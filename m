From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Tue, 12 Feb 2019 16:00:45 -0700
Message-ID: <beb052ba-2c4a-0201-d673-c7b8eef294dd@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-6-axboe@kernel.dk>
 <CAG48ez2Qc9XOApLRb5fnNiOjxaURO8vjZ-EHX7g25gje3weZ6A@mail.gmail.com>
 <42eea00c-81fb-2e28-d884-03be5bb229c8@kernel.dk>
 <CAG48ez2c=7f34AX_FFKTFFnNqJojULs9GwdqaMv=WO2tYLZE3g@mail.gmail.com>
 <1ca9f039-c6f0-cae7-8484-7db0a4e4e213@kernel.dk>
 <f20b8e79-d10f-6316-561f-3c77cab71ee0@kernel.dk>
 <CAG48ez0rJU8bx4EFJwzXOpUX1C2J86pDFHtwEdvKf2K2tsWuig@mail.gmail.com>
 <041f1c67-b62e-a593-fdc0-b44e35a4da4e@kernel.dk>
 <7149d509-25a1-eb3b-b4c6-6bb2d7a87465@kernel.dk>
 <CAG48ez09zTXuxEJE4KKfv-9yeYPGbFm_b9YnYK70csTQ1UXiuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez09zTXuxEJE4KKfv-9yeYPGbFm_b9YnYK70csTQ1UXiuA@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 2/12/19 3:57 PM, Jann Horn wrote:
