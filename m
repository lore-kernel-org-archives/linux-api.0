From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v6 16/46] virtio_blk: v1.0 support
Date: Thu, 27 Nov 2014 22:09:08 +0200
Message-ID: <1417118789-18231-17-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Based on patch by Cornelia Huck.

Note: for consistency, and to avoid sparse errors,
      convert all fields, even those no longer in use
      for virtio v1.0.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_blk.h | 15 ++++-----
 drivers/block/virtio_blk.c      | 70 ++++++++++++++++++++++++-----------------
 2 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 9ad67b2..247c8ba 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 
 /* Feature bits */
 #define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
@@ -114,18 +115,18 @@ struct virtio_blk_config {
 /* This is the first element of the read scatter-gather list. */
 struct virtio_blk_outhdr {
 	/* VIRTIO_BLK_T* */
-	__u32 type;
+	__virtio32 type;
 	/* io priority. */
-	__u32 ioprio;
+	__virtio32 ioprio;
 	/* Sector (ie. 512 byte offset) */
-	__u64 sector;
+	__virtio64 sector;
 };
 
 struct virtio_scsi_inhdr {
-	__u32 errors;
-	__u32 data_len;
-	__u32 sense_len;
-	__u32 residual;
+	__virtio32 errors;
+	__virtio32 data_len;
+	__virtio32 sense_len;
+	__virtio32 residual;
 };
 
 /* And this is the final byte of the write scatter-gather list. */
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c6a27d5..f601f16 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -80,7 +80,7 @@ static int __virtblk_add_req(struct virtqueue *vq,
 {
 	struct scatterlist hdr, status, cmd, sense, inhdr, *sgs[6];
 	unsigned int num_out = 0, num_in = 0;
-	int type = vbr->out_hdr.type & ~VIRTIO_BLK_T_OUT;
+	__virtio32 type = vbr->out_hdr.type & ~cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT);
 
 	sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
 	sgs[num_out++] = &hdr;
@@ -91,19 +91,19 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	 * block, and before the normal inhdr we put the sense data and the
 	 * inhdr with additional status information.
 	 */
-	if (type == VIRTIO_BLK_T_SCSI_CMD) {
+	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
 		sg_init_one(&cmd, vbr->req->cmd, vbr->req->cmd_len);
 		sgs[num_out++] = &cmd;
 	}
 
 	if (have_data) {
-		if (vbr->out_hdr.type & VIRTIO_BLK_T_OUT)
+		if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
 			sgs[num_out++] = data_sg;
 		else
 			sgs[num_out + num_in++] = data_sg;
 	}
 
-	if (type == VIRTIO_BLK_T_SCSI_CMD) {
+	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
 		sg_init_one(&sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
 		sgs[num_out + num_in++] = &sense;
 		sg_init_one(&inhdr, &vbr->in_hdr, sizeof(vbr->in_hdr));
@@ -119,12 +119,13 @@ static int __virtblk_add_req(struct virtqueue *vq,
 static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+	struct virtio_blk *vblk = req->q->queuedata;
 	int error = virtblk_result(vbr);
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		req->resid_len = vbr->in_hdr.residual;
-		req->sense_len = vbr->in_hdr.sense_len;
-		req->errors = vbr->in_hdr.errors;
+		req->resid_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
+		req->sense_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
+		req->errors = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
 	} else if (req->cmd_type == REQ_TYPE_SPECIAL) {
 		req->errors = (error != 0);
 	}
@@ -173,25 +174,25 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 
 	vbr->req = req;
 	if (req->cmd_flags & REQ_FLUSH) {
-		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+		vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_FLUSH);
 		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+		vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
 	} else {
 		switch (req->cmd_type) {
 		case REQ_TYPE_FS:
 			vbr->out_hdr.type = 0;
-			vbr->out_hdr.sector = blk_rq_pos(vbr->req);
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.sector = cpu_to_virtio64(vblk->vdev, blk_rq_pos(vbr->req));
+			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
 			break;
 		case REQ_TYPE_BLOCK_PC:
-			vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
+			vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_SCSI_CMD);
 			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
 			break;
 		case REQ_TYPE_SPECIAL:
-			vbr->out_hdr.type = VIRTIO_BLK_T_GET_ID;
+			vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
 			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
 			break;
 		default:
 			/* We don't put anything else in the queue. */
@@ -204,9 +205,9 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 	num = blk_rq_map_sg(hctx->queue, vbr->req, vbr->sg);
 	if (num) {
 		if (rq_data_dir(vbr->req) == WRITE)
-			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
+			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
 		else
-			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
+			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
@@ -476,7 +477,8 @@ static int virtblk_get_cache_mode(struct virtio_device *vdev)
 				   struct virtio_blk_config, wce,
 				   &writeback);
 	if (err)
-		writeback = virtio_has_feature(vdev, VIRTIO_BLK_F_WCE);
+		writeback = virtio_has_feature(vdev, VIRTIO_BLK_F_WCE) ||
+		            virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
 
 	return writeback;
 }
@@ -821,25 +823,35 @@ static const struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
-static unsigned int features[] = {
+static unsigned int features_legacy[] = {
 	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
 	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
 	VIRTIO_BLK_F_MQ,
+}
+;
+static unsigned int features[] = {
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
+	VIRTIO_BLK_F_TOPOLOGY,
+	VIRTIO_BLK_F_MQ,
+	VIRTIO_F_VERSION_1,
 };
 
 static struct virtio_driver virtio_blk = {
-	.feature_table		= features,
-	.feature_table_size	= ARRAY_SIZE(features),
-	.driver.name		= KBUILD_MODNAME,
-	.driver.owner		= THIS_MODULE,
-	.id_table		= id_table,
-	.probe			= virtblk_probe,
-	.remove			= virtblk_remove,
-	.config_changed		= virtblk_config_changed,
+	.feature_table			= features,
+	.feature_table_size		= ARRAY_SIZE(features),
+	.feature_table_legacy		= features_legacy,
+	.feature_table_size_legacy	= ARRAY_SIZE(features_legacy),
+	.driver.name			= KBUILD_MODNAME,
+	.driver.owner			= THIS_MODULE,
+	.id_table			= id_table,
+	.probe				= virtblk_probe,
+	.remove				= virtblk_remove,
+	.config_changed			= virtblk_config_changed,
 #ifdef CONFIG_PM_SLEEP
-	.freeze			= virtblk_freeze,
-	.restore		= virtblk_restore,
+	.freeze				= virtblk_freeze,
+	.restore			= virtblk_restore,
 #endif
 };
 
-- 
MST
