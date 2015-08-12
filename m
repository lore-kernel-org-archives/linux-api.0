From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] dm: refactor ioctl handling
Date: Wed, 12 Aug 2015 08:23:23 +0200
Message-ID: <1439360604-16192-5-git-send-email-hch@lst.de>
References: <1439360604-16192-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439360604-16192-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This moves the call to blkdev_ioctl and the argument checking to core code,
and only leaves a callout to find the block device to operate on it the
targets.  This will simplifies the code and will allow us to pass through
ioctl-like command using other methods in the next patch.

Also split out a helper around calling the prepare_ioctl method that will
be reused for persistent reservation handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-flakey.c        | 16 +++++++-------
 drivers/md/dm-linear.c        | 14 ++++++------
 drivers/md/dm-log-writes.c    | 13 ++++++-----
 drivers/md/dm-mpath.c         | 32 +++++++++++----------------
 drivers/md/dm-switch.c        | 21 ++++++++----------
 drivers/md/dm-verity.c        | 15 ++++++-------
 drivers/md/dm.c               | 50 ++++++++++++++++++++++++++++++++-----------
 include/linux/device-mapper.h |  6 +++---
 8 files changed, 89 insertions(+), 78 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 0448124..e314e49 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -371,20 +371,20 @@ static void flakey_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
+static int flakey_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct flakey_c *fc = ti->private;
-	struct dm_dev *dev = fc->dev;
-	int r = 0;
+
+	*bdev = fc->dev->bdev;
 
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
 	if (fc->start ||
-	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-
-	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+	    ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
+		return 1;
+	return 0;
 }
 
 static int flakey_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -418,7 +418,7 @@ static struct target_type flakey_target = {
 	.map    = flakey_map,
 	.end_io = flakey_end_io,
 	.status = flakey_status,
-	.ioctl	= flakey_ioctl,
+	.prepare_ioctl = flakey_prepare_ioctl,
 	.merge	= flakey_merge,
 	.iterate_devices = flakey_iterate_devices,
 };
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 53e848c..f81f68e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -113,21 +113,21 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
-			unsigned long arg)
+static int linear_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
 	struct dm_dev *dev = lc->dev;
-	int r = 0;
+
+	*bdev = dev->bdev;
 
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
 	if (lc->start ||
 	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-
-	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+		return 1;
+	return 0;
 }
 
 static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -161,7 +161,7 @@ static struct target_type linear_target = {
 	.dtr    = linear_dtr,
 	.map    = linear_map,
 	.status = linear_status,
-	.ioctl  = linear_ioctl,
+	.prepare_ioctl = linear_prepare_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
 };
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index e9d1748..9601d9d 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -709,20 +709,19 @@ static void log_writes_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int log_writes_ioctl(struct dm_target *ti, unsigned int cmd,
-			    unsigned long arg)
+static int log_writes_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct log_writes_c *lc = ti->private;
 	struct dm_dev *dev = lc->dev;
-	int r = 0;
 
+	*bdev = dev->bdev;
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
 	if (ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-
-	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+		return 1;
+	return 0;
 }
 
 static int log_writes_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -792,7 +791,7 @@ static struct target_type log_writes_target = {
 	.map    = log_writes_map,
 	.end_io = normal_end_io,
 	.status = log_writes_status,
-	.ioctl	= log_writes_ioctl,
+	.prepare_ioctl = log_writes_prepare_ioctl,
 	.merge	= log_writes_merge,
 	.message = log_writes_message,
 	.iterate_devices = log_writes_iterate_devices,
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index eff7bdd..97cf835 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1548,18 +1548,14 @@ out:
 	return r;
 }
 
-static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
-			   unsigned long arg)
+static int multipath_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct multipath *m = ti->private;
 	struct pgpath *pgpath;
-	struct block_device *bdev;
-	fmode_t mode;
 	unsigned long flags;
 	int r;
 
