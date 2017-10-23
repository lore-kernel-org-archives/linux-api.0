From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 06/25] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY
 ioctl
Date: Mon, 23 Oct 2017 14:40:39 -0700
Message-ID: <20171023214058.128121-7-ebiggers3@gmail.com>
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

Add a new filesystem encryption ioctl, FS_IOC_ADD_ENCRYPTION_KEY.  This
ioctl adds a master encryption key to the filesystem encryption keyring
->s_master_keys.

When a process tries to access an encrypted file that has not yet been
"unlocked" (set up with an ->i_crypt_info containing a crypto transform
keyed by the file's derived key), fscrypt_get_encryption_info() will
search for the master key in ->s_master_keys before falling back to the
process-subscribed keyrings.

For now this ioctl is root-only, which is necessary in part because the
keys are identified by master_key_descriptor, which is not
cryptographically tied to the actual key payload.  However, a later
patch will introduce a new encryption policy version where the key is
identified by a cryptographic hash.  This will, in combination with
other protections, make it possible for non-root users to use this ioctl
in some situations.

Why we need this
~~~~~~~~~~~~~~~~

The main problem is that the "locked/unlocked" (ciphertext/plaintext)
status of encrypted files is global, but currently the master keys are
not.  We only look for master keys in the process-subscribed keyrings;
that is, the current thread keyring, process keyring, and session
keyring, where the session keyring usually contains the user keyring.
This means we have to put the master keys in the keyrings for individual
users or for individual sessions.  This causes much confusion as soon as
a process with a different UID, such as a 'sudo' command, tries to
access encrypted files.  In such a situation, whether each individual
inode appears "locked" or "unlocked" will depend on whether it was
previously accessed and happens to still be in the inode cache, which is
more or less nondeterministic.

It may seem that we should indeed provide each process its own "view" of
the filesystem depending on whether it "has the key" or not.  However
that would be extremely difficult to do without a separate mount, due to
the way the VFS caches work.  Furthermore, it is actually missing the
point of encryption because it would *not* be encryption that would
provide the different "views", but rather kernel *code*.  Thus, it would
simply be an access control mechanism largely redundant with the many
existing access control mechanisms such as UNIX file permissions and
LSMs.  The reality is that the confidentially of encrypted files *after
the kernel already has the encryption key in memory* is only protected
by the correctness of the kernel, not by the mathematical properties of
encryption.

And at the end of the day, almost all users of filesystem encryption we
are aware of do really need the global view, because they need encrypted
files to be accessible to processes running under different UIDs.  This
can be as simple as needing to be able to run 'sudo', or it can be
something more complex like Android's key management system where
applications running under different UIDs as well as system processes
need access to the same encrypted files.

As a result, some very ugly hacks have been added to try to emulate
globally visible keys.  The Android and Chromium OS key management
systems simply create a "session" keyring in PID 1 and put all the keys
in it, which abuses the "session" keyring to have nothing to do with a
"session", but rather be a global keyring.  This is fragile, as it means
that the "session" keyring must never be changed.  There have also been
bugs involving processes that were forked before the "session" keyring
was created, causing them to miss out on the keys.

Meanwhile, filesystem encryption tools written for general-purpose Linux
distributions have no such ability to abuse the "session" keyring.  They
instead must implement "interesting" workarounds such as linking all the
user keyrings into root's user keyring, as is done by the fscrypt
userspace tool (see the design document at https://goo.gl/55cCrI).  This
raises security concerns, to say the least.

By having an API to add a key to the *filesystem* we'll be able to
eliminate all the above hacks and better express the intended semantics:
the "locked/unlocked" status of an encrypted directory is global.  And
orthogonally to encryption, existing mechanisms such as file permissions
and LSMs can and should continue to be used for the purpose of *access
control*.

Why use a custom key type
~~~~~~~~~~~~~~~~~~~~~~~~~

The keys the new ioctl adds to ->s_master_keys are still "keys" in the
sense of the keyrings service, but they have a custom key type rather
than the "logon" key type we currently require when userspace provides a
key via a process-subscribed keyring.

Judging just from this patch alone, the "logon" key type would be
sufficient.  However, later patches will be solving problems such as the
nonstandard KDF and the lack of a key removal API.  The solutions for
these problems will require tracking information on a per-master-key
basis.  Therefore, we'll need a custom structure associated with each
master key anyway.  A custom key type lets us do that easily.

Why not use add_key()
~~~~~~~~~~~~~~~~~~~~~

Instead of adding a new ioctl() to add a key, we could have userspace
use the add_key() system call.  In combination with an ioctl which
retrieves the key ID of ->s_master_keys, add_key() could be used to add
a key to ->s_master_keys.  Alternatively, we could add the concept of a
"global keyring" or "namespace keyring" to the keyrings service, where
that keyring would be searched in addition to the process-subscribed
keyrings.  Then, add_key() could add a key to that.

This actually makes sense given only the present patch.  However,
unfortunately it falls apart once we consider the follow-on changes.

First, we also need to add the ability to remove an encryption key, and
it will need to have more specialized semantics than keyctl_unlink() or
keyctl_revoke() can provide.  For example, we must not only wipe the
master key *secret* from memory, but we must also try to evict all the
inodes which had been "unlocked" using the key.  And it's possible that
even though the master key secret was wiped, some inodes could not be
evicted, since they may be busy.  In that case, we still want to wipe
the master key *secret* so that no more encrypted files can be
"unlocked".  But we also want to allow userspace to retry the request
later, so that evicting the remaining inodes can be re-attempted.
Alternatively, we want the same list of inodes to be picked up again if
the secret happens to be added again.  Trying to shoehorn these specific
semantics into the keyrings API would be very difficult.

Later we also want to open up the add/remove key operations to non-root
users by taking advantage of a new encryption policy version which
includes a cryptographic hash of the master key.  This is needed because
otherwise we wouldn't be able to fully replace the process-subscribed
keyrings and avoid all its problems mentioned earlier.  But to actually
make non-root use secure, we'll need to do some extra accounting where
we keep track of all users who have added a given key, then only really
remove a key after all users have removed it.  Non-root users also
cannot simply be given write permission to a global keyring.  So again,
it seems that trying to shoehorn the needed semantics into the keyrings
API would just create problems.

Nevertheless, we do still use the keyrings service internally so that we
reuse some code and get some "free" functionality such as having the
keys show up in /proc/keys for debugging purposes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c              |  12 +-
 fs/crypto/fscrypt_private.h     |   3 +
 fs/crypto/keyinfo.c             | 351 +++++++++++++++++++++++++++++++++++++++-
 include/linux/fscrypt_notsupp.h |   5 +
 include/linux/fscrypt_supp.h    |   1 +
 include/uapi/linux/fscrypt.h    |  41 +++--
 6 files changed, 397 insertions(+), 16 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 608f6bbe0f31..489c504ac20d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
+#include <linux/key-type.h>
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <crypto/aes.h>
@@ -449,6 +450,8 @@ int fscrypt_initialize(unsigned int cop_flags)
  */
 static int __init fscrypt_init(void)
 {
+	int err = -ENOMEM;
+
 	fscrypt_read_workqueue = alloc_workqueue("fscrypt_read_queue",
 							WQ_HIGHPRI, 0);
 	if (!fscrypt_read_workqueue)
@@ -462,14 +465,20 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_info_cachep)
 		goto fail_free_ctx;
 
+	err = register_key_type(&key_type_fscrypt_mk);
+	if (err)
+		goto fail_free_info;
+
 	return 0;
 
+fail_free_info:
+	kmem_cache_destroy(fscrypt_info_cachep);
 fail_free_ctx:
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 fail_free_queue:
 	destroy_workqueue(fscrypt_read_workqueue);
 fail:
-	return -ENOMEM;
+	return err;
 }
 module_init(fscrypt_init)
 
@@ -484,6 +493,7 @@ static void __exit fscrypt_exit(void)
 		destroy_workqueue(fscrypt_read_workqueue);
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 	kmem_cache_destroy(fscrypt_info_cachep);
+	unregister_key_type(&key_type_fscrypt_mk);
 
 	fscrypt_essiv_cleanup();
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5cb80a2d39ea..b2fad12eeedb 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -27,6 +27,8 @@
 
 #define FS_KEY_DERIVATION_NONCE_SIZE		16
 
+#define FSCRYPT_MIN_KEY_SIZE		16
+
 /**
  * Encryption context for inode
  *
@@ -93,6 +95,7 @@ extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
 					      gfp_t gfp_flags);
 
 /* keyinfo.c */
+extern struct key_type key_type_fscrypt_mk;
 extern void __exit fscrypt_essiv_cleanup(void);
 
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index d3a97c2cd4dd..3f1cb8bbc1e5 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -9,14 +9,307 @@
  */
 
 #include <keys/user-type.h>
-#include <linux/scatterlist.h>
+#include <linux/key-type.h>
 #include <linux/ratelimit.h>
+#include <linux/scatterlist.h>
+#include <linux/seq_file.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include "fscrypt_private.h"
 
 static struct crypto_shash *essiv_hash_tfm;
 
+/*
+ * fscrypt_master_key_secret - secret key material of an in-use master key
+ */
+struct fscrypt_master_key_secret {
+
+	/* Size of the raw key in bytes */
+	u32			size;
+
+	/* The raw key */
+	u8			raw[FSCRYPT_MAX_KEY_SIZE];
+};
+
+/*
+ * fscrypt_master_key - an in-use master key
+ *
+ * This represents a master encryption key which has been added to the
+ * filesystem and can be used to "unlock" the encrypted files which were
+ * encrypted with it.
+ */
+struct fscrypt_master_key {
+
+	/* The secret key material */
+	struct fscrypt_master_key_secret	mk_secret;
+
+	/* Arbitrary key descriptor which was assigned by userspace */
+	struct fscrypt_key_specifier		mk_spec;
+};
+
+static inline int master_key_spec_len(const struct fscrypt_key_specifier *spec)
+{
+	switch (spec->type) {
+	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
+		return FSCRYPT_KEY_DESCRIPTOR_SIZE;
+	}
+	return 0;
+}
+
+static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
+{
+	if (spec->reserved)
+		return false;
+	return master_key_spec_len(spec) != 0;
+}
+
+static void wipe_master_key_secret(struct fscrypt_master_key_secret *secret)
+{
+	memzero_explicit(secret, sizeof(*secret));
+}
+
+static void move_master_key_secret(struct fscrypt_master_key_secret *dst,
+				   struct fscrypt_master_key_secret *src)
+{
+	memcpy(dst, src, sizeof(*dst));
+	memzero_explicit(src, sizeof(*src));
+}
+
+static void free_master_key(struct fscrypt_master_key *mk)
+{
+	wipe_master_key_secret(&mk->mk_secret);
+	kzfree(mk);
+}
+
+static int fscrypt_key_instantiate(struct key *key,
+				   struct key_preparsed_payload *prep)
+{
+	key->payload.data[0] = (struct fscrypt_master_key *)prep->data;
+	return 0;
+}
+
+static void fscrypt_key_destroy(struct key *key)
+{
+	free_master_key(key->payload.data[0]);
+}
+
+static void fscrypt_key_describe(const struct key *key, struct seq_file *m)
+{
+	seq_puts(m, key->description);
+}
+
+/*
+ * Type of key in ->s_master_keys.  Each key of this type represents a master
+ * key which has been added to the filesystem.  Its payload is a
+ * 'struct fscrypt_master_key'.
+ */
+struct key_type key_type_fscrypt_mk = {
+	.name			= "._fscrypt",
+	.instantiate		= fscrypt_key_instantiate,
+	.destroy		= fscrypt_key_destroy,
+	.describe		= fscrypt_key_describe,
+};
+
+/*
+ * Search ->s_master_keys.  Note that we mark the keyring reference as
+ * "possessed" so that we can use the KEY_POS_SEARCH permission.
+ */
+static struct key *search_fscrypt_keyring(struct key *keyring,
+					  struct key_type *type,
+					  const char *description)
+{
+	key_ref_t keyref;
+
+	keyref = keyring_search(make_key_ref(keyring, 1), type, description);
+	if (IS_ERR(keyref)) {
+		if (PTR_ERR(keyref) == -EAGAIN)
+			keyref = ERR_PTR(-ENOKEY);
+		return ERR_CAST(keyref);
+	}
+	return key_ref_to_ptr(keyref);
+}
+
+#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE	\
+	(sizeof("fscrypt-") - 1 + sizeof(((struct super_block *)0)->s_id) + 1)
+
+#define FSCRYPT_MK_DESCRIPTION_SIZE	(2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
+
+static void format_fs_keyring_description(
+			char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
+			const struct super_block *sb)
+{
+	sprintf(description, "fscrypt-%s", sb->s_id);
+}
+
+static void format_mk_description(
+			char description[FSCRYPT_MK_DESCRIPTION_SIZE],
+			const struct fscrypt_key_specifier *mk_spec)
+{
+	sprintf(description, "%*phN",
+		master_key_spec_len(mk_spec), mk_spec->max_specifier);
+}
+
+/*
+ * Find the specified master key in ->s_master_keys.
+ * Returns ERR_PTR(-ENOKEY) if not found.
+ */
+static struct key *find_master_key(struct super_block *sb,
+				   const struct fscrypt_key_specifier *mk_spec)
+{
+	struct key *keyring;
+	char description[FSCRYPT_MK_DESCRIPTION_SIZE];
+
+	/* pairs with smp_store_release() in add_to_filesystem_keyring() */
+	keyring = smp_load_acquire(&sb->s_master_keys);
+	if (keyring == NULL)
+		return ERR_PTR(-ENOKEY);
+
+	format_mk_description(description, mk_spec);
+	return search_fscrypt_keyring(keyring, &key_type_fscrypt_mk,
+				      description);
+}
+
+static struct key *
+allocate_master_key(struct fscrypt_master_key_secret *secret,
+		    const struct fscrypt_key_specifier *mk_spec)
+{
+	struct fscrypt_master_key *mk;
+	struct key *key;
+	char description[FSCRYPT_MK_DESCRIPTION_SIZE];
+	int err;
+
+	mk = kzalloc(sizeof(*mk), GFP_NOFS);
+	if (!mk)
+		return ERR_PTR(-ENOMEM);
+
+	mk->mk_spec = *mk_spec;
+
+	move_master_key_secret(&mk->mk_secret, secret);
+
+	format_mk_description(description, mk_spec);
+	key = key_alloc(&key_type_fscrypt_mk, description,
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
+			KEY_POS_SEARCH | KEY_USR_SEARCH |
+			KEY_USR_READ | KEY_USR_VIEW, 0, NULL);
+	if (IS_ERR(key))
+		goto out_free_mk;
+
+	err = key_instantiate_and_link(key, mk, sizeof(*mk), NULL, NULL);
+	if (err) {
+		key_put(key);
+		key = ERR_PTR(err);
+		goto out_free_mk;
+	}
+	return key;
+
+out_free_mk:
+	free_master_key(mk);
+	return key;
+}
+
+/*
+ * Add the given key to ->s_master_keys, creating ->s_master_keys if it doesn't
+ * already exist.  Synchronized by fscrypt_add_key_mutex.
+ */
+static int add_to_filesystem_keyring(struct super_block *sb, struct key *key)
+{
+	struct key *keyring = sb->s_master_keys;
+
+	if (keyring == NULL) {
+		char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE];
+
+		format_fs_keyring_description(description, sb);
+		keyring = keyring_alloc(description, GLOBAL_ROOT_UID,
+					GLOBAL_ROOT_GID, current_cred(),
+					KEY_POS_SEARCH | KEY_USR_SEARCH |
+					KEY_USR_READ | KEY_USR_VIEW,
+					KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+		if (IS_ERR(keyring))
+			return PTR_ERR(keyring);
+
+		/* Pairs with smp_load_acquire() in find_master_key() */
+		smp_store_release(&sb->s_master_keys, keyring);
+	}
+
+	return key_link(keyring, key);
+}
+
+static int add_master_key(struct super_block *sb,
+			  struct fscrypt_master_key_secret *secret,
+			  const struct fscrypt_key_specifier *mk_spec)
+{
+	struct key *key;
+	int err;
+	static DEFINE_MUTEX(fscrypt_add_key_mutex);
+
+	mutex_lock(&fscrypt_add_key_mutex); /* serialize find + link */
+	key = find_master_key(sb, mk_spec);
+	if (IS_ERR(key)) {
+		if (key != ERR_PTR(-ENOKEY)) {
+			err = PTR_ERR(key);
+			goto out_unlock;
+		}
+		/* Didn't find the key in ->s_master_keys; add it. */
+
+		key = allocate_master_key(secret, mk_spec);
+		if (IS_ERR(key)) {
+			err = PTR_ERR(key);
+			goto out_unlock;
+		}
+		err = add_to_filesystem_keyring(sb, key);
+		if (err)
+			goto out_put_key;
+	}
+	err = 0;
+out_put_key:
+	key_put(key);
+out_unlock:
+	mutex_unlock(&fscrypt_add_key_mutex);
+	return err;
+}
+
+/*
+ * Add a master encryption key to the filesystem, causing all files which were
+ * encrypted with it to appear "unlocked" (decrypted) when accessed.
+ */
+int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
+{
+	struct super_block *sb = file_inode(filp)->i_sb;
+	struct fscrypt_add_key_args __user *uarg = _uarg;
+	struct fscrypt_add_key_args arg;
+	struct fscrypt_master_key_secret secret;
+	int err;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	if (arg.raw_size < FSCRYPT_MIN_KEY_SIZE ||
+	    arg.raw_size > FSCRYPT_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	if (arg.reserved1 ||
+	    memchr_inv(arg.reserved2, 0, sizeof(arg.reserved2)))
+		return -EINVAL;
+
+	if (!valid_key_spec(&arg.key_spec))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	memset(&secret, 0, sizeof(secret));
+	secret.size = arg.raw_size;
+	err = -EFAULT;
+	if (copy_from_user(secret.raw, uarg->raw, secret.size))
+		goto out_wipe_secret;
+
+	err = add_master_key(sb, &secret, &arg.key_spec);
+out_wipe_secret:
+	wipe_master_key_secret(&secret);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
+
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 {
 	struct fscrypt_completion_result *ecr = req->data;
@@ -137,10 +430,10 @@ find_and_lock_process_key(const char *prefix,
 	return ERR_PTR(-ENOKEY);
 }
 
-/* Find the master key, then derive the inode's actual encryption key */
-static int find_and_derive_key(const struct inode *inode,
-			       const struct fscrypt_context *ctx,
-			       u8 *derived_key, unsigned int derived_keysize)
+static int find_and_derive_key_legacy(const struct inode *inode,
+				      const struct fscrypt_context *ctx,
+				      u8 *derived_key,
+				      unsigned int derived_keysize)
 {
 	struct key *key;
 	const struct fscrypt_key *payload;
@@ -162,6 +455,54 @@ static int find_and_derive_key(const struct inode *inode,
 	return err;
 }
 
+/* Find the master key, then derive the inode's actual encryption key */
+static int find_and_derive_key(const struct inode *inode,
+			       const struct fscrypt_context *ctx,
+			       u8 *derived_key, unsigned int derived_keysize)
+{
+	struct key *key;
+	struct fscrypt_master_key *mk;
+	struct fscrypt_key_specifier mk_spec;
+	int err;
+
+	mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
+	memcpy(mk_spec.descriptor, ctx->master_key_descriptor,
+	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
+
+	key = find_master_key(inode->i_sb, &mk_spec);
+	if (IS_ERR(key)) {
+		if (key != ERR_PTR(-ENOKEY))
+			return PTR_ERR(key);
+		/*
+		 * As a legacy fallback, we search the current task's subscribed
+		 * keyrings in addition to ->s_master_keys.
+		 */
+		return find_and_derive_key_legacy(inode, ctx, derived_key,
+						  derived_keysize);
+	}
+	mk = key->payload.data[0];
+
+	/*
+	 * Require that the master key be at least as long as the derived key.
+	 * Otherwise, the derived key cannot possibly contain as much entropy as
+	 * that required by the encryption mode it will be used for.
+	 */
+	if (mk->mk_secret.size < derived_keysize) {
+		pr_warn_ratelimited("fscrypt: key with description '%s' is too short "
+				    "(got %u bytes, need %u+ bytes)\n",
+				    key->description,
+				    mk->mk_secret.size, derived_keysize);
+		err = -ENOKEY;
+		goto out_put_key;
+	}
+
+	err = derive_key_aes(mk->mk_secret.raw, ctx,
+			     derived_key, derived_keysize);
+out_put_key:
+	key_put(key);
+	return err;
+}
+
 static const struct {
 	const char *cipher_str;
 	int keysize;
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index c4c6bf2c390e..7ca8a44fc984 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -84,6 +84,11 @@ static inline int fscrypt_inherit_context(struct inode *parent,
 }
 
 /* keyinfo.c */
+static inline int fscrypt_ioctl_add_key(struct file *filp, void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
 	return -EOPNOTSUPP;
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index 2db5e9706f60..313943214d57 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -42,6 +42,7 @@ extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyinfo.c */
+extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 extern int fscrypt_get_encryption_info(struct inode *);
 extern void fscrypt_put_encryption_info(struct inode *, struct fscrypt_info *);
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 26c381a40279..aebe5d84d091 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -34,22 +34,43 @@ struct fscrypt_policy {
 	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 };
 
-#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
-#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
-#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
-
-/* Parameters for passing an encryption key into the kernel keyring */
+/*
+ * Process-subscribed "logon" key description prefix and payload format.
+ * Deprecated; prefer FS_IOC_ADD_ENCRYPTION_KEY instead.
+ */
 #define FSCRYPT_KEY_DESC_PREFIX		"fscrypt:"
-#define FSCRYPT_KEY_DESC_PREFIX_SIZE		8
-
-/* Structure that userspace passes to the kernel keyring */
-#define FSCRYPT_MAX_KEY_SIZE			64
-
+#define FSCRYPT_KEY_DESC_PREFIX_SIZE	8
+#define FSCRYPT_MAX_KEY_SIZE		64
 struct fscrypt_key {
 	__u32 mode;
 	__u8 raw[FSCRYPT_MAX_KEY_SIZE];
 	__u32 size;
 };
+
+struct fscrypt_key_specifier {
+	__u32 type;
+#define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
+	__u32 reserved;
+	union {
+		__u8 max_specifier[32];
+		__u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+	};
+};
+
+/* Struct passed to FS_IOC_ADD_ENCRYPTION_KEY */
+struct fscrypt_add_key_args {
+	__u32 raw_size;
+	__u32 reserved1;
+	__u64 reserved2[2];
+	struct fscrypt_key_specifier key_spec;
+	__u8 raw[];
+};
+
+#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR( 'f', 19, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW( 'f', 20, __u8[16])
+#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW( 'f', 21, struct fscrypt_policy)
+#define FS_IOC_ADD_ENCRYPTION_KEY	_IOWR('f', 22, struct fscrypt_add_key_args)
+
 /**********************************************************************/
 
 /* old names; don't add anything new here! */
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
