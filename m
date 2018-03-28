From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/30] aio: add delayed cancel support
Date: Wed, 28 Mar 2018 09:29:03 +0200
Message-ID: <20180328072926.17131-8-hch@lst.de>
References: <20180328072926.17131-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180328072926.17131-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The upcoming aio poll support would like to be able to complete the
iocb inline from the cancellation context, but that would cause
a lock order reversal.  Add support for optionally moving the cancelation
outside the context lock to avoid this reversal.

To make this safe aio_complete needs to check if this call should complete
the iocb.  If it didn't the callers must not release any other resources.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 22 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c36eec8b0879..232dd84fc897 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -177,6 +177,11 @@ struct aio_kiocb {
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
 
+	unsigned int		flags;		/* protected by ctx->ctx_lock */
+#define AIO_IOCB_CAN_CANCEL	(1 << 0)
+#define AIO_IOCB_DELAYED_CANCEL	(1 << 1)
+#define AIO_IOCB_CANCELLED	(1 << 2)
+
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying eventfd context to deliver events to.
@@ -543,9 +548,9 @@ static int aio_setup_ring(struct kioctx *ctx, unsigned int nr_events)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
+static void __kiocb_set_cancel_fn(struct aio_kiocb *req,
+		kiocb_cancel_fn *cancel, unsigned int iocb_flags)
 {
-	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, rw);
 	struct kioctx *ctx = req->ki_ctx;
 	unsigned long flags;
 
@@ -555,8 +560,15 @@ void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	list_add_tail(&req->ki_list, &ctx->active_reqs);
 	req->ki_cancel = cancel;
+	req->flags |= (AIO_IOCB_CAN_CANCEL | iocb_flags);
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
+
+void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
+{
+	return __kiocb_set_cancel_fn(container_of(iocb, struct aio_kiocb, rw),
+			cancel, 0);
+}
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
 static int kiocb_cancel(struct aio_kiocb *kiocb)
@@ -599,17 +611,26 @@ static void free_ioctx_users(struct percpu_ref *ref)
 {
 	struct kioctx *ctx = container_of(ref, struct kioctx, users);
 	struct aio_kiocb *req;
+	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->ctx_lock);
-
 	while (!list_empty(&ctx->active_reqs)) {
 		req = list_first_entry(&ctx->active_reqs,
 				       struct aio_kiocb, ki_list);
-		kiocb_cancel(req);
+		if (req->flags & AIO_IOCB_DELAYED_CANCEL) {
+			req->flags |= AIO_IOCB_CANCELLED;
+			list_move_tail(&req->ki_list, &list);
+		} else {
+			kiocb_cancel(req);
+		}
 	}
-
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	while (!list_empty(&list)) {
+		req = list_first_entry(&list, struct aio_kiocb, ki_list);
+		kiocb_cancel(req);
+	}
+
 	percpu_ref_kill(&ctx->reqs);
 	percpu_ref_put(&ctx->reqs);
 }
@@ -1045,22 +1066,30 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 	return ret;
 }
 
+#define AIO_COMPLETE_CANCEL	(1 << 0)
+
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  */
-static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
+static bool aio_complete(struct aio_kiocb *iocb, long res, long res2,
+		unsigned complete_flags)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned tail, pos, head;
-	unsigned long	flags;
-
-	if (!list_empty_careful(&iocb->ki_list)) {
-		unsigned long flags;
+	unsigned long flags;
 
+	if (iocb->flags & AIO_IOCB_CAN_CANCEL) {
 		spin_lock_irqsave(&ctx->ctx_lock, flags);
-		list_del(&iocb->ki_list);
+		if (!(complete_flags & AIO_COMPLETE_CANCEL) &&
+		    (iocb->flags & AIO_IOCB_CANCELLED)) {
+			spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+			return false;
+		}
+
+		if (!list_empty(&iocb->ki_list))
+			list_del(&iocb->ki_list);
 		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	}
 
@@ -1136,6 +1165,7 @@ static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
 		wake_up(&ctx->wait);
 
 	percpu_ref_put(&ctx->reqs);
+	return true;
 }
 
 /* aio_read_events_ring
@@ -1384,6 +1414,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, rw);
+	struct file *file = kiocb->ki_filp;
 
 	if (kiocb->ki_flags & IOCB_WRITE) {
 		struct inode *inode = file_inode(kiocb->ki_filp);
@@ -1397,8 +1428,8 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 		file_end_write(kiocb->ki_filp);
 	}
 
-	fput(kiocb->ki_filp);
-	aio_complete(iocb, res, res2);
+	if (aio_complete(iocb, res, res2, 0))
+		fput(file);
 }
 
 static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
@@ -1541,11 +1572,13 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 static void aio_fsync_work(struct work_struct *work)
 {
 	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, fsync);
+	struct file *file = req->file;
 	int ret;
 
 	ret = vfs_fsync(req->file, req->datasync);
-	fput(req->file);
-	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
+	if (aio_complete(iocb, ret, 0, 0))
+		fput(file);
 }
 
 static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)
@@ -1807,8 +1840,8 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 {
 	struct kioctx *ctx;
 	struct aio_kiocb *kiocb;
+	int ret = -EINVAL;
 	u32 key;
-	int ret;
 
 	ret = get_user(key, &iocb->aio_key);
 	if (unlikely(ret))
@@ -1819,15 +1852,19 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-
 	kiocb = lookup_kiocb(ctx, iocb, key);
-	if (kiocb)
-		ret = kiocb_cancel(kiocb);
-	else
-		ret = -EINVAL;
-
+	if (kiocb) {
+		if (kiocb->flags & AIO_IOCB_DELAYED_CANCEL) {
+			kiocb->flags |= AIO_IOCB_CANCELLED;
+		} else {
+			ret = kiocb_cancel(kiocb);
+			kiocb = NULL;
+		}
+	}
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	if (kiocb)
+		ret = kiocb_cancel(kiocb);
 	if (!ret) {
 		/*
 		 * The result argument is no longer used - the io_event is
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
