From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 19/19] io_uring: add io_uring_event cache hit information
Date: Sun, 10 Feb 2019 06:39:26 -0700
Message-ID: <cf52bd37-4891-dfe3-8673-9a836e01b6c8@kernel.dk>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-20-axboe@kernel.dk>
 <ca60183a-bb43-930c-8bf1-026c2528723d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <ca60183a-bb43-930c-8bf1-026c2528723d@suse.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Hannes Reinecke <hare@suse.de>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/10/19 2:36 AM, Hannes Reinecke wrote:
> On 2/9/19 10:13 PM, Jens Axboe wrote:
>> Add hint on whether a read was served out of the page cache, or if it
>> hit media. This is useful for buffered async IO, O_DIRECT reads would
>> never have this set (for obvious reasons).
>>
>> If the read hit page cache, cqe->flags will have IOCQE_FLAG_CACHEHIT
>> set.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c                 | 7 ++++++-
>>   include/uapi/linux/io_uring.h | 5 +++++
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 11a549b5dcbf..d7a10484d748 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -587,11 +587,16 @@ static void io_fput(struct io_kiocb *req)
>>   static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>>   {
>>   	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
>> +	unsigned ev_flags = 0;
>>   
>>   	kiocb_end_write(kiocb);
>>   
>>   	io_fput(req);
>> -	io_cqring_add_event(req->ctx, req->user_data, res, 0);
>> +
>> +	if (res > 0 && (req->flags & REQ_F_FORCE_NONBLOCK))
>> +		ev_flags = IOCQE_FLAG_CACHEHIT;
>> +
>> +	io_cqring_add_event(req->ctx, req->user_data, res, ev_flags);
>>   	io_free_req(req);
>>   }
>>   
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index e23408692118..24906e99fdc7 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -69,6 +69,11 @@ struct io_uring_cqe {
>>   	__u32	flags;
>>   };
>>
>> +/*
>> + * io_uring_event->flags
>> + */
>> +#define IOCQE_FLAG_CACHEHIT	(1U << 0)	/* IO did not hit media */
>> +
>>   /*
>>    * Magic offsets for the application to mmap the data it needs
>>    */
>>
> 
> Hmm. The point of this patch being ... what?
> Just setting a newly introduced flag seems to be a bit pointless.
> Unless it has some magic interaction with io_cqring_add_event().
> But then that function would have had to have knowledge of that flag 
> already, which would be ... odd.

Not sure I follow your concern here. The kernel doesn't use the flag,
we just set it. It's used to inform the application of whether or
not the given read was a cachehit, or if it had to be served by
media.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
