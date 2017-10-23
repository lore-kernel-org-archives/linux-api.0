From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 10/25] fscrypt: add
 FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Mon, 23 Oct 2017 14:40:43 -0700
Message-ID: <20171023214058.128121-11-ebiggers3@gmail.com>
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

Problem
~~~~~~~

Many filesystem encryption users want the ability to remove encryption
keys, causing the corresponding encrypted directories to appear "locked"
(presented in ciphertext form) again.  Moreover, users want removing an
encryption key to *really* remove it, in the sense that the removed keys
cannot be recovered even if kernel memory is compromised, e.g. by the
exploit of a kernel security vulnerability or by a physical attack.
This is desirable after a user logs out of the system, for example.  In
many cases users even already assume this to be the case and are
surprised to hear when it's not.

It is *not* sufficient to simply unlink the master key from the keyring
(or to revoke or invalidate it), since files are encrypted with per-file
keys instead of with the master keys directly.  Therefore, to really
remove a key we must also remove the per-file keys, e.g. by evicting the
corresponding inodes from the inode cache.  This also would have the
benefit of making encrypted files appear "locked" again.

Currently the workaround is to run:

    sync
    echo 2 > /proc/sys/vm/drop_caches

This is a very bad solution because it evicts all not-in-use inodes in
the system rather than just the inodes associated with the key being
removed.  Moreover, it requires root privileges, so non-root users
cannot lock their encrypted directories.  Finally, the drop_caches
sysctl was originally meant for debugging purposes only.

