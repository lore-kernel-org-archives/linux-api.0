From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/19] io_uring: batch io_kiocb allocation
Date: Mon, 11 Feb 2019 12:00:40 -0700
Message-ID: <20190211190049.7888-12-axboe@kernel.dk>
References: <20190211190049.7888-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190211190049.7888-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, Jens Axboe <axboe@kernel.dk>
List-Id: linux-api@vger.kernel.org

Similarly to how we use the state->ios_left to know how many references
to get to a file, we can use it to allocate the io_kiocb's we need in
bulk.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7358dd1dbf3f..e330252dc5de 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -168,6 +168,13 @@ struct io_kiocb {
 struct io_submit_state {
 	struct blk_plug		plug;
 
+	/*
+	 * io_kiocb alloc cache
+	 */
+	void			*reqs[IO_IOPOLL_BATCH];
+	unsigned		int free_reqs;
+	unsigned		int cur_req;
+
 	/*
 	 * File reference cache
 	 */
@@ -305,20 +312,40 @@ static void io_ring_drop_ctx_refs(struct io_ring_ctx *ctx, unsigned refs)
 		wake_up(&ctx->wait);
 }
 
-static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
+static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
+				   struct io_submit_state *state)
 {
 	struct io_kiocb *req;
 
 	if (!percpu_ref_tryget(&ctx->refs))
 		return NULL;
 
-	req = kmem_cache_alloc(req_cachep, __GFP_NOWARN);
-	if (req) {
-		req->ctx = ctx;
-		req->flags = 0;
-		return req;
+	if (!state) {
+		req = kmem_cache_alloc(req_cachep, __GFP_NOWARN);
+		if (unlikely(!req))
+			goto out;
+	} else if (!state->free_reqs) {
+		size_t sz;
+		int ret;
+
+		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
+		ret = kmem_cache_alloc_bulk(req_cachep, __GFP_NOWARN, sz,
+						state->reqs);
+		if (unlikely(ret <= 0))
+			goto out;
+		state->free_reqs = ret - 1;
+		state->cur_req = 1;
+		req = state->reqs[0];
+	} else {
+		req = state->reqs[state->cur_req];
+		state->free_reqs--;
+		state->cur_req++;
 	}
 
+	req->ctx = ctx;
+	req->flags = 0;
+	return req;
+out:
 	io_ring_drop_ctx_refs(ctx, 1);
 	return NULL;
 }
@@ -1007,7 +1034,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 	if (unlikely(s->sqe->flags))
 		return -EINVAL;
 
-	req = io_get_req(ctx);
+	req = io_get_req(ctx, state);
 	if (unlikely(!req))
 		return -EAGAIN;
 
@@ -1041,6 +1068,9 @@ static void io_submit_state_end(struct io_submit_state *state)
 {
 	blk_finish_plug(&state->plug);
 	io_file_put(state, NULL);
+	if (state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, state->free_reqs,
+					&state->reqs[state->cur_req]);
 }
 
 /*
@@ -1050,6 +1080,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  struct io_ring_ctx *ctx, unsigned max_ios)
 {
 	blk_start_plug(&state->plug);
+	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
 }
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
