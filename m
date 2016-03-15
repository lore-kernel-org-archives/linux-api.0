From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Tue, 15 Mar 2016 12:42:29 -0700
Message-ID: <20160315194229.30093.75656.stgit@birch.djwong.org>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315194221.30093.70506.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
returning stale cache contents at a later time.

v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
Split the page invalidation and the new ioctl into separate patches.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/ioctl.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/block/ioctl.c b/block/ioctl.c
index d8996bb..c6eb462 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -226,7 +226,9 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
 	uint64_t range[2];
-	uint64_t start, len;
+	struct address_space *mapping;
+	uint64_t start, end, len;
+	int ret;
 
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
@@ -236,18 +238,33 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 
 	start = range[0];
 	len = range[1];
+	end = start + len - 1;
 
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
 		return -EINVAL;
-	start >>= 9;
-	len >>= 9;
-
-	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
+	if (end >= (uint64_t)i_size_read(bdev->bd_inode))
+		return -EINVAL;
+	if (end < start)
 		return -EINVAL;
 
-	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
+	/* Invalidate the page cache, including dirty pages */
+	mapping = bdev->bd_inode->i_mapping;
+	truncate_inode_pages_range(mapping, start, end);
+
+	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
+				    false);
+	if (ret)
+		return ret;
+
+	/*
+	 * Invalidate again; if someone wandered in and dirtied a page,
+	 * the caller will be given -EBUSY.
+	 */
+	return invalidate_inode_pages2_range(mapping,
+					     start >> PAGE_CACHE_SHIFT,
+					     end >> PAGE_CACHE_SHIFT);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
