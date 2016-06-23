From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Thu, 23 Jun 2016 15:55:58 -0700
Message-ID: <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, mathew.j.martineau@linux.intel.com, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

This patch adds support for asymmetric key type to AF_ALG.
It will work as follows: A new PF_ALG socket options are
added on top of existing ALG_SET_KEY and ALG_SET_PUBKEY, namely
ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID for setting public and
private keys respectively. When these new options will be used
the user, instead of providing the key material, will provide a
key id and the key itself will be obtained from kernel keyring
subsystem. The user will use the standard tools (keyctl tool
or the keyctl syscall) for key instantiation and to obtain the
key id. The key id can also be obtained by reading the
/proc/keys file.

When a key corresponding to the given keyid is found, it is stored
in the socket context and subsequent crypto operation invoked by the
user will use the new asymmetric accessor functions instead of akcipher
api. The asymmetric subtype can internally use akcipher api or
invoke operations defined by a given subtype, depending on the
key type.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c             |   10 ++
 crypto/algif_akcipher.c     |  212 ++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/if_alg.h     |    1 
 include/uapi/linux/if_alg.h |    2 
 4 files changed, 220 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 24dc082..59c8244 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -260,6 +260,16 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 
 		err = alg_setkey(sk, optval, optlen, type->setpubkey);
 		break;
+
+	case ALG_SET_KEY_ID:
+	case ALG_SET_PUBKEY_ID:
+		/* ALG_SET_KEY_ID is only for akcipher */
+		if (!strcmp(type->name, "akcipher") ||
+		    sock->state == SS_CONNECTED)
+			goto unlock;
+
+		err = alg_setkey(sk, optval, optlen, type->setkeyid);
+		break;
 	case ALG_SET_AEAD_AUTHSIZE:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
index 2b8d37e..106f715 100644
--- a/crypto/algif_akcipher.c
+++ b/crypto/algif_akcipher.c
@@ -14,6 +14,8 @@
 #include <crypto/akcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/if_alg.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -29,6 +31,7 @@ struct akcipher_sg_list {
 
 struct akcipher_tfm {
 	struct crypto_akcipher *akcipher;
+	char keyid[12];
 	bool has_key;
 };
 
@@ -37,6 +40,7 @@ struct akcipher_ctx {
 	struct af_alg_sgl rsgl[ALG_MAX_PAGES];
 
 	struct af_alg_completion completion;
+	struct key *key;
 
 	unsigned long used;
 
@@ -317,6 +321,158 @@ unlock:
 	return err ? err : size;
 }
 
