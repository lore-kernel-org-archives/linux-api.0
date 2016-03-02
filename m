From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 01 Mar 2016 20:09:47 -0800
Message-ID: <20160302040947.16685.42926.stgit@birch.djwong.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160302040932.16685.62789.stgit@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: martin.petersen@oracle.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net
List-Id: linux-api@vger.kernel.org

Create a new ioctl to expose the block layer's newfound ability to
issue either a zeroing discard, a WRITE SAME with a zero page, or a
regular write with the zero page.  This BLKZEROOUT2 ioctl takes
{start, length, flags} as parameters.  So far, the only flag available
is to enable the zeroing discard part -- without it, the call invokes
the old BLKZEROOUT behavior.  start and length have the same meaning
as in BLKZEROOUT.

This new ioctl also invalidates the page cache correctly on account
of the previous patch in the series.

v3: Add extra padding for future expansion, and check the padding is zero.
v4: Check the start/len arguments for overflows prior to feeding the page
    cache bogus numbers (that it'll ignore anyway).
v5: Refactor the 4.4 refactoring of the ioctl code into separate functions.
    Separate patches for invalidation and new ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/ioctl.c           |   57 ++++++++++++++++++++++++++++++++++++-----------
 include/uapi/linux/fs.h |    9 +++++++
 2 files changed, 53 insertions(+), 13 deletions(-)


diff --git a/block/ioctl.c b/block/ioctl.c
index c6eb462..5567466 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -222,24 +222,20 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
-static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
-		unsigned long arg)
+static int __blk_ioctl_zeroout(struct block_device *bdev,
+			       unsigned long long start,
+			       unsigned long long len,
+			       unsigned int flags)
 {
-	uint64_t range[2];
 	struct address_space *mapping;
-	uint64_t start, end, len;
+	unsigned long long end;
+	bool discard = false;
 	int ret;
 
-	if (!(mode & FMODE_WRITE))
-		return -EBADF;
-
-	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
-		return -EFAULT;
-
-	start = range[0];
-	len = range[1];
 	end = start + len - 1;
 
+	if (flags & ~BLKZEROOUT2_DISCARD_OK)
+		return -EINVAL;
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
@@ -253,8 +249,10 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 	mapping = bdev->bd_inode->i_mapping;
 	truncate_inode_pages_range(mapping, start, end);
 
+	if (flags & BLKZEROOUT2_DISCARD_OK)
+		discard = true;
 	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
-				    false);
+				   discard);
 	if (ret)
 		return ret;
 
@@ -267,6 +265,37 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 					     end >> PAGE_CACHE_SHIFT);
 }
 
+static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
+		unsigned long arg)
+{
+	uint64_t range[2];
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+		return -EFAULT;
+
+	return __blk_ioctl_zeroout(bdev, range[0], range[1], 0);
+}
+
+static int blk_ioctl_zeroout2(struct block_device *bdev, fmode_t mode,
+		unsigned long arg)
+{
+	struct blkzeroout2 p;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(&p, (void __user *)arg, sizeof(p)))
+		return -EFAULT;
+
+	if (p.padding || p.padding2)
+		return -EINVAL;
+
+	return __blk_ioctl_zeroout(bdev, p.start, p.length, p.flags);
+}
+
 static int put_ushort(unsigned long arg, unsigned short val)
 {
 	return put_user(val, (unsigned short __user *)arg);
@@ -560,6 +589,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 				BLKDEV_DISCARD_SECURE);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
+	case BLKZEROOUT2:
+		return blk_ioctl_zeroout2(bdev, mode, arg);
 	case HDIO_GETGEO:
 		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 149bec8..4c7a376 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,6 +222,15 @@ struct fsxattr {
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
 #define BLKDAXGET _IO(0x12,129)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
