From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 27/32] aio: sanitize ki_list handling
Date: Wed, 10 Jan 2018 16:29:30 -0500
Message-ID: <x49lgh54d39.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-28-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-28-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 10 Jan 2018 16:58:48 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Instead of handcoded non-null checks always initialize ki_list to an
> empty list and use list_empty / list_empty_careful on it.

Yeah, who knows why list_empty wasn't used from the beginning.  In the
past, tricks were played by overwriting list pointers with non-null, but
that wasn't the case here.

> While we're at it also error out on a double call to
> kiocb_set_cancel_fn instead of ignoring it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/aio.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 496b50f9e9b1..fe241b5b44b2 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -555,13 +555,12 @@ void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
>  	struct kioctx *ctx = req->ki_ctx;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&ctx->ctx_lock, flags);
> -
> -	if (!req->ki_list.next)
> -		list_add(&req->ki_list, &ctx->active_reqs);
> +	if (WARN_ON_ONCE(!list_empty(&req->ki_list)))
> +		return;
>  
> +	spin_lock_irqsave(&ctx->ctx_lock, flags);
> +	list_add_tail(&req->ki_list, &ctx->active_reqs);
>  	req->ki_cancel = cancel;

So, this changes behavior from quietly overwriting the prior cancel
function to not doing it.  I don't think it matters one bit, though.
Callers shouldn't do that.

Acked-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
