From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] block: implement (some of) fallocate for block devices
Date: Fri, 04 Mar 2016 16:56:17 -0800
Message-ID: <20160305005617.29738.85316.stgit@birch.djwong.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160305005556.29738.66782.stgit@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, linux-api@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

After much discussion, it seems that the fallocate feature flag
FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
whitelisted for zeroing SCSI UNMAP.  Both flags require that
FALLOC_FL_KEEP_SIZE are set, both return EINVAL if one tries
to write past the end of the device, and both require that the
offset and length be aligned at least to 512-byte offsets.q

Since the semantics of fallocate are fairly well established already,
wire up the two pieces.  The other fallocate variants (collapse range,
insert range, and allocate blocks) are not supported.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/block_dev.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/open.c      |    3 ++-
 2 files changed, 69 insertions(+), 1 deletion(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 826b164..c9c9421 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -30,6 +30,7 @@
 #include <linux/cleancache.h>
 #include <linux/dax.h>
 #include <asm/uaccess.h>
+#include <linux/falloc.h>
 #include "internal.h"
 
 struct bdev_inode {
@@ -1786,6 +1787,71 @@ static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
 #define blkdev_mmap generic_file_mmap
 #endif
 
+#define	BLKDEV_FALLOC_FL_SUPPORTED					\
+		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
+		 FALLOC_FL_ZERO_RANGE)
+
+long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
+{
+	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct address_space *mapping;
+	loff_t end = start + len - 1;
+	loff_t bs_mask;
+	int error;
+
+	/* We only support zero range and punch hole. */
+	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
+		return -EOPNOTSUPP;
+
+	/* We can't change the bdev size from here */
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
+	/* We haven't a primitive for "ensure space exists" right now. */
+	if (mode == FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	/* Only punch if the device can do zeroing discard. */
+	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
+	    (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
+		return -EOPNOTSUPP;
+
+	/* Don't allow IO that isn't aligned to logical block size */
+	bs_mask = bdev_logical_block_size(bdev) - 1;
+	if ((start & bs_mask) || ((start + len) & bs_mask))
+		return -EINVAL;
+
+	/* Don't go off the end of the device */
+	if (end > i_size_read(bdev->bd_inode))
+		return -EINVAL;
+	if (end < start)
+		return -EINVAL;
+
+	/* Invalidate the page cache, including dirty pages. */
+	mapping = bdev->bd_inode->i_mapping;
+	truncate_inode_pages_range(mapping, start, end);
+
+	error = -EINVAL;
+	if (mode & FALLOC_FL_ZERO_RANGE)
+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
+					    GFP_KERNEL, false);
+	else if (mode & FALLOC_FL_PUNCH_HOLE)
+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Invalidate again; if someone wandered in and dirtied a page,
+	 * the caller will be given -EBUSY;
+	 */
+	return invalidate_inode_pages2_range(mapping,
+					     start >> PAGE_CACHE_SHIFT,
+					     end >> PAGE_CACHE_SHIFT);
+}
+EXPORT_SYMBOL_GPL(blkdev_fallocate);
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
@@ -1800,6 +1866,7 @@ const struct file_operations def_blk_fops = {
 #endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.fallocate	= blkdev_fallocate,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
diff --git a/fs/open.c b/fs/open.c
index 55bdc75..4f99adc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -289,7 +289,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * Let individual file system decide if it supports preallocation
 	 * for directories or not.
 	 */
-	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
+	    !S_ISBLK(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wrap through zero too */
