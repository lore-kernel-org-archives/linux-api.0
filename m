From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/9] Use RWF_* flags for AIO operations
Date: Wed, 12 Apr 2017 01:33:08 -0700
Message-ID: <20170412083308.GA22363@infradead.org>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-2-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170411142619.27205-2-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>  
> +	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
> +		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
> +		return -EINVAL;
> +	}

> +	if (iocb->aio_rw_flags & RWF_HIPRI)
> +		req->common.ki_flags |= IOCB_HIPRI;
> +	if (iocb->aio_rw_flags & RWF_DSYNC)
> +		req->common.ki_flags |= IOCB_DSYNC;
> +	if (iocb->aio_rw_flags & RWF_SYNC)
> +		req->common.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);

Pleae introduce a common helper to share this code between the
synchronous and the aio path
