From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/8] nowait-aio: Introduce IOMAP_NOWAIT
Date: Wed, 19 Apr 2017 09:12:23 +0200
Message-ID: <20170419071223.GB24693@quack2.suse.cz>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-5-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-5-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 14-04-17 07:02:53, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> IOCB_NOWAIT translates to IOMAP_NOWAIT for iomaps.
> This is used by XFS in the XFS patch.

Goldwyn, the patch is missing your Signed-off-by...

								Honza

> ---
>  fs/iomap.c            | 2 ++
>  include/linux/iomap.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 141c3cd55a8b..d1c81753d411 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -885,6 +885,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	} else {
>  		dio->flags |= IOMAP_DIO_WRITE;
>  		flags |= IOMAP_WRITE;
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			flags |= IOMAP_NOWAIT;
>  	}
>  
>  	if (mapping->nrpages) {
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 7291810067eb..53f6af89c625 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -51,6 +51,7 @@ struct iomap {
>  #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
>  #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
>  #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
> +#define IOMAP_NOWAIT		(1 << 5) /* Don't wait for writeback */
>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
