From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/31] aio: try to complete poll iocbs without context switch
Date: Tue, 22 May 2018 13:30:46 +0200
Message-ID: <20180522113108.25713-10-hch@lst.de>
References: <20180522113108.25713-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522113108.25713-1-hch@lst.de>
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
index 4d1eabce6659..85d9102431db 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1632,6 +1632,7 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		void *key)
 {
 	struct poll_iocb *req = container_of(wait, struct poll_iocb, wait);
+	struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
 	struct file *file = req->file;
 	__poll_t mask = key_to_poll(key);
 
@@ -1647,9 +1648,22 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
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
