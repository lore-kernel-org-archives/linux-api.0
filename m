From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Tue, 12 Feb 2019 17:24:13 -0700
Message-ID: <ad4c78cb-071f-dd6c-bc97-5e75cac05a0b@kernel.dk>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <CAG48ez2Qc9XOApLRb5fnNiOjxaURO8vjZ-EHX7g25gje3weZ6A@mail.gmail.com>
 <42eea00c-81fb-2e28-d884-03be5bb229c8@kernel.dk>
 <CAG48ez2c=7f34AX_FFKTFFnNqJojULs9GwdqaMv=WO2tYLZE3g@mail.gmail.com>
 <1ca9f039-c6f0-cae7-8484-7db0a4e4e213@kernel.dk>
 <f20b8e79-d10f-6316-561f-3c77cab71ee0@kernel.dk>
 <CAG48ez0rJU8bx4EFJwzXOpUX1C2J86pDFHtwEdvKf2K2tsWuig@mail.gmail.com>
 <041f1c67-b62e-a593-fdc0-b44e35a4da4e@kernel.dk>
 <7149d509-25a1-eb3b-b4c6-6bb2d7a87465@kernel.dk>
 <CAG48ez09zTXuxEJE4KKfv-9yeYPGbFm_b9YnYK70csTQ1UXiuA@mail.gmail.com>
 <beb052ba-2c4a-0201-d673-c7b8eef294dd@kernel.dk>
 <CAG48ez22G1orwZ43tZ6VK3rngQitar0qH9zJXdTv8kX2e2HqOQ@mail.gmail.com>
 <0641e74d-0277-9cdb-2b13-63ee60f9196d@kernel.dk>
 <CAG48ez3PESTFsySiZ1T2w-+4xo6mqkHRBv+Hgs2BKy-4w+7yug@mail.gmail.com>
 <e70a7451-2fb4-5800-500d-6ae46fbfe5f4@kernel.dk>
 <7452c409-f232-2017-9101-0cd6c6946d64@kernel.dk>
 <08141EFF-E805-405B-9970-ABFE9A1C3F58@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <08141EFF-E805-405B-9970-ABFE9A1C3F58@amacapital.net>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 2/12/19 5:07 PM, Andy Lutomirski wrote:
