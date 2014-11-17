From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] block: create ioctl to discard-or-zeroout a range of blocks
Date: Mon, 17 Nov 2014 11:28:15 -0800
Message-ID: <20141117192815.GC10047@birch.djwong.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
 <20141111000433.GA10047@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141111000433.GA10047@birch.djwong.org>
Sender: linux-scsi-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de, linux-api@vger.kernel.org
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

This patch depends on mkp's earlier patch "block: Introduce
blkdev_issue_zeroout_discard() function".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/ioctl.c           |   45 ++++++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/fs.h |    7 +++++++
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 7d8befd..ff623d5 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -186,19 +186,39 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
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
+	if (end >= i_size_read(bdev->bd_inode))
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
@@ -326,7 +346,18 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
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
+		return blk_ioctl_zeroout(bdev, p.start, p.length, p.flags);
 	}
 
 	case HDIO_GETGEO: {
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..54d24ea 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -150,6 +150,13 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+struct blkzeroout2 {
+	__u64 start;
+	__u64 length;
+	__u32 flags;
+};
+#define BLKZEROOUT2_DISCARD_OK	1
+#define BLKZEROOUT2 _IOR(0x12, 127, struct blkzeroout2)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
