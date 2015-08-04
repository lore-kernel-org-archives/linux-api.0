From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] dm: refactor ioctl handling
Date: Tue,  4 Aug 2015 09:11:09 +0200
Message-ID: <1438672271-11309-5-git-send-email-hch@lst.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438672271-11309-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This moves the call to blkdev_ioctl and the argument checking to core code,
and only leaves a callout to find the block device to operate on it the
targets.  This will simplifies the code and will allow us to pass through
ioctl-like command using other methods in the next patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-flakey.c        | 14 +++++++-------
 drivers/md/dm-linear.c        | 12 ++++++------
 drivers/md/dm-log-writes.c    | 11 +++++------
 drivers/md/dm-mpath.c         | 30 +++++++++++-------------------
 drivers/md/dm-switch.c        | 19 ++++++++-----------
 drivers/md/dm-verity.c        | 13 ++++++-------
 drivers/md/dm.c               | 12 +++++++++++-
 include/linux/device-mapper.h |  4 ++--
 8 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b257e46..ec4ebc8 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -371,20 +371,20 @@ static void flakey_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
+static int flakey_ioctl(struct dm_target *ti, struct block_device **bdev,
+		fmode_t *mode)
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
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 53e848c..d897707 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -113,21 +113,21 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
-			unsigned long arg)
+static int linear_ioctl(struct dm_target *ti, struct block_device **bdev,
+		fmode_t *mode)
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
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index ad1b049..811fc42 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -712,20 +712,19 @@ static void log_writes_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int log_writes_ioctl(struct dm_target *ti, unsigned int cmd,
-			    unsigned long arg)
+static int log_writes_ioctl(struct dm_target *ti, struct block_device **bdev,
+		fmode_t *mode)
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
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index eff7bdd..8670597 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1548,18 +1548,14 @@ out:
 	return r;
 }
 
-static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
-			   unsigned long arg)
+static int multipath_ioctl(struct dm_target *ti,
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
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 50fca46..37d27e9 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -511,27 +511,24 @@ static void switch_status(struct dm_target *ti, status_type_t type,
  *
  * Passthrough all ioctls to the path for sector 0
  */
-static int switch_ioctl(struct dm_target *ti, unsigned cmd,
-			unsigned long arg)
+static int switch_ioctl(struct dm_target *ti,
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
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index bb9c6a0..bd20c41 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -634,18 +634,17 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int verity_ioctl(struct dm_target *ti, unsigned cmd,
-			unsigned long arg)
+static int verity_ioctl(struct dm_target *ti, struct block_device **bdev,
+		fmode_t *mode)
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
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f331d88..c68eb91 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -584,7 +584,17 @@ retry:
 		goto out;
 	}
 
-	r = tgt->type->ioctl(tgt, cmd, arg);
+	r = tgt->type->ioctl(tgt, &bdev, &mode);
+	if (r < 0)
+		goto out;
+
+	if (r > 0) {
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+		if (r)
+			goto out;
+	}
+
+	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 
 out:
 	dm_put_live_table(md, srcu_idx);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 51cc1de..9b73138 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -79,8 +79,8 @@ typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
 
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
-typedef int (*dm_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
-			    unsigned long arg);
+typedef int (*dm_ioctl_fn) (struct dm_target *ti,
+			    struct block_device **bdev, fmode_t *mode);
 
 typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
 			    struct bio_vec *biovec, int max_size);
-- 
1.9.1
