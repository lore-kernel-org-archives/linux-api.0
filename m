From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 2/2] block: virtio-blk: support multi virt queues per
	virtio-blk device
Date: Fri, 20 Jun 2014 23:29:40 +0800
Message-ID: <1403278181-28455-3-git-send-email-ming.lei@canonical.com>
References: <1403278181-28455-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1403278181-28455-1-git-send-email-ming.lei@canonical.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

Firstly this patch supports more than one virtual queues for virtio-blk
device.

Secondly this patch maps the virtual queue to blk-mq's hardware queue.

With this approach, both scalability and performance can be improved.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/virtio_blk.c |   70 +++++++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f63d358..7c3d686 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -16,6 +16,8 @@
 
 #define PART_BITS 4
 
+#define MAX_NUM_VQ 16
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -24,8 +26,8 @@ static struct workqueue_struct *virtblk_wq;
 struct virtio_blk
 {
 	struct virtio_device *vdev;
-	struct virtqueue *vq;
-	spinlock_t vq_lock;
+	struct virtqueue *vq[MAX_NUM_VQ];
+	spinlock_t vq_lock[MAX_NUM_VQ];
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -47,6 +49,9 @@ struct virtio_blk
 
 	/* Ida index - used to track minor number allocations. */
 	int index;
+
+	/* num of vqs */
+	int num_vqs;
 };
 
 struct virtblk_req
@@ -133,14 +138,15 @@ static void virtblk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
 	bool req_done = false;
+	int qid = vq->index;
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
+	spin_lock_irqsave(&vblk->vq_lock[qid], flags);
 	do {
 		virtqueue_disable_cb(vq);
-		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
+		while ((vbr = virtqueue_get_buf(vblk->vq[qid], &len)) != NULL) {
 			blk_mq_complete_request(vbr->req);
 			req_done = true;
 		}
@@ -151,7 +157,7 @@ static void virtblk_done(struct virtqueue *vq)
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vq_lock[qid], flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -160,6 +166,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
 	unsigned int num;
+	int qid = hctx->queue_num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
 	bool notify = false;
@@ -202,12 +209,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 	}
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
-	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
+	spin_lock_irqsave(&vblk->vq_lock[qid], flags);
+	err = __virtblk_add_req(vblk->vq[qid], vbr, vbr->sg, num);
 	if (err) {
-		virtqueue_kick(vblk->vq);
+		virtqueue_kick(vblk->vq[qid]);
 		blk_mq_stop_hw_queue(hctx);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
+		spin_unlock_irqrestore(&vblk->vq_lock[qid], flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
@@ -215,12 +222,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
-	if (last && virtqueue_kick_prepare(vblk->vq))
+	if (last && virtqueue_kick_prepare(vblk->vq[qid]))
 		notify = true;
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vq_lock[qid], flags);
 
 	if (notify)
-		virtqueue_notify(vblk->vq);
+		virtqueue_notify(vblk->vq[qid]);
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
@@ -377,12 +384,35 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 static int init_vq(struct virtio_blk *vblk)
 {
 	int err = 0;
+	int i;
+	vq_callback_t *callbacks[MAX_NUM_VQ];
+	const char *names[MAX_NUM_VQ];
+	unsigned short num_vqs;
+	struct virtio_device *vdev = vblk->vdev;
 
-	/* We expect one virtqueue, for output. */
-	vblk->vq = virtio_find_single_vq(vblk->vdev, virtblk_done, "requests");
-	if (IS_ERR(vblk->vq))
-		err = PTR_ERR(vblk->vq);
+	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
+				   struct virtio_blk_config, num_queues,
+				   &num_vqs);
+	if (err)
+		num_vqs = 1;
+	if (num_vqs > MAX_NUM_VQ)
+		num_vqs = MAX_NUM_VQ;
 
+	for (i = 0; i < num_vqs; i++) {
+		callbacks[i] = virtblk_done;
+		names[i] = "requests";
+	}
+
+	/* Discover virtqueues and write information to configuration.  */
+	err = vdev->config->find_vqs(vdev, num_vqs, vblk->vq,
+			callbacks, names);
+	if (err)
+		goto out;
+
+	for (i = 0; i < num_vqs; i++)
+		spin_lock_init(&vblk->vq_lock[i]);
+	vblk->num_vqs = num_vqs;
+out:
 	return err;
 }
 
@@ -551,7 +581,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = init_vq(vblk);
 	if (err)
 		goto out_free_vblk;
-	spin_lock_init(&vblk->vq_lock);
 
 	/* FIXME: How many partitions?  How long is a piece of string? */
 	vblk->disk = alloc_disk(1 << PART_BITS);
@@ -562,7 +591,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	/* Default queue sizing is to fill the ring. */
 	if (!virtblk_queue_depth) {
-		virtblk_queue_depth = vblk->vq->num_free;
+		virtblk_queue_depth = vblk->vq[0]->num_free;
 		/* ... but without indirect descs, we use 2 descs per req */
 		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
 			virtblk_queue_depth /= 2;
@@ -570,7 +599,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
 	vblk->tag_set.ops = &virtio_mq_ops;
-	vblk->tag_set.nr_hw_queues = 1;
 	vblk->tag_set.queue_depth = virtblk_queue_depth;
 	vblk->tag_set.numa_node = NUMA_NO_NODE;
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
@@ -578,6 +606,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		sizeof(struct virtblk_req) +
 		sizeof(struct scatterlist) * sg_elems;
 	vblk->tag_set.driver_data = vblk;
+	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
 	err = blk_mq_alloc_tag_set(&vblk->tag_set);
 	if (err)
@@ -777,7 +806,8 @@ static const struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
-	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE
+	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
+	VIRTIO_BLK_F_MQ,
 };
 
 static struct virtio_driver virtio_blk = {
-- 
1.7.9.5
