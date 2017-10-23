From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 16/25] fscrypt: implement basic handling of
 v2 encryption policies
Date: Mon, 23 Oct 2017 14:40:49 -0700
Message-ID: <20171023214058.128121-17-ebiggers3@gmail.com>
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

Update the fscrypt internals to handle v2 encryption policies.  This
includes supporting getting and setting them, translating them to/from
the on-disk fscrypt_context.  It also includes storing either a v1 or v2
policy struct in the fscrypt_info for use by fscrypt_inherit_context()
and fscrypt_has_permitted_context().  (Previously we were storing the
individual fields, but it is a bit easier to store a policy struct.)

An fscrypt_policy_v1 (previously 'fscrypt_policy') maps to/from an
fscrypt_context_v1 (previously 'fscrypt_context'), while an
fscrypt_policy_v2 maps to/from an fscrypt_context_v2.

Key management for v2 policies will be implemented by later patches.
For now, attempting to set up an inode's key just fails with EOPNOTSUPP.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c               |   4 +-
 fs/crypto/fscrypt_private.h     | 172 ++++++++++++++++---
 fs/crypto/keyinfo.c             |  70 ++++----
 fs/crypto/policy.c              | 368 ++++++++++++++++++++++++++++------------
 include/linux/fscrypt.h         |   2 +-
 include/linux/fscrypt_notsupp.h |   6 +
 include/linux/fscrypt_supp.h    |   1 +
 7 files changed, 452 insertions(+), 171 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index c91bcef65b9f..78dc0e3f6328 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -46,7 +46,7 @@ static int fname_encrypt(struct inode *inode,
 	int res = 0;
 	char iv[FS_CRYPTO_BLOCK_SIZE];
 	struct scatterlist sg;
-	int padding = 4 << (ci->ci_flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
+	int padding = fscrypt_policy_fname_padding(&ci->ci_policy);
 	unsigned int lim;
 	unsigned int cryptlen;
 
@@ -217,7 +217,7 @@ u32 fscrypt_fname_encrypted_size(const struct inode *inode, u32 ilen)
 	struct fscrypt_info *ci = inode->i_crypt_info;
 
 	if (ci)
-		padding = 4 << (ci->ci_flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
+		padding = fscrypt_policy_fname_padding(&ci->ci_policy);
 	ilen = max(ilen, (u32)FS_CRYPTO_BLOCK_SIZE);
 	return round_up(ilen, padding);
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2fdc4e5c0771..dec85c4b14a8 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -29,39 +29,159 @@
 
 #define FSCRYPT_MIN_KEY_SIZE		16
 
-/**
- * Encryption context for inode
- *
- * Protector format:
- *  1 byte: Protector format (1 = this version)
- *  1 byte: File contents encryption mode
- *  1 byte: File names encryption mode
- *  1 byte: Flags
- *  8 bytes: Master Key descriptor
- *  16 bytes: Encryption Key derivation nonce
- */
-struct fscrypt_context {
-	u8 format;
+struct fscrypt_context_v1 {
+
+	u8 version; /* FSCRYPT_CONTEXT_V1 */
+
+	/* Same meaning as in v2 context --- see below */
 	u8 contents_encryption_mode;
 	u8 filenames_encryption_mode;
 	u8 flags;
+
+	/*
+	 * Descriptor for this file's master key in a process-subscribed keyring
+	 * --- typically a session keyring, or a user keyring linked into a
+	 * session or user session keyring.  This is an arbitrary value, chosen
+	 * by userspace when it set the encryption policy.  It is *not*
+	 * necessarily tied to the actual key payload.
+	 */
 	u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+
+	/*
+	 * A unique value used in combination with the master key to derive the
+	 * file's actual encryption key
+	 */
 	u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
-} __packed;
+};
+
+struct fscrypt_context_v2 {
+
+	u8 version; /* FSCRYPT_CONTEXT_V2 */
+
+	/* Encryption mode for the contents of regular files */
+	u8 contents_encryption_mode;
 
-#define FS_ENCRYPTION_CONTEXT_FORMAT_V1		1
+	/* Encryption mode for filenames in directories and symlink targets */
+	u8 filenames_encryption_mode;
+
+	/* Options that affect how encryption is done (e.g. padding amount) */
+	u8 flags;
+
+	/* Reserved, must be 0 */
+	u8 reserved[4];
+
+	/*
+	 * A cryptographic hash of the master key with which this file is
+	 * encrypted
+	 */
+	u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+
+	/*
+	 * A unique value used in combination with the master key to derive the
+	 * file's actual encryption key
+	 */
+	u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+};
+
+/**
+ * fscrypt_context - the encryption context for an inode
+ *
+ * Filesystems usually store this in an extended attribute.  It identifies the
+ * encryption algorithm and key with which the file is encrypted.
+ *
+ * Since this is stored on-disk, be careful not to reorder fields or add any
+ * implicit padding bytes!
+ */
+union fscrypt_context {
+	struct fscrypt_context_v1 v1;
+	struct fscrypt_context_v2 v2;
+};
+
+#define FSCRYPT_CONTEXT_V1	1
+#define FSCRYPT_CONTEXT_V2	2
+
+static inline int fscrypt_context_size(const union fscrypt_context *ctx)
+{
+	switch (ctx->v1.version) {
+	case FSCRYPT_CONTEXT_V1:
+		return sizeof(ctx->v1);
+	case FSCRYPT_CONTEXT_V2:
+		return sizeof(ctx->v2);
+	}
+	return 0;
+}
+
+static inline bool
+fscrypt_valid_context_format(const union fscrypt_context *ctx, int size)
+{
+	return size >= 1 && size == fscrypt_context_size(ctx);
+}
+
+#undef fscrypt_policy
+union fscrypt_policy {
+	struct fscrypt_policy_v1 v1;
+	struct fscrypt_policy_v2 v2;
+};
+
+static inline int fscrypt_policy_size(const union fscrypt_policy *policy)
+{
+	switch (policy->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY:
+		return sizeof(policy->v1);
+	case FSCRYPT_POLICY_VERSION_2:
+		return sizeof(policy->v2);
+	}
+	return 0;
+}
+
+static inline u8
+fscrypt_policy_contents_mode(const union fscrypt_policy *policy)
+{
+	switch (policy->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY:
+		return policy->v1.contents_encryption_mode;
+	case FSCRYPT_POLICY_VERSION_2:
+		return policy->v2.contents_encryption_mode;
+	}
+	BUG();
+}
+
+static inline u8
+fscrypt_policy_fnames_mode(const union fscrypt_policy *policy)
+{
+	switch (policy->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY:
+		return policy->v1.filenames_encryption_mode;
+	case FSCRYPT_POLICY_VERSION_2:
+		return policy->v2.filenames_encryption_mode;
+	}
+	BUG();
+}
+
+static inline int
+fscrypt_policy_fname_padding(const union fscrypt_policy *policy)
+{
+	switch (policy->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY:
+		return 4 << (policy->v1.flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
+	case FSCRYPT_POLICY_VERSION_2:
+		return 4 << (policy->v2.flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
+	}
+	BUG();
+}
 
 /*
- * A pointer to this structure is stored in the file system's in-core
- * representation of an inode.
+ * fscrypt_info - the "encryption key" for an inode
+ *
+ * When an encrypted file's key is made available, an instance of this struct is
+ * allocated and stored in ->i_crypt_info.  Once created, it remains until the
+ * inode is evicted.
  */
 struct fscrypt_info {
-	u8 ci_data_mode;
-	u8 ci_filename_mode;
-	u8 ci_flags;
+
+	/* The actual crypto transforms needed for encryption and decryption */
 	struct crypto_skcipher *ci_ctfm;
 	struct crypto_cipher *ci_essiv_tfm;
-	u8 ci_master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 
 	/*
 	 * The master key with which this inode was unlocked (decrypted).  This
@@ -78,6 +198,9 @@ struct fscrypt_info {
 	 * ->ci_master_key is set.
 	 */
 	struct inode *ci_inode;
+
+	/* The encryption policy used by this file */
+	union fscrypt_policy ci_policy;
 };
 
 typedef enum {
@@ -114,4 +237,11 @@ extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
 extern struct key_type key_type_fscrypt_mk;
 extern void __exit fscrypt_essiv_cleanup(void);
 
+/* policy.c */
+extern bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
+				   const union fscrypt_policy *policy2);
+extern bool fscrypt_supported_policy(const union fscrypt_policy *policy_u);
+extern void fscrypt_context_to_policy(const union fscrypt_context *ctx_u,
+				      union fscrypt_policy *policy_u);
+
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 4052030a4c96..937a678ebba1 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -649,7 +649,7 @@ static void derive_crypt_complete(struct crypto_async_request *req, int rc)
  * key is longer, then only the first 'derived_keysize' bytes are used.
  */
 static int derive_key_aes(const u8 *master_key,
-			  const struct fscrypt_context *ctx,
+			  const struct fscrypt_context_v1 *ctx,
 			  u8 *derived_key, unsigned int derived_keysize)
 {
 	int err;
@@ -751,7 +751,7 @@ find_and_lock_process_key(const char *prefix,
 }
 
 static int find_and_derive_key_legacy(const struct inode *inode,
-				      const struct fscrypt_context *ctx,
+				      const struct fscrypt_context_v1 *ctx,
 				      u8 *derived_key,
 				      unsigned int derived_keysize)
 {
@@ -786,7 +786,7 @@ static int find_and_derive_key_legacy(const struct inode *inode,
  * its fscrypt_info into ->mk_decrypted_inodes.
  */
 static int find_and_derive_key(const struct inode *inode,
-			       const struct fscrypt_context *ctx,
+			       const union fscrypt_context *ctx,
 			       u8 *derived_key, unsigned int derived_keysize,
 			       struct key **master_key_ret)
 {
@@ -795,9 +795,15 @@ static int find_and_derive_key(const struct inode *inode,
 	struct fscrypt_key_specifier mk_spec;
 	int err;
 
-	mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
-	memcpy(mk_spec.descriptor, ctx->master_key_descriptor,
-	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
+	switch (ctx->v1.version) {
+	case FSCRYPT_CONTEXT_V1:
+		mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
+		memcpy(mk_spec.descriptor, ctx->v1.master_key_descriptor,
+		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
 
 	key = find_master_key(inode->i_sb, &mk_spec);
 	if (IS_ERR(key)) {
@@ -807,7 +813,7 @@ static int find_and_derive_key(const struct inode *inode,
 		 * As a legacy fallback, we search the current task's subscribed
 		 * keyrings in addition to ->s_master_keys.
 		 */
-		return find_and_derive_key_legacy(inode, ctx, derived_key,
+		return find_and_derive_key_legacy(inode, &ctx->v1, derived_key,
 						  derived_keysize);
 	}
 	mk = key->payload.data[0];
@@ -833,7 +839,7 @@ static int find_and_derive_key(const struct inode *inode,
 		goto out_release_key;
 	}
 
-	err = derive_key_aes(mk->mk_secret.raw, ctx,
+	err = derive_key_aes(mk->mk_secret.raw, &ctx->v1,
 			     derived_key, derived_keysize);
 	if (err)
 		goto out_release_key;
@@ -862,17 +868,10 @@ static int determine_cipher_type(struct fscrypt_info *ci, struct inode *inode,
 {
 	u32 mode;
 
-	if (!fscrypt_valid_enc_modes(ci->ci_data_mode, ci->ci_filename_mode)) {
-		pr_warn_ratelimited("fscrypt: inode %lu uses unsupported encryption modes (contents mode %d, filenames mode %d)\n",
-				    inode->i_ino,
-				    ci->ci_data_mode, ci->ci_filename_mode);
-		return -EINVAL;
-	}
-
 	if (S_ISREG(inode->i_mode)) {
-		mode = ci->ci_data_mode;
+		mode = fscrypt_policy_contents_mode(&ci->ci_policy);
 	} else if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) {
-		mode = ci->ci_filename_mode;
+		mode = fscrypt_policy_fnames_mode(&ci->ci_policy);
 	} else {
 		WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %lu, which is not encryptable (file type %d)\n",
 			  inode->i_ino, (inode->i_mode & S_IFMT));
@@ -984,7 +983,7 @@ void __exit fscrypt_essiv_cleanup(void)
 int fscrypt_get_encryption_info(struct inode *inode)
 {
 	struct fscrypt_info *crypt_info;
-	struct fscrypt_context ctx;
+	union fscrypt_context ctx;
 	struct crypto_skcipher *ctfm;
 	const char *cipher_str;
 	unsigned int derived_keysize;
@@ -1006,33 +1005,31 @@ int fscrypt_get_encryption_info(struct inode *inode)
 			return res;
 		/* Fake up a context for an unencrypted directory */
 		memset(&ctx, 0, sizeof(ctx));
-		ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-		ctx.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
-		ctx.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
-		memset(ctx.master_key_descriptor, 0x42,
+		ctx.v1.version = FSCRYPT_CONTEXT_V1;
+		ctx.v1.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
+		ctx.v1.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
+		memset(ctx.v1.master_key_descriptor, 0x42,
 		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
-	} else if (res != sizeof(ctx)) {
-		return -EINVAL;
+		res = sizeof(ctx.v1);
 	}
 
-	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
-		return -EINVAL;
-
-	if (ctx.flags & ~FSCRYPT_POLICY_FLAGS_VALID)
+	if (!fscrypt_valid_context_format(&ctx, res))
 		return -EINVAL;
 
 	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_NOFS);
 	if (!crypt_info)
 		return -ENOMEM;
 
-	crypt_info->ci_flags = ctx.flags;
-	crypt_info->ci_data_mode = ctx.contents_encryption_mode;
-	crypt_info->ci_filename_mode = ctx.filenames_encryption_mode;
-	memcpy(crypt_info->ci_master_key_descriptor, ctx.master_key_descriptor,
-	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
+	fscrypt_context_to_policy(&ctx, &crypt_info->ci_policy);
+	if (!fscrypt_supported_policy(&crypt_info->ci_policy)) {
+		res = -EINVAL;
+		pr_warn_ratelimited("fscrypt: inode %lu uses unsupported encryption policy\n",
+				    inode->i_ino);
+		goto out;
+	}
 
-	res = determine_cipher_type(crypt_info, inode,
-				    &cipher_str, &derived_keysize);
+	res = determine_cipher_type(crypt_info, inode, &cipher_str,
+				    &derived_keysize);
 	if (res)
 		goto out;
 
@@ -1065,7 +1062,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		goto out;
 
 	if (S_ISREG(inode->i_mode) &&
-	    crypt_info->ci_data_mode == FSCRYPT_MODE_AES_128_CBC) {
+	    (fscrypt_policy_contents_mode(&crypt_info->ci_policy) ==
+	     FSCRYPT_MODE_AES_128_CBC)) {
 		res = init_essiv_generator(crypt_info, derived_key,
 					   derived_keysize);
 		if (res) {
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index a856c8941be6..27a391038f73 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -6,6 +6,7 @@
  *
  * Written by Michael Halcrow, 2015.
  * Modified by Jaegeuk Kim, 2015.
+ * Modified by Eric Biggers, 2017 for v2 policy support.
  */
 
 #include <linux/random.h>
@@ -13,84 +14,227 @@
 #include <linux/mount.h>
 #include "fscrypt_private.h"
 
-/*
- * check whether an encryption policy is consistent with an encryption context
- */
-static bool is_encryption_context_consistent_with_policy(
-				const struct fscrypt_context *ctx,
-				const struct fscrypt_policy *policy)
+bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
+			    const union fscrypt_policy *policy2)
+{
+	if (policy1->v1.version != policy2->v1.version)
+		return false;
+
+	return !memcmp(policy1, policy2, fscrypt_policy_size(policy1));
+}
+
+bool fscrypt_supported_policy(const union fscrypt_policy *policy_u)
+{
+	switch (policy_u->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY: {
+		const struct fscrypt_policy_v1 *policy = &policy_u->v1;
+
+		if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+					     policy->filenames_encryption_mode))
+			return false;
+
+		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID)
+			return false;
+
+		return true;
+	}
+	case FSCRYPT_POLICY_VERSION_2: {
+		const struct fscrypt_policy_v2 *policy = &policy_u->v2;
+
+		if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+					     policy->filenames_encryption_mode))
+			return false;
+
+		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID)
+			return false;
+
+		if (memchr_inv(policy->reserved, 0, sizeof(policy->reserved)))
+			return false;
+
+		return true;
+	}
+	}
+	return false;
+}
+
+static void fscrypt_policy_to_context(const union fscrypt_policy *policy_u,
+				      union fscrypt_context *ctx_u)
 {
-	return memcmp(ctx->master_key_descriptor, policy->master_key_descriptor,
-		      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
-		(ctx->flags == policy->flags) &&
-		(ctx->contents_encryption_mode ==
-		 policy->contents_encryption_mode) &&
-		(ctx->filenames_encryption_mode ==
-		 policy->filenames_encryption_mode);
+	memset(ctx_u, 0, sizeof(*ctx_u));
+
+	switch (policy_u->v1.version) {
+	case FSCRYPT_POLICY_VERSION_LEGACY: {
+		const struct fscrypt_policy_v1 *policy = &policy_u->v1;
+		struct fscrypt_context_v1 *ctx = &ctx_u->v1;
+
+		ctx->version = FSCRYPT_CONTEXT_V1;
+		ctx->contents_encryption_mode =
+			policy->contents_encryption_mode;
+		ctx->filenames_encryption_mode =
+			policy->filenames_encryption_mode;
+		ctx->flags = policy->flags;
+		memcpy(ctx->master_key_descriptor,
+		       policy->master_key_descriptor,
+		       sizeof(ctx->master_key_descriptor));
+		get_random_bytes(ctx->nonce, sizeof(ctx->nonce));
+		break;
+	}
+	case FSCRYPT_POLICY_VERSION_2: {
+		const struct fscrypt_policy_v2 *policy = &policy_u->v2;
+		struct fscrypt_context_v2 *ctx = &ctx_u->v2;
+
+		ctx->version = FSCRYPT_CONTEXT_V2;
+		ctx->contents_encryption_mode =
+			policy->contents_encryption_mode;
+		ctx->filenames_encryption_mode =
+			policy->filenames_encryption_mode;
+		ctx->flags = policy->flags;
+		memcpy(ctx->reserved, policy->reserved, sizeof(ctx->reserved));
+		memcpy(ctx->master_key_identifier,
+		       policy->master_key_identifier,
+		       sizeof(ctx->master_key_identifier));
+		get_random_bytes(ctx->nonce, sizeof(ctx->nonce));
+		break;
+	}
+	default:
+		BUG();
+	}
 }
 
-static int create_encryption_context_from_policy(struct inode *inode,
-				const struct fscrypt_policy *policy)
+void fscrypt_context_to_policy(const union fscrypt_context *ctx_u,
+			       union fscrypt_policy *policy_u)
 {
-	struct fscrypt_context ctx;
+	memset(policy_u, 0, sizeof(*policy_u));
+
+	switch (ctx_u->v1.version) {
+	case FSCRYPT_CONTEXT_V1: {
+		const struct fscrypt_context_v1 *ctx = &ctx_u->v1;
+		struct fscrypt_policy_v1 *policy = &policy_u->v1;
+
+		policy->version = FSCRYPT_POLICY_VERSION_LEGACY;
+		policy->contents_encryption_mode =
+			ctx->contents_encryption_mode;
+		policy->filenames_encryption_mode =
+			ctx->filenames_encryption_mode;
+		policy->flags = ctx->flags;
+		memcpy(policy->master_key_descriptor,
+		       ctx->master_key_descriptor,
+		       sizeof(policy->master_key_descriptor));
+		return;
+	}
+	case FSCRYPT_CONTEXT_V2: {
+		const struct fscrypt_context_v2 *ctx = &ctx_u->v2;
+		struct fscrypt_policy_v2 *policy = &policy_u->v2;
+
+		policy->version = FSCRYPT_POLICY_VERSION_2;
+		policy->contents_encryption_mode =
+			ctx->contents_encryption_mode;
+		policy->filenames_encryption_mode =
+			ctx->filenames_encryption_mode;
+		policy->flags = ctx->flags;
+		memcpy(policy->reserved, ctx->reserved,
+		       sizeof(policy->reserved));
+		memcpy(policy->master_key_identifier,
+		       ctx->master_key_identifier,
+		       sizeof(policy->master_key_identifier));
+		return;
+	}
+	default:
+		BUG();
+	}
+}
 
-	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-	memcpy(ctx.master_key_descriptor, policy->master_key_descriptor,
-					FSCRYPT_KEY_DESCRIPTOR_SIZE);
+static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
+{
+	union fscrypt_context ctx;
+	int ret;
+
+	if (inode->i_crypt_info) {
+		*policy = inode->i_crypt_info->ci_policy;
+		return 0;
+	}
+
+	if (!IS_ENCRYPTED(inode))
+		return -ENODATA;
 
-	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
-				     policy->filenames_encryption_mode))
+	ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+	if (ret < 0)
+		return (ret == -ERANGE) ? -EINVAL : ret;
+	if (!fscrypt_valid_context_format(&ctx, ret))
 		return -EINVAL;
+	fscrypt_context_to_policy(&ctx, policy);
+	return 0;
+}
+
+static int set_encryption_policy(struct inode *inode,
+				 const union fscrypt_policy *policy)
+{
+	union fscrypt_context ctx;
 
-	if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID)
+	if (!fscrypt_supported_policy(policy))
 		return -EINVAL;
 
-	ctx.contents_encryption_mode = policy->contents_encryption_mode;
-	ctx.filenames_encryption_mode = policy->filenames_encryption_mode;
-	ctx.flags = policy->flags;
-	BUILD_BUG_ON(sizeof(ctx.nonce) != FS_KEY_DERIVATION_NONCE_SIZE);
-	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
+	fscrypt_policy_to_context(policy, &ctx);
+
+	if (policy->v1.version == FSCRYPT_POLICY_VERSION_LEGACY) {
+		/*
+		 * The original encryption policy version provided no way of
+		 * verifying that the correct master key was supplied, which was
+		 * insecure in scenarios where multiple users have access to the
+		 * same encrypted files (even just read-only access).  The new
+		 * encryption policy version fixes this and also implies use of
+		 * an improved key derivation function and allows non-root users
+		 * to securely remove keys.  So as long as compatibility with
+		 * old kernels isn't required, it is recommended to use the new
+		 * policy version for all new encrypted directories.
+		 */
+		pr_warn_once("%s (pid %d) is setting less secure v1 encryption policy; recommend upgrading to v2.\n",
+			     current->comm, current->pid);
+	}
 
-	return inode->i_sb->s_cop->set_context(inode, &ctx, sizeof(ctx), NULL);
+	return inode->i_sb->s_cop->set_context(inode, &ctx,
+					       fscrypt_context_size(&ctx),
+					       NULL);
 }
 
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 {
-	struct fscrypt_policy policy;
+	union fscrypt_policy policy;
+	union fscrypt_policy existing_policy;
 	struct inode *inode = file_inode(filp);
+	int size;
 	int ret;
-	struct fscrypt_context ctx;
 
-	if (copy_from_user(&policy, arg, sizeof(policy)))
+	if (copy_from_user(&policy, arg, sizeof(u8)))
+		return -EFAULT;
+
+	size = fscrypt_policy_size(&policy);
+	if (size == 0)
+		return -EINVAL;
+
+	if (copy_from_user((u8 *)&policy + 1, arg + 1, size - 1))
 		return -EFAULT;
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
-	if (policy.version != 0)
-		return -EINVAL;
-
 	ret = mnt_want_write_file(filp);
 	if (ret)
 		return ret;
 
 	inode_lock(inode);
 
-	ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+	ret = fscrypt_get_policy(inode, &existing_policy);
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
 			ret = -ENOTEMPTY;
 		else
-			ret = create_encryption_context_from_policy(inode,
-								    &policy);
-	} else if (ret == sizeof(ctx) &&
-		   is_encryption_context_consistent_with_policy(&ctx,
-								&policy)) {
-		/* The file already uses the same encryption policy. */
-		ret = 0;
-	} else if (ret >= 0 || ret == -ERANGE) {
+			ret = set_encryption_policy(inode, &policy);
+	} else if (ret == -EINVAL ||
+		   (ret == 0 && !fscrypt_policies_equal(&policy,
+							&existing_policy))) {
 		/* The file already uses a different encryption policy. */
 		ret = -EEXIST;
 	}
@@ -102,36 +246,61 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 }
 EXPORT_SYMBOL(fscrypt_ioctl_set_policy);
 
+/* Original ioctl version; can only get the original policy version */
 int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 {
-	struct inode *inode = file_inode(filp);
-	struct fscrypt_context ctx;
-	struct fscrypt_policy policy;
-	int res;
+	union fscrypt_policy policy;
+	int err;
 
-	if (!IS_ENCRYPTED(inode))
-		return -ENODATA;
+	err = fscrypt_get_policy(file_inode(filp), &policy);
+	if (err)
+		return err;
 
-	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res < 0 && res != -ERANGE)
-		return res;
-	if (res != sizeof(ctx))
+	if (policy.v1.version != FSCRYPT_POLICY_VERSION_LEGACY)
 		return -EINVAL;
-	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
+
+	if (copy_to_user(arg, &policy, sizeof(policy.v1)))
+		return -EFAULT;
+	return 0;
+}
+EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
+
+/* Extended ioctl version; can get policies of any version */
+int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *_arg)
+{
+	struct fscrypt_get_policy_ex_args __user *arg = _arg;
+	__u64 size;
+	__u64 actual_size;
+	size_t policy_size;
+	union fscrypt_policy policy;
+	int err;
+
+	if (get_user(size, &arg->size))
+		return -EFAULT;
+
+	if (size <= offsetof(struct fscrypt_get_policy_ex_args, policy) ||
+	    size >= 65536)
 		return -EINVAL;
 
-	policy.version = 0;
-	policy.contents_encryption_mode = ctx.contents_encryption_mode;
-	policy.filenames_encryption_mode = ctx.filenames_encryption_mode;
-	policy.flags = ctx.flags;
-	memcpy(policy.master_key_descriptor, ctx.master_key_descriptor,
-				FSCRYPT_KEY_DESCRIPTOR_SIZE);
+	err = fscrypt_get_policy(file_inode(filp), &policy);
+	if (err)
+		return err;
+
+	policy_size = fscrypt_policy_size(&policy);
+	actual_size = offsetof(struct fscrypt_get_policy_ex_args, policy) +
+		      policy_size;
 
-	if (copy_to_user(arg, &policy, sizeof(policy)))
+	if (size < actual_size)
+		return -EOVERFLOW;
+
+	if (put_user(actual_size, &arg->size))
+		return -EFAULT;
+
+	if (copy_to_user(&arg->policy, &policy, policy_size))
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
+EXPORT_SYMBOL(fscrypt_ioctl_get_policy_ex);
 
 /**
  * fscrypt_has_permitted_context() - is a file's encryption policy permitted
@@ -155,10 +324,8 @@ EXPORT_SYMBOL(fscrypt_ioctl_get_policy);
  */
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 {
-	const struct fscrypt_operations *cops = parent->i_sb->s_cop;
-	const struct fscrypt_info *parent_ci, *child_ci;
-	struct fscrypt_context parent_ctx, child_ctx;
-	int res;
+	union fscrypt_policy parent_policy, child_policy;
+	int err;
 
 	/* No restrictions on file types which are never encrypted */
 	if (!S_ISREG(child->i_mode) && !S_ISDIR(child->i_mode) &&
@@ -188,41 +355,22 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 	 * In any case, if an unexpected error occurs, fall back to "forbidden".
 	 */
 
-	res = fscrypt_get_encryption_info(parent);
-	if (res)
+	err = fscrypt_get_encryption_info(parent);
+	if (err)
 		return 0;
-	res = fscrypt_get_encryption_info(child);
-	if (res)
+	err = fscrypt_get_encryption_info(child);
+	if (err)
 		return 0;
-	parent_ci = parent->i_crypt_info;
-	child_ci = child->i_crypt_info;
-
-	if (parent_ci && child_ci) {
-		return memcmp(parent_ci->ci_master_key_descriptor,
-			      child_ci->ci_master_key_descriptor,
-			      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
-			(parent_ci->ci_data_mode == child_ci->ci_data_mode) &&
-			(parent_ci->ci_filename_mode ==
-			 child_ci->ci_filename_mode) &&
-			(parent_ci->ci_flags == child_ci->ci_flags);
-	}
 
-	res = cops->get_context(parent, &parent_ctx, sizeof(parent_ctx));
-	if (res != sizeof(parent_ctx))
+	err = fscrypt_get_policy(parent, &parent_policy);
+	if (err)
 		return 0;
 
-	res = cops->get_context(child, &child_ctx, sizeof(child_ctx));
-	if (res != sizeof(child_ctx))
+	err = fscrypt_get_policy(child, &child_policy);
+	if (err)
 		return 0;
 
-	return memcmp(parent_ctx.master_key_descriptor,
-		      child_ctx.master_key_descriptor,
-		      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
-		(parent_ctx.contents_encryption_mode ==
-		 child_ctx.contents_encryption_mode) &&
-		(parent_ctx.filenames_encryption_mode ==
-		 child_ctx.filenames_encryption_mode) &&
-		(parent_ctx.flags == child_ctx.flags);
+	return fscrypt_policies_equal(&parent_policy, &child_policy);
 }
 EXPORT_SYMBOL(fscrypt_has_permitted_context);
 
@@ -238,30 +386,28 @@ EXPORT_SYMBOL(fscrypt_has_permitted_context);
 int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 						void *fs_data, bool preload)
 {
-	struct fscrypt_context ctx;
-	struct fscrypt_info *ci;
-	int res;
+	int err;
+	const struct fscrypt_info *ci;
+	union fscrypt_context ctx;
 
-	res = fscrypt_get_encryption_info(parent);
-	if (res < 0)
-		return res;
+	err = fscrypt_get_encryption_info(parent);
+	if (err)
+		return err;
 
 	ci = parent->i_crypt_info;
 	if (ci == NULL)
 		return -ENOKEY;
 
-	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
-	ctx.contents_encryption_mode = ci->ci_data_mode;
-	ctx.filenames_encryption_mode = ci->ci_filename_mode;
-	ctx.flags = ci->ci_flags;
-	memcpy(ctx.master_key_descriptor, ci->ci_master_key_descriptor,
-	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
-	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
 	BUILD_BUG_ON(sizeof(ctx) != FSCRYPT_SET_CONTEXT_MAX_SIZE);
-	res = parent->i_sb->s_cop->set_context(child, &ctx,
-						sizeof(ctx), fs_data);
-	if (res)
-		return res;
+
+	fscrypt_policy_to_context(&ci->ci_policy, &ctx);
+
+	err = parent->i_sb->s_cop->set_context(child, &ctx,
+					       fscrypt_context_size(&ctx),
+					       fs_data);
+	if (err)
+		return err;
+
 	return preload ? fscrypt_get_encryption_info(child): 0;
 }
 EXPORT_SYMBOL(fscrypt_inherit_context);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 671ce57e4673..aa8c6e8bfed8 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -86,7 +86,7 @@ struct fscrypt_operations {
 };
 
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
-#define FSCRYPT_SET_CONTEXT_MAX_SIZE	28
+#define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
 
 static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
 {
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index bd60f951b06a..41bd5b70e343 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -70,6 +70,12 @@ static inline int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_ioctl_get_policy_ex(struct file *filp,
+					      void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_has_permitted_context(struct inode *parent,
 						struct inode *child)
 {
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index ace278056dbe..a11b0b2d14b0 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -38,6 +38,7 @@ static inline void fscrypt_set_encrypted_dentry(struct dentry *dentry)
 /* policy.c */
 extern int fscrypt_ioctl_set_policy(struct file *, const void __user *);
 extern int fscrypt_ioctl_get_policy(struct file *, void __user *);
+extern int fscrypt_ioctl_get_policy_ex(struct file *, void __user *);
 extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