> On Tue, Feb 12, 2019 at 11:52 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/12/19 3:45 PM, Jens Axboe wrote:
>>> On 2/12/19 3:40 PM, Jann Horn wrote:
>>>> On Tue, Feb 12, 2019 at 11:06 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 2/12/19 3:03 PM, Jens Axboe wrote:
>>>>>> On 2/12/19 2:42 PM, Jann Horn wrote:
>>>>>>> On Sat, Feb 9, 2019 at 5:15 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 2/8/19 3:12 PM, Jann Horn wrote:
>>>>>>>>> On Fri, Feb 8, 2019 at 6:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>> The submission queue (SQ) and completion queue (CQ) rings are shared
>>>>>>>>>> between the application and the kernel. This eliminates the need to
>>>>>>>>>> copy data back and forth to submit and complete IO.
>>>>>>>>>>
>>>>>>>>>> IO submissions use the io_uring_sqe data structure, and completions
>>>>>>>>>> are generated in the form of io_uring_cqe data structures. The SQ
>>>>>>>>>> ring is an index into the io_uring_sqe array, which makes it possible
>>>>>>>>>> to submit a batch of IOs without them being contiguous in the ring.
>>>>>>>>>> The CQ ring is always contiguous, as completion events are inherently
>>>>>>>>>> unordered, and hence any io_uring_cqe entry can point back to an
>>>>>>>>>> arbitrary submission.
>>>>>>>>>>
>>>>>>>>>> Two new system calls are added for this:
>>>>>>>>>>
>>>>>>>>>> io_uring_setup(entries, params)
>>>>>>>>>>         Sets up an io_uring instance for doing async IO. On success,
>>>>>>>>>>         returns a file descriptor that the application can mmap to
>>>>>>>>>>         gain access to the SQ ring, CQ ring, and io_uring_sqes.
>>>>>>>>>>
>>>>>>>>>> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
>>>>>>>>>>         Initiates IO against the rings mapped to this fd, or waits for
>>>>>>>>>>         them to complete, or both. The behavior is controlled by the
>>>>>>>>>>         parameters passed in. If 'to_submit' is non-zero, then we'll
>>>>>>>>>>         try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>>>>>>>>>>         kernel will wait for 'min_complete' events, if they aren't
>>>>>>>>>>         already available. It's valid to set IORING_ENTER_GETEVENTS
>>>>>>>>>>         and 'min_complete' == 0 at the same time, this allows the
>>>>>>>>>>         kernel to return already completed events without waiting
>>>>>>>>>>         for them. This is useful only for polling, as for IRQ
>>>>>>>>>>         driven IO, the application can just check the CQ ring
>>>>>>>>>>         without entering the kernel.
>>>>>>>>>>
>>>>>>>>>> With this setup, it's possible to do async IO with a single system
>>>>>>>>>> call. Future developments will enable polled IO with this interface,
>>>>>>>>>> and polled submission as well. The latter will enable an application
>>>>>>>>>> to do IO without doing ANY system calls at all.
>>>>>>>>>>
>>>>>>>>>> For IRQ driven IO, an application only needs to enter the kernel for
>>>>>>>>>> completions if it wants to wait for them to occur.
>>>>>>>>>>
>>>>>>>>>> Each io_uring is backed by a workqueue, to support buffered async IO
>>>>>>>>>> as well. We will only punt to an async context if the command would
>>>>>>>>>> need to wait for IO on the device side. Any data that can be accessed
>>>>>>>>>> directly in the page cache is done inline. This avoids the slowness
>>>>>>>>>> issue of usual threadpools, since cached data is accessed as quickly
>>>>>>>>>> as a sync interface.
>>>>>>> [...]
>>>>>>>>>> +static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s)
>>>>>>>>>> +{
>>>>>>>>>> +       struct io_kiocb *req;
>>>>>>>>>> +       ssize_t ret;
>>>>>>>>>> +
>>>>>>>>>> +       /* enforce forwards compatibility on users */
>>>>>>>>>> +       if (unlikely(s->sqe->flags))
>>>>>>>>>> +               return -EINVAL;
>>>>>>>>>> +
>>>>>>>>>> +       req = io_get_req(ctx);
>>>>>>>>>> +       if (unlikely(!req))
>>>>>>>>>> +               return -EAGAIN;
>>>>>>>>>> +
>>>>>>>>>> +       req->rw.ki_filp = NULL;
>>>>>>>>>> +
>>>>>>>>>> +       ret = __io_submit_sqe(ctx, req, s, true);
>>>>>>>>>> +       if (ret == -EAGAIN) {
>>>>>>>>>> +               memcpy(&req->submit, s, sizeof(*s));
>>>>>>>>>> +               INIT_WORK(&req->work, io_sq_wq_submit_work);
>>>>>>>>>> +               queue_work(ctx->sqo_wq, &req->work);
>>>>>>>>>> +               ret = 0;
>>>>>>>>>> +       }
>>>>>>>>>> +       if (ret)
>>>>>>>>>> +               io_free_req(req);
>>>>>>>>>> +
>>>>>>>>>> +       return ret;
>>>>>>>>>> +}
>>>>>>>>>> +
>>>>>>>>>> +static void io_commit_sqring(struct io_ring_ctx *ctx)
>>>>>>>>>> +{
>>>>>>>>>> +       struct io_sq_ring *ring = ctx->sq_ring;
>>>>>>>>>> +
>>>>>>>>>> +       if (ctx->cached_sq_head != ring->r.head) {
>>>>>>>>>> +               WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
>>>>>>>>>> +               /* write side barrier of head update, app has read side */
>>>>>>>>>> +               smp_wmb();
>>>>>>>>>
>>>>>>>>> Can you elaborate on what this memory barrier is doing? Don't you need
>>>>>>>>> some sort of memory barrier *before* the WRITE_ONCE(), to ensure that
>>>>>>>>> nobody sees the updated head before you're done reading the submission
>>>>>>>>> queue entry? Or is that barrier elsewhere?
>>>>>>>>
>>>>>>>> The matching read barrier is in the application, it must do that before
>>>>>>>> reading ->head for the SQ ring.
>>>>>>>>
>>>>>>>> For the other barrier, since the ring->r.head now has a READ_ONCE(),
>>>>>>>> that should be all we need to ensure that loads are done.
>>>>>>>
>>>>>>> READ_ONCE() / WRITE_ONCE are not hardware memory barriers that enforce
>>>>>>> ordering with regard to concurrent execution on other cores. They are
>>>>>>> only compiler barriers, influencing the order in which the compiler
>>>>>>> emits things. (Well, unless you're on alpha, where READ_ONCE() implies
>>>>>>> a memory barrier that prevents reordering of dependent reads.)
>>>>>>>
>>>>>>> As far as I can tell, between the READ_ONCE(ring->array[...]) in
>>>>>>> io_get_sqring() and the WRITE_ONCE() in io_commit_sqring(), you have
>>>>>>> no *hardware* memory barrier that prevents reordering against
>>>>>>> concurrently running userspace code. As far as I can tell, the
>>>>>>> following could happen:
>>>>>>>
>>>>>>>  - The kernel reads from ring->array in io_get_sqring(), then updates
>>>>>>> the head in io_commit_sqring(). The CPU reorders the memory accesses
>>>>>>> such that the write to the head becomes visible before the read from
>>>>>>> ring->array has completed.
>>>>>>>  - Userspace observes the write to the head and reuses the array slots
>>>>>>> the kernel has freed with the write, clobbering ring->array before the
>>>>>>> kernel reads from ring->array.
>>>>>>
>>>>>> I'd say this is highly theoretical for the normal use case, as we
>>>>>> will have submitted IO in between. Hence the load must have been done.
>>>>
>>>> Sorry, I'm confused. Who is "we", and which load are you referring to?
>>>> io_sq_thread() goes directly from io_get_sqring() to
>>>> io_commit_sqring(), with only a conditional io_sqe_needs_user() in
>>>> between, if the `i == ARRAY_SIZE(sqes)` check triggers. There is no
>>>> "submitting IO" in the middle.
>>>
>>> You are right, the patch I sent IS needed for the sq thread case! It's
>>> only true for the "normal" case that we don't need the smp_mb() before
>>> writing the sq ring head, as sqes are fully consumed at that point.
> 
> Hmm... does that actually matter? As long as you don't have an
> explicit barrier for this, the CPU could still reorder things, right?
> Pull the store in front of everything else?

If the IO has been submitted, by definition the loads have completed.
At that point it should be fine to commit the ring head that the
application sees.

>>> I'll fold the fix into that patch.
>> A better fix is to let the sq thread have the same behavior as the
>> application driven path, simply committing the sq ring once we've
>> consumed the sqes instead. That's just moving the io_sqring_commit()
>> below io_submit_sqes().
> 
> Hmm. How does that help?

Because then it'll have submitted the IO, and hence loads from the sqes
in question must have been done.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