-	bdev = NULL;
-	mode = 0;
 	r = 0;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1570,26 +1566,17 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	pgpath = m->current_pgpath;
 
 	if (pgpath) {
-		bdev = pgpath->path.dev->bdev;
-		mode = pgpath->path.dev->mode;
+		*bdev = pgpath->path.dev->bdev;
+		*mode = pgpath->path.dev->mode;
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
 		r = -ENOTCONN;
-	else if (!bdev)
+	else if (!*bdev)
 		r = -EIO;
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	/*
-	 * Only pass ioctls through if the device sizes match exactly.
-	 */
-	if (!bdev || ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT) {
-		int err = scsi_verify_blk_ioctl(NULL, cmd);
-		if (err)
-			r = err;
-	}
-
 	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
 		spin_lock_irqsave(&m->lock, flags);
 		if (!m->current_pg) {
@@ -1602,7 +1589,12 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 		dm_table_run_md_queue_async(m->ti->table);
 	}
 
-	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!r && ti->len != i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
+		return 1;
+	return r;
 }
 
 static int multipath_iterate_devices(struct dm_target *ti,
@@ -1718,7 +1710,7 @@ static struct target_type multipath_target = {
 	.resume = multipath_resume,
 	.status = multipath_status,
 	.message = multipath_message,
-	.ioctl  = multipath_ioctl,
+	.prepare_ioctl = multipath_prepare_ioctl,
 	.iterate_devices = multipath_iterate_devices,
 	.busy = multipath_busy,
 };
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 50fca46..b128575 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -511,27 +511,24 @@ static void switch_status(struct dm_target *ti, status_type_t type,
  *
  * Passthrough all ioctls to the path for sector 0
  */
-static int switch_ioctl(struct dm_target *ti, unsigned cmd,
-			unsigned long arg)
+static int switch_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct switch_ctx *sctx = ti->private;
-	struct block_device *bdev;
-	fmode_t mode;
 	unsigned path_nr;
-	int r = 0;
 
 	path_nr = switch_get_path_nr(sctx, 0);
 
-	bdev = sctx->path_list[path_nr].dmdev->bdev;
-	mode = sctx->path_list[path_nr].dmdev->mode;
+	*bdev = sctx->path_list[path_nr].dmdev->bdev;
+	*mode = sctx->path_list[path_nr].dmdev->mode;
 
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
-	if (ti->len + sctx->path_list[path_nr].start != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-
-	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+	if (ti->len + sctx->path_list[path_nr].start !=
+	    i_size_read((*bdev)->bd_inode) >> SECTOR_SHIFT)
+		return 1;
+	return 0;
 }
 
 static int switch_iterate_devices(struct dm_target *ti,
@@ -560,7 +557,7 @@ static struct target_type switch_target = {
 	.map = switch_map,
 	.message = switch_message,
 	.status = switch_status,
-	.ioctl = switch_ioctl,
+	.prepare_ioctl = switch_prepare_ioctl,
 	.iterate_devices = switch_iterate_devices,
 };
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 4b34df8..ce1764c 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -635,18 +635,17 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int verity_ioctl(struct dm_target *ti, unsigned cmd,
-			unsigned long arg)
+static int verity_prepare_ioctl(struct dm_target *ti,
+		struct block_device **bdev, fmode_t *mode)
 {
 	struct dm_verity *v = ti->private;
-	int r = 0;
+
+	*bdev = v->data_dev->bdev;
 
 	if (v->data_start ||
 	    ti->len != i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-
-	return r ? : __blkdev_driver_ioctl(v->data_dev->bdev, v->data_dev->mode,
-				     cmd, arg);
+		return 1;
+	return 0;
 }
 
 static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -995,7 +994,7 @@ static struct target_type verity_target = {
 	.dtr		= verity_dtr,
 	.map		= verity_map,
 	.status		= verity_status,
-	.ioctl		= verity_ioctl,
+	.prepare_ioctl	= verity_prepare_ioctl,
 	.merge		= verity_merge,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7f367fc..49e4719 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -556,18 +556,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
-static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned int cmd, unsigned long arg)
+static int dm_get_live_table_for_ioctl(struct mapped_device *md,
+		struct dm_target **tgt, struct block_device **bdev,
+		fmode_t *mode, int *srcu_idx)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	int srcu_idx;
 	struct dm_table *map;
-	struct dm_target *tgt;
-	int r = -ENOTTY;
+	int r;
 
 retry:
-	map = dm_get_live_table(md, &srcu_idx);
-
+	r = -ENOTTY;
+	map = dm_get_live_table(md, srcu_idx);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -575,8 +573,9 @@ retry:
 	if (dm_table_get_num_targets(map) != 1)
 		goto out;
 
-	tgt = dm_table_get_target(map, 0);
-	if (!tgt->type->ioctl)
+	*tgt = dm_table_get_target(map, 0);
+
+	if (!(*tgt)->type->prepare_ioctl)
 		goto out;
 
 	if (dm_suspended_md(md)) {
@@ -584,16 +583,41 @@ retry:
 		goto out;
 	}
 
-	r = tgt->type->ioctl(tgt, cmd, arg);
+	r = (*tgt)->type->prepare_ioctl(*tgt, bdev, mode);
+	if (r < 0)
+		goto out;
 
-out:
-	dm_put_live_table(md, srcu_idx);
+	return r;
 
+out:
+	dm_put_live_table(md, *srcu_idx);
 	if (r == -ENOTCONN) {
 		msleep(10);
 		goto retry;
 	}
+	return r;
+}
+
+static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
+			unsigned int cmd, unsigned long arg)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct dm_target *tgt;
+	int srcu_idx, r;
+
+	r = dm_get_live_table_for_ioctl(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
+	if (r > 0) {
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+		if (r)
+			goto out;
+	}
 
+	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+out:
+	dm_put_live_table(md, srcu_idx);
 	return r;
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 51cc1de..9f1e7e9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -79,8 +79,8 @@ typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
 
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
-typedef int (*dm_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
-			    unsigned long arg);
+typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti,
+			    struct block_device **bdev, fmode_t *mode);
 
 typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
 			    struct bio_vec *biovec, int max_size);
@@ -159,7 +159,7 @@ struct target_type {
 	dm_resume_fn resume;
 	dm_status_fn status;
 	dm_message_fn message;
-	dm_ioctl_fn ioctl;
+	dm_prepare_ioctl_fn prepare_ioctl;
 	dm_merge_fn merge;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
-- 
1.9.1
