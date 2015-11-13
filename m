From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v4] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 13 Nov 2015 14:01:43 -0800
Message-ID: <20151113220143.GE2217@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

Create a new ioctl to expose the block layer's newfound ability to
issue either a zeroing discard, a WRITE SAME with a zero page, or a
regular write with the zero page.  This BLKZEROOUT2 ioctl takes
{start, length, flags} as parameters.  So far, the only flag available
is to enable the zeroing discard part -- without it, the call invokes
the old BLKZEROOUT behavior.  start and length have the same meaning
as in BLKZEROOUT.

Furthermore, because BLKZEROOUT2 issues commands directly to the
storage device, we must invalidate the page cache (as a regular
O_DIRECT write would do) to avoid returning stale cache contents at a
later time.

v3: Add extra padding for future expansion, and check the padding is zero.
v4: Check the start/len arguments for overflows prior to feeding the page
    cache bogus numbers (that it'll ignore anyway).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/ioctl.c           |   50 ++++++++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/fs.h |    9 ++++++++
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 8061eba..5c092e8 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -213,19 +213,41 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 }
 
 static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
-			     uint64_t len)
+			     uint64_t len, uint32_t flags)
 {
+	int ret;
+	struct address_space *mapping;
+	uint64_t end = start + len - 1;
+
+	if (flags & ~BLKZEROOUT2_DISCARD_OK)
+		return -EINVAL;
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
+				   flags & BLKZEROOUT2_DISCARD_OK);
+	if (ret)
+		goto out;
+
+	/*
+	 * Invalidate again; if someone wandered in and dirtied a page,
+	 * the caller will be given -EBUSY.
+	 */
+	ret = invalidate_inode_pages2_range(mapping,
+					    start >> PAGE_CACHE_SHIFT,
+					    end >> PAGE_CACHE_SHIFT);
+out:
+	return ret;
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
@@ -353,7 +375,21 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
 			return -EFAULT;
 
-		return blk_ioctl_zeroout(bdev, range[0], range[1]);
+		return blk_ioctl_zeroout(bdev, range[0], range[1], 0);
+	}
+	case BLKZEROOUT2: {
+		struct blkzeroout2 p;
+
+		if (!(mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(&p, (void __user *)arg, sizeof(p)))
+			return -EFAULT;
+
+		if (p.padding || p.padding2)
+			return -EINVAL;
+
+		return blk_ioctl_zeroout(bdev, p.start, p.length, p.flags);
 	}
 
 	case HDIO_GETGEO: {
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5..b811fa4 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -152,6 +152,15 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+struct blkzeroout2 {
+	__u64 start;
+	__u64 length;
+	__u32 flags;
+	__u32 padding;
+	__u64 padding2;
+};
+#define BLKZEROOUT2_DISCARD_OK	1
+#define BLKZEROOUT2 _IOR(0x12, 127, struct blkzeroout2)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
