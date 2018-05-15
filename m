From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/32] aio: add delayed cancel support
Date: Tue, 15 May 2018 21:48:10 +0200
Message-ID: <20180515194833.6906-10-hch@lst.de>
References: <20180515194833.6906-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180515194833.6906-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The upcoming aio poll support would like to be able to complete the iocb
inline from the cancellation context, but that would cause a double lock
of ctx_lock as-is.  Add a new delayed_cancel_reqs list of iocbs that
should be cancelled from outside the ctx_lock by calling the (re-)added
ki_cancel callback.

To make this safe aio_complete needs to check if this call should complete
the iocb, and to make that safe without much reordering a struct file
argument to put is padded to aio_complete.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 80 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index be10dde20c8e..3afca506c7f0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -138,7 +138,8 @@ struct kioctx {
 
 	struct {
 		spinlock_t	ctx_lock;
-		struct list_head active_reqs;	/* used for cancellation */
+		struct list_head cancel_reqs;
+		struct list_head delayed_cancel_reqs;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -171,6 +172,7 @@ struct aio_kiocb {
 	};
 
 	struct kioctx		*ki_ctx;
+	int			(*ki_cancel)(struct aio_kiocb *iocb);
 
 	struct iocb __user	*ki_user_iocb;	/* user's aiocb */
 	__u64			ki_user_data;	/* user's data for completion */
@@ -178,6 +180,9 @@ struct aio_kiocb {
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
 
+	unsigned int		flags;		/* protected by ctx->ctx_lock */
+#define AIO_IOCB_CANCELLED	(1 << 1)
+
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying eventfd context to deliver events to.
@@ -584,18 +589,23 @@ static void free_ioctx_users(struct percpu_ref *ref)
 {
 	struct kioctx *ctx = container_of(ref, struct kioctx, users);
 	struct aio_kiocb *req;
+	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->ctx_lock);
-
-	while (!list_empty(&ctx->active_reqs)) {
-		req = list_first_entry(&ctx->active_reqs,
+	while (!list_empty(&ctx->cancel_reqs)) {
+		req = list_first_entry(&ctx->cancel_reqs,
 				       struct aio_kiocb, ki_list);
 		list_del_init(&req->ki_list);
 		req->rw.ki_filp->f_op->cancel_kiocb(&req->rw);
 	}
-
+	list_splice_init(&ctx->delayed_cancel_reqs, &list);
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	while (!list_empty(&list)) {
+		req = list_first_entry(&list, struct aio_kiocb, ki_list);
+		req->ki_cancel(req);
+	}
+
 	percpu_ref_kill(&ctx->reqs);
 	percpu_ref_put(&ctx->reqs);
 }
@@ -715,7 +725,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	mutex_lock(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
-	INIT_LIST_HEAD(&ctx->active_reqs);
+	INIT_LIST_HEAD(&ctx->cancel_reqs);
+	INIT_LIST_HEAD(&ctx->delayed_cancel_reqs);
 
 	if (percpu_ref_init(&ctx->users, free_ioctx_users, 0, GFP_KERNEL))
 		goto err;
@@ -1032,25 +1043,34 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 	return ret;
 }
 
+#define AIO_COMPLETE_CANCEL	(1 << 0)
+
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  */
-static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
+static void aio_complete(struct aio_kiocb *iocb, struct file *file, long res,
+		long res2, unsigned complete_flags)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
 	unsigned tail, pos, head;
-	unsigned long	flags;
+	unsigned long flags;
 
 	if (!list_empty_careful(&iocb->ki_list)) {
-		unsigned long flags;
-
 		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		if (!(complete_flags & AIO_COMPLETE_CANCEL) &&
+		    (iocb->flags & AIO_IOCB_CANCELLED)) {
+			spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+			return;
+		}
+
 		list_del(&iocb->ki_list);
 		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	}
 
+	fput(file);
+
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->completion_lock to prevent other code from messing with the tail
@@ -1384,8 +1404,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 		file_end_write(kiocb->ki_filp);
 	}
 
-	fput(kiocb->ki_filp);
-	aio_complete(iocb, res, res2);
+	aio_complete(iocb, kiocb->ki_filp, res, res2, 0);
 }
 
 static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
@@ -1437,7 +1456,7 @@ static inline ssize_t aio_rw_ret(struct kiocb *req, ssize_t ret)
 			unsigned long flags;
 
 			spin_lock_irqsave(&ctx->ctx_lock, flags);
-			list_add_tail(&iocb->ki_list, &ctx->active_reqs);
+			list_add_tail(&iocb->ki_list, &ctx->cancel_reqs);
 			spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 		}
 		return ret;
@@ -1539,11 +1558,10 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 static void aio_fsync_work(struct work_struct *work)
 {
 	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
-	int ret;
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, fsync);
+	struct file *file = req->file;
 
-	ret = vfs_fsync(req->file, req->datasync);
-	fput(req->file);
-	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
+	aio_complete(iocb, file, vfs_fsync(file, req->datasync), 0, 0);
 }
 
 static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)
@@ -1768,18 +1786,12 @@ COMPAT_SYSCALL_DEFINE3(io_submit, compat_aio_context_t, ctx_id,
 }
 #endif
 
-/* lookup_kiocb
- *	Finds a given iocb for cancellation.
- */
 static struct aio_kiocb *
-lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb)
+lookup_kiocb(struct list_head *list, struct iocb __user *iocb)
 {
 	struct aio_kiocb *kiocb;
 
-	assert_spin_locked(&ctx->ctx_lock);
-
-	/* TODO: use a hash or array, this sucks. */
-	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
+	list_for_each_entry(kiocb, list, ki_list) {
 		if (kiocb->ki_user_iocb == iocb)
 			return kiocb;
 	}
@@ -1801,6 +1813,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 {
 	struct kioctx *ctx;
 	struct aio_kiocb *kiocb;
+	LIST_HEAD(dummy);
 	int ret = -EINVAL;
 	u32 key;
 
@@ -1814,12 +1827,21 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	kiocb = lookup_kiocb(ctx, iocb);
+	kiocb = lookup_kiocb(&ctx->delayed_cancel_reqs, iocb);
 	if (kiocb) {
-		list_del_init(&kiocb->ki_list);
-		ret = kiocb->rw.ki_filp->f_op->cancel_kiocb(&kiocb->rw);
+		kiocb->flags |= AIO_IOCB_CANCELLED;
+		list_move_tail(&kiocb->ki_list, &dummy);
+		spin_unlock_irq(&ctx->ctx_lock);
+
+		ret = kiocb->ki_cancel(kiocb);
+	} else {
+		kiocb = lookup_kiocb(&ctx->cancel_reqs, iocb);
+		if (kiocb) {
+			list_del_init(&kiocb->ki_list);
+			ret = kiocb->rw.ki_filp->f_op->cancel_kiocb(&kiocb->rw);
+		}
+		spin_unlock_irq(&ctx->ctx_lock);
 	}
-	spin_unlock_irq(&ctx->ctx_lock);
 
 	if (!ret) {
 		/*
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
