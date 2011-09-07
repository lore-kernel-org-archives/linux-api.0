From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/3] nbd: map DISCARD requests to a new nbd request type
Date: Wed,  7 Sep 2011 16:41:43 +0200
Message-ID: <1315406503-7883-4-git-send-email-pbonzini@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Paul Clements <Paul.Clements@steeleye.com>
List-Id: linux-api@vger.kernel.org

When the feature is enabled, set QUEUE_FLAG_DISCARD and transmit those as
NBD_CMD_TRIM requests.

I used "trim" instead of "discard" to avoid confusion with the existing
NBD_CMD_DISC that is used for disconnect.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c |   15 ++++++++++++---
 include/linux/nbd.h |    4 +++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c4fe9c8..71ebaab 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int cmd)
 	case  NBD_CMD_READ: return "read";
 	case NBD_CMD_WRITE: return "write";
 	case  NBD_CMD_DISC: return "disconnect";
+	case  NBD_CMD_TRIM: return "trim (discard)";
 	}
 	return "invalid";
 }
@@ -454,9 +455,13 @@ static void nbd_handle_req(struct nbd_device *lo, struct request *req)
 	if (req->cmd_type != REQ_TYPE_FS)
 		goto error_out;
 
-	if (rq_data_dir(req) == WRITE)
-		nbd_cmd(req) = NBD_CMD_WRITE;
-	else
+	if (rq_data_dir(req) == WRITE) {
+		if ((req->cmd_flags & REQ_DISCARD)) {
+			WARN_ON(!(lo->flags & NBD_FEATURE_TRIM));
+			nbd_cmd(req) = NBD_CMD_TRIM;
+		} else
+			nbd_cmd(req) = NBD_CMD_WRITE;
+	} else
 		nbd_cmd(req) = NBD_CMD_READ;
 
 	req->errors = 0;
@@ -659,6 +664,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 			return -EINVAL;
 
 		mutex_unlock(&lo->tx_lock);
+		if (lo->flags & NBD_FEATURE_TRIM)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+						lo->disk->queue);
 
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
 		if (IS_ERR(thread)) {
@@ -677,6 +685,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		lo->file = NULL;
 		nbd_clear_que(lo);
 		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, lo->disk->queue);
 		if (file)
 			fput(file);
 		lo->flags = 0;
@@ -796,6 +805,9 @@ static int __init nbd_init(void)
 		 * Tell the block layer that we are not a rotational device
 		 */
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		disk->queue->limits.discard_granularity = 512;
+		disk->queue->limits.max_discard_sectors = UINT_MAX;
+		disk->queue->limits.discard_zeroes_data = 0;
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index 926f19d..7048463 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -33,11 +33,13 @@
  * not want any overlap.  Bits 32-63 are reserved because they
  * are inaccessible on 32-bit platforms.  */
 #define NBD_FEATURE_RESERVED	0xFFFFFFFF00000003LL
+#define NBD_FEATURE_TRIM	(1 << 2)
 
 enum {
 	NBD_CMD_READ = 0,
 	NBD_CMD_WRITE = 1,
-	NBD_CMD_DISC = 2
+	NBD_CMD_DISC = 2,
+	NBD_CMD_TRIM = 3
 };
 
 #define nbd_cmd(req) ((req)->cmd[0])
-- 
1.7.6
