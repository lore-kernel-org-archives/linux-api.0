From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/36] aio: add delayed cancel support
Date: Mon,  5 Mar 2018 13:27:14 -0800
Message-ID: <20180305212743.16664-8-hch@lst.de>
References: <20180305212743.16664-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180305212743.16664-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The upcoming aio poll support would like to be able to complete the
iocb inline from the cancellation context, but that would cause
a lock order reversal.  Add support for optionally moving the cancelation
outside the context lock to avoid this reversal.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/aio.c | 49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 0b6394b4e528..9d7d6e4cde87 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -170,6 +170,10 @@ struct aio_kiocb {
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
 
+	unsigned int		flags;		/* protected by ctx->ctx_lock */
+#define AIO_IOCB_DELAYED_CANCEL	(1 << 0)
+#define AIO_IOCB_CANCELLED	(1 << 1)
+
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying eventfd context to deliver events to.
@@ -536,9 +540,9 @@ static int aio_setup_ring(struct kioctx *ctx, unsigned int nr_events)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
+static void __kiocb_set_cancel_fn(struct aio_kiocb *req,
+		kiocb_cancel_fn *cancel, unsigned int iocb_flags)
 {
-	struct aio_kiocb *req = container_of(iocb, struct aio_kiocb, rw);
 	struct kioctx *ctx = req->ki_ctx;
 	unsigned long flags;
 
@@ -548,8 +552,15 @@ void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	list_add_tail(&req->ki_list, &ctx->active_reqs);
 	req->ki_cancel = cancel;
+	req->flags |= iocb_flags;
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
+
+void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
+{
+	return __kiocb_set_cancel_fn(container_of(iocb, struct aio_kiocb, rw),
+			cancel, 0);
+}
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
 /*
@@ -603,17 +614,27 @@ static void free_ioctx_users(struct percpu_ref *ref)
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
-	}
 
+		if (req->flags & AIO_IOCB_DELAYED_CANCEL) {
+			req->flags |= AIO_IOCB_CANCELLED;
+			list_move_tail(&req->ki_list, &list);
+		} else {
+			kiocb_cancel(req);
+		}
+	}
 	spin_unlock_irq(&ctx->ctx_lock);
 
+	while (!list_empty(&list)) {
+		req = list_first_entry(&list, struct aio_kiocb, ki_list);
+		kiocb_cancel(req);
+	}
+
 	percpu_ref_kill(&ctx->reqs);
 	percpu_ref_put(&ctx->reqs);
 }
@@ -1785,15 +1806,22 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 	if (unlikely(!ctx))
 		return -EINVAL;
 
-	spin_lock_irq(&ctx->ctx_lock);
+	ret = -EINVAL;
 
+	spin_lock_irq(&ctx->ctx_lock);
 	kiocb = lookup_kiocb(ctx, iocb, key);
+	if (kiocb) {
+		if (kiocb->flags & AIO_IOCB_DELAYED_CANCEL) {
+			kiocb->flags |= AIO_IOCB_CANCELLED;
+		} else {
+			ret = kiocb_cancel(kiocb);
+			kiocb = NULL;
+		}
+	}
+	spin_unlock_irq(&ctx->ctx_lock);
+
 	if (kiocb)
 		ret = kiocb_cancel(kiocb);
-	else
-		ret = -EINVAL;
-
-	spin_unlock_irq(&ctx->ctx_lock);
 
 	if (!ret) {
 		/*
@@ -1805,7 +1833,6 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 	}
 
 	percpu_ref_put(&ctx->users);
-
 	return ret;
 }
 
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
