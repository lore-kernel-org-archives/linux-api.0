From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 18/25] fscrypt: allow adding and removing
 keys for v2 encryption policies
Date: Mon, 23 Oct 2017 14:40:51 -0700
Message-ID: <20171023214058.128121-19-ebiggers3@gmail.com>
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

Extend the FS_IOC_ADD_ENCRYPTION_KEY and FS_IOC_REMOVE_ENCRYPTION_KEY
ioctls to support adding and removing keys for use by v2 encryption
policies.

Keys for v2 encryption policies are identified by a 16-byte
"identifier", which is a cryptographic hash of the key, instead of by an
8-byte "descriptor".  For FS_IOC_ADD_ENCRYPTION_KEY, the kernel
calculates the key identifier and copies it to userspace.  Userspace is
not allowed to choose the key identifier, since the kernel would have to
recalculate it anyway to verify that it is correct.

For FS_IOC_REMOVE_ENCRYPTION_KEY, userspace provides the key identifier
rather than the key descriptor to identify the key to be removed.  For
both ioctls, a type field indicates whether the old or new way of
specifying keys is being used.  A common structure is used, 'struct
fscrypt_key_specifier', and it has some extra space just in case we have
to introduce a new way to identify keys in the future.

Note that keys for v1 and v2 encryption policies are both stored in
->s_master_keys, but their descriptions will be of different lengths.
Therefore, they cannot be mixed up when we search for a key.

For now the ioctls still always require capable(CAP_SYS_ADMIN).  We'll
be able to relax that soon, but only for v2 policies.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c          | 75 ++++++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/fscrypt.h |  2 ++
 2 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index e9de625ddfe4..c9e7b2b262d2 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -32,6 +32,19 @@
 #define HKDF_HMAC_ALG		"hmac(sha512)"
 #define HKDF_HASHLEN		SHA512_DIGEST_SIZE
 
+/*
+ * The list of contexts in which we use HKDF to derive additional keys from a
+ * master key.  The values in this list are used as the first byte of the
+ * application-specific info string to guarantee that info strings are never
+ * repeated between contexts.
+ *
+ * Keys derived with different info strings are cryptographically isolated from
+ * each other --- knowledge of one derived key doesn't reveal any others.
+ * (This property is particularly important for the derived key used as the
+ * "key identifier", as that is stored in the clear.)
+ */
+#define HKDF_CONTEXT_KEY_IDENTIFIER	1
+
 /*
  * HKDF consists of two steps:
  *
@@ -228,7 +241,12 @@ struct fscrypt_master_key {
 	 */
 	struct fscrypt_master_key_secret	mk_secret;
 
