From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] dm: add support for passing through persistent reservations
Date: Wed, 26 Aug 2015 18:56:54 +0200
Message-ID: <1440608214-14497-6-git-send-email-hch@lst.de>
References: <1440608214-14497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440608214-14497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds support to pass through persistent reservation requests
similar to the existing ioctl handling, and with the same limitations,
e.g. devices may only have a single target attached.

This is mostly intended for multipathing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 85dc14c..c3eadbe 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -24,6 +24,7 @@
 #include <linux/ktime.h>
 #include <linux/elevator.h> /* for rq_end_sector() */
 #include <linux/blk-mq.h>
+#include <linux/pr.h>
 
 #include <trace/events/block.h>
 
@@ -3544,11 +3545,133 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
+static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+		u32 flags)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	struct dm_target *tgt;
+	fmode_t mode;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_register)
+		r = ops->pr_register(bdev, old_key, new_key, flags);
+	else
+		r = -EOPNOTSUPP;
+
+	dm_put_live_table(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
+		u32 flags)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	struct dm_target *tgt;
+	fmode_t mode;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_reserve)
+		r = ops->pr_reserve(bdev, key, type, flags);
+	else
+		r = -EOPNOTSUPP;
+
+	dm_put_live_table(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	struct dm_target *tgt;
+	fmode_t mode;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_release)
+		r = ops->pr_release(bdev, key, type);
+	else
+		r = -EOPNOTSUPP;
+
+	dm_put_live_table(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
+		enum pr_type type, bool abort)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	struct dm_target *tgt;
+	fmode_t mode;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_preempt)
+		r = ops->pr_preempt(bdev, old_key, new_key, type, abort);
+	else
+		r = -EOPNOTSUPP;
+
+	dm_put_live_table(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_clear(struct block_device *bdev, u64 key)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	struct dm_target *tgt;
+	fmode_t mode;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_clear)
+		r = ops->pr_clear(bdev, key);
+	else
+		r = -EOPNOTSUPP;
+
+	dm_put_live_table(md, srcu_idx);
+	return r;
+}
+
+static const struct pr_ops dm_pr_ops = {
+	.pr_register	= dm_pr_register,
+	.pr_reserve	= dm_pr_reserve,
+	.pr_release	= dm_pr_release,
+	.pr_preempt	= dm_pr_preempt,
+	.pr_clear	= dm_pr_clear,
+};
+
 static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
 };
 
-- 
1.9.1
