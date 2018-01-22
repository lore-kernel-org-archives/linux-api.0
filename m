From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 32/36] crypto: af_alg: convert to ->poll_mask
Date: Mon, 22 Jan 2018 21:12:39 +0100
Message-ID: <20180122201243.31610-33-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/af_alg.c         | 13 +++----------
 crypto/algif_aead.c     |  4 ++--
 crypto/algif_skcipher.c |  4 ++--
 include/crypto/if_alg.h |  3 +--
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 592797ec8075..2639ffda4f4d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1058,19 +1058,12 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
-/**
- * af_alg_poll - poll system call handler
- */
-__poll_t af_alg_poll(struct file *file, struct socket *sock,
-			 poll_table *wait)
+__poll_t af_alg_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
-	__poll_t mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	__poll_t mask = 0;
 
 	if (!ctx->more || ctx->used)
 		mask |= POLLIN | POLLRDNORM;
@@ -1080,7 +1073,7 @@ __poll_t af_alg_poll(struct file *file, struct socket *sock,
 
 	return mask;
 }
-EXPORT_SYMBOL_GPL(af_alg_poll);
+EXPORT_SYMBOL_GPL(af_alg_poll_mask);
 
 /**
  * af_alg_alloc_areq - allocate struct af_alg_async_req
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index ddcc45f77edd..0f726e55b0b1 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -376,7 +376,7 @@ static struct proto_ops algif_aead_ops = {
 	.sendmsg	=	aead_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	aead_recvmsg,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static int aead_check_key(struct socket *sock)
@@ -472,7 +472,7 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.sendmsg	=	aead_sendmsg_nokey,
 	.sendpage	=	aead_sendpage_nokey,
 	.recvmsg	=	aead_recvmsg_nokey,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static void *aead_bind(const char *name, u32 type, u32 mask)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 494c99cbe48f..e5463cc0821e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -212,7 +212,7 @@ static struct proto_ops algif_skcipher_ops = {
 	.sendmsg	=	skcipher_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static int skcipher_check_key(struct socket *sock)
@@ -308,7 +308,7 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.sendmsg	=	skcipher_sendmsg_nokey,
 	.sendpage	=	skcipher_sendpage_nokey,
 	.recvmsg	=	skcipher_recvmsg_nokey,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a50bdb9d7cfd..ff575671fb2f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -244,8 +244,7 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags);
 void af_alg_free_resources(struct af_alg_async_req *areq);
 void af_alg_async_cb(struct crypto_async_request *_req, int err);
-__poll_t af_alg_poll(struct file *file, struct socket *sock,
-			 poll_table *wait);
+__poll_t af_alg_poll_mask(struct socket *sock, __poll_t events);
 struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 					   unsigned int areqlen);
 int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
