From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] block: invalidate the page cache when issuing
 BLKZEROOUT.
Date: Tue, 01 Mar 2016 20:09:40 -0800
Message-ID: <20160302040940.16685.85318.stgit@birch.djwong.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160302040932.16685.62789.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: martin.petersen@oracle.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net
List-Id: linux-api@vger.kernel.org

Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
returning stale cache contents at a later time.

v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
Split the page invalidation and the new ioctl into separate patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

