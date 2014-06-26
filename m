From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 2/2] block: virtio-blk: support multi virt queues per
	virtio-blk device
Date: Thu, 26 Jun 2014 17:41:48 +0800
Message-ID: <1403775708-22244-3-git-send-email-ming.lei@canonical.com>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1403775708-22244-1-git-send-email-ming.lei@canonical.com>
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
 drivers/block/virtio_blk.c |  104 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 84 insertions(+), 20 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f63d358..0a58140 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -15,17 +15,22 @@
 #include <linux/numa.h>
 
 #define PART_BITS 4
+#define VQ_NAME_LEN 16
 
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
 static struct workqueue_struct *virtblk_wq;
 
+struct virtio_blk_vq {
+	struct virtqueue *vq;
+	spinlock_t lock;
+	char name[VQ_NAME_LEN];
+} ____cacheline_aligned_in_smp;
+
 struct virtio_blk
 {
 	struct virtio_device *vdev;
-	struct virtqueue *vq;
-	spinlock_t vq_lock;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -47,6 +52,10 @@ struct virtio_blk
 
 	/* Ida index - used to track minor number allocations. */
 	int index;
+
+	/* num of vqs */
+	int num_vqs;
+	struct virtio_blk_vq *vqs;
 };
 
 struct virtblk_req
@@ -133,14 +142,15 @@ static void virtblk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
 	bool req_done = false;
+	int qid = vq->index;
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
+	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
-		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
+		while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
 			blk_mq_complete_request(vbr->req);
 			req_done = true;
 		}
@@ -151,7 +161,7 @@ static void virtblk_done(struct virtqueue *vq)
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -160,6 +170,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
 	unsigned int num;
+	int qid = hctx->queue_num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
 	bool notify = false;
@@ -202,12 +213,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 	}
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
-	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
+	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
+	err = __virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
 	if (err) {
-		virtqueue_kick(vblk->vq);
+		virtqueue_kick(vblk->vqs[qid].vq);
 		blk_mq_stop_hw_queue(hctx);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
+		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
@@ -215,12 +226,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
-	if (last && virtqueue_kick_prepare(vblk->vq))
+	if (last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
 		notify = true;
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 
 	if (notify)
-		virtqueue_notify(vblk->vq);
+		virtqueue_notify(vblk->vqs[qid].vq);
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
@@ -377,12 +388,64 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 static int init_vq(struct virtio_blk *vblk)
 {
 	int err = 0;
+	int i;
+	vq_callback_t **callbacks;
+	const char **names;
+	struct virtqueue **vqs;
+	unsigned short num_vqs;
+	struct virtio_device *vdev = vblk->vdev;
+
+	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
+				   struct virtio_blk_config, num_queues,
+				   &num_vqs);
+	if (err)
+		num_vqs = 1;
+
+	vblk->vqs = kmalloc(sizeof(*vblk->vqs) * num_vqs, GFP_KERNEL);
+	if (!vblk->vqs) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	names = kmalloc(sizeof(*names) * num_vqs, GFP_KERNEL);
+	if (!names)
+		goto err_names;
+
+	callbacks = kmalloc(sizeof(*callbacks) * num_vqs, GFP_KERNEL);
+	if (!callbacks)
+		goto err_callbacks;
+
+	vqs = kmalloc(sizeof(*vqs) * num_vqs, GFP_KERNEL);
+	if (!vqs)
+		goto err_vqs;
 
-	/* We expect one virtqueue, for output. */
-	vblk->vq = virtio_find_single_vq(vblk->vdev, virtblk_done, "requests");
-	if (IS_ERR(vblk->vq))
-		err = PTR_ERR(vblk->vq);
+	for (i = 0; i < num_vqs; i++) {
+		callbacks[i] = virtblk_done;
+		snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req.%d", i);
+		names[i] = vblk->vqs[i].name;
+	}
+
+	/* Discover virtqueues and write information to configuration.  */
+	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
+	if (err)
+		goto err_find_vqs;
 
+	for (i = 0; i < num_vqs; i++) {
+		spin_lock_init(&vblk->vqs[i].lock);
+		vblk->vqs[i].vq = vqs[i];
+	}
+	vblk->num_vqs = num_vqs;
+
+ err_find_vqs:
+	kfree(vqs);
+ err_vqs:
+	kfree(callbacks);
+ err_callbacks:
+	kfree(names);
+ err_names:
+	if (err)
+		kfree(vblk->vqs);
+ out:
 	return err;
 }
 
@@ -551,7 +614,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = init_vq(vblk);
 	if (err)
 		goto out_free_vblk;
-	spin_lock_init(&vblk->vq_lock);
 
 	/* FIXME: How many partitions?  How long is a piece of string? */
 	vblk->disk = alloc_disk(1 << PART_BITS);
@@ -562,7 +624,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	/* Default queue sizing is to fill the ring. */
 	if (!virtblk_queue_depth) {
-		virtblk_queue_depth = vblk->vq->num_free;
+		virtblk_queue_depth = vblk->vqs[0].vq->num_free;
 		/* ... but without indirect descs, we use 2 descs per req */
 		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
 			virtblk_queue_depth /= 2;
@@ -570,7 +632,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	memset(&vblk->tag_set, 0, sizeof(vblk->tag_set));
 	vblk->tag_set.ops = &virtio_mq_ops;
-	vblk->tag_set.nr_hw_queues = 1;
 	vblk->tag_set.queue_depth = virtblk_queue_depth;
 	vblk->tag_set.numa_node = NUMA_NO_NODE;
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
@@ -578,6 +639,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 		sizeof(struct virtblk_req) +
 		sizeof(struct scatterlist) * sg_elems;
 	vblk->tag_set.driver_data = vblk;
+	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
 	err = blk_mq_alloc_tag_set(&vblk->tag_set);
 	if (err)
@@ -727,6 +789,7 @@ static void virtblk_remove(struct virtio_device *vdev)
 	refc = atomic_read(&disk_to_dev(vblk->disk)->kobj.kref.refcount);
 	put_disk(vblk->disk);
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
 	kfree(vblk);
 
 	/* Only free device id if we don't have any users */
@@ -777,7 +840,8 @@ static const struct virtio_device_id id_table[] = {
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
