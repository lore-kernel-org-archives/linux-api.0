From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v6 5/6] crypto: algif_akcipher - add ops_nokey
Date: Sat, 14 May 2016 21:17:13 -0700
Message-ID: <20160515041713.15888.29635.stgit@tstruk-mobl1>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Similar to algif_skcipher and algif_hash, algif_akcipher needs
to prevent user space from using the interface in an improper way.
This patch adds nokey ops handlers, which do just that.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_akcipher.c |  159 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 152 insertions(+), 7 deletions(-)

diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
index 6342b6e..e00793d 100644
--- a/crypto/algif_akcipher.c
+++ b/crypto/algif_akcipher.c
@@ -27,6 +27,11 @@ struct akcipher_sg_list {
 	struct scatterlist sg[ALG_MAX_PAGES];
 };
 
+struct akcipher_tfm {
+	struct crypto_akcipher *akcipher;
+	bool has_key;
+};
+
 struct akcipher_ctx {
 	struct akcipher_sg_list tsgl;
 	struct af_alg_sgl rsgl[ALG_MAX_PAGES];
@@ -450,25 +455,151 @@ static struct proto_ops algif_akcipher_ops = {
 	.poll		=	akcipher_poll,
 };
 
+static int akcipher_check_key(struct socket *sock)
+{
+	int err = 0;
+	struct sock *psk;
+	struct alg_sock *pask;
+	struct akcipher_tfm *tfm;
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+
+	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock_child;
+
+	psk = ask->parent;
+	pask = alg_sk(ask->parent);
+	tfm = pask->private;
+
+	err = -ENOKEY;
+	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
+	if (!tfm->has_key)
+		goto unlock;
+
+	if (!pask->refcnt++)
+		sock_hold(psk);
+
+	ask->refcnt = 1;
+	sock_put(psk);
+
+	err = 0;
+
+unlock:
+	release_sock(psk);
+unlock_child:
+	release_sock(sk);
+
+	return err;
+}
+
+static int akcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t size)
+{
+	int err;
+
+	err = akcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return akcipher_sendmsg(sock, msg, size);
+}
+
+static ssize_t akcipher_sendpage_nokey(struct socket *sock, struct page *page,
+				       int offset, size_t size, int flags)
+{
+	int err;
+
+	err = akcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return akcipher_sendpage(sock, page, offset, size, flags);
+}
+
+static int akcipher_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t ignored, int flags)
+{
+	int err;
+
+	err = akcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return akcipher_recvmsg(sock, msg, ignored, flags);
+}
+
+static struct proto_ops algif_akcipher_ops_nokey = {
+	.family		=	PF_ALG,
+
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+
+	.release	=	af_alg_release,
+	.sendmsg	=	akcipher_sendmsg_nokey,
+	.sendpage	=	akcipher_sendpage_nokey,
+	.recvmsg	=	akcipher_recvmsg_nokey,
+	.poll		=	akcipher_poll,
+};
+
 static void *akcipher_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_akcipher(name, type, mask);
+	struct akcipher_tfm *tfm;
+	struct crypto_akcipher *akcipher;
+
+	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
+
+	akcipher = crypto_alloc_akcipher(name, type, mask);
+	if (IS_ERR(akcipher)) {
+		kfree(tfm);
+		return ERR_CAST(akcipher);
+	}
+
+	tfm->akcipher = akcipher;
+	return tfm;
 }
 
 static void akcipher_release(void *private)
 {
-	crypto_free_akcipher(private);
+	struct akcipher_tfm *tfm = private;
+	struct crypto_akcipher *akcipher = tfm->akcipher;
+
+	crypto_free_akcipher(akcipher);
+	kfree(tfm);
 }
 
 static int akcipher_setprivkey(void *private, const u8 *key,
 			       unsigned int keylen)
 {
-	return crypto_akcipher_set_priv_key(private, key, keylen);
+	struct akcipher_tfm *tfm = private;
+	struct crypto_akcipher *akcipher = tfm->akcipher;
+	int err;
+
+	err = crypto_akcipher_set_priv_key(akcipher, key, keylen);
+	tfm->has_key = !err;
+	return err;
 }
 
 static int akcipher_setpubkey(void *private, const u8 *key, unsigned int keylen)
 {
-	return crypto_akcipher_set_pub_key(private, key, keylen);
+	struct akcipher_tfm *tfm = private;
+	struct crypto_akcipher *akcipher = tfm->akcipher;
+	int err;
+
+	err = crypto_akcipher_set_pub_key(akcipher, key, keylen);
+	tfm->has_key = !err;
+	return err;
 }
 
 static void akcipher_sock_destruct(struct sock *sk)
@@ -481,11 +612,13 @@ static void akcipher_sock_destruct(struct sock *sk)
 	af_alg_release_parent(sk);
 }
 
-static int akcipher_accept_parent(void *private, struct sock *sk)
+static int akcipher_accept_parent_nokey(void *private, struct sock *sk)
 {
 	struct akcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_akcipher_reqsize(private);
+	struct akcipher_tfm *tfm = private;
+	struct crypto_akcipher *akcipher = tfm->akcipher;
+	unsigned int len = sizeof(*ctx) + crypto_akcipher_reqsize(akcipher);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
@@ -503,7 +636,7 @@ static int akcipher_accept_parent(void *private, struct sock *sk)
 
 	ask->private = ctx;
 
-	akcipher_request_set_tfm(&ctx->req, private);
+	akcipher_request_set_tfm(&ctx->req, akcipher);
 	akcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      af_alg_complete, &ctx->completion);
 
@@ -512,13 +645,25 @@ static int akcipher_accept_parent(void *private, struct sock *sk)
 	return 0;
 }
 
+static int akcipher_accept_parent(void *private, struct sock *sk)
+{
+	struct akcipher_tfm *tfm = private;
+
+	if (!tfm->has_key)
+		return -ENOKEY;
+
+	return akcipher_accept_parent_nokey(private, sk);
+}
+
 static const struct af_alg_type algif_type_akcipher = {
 	.bind		=	akcipher_bind,
 	.release	=	akcipher_release,
 	.setkey		=	akcipher_setprivkey,
 	.setpubkey	=	akcipher_setpubkey,
 	.accept		=	akcipher_accept_parent,
+	.accept_nokey	=	akcipher_accept_parent_nokey,
 	.ops		=	&algif_akcipher_ops,
+	.ops_nokey	=	&algif_akcipher_ops_nokey,
 	.name		=	"akcipher",
 	.owner		=	THIS_MODULE
 };
