From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/18] io_uring: support for IO polling
Date: Tue, 29 Jan 2019 13:56:30 -0700
Message-ID: <7337bdfc-39b5-2383-4b58-a9efc3dea1cb@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-8-axboe@kernel.dk>
 <CAG48ez270gG64wmHtG8pNUoBWiSwYiGxsyuSCQ_4wn7v_n_h_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez270gG64wmHtG8pNUoBWiSwYiGxsyuSCQ_4wn7v_n_h_w@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 1:47 PM, Jann Horn wrote:
> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>> Add support for a polled io_uring context. When a read or write is
>> submitted to a polled context, the application must poll for completions
>> on the CQ ring through io_uring_enter(2). Polled IO may not generate
>> IRQ completions, hence they need to be actively found by the application
>> itself.
>>
>> To use polling, io_uring_setup() must be used with the
>> IORING_SETUP_IOPOLL flag being set. It is illegal to mix and match
>> polled and non-polled IO on an io_uring.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [...]
>> @@ -102,6 +102,8 @@ struct io_ring_ctx {
>>
>>         struct {
>>                 spinlock_t              completion_lock;
>> +               bool                    poll_multi_file;
>> +               struct list_head        poll_list;
> 
> Please add a comment explaining what protects poll_list against
> concurrent modification, and ideally also put lockdep asserts in the
> functions that access the list to allow the kernel to sanity-check the
> locking at runtime.

Not sure that's needed, and it would be a bit difficult with the SQPOLL
thread and non-thread being different cases.

But comments I can definitely add.

> As far as I understand:
> Elements are added by io_iopoll_req_issued(). io_iopoll_req_issued()
> can't race with itself because, depending on IORING_SETUP_SQPOLL,
> either you have to come through sys_io_uring_enter() (which takes the
> uring_lock), or you have to come from the single-threaded
> io_sq_thread().
> io_do_iopoll() iterates over the list and removes completed items.
> io_do_iopoll() is called through io_iopoll_getevents(), which can be
> invoked in two ways during normal operation:
>  - sys_io_uring_enter -> __io_uring_enter -> io_iopoll_check
> ->io_iopoll_getevents; this is only protected by the uring_lock
>  - io_sq_thread -> io_iopoll_check ->io_iopoll_getevents; this doesn't
> hold any locks
> Additionally, the following exit paths:
>  - io_sq_thread -> io_iopoll_reap_events -> io_iopoll_getevents
>  - io_uring_release -> io_ring_ctx_wait_and_kill ->
> io_iopoll_reap_events -> io_iopoll_getevents
>  - io_uring_release -> io_ring_ctx_wait_and_kill -> io_ring_ctx_free
> -> io_iopoll_reap_events -> io_iopoll_getevents

Yes, your understanding is correct. But of important note, those two
cases don't co-exist. If you are using SQPOLL, then only the thread
itself is the one that modifies the list. The only valid call of
io_uring_enter(2) is to wakeup the thread, the task itself will NOT be
doing any issues. If you are NOT using SQPOLL, then any access is inside
the ->uring_lock.

For the reap cases, we don't enter those at shutdown for SQPOLL, we
expect the thread to do it. Hence we wait for the thread to exit before
we do our final release.

> So as far as I can tell, you can have various races around access to
> the poll_list.

How did you make that leap?

>> +static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
>> +{
>> +       if (*nr) {
>> +               kmem_cache_free_bulk(req_cachep, *nr, reqs);
>> +               io_ring_drop_ctx_refs(ctx, *nr);
>> +               *nr = 0;
>> +       }
>> +}
> [...]
>> +static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>> +                              struct list_head *done)
>> +{
>> +       void *reqs[IO_IOPOLL_BATCH];
>> +       struct io_kiocb *req;
>> +       int to_free = 0;
>> +
>> +       while (!list_empty(done)) {
>> +               req = list_first_entry(done, struct io_kiocb, list);
>> +               list_del(&req->list);
>> +
>> +               io_cqring_fill_event(ctx, req->user_data, req->error, 0);
>> +
>> +               reqs[to_free++] = req;
>> +               (*nr_events)++;
>> +
>> +               fput(req->rw.ki_filp);
>> +               if (to_free == ARRAY_SIZE(reqs))
>> +                       io_free_req_many(ctx, reqs, &to_free);
>> +       }
>> +       io_commit_cqring(ctx);
>> +
>> +       if (to_free)
>> +               io_free_req_many(ctx, reqs, &to_free);
> 
> Nit: You check here whether to_free==0, and then io_free_req_many()
> does that again. You can delete one of those checks; I'd probably
> delete this one.

Agree, I'll kill it.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