-	/* Arbitrary key descriptor which was assigned by userspace */
+	/*
+	 * For v1 policy keys: an arbitrary key descriptor which was assigned by
+	 * userspace (->descriptor).
+	 *
+	 * For v2 policy keys: a cryptographic hash of this key (->identifier).
+	 */
 	struct fscrypt_key_specifier		mk_spec;
 
 	/*
@@ -252,6 +270,8 @@ static inline int master_key_spec_len(const struct fscrypt_key_specifier *spec)
 	switch (spec->type) {
 	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
 		return FSCRYPT_KEY_DESCRIPTOR_SIZE;
+	case FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER:
+		return FSCRYPT_KEY_IDENTIFIER_SIZE;
 	}
 	return 0;
 }
@@ -346,7 +366,7 @@ static struct key *search_fscrypt_keyring(struct key *keyring,
 #define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE	\
 	(sizeof("fscrypt-") - 1 + sizeof(((struct super_block *)0)->s_id) + 1)
 
-#define FSCRYPT_MK_DESCRIPTION_SIZE	(2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
+#define FSCRYPT_MK_DESCRIPTION_SIZE	(2 * FSCRYPT_KEY_IDENTIFIER_SIZE + 1)
 
 static void format_fs_keyring_description(
 			char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
@@ -550,6 +570,39 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	if (copy_from_user(secret.raw, uarg->raw, secret.size))
 		goto out_wipe_secret;
 
+	if (arg.key_spec.type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
+		struct crypto_shash *hmac_tfm;
+
+		hmac_tfm = allocate_hmac_tfm(secret.raw, secret.size);
+		if (IS_ERR(hmac_tfm)) {
+			err = PTR_ERR(hmac_tfm);
+			goto out_wipe_secret;
+		}
+
+		/*
+		 * Hash the master key to get the key identifier, then return it
+		 * to userspace.  Specifically, we derive the key identifier
+		 * from the master key with HKDF-SHA512, using a unique
+		 * application-specific info string.  This is preferable to a
+		 * simple truncated SHA512 because it means we only ever use the
+		 * master key for a single cryptographic primitive (HKDF-SHA512)
+		 * rather than two (HKDF-SHA512 and SHA512).  It *maybe* would
+		 * be okay, but cryptographically it would be bad practice.
+		 */
+		err = hkdf_expand(hmac_tfm, HKDF_CONTEXT_KEY_IDENTIFIER,
+				  NULL, 0, arg.key_spec.identifier,
+				  FSCRYPT_KEY_IDENTIFIER_SIZE);
+		crypto_free_shash(hmac_tfm);
+		if (err)
+			goto out_wipe_secret;
+
+		err = -EFAULT;
+		if (copy_to_user(uarg->key_spec.identifier,
+				 arg.key_spec.identifier,
+				 FSCRYPT_KEY_IDENTIFIER_SIZE))
+			goto out_wipe_secret;
+	}
+
 	err = add_master_key(sb, &secret, &arg.key_spec);
 out_wipe_secret:
 	wipe_master_key_secret(&secret);
@@ -872,6 +925,10 @@ static int derive_key_aes(const u8 *master_key,
  * Search the current task's subscribed keyrings for a "logon" key with
  * description prefix:descriptor, and if found acquire a read lock on it and
  * return a pointer to its validated payload in *payload_ret.
+ *
+ * This is only used for v1 encryption policies, where keys are identified by
+ * master_key_descriptor.  With newer policy versions, only the filesystem-level
+ * keyring (->s_master_keys) is supported.
  */
 static struct key *
 find_and_lock_process_key(const char *prefix,
@@ -977,17 +1034,23 @@ static int find_and_derive_key(const struct inode *inode,
 		memcpy(mk_spec.descriptor, ctx->v1.master_key_descriptor,
 		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 		break;
+	case FSCRYPT_CONTEXT_V2:
+		mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+		memcpy(mk_spec.identifier, ctx->v2.master_key_identifier,
+		       FSCRYPT_KEY_IDENTIFIER_SIZE);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		return -EOPNOTSUPP; /* should have been checked earlier too */
 	}
 
 	key = find_master_key(inode->i_sb, &mk_spec);
 	if (IS_ERR(key)) {
-		if (key != ERR_PTR(-ENOKEY))
+		if (key != ERR_PTR(-ENOKEY) ||
+		    ctx->v1.version != FSCRYPT_CONTEXT_V1)
 			return PTR_ERR(key);
 		/*
-		 * As a legacy fallback, we search the current task's subscribed
-		 * keyrings in addition to ->s_master_keys.
+		 * As a legacy fallback for v1 policies, we search the current
+		 * task's subscribed keyrings in addition to ->s_master_keys.
 		 */
 		return find_and_derive_key_legacy(inode, &ctx->v1, derived_key,
 						  derived_keysize);
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 065060b20a34..1918bdc0c6d7 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -82,10 +82,12 @@ struct fscrypt_get_policy_ex_args {
 struct fscrypt_key_specifier {
 	__u32 type;
 #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
+#define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
 	__u32 reserved;
 	union {
 		__u8 max_specifier[32];
 		__u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+		__u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
 	};
 };
 
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
