From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Fri, 8 Feb 2019 21:15:34 -0700
Message-ID: <42eea00c-81fb-2e28-d884-03be5bb229c8@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-6-axboe@kernel.dk>
 <CAG48ez2Qc9XOApLRb5fnNiOjxaURO8vjZ-EHX7g25gje3weZ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez2Qc9XOApLRb5fnNiOjxaURO8vjZ-EHX7g25gje3weZ6A@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 2/8/19 3:12 PM, Jann Horn wrote:
> On Fri, Feb 8, 2019 at 6:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>> The submission queue (SQ) and completion queue (CQ) rings are shared
>> between the application and the kernel. This eliminates the need to
>> copy data back and forth to submit and complete IO.
>>
>> IO submissions use the io_uring_sqe data structure, and completions
>> are generated in the form of io_uring_cqe data structures. The SQ
>> ring is an index into the io_uring_sqe array, which makes it possible
>> to submit a batch of IOs without them being contiguous in the ring.
>> The CQ ring is always contiguous, as completion events are inherently
>> unordered, and hence any io_uring_cqe entry can point back to an
>> arbitrary submission.
>>
>> Two new system calls are added for this:
>>
>> io_uring_setup(entries, params)
>>         Sets up an io_uring instance for doing async IO. On success,
>>         returns a file descriptor that the application can mmap to
>>         gain access to the SQ ring, CQ ring, and io_uring_sqes.
>>
>> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
>>         Initiates IO against the rings mapped to this fd, or waits for
>>         them to complete, or both. The behavior is controlled by the
>>         parameters passed in. If 'to_submit' is non-zero, then we'll
>>         try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>>         kernel will wait for 'min_complete' events, if they aren't
>>         already available. It's valid to set IORING_ENTER_GETEVENTS
>>         and 'min_complete' == 0 at the same time, this allows the
>>         kernel to return already completed events without waiting
>>         for them. This is useful only for polling, as for IRQ
>>         driven IO, the application can just check the CQ ring
>>         without entering the kernel.
>>
>> With this setup, it's possible to do async IO with a single system
>> call. Future developments will enable polled IO with this interface,
>> and polled submission as well. The latter will enable an application
>> to do IO without doing ANY system calls at all.
>>
>> For IRQ driven IO, an application only needs to enter the kernel for
>> completions if it wants to wait for them to occur.
>>
>> Each io_uring is backed by a workqueue, to support buffered async IO
>> as well. We will only punt to an async context if the command would
>> need to wait for IO on the device side. Any data that can be accessed
>> directly in the page cache is done inline. This avoids the slowness
>> issue of usual threadpools, since cached data is accessed as quickly
>> as a sync interface.
> [...]
>> +static void io_commit_cqring(struct io_ring_ctx *ctx)
>> +{
>> +       struct io_cq_ring *ring = ctx->cq_ring;
>> +
>> +       if (ctx->cached_cq_tail != ring->r.tail) {
> 
> I know that this is very unlikely to actually matter, but both because
> I don't feel fuzzy about relying on compiler internals regarding when
> the compiler might decide to generate dangerous double-reads (if
> switch() can blow up, why shouldn't the compiler be able to make if()
> blow up if it wants to, too?), and because I would like it to be as
> clear as possible to the reader which memory is shared with userspace,
> can we please have READ_ONCE() on *every* shared memory read, not just
> the ones in places that look like they might plausibly blow up
> otherwise? Sorry, shared memory is a bit of a pet peeve of mine.

Sure, I've done that now.

>> +               /* order cqe stores with ring update */
>> +               smp_wmb();
>> +               WRITE_ONCE(ring->r.tail, ctx->cached_cq_tail);
>> +               /* write side barrier of tail update, app has read side */
>> +               smp_wmb();
>> +
>> +               if (wq_has_sleeper(&ctx->cq_wait)) {
>> +                       wake_up_interruptible(&ctx->cq_wait);
>> +                       kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
>> +               }
>> +       }
>> +}
> [...]
>> +static void io_cqring_fill_event(struct io_ring_ctx *ctx, u64 ki_user_data,
>> +                                long res, unsigned ev_flags)
>> +{
>> +       struct io_uring_cqe *cqe;
>> +
>> +       /*
>> +        * If we can't get a cq entry, userspace overflowed the
>> +        * submission (by quite a lot). Increment the overflow count in
>> +        * the ring.
>> +        */
>> +       cqe = io_get_cqring(ctx);
>> +       if (cqe) {
>> +               cqe->user_data = ki_user_data;
>> +               cqe->res = res;
>> +               cqe->flags = ev_flags;
> 
> Please use WRITE_ONCE() for stores like these.

Done

>> +       } else
>> +               ctx->cq_ring->overflow++;
>> +}
> [...]
>> +static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>> +                          const struct sqe_submit *s, bool force_nonblock)
>> +{
>> +       ssize_t ret;
>> +       int opcode;
>> +
>> +       if (unlikely(s->index >= ctx->sq_entries))
>> +               return -EINVAL;
>> +       req->user_data = READ_ONCE(s->sqe->user_data);
>> +
>> +       opcode = READ_ONCE(s->sqe->opcode);
> 
> There might be a sneaky bug here. Consider the following scenario:
> 
> 1. request gets submitted from io_sq_wq_submit_work() with opcode
> IORING_OP_READV, io_read() is invoked
> 2. io_read() looks up the file, taking a reference to it
> 3. call_read_iter() returns -EAGAIN
> 4. io_read() returns -EAGAIN without dropping its reference on the
> file (because it expects that it'll be called again)
> 5. __io_submit_sqe() returns -EAGAIN
> 6. io_sq_wq_submit_work() loops back and retries __io_submit_sqe()
> 7. __io_submit_sqe() reads opcode again, this time it's IORING_OP_NOP
> 8. io_nop() gets called
> 9. io_nop() uses io_free_req() to delete the request without dropping
> its reference on the file
> 
> So that's a file reference leak, I think?

Hmm yes, that could happen with a malicious app.

For non-file using opcodes, I think we should just error the sqe if we
have req->rw.ki_filp set. That shouldn't happen unless the app is doing
something funky. I'll fix this.

>> +       switch (opcode) {
>> +       case IORING_OP_NOP:
>> +               ret = io_nop(req, req->user_data);
>> +               break;
>> +       case IORING_OP_READV:
>> +               ret = io_read(req, s, force_nonblock);
>> +               break;
>> +       case IORING_OP_WRITEV:
>> +               ret = io_write(req, s, force_nonblock);
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +
>> +       return ret;
>> +}
> [...]
>> +static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s)
>> +{
>> +       struct io_kiocb *req;
>> +       ssize_t ret;
>> +
>> +       /* enforce forwards compatibility on users */
>> +       if (unlikely(s->sqe->flags))
>> +               return -EINVAL;
>> +
>> +       req = io_get_req(ctx);
>> +       if (unlikely(!req))
>> +               return -EAGAIN;
>> +
>> +       req->rw.ki_filp = NULL;
>> +
>> +       ret = __io_submit_sqe(ctx, req, s, true);
>> +       if (ret == -EAGAIN) {
>> +               memcpy(&req->submit, s, sizeof(*s));
>> +               INIT_WORK(&req->work, io_sq_wq_submit_work);
>> +               queue_work(ctx->sqo_wq, &req->work);
>> +               ret = 0;
>> +       }
>> +       if (ret)
>> +               io_free_req(req);
>> +
>> +       return ret;
>> +}
>> +
>> +static void io_commit_sqring(struct io_ring_ctx *ctx)
>> +{
>> +       struct io_sq_ring *ring = ctx->sq_ring;
>> +
>> +       if (ctx->cached_sq_head != ring->r.head) {
>> +               WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
>> +               /* write side barrier of head update, app has read side */
>> +               smp_wmb();
> 
> Can you elaborate on what this memory barrier is doing? Don't you need
> some sort of memory barrier *before* the WRITE_ONCE(), to ensure that
> nobody sees the updated head before you're done reading the submission
> queue entry? Or is that barrier elsewhere?

The matching read barrier is in the application, it must do that before
reading ->head for the SQ ring.

For the other barrier, since the ring->r.head now has a READ_ONCE(),
that should be all we need to ensure that loads are done.

>> +       }
>> +}
>> +
>> +/*
>> + * Undo last io_get_sqring()
>> + */
>> +static void io_drop_sqring(struct io_ring_ctx *ctx)
>> +{
>> +       ctx->cached_sq_head--;
>> +}
> [...]
>> +static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>> +{
>> +       if (capable(CAP_IPC_LOCK))
>> +               return;
> 
> Hrm... what happens if root creates a uring, drops CAP_IPC_LOCK, and
> then destroys the uring? Will the pages get subtracted from
> ->locked_vm even though they were never added to it, causing a
> wraparound?
> 
> You might want to make sure that ctx->user is set if and only if the
> creator didn't have CAP_IPC_LOCK, and then just do a `user == NULL`
> check instead of a `capable(...)` check. Or you could do what BPF is
> doing (AFAICS) and not treat root specially - root can just bump the
> rlimit if necessary.

That won't work since we use ->user for other items later on. But I can
store whether we need it or not, I'll do that.

> 
>> +       atomic_long_sub(nr_pages, &user->locked_vm);
>> +}
>> +
>> +static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>> +{
>> +       unsigned long page_limit, cur_pages, new_pages;
>> +
>> +       if (capable(CAP_IPC_LOCK))
>> +               return 0;
>> +
>> +       /* Don't allow more pages than we can safely lock */
>> +       page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> +
>> +       do {
>> +               cur_pages = atomic_long_read(&user->locked_vm);
>> +               new_pages = cur_pages + nr_pages;
>> +               if (new_pages > page_limit)
>> +                       return -ENOMEM;
>> +       } while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>> +                                       new_pages) != cur_pages);
>> +
>> +       return 0;
>> +}
> [...]
>> +config IO_URING
>> +       bool "Enable IO uring support" if EXPERT
>> +       select ANON_INODES
>> +       default y
>> +       help
>> +         This option enables support for the io_uring interface, enabling
>> +         applications to submit and completion IO through submission and
>> +         completion rings that are shared between the kernel and application.
> 
> Nit: I can't parse this part: "enabling applications to submit and
> completion IO"

completion -> complete

Fixed it up.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
