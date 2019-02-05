From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 5 Feb 2019 09:58:30 -0700
Message-ID: <f67d5190-1431-b554-77a7-125bc1a70c32@kernel.dk>
References: <20190201152414.23296-1-axboe@kernel.dk>
 <20190201152414.23296-6-axboe@kernel.dk>
 <871s4r8j5i.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <871s4r8j5i.fsf@oldenburg2.str.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On 2/1/19 11:20 AM, Florian Weimer wrote:
> * Jens Axboe:
> 
>> +/*
>> + * Filled with the offset for mmap(2)
>> + */
>> +struct io_sqring_offsets {
>> +	__u32 head;
>> +	__u32 tail;
>> +	__u32 ring_mask;
>> +	__u32 ring_entries;
>> +	__u32 flags;
>> +	__u32 dropped;
>> +	__u32 array;
>> +	__u32 resv[3];
>> +};
>> +
>> +struct io_cqring_offsets {
>> +	__u32 head;
>> +	__u32 tail;
>> +	__u32 ring_mask;
>> +	__u32 ring_entries;
>> +	__u32 overflow;
>> +	__u32 cqes;
>> +	__u32 resv[4];
>> +};
>> +
>> +/*
>> + * io_uring_enter(2) flags
>> + */
>> +#define IORING_ENTER_GETEVENTS	(1U << 0)
>> +
>> +/*
>> + * Passed in for io_uring_setup(2). Copied back with updated info on success
>> + */
>> +struct io_uring_params {
>> +	__u32 sq_entries;
>> +	__u32 cq_entries;
>> +	__u32 flags;
>> +	__u32 resv[7];
>> +	struct io_sqring_offsets sq_off;
>> +	struct io_cqring_offsets cq_off;
>> +};
> 
> I still think it might be a good idea to have one reserved __u64 field
> for alignment purposes.

Sure, I can do that.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
