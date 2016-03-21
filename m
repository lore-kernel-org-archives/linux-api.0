From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Mon, 21 Mar 2016 08:38:27 -0700
Message-ID: <20160321153827.GA27230@infradead.org>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
 <20160315194244.30093.6483.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315194244.30093.6483.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 12:42:44PM -0700, Darrick J. Wong wrote:
>  #include <linux/cleancache.h>
>  #include <linux/dax.h>
>  #include <asm/uaccess.h>
> +#include <linux/falloc.h>

Maybe keep this before asm/uaccess.h

> +long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)

should be marked static.

> +	/* We haven't a primitive for "ensure space exists" right now. */
> +	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;

I don't really understand the comment.  But I think you'd be much
better off with having blkdev_fallocate as just a tiny wrapper that has
a switch for the supported modes, e.g.

	switch (mode) {
	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
		return blkdev_punch_hole();
	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE::
		return blkdev_zero_range();
	default:
		return -EOPNOTSUPP;
	}

> +EXPORT_SYMBOL_GPL(blkdev_fallocate);

and no need to export it either..
