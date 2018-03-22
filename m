From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/28] aio: implement IOCB_CMD_POLL
Date: Thu, 22 Mar 2018 18:24:10 +0100
Message-ID: <20180322172410.GC5542@lst.de>
References: <20180321074032.14211-1-hch@lst.de> <20180321074032.14211-7-hch@lst.de> <20180322165255.GI30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180322165255.GI30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 22, 2018 at 04:52:55PM +0000, Al Viro wrote:
> On Wed, Mar 21, 2018 at 08:40:10AM +0100, Christoph Hellwig wrote:
> > Simple one-shot poll through the io_submit() interface.  To poll for
> > a file descriptor the application should submit an iocb of type
> > IOCB_CMD_POLL.  It will poll the fd for the events specified in the
> > the first 32 bits of the aio_buf field of the iocb.
> > 
> > Unlike poll or epoll without EPOLLONESHOT this interface always works
> > in one shot mode, that is once the iocb is completed, it will have to be
> > resubmitted.
> 
> AFAICS, your wakeup can race with io_cancel(), leading to double fput().
> You are checking the "somebody had committed itself to cancelling that
> thing" bit outside of ->ctx_lock on the wakeup side, and I don't see
> anything to prevent both getting to __aio_poll_complete() on the same
> iocb, with obvious results.

True.  Probably wants something like this to fix, although for this
is entirely untested:

diff --git a/fs/aio.c b/fs/aio.c
index 38b408129697..66d5cc272617 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -187,8 +187,9 @@ struct aio_kiocb {
 						 * for cancellation */
 
 	unsigned int		flags;		/* protected by ctx->ctx_lock */
-#define AIO_IOCB_DELAYED_CANCEL	(1 << 0)
-#define AIO_IOCB_CANCELLED	(1 << 1)
+#define AIO_IOCB_CAN_CANCEL	(1 << 0)
+#define AIO_IOCB_DELAYED_CANCEL	(1 << 1)
+#define AIO_IOCB_CANCELLED	(1 << 2)
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
@@ -568,7 +569,7 @@ static void __kiocb_set_cancel_fn(struct aio_kiocb *req,
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	list_add_tail(&req->ki_list, &ctx->active_reqs);
 	req->ki_cancel = cancel;
-	req->flags |= iocb_flags;
+	req->flags |= (AIO_IOCB_CAN_CANCEL | iocb_flags);
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 
@@ -1086,22 +1087,30 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
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
-	if (!list_empty_careful(iocb->ki_list.next)) {
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
 
@@ -1177,6 +1186,7 @@ static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
 		wake_up(&ctx->wait);
 
 	percpu_ref_put(&ctx->reqs);
+	return true;
 }
 
 /* aio_read_events_ring
@@ -1425,6 +1435,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct aio_kiocb *iocb = container_of(kiocb, struct aio_kiocb, rw);
+	struct file *file = kiocb->ki_filp;
 
 	WARN_ON_ONCE(is_sync_kiocb(kiocb));
 
@@ -1440,8 +1451,8 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
 		file_end_write(kiocb->ki_filp);
 	}
 
-	fput(kiocb->ki_filp);
-	aio_complete(iocb, res, res2);
+	if (aio_complete(iocb, res, res2, 0))
+		fput(file);
 }
 
 static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
@@ -1584,11 +1595,13 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
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
@@ -1617,27 +1630,23 @@ static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)
 	return ret;
 }
 
-static void __aio_complete_poll(struct poll_iocb *req, __poll_t mask)
-{
-	fput(req->file);
-	aio_complete(container_of(req, struct aio_kiocb, poll),
-			mangle_poll(mask), 0);
-}
-
 static void aio_complete_poll(struct poll_iocb *req, __poll_t mask)
 {
 	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
+	struct file *file = req->file;
 
-	if (!(iocb->flags & AIO_IOCB_CANCELLED))
-		__aio_complete_poll(req, mask);
+	if (aio_complete(iocb, mangle_poll(mask), 0, 0))
+		fput(file);
 }
 
 static int aio_poll_cancel(struct kiocb *rw)
 {
 	struct aio_kiocb *iocb = container_of(rw, struct aio_kiocb, rw);
+	struct file *file = iocb->poll.file;
 
 	remove_wait_queue(iocb->poll.head, &iocb->poll.wait);
-	__aio_complete_poll(&iocb->poll, 0); /* no events to report */
+	if (aio_complete(iocb, 0, 0, AIO_COMPLETE_CANCEL))
+		fput(file);
 	return 0;
 }
 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
