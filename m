From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT and FMODE_AIO_NOWAIT
Date: Sat, 17 Jun 2017 05:09:44 +0100
Message-ID: <20170617040944.GT31671@ZenIV.linux.org.uk>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
 <20170615160002.17233-5-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170615160002.17233-5-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 15, 2017 at 10:59:56AM -0500, Goldwyn Rodrigues wrote:
>  static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
>  {
> -	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
> +	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))

Minor nit: that calls for something like
	if (unlikely(flags & ~RWF_ALL)
>  		return -EOPNOTSUPP;

with corresponding definition.
