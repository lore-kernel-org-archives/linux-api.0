From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] block: Add part_stat_read_accum to read across field entries.
Date: Wed, 18 Jul 2018 04:47:37 -0700
Message-ID: <20180718114741.2580313-3-tj@kernel.org>
References: <20180718114741.2580313-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718114741.2580313-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: michaelcallahan@fb.com, newella@fb.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

From: Michael Callahan <michaelcallahan@fb.com>

Add a part_stat_read_accum macro to genhd.h to read and sum across
field entries.  For example to sum up the number read and write
sectors completed.  In addition to being ar reasonable cleanup by
itself this will make it easier to add new stat fields in the future.

tj: Refreshed on top of v4.17.

Signed-off-by: Michael Callahan <michaelcallahan@fb.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 3 +--
 drivers/block/drbd/drbd_worker.c   | 4 +---
 drivers/md/md.c                    | 3 +--
 include/linux/genhd.h              | 4 ++++
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a36a30795c43..75f6b47169e6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2674,8 +2674,7 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 	if (c_min_rate == 0)
 		return false;
 
-	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
-		      (int)part_stat_read(&disk->part0, sectors[1]) -
+	curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
 			atomic_read(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 5e793dd7adfb..b8f77e83d456 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1690,9 +1690,7 @@ void drbd_rs_controller_reset(struct drbd_device *device)
 	atomic_set(&device->rs_sect_in, 0);
 	atomic_set(&device->rs_sect_ev, 0);
 	device->rs_in_flight = 0;
-	device->rs_last_events =
-		(int)part_stat_read(&disk->part0, sectors[0]) +
-		(int)part_stat_read(&disk->part0, sectors[1]);
+	device->rs_last_events = (int)part_stat_read_accum(&disk->part0, sectors);
 
 	/* Updating the RCU protected object in place is necessary since
 	   this function gets called from atomic context.
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 994aed2f9dff..dabe36723d60 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8046,8 +8046,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
-		curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
-			      (int)part_stat_read(&disk->part0, sectors[1]) -
+		curr_events = (int)part_stat_read_accum(&disk->part0, sectors) -
 			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6cb8a5789668..19f36fa10995 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -353,6 +353,10 @@ static inline void free_part_stats(struct hd_struct *part)
 
 #endif /* CONFIG_SMP */
 
+#define part_stat_read_accum(part, field)				\
+	(part_stat_read(part, field[0]) +				\
+	 part_stat_read(part, field[1]))
+
 #define part_stat_add(cpu, part, field, addnd)	do {			\
 	__part_stat_add((cpu), (part), field, addnd);			\
 	if ((part)->partno)						\
-- 
2.17.1
