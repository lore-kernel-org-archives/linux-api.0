From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 17:34:36 +0100
Message-ID: <20190128163436.GA12427@lst.de>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de> <42a5b12b-8d3a-2495-ad53-6a6fdd4504c6@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <42a5b12b-8d3a-2495-ad53-6a6fdd4504c6@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-block@vger.kernel.org, jmoyer@redhat.com, avi@scylladb.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 09:26:42AM -0700, Jens Axboe wrote:
> >> +static void io_free_scq_urings(struct io_ring_ctx *ctx)
> >> +{
> >> +	if (ctx->sq_ring) {
> >> +		page_frag_free(ctx->sq_ring);
> >> +		ctx->sq_ring = NULL;
> >> +	}
> >> +	if (ctx->sq_sqes) {
> >> +		page_frag_free(ctx->sq_sqes);
> >> +		ctx->sq_sqes = NULL;
> >> +	}
> >> +	if (ctx->cq_ring) {
> >> +		page_frag_free(ctx->cq_ring);
> >> +		ctx->cq_ring = NULL;
> >> +	}
> > 
> > Why is this using the page_frag helpers?  Also the callers just free
> > these ctx structure, so there isn't much of a point zeroing them out.
> 
> Why not use the page frag helpers? No point in open-coding it. I can
> kill the zeroing, double call would be a bug anyway.

Because they are at a different level of abstraction, and someone
might change the implementation, and is unlikely to catch the io_uring
mix of interfaces.  If you think this is really useful we should also
export the helpers under a different name and with documentation.
(and add a __get_free_pages version that returns a pointer..)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
