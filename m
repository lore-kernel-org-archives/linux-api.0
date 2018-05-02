From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] aio: sanitize ki_list handling
Date: Wed,  2 May 2018 23:14:44 +0200
Message-ID: <20180502211448.18276-4-hch@lst.de>
References: <20180502211448.18276-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502211448.18276-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Instead of handcoded non-null checks always initialize ki_list to an
empty list and use list_empty / list_empty_careful on it.  While we're
at it also error out on a double call to kiocb_set_cancel_fn instead
of ignoring it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/aio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7c1855afd723..18507743757a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -553,13 +553,12 @@ void kiocb_set_cancel_fn(struct kiocb *iocb, kiocb_cancel_fn *cancel)
 	struct kioctx *ctx = req->ki_ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
-
-	if (!req->ki_list.next)
-		list_add(&req->ki_list, &ctx->active_reqs);
+	if (WARN_ON_ONCE(!list_empty(&req->ki_list)))
+		return;
 
+	spin_lock_irqsave(&ctx->ctx_lock, flags);
+	list_add_tail(&req->ki_list, &ctx->active_reqs);
 	req->ki_cancel = cancel;
-
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
@@ -1039,7 +1038,7 @@ static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
 		goto out_put;
 
 	percpu_ref_get(&ctx->reqs);
-
+	INIT_LIST_HEAD(&req->ki_list);
 	req->ki_ctx = ctx;
 	return req;
 out_put:
@@ -1107,7 +1106,7 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
 		file_end_write(file);
 	}
 
-	if (iocb->ki_list.next) {
+	if (!list_empty_careful(&iocb->ki_list)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ctx->ctx_lock, flags);
-- 
2.17.0
