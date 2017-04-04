From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] nowait aio: xfs
Date: Mon, 3 Apr 2017 23:52:11 -0700
Message-ID: <20170404065211.GD21942@infradead.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-8-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170403185307.6243-8-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

> +	if (unaligned_io) {
> +		/* If we are going to wait for other DIO to finish, bail */
> +		if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +		     atomic_read(&inode->i_dio_count))
> +			return -EAGAIN;
>  		inode_dio_wait(inode);

This checks i_dio_count twice in the nowait case, I think it should be:

	if (iocb->ki_flags & IOCB_NOWAIT) {
		if (atomic_read(&inode->i_dio_count))
			return -EAGAIN;
	} else {
		inode_dio_wait(inode);
	}

>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
>  		if (flags & IOMAP_DIRECT) {
> +			/* A reflinked inode will result in CoW alloc */
> +			if (flags & IOMAP_NOWAIT) {
> +				error = -EAGAIN;
> +				goto out_unlock;
> +			}

This is a bit pessimistic - just because the inode has any shared
extents we could still write into unshared ones.  For now I think this
pessimistic check is fine, but the comment should be corrected.
