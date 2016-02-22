From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 7/7] block, directio: set a REQ_POLL flag when submitting polled bios
Date: Mon, 22 Feb 2016 18:07:56 +0100
Message-ID: <1456160876-14560-8-git-send-email-hch@lst.de>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
Cc: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-core.c          | 9 +++++++--
 fs/direct-io.c            | 4 ++++
 include/linux/blk_types.h | 2 ++
 include/linux/blkdev.h    | 1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b83d297..81b4b8b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3335,13 +3335,18 @@ void blk_finish_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
+inline bool blk_queue_can_poll(struct request_queue *q)
+{
+	return q->mq_ops && q->mq_ops->poll &&
+		test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
+}
+
 bool blk_poll(struct request_queue *q, blk_qc_t cookie)
 {
 	struct blk_plug *plug;
 	long state;
 
-	if (!q->mq_ops || !q->mq_ops->poll || !blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_can_poll(q) || !blk_qc_t_valid(cookie))
 		return false;
 
 	plug = current->plug;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0a8d937..ba5ba7e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1197,6 +1197,10 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	dio->inode = inode;
 	dio->rw = iov_iter_rw(iter) == WRITE ? WRITE_ODIRECT : READ;
 
+	if ((iocb->ki_flags & IOCB_HIPRI) &&
+	    blk_queue_can_poll(bdev_get_queue(bdev)))
+		dio->rw |= REQ_POLL;
+
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
 	 * so that we can call ->fsync.
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 86a38ea..d667bb4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -161,6 +161,7 @@ enum rq_flag_bits {
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
 	__REQ_FUA,		/* forced unit access */
 	__REQ_FLUSH,		/* request for cache flush */
+	__REQ_POLL,		/* request polling for completion */
 
 	/* bio only flags */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
@@ -202,6 +203,7 @@ enum rq_flag_bits {
 #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
+#define REQ_POLL		(1ULL << __REQ_POLL)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 458f6ef..d79353f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -824,6 +824,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 
+bool blk_queue_can_poll(struct request_queue *q);
 bool blk_poll(struct request_queue *q, blk_qc_t cookie);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
-- 
2.1.4
