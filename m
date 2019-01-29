From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/18] io_uring: batch io_kiocb allocation
Date: Tue, 29 Jan 2019 18:26:24 +0100
Message-ID: <20190129172624.GB15347@lst.de>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-11-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190128213538.13486-11-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

> -static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
> +static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
> +				   struct io_submit_state *state)
>  {
> +	gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;

No actually in this patch, but why do we do GFP_ATOMIC allocations
here?  We aren't in irq context or under a spinlock.

> +	if (!state)
> +		req = kmem_cache_alloc(req_cachep, gfp);

Add a
		if (!req)
			goto out;

plus the missing braces here..

> +	else if (!state->free_reqs) {
> +		size_t sz;
> +		int ret;
> +
> +		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
> +		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz,
> +						state->reqs);
> +		if (ret <= 0)
> +			goto out;
> +		state->free_reqs = ret - 1;
> +		state->cur_req = 1;
> +		req = state->reqs[0];
> +	} else {
> +		req = state->reqs[state->cur_req];
> +		state->free_reqs--;
> +		state->cur_req++;
> +	}
> +
>  	if (req) {
>  		req->ctx = ctx;
>  		req->flags = 0;
>  		return req;
>  	}

... and we don't need this conditional, which would otherwise also
be in the fast path.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