Nevertheless, the largest users of filesystem encryption (Android and
Chromium OS) actually want this capability badly enough that they are
actually using the drop_caches workaround.  Similarly, the drop_caches
workaround is also used in the PAM module provided by the fscrypt
userspace tool (https://github.com/google/fscrypt).  Needless to say,
this is causing significant performance problems due to inodes for
unencrypted system files being evicted.  So a real solution is needed.

Solution
~~~~~~~~

To properly solve this problem, we need an API which removes and wipes
the given master key, *and* removes and and wipes the corresponding
per-file keys.  This requires tracking which inodes have been "unlocked"
using each master key.  Originally that was not possible because the
kernel didn't actually have a centralized notion of what a master key
even was.  But now that we have the filesystem-level keyring
->s_master_keys it is finally possible.

Add this API as a new ioctl, FS_IOC_REMOVE_ENCRYPTION_KEY.  It is the
counterpart of FS_IOC_ADD_ENCRYPTION_KEY.

FS_IOC_REMOVE_ENCRYPTION_KEY first wipes the master key's secret from
memory.  Then, it syncs the filesystem and tries to evict the list of
inodes that had been "unlocked" with the key.  Evicting the inodes has
several effects, including:

- The actual keys used to encrypt the data (in ->i_crypt_info->ci_ctfm)
  are wiped from memory.  Thus, they can no longer be recovered, even if
  kernel memory is later compromised.

- The encrypted files and directories once again appear "locked", i.e.
  in ciphertext or in "encrypted" form.  This is highly desirable from a
  user interface perspective.  It can also be desirable from a security
  perspective (although sometimes for the wrong reasons!).

- The pagecache pages are freed, which allows the plaintext file
  contents to be overwritten in memory later as the system continues
  running.  Currently we do not actually wipe the pages on free, nor
  does the kernel more generally wipe memory on free either.  Thus, for
  now we tolerate that an attacker who later gains access to kernel
  memory may be able to see portions of file contents and file names in
  plaintext in unallocated memory.  Security-conscious users who do not
  mind a performance hit may ameliorate this by enabling page poisoning.

Of course, some inodes may still be in use when a master key is removed,
and we cannot simply revoke random file descriptors, mmap's, etc.  The
approach we take is to skip in-use inodes, and notify userspace by
returning -EBUSY if any inodes could not be evicted.  Still, even in
this case the master key secret is removed, so no more files can be
unlocked with it.  Moreover, most of the inodes should still be evicted
as well.  Userspace can then retry the ioctl later to evict the
remaining inodes.  Alternatively, if userspace adds the key again, then
the refreshed secret will be associated with the existing list of inodes
so that they are correctly tracked for future key removals.

For now, FS_IOC_REMOVE_ENCRYPTION_KEY has to be restricted to privileged
users only, just like FS_IOC_ADD_ENCRYPTION_KEY.  This is sufficient for
use cases where all encryption keys are managed by a privileged process,
e.g. as is the case on Android and Chromium OS.

But in the more general case, non-root users need to be able to both
unlock *and* lock their own encrypted directories.  As it turns out, we
will indeed be able to support this through these ioctls, but non-root
use will need to be tied to the use of a new encryption policy version
which identifies the master key using a cryptographic hash.  (See later
patches.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h     |  18 ++-
 fs/crypto/keyinfo.c             | 347 ++++++++++++++++++++++++++++++++++++++--
 fs/crypto/policy.c              |   5 +-
 include/linux/fscrypt_notsupp.h |   6 +
 include/linux/fscrypt_supp.h    |   1 +
 include/uapi/linux/fscrypt.h    |   7 +
 6 files changed, 367 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index b2fad12eeedb..2fdc4e5c0771 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -61,7 +61,23 @@ struct fscrypt_info {
 	u8 ci_flags;
 	struct crypto_skcipher *ci_ctfm;
 	struct crypto_cipher *ci_essiv_tfm;
-	u8 ci_master_key[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+	u8 ci_master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+
+	/*
+	 * The master key with which this inode was unlocked (decrypted).  This
+	 * will be NULL if the master key was found in a process-subscribed
+	 * keyring rather than in the filesystem-level keyring.
+	 */
+	struct key *ci_master_key;
+
+	/* Link in list of inodes that were unlocked with the master key */
+	struct list_head ci_master_key_link;
+
+	/*
+	 * Back-pointer to the inode, needed during key removal.  Only set when
+	 * ->ci_master_key is set.
+	 */
+	struct inode *ci_inode;
 };
 
 typedef enum {
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 3f1cb8bbc1e5..dc2697cf9114 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -40,11 +40,35 @@ struct fscrypt_master_key_secret {
  */
 struct fscrypt_master_key {
 
-	/* The secret key material */
+	/*
+	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
+	 * executed, this is wiped and no new inodes can be unlocked with this
+	 * key; however, there may still be inodes in ->mk_decrypted_inodes
+	 * which could not be evicted.  As long as some inodes still remain,
+	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
+	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
+	 *
+	 * Locking: protected by key->sem.
+	 */
 	struct fscrypt_master_key_secret	mk_secret;
 
 	/* Arbitrary key descriptor which was assigned by userspace */
 	struct fscrypt_key_specifier		mk_spec;
+
+	/*
+	 * Length of ->mk_decrypted_inodes, plus one if mk_secret is present.
+	 * Once this goes to 0, the master key is removed from ->s_master_keys.
+	 * This struct will continue to live as long as the 'struct key' whose
+	 * payload it is, but we won't let this reference count rise again.
+	 */
+	refcount_t		mk_refcount;
+
+	/*
+	 * List of inodes that were unlocked using this key.  This allows the
+	 * inodes to be evicted efficiently if the key is removed.
+	 */
+	struct list_head	mk_decrypted_inodes;
+	spinlock_t		mk_decrypted_inodes_lock;
 };
 
 static inline int master_key_spec_len(const struct fscrypt_key_specifier *spec)
@@ -63,6 +87,12 @@ static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
 	return master_key_spec_len(spec) != 0;
 }
 
+static bool
+is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
+{
+	return secret->size != 0;
+}
+
 static void wipe_master_key_secret(struct fscrypt_master_key_secret *secret)
 {
 	memzero_explicit(secret, sizeof(*secret));
@@ -96,6 +126,13 @@ static void fscrypt_key_destroy(struct key *key)
 static void fscrypt_key_describe(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
+
+	if (key_is_positive(key)) {
+		struct fscrypt_master_key *mk = key->payload.data[0];
+
+		if (!is_master_key_secret_present(&mk->mk_secret))
+			seq_puts(m, ": secret removed");
+	}
 }
 
 /*
@@ -122,7 +159,8 @@ static struct key *search_fscrypt_keyring(struct key *keyring,
 
 	keyref = keyring_search(make_key_ref(keyring, 1), type, description);
 	if (IS_ERR(keyref)) {
-		if (PTR_ERR(keyref) == -EAGAIN)
+		if (PTR_ERR(keyref) == -EAGAIN ||
+		    PTR_ERR(keyref) == -EKEYREVOKED)
 			keyref = ERR_PTR(-ENOKEY);
 		return ERR_CAST(keyref);
 	}
@@ -186,6 +224,10 @@ allocate_master_key(struct fscrypt_master_key_secret *secret,
 
 	move_master_key_secret(&mk->mk_secret, secret);
 
+	refcount_set(&mk->mk_refcount, 1); /* secret is present */
+	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
+	spin_lock_init(&mk->mk_decrypted_inodes_lock);
+
 	format_mk_description(description, mk_spec);
 	key = key_alloc(&key_type_fscrypt_mk, description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
@@ -243,6 +285,7 @@ static int add_master_key(struct super_block *sb,
 	static DEFINE_MUTEX(fscrypt_add_key_mutex);
 
 	mutex_lock(&fscrypt_add_key_mutex); /* serialize find + link */
+retry:
 	key = find_master_key(sb, mk_spec);
 	if (IS_ERR(key)) {
 		if (key != ERR_PTR(-ENOKEY)) {
@@ -259,6 +302,33 @@ static int add_master_key(struct super_block *sb,
 		err = add_to_filesystem_keyring(sb, key);
 		if (err)
 			goto out_put_key;
+	} else {
+		struct fscrypt_master_key *mk = key->payload.data[0];
+		bool rekey;
+
+		/* Found the key in ->s_master_keys */
+
+		down_write(&key->sem);
+
+		/*
+		 * Take a reference if we'll be re-adding ->mk_secret.  If we
+		 * couldn't take a reference, then the key is being removed from
+		 * ->s_master_keys and can no longer be used.  So invalidate the
+		 * key (someone else is doing that too, but they might be
+		 * slower) and retry searching ->s_master_keys.
+		 */
+		rekey = !is_master_key_secret_present(&mk->mk_secret);
+		if (rekey && !refcount_inc_not_zero(&mk->mk_refcount)) {
+			up_write(&key->sem);
+			key_invalidate(key);
+			key_put(key);
+			goto retry;
+		}
+
+		/* Re-add the secret key material if needed */
+		if (rekey)
+			move_master_key_secret(&mk->mk_secret, secret);
+		up_write(&key->sem);
 	}
 	err = 0;
 out_put_key:
@@ -270,7 +340,8 @@ static int add_master_key(struct super_block *sb,
 
 /*
  * Add a master encryption key to the filesystem, causing all files which were
- * encrypted with it to appear "unlocked" (decrypted) when accessed.
+ * encrypted with it to appear "unlocked" (decrypted) when accessed.  The key
+ * can be removed later by FS_IOC_REMOVE_ENCRYPTION_KEY.
  */
 int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 {
@@ -310,6 +381,191 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
+static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
+{
+	struct fscrypt_info *ci;
+	struct inode *inode;
+	struct inode *toput_inode = NULL;
+
+	spin_lock(&mk->mk_decrypted_inodes_lock);
+
+	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
+		inode = ci->ci_inode;
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&mk->mk_decrypted_inodes_lock);
+
+		shrink_dcache_inode(inode);
+		iput(toput_inode);
+		toput_inode = inode;
+
+		spin_lock(&mk->mk_decrypted_inodes_lock);
+	}
+
+	spin_unlock(&mk->mk_decrypted_inodes_lock);
+	iput(toput_inode);
+}
+
+static int evict_decrypted_inodes(struct fscrypt_master_key *mk)
+{
+	struct fscrypt_info *ci;
+	struct inode *inode;
+	LIST_HEAD(dispose);
+	unsigned long num_busy = 0;
+	unsigned long busy_ino;
+
+	spin_lock(&mk->mk_decrypted_inodes_lock);
+
+	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
+		inode = ci->ci_inode;
+		spin_lock(&inode->i_lock);
+
+		if (inode->i_state & (I_FREEING | I_WILL_FREE))
+			goto next;
+
+		if (atomic_read(&inode->i_count) ||
+		    (inode->i_state & ~I_REFERENCED)) {
+			num_busy++;
+			busy_ino = inode->i_ino;
+			goto next;
+		}
+
+		inode->i_state |= I_FREEING;
+		inode_lru_list_del(inode);
+		list_add(&inode->i_lru, &dispose);
+next:
+		spin_unlock(&inode->i_lock);
+	}
+
+	spin_unlock(&mk->mk_decrypted_inodes_lock);
+
+	evict_inode_list(&dispose);
+
+	if (unlikely(num_busy)) {
+		pr_warn_ratelimited("fscrypt: %lu inodes still busy after removing key with description %*phN (%sino: %lu)\n",
+				    num_busy, master_key_spec_len(&mk->mk_spec),
+				    mk->mk_spec.max_specifier,
+				    (num_busy > 1 ? "example " : ""), busy_ino);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int try_to_lock_encrypted_files(struct super_block *sb,
+				       struct fscrypt_master_key *mk)
+{
+	int err1;
+	int err2;
+
+	/*
+	 * An inode can't be evicted while it still has dirty pages, or while
+	 * the inode itself is still dirty.  Thus, we first have to clean all
+	 * the inodes in ->mk_decrypted_inodes.
+	 *
+	 * Just do it the easy way: call sync_filesystem().  It's overkill, but
+	 * it works, and it's more important to minimize the amount of caches we
+	 * drop than the amount of data we sync.  Also, unprivileged users can
+	 * already call sync_filesystem() via sys_syncfs() or sys_sync().
+	 */
+	down_read(&sb->s_umount);
+	err1 = sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	/*
+	 * Inodes are pinned by their dentries, so we have to evict the dentries
+	 * first.  We could potentially just call shrink_dcache_sb() here, but
+	 * that would be overkill, and an unprivileged user shouldn't be able to
+	 * evict all dentries for the entire filesystem.  Instead, go through
+	 * the inodes' alias lists and try to evict each dentry.
+	 */
+	evict_dentries_for_decrypted_inodes(mk);
+
+	/*
+	 * Finally, iterate through ->mk_decrypted_inodes and evict as many
+	 * inodes as we can.  Similarly, we could potentially just call
+	 * invalidate_inodes() here, but that would be overkill, and an
+	 * unprivileged user shouldn't be able to evict all inodes for the
+	 * entire filesystem.
+	 *
+	 * Note that ideally, we wouldn't really evict the inodes, but rather
+	 * just free their ->i_crypt_info and pagecache.  But eviction is *much*
+	 * easier to correctly implement without causing use-after-free bugs.
+	 */
+	err2 = evict_decrypted_inodes(mk);
+
+	return err1 ?: err2;
+}
+
+/*
+ * Try to remove an fscrypt master encryption key.
+ *
+ * First we wipe the actual master key secret from memory, so that no more
+ * inodes can be unlocked with it.  Then, we try to evict all cached inodes that
+ * had been unlocked using the key.  Since this can fail for in-use inodes, this
+ * is expected to be used in cooperation with userspace ensuring that none of
+ * the files are still open.
+ *
+ * If, nevertheless, some inodes could not be evicted, we return -EBUSY
+ * (although we still evicted as many inodes as possible) and keep the 'struct
+ * key' and the 'struct fscrypt_master_key' around to keep track of the list of
+ * remaining inodes.  Userspace can then retry the ioctl later to retry evicting
+ * the remaining inodes, or alternatively can add the secret key again.
+ *
+ * Note that even though we wipe the encryption *keys* from memory, decrypted
+ * data can likely still be found in memory, e.g. in pagecache pages that have
+ * been freed.  Wiping such data is currently out of scope, short of users who
+ * may choose to enable page and slab poisoning systemwide.
+ */
+int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
+{
+	struct super_block *sb = file_inode(filp)->i_sb;
+	struct fscrypt_remove_key_args arg;
+	struct key *key;
+	struct fscrypt_master_key *mk;
+	int err;
+	bool dead;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
+		return -EINVAL;
+
+	if (!valid_key_spec(&arg.key_spec))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	key = find_master_key(sb, &arg.key_spec);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+	mk = key->payload.data[0];
+
+	down_write(&key->sem);
+	dead = false;
+	if (is_master_key_secret_present(&mk->mk_secret)) {
+		wipe_master_key_secret(&mk->mk_secret);
+		dead = refcount_dec_and_test(&mk->mk_refcount);
+	}
+	up_write(&key->sem);
+	if (dead) {
+		key_invalidate(key);
+		err = 0;
+	} else {
+		err = try_to_lock_encrypted_files(sb, mk);
+	}
+	key_put(key);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key);
+
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 {
 	struct fscrypt_completion_result *ecr = req->data;
@@ -455,10 +711,20 @@ static int find_and_derive_key_legacy(const struct inode *inode,
 	return err;
 }
 
-/* Find the master key, then derive the inode's actual encryption key */
+/*
+ * Find the master key, then derive the inode's actual encryption key.
+ *
+ * If the master key is found in the filesystem-level keyring, then the
+ * corresponding 'struct key' is returned read-locked in *master_key_ret.  This
+ * is needed because we need to hold the semaphore until we link the new
+ * fscrypt_info into ->mk_decrypted_inodes, but in the case where multiple tasks
+ * are racing to set up an inode's ->i_crypt_info, only the winner should link
+ * its fscrypt_info into ->mk_decrypted_inodes.
+ */
 static int find_and_derive_key(const struct inode *inode,
 			       const struct fscrypt_context *ctx,
-			       u8 *derived_key, unsigned int derived_keysize)
+			       u8 *derived_key, unsigned int derived_keysize,
+			       struct key **master_key_ret)
 {
 	struct key *key;
 	struct fscrypt_master_key *mk;
@@ -481,6 +747,13 @@ static int find_and_derive_key(const struct inode *inode,
 						  derived_keysize);
 	}
 	mk = key->payload.data[0];
+	down_read(&key->sem);
+
+	/* Has the secret been removed using FS_IOC_REMOVE_ENCRYPTION_KEY? */
+	if (!is_master_key_secret_present(&mk->mk_secret)) {
+		err = -ENOKEY;
+		goto out_release_key;
+	}
 
 	/*
 	 * Require that the master key be at least as long as the derived key.
@@ -493,12 +766,19 @@ static int find_and_derive_key(const struct inode *inode,
 				    key->description,
 				    mk->mk_secret.size, derived_keysize);
 		err = -ENOKEY;
-		goto out_put_key;
+		goto out_release_key;
 	}
 
 	err = derive_key_aes(mk->mk_secret.raw, ctx,
 			     derived_key, derived_keysize);
-out_put_key:
+	if (err)
+		goto out_release_key;
+
+	*master_key_ret = key;
+	return 0;
+
+out_release_key:
+	up_read(&key->sem);
 	key_put(key);
 	return err;
 }
@@ -542,11 +822,32 @@ static int determine_cipher_type(struct fscrypt_info *ci, struct inode *inode,
 
 static void put_crypt_info(struct fscrypt_info *ci)
 {
+	struct key *key;
+
 	if (!ci)
 		return;
 
 	crypto_free_skcipher(ci->ci_ctfm);
 	crypto_free_cipher(ci->ci_essiv_tfm);
+	key = ci->ci_master_key;
+	if (key) {
+		struct fscrypt_master_key *mk = key->payload.data[0];
+
+		/*
+		 * Remove this inode from the list of inodes that were unlocked
+		 * with the master key.
+		 *
+		 * In addition, if we're removing the last inode from a key that
+		 * already had its secret removed, invalidate the key so that it
+		 * gets removed from ->s_master_keys.
+		 */
+		spin_lock(&mk->mk_decrypted_inodes_lock);
+		list_del(&ci->ci_master_key_link);
+		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		if (refcount_dec_and_test(&mk->mk_refcount))
+			key_invalidate(key);
+		key_put(key);
+	}
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
@@ -624,6 +925,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	const char *cipher_str;
 	unsigned int derived_keysize;
 	u8 *derived_key = NULL;
+	struct key *master_key = NULL;
 	int res;
 
 	if (inode->i_crypt_info)
@@ -655,17 +957,15 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	if (ctx.flags & ~FSCRYPT_POLICY_FLAGS_VALID)
 		return -EINVAL;
 
-	crypt_info = kmem_cache_alloc(fscrypt_info_cachep, GFP_NOFS);
+	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_NOFS);
 	if (!crypt_info)
 		return -ENOMEM;
 
 	crypt_info->ci_flags = ctx.flags;
 	crypt_info->ci_data_mode = ctx.contents_encryption_mode;
 	crypt_info->ci_filename_mode = ctx.filenames_encryption_mode;
-	crypt_info->ci_ctfm = NULL;
-	crypt_info->ci_essiv_tfm = NULL;
-	memcpy(crypt_info->ci_master_key, ctx.master_key_descriptor,
-				sizeof(crypt_info->ci_master_key));
+	memcpy(crypt_info->ci_master_key_descriptor, ctx.master_key_descriptor,
+	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 
 	res = determine_cipher_type(crypt_info, inode,
 				    &cipher_str, &derived_keysize);
@@ -681,7 +981,8 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	if (!derived_key)
 		goto out;
 
-	res = find_and_derive_key(inode, &ctx, derived_key, derived_keysize);
+	res = find_and_derive_key(inode, &ctx, derived_key, derived_keysize,
+				  &master_key);
 	if (res)
 		goto out;
 
@@ -709,9 +1010,27 @@ int fscrypt_get_encryption_info(struct inode *inode)
 			goto out;
 		}
 	}
-	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) == NULL)
+
+	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
+		if (master_key) {
+			struct fscrypt_master_key *mk =
+				master_key->payload.data[0];
+
+			crypt_info->ci_inode = inode;
+			refcount_inc(&mk->mk_refcount);
+			crypt_info->ci_master_key = key_get(master_key);
+			spin_lock(&mk->mk_decrypted_inodes_lock);
+			list_add(&crypt_info->ci_master_key_link,
+				 &mk->mk_decrypted_inodes);
+			spin_unlock(&mk->mk_decrypted_inodes_lock);
+		}
 		crypt_info = NULL;
+	}
 out:
+	if (master_key) {
+		up_read(&master_key->sem);
+		key_put(master_key);
+	}
 	if (res == -ENOKEY)
 		res = 0;
 	put_crypt_info(crypt_info);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 19332a6fd52d..a856c8941be6 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -198,7 +198,8 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 	child_ci = child->i_crypt_info;
 
 	if (parent_ci && child_ci) {
-		return memcmp(parent_ci->ci_master_key, child_ci->ci_master_key,
+		return memcmp(parent_ci->ci_master_key_descriptor,
+			      child_ci->ci_master_key_descriptor,
 			      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
 			(parent_ci->ci_data_mode == child_ci->ci_data_mode) &&
 			(parent_ci->ci_filename_mode ==
@@ -253,7 +254,7 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 	ctx.contents_encryption_mode = ci->ci_data_mode;
 	ctx.filenames_encryption_mode = ci->ci_filename_mode;
 	ctx.flags = ci->ci_flags;
-	memcpy(ctx.master_key_descriptor, ci->ci_master_key,
+	memcpy(ctx.master_key_descriptor, ci->ci_master_key_descriptor,
 	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
 	BUILD_BUG_ON(sizeof(ctx) != FSCRYPT_SET_CONTEXT_MAX_SIZE);
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 7ca8a44fc984..92616bfdc294 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -89,6 +89,12 @@ static inline int fscrypt_ioctl_add_key(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_ioctl_remove_key(struct file *filp,
+					   const void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
 	return -EOPNOTSUPP;
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index 313943214d57..620ca4f1bafe 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -43,6 +43,7 @@ extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyinfo.c */
 extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
+extern int fscrypt_ioctl_remove_key(struct file *filp, const void __user *arg);
 extern int fscrypt_get_encryption_info(struct inode *);
 extern void fscrypt_put_encryption_info(struct inode *, struct fscrypt_info *);
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index aebe5d84d091..5d02f138668c 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -66,10 +66,17 @@ struct fscrypt_add_key_args {
 	__u8 raw[];
 };
 
+/* Struct passed to FS_IOC_REMOVE_ENCRYPTION_KEY */
+struct fscrypt_remove_key_args {
+	__u64 reserved[3];
+	struct fscrypt_key_specifier key_spec;
+};
+
 #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR( 'f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW( 'f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	_IOW( 'f', 21, struct fscrypt_policy)
 #define FS_IOC_ADD_ENCRYPTION_KEY	_IOWR('f', 22, struct fscrypt_add_key_args)
+#define FS_IOC_REMOVE_ENCRYPTION_KEY	_IOR( 'f', 23, struct fscrypt_remove_key_args)
 
 /**********************************************************************/
 
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
