From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO
 buffers
Date: Tue, 29 Jan 2019 16:51:13 -0700
Message-ID: <bfc062e8-7ff3-5003-1aa6-fb103aff06a0@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-13-axboe@kernel.dk>
 <CAG48ez2VkeSEZA+9H4UAcg86uC77gU=UkTG8L1V58TuR9pDEqg@mail.gmail.com>
 <dd366179-c003-752f-743d-2bea4f6b796c@kernel.dk>
 <CAG48ez3x5x+P=8L1p-bHvcUnypeT1TizkXq2+Q0bCP0GdE-bog@mail.gmail.com>
 <87b25ce2-a5bc-3e81-ddba-5c932c71b40f@kernel.dk>
 <CAG48ez1m22z0Pqi0cT=UZdsA14SCM5579T1d40cZdyD6KqBw_g@mail.gmail.com>
 <379a631f-e55b-cc31-f84a-ace73fd66ea1@kernel.dk>
 <CAG48ez3Jtq3ka+cSVxQWjMLQU=YRqV2dJuq5Kp2Nx_YLz3FsNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAG48ez3Jtq3ka+cSVxQWjMLQU=YRqV2dJuq5Kp2Nx_YLz3FsNQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, Avi Kivity <avi@scylladb.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 4:42 PM, Jann Horn wrote:
> On Wed, Jan 30, 2019 at 12:14 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/29/19 4:08 PM, Jann Horn wrote:
>>> On Wed, Jan 30, 2019 at 12:06 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/29/19 4:03 PM, Jann Horn wrote:
>>>>> On Tue, Jan 29, 2019 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 1/29/19 3:44 PM, Jann Horn wrote:
>>>>>>> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> If we have fixed user buffers, we can map them into the kernel when we
>>>>>>>> setup the io_context. That avoids the need to do get_user_pages() for
>>>>>>>> each and every IO.
>>>>>>>>
>>>>>>>> To utilize this feature, the application must call io_uring_register()
>>>>>>>> after having setup an io_uring context, passing in
>>>>>>>> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer
>>>>>>>> to an iovec array, and the nr_args should contain how many iovecs the
>>>>>>>> application wishes to map.
>>>>>>>>
>>>>>>>> If successful, these buffers are now mapped into the kernel, eligible
>>>>>>>> for IO. To use these fixed buffers, the application must use the
>>>>>>>> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
>>>>>>>> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
>>>>>>>> must point to somewhere inside the indexed buffer.
>>>>>>>>
>>>>>>>> The application may register buffers throughout the lifetime of the
>>>>>>>> io_uring context. It can call io_uring_register() with
>>>>>>>> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
>>>>>>>> buffers, and then register a new set. The application need not
>>>>>>>> unregister buffers explicitly before shutting down the io_uring context.
> [...]
>> Just folded in this incremental, which should fix all the issues outlined
>> in your email.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7364feebafed..d42541357969 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
> [...]
>> @@ -1602,6 +1605,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, struct sqe_submit *sqes,
>>
>>  static int io_sq_thread(void *data)
>>  {
>> +       struct io_uring_sqe lsqe[IO_IOPOLL_BATCH];
>>         struct sqe_submit sqes[IO_IOPOLL_BATCH];
>>         struct io_ring_ctx *ctx = data;
>>         struct mm_struct *cur_mm = NULL;
>> @@ -1701,6 +1705,14 @@ static int io_sq_thread(void *data)
>>                 i = 0;
>>                 all_fixed = true;
>>                 do {
>> +                       /*
>> +                        * Ensure sqe is stable between checking if we need
>> +                        * user access, and actually importing the iovec
>> +                        * further down the stack.
>> +                        */
>> +                       memcpy(&lsqe[i], sqes[i].sqe, sizeof(lsqe[i]));
>> +                       sqes[i].sqe = &lsqe[i];
>> +
> 
> What if io_submit_sqe() gets an -EAGAIN from __io_submit_sqe() and
> queues io_sq_wq_submit_work()? Could that cause io_sq_wq_submit_work()
> to read from io_sq_thread()'s lsge[i] while io_sq_thread() is already
> in the next loop iteration of the outer loop and has copied new data
> into lsge[i]?

Hmm yes. I think we'll need to both embed a pointer to an sqe into
sqe_submit, and an actual sqe. The former can be used in the fast
path, while the latter will be our copy for the offload path for
io_sq_thread() and io_sq_wq_submit_work().

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
