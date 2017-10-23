From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 04/25] fscrypt: refactor finding and deriving
 key
Date: Mon, 23 Oct 2017 14:40:37 -0700
Message-ID: <20171023214058.128121-5-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171023214058.128121-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Ryo Hashimoto <hashimoto@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>, linux-api@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, Michael Halcrow <mhalcrow@google.com>, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for introducing a new way to find the master keys and
derive the per-file keys, clean up the current method.  This includes:

- Introduce a helper function find_and_derive_key() so that we don't
  have to add more code directly to fscrypt_get_encryption_info().

- Don't pass the 'struct fscrypt_key' directly into derive_key_aes().
  This is in preparation for the case where we find the master key in a
  filesystem-level keyring, where (for good reasons) the key payload
  will *not* be formatted as the UAPI 'struct fscrypt_key'.

- Separate finding the key from key derivation.  In particular, it
  *only* makes sense to fall back to the alternate key description
  prefix if searching for the "fscrypt:" prefix returns -ENOKEY.  It
  doesn't make sense to do so when derive_key_aes() fails, for example.

- Improve the error messages for when the fscrypt_key is invalid.

- Rename 'raw_key' to 'derived_key' for clarity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 205 ++++++++++++++++++++++++++++------------------------
 1 file changed, 109 insertions(+), 96 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index ac41f646e7b7..d3a97c2cd4dd 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -28,113 +28,138 @@ static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 	complete(&ecr->completion);
 }
 
-/**
- * derive_key_aes() - Derive a key using AES-128-ECB
- * @deriving_key: Encryption key used for derivation.
- * @source_key:   Source key to which to apply derivation.
- * @derived_raw_key:  Derived raw key.
+/*
+ * Key derivation function.  This generates the derived key by encrypting the
+ * master key with AES-128-ECB using the nonce as the AES key.
  *
- * Return: Zero on success; non-zero otherwise.
+ * The master key must be at least as long as the derived key.  If the master
+ * key is longer, then only the first 'derived_keysize' bytes are used.
  */
-static int derive_key_aes(u8 deriving_key[FS_AES_128_ECB_KEY_SIZE],
-				const struct fscrypt_key *source_key,
-				u8 derived_raw_key[FSCRYPT_MAX_KEY_SIZE])
+static int derive_key_aes(const u8 *master_key,
+			  const struct fscrypt_context *ctx,
+			  u8 *derived_key, unsigned int derived_keysize)
 {
-	int res = 0;
+	int err;
 	struct skcipher_request *req = NULL;
 	DECLARE_FS_COMPLETION_RESULT(ecr);
 	struct scatterlist src_sg, dst_sg;
-	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	struct crypto_skcipher *tfm;
+
+	tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
-	if (IS_ERR(tfm)) {
-		res = PTR_ERR(tfm);
-		tfm = NULL;
-		goto out;
-	}
 	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
 	if (!req) {
-		res = -ENOMEM;
+		err = -ENOMEM;
 		goto out;
 	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 			derive_crypt_complete, &ecr);
-	res = crypto_skcipher_setkey(tfm, deriving_key,
-					FS_AES_128_ECB_KEY_SIZE);
-	if (res < 0)
+
+	BUILD_BUG_ON(sizeof(ctx->nonce) != FS_AES_128_ECB_KEY_SIZE);
+	err = crypto_skcipher_setkey(tfm, ctx->nonce, sizeof(ctx->nonce));
+	if (err)
 		goto out;
 
-	sg_init_one(&src_sg, source_key->raw, source_key->size);
-	sg_init_one(&dst_sg, derived_raw_key, source_key->size);
-	skcipher_request_set_crypt(req, &src_sg, &dst_sg, source_key->size,
+	sg_init_one(&src_sg, master_key, derived_keysize);
+	sg_init_one(&dst_sg, derived_key, derived_keysize);
+	skcipher_request_set_crypt(req, &src_sg, &dst_sg, derived_keysize,
 				   NULL);
-	res = crypto_skcipher_encrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
+	err = crypto_skcipher_encrypt(req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
 		wait_for_completion(&ecr.completion);
-		res = ecr.res;
+		err = ecr.res;
 	}
 out:
 	skcipher_request_free(req);
 	crypto_free_skcipher(tfm);
-	return res;
+	return err;
 }
 
-static int validate_user_key(struct fscrypt_info *crypt_info,
-			struct fscrypt_context *ctx, u8 *raw_key,
-			const char *prefix, int min_keysize)
+/*
+ * Search the current task's subscribed keyrings for a "logon" key with
+ * description prefix:descriptor, and if found acquire a read lock on it and
+ * return a pointer to its validated payload in *payload_ret.
+ */
+static struct key *
+find_and_lock_process_key(const char *prefix,
+			  const u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE],
+			  unsigned int min_keysize,
+			  const struct fscrypt_key **payload_ret)
 {
 	char *description;
-	struct key *keyring_key;
-	struct fscrypt_key *master_key;
+	struct key *key;
 	const struct user_key_payload *ukp;
-	int res;
+	const struct fscrypt_key *payload;
 
 	description = kasprintf(GFP_NOFS, "%s%*phN", prefix,
-				FSCRYPT_KEY_DESCRIPTOR_SIZE,
-				ctx->master_key_descriptor);
+				FSCRYPT_KEY_DESCRIPTOR_SIZE, descriptor);
 	if (!description)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	keyring_key = request_key(&key_type_logon, description, NULL);
