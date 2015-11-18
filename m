From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 17 Nov 2015 20:38:04 -0800
Message-ID: <20151118043804.GC32467@birch.djwong.org>
References: <20151111062948.GA2214@birch.djwong.org>
 <x491tbt643m.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <x491tbt643m.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Seymour, Shane M" <shane.seymour-ZPxbGqLxI0U@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 13, 2015 at 03:23:25PM -0500, Jeff Moyer wrote:
> "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Create a new ioctl to expose the block layer's newfound ability to
> > issue either a zeroing discard, a WRITE SAME with a zero page, or a
> > regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> > {start, length, flags} as parameters.  So far, the only flag available
> > is to enable the zeroing discard part -- without it, the call invokes
> > the old BLKZEROOUT behavior.  start and length have the same meaning
> > as in BLKZEROOUT.
> >
> > Furthermore, because BLKZEROOUT2 issues commands directly to the
> > storage device, we must invalidate the page cache (as a regular
> > O_DIRECT write would do) to avoid returning stale cache contents at a
> > later time.
> >
> > v3: Add extra padding for future expansion, and check the padding is zero.
> 
> Is there someplace we document ioctls?  This stuff really could use some
> good documentation.

There's no place that I know of.  I looked in man-pages.git but didn't see
anything promising.  There's what, like ~2000 ioctls?

--D

> 
> Cheers,
> Jeff
> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  block/ioctl.c           |   48 ++++++++++++++++++++++++++++++++++++++++-------
> >  include/uapi/linux/fs.h |    9 +++++++++
> >  2 files changed, 50 insertions(+), 7 deletions(-)
> >
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index 8061eba..8e67551 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -213,19 +213,39 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
> >  }
> >  
> >  static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
> > -			     uint64_t len)
> > +			     uint64_t len, uint32_t flags)
> >  {
> > +	int ret;
> > +	struct address_space *mapping;
> > +	uint64_t end = start + len - 1;
> > +
> > +	if (flags & ~BLKZEROOUT2_DISCARD_OK)
> > +		return -EINVAL;
> >  	if (start & 511)
> >  		return -EINVAL;
> >  	if (len & 511)
> >  		return -EINVAL;
> > -	start >>= 9;
> > -	len >>= 9;
> > -
> > -	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
> > +	if (end >= i_size_read(bdev->bd_inode))
> >  		return -EINVAL;
> >  
> > -	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
> > +	/* Invalidate the page cache, including dirty pages */
> > +	mapping = bdev->bd_inode->i_mapping;
> > +	truncate_inode_pages_range(mapping, start, end);
> > +
> > +	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
> > +				   flags & BLKZEROOUT2_DISCARD_OK);
> > +	if (ret)
> > +		goto out;
> > +
> > +	/*
> > +	 * Invalidate again; if someone wandered in and dirtied a page,
> > +	 * the caller will be given -EBUSY.
> > +	 */
> > +	ret = invalidate_inode_pages2_range(mapping,
> > +					    start >> PAGE_CACHE_SHIFT,
> > +					    end >> PAGE_CACHE_SHIFT);
> > +out:
> > +	return ret;
> >  }
> >  
> >  static int put_ushort(unsigned long arg, unsigned short val)
> > @@ -353,7 +373,21 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> >  		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
> >  			return -EFAULT;
> >  
> > -		return blk_ioctl_zeroout(bdev, range[0], range[1]);
> > +		return blk_ioctl_zeroout(bdev, range[0], range[1], 0);
> > +	}
> > +	case BLKZEROOUT2: {
> > +		struct blkzeroout2 p;
> > +
> > +		if (!(mode & FMODE_WRITE))
> > +			return -EBADF;
> > +
> > +		if (copy_from_user(&p, (void __user *)arg, sizeof(p)))
> > +			return -EFAULT;
> > +
> > +		if (p.padding || p.padding2)
> > +			return -EINVAL;
> > +
> > +		return blk_ioctl_zeroout(bdev, p.start, p.length, p.flags);
> >  	}
> >  
> >  	case HDIO_GETGEO: {
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 9b964a5..b811fa4 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -152,6 +152,15 @@ struct inodes_stat_t {
> >  #define BLKSECDISCARD _IO(0x12,125)
> >  #define BLKROTATIONAL _IO(0x12,126)
> >  #define BLKZEROOUT _IO(0x12,127)
> > +struct blkzeroout2 {
> > +	__u64 start;
> > +	__u64 length;
> > +	__u32 flags;
> > +	__u32 padding;
> > +	__u64 padding2;
> > +};
> > +#define BLKZEROOUT2_DISCARD_OK	1
> > +#define BLKZEROOUT2 _IOR(0x12, 127, struct blkzeroout2)
> >  
> >  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
> >  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
