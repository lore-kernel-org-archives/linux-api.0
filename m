From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] dm: split out a helper to find the ioctl target
Date: Tue,  4 Aug 2015 09:11:10 +0200
Message-ID: <1438672271-11309-6-git-send-email-hch@lst.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438672271-11309-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

We want to reuse this code for the persistent reservation handling,
so move it into a helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 50 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c68eb91..8dfc760 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -556,18 +556,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
-static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned int cmd, unsigned long arg)
+static int dm_get_ioctl_table(struct mapped_device *md,
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
+	if (!(*tgt)->type->ioctl)
 		goto out;
 
 	if (dm_suspended_md(md)) {
@@ -584,10 +583,32 @@ retry:
 		goto out;
 	}
 
-	r = tgt->type->ioctl(tgt, &bdev, &mode);
+	r = (*tgt)->type->ioctl(*tgt, bdev, mode);
 	if (r < 0)
 		goto out;
 
+	return r;
+
+out:
+	dm_put_live_table(md, *srcu_idx);
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
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
+	r = dm_get_ioctl_table(md, &tgt, &bdev, &mode, &srcu_idx);
+	if (r < 0)
+		return r;
+
 	if (r > 0) {
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 		if (r)
@@ -595,15 +616,8 @@ retry:
 	}
 
 	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-
 out:
 	dm_put_live_table(md, srcu_idx);
-
-	if (r == -ENOTCONN) {
-		msleep(10);
-		goto retry;
-	}
-
 	return r;
 }
 
-- 
1.9.1
