From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/9] aio: sanitize ki_list handling
Date: Wed, 21 Mar 2018 10:16:48 +0100
Message-ID: <20180321091648.GL14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-5-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:27AM +0100, Christoph Hellwig wrote:
> Instead of handcoded non-null checks always initialize ki_list to an
> empty list and use list_empty / list_empty_careful on it.  While we're
> at it also error out on a double call to kiocb_set_cancel_fn instead
> of ignoring it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/aio.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 6295fc00f104..c32c315f05b5 100644
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

Will be fun to see if the syzkaller code ends up tripping on this one,
their use of panic-on-warn always is "interesting"...

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


>  
> +	spin_lock_irqsave(&ctx->ctx_lock, flags);
> +	list_add_tail(&req->ki_list, &ctx->active_reqs);
>  	req->ki_cancel = cancel;
> -
>  	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
> @@ -1034,7 +1033,7 @@ static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
>  		goto out_put;
>  
>  	percpu_ref_get(&ctx->reqs);
> -
> +	INIT_LIST_HEAD(&req->ki_list);
>  	req->ki_ctx = ctx;
>  	return req;
>  out_put:
> @@ -1080,7 +1079,7 @@ static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
>  	unsigned tail, pos, head;
>  	unsigned long	flags;
>  
> -	if (iocb->ki_list.next) {
> +	if (!list_empty_careful(iocb->ki_list.next)) {
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&ctx->ctx_lock, flags);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
