From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/18] io_uring: support for IO polling
Date: Tue, 29 Jan 2019 18:24:14 +0100
Message-ID: <20190129172414.GA15347@lst.de>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-8-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190128213538.13486-8-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

>  
> @@ -118,12 +120,16 @@ struct io_kiocb {
>  	struct list_head	list;
>  	unsigned int		flags;
>  #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
> +#define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
> +#define REQ_F_IOPOLL_EAGAIN	4	/* submission got EAGAIN */
>  	u64			user_data;
> +	u64			res;

Should this be ret or error instead?  res is kinda off.  A little
comment describing it won't hurt either.  Last but not least with
the actual errno value stored here we probably don't need the
REQ_F_IOPOLL_EAGAIN flag, do we?

> +	/*
> +	 * Only spin for completions if we don't have multiple devices hanging
> +	 * off our complete list, and we're under the requested amount.
> +	 */
> +	spin = !ctx->poll_multi_file && (*nr_events < min);

no need for the braces here.

> +static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
> +				long min)
> +{
> +	int ret;
> +
> +	do {
> +		if (list_empty(&ctx->poll_list))
> +			return 0;
> +
> +		ret = io_do_iopoll(ctx, nr_events, min);
> +		if (ret < 0)
> +			break;
> +	} while (min && *nr_events < min);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return *nr_events < min;

The code looks a little clumsy to me.  Why not:

	while (!list_empty(&ctx->poll_list)) {
		int ret = io_do_iopoll(ctx, nr_events, min);
		if (ret)
			return ret;

		if (!min || *nr_events >= min)
			return 0;
	}

	return 1;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
