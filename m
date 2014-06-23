From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
Date: Mon, 23 Jun 2014 09:47:00 +0300
Message-ID: <20140623064700.GA13810@redhat.com>
References: <1403278181-28455-1-git-send-email-ming.lei@canonical.com>
 <1403278181-28455-3-git-send-email-ming.lei@canonical.com>
 <20140622102448.GB17067@redhat.com>
 <20140623034251.GR4453@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140623034251.GR4453@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 23, 2014 at 01:42:51PM +1000, Dave Chinner wrote:
> On Sun, Jun 22, 2014 at 01:24:48PM +0300, Michael S. Tsirkin wrote:
> > On Fri, Jun 20, 2014 at 11:29:40PM +0800, Ming Lei wrote:
> > > @@ -24,8 +26,8 @@ static struct workqueue_struct *virtblk_wq;
> > >  struct virtio_blk
> > >  {
> > >  	struct virtio_device *vdev;
> > > -	struct virtqueue *vq;
> > > -	spinlock_t vq_lock;
> > > +	struct virtqueue *vq[MAX_NUM_VQ];
> > > +	spinlock_t vq_lock[MAX_NUM_VQ];
> > 
> > array of struct {
> >     *vq;
> >     spinlock_t lock;
> > }
> > would use more memory but would get us better locality.
> > It might even make sense to add padding to avoid
> > cacheline sharing between two unrelated VQs.
> > Want to try?
> 
> It's still false sharing because the queue objects share cachelines.
> To operate without contention they have to be physically separated
> from each other like so:
> 
> struct vq {
> 	struct virtqueue	*q;
> 	spinlock_t		lock;
> } ____cacheline_aligned_in_smp;

Exacly, that's what I meant by padding above.

> struct some_other_struct {
> 	....
> 	struct vq	vq[MAX_NUM_VQ];
> 	....
> };
> 
> This keeps locality to objects within a queue, but separates each
> queue onto it's own cacheline....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org

To reduce the amount of memory wasted, we could add
the lock in the VQ itself.
Wastes 8 bytes of memory for devices which don't need it, but
we can save it elsewhere (e.g. get rid of the list and
the priv pointer).

How's this?  Your patch would go on top.
Care benchmarking and telling us whether it makes sense?
If yes please let me know and I'll send an official patchset.

-->

virtio-blk: move spinlock to vq itself

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b46671e..0951b21 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -19,6 +19,7 @@
  * @priv: a pointer for the virtqueue implementation to use.
  * @index: the zero-based ordinal number for this queue.
  * @num_free: number of elements we expect to be able to fit.
+ * @lock: lock for optional use by devices. If used, devices must initialize it.
  *
  * A note on @num_free: with indirect buffers, each buffer needs one
  * element in the queue, otherwise a buffer will need one element per
@@ -31,6 +32,7 @@ struct virtqueue {
 	struct virtio_device *vdev;
 	unsigned int index;
 	unsigned int num_free;
+	spinlock_t lock;
 	void *priv;
 };
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f63d358..a3cdc19 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -25,7 +25,6 @@ struct virtio_blk
 {
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
-	spinlock_t vq_lock;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
@@ -137,7 +136,7 @@ static void virtblk_done(struct virtqueue *vq)
 	unsigned long flags;
 	unsigned int len;
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
+	spin_lock_irqsave(&vblk->vq->lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
@@ -151,7 +150,7 @@ static void virtblk_done(struct virtqueue *vq)
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vq->lock, flags);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -202,12 +201,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 	}
 
-	spin_lock_irqsave(&vblk->vq_lock, flags);
+	spin_lock_irqsave(&vblk->vq->lock, flags);
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
 	if (err) {
 		virtqueue_kick(vblk->vq);
 		blk_mq_stop_hw_queue(hctx);
-		spin_unlock_irqrestore(&vblk->vq_lock, flags);
+		spin_unlock_irqrestore(&vblk->vq->lock, flags);
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
@@ -217,7 +216,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 
 	if (last && virtqueue_kick_prepare(vblk->vq))
 		notify = true;
-	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+	spin_unlock_irqrestore(&vblk->vq->lock, flags);
 
 	if (notify)
 		virtqueue_notify(vblk->vq);
@@ -551,7 +550,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = init_vq(vblk);
 	if (err)
 		goto out_free_vblk;
-	spin_lock_init(&vblk->vq_lock);
+	spin_lock_init(&vblk->vq->lock);
 
 	/* FIXME: How many partitions?  How long is a piece of string? */
 	vblk->disk = alloc_disk(1 << PART_BITS);
