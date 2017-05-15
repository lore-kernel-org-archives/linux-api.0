From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT
Date: Mon, 15 May 2017 11:47:09 +0200
Message-ID: <20170515094709.GA16182@quack2.suse.cz>
References: <20170511191710.31959-1-rgoldwyn@suse.de>
 <20170511191710.31959-5-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170511191710.31959-5-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu 11-05-17 14:17:04, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> RWF_NOWAIT informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
> 
> The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
> is called by most filesystems, either through fsops.write_iter() or through
> the function defined by write_iter(). If not, we perform the check defined
> by .write_iter() which is called for direct IO specifically.
> 
> Filesystems xfs, btrfs and ext4 would be supported in the following patches.
...
> diff --git a/fs/aio.c b/fs/aio.c
> index 020fa0045e3c..34027b67e2f4 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		goto out_put_req;
>  	}
>  
> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
> +			!(req->common.ki_flags & IOCB_DIRECT)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_put_req;
> +	}
> +
>  	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
>  	if (unlikely(ret)) {
>  		pr_debug("EFAULT: aio_key\n");

I think you need to also check here that the IO is write. So that NOWAIT
reads don't silently pass.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