+static int asym_key_encrypt(const struct key *key, struct akcipher_request *req)
+{
+	struct kernel_pkey_params params = {0};
+	char *src = NULL, *dst = NULL, *in, *out;
+	int ret;
+
+	if (!sg_is_last(req->src)) {
+		src = kmalloc(req->src_len, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(src, req->src, 0, req->src_len, 0);
+		in = src;
+	} else {
+		in = sg_virt(req->src);
+	}
+	if (!sg_is_last(req->dst)) {
+		dst = kmalloc(req->dst_len, GFP_KERNEL);
+		if (!dst) {
+			kfree(src);
+			return -ENOMEM;
+		}
+		out = dst;
+	} else {
+		out = sg_virt(req->dst);
+	}
+	params.key = (struct key *)key;
+	params.in_len = req->src_len;
+	params.out_len = req->dst_len;
+	ret = encrypt_blob(&params, in, out);
+	if (ret)
+		goto free;
+
+	if (dst)
+		scatterwalk_map_and_copy(dst, req->dst, 0, req->dst_len, 1);
+free:
+	kfree(src);
+	kfree(dst);
+	return ret;
+}
+
+static int asym_key_decrypt(const struct key *key, struct akcipher_request *req)
+{
+	struct kernel_pkey_params params = {0};
+	char *src = NULL, *dst = NULL, *in, *out;
+	int ret;
+
+	if (!sg_is_last(req->src)) {
+		src = kmalloc(req->src_len, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(src, req->src, 0, req->src_len, 0);
+		in = src;
+	} else {
+		in = sg_virt(req->src);
+	}
+	if (!sg_is_last(req->dst)) {
+		dst = kmalloc(req->dst_len, GFP_KERNEL);
+		if (!dst) {
+			kfree(src);
+			return -ENOMEM;
+		}
+		out = dst;
+	} else {
+		out = sg_virt(req->dst);
+	}
+	params.key = (struct key *)key;
+	params.in_len = req->src_len;
+	params.out_len = req->dst_len;
+	ret = decrypt_blob(&params, in, out);
+	if (ret)
+		goto free;
+
+	if (dst)
+		scatterwalk_map_and_copy(dst, req->dst, 0, req->dst_len, 1);
+free:
+	kfree(src);
+	kfree(dst);
+	return ret;
+}
+
+static int asym_key_sign(const struct key *key, struct akcipher_request *req)
+{
+	struct kernel_pkey_params params = {0};
+	char *src = NULL, *dst = NULL, *in, *out;
+	int ret;
+
+	if (!sg_is_last(req->src)) {
+		src = kmalloc(req->src_len, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(src, req->src, 0, req->src_len, 0);
+		in = src;
+	} else {
+		in = sg_virt(req->src);
+	}
+	if (!sg_is_last(req->dst)) {
+		dst = kmalloc(req->dst_len, GFP_KERNEL);
+		if (!dst) {
+			kfree(src);
+			return -ENOMEM;
+		}
+		out = dst;
+	} else {
+		out = sg_virt(req->dst);
+	}
+	params.key = (struct key *)key;
+	params.in_len = req->src_len;
+	params.out_len = req->dst_len;
+	ret = create_signature(&params, in, out);
+	if (ret)
+		goto free;
+
+	if (dst)
+		scatterwalk_map_and_copy(dst, req->dst, 0, req->dst_len, 1);
+free:
+	kfree(src);
+	kfree(dst);
+	return ret;
+}
+
+static int asym_key_verify(const struct key *key, struct akcipher_request *req)
+{
+	struct public_key_signature sig;
+	char *src = NULL, *in, digest[20];
+	int ret;
+
+	if (!sg_is_last(req->src)) {
+		src = kmalloc(req->src_len, GFP_KERNEL);
+		if (!src)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(src, req->src, 0, req->src_len, 0);
+		in = src;
+	} else {
+		in = sg_virt(req->src);
+	}
+	sig.pkey_algo = "rsa";
+	sig.encoding = "pkcs1";
+	/* Need to find a way to pass the hash param */
+	sig.hash_algo = "sha1";
+	sig.digest_size = sizeof(digest);
+	sig.digest = digest;
+	sig.s_size = req->src_len;
+	sig.s = src;
+	ret = verify_signature(key, &sig);
+	if (!ret) {
+		req->dst_len = sizeof(digest);
+		scatterwalk_map_and_copy(digest, req->dst, 0, req->dst_len, 1);
+	}
+	kfree(src);
+	return ret;
+}
+
 static int akcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			    size_t ignored, int flags)
 {
@@ -366,16 +522,28 @@ static int akcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 				   usedpages);
 	switch (ctx->op) {
 	case ALG_OP_VERIFY:
-		err = crypto_akcipher_verify(&ctx->req);
+		if (ctx->key)
+			err = asym_key_verify(ctx->key, &ctx->req);
+		else
+			err = crypto_akcipher_verify(&ctx->req);
 		break;
 	case ALG_OP_SIGN:
-		err = crypto_akcipher_sign(&ctx->req);
+		if (ctx->key)
+			err = asym_key_sign(ctx->key, &ctx->req);
+		else
+			err = crypto_akcipher_sign(&ctx->req);
 		break;
 	case ALG_OP_ENCRYPT:
-		err = crypto_akcipher_encrypt(&ctx->req);
+		if (ctx->key)
+			err = asym_key_encrypt(ctx->key, &ctx->req);
+		else
+			err = crypto_akcipher_encrypt(&ctx->req);
 		break;
 	case ALG_OP_DECRYPT:
-		err = crypto_akcipher_decrypt(&ctx->req);
+		if (ctx->key)
+			err = asym_key_decrypt(ctx->key, &ctx->req);
+		else
+			err = crypto_akcipher_decrypt(&ctx->req);
 		break;
 	default:
 		err = -EFAULT;
@@ -568,6 +736,27 @@ static void akcipher_release(void *private)
 	kfree(tfm);
 }
 
+static int akcipher_setkeyid(void *private, const u8 *key, unsigned int keylen)
+{
+	struct akcipher_tfm *tfm = private;
+	struct key *akey;
+	u32 keyid = *((u32 *)key);
+	int err = -ENOKEY;
+
+	/* Store the key id and verify that a key with the given id is present.
+	 * The actual key will be acquired in the accept_parent function
+	 */
+	sprintf(tfm->keyid, "id:%08x", keyid);
+	akey = request_key(&key_type_asymmetric, tfm->keyid, NULL);
+	if (IS_ERR(key))
+		goto out;
+
+	tfm->has_key = true;
+	key_put(akey);
+out:
+	return err;
+}
+
 static int akcipher_setprivkey(void *private, const u8 *key,
 			       unsigned int keylen)
 {
@@ -599,6 +788,8 @@ static void akcipher_sock_destruct(struct sock *sk)
 	akcipher_put_sgl(sk);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
+	if (ctx->key)
+		key_put(ctx->key);
 }
 
 static int akcipher_accept_parent_nokey(void *private, struct sock *sk)
@@ -607,6 +798,7 @@ static int akcipher_accept_parent_nokey(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct akcipher_tfm *tfm = private;
 	struct crypto_akcipher *akcipher = tfm->akcipher;
+	struct key *key;
 	unsigned int len = sizeof(*ctx) + crypto_akcipher_reqsize(akcipher);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
@@ -623,11 +815,20 @@ static int akcipher_accept_parent_nokey(void *private, struct sock *sk)
 	af_alg_init_completion(&ctx->completion);
 	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
 
-	ask->private = ctx;
+	if (strlen(tfm->keyid)) {
+		key = request_key(&key_type_asymmetric, tfm->keyid, NULL);
+		if (IS_ERR(key)) {
+			sock_kfree_s(sk, ctx, len);
+			return -ENOKEY;
+		}
 
+		ctx->key = key;
+		memset(tfm->keyid, '\0', sizeof(tfm->keyid));
+	}
 	akcipher_request_set_tfm(&ctx->req, akcipher);
 	akcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      af_alg_complete, &ctx->completion);
+	ask->private = ctx;
 
 	sk->sk_destruct = akcipher_sock_destruct;
 
@@ -649,6 +850,7 @@ static const struct af_alg_type algif_type_akcipher = {
 	.release	=	akcipher_release,
 	.setkey		=	akcipher_setprivkey,
 	.setpubkey	=	akcipher_setpubkey,
+	.setkeyid	=	akcipher_setkeyid,
 	.accept		=	akcipher_accept_parent,
 	.accept_nokey	=	akcipher_accept_parent_nokey,
 	.ops		=	&algif_akcipher_ops,
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 6c3e6e7..09c99ab 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -53,6 +53,7 @@ struct af_alg_type {
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*setpubkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*setkeyid)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index 02e6162..0379766 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,8 @@ struct af_alg_iv {
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
 #define ALG_SET_PUBKEY			6
+#define ALG_SET_PUBKEY_ID		7
+#define ALG_SET_KEY_ID			8
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
