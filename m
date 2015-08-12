From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] block: cleanup blkdev_ioctl
Date: Wed, 12 Aug 2015 08:23:20 +0200
Message-ID: <1439360604-16192-2-git-send-email-hch@lst.de>
References: <1439360604-16192-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439360604-16192-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Split out helpers for all non-trivial ioctls to make this function simpler,
and also start passing around a pointer version of the argument, as that's
what most ioctl handlers actually need.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c | 227 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 127 insertions(+), 100 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 8061eba..df62b47 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -193,10 +193,20 @@ int blkdev_reread_part(struct block_device *bdev)
 }
 EXPORT_SYMBOL(blkdev_reread_part);
 
-static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
-			     uint64_t len, int secure)
+static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
+		unsigned long arg, unsigned long flags)
 {
-	unsigned long flags = 0;
+	uint64_t range[2];
+	uint64_t start, len;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+		return -EFAULT;
+
+	start = range[0];
+	len = range[1];
 
 	if (start & 511)
 		return -EINVAL;
@@ -207,14 +217,24 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 
 	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
 		return -EINVAL;
-	if (secure)
-		flags |= BLKDEV_DISCARD_SECURE;
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
-static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
-			     uint64_t len)
+static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
+		unsigned long arg)
 {
+	uint64_t range[2];
+	uint64_t start, len;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+		return -EFAULT;
+
+	start = range[0];
+	len = range[1];
+
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
@@ -295,89 +315,115 @@ static inline int is_unrecognized_ioctl(int ret)
 		ret == -ENOIOCTLCMD;
 }
 
