From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 7/9] aio: add delayed cancel support
Date: Wed, 21 Mar 2018 10:18:42 +0100
Message-ID: <20180321091842.GO14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-8-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:30AM +0100, Christoph Hellwig wrote:
> The upcoming aio poll support would like to be able to complete the
> iocb inline from the cancellation context, but that would cause
> a lock order reversal.  Add support for optionally moving the cancelation
> outside the context lock to avoid this reversal.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/aio.c | 49 ++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 0b6394b4e528..9d7d6e4cde87 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -170,6 +170,10 @@ struct aio_kiocb {
>  	struct list_head	ki_list;	/* the aio core uses this
>  						 * for cancellation */
>  
> +	unsigned int		flags;		/* protected by ctx->ctx_lock */
> +#define AIO_IOCB_DELAYED_CANCEL	(1 << 0)
> +#define AIO_IOCB_CANCELLED	(1 << 1)

BIT(0) and BIT(1)?

Anyway, not a big deal...

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
