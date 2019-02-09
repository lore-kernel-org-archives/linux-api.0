From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/19] io_uring: add io_kiocb ref count
Date: Sat,  9 Feb 2019 14:13:43 -0700
Message-ID: <20190209211346.26060-17-axboe@kernel.dk>
References: <20190209211346.26060-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

We'll use this for the POLL implementation. Regular requests will
NOT be using references, so initialize it to 0. Any real use of
the io_kiocb ref will initialize it to at least 2.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd7ff2643292..dc5667c53c55 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -164,6 +164,7 @@ struct io_kiocb {
 	struct io_ring_ctx	*ctx;
 	struct list_head	list;
 	unsigned int		flags;
+	refcount_t		refs;
 #define REQ_F_FORCE_NONBLOCK	1	/* inline submission attempt */
 #define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
 #define REQ_F_FIXED_FILE	4	/* ctx owns file */
@@ -353,6 +354,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 
 	req->ctx = ctx;
 	req->flags = 0;
+	refcount_set(&req->refs, 0);
 	return req;
 out:
 	io_ring_drop_ctx_refs(ctx, 1);
@@ -370,8 +372,10 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
 
 static void io_free_req(struct io_kiocb *req)
 {
-	io_ring_drop_ctx_refs(req->ctx, 1);
-	kmem_cache_free(req_cachep, req);
+	if (!refcount_read(&req->refs) || refcount_dec_and_test(&req->refs)) {
+		io_ring_drop_ctx_refs(req->ctx, 1);
+		kmem_cache_free(req_cachep, req);
+	}
 }
 
 /*
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
