From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/8] Use RWF_* flags for AIO operations
Date: Tue, 18 Apr 2017 23:37:54 -0700
Message-ID: <20170419063754.GA20053@infradead.org>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-2-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-2-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 14, 2017 at 07:02:50AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> RWF_* flags is used for preadv2/pwritev2 calls. Port to use
> it for aio operations as well. For this, aio_rw_flags is
> introduced in struct iocb (using aio_reserved1) which will
> carry these flags.
> 
> This is a precursor to the nowait AIO calls.
> 
> Note, the only place RWF_HIPRI comes in effect is dio_await_one().
> All the rest of the locations, aio code return -EIOCBQUEUED before the
> checks for RWF_HIPRI.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/aio.c                     | 10 +++++++++-
>  fs/read_write.c              |  7 +------
>  include/linux/fs.h           | 12 ++++++++++++
>  include/uapi/linux/aio_abi.h |  2 +-
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index f52d925ee259..b8a33f5beef5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1541,11 +1541,17 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	ssize_t ret;
>  
>  	/* enforce forwards compatibility on users */
> -	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
> +	if (unlikely(iocb->aio_reserved2)) {
>  		pr_debug("EINVAL: reserve field set\n");
>  		return -EINVAL;
>  	}
>  
> +	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
> +		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
> +		return -EINVAL;
> +	}
> +

> +	req->common.ki_flags |= iocb_rw_flags(iocb->aio_rw_flags);

The flag validity checking also needs to go into what's currently
iocb_rw_flags (which will need a new name and a return value).
