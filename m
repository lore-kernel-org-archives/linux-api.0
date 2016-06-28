From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Tue, 28 Jun 2016 12:13:02 -0700
Message-ID: <20160628191302.GE16181@birch.djwong.org>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
 <146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
 <7589fc01-a000-a912-f9b5-cf099cc2d27a@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7589fc01-a000-a912-f9b5-cf099cc2d27a-HInyCGIudOg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org" <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 20, 2016 at 02:35:29PM +0200, Bart Van Assche wrote:
> On 06/17/2016 03:18 AM, Darrick J. Wong wrote:
> >Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> >returning stale cache contents at a later time.
> >
> >v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
> >Split the page invalidation and the new ioctl into separate patches.
> >
> >Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> >---
> > block/ioctl.c |   29 +++++++++++++++++++++++------
> > 1 file changed, 23 insertions(+), 6 deletions(-)
> >
> >
> >diff --git a/block/ioctl.c b/block/ioctl.c
> >index ed2397f..d001f52 100644
> >--- a/block/ioctl.c
> >+++ b/block/ioctl.c
> >@@ -225,7 +225,9 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> > 		unsigned long arg)
> > {
> > 	uint64_t range[2];
> >-	uint64_t start, len;
> >+	struct address_space *mapping;
> >+	uint64_t start, end, len;
> >+	int ret;
> >
> > 	if (!(mode & FMODE_WRITE))
> > 		return -EBADF;
> >@@ -235,18 +237,33 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> >
> > 	start = range[0];
> > 	len = range[1];
> >+	end = start + len - 1;
> >
> > 	if (start & 511)
> > 		return -EINVAL;
> > 	if (len & 511)
> > 		return -EINVAL;
> >-	start >>= 9;
> >-	len >>= 9;
> >-
> >-	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
> >+	if (end >= (uint64_t)i_size_read(bdev->bd_inode))
> >+		return -EINVAL;
> >+	if (end < start)
> > 		return -EINVAL;
> >
> >-	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
> >+	/* Invalidate the page cache, including dirty pages */
> >+	mapping = bdev->bd_inode->i_mapping;
> >+	truncate_inode_pages_range(mapping, start, end);
> >+
> >+	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
> >+				    false);
> >+	if (ret)
> >+		return ret;
> >+
> >+	/*
> >+	 * Invalidate again; if someone wandered in and dirtied a page,
> >+	 * the caller will be given -EBUSY.
> >+	 */
> >+	return invalidate_inode_pages2_range(mapping,
> >+					     start >> PAGE_SHIFT,
> >+					     end >> PAGE_SHIFT);
> > }
> 
> Hello Darrick,
> 
> Maybe this has already been discussed, but anyway: in the POSIX spec
> (http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html) I
> found the following: "This volume of POSIX.1-2008 does not specify behavior
> of concurrent writes to a file from multiple processes. Applications should
> use some form of concurrency control."
> 
> Do we really need the invalidate_inode_pages2_range() call?

It's not strictly necessary.  I like the idea of having the kernel bonking
userspace when they don't coordinate and collide, but we could just jump
out after the blkdev_*() calls and let userspace fend for themselves. :)

--D

> 
> Thanks,
> 
> Bart.
> 
