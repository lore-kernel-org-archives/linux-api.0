From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v6 4/5] block: loop: prepare for supporing direct IO
Date: Wed, 24 Jun 2015 21:07:45 +0800
Message-ID: <1435151266-13819-5-git-send-email-ming.lei@canonical.com>
References: <1435151266-13819-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435151266-13819-1-git-send-email-ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Maxim Patlasov <mpatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patches provides one interface for enabling direct IO
from user space:

	- userspace(such as losetup) can pass 'file' which is
	opened/fcntl as O_DIRECT

Also __loop_update_dio() is introduced to check if direct I/O
can be used on current loop setting.

The last big change is to introduce LO_FLAGS_DIRECT_IO flag
for userspace to know if direct IO is used to access backing
file.

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/block/loop.c      | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/loop.h      |  1 +
 include/uapi/linux/loop.h |  1 +
 3 files changed, 58 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 555b895..599d668 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -421,6 +421,51 @@ struct switch_request {
 	struct completion wait;
 };
 
+static void __loop_update_dio(struct loop_device *lo, bool dio)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+	bool use_dio;
+
+	/*
+	 * loop block's logical block size is 512, now
+	 * we support direct I/O only if the backing
+	 * block devices' minimize I/O size is 512 and
+	 * the offset is aligned with 512.
+	 */
+	if (dio) {
+		if (inode->i_sb->s_bdev &&
+			bdev_io_min(inode->i_sb->s_bdev) == 512 &&
+			!(lo->lo_offset & 511))
+			use_dio = true;
+		else
+			use_dio = false;
+	} else {
+		use_dio = false;
+	}
+
+	if (lo->use_dio == use_dio)
+		return;
+
+	/* flush dirty pages before changing direct IO */
+	vfs_fsync(file, 0);
+
+	/*
+	 * The flag of LO_FLAGS_DIRECT_IO is handled similarly with
+	 * LO_FLAGS_READ_ONLY, both are set from kernel, and losetup
+	 * will get updated by ioctl(LOOP_GET_STATUS)
+	 */
+	blk_mq_freeze_queue(lo->lo_queue);
+	lo->use_dio = use_dio;
+	lo->lo_flags |= use_dio ? LO_FLAGS_DIRECT_IO : 0;
+	blk_mq_unfreeze_queue(lo->lo_queue);
+}
+
+static inline void loop_update_dio(struct loop_device *lo)
+{
+	__loop_update_dio(lo, io_is_direct(lo->lo_backing_file));
+}
+
 /*
  * Do the actual switch; called from the BIO completion routine
  */
@@ -441,6 +486,7 @@ static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_update_dio(lo);
 }
 
 /*
@@ -627,11 +673,19 @@ static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
 	return sprintf(buf, "%s\n", partscan ? "1" : "0");
 }
 
+static ssize_t loop_attr_dio_show(struct loop_device *lo, char *buf)
+{
+	int dio = (lo->lo_flags & LO_FLAGS_DIRECT_IO);
+
+	return sprintf(buf, "%s\n", dio ? "1" : "0");
+}
+
 LOOP_ATTR_RO(backing_file);
 LOOP_ATTR_RO(offset);
 LOOP_ATTR_RO(sizelimit);
 LOOP_ATTR_RO(autoclear);
 LOOP_ATTR_RO(partscan);
+LOOP_ATTR_RO(dio);
 
 static struct attribute *loop_attrs[] = {
 	&loop_attr_backing_file.attr,
@@ -639,6 +693,7 @@ static struct attribute *loop_attrs[] = {
 	&loop_attr_sizelimit.attr,
 	&loop_attr_autoclear.attr,
 	&loop_attr_partscan.attr,
+	&loop_attr_dio.attr,
 	NULL,
 };
 
@@ -783,6 +838,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
+	loop_update_dio(lo);
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 	loop_sysfs_init(lo);
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index b6c7d21..d1de221 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -58,6 +58,7 @@ struct loop_device {
 	struct mutex		lo_ctl_mutex;
 	struct kthread_worker	worker;
 	struct task_struct	*worker_task;
+	bool			use_dio;
 
 	struct request_queue	*lo_queue;
 	struct blk_mq_tag_set	tag_set;
diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index e0cecd2..949851c 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -21,6 +21,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
+	LO_FLAGS_DIRECT_IO	= 16,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.9.1
