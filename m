From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v10 4/6] block: loop: prepare for supporing direct IO
Date: Mon, 17 Aug 2015 10:31:49 +0800
Message-ID: <1439778711-9621-5-git-send-email-ming.lei@canonical.com>
References: <1439778711-9621-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439778711-9621-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>, Maxim Patlasov <mpatlasov@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@canonical.com>, linux-api@vger.kernel.org
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

Cc: linux-api@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c      | 77 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/loop.h      |  1 +
 include/uapi/linux/loop.h |  1 +
 3 files changed, 79 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1875aad..06cad7e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -164,6 +164,62 @@ static loff_t get_loop_size(struct loop_device *lo, struct file *file)
 	return get_size(lo->lo_offset, lo->lo_sizelimit, file);
 }
 
+static void __loop_update_dio(struct loop_device *lo, bool dio)
+{
+	struct file *file = lo->lo_backing_file;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	unsigned short sb_bsize = 0;
+	unsigned dio_align = 0;
+	bool use_dio;
+
+	if (inode->i_sb->s_bdev) {
+		sb_bsize = bdev_logical_block_size(inode->i_sb->s_bdev);
+		dio_align = sb_bsize - 1;
+	}
+
+	/*
+	 * We support direct I/O only if lo_offset is aligned with the
+	 * logical I/O size of backing device, and the logical block
+	 * size of loop is bigger than the backing device's and the loop
+	 * needn't transform transfer.
+	 *
+	 * TODO: the above condition may be loosed in the future, and
+	 * direct I/O may be switched runtime at that time because most
+	 * of requests in sane appplications should be PAGE_SIZE algined
+	 */
+	if (dio) {
+		if (queue_logical_block_size(lo->lo_queue) >= sb_bsize &&
+				!(lo->lo_offset & dio_align) &&
+				mapping->a_ops->direct_IO &&
+				!lo->transfer)
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
+	if (use_dio)
+		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
+	else
+		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
+	blk_mq_unfreeze_queue(lo->lo_queue);
+}
+
 static int
 figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
@@ -421,6 +477,12 @@ struct switch_request {
 	struct completion wait;
 };
 
+static inline void loop_update_dio(struct loop_device *lo)
+{
+	__loop_update_dio(lo, io_is_direct(lo->lo_backing_file) |
+			lo->use_dio);
+}
+
 /*
  * Do the actual switch; called from the BIO completion routine
  */
@@ -441,6 +503,7 @@ static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_update_dio(lo);
 }
 
 /*
@@ -627,11 +690,19 @@ static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
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
@@ -639,6 +710,7 @@ static struct attribute *loop_attrs[] = {
 	&loop_attr_sizelimit.attr,
 	&loop_attr_autoclear.attr,
 	&loop_attr_partscan.attr,
+	&loop_attr_dio.attr,
 	NULL,
 };
 
@@ -770,6 +842,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
+	lo->use_dio = false;
 	lo->lo_blocksize = lo_blocksize;
 	lo->lo_device = bdev;
 	lo->lo_flags = lo_flags;
@@ -783,6 +856,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
+	loop_update_dio(lo);
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 	loop_sysfs_init(lo);
@@ -1001,6 +1075,9 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		lo->lo_key_owner = uid;
 	}
 
+	/* update dio if lo_offset or transfer is changed */
+	__loop_update_dio(lo, lo->use_dio);
+
 	return 0;
 }
 
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
