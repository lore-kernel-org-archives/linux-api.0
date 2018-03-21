From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/9] aio: refactor read/write iocb setup
Date: Wed, 21 Mar 2018 10:15:22 +0100
Message-ID: <20180321091522.GK14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-4-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:26AM +0100, Christoph Hellwig wrote:
> Don't reference the kiocb structure from the common aio code, and move
> any use of it into helper specific to the read/write path.  This is in
> preparation for aio_poll support that wants to use the space for different
> fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/aio.c | 171 ++++++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 97 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 41fc8ce6bc7f..6295fc00f104 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -170,7 +170,9 @@ struct kioctx {
>  #define KIOCB_CANCELLED		((void *) (~0ULL))
>  
>  struct aio_kiocb {
> -	struct kiocb		common;
> +	union {
> +		struct kiocb		rw;
> +	};
>  
>  	struct kioctx		*ki_ctx;
>  	kiocb_cancel_fn		*ki_cancel;
> @@ -549,7 +551,7 @@ static int aio_setup_ring(struct kioctx *ctx, unsigned int nr_events)
>  
>  void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
>  {
> -	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, common);
> +	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, rw);
>  	struct kioctx *ctx = req->ki_ctx;
>  	unsigned long flags;
>  
> @@ -582,7 +584,7 @@ static int kiocb_cancel(struct aio_kiocb *kiocb)
>  		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
>  	} while (cancel != old);
>  
> -	return cancel(&kiocb->common);
> +	return cancel(&kiocb->rw);
>  }
>  
>  static void free_ioctx(struct work_struct *work)
> @@ -1040,15 +1042,6 @@ static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
>  	return NULL;
>  }
>  
> -static void kiocb_free(struct aio_kiocb *req)
> -{
> -	if (req->common.ki_filp)
> -		fput(req->common.ki_filp);
> -	if (req->ki_eventfd != NULL)
> -		eventfd_ctx_put(req->ki_eventfd);
> -	kmem_cache_free(kiocb_cachep, req);
> -}
> -
>  static struct kioctx *lookup_ioctx(unsigned long ctx_id)
>  {
>  	struct aio_ring __user *ring  = (void __user *)ctx_id;
> @@ -1079,29 +1072,14 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
>  /* aio_complete
>   *	Called when the io request on the given iocb is complete.
>   */
> -static void aio_complete(struct kiocb *kiocb, long res, long res2)
> +static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
>  {
> -	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, common);
>  	struct kioctx	*ctx = iocb->ki_ctx;
>  	struct aio_ring	*ring;
>  	struct io_event	*ev_page, *event;
>  	unsigned tail, pos, head;
>  	unsigned long	flags;
>  
> -	BUG_ON(is_sync_kiocb(kiocb));

Ah, nevermind about my previous email, sorry, should have kept
reading...

> +static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
> +{
> +	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, rw);
> +
> +	WARN_ON_ONCE(is_sync_kiocb(kiocb));

That's nicer, thanks.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
