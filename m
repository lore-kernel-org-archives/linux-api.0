From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] nowait aio: xfs
Date: Thu, 6 Apr 2017 15:54:15 -0700
Message-ID: <20170406225415.GC4864@birch.djwong.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-8-rgoldwyn@suse.de>
 <20170404065211.GD21942@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404065211.GD21942-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 03, 2017 at 11:52:11PM -0700, Christoph Hellwig wrote:
> > +	if (unaligned_io) {
> > +		/* If we are going to wait for other DIO to finish, bail */
> > +		if ((iocb->ki_flags & IOCB_NOWAIT) &&
> > +		     atomic_read(&inode->i_dio_count))
> > +			return -EAGAIN;
> >  		inode_dio_wait(inode);
> 
> This checks i_dio_count twice in the nowait case, I think it should be:
> 
> 	if (iocb->ki_flags & IOCB_NOWAIT) {
> 		if (atomic_read(&inode->i_dio_count))
> 			return -EAGAIN;
> 	} else {
> 		inode_dio_wait(inode);
> 	}
> 
> >  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> >  		if (flags & IOMAP_DIRECT) {
> > +			/* A reflinked inode will result in CoW alloc */
> > +			if (flags & IOMAP_NOWAIT) {
> > +				error = -EAGAIN;
> > +				goto out_unlock;
> > +			}
> 
> This is a bit pessimistic - just because the inode has any shared
> extents we could still write into unshared ones.  For now I think this
> pessimistic check is fine, but the comment should be corrected.

Consider what happens in both _reflink_{allocate,reserve}_cow.  If there
is already an existing reservation in the CoW fork then we'll have to
CoW and therefore can't satisfy the NOWAIT flag.  If there isn't already
anything in the CoW fork, then we have to see if there are shared blocks
by calling _reflink_trim_around_shared.  That performs a refcountbt
lookup, which involves locking the AGF, so we also can't satisfy NOWAIT.

IOWs, I think this hunk has to move outside the IOMAP_DIRECT check to
cover both write-to-reflinked-file cases.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
