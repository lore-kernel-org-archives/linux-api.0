From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Sun, 16 Nov 2014 03:24:25 +0100
Message-ID: <2688209.3bGZus2TD9@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5365136.g8vbXlhRyC@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The AF_ALG interface allows normal cipher (hash, encrypt, decrypt).
However, it does not allow user space to obtain the following generic
information about the currently active cipher:

	* block size of the cipher

	* IV size of the cipher

	* for AEAD, the maximum authentication tag size

The patch adds a getsockopt interface for the symmetric ciphers to
answer such information requests from user space.

The kernel crypto API function calls are used to obtain the real data.
As all data are simple integer values, the getsockopt handler function
uses put_user() to return the integer value to user space in the
*optval parameter of getsockopt.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/if_alg.h |  7 +++++++
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 85e3bdb..2f5d663 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -522,6 +522,50 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int skcipher_getsockopt(struct socket *sock, int level, int optname,
+			       char __user *optval, int __user *optlen)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	const struct af_alg_type *type;
+	int len = 0;
+	int err = -EOPNOTSUPP;
+
+	lock_sock(sk);
+	type = ask->type;
+
+	if (level != SOL_ALG || !type)
+		goto unlock;
+
+	switch (optname) {
+	case ALG_GET_BLOCKSIZE:
+		len = skcipher_crypto_blocksize(ctx);
+		err = 0;
+		break;
+	case ALG_GET_IVSIZE:
+		len = skcipher_crypto_ivsize_ctx(ctx);
+		err = 0;
+		break;
+	case ALG_GET_AEAD_AUTHSIZE:
+		if (ctx->aead) {
+			len = crypto_aead_authsize(crypto_aead_reqtfm(
+						   &ctx->u.aead_req));
+			err = 0;
+		}
+		break;
+	default:
+		break;
+	}
+
+unlock:
+	release_sock(sk);
+	if (err >= 0)
+		err = put_user(len, optlen);
+
+	return err;
+}
+
 static struct proto_ops algif_skcipher_ops = {
 	.family		=	PF_ALG,
 
@@ -531,7 +575,6 @@ static struct proto_ops algif_skcipher_ops = {
 	.ioctl		=	sock_no_ioctl,
 	.listen		=	sock_no_listen,
 	.shutdown	=	sock_no_shutdown,
-	.getsockopt	=	sock_no_getsockopt,
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
@@ -542,6 +585,7 @@ static struct proto_ops algif_skcipher_ops = {
 	.sendpage	=	skcipher_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
 	.poll		=	skcipher_poll,
+	.getsockopt	=	skcipher_getsockopt,
 };
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index 64e7008..b8fb714 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -40,8 +40,15 @@ struct af_alg_aead_assoc {
 #define ALG_SET_AEAD_ASSOC		4
 #define ALG_SET_AEAD_AUTHSIZE		5
 
+/* getsockopt options */
+#define ALG_GET_BLOCKSIZE		1
+#define ALG_GET_IVSIZE			2
+#define ALG_GET_AEAD_AUTHSIZE		3
+
 /* Operations */
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
 
+
+
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.1.0
