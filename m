From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/3] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Thu, 16 Jun 2016 18:17:34 -0700
Message-ID: <146612625412.12764.6647932282740152837.stgit@birch.djwong.org>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, darrick.wong@oracle.com
Cc: linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
returning stale cache contents at a later time.

v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
Split the page invalidation and the new ioctl into separate patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/block/ioctl.c b/block/ioctl.c
index ed2397f..d001f52 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -225,7 +225,9 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		unsigned long arg)
 {
 	uint64_t range[2];
-	uint64_t start, len;
+	struct address_space *mapping;
+	uint64_t start, end, len;
+	int ret;
 
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
@@ -235,18 +237,33 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 
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
+					     start >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)

