From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 10/18] io_uring: batch io_kiocb allocation
Date: Tue, 29 Jan 2019 11:14:45 -0700
Message-ID: <9e99b94e-dcd1-4c4d-1dc9-384b29f31528@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-11-axboe@kernel.dk> <20190129172624.GB15347@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190129172624.GB15347@lst.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

On 1/29/19 10:26 AM, Christoph Hellwig wrote:
>> -static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
>> +static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>> +				   struct io_submit_state *state)
>>  {
>> +	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;
> 
> No actually in this patch, but why do we do GFP_ATOMIC allocations
> here?  We aren't in irq context or under a spinlock.

Just to avoid dipping into more expensive allocs. Probably not a big
deal, I'll remove the atomic.

> 
>> +	if (!state)
>> +		req = kmem_cache_alloc(req_cachep, gfp);
> 
> Add a
> 		if (!req)
> 			goto out;
> 
> plus the missing braces here..
> 
>> +	else if (!state->free_reqs) {
>> +		size_t sz;
>> +		int ret;
>> +
>> +		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
>> +		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz,
>> +						state->reqs);
>> +		if (ret <= 0)
>> +			goto out;
>> +		state->free_reqs = ret - 1;
>> +		state->cur_req = 1;
>> +		req = state->reqs[0];
>> +	} else {
>> +		req = state->reqs[state->cur_req];
>> +		state->free_reqs--;
>> +		state->cur_req++;
>> +	}
>> +
>>  	if (req) {
>>  		req->ctx = ctx;
>>  		req->flags = 0;
>>  		return req;
>>  	}
> 
> ... and we don't need this conditional, which would otherwise also
> be in the fast path.

Good idea, done.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
