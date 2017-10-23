From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 21/25] fscrypt: require that key be added
 when setting a v2 encryption policy
Date: Mon, 23 Oct 2017 14:40:54 -0700
Message-ID: <20171023214058.128121-22-ebiggers3@gmail.com>
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

By looking up the master keys in a filesystem-level keyring rather than
in the calling processes' key hierarchy, it becomes possible for a user
to set an encryption policy which refers to some key they don't actually
know, then encrypt their files using that key.  Cryptographically this
shouldn't actually be a major problem; for one, every file will still be
encrypted with a unique derived key, rather than with the master key
directly.  But to be on the safe side, enforce that a v2 encryption
policy can only be set if the user has previously added the key, or has
capable(CAP_FOWNER).

We tolerate that this problem will continue to exist for v1 encryption
policies, however; there is no way around that.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  2 ++
 fs/crypto/keyinfo.c         | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  6 ++++++
 3 files changed, 50 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d0a63086fa95..7a0d5b6c2504 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -234,6 +234,8 @@ extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
 					      gfp_t gfp_flags);
 
 /* keyinfo.c */
+extern int fscrypt_verify_key_added(struct super_block *sb,
+				    const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
 extern struct key_type key_type_fscrypt_mk;
 extern struct key_type key_type_fscrypt_mk_user;
 extern void __exit fscrypt_essiv_cleanup(void);
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 1fe44983239a..fd59f37dad10 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -851,6 +851,48 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
+/*
+ * Verify that the current user has added a master key that has the given
+ * identifier (returns -ENOKEY if not).  This is needed to prevent a user from
+ * encrypting their files using some other user's key which they don't actually
+ * know.  Cryptographically speaking, it's debatable how much of a problem this
+ * actually would be, but it's best to just forbid it.
+ *
+ * The system administrator (CAP_FOWNER) can override this, which should be
+ * enough for any use cases where encryption policies are being set using keys
+ * that were chosen ahead of time but aren't available at the moment.
+ */
+int fscrypt_verify_key_added(struct super_block *sb,
+			     const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+	struct fscrypt_key_specifier mk_spec;
+	struct key *key, *mk_user;
+	struct fscrypt_master_key *mk;
+	int err;
+
+	mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+	memcpy(mk_spec.identifier, identifier, FSCRYPT_KEY_IDENTIFIER_SIZE);
+
+	key = find_master_key(sb, &mk_spec);
+	if (IS_ERR(key)) {
+		err = PTR_ERR(key);
+		goto out;
+	}
+	mk = key->payload.data[0];
+	mk_user = find_master_key_user(mk);
+	if (IS_ERR(mk_user)) {
+		err = PTR_ERR(mk_user);
+	} else {
+		key_put(mk_user);
+		err = 0;
+	}
+	key_put(key);
+out:
+	if (err == -ENOKEY && capable(CAP_FOWNER))
+		err = 0;
+	return err;
+}
+
 static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 {
 	struct fscrypt_info *ci;
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 27a391038f73..cfb404def9ed 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -170,6 +170,7 @@ static int set_encryption_policy(struct inode *inode,
 				 const union fscrypt_policy *policy)
 {
 	union fscrypt_context ctx;
+	int err;
 
 	if (!fscrypt_supported_policy(policy))
 		return -EINVAL;
@@ -190,6 +191,11 @@ static int set_encryption_policy(struct inode *inode,
 		 */
 		pr_warn_once("%s (pid %d) is setting less secure v1 encryption policy; recommend upgrading to v2.\n",
 			     current->comm, current->pid);
+	} else {
+		err = fscrypt_verify_key_added(inode->i_sb,
+					       policy->v2.master_key_identifier);
+		if (err)
+			return err;
 	}
 
 	return inode->i_sb->s_cop->set_context(inode, &ctx,
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
