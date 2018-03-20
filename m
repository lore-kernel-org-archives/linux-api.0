From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/36] aio: simplify cancellation
Date: Mon, 19 Mar 2018 17:25:07 -0700
Message-ID: <20180320002507.GC7282@magnolia>
References: <20180305212743.16664-1-hch@lst.de>
 <20180305212743.16664-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-6-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 01:27:12PM -0800, Christoph Hellwig wrote:
> With the current aio code there is no need for the magic KIOCB_CANCELLED
> value, as a cancelation just kicks the driver to queue the completion
> ASAP, with all actual completion handling done in another thread. Given
> that both the completion path and cancelation take the context lock there
> is no need for magic cmpxchg loops either.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/aio.c | 37 +++++++++----------------------------
>  1 file changed, 9 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index c32c315f05b5..2d40cf5dd4ec 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -156,19 +156,6 @@ struct kioctx {
>  	unsigned		id;
>  };
>  
> -/*
> - * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
> - * cancelled or completed (this makes a certain amount of sense because
> - * successful cancellation - io_cancel() - does deliver the completion to
> - * userspace).
> - *
> - * And since most things don't implement kiocb cancellation and we'd really like
> - * kiocb completion to be lockless when possible, we use ki_cancel to
> - * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
> - * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
> - */
> -#define KIOCB_CANCELLED		((void *) (~0ULL))
> -
>  struct aio_kiocb {
>  	union {
>  		struct kiocb		rw;
> @@ -565,24 +552,18 @@ void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
> +/*
> + * Only cancel if there ws a ki_cancel function to start with, and we
> + * are the one how managed to clear it (to protect against simulatinious

"...are the one who managed to clear it (to protect against simultaneous
cancel calls)." ?

Really only complaining because who/how are both English words...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> + * cancel calls).
> + */
>  static int kiocb_cancel(struct aio_kiocb *kiocb)
>  {
> -	kiocb_cancel_fn *old, *cancel;
> -
> -	/*
> -	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> -	 * actually has a cancel function, hence the cmpxchg()
> -	 */
> -
> -	cancel = READ_ONCE(kiocb->ki_cancel);
> -	do {
> -		if (!cancel || cancel == KIOCB_CANCELLED)
> -			return -EINVAL;
> -
> -		old = cancel;
> -		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
> -	} while (cancel != old);
> +	kiocb_cancel_fn *cancel = kiocb->ki_cancel;
>  
> +	if (!cancel)
> +		return -EINVAL;
> +	kiocb->ki_cancel = NULL;
>  	return cancel(&kiocb->rw);
>  }
>  
> -- 
> 2.14.2
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
