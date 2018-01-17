From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/36] aio: implement IOCB_CMD_POLL
Date: Wed, 17 Jan 2018 20:27:20 +0100
Message-ID: <20180117192742.710-15-hch@lst.de>
References: <20180117192742.710-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180117192742.710-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Simple one-shot poll through the io_submit() interface.  To poll for
a file descriptor the application should submit an iocb of type
IOCB_CMD_POLL.  It will poll the fd for the events specified in the
the first 32 bits of the aio_buf field of the iocb.

Unlike poll or epoll without EPOLLONESHOT this interface always works
in one shot mode, that is once the iocb is completed, it will have to be
resubmitted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c                     | 98 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/aio_abi.h |  6 +--
 2 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index da87cbf7c67a..0cddd24e7316 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -5,6 +5,7 @@
  *	Implements an efficient asynchronous io interface.
  *
  *	Copyright 2000, 2001, 2002 Red Hat, Inc.  All Rights Reserved.
+ *	Copyright 2018 Christoph Hellwig.
  *
  *	See ../COPYING for licensing terms.
  */
@@ -156,9 +157,17 @@ struct kioctx {
 	unsigned		id;
 };
 
+struct poll_iocb {
+	struct file		*file;
+	__poll_t		events;
+	struct wait_queue_head	*head;
+	struct wait_queue_entry	wait;
+};
+
 struct aio_kiocb {
 	union {
 		struct kiocb		rw;
+		struct poll_iocb	poll;
 	};
 
 	struct kioctx		*ki_ctx;
@@ -1565,6 +1574,92 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 	return ret;
 }
 
+static void __aio_complete_poll(struct poll_iocb *req, __poll_t mask)
+{
+	fput(req->file);
+	aio_complete(container_of(req, struct aio_kiocb, poll),
+			mangle_poll(mask), 0);
+}
+
+static void aio_complete_poll(struct poll_iocb *req, __poll_t mask)
+{
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
+
+	if (!(iocb->flags & AIO_IOCB_CANCELLED))
+		__aio_complete_poll(req, mask);
+}
+
+static int aio_poll_cancel(struct kiocb *rw)
+{
+	struct aio_kiocb *iocb = container_of(rw, struct aio_kiocb, rw);
+
+	remove_wait_queue(iocb->poll.head, &iocb->poll.wait);
+	__aio_complete_poll(&iocb->poll, 0); /* no events to report */
+	return 0;
+}
+
+static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+		void *key)
+{
+	struct poll_iocb *req = container_of(wait, struct poll_iocb, wait);
+	struct file *file = req->file;
+	__poll_t mask = key_to_poll(key);
+
+	assert_spin_locked(&req->head->lock);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & req->events))
+		return 0;
+
+	mask = vfs_poll_mask(file, req->events);
+	if (!mask)
+		return 0;
+
+	__remove_wait_queue(req->head, &req->wait);
+	aio_complete_poll(req, mask);
+	return 1;
+}
+
+static ssize_t aio_poll(struct aio_kiocb *aiocb, struct iocb *iocb)
+{
+	struct poll_iocb *req = &aiocb->poll;
+	unsigned long flags;
+	__poll_t mask;
+
+	/* reject any unknown events outside the normal event mask. */
+	if ((u16)iocb->aio_buf != iocb->aio_buf)
+		return -EINVAL;
+	/* reject fields that are not defined for poll */
+	if (iocb->aio_offset || iocb->aio_nbytes || iocb->aio_rw_flags)
+		return -EINVAL;
+
+	req->events = demangle_poll(iocb->aio_buf) | POLLERR | POLLHUP;
+	req->file = fget(iocb->aio_fildes);
+	if (unlikely(!req->file))
+		return -EBADF;
+
+	req->head = vfs_get_poll_head(req->file, req->events);
+	if (!req->head) {
+		fput(req->file);
+		return -EINVAL; /* same as no support for IOCB_CMD_POLL */
+	}
+
+	init_waitqueue_func_entry(&req->wait, aio_poll_wake);
+
+	spin_lock_irqsave(&req->head->lock, flags);
+	mask = vfs_poll_mask(req->file, req->events);
+	if (!mask) {
+		__kiocb_set_cancel_fn(aiocb, aio_poll_cancel,
+				AIO_IOCB_DELAYED_CANCEL);
+		__add_wait_queue(req->head, &req->wait);
+	}
+	spin_unlock_irqrestore(&req->head->lock, flags);
+
+	if (mask)
+		aio_complete_poll(req, mask);
+	return -EIOCBQUEUED;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
@@ -1628,6 +1723,9 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	case IOCB_CMD_PWRITEV:
 		ret = aio_write(&req->rw, iocb, true, compat);
 		break;
+	case IOCB_CMD_POLL:
+		ret = aio_poll(req, iocb);
+		break;
 	default:
 		pr_debug("invalid aio operation %d\n", iocb->aio_lio_opcode);
 		ret = -EINVAL;
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 2c0a3415beee..ed0185945bb2 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -39,10 +39,8 @@ enum {
 	IOCB_CMD_PWRITE = 1,
 	IOCB_CMD_FSYNC = 2,
 	IOCB_CMD_FDSYNC = 3,
-	/* These two are experimental.
-	 * IOCB_CMD_PREADX = 4,
-	 * IOCB_CMD_POLL = 5,
-	 */
+	/* 4 was the experimental IOCB_CMD_PREADX */
+	IOCB_CMD_POLL = 5,
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
