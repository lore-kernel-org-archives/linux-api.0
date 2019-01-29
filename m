From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 06:35:04 -0700
Message-ID: <74fd3127-75f1-3a48-d3cb-a8f6c9bd0b74@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <87tvhrpsqg.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <87tvhrpsqg.fsf@oldenburg2.str.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

On 1/29/19 5:12 AM, Florian Weimer wrote:
> * Jens Axboe:
> 
>> +#define IORING_MAX_ENTRIES	4096
> 
> Where does this constant come from?  Should it really be exposed to
> userspace?

Seems pretty handy for the application to know what the limit is?

>> +struct io_uring_params {
>> +	__u32 sq_entries;
>> +	__u32 cq_entries;
>> +	__u32 flags;
>> +	__u16 resv[10];
>> +	struct io_sqring_offsets sq_off;
>> +	struct io_cqring_offsets cq_off;
>> +};
> 
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
> 
> Should the reserved fields include a __u64 member, to increase struct
> alignment on architectures that might need it in the future?

Sure, I can do that.

>> +#define IORING_ENTER_GETEVENTS	(1 << 0)
> 
> Should this be unsigned, to match the u32 flags argument?  (Otherwise
> using 32 flags can be difficult).

Good point, I've changed them all to be unsigned.


-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
