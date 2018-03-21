From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/9] aio: remove an outdated comment in aio_complete
Date: Wed, 21 Mar 2018 10:14:20 +0100
Message-ID: <20180321091420.GJ14085@kroah.com>
References: <20180321073232.13366-1-hch@lst.de>
 <20180321073232.13366-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321073232.13366-3-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:32:25AM +0100, Christoph Hellwig wrote:
> These days we don't treat sync iocbs special in the aio completion code as
> they never use it.  Remove the old comment, and move the BUG_ON for a sync
> iocb to the top of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/aio.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 03d59593912d..41fc8ce6bc7f 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1088,6 +1088,8 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
>  	unsigned tail, pos, head;
>  	unsigned long	flags;
>  
> +	BUG_ON(is_sync_kiocb(kiocb));

Is this BUG_ON even needed anymore?  Does it ever trip in any "regular"
use, or is it only there for when a developer does something dumb?  If
"dumb", then we should keep it, otherwise we might be able to just drop
it.

Either way, this patch is fine:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