> 
> 
>> On Feb 12, 2019, at 3:53 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> On 2/12/19 4:46 PM, Jens Axboe wrote:
>>>> On 2/12/19 4:28 PM, Jann Horn wrote:
>>>>> On Wed, Feb 13, 2019 at 12:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>>> On 2/12/19 4:11 PM, Jann Horn wrote:
>>>>>>> On Wed, Feb 13, 2019 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>>> On 2/12/19 3:57 PM, Jann Horn wrote:
>>>>>>>>> On Tue, Feb 12, 2019 at 11:52 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>
>>>>>>>>>> On 2/12/19 3:45 PM, Jens Axboe wrote:
>>>>>>>>>>> On 2/12/19 3:40 PM, Jann Horn wrote:
>>>>>>>>>>>> On Tue, Feb 12, 2019 at 11:06 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> On 2/12/19 3:03 PM, Jens Axboe wrote:
>>>>>>>>>>>>>> On 2/12/19 2:42 PM, Jann Horn wrote:
>>>>>>>>>>>>>>> On Sat, Feb 9, 2019 at 5:15 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>>>>>>>> On 2/8/19 3:12 PM, Jann Horn wrote:
>>>>>>>>>>>>>>>>> On Fri, Feb 8, 2019 at 6:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>>>>>>>>> The submission queue (SQ) and completion queue (CQ) rings are shared
>>>>>>>>>>>>>>>>> between the application and the kernel. This eliminates the need to
>>>>>>>>>>>>>>>>> copy data back and forth to submit and complete IO.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> IO submissions use the io_uring_sqe data structure, and completions
>>>>>>>>>>>>>>>>> are generated in the form of io_uring_cqe data structures. The SQ
>>>>>>>>>>>>>>>>> ring is an index into the io_uring_sqe array, which makes it possible
>>>>>>>>>>>>>>>>> to submit a batch of IOs without them being contiguous in the ring.
>>>>>>>>>>>>>>>>> The CQ ring is always contiguous, as completion events are inherently
>>>>>>>>>>>>>>>>> unordered, and hence any io_uring_cqe entry can point back to an
>>>>>>>>>>>>>>>>> arbitrary submission.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Two new system calls are added for this:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> io_uring_setup(entries, params)
>>>>>>>>>>>>>>>>>        Sets up an io_uring instance for doing async IO. On success,
>>>>>>>>>>>>>>>>>        returns a file descriptor that the application can mmap to
>>>>>>>>>>>>>>>>>        gain access to the SQ ring, CQ ring, and io_uring_sqes.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
>>>>>>>>>>>>>>>>>        Initiates IO against the rings mapped to this fd, or waits for
>>>>>>>>>>>>>>>>>        them to complete, or both. The behavior is controlled by the
>>>>>>>>>>>>>>>>>        parameters passed in. If 'to_submit' is non-zero, then we'll
>>>>>>>>>>>>>>>>>        try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>>>>>>>>>>>>>>>>>        kernel will wait for 'min_complete' events, if they aren't
>>>>>>>>>>>>>>>>>        already available. It's valid to set IORING_ENTER_GETEVENTS
>>>>>>>>>>>>>>>>>        and 'min_complete' == 0 at the same time, this allows the
>>>>>>>>>>>>>>>>>        kernel to return already completed events without waiting
>>>>>>>>>>>>>>>>>        for them. This is useful only for polling, as for IRQ
>>>>>>>>>>>>>>>>>        driven IO, the application can just check the CQ ring
>>>>>>>>>>>>>>>>>        without entering the kernel.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> With this setup, it's possible to do async IO with a single system
>>>>>>>>>>>>>>>>> call. Future developments will enable polled IO with this interface,
>>>>>>>>>>>>>>>>> and polled submission as well. The latter will enable an application
>>>>>>>>>>>>>>>>> to do IO without doing ANY system calls at all.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> For IRQ driven IO, an application only needs to enter the kernel for
>>>>>>>>>>>>>>>>> completions if it wants to wait for them to occur.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Each io_uring is backed by a workqueue, to support buffered async IO
>>>>>>>>>>>>>>>>> as well. We will only punt to an async context if the command would
>>>>>>>>>>>>>>>>> need to wait for IO on the device side. Any data that can be accessed
>>>>>>>>>>>>>>>>> directly in the page cache is done inline. This avoids the slowness
>>>>>>>>>>>>>>>>> issue of usual threadpools, since cached data is accessed as quickly
>>>>>>>>>>>>>>>>> as a sync interface.
>>>>>>>>>>>>>> [...]
>>>>>>>>>>>>>>>>> +static int io_submit_sqe(struct io_ring_ctx *ctx, const struct sqe_submit *s)
>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>> +       struct io_kiocb *req;
>>>>>>>>>>>>>>>>> +       ssize_t ret;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       /* enforce forwards compatibility on users */
>>>>>>>>>>>>>>>>> +       if (unlikely(s->sqe->flags))
>>>>>>>>>>>>>>>>> +               return -EINVAL;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       req = io_get_req(ctx);
>>>>>>>>>>>>>>>>> +       if (unlikely(!req))
>>>>>>>>>>>>>>>>> +               return -EAGAIN;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       req->rw.ki_filp = NULL;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       ret = __io_submit_sqe(ctx, req, s, true);
>>>>>>>>>>>>>>>>> +       if (ret == -EAGAIN) {
>>>>>>>>>>>>>>>>> +               memcpy(&req->submit, s, sizeof(*s));
>>>>>>>>>>>>>>>>> +               INIT_WORK(&req->work, io_sq_wq_submit_work);
>>>>>>>>>>>>>>>>> +               queue_work(ctx->sqo_wq, &req->work);
>>>>>>>>>>>>>>>>> +               ret = 0;
>>>>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>>>>> +       if (ret)
>>>>>>>>>>>>>>>>> +               io_free_req(req);
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       return ret;
>>>>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +static void io_commit_sqring(struct io_ring_ctx *ctx)
>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>> +       struct io_sq_ring *ring = ctx->sq_ring;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +       if (ctx->cached_sq_head != ring->r.head) {
>>>>>>>>>>>>>>>>> +               WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
>>>>>>>>>>>>>>>>> +               /* write side barrier of head update, app has read side */
>>>>>>>>>>>>>>>>> +               smp_wmb();
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Can you elaborate on what this memory barrier is doing? Don't you need
>>>>>>>>>>>>>>>> some sort of memory barrier *before* the WRITE_ONCE(), to ensure that
>>>>>>>>>>>>>>>> nobody sees the updated head before you're done reading the submission
>>>>>>>>>>>>>>>> queue entry? Or is that barrier elsewhere?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The matching read barrier is in the application, it must do that before
>>>>>>>>>>>>>>> reading ->head for the SQ ring.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> For the other barrier, since the ring->r.head now has a READ_ONCE(),
>>>>>>>>>>>>>>> that should be all we need to ensure that loads are done.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> READ_ONCE() / WRITE_ONCE are not hardware memory barriers that enforce
>>>>>>>>>>>>>> ordering with regard to concurrent execution on other cores. They are
>>>>>>>>>>>>>> only compiler barriers, influencing the order in which the compiler
>>>>>>>>>>>>>> emits things. (Well, unless you're on alpha, where READ_ONCE() implies
>>>>>>>>>>>>>> a memory barrier that prevents reordering of dependent reads.)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> As far as I can tell, between the READ_ONCE(ring->array[...]) in
>>>>>>>>>>>>>> io_get_sqring() and the WRITE_ONCE() in io_commit_sqring(), you have
>>>>>>>>>>>>>> no *hardware* memory barrier that prevents reordering against
>>>>>>>>>>>>>> concurrently running userspace code. As far as I can tell, the
>>>>>>>>>>>>>> following could happen:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> - The kernel reads from ring->array in io_get_sqring(), then updates
>>>>>>>>>>>>>> the head in io_commit_sqring(). The CPU reorders the memory accesses
>>>>>>>>>>>>>> such that the write to the head becomes visible before the read from
>>>>>>>>>>>>>> ring->array has completed.
>>>>>>>>>>>>>> - Userspace observes the write to the head and reuses the array slots
>>>>>>>>>>>>>> the kernel has freed with the write, clobbering ring->array before the
>>>>>>>>>>>>>> kernel reads from ring->array.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'd say this is highly theoretical for the normal use case, as we
>>>>>>>>>>>>> will have submitted IO in between. Hence the load must have been done.
>>>>>>>>>>>
>>>>>>>>>>> Sorry, I'm confused. Who is "we", and which load are you referring to?
>>>>>>>>>>> io_sq_thread() goes directly from io_get_sqring() to
>>>>>>>>>>> io_commit_sqring(), with only a conditional io_sqe_needs_user() in
>>>>>>>>>>> between, if the `i == ARRAY_SIZE(sqes)` check triggers. There is no
>>>>>>>>>>> "submitting IO" in the middle.
>>>>>>>>>>
>>>>>>>>>> You are right, the patch I sent IS needed for the sq thread case! It's
>>>>>>>>>> only true for the "normal" case that we don't need the smp_mb() before
>>>>>>>>>> writing the sq ring head, as sqes are fully consumed at that point.
>>>>>>>>
>>>>>>>> Hmm... does that actually matter? As long as you don't have an
>>>>>>>> explicit barrier for this, the CPU could still reorder things, right?
>>>>>>>> Pull the store in front of everything else?
>>>>>>>
>>>>>>> If the IO has been submitted, by definition the loads have completed.
>>>>>>> At that point it should be fine to commit the ring head that the
>>>>>>> application sees.
>>>>>>
>>>>>> What exactly do you mean by "the IO has been submitted"? Are you
>>>>>> talking about interaction with hardware, or about the end of the
>>>>>> syscall, or something else?
>>>>>
>>>>> I mean that the loads from the sqe, which the IO is made of, have been
>>>>> done. That's what we care about here, right? The sqe has either been
>>>>> turned into an io request and has been submitted, or it has been copied.
>>>>
>>>> But they might not actually be done. AFAIU the CPU is allowed to do
>>>> the WRITE_ONCE of the head before doing any of the reads from the sqe
>>>> - loads and stores you do, as observed by a concurrently executing
>>>> thread, can happen in an order independent of the order in which you
>>>> write them in your code unless you use memory barriers. So the CPU
>>>> might decide to first write the new head, then do the read for
>>>> io_get_sqring(), and then do the __io_submit_sqe(), potentially
>>>> reading e.g. a IORING_OP_NOP opcode that has been written by
>>>> concurrently executing userspace after userspace has observed the
>>>> bumped head.
>>>
>>> For that to be possible, we'd need NO ordering in between the IO
>>> submission and when we write the sq ring head. A single spin lock
>>> should do it, right?
>>>
>>> It's not that I'm set against adding an smp_mb() to io_commit_sqring(),
>>> but I think we're going off the deep end a little bit here on
>>> theoretical vs what can practically happen.
>>>
>>> For the regular IO cases, we will have done at least one lock/unlock
>>> cycle. This is true for nops as well, and poll. The only case that could
>>> potentially NOT have one is the fsync, for the case where we punt and
>>> don't add it to existing work, we don't have any locking in between.
>>>
>>> I'll add the smp_mb() for peace of mind.
>>
>> For reference, folded in:
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8d68569f9ba9..755ff8f411da 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1690,6 +1690,13 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
>>    struct io_sq_ring *ring = ctx->sq_ring;
>>
>>    if (ctx->cached_sq_head != READ_ONCE(ring->r.head)) {
>> +        /*
>> +         * Ensure any loads from the SQEs are done at this point,
>> +         * since once we write the new head, the application could
>> +         * write new data to them.
>> +         */
>> +        smp_mb();
>> +
>>        WRITE_ONCE(ring->r.head, ctx->cached_sq_head);
>>        /*
>>         * write side barrier of head update, app has read side. See
>>
>>
> 
> I haven’t followed the full set of machinations here, but would
> smp_store_release() be sufficient?  It is a *lot* faster on some
> architectures.

Thanks for the hint, yes that looks more appropriate.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
