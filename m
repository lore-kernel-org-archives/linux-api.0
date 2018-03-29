From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/30] crypto: af_alg: convert to ->poll_mask
Date: Thu, 29 Mar 2018 22:33:24 +0200
Message-ID: <20180329203328.3248-27-hch@lst.de>
References: <20180329203328.3248-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180329203328.3248-1-hch@lst.de>
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
index 50d75de539f5..330aef1cd08b 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1060,19 +1060,12 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
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
 		mask |= EPOLLIN | EPOLLRDNORM;
@@ -1082,7 +1075,7 @@ __poll_t af_alg_poll(struct file *file, struct socket *sock,
 
 	return mask;
 }
-EXPORT_SYMBOL_GPL(af_alg_poll);
+EXPORT_SYMBOL_GPL(af_alg_poll_mask);
 
 /**
  * af_alg_alloc_areq - allocate struct af_alg_async_req
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 4b07edd5a9ff..330cf9f2b767 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -375,7 +375,7 @@ static struct proto_ops algif_aead_ops = {
 	.sendmsg	=	aead_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	aead_recvmsg,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static int aead_check_key(struct socket *sock)
@@ -471,7 +471,7 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.sendmsg	=	aead_sendmsg_nokey,
 	.sendpage	=	aead_sendpage_nokey,
 	.recvmsg	=	aead_recvmsg_nokey,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static void *aead_bind(const char *name, u32 type, u32 mask)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c4e885df4564..15cf3c5222e0 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -205,7 +205,7 @@ static struct proto_ops algif_skcipher_ops = {
 	.sendmsg	=	skcipher_sendmsg,
 	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static int skcipher_check_key(struct socket *sock)
@@ -301,7 +301,7 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.sendmsg	=	skcipher_sendmsg_nokey,
 	.sendpage	=	skcipher_sendpage_nokey,
 	.recvmsg	=	skcipher_recvmsg_nokey,
-	.poll		=	af_alg_poll,
+	.poll_mask	=	af_alg_poll_mask,
 };
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 482461d8931d..cc414db9da0a 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -245,8 +245,7 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
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
