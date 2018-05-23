From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/33] aio: try to complete poll iocbs without context switch
Date: Wed, 23 May 2018 21:20:00 +0200
Message-ID: <20180523192022.1703-12-hch@lst.de>
References: <20180523192022.1703-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180523192022.1703-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

If we can acquire ctx_lock without spinning we can just remove our
iocb from the active_reqs list, and thus complete the iocbs from the
wakeup context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index bd711cfa4a1f..8274d09d44a2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1633,6 +1633,7 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		void *key)
 {
 	struct poll_iocb *req = container_of(wait, struct poll_iocb, wait);
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
 	struct file *file = req->file;
 	__poll_t mask = key_to_poll(key);
 
@@ -1648,9 +1649,22 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 	__aio_poll_remove(req);
 
-	req->events = mask;
-	INIT_WORK(&req->work, aio_poll_work);
-	schedule_work(&req->work);
+	/*
+	 * Try completing without a context switch if we can acquire ctx_lock
+	 * without spinning.  Otherwise we need to defer to a workqueue to
+	 * avoid a deadlock due to the lock order.
+	 */
+	if (spin_trylock(&iocb->ki_ctx->ctx_lock)) {
+		list_del_init(&iocb->ki_list);
+		spin_unlock(&iocb->ki_ctx->ctx_lock);
+
+		__aio_poll_complete(req, mask);
+	} else {
+		req->events = mask;
+		INIT_WORK(&req->work, aio_poll_work);
+		schedule_work(&req->work);
+	}
+
 	return 1;
 }
 
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