+	key = request_key(&key_type_logon, description, NULL);
 	kfree(description);
-	if (IS_ERR(keyring_key))
-		return PTR_ERR(keyring_key);
-	down_read(&keyring_key->sem);
-
-	if (keyring_key->type != &key_type_logon) {
-		printk_once(KERN_WARNING
-				"%s: key type must be logon\n", __func__);
-		res = -ENOKEY;
-		goto out;
-	}
-	ukp = user_key_payload_locked(keyring_key);
-	if (!ukp) {
-		/* key was revoked before we acquired its semaphore */
-		res = -EKEYREVOKED;
-		goto out;
+	if (IS_ERR(key))
+		return key;
+
+	down_read(&key->sem);
+	ukp = user_key_payload_locked(key);
+
+	if (!ukp) /* was the key revoked before we acquired its semaphore? */
+		goto invalid;
+
+	payload = (const struct fscrypt_key *)ukp->data;
+
+	if (ukp->datalen != sizeof(struct fscrypt_key) ||
+	    payload->size < 1 || payload->size > FSCRYPT_MAX_KEY_SIZE) {
+		pr_warn_ratelimited("fscrypt: key with description '%s' has invalid payload\n",
+				    key->description);
+		goto invalid;
 	}
-	if (ukp->datalen != sizeof(struct fscrypt_key)) {
-		res = -EINVAL;
-		goto out;
+
+	if (payload->size < min_keysize) {
+		pr_warn_ratelimited("fscrypt: key with description '%s' is too short "
+				    "(got %u bytes, need %u+ bytes)\n",
+				    key->description,
+				    payload->size, min_keysize);
+		goto invalid;
 	}
-	master_key = (struct fscrypt_key *)ukp->data;
-	BUILD_BUG_ON(FS_AES_128_ECB_KEY_SIZE != FS_KEY_DERIVATION_NONCE_SIZE);
-
-	if (master_key->size < min_keysize ||
-	    master_key->size > FSCRYPT_MAX_KEY_SIZE
-	    || master_key->size % AES_BLOCK_SIZE != 0) {
-		printk_once(KERN_WARNING
-				"%s: key size incorrect: %d\n",
-				__func__, master_key->size);
-		res = -ENOKEY;
-		goto out;
+
+	*payload_ret = payload;
+	return key;
+
+invalid:
+	up_read(&key->sem);
+	key_put(key);
+	return ERR_PTR(-ENOKEY);
+}
+
+/* Find the master key, then derive the inode's actual encryption key */
+static int find_and_derive_key(const struct inode *inode,
+			       const struct fscrypt_context *ctx,
+			       u8 *derived_key, unsigned int derived_keysize)
+{
+	struct key *key;
+	const struct fscrypt_key *payload;
+	int err;
+
+	key = find_and_lock_process_key(FSCRYPT_KEY_DESC_PREFIX,
+					ctx->master_key_descriptor,
+					derived_keysize, &payload);
+	if (key == ERR_PTR(-ENOKEY) && inode->i_sb->s_cop->key_prefix) {
+		key = find_and_lock_process_key(inode->i_sb->s_cop->key_prefix,
+						ctx->master_key_descriptor,
+						derived_keysize, &payload);
 	}
-	res = derive_key_aes(ctx->nonce, master_key, raw_key);
-out:
-	up_read(&keyring_key->sem);
-	key_put(keyring_key);
-	return res;
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+	err = derive_key_aes(payload->raw, ctx, derived_key, derived_keysize);
+	up_read(&key->sem);
+	key_put(key);
+	return err;
 }
 
 static const struct {
@@ -256,8 +281,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	struct fscrypt_context ctx;
 	struct crypto_skcipher *ctfm;
 	const char *cipher_str;
-	int keysize;
-	u8 *raw_key = NULL;
+	unsigned int derived_keysize;
+	u8 *derived_key = NULL;
 	int res;
 
 	if (inode->i_crypt_info)
@@ -301,7 +326,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	memcpy(crypt_info->ci_master_key, ctx.master_key_descriptor,
 				sizeof(crypt_info->ci_master_key));
 
-	res = determine_cipher_type(crypt_info, inode, &cipher_str, &keysize);
+	res = determine_cipher_type(crypt_info, inode,
+				    &cipher_str, &derived_keysize);
 	if (res)
 		goto out;
 
@@ -310,24 +336,14 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	 * crypto API as part of key derivation.
 	 */
 	res = -ENOMEM;
-	raw_key = kmalloc(FSCRYPT_MAX_KEY_SIZE, GFP_NOFS);
-	if (!raw_key)
+	derived_key = kmalloc(FS_MAX_KEY_SIZE, GFP_NOFS);
+	if (!derived_key)
 		goto out;
 
-	res = validate_user_key(crypt_info, &ctx, raw_key,
-				FSCRYPT_KEY_DESC_PREFIX, keysize);
-	if (res && inode->i_sb->s_cop->key_prefix) {
-		int res2 = validate_user_key(crypt_info, &ctx, raw_key,
-					     inode->i_sb->s_cop->key_prefix,
-					     keysize);
-		if (res2) {
-			if (res2 == -ENOKEY)
-				res = -ENOKEY;
-			goto out;
-		}
-	} else if (res) {
+	res = find_and_derive_key(inode, &ctx, derived_key, derived_keysize);
+	if (res)
 		goto out;
-	}
+
 	ctfm = crypto_alloc_skcipher(cipher_str, 0, 0);
 	if (!ctfm || IS_ERR(ctfm)) {
 		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
@@ -338,17 +354,14 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	crypt_info->ci_ctfm = ctfm;
 	crypto_skcipher_clear_flags(ctfm, ~0);
 	crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_REQ_WEAK_KEY);
-	/*
-	 * if the provided key is longer than keysize, we use the first
-	 * keysize bytes of the derived key only
-	 */
-	res = crypto_skcipher_setkey(ctfm, raw_key, keysize);
+	res = crypto_skcipher_setkey(ctfm, derived_key, derived_keysize);
 	if (res)
 		goto out;
 
 	if (S_ISREG(inode->i_mode) &&
 	    crypt_info->ci_data_mode == FSCRYPT_MODE_AES_128_CBC) {
-		res = init_essiv_generator(crypt_info, raw_key, keysize);
+		res = init_essiv_generator(crypt_info, derived_key,
+					   derived_keysize);
 		if (res) {
 			pr_debug("%s: error %d (inode %lu) allocating essiv tfm\n",
 				 __func__, res, inode->i_ino);
@@ -361,7 +374,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	if (res == -ENOKEY)
 		res = 0;
 	put_crypt_info(crypt_info);
-	kzfree(raw_key);
+	kzfree(derived_key);
 	return res;
 }
 EXPORT_SYMBOL(fscrypt_get_encryption_info);
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