-/*
- * always keep this in sync with compat_blkdev_ioctl()
- */
-int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
-			unsigned long arg)
+static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
+		unsigned cmd, unsigned long arg)
 {
-	struct gendisk *disk = bdev->bd_disk;
-	struct backing_dev_info *bdi;
-	loff_t size;
-	int ret, n;
-	unsigned int max_sectors;
+	int ret;
 
-	switch(cmd) {
-	case BLKFLSBUF:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-
-		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-		if (!is_unrecognized_ioctl(ret))
-			return ret;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
 
-		fsync_bdev(bdev);
-		invalidate_bdev(bdev);
-		return 0;
+	ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+	if (!is_unrecognized_ioctl(ret))
+		return ret;
 
-	case BLKROSET:
-		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-		if (!is_unrecognized_ioctl(ret))
-			return ret;
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		if (get_user(n, (int __user *)(arg)))
-			return -EFAULT;
-		set_device_ro(bdev, n);
-		return 0;
+	fsync_bdev(bdev);
+	invalidate_bdev(bdev);
+	return 0;
+}
 
-	case BLKDISCARD:
-	case BLKSECDISCARD: {
-		uint64_t range[2];
+static int blkdev_roset(struct block_device *bdev, fmode_t mode,
+		unsigned cmd, unsigned long arg)
+{
+	int ret, n;
 
-		if (!(mode & FMODE_WRITE))
-			return -EBADF;
+	ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+	if (!is_unrecognized_ioctl(ret))
+		return ret;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (get_user(n, (int __user *)arg))
+		return -EFAULT;
+	set_device_ro(bdev, n);
+	return 0;
+}
 
-		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
-			return -EFAULT;
+static int blkdev_getgeo(struct block_device *bdev,
+		struct hd_geometry __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct hd_geometry geo;
+	int ret;
 
-		return blk_ioctl_discard(bdev, range[0], range[1],
-					 cmd == BLKSECDISCARD);
-	}
-	case BLKZEROOUT: {
-		uint64_t range[2];
+	if (!argp)
+		return -EINVAL;
+	if (!disk->fops->getgeo)
+		return -ENOTTY;
+
+	/*
+	 * We need to set the startsect first, the driver may
+	 * want to override it.
+	 */
+	memset(&geo, 0, sizeof(geo));
+	geo.start = get_start_sect(bdev);
+	ret = disk->fops->getgeo(bdev, &geo);
+	if (ret)
+		return ret;
+	if (copy_to_user(argp, &geo, sizeof(geo)))
+		return -EFAULT;
+	return 0;
+}
 
-		if (!(mode & FMODE_WRITE))
-			return -EBADF;
+/* set the logical block size */
+static int blkdev_bszset(struct block_device *bdev, fmode_t mode,
+		int __user *argp)
+{
+	int ret, n;
 
-		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
-			return -EFAULT;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (!argp)
+		return -EINVAL;
+	if (get_user(n, argp))
+		return -EFAULT;
 
-		return blk_ioctl_zeroout(bdev, range[0], range[1]);
+	if (!(mode & FMODE_EXCL)) {
+		bdgrab(bdev);
+		if (blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
+			return -EBUSY;
 	}
 
-	case HDIO_GETGEO: {
-		struct hd_geometry geo;
+	ret = set_blocksize(bdev, n);
+	if (!(mode & FMODE_EXCL))
+		blkdev_put(bdev, mode | FMODE_EXCL);
+	return ret;
+}
 
-		if (!arg)
-			return -EINVAL;
-		if (!disk->fops->getgeo)
-			return -ENOTTY;
-
-		/*
-		 * We need to set the startsect first, the driver may
-		 * want to override it.
-		 */
-		memset(&geo, 0, sizeof(geo));
-		geo.start = get_start_sect(bdev);
-		ret = disk->fops->getgeo(bdev, &geo);
-		if (ret)
-			return ret;
-		if (copy_to_user((struct hd_geometry __user *)arg, &geo,
-					sizeof(geo)))
-			return -EFAULT;
-		return 0;
-	}
+/*
+ * always keep this in sync with compat_blkdev_ioctl()
+ */
+int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
+			unsigned long arg)
+{
+	struct backing_dev_info *bdi;
+	void __user *argp = (void __user *)arg;
+	loff_t size;
+	unsigned int max_sectors;
+
+	switch (cmd) {
+	case BLKFLSBUF:
+		return blkdev_flushbuf(bdev, mode, cmd, arg);
+	case BLKROSET:
+		return blkdev_roset(bdev, mode, cmd, arg);
+	case BLKDISCARD:
+		return blk_ioctl_discard(bdev, mode, arg, 0);
+	case BLKSECDISCARD:
+		return blk_ioctl_discard(bdev, mode, arg,
+				BLKDEV_DISCARD_SECURE);
+	case BLKZEROOUT:
+		return blk_ioctl_zeroout(bdev, mode, arg);
+	case HDIO_GETGEO:
+		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
 	case BLKFRAGET:
 		if (!arg)
@@ -414,28 +460,11 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
 		return 0;
 	case BLKBSZSET:
-		/* set the logical block size */
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		if (!arg)
-			return -EINVAL;
-		if (get_user(n, (int __user *) arg))
-			return -EFAULT;
-		if (!(mode & FMODE_EXCL)) {
-			bdgrab(bdev);
-			if (blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
-				return -EBUSY;
-		}
-		ret = set_blocksize(bdev, n);
-		if (!(mode & FMODE_EXCL))
-			blkdev_put(bdev, mode | FMODE_EXCL);
-		return ret;
+		return blkdev_bszset(bdev, mode, argp);
 	case BLKPG:
-		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
-		break;
+		return blkpg_ioctl(bdev, argp);
 	case BLKRRPART:
-		ret = blkdev_reread_part(bdev);
-		break;
+		return blkdev_reread_part(bdev);
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
 		if ((size >> 9) > ~0UL)
@@ -447,11 +476,9 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESTOP:
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
-		ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
-		break;
+		return blk_trace_ioctl(bdev, cmd, argp);
 	default:
-		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+		return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 	}
-	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_ioctl);
-- 
1.9.1
