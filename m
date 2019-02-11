From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH v2 11/20] fscrypt: add
 FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Date: Mon, 11 Feb 2019 09:27:29 -0800
Message-ID: <20190211172738.4633-12-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a new fscrypt ioctl, FS_IOC_REMOVE_ENCRYPTION_KEY.  This ioctl
removes an encryption key that was added by FS_IOC_ADD_ENCRYPTION_KEY.
It wipes the secret key itself, then "locks" the encrypted files and
directories that had been unlocked using that key -- implemented by
evicting the relevant dentries and inodes from the VFS caches.

The problem this solves is that many fscrypt users want the ability to
remove encryption keys, causing the corresponding encrypted directories
to appear "locked" (presented in ciphertext form) again.  Moreover,
users want removing an encryption key to *really* remove it, in the
sense that the removed keys cannot be recovered even if kernel memory is
compromised, e.g. by the exploit of a kernel security vulnerability or
by a physical attack.  This is desirable after a user logs out of the
system, for example.  In many cases users even already assume this to be
the case and are surprised to hear when it's not.

It is not sufficient to simply unlink the master key from the keyring
(or to revoke or invalidate it), since the actual encryption transform
objects are still pinned in memory by their inodes.  Therefore, to
really remove a key we must also evict the relevant inodes.

Currently one workaround is to run 'sync && echo 2 >
/proc/sys/vm/drop_caches'.  But, that evicts all unused inodes in the
system rather than just the inodes associated with the key being
removed, causing severe performance problems.  Moreover, it requires
root privileges, so regular users can't "lock" their encrypted files.

Another workaround, used in Chromium OS kernels, is to add a new
VFS-level ioctl FS_IOC_DROP_CACHE which is a more restricted version of
drop_caches that operates on a single super_block.  It does:

        shrink_dcache_sb(sb);
        invalidate_inodes(sb, false);

But it's still a hack.  Yet, the major users of filesystem encryption
want this feature badly enough that they are actually using these hacks.

To properly solve the problem, start maintaining a list of the inodes
which have been "unlocked" using each master key.  Originally this
wasn't possible because the kernel didn't keep track of in-use master
keys at all.  But, with the ->s_master_keys keyring it is now possible.

Then, add an ioctl FS_IOC_REMOVE_ENCRYPTION_KEY.  It finds the specified
master key in ->s_master_keys, then wipes the secret key itself, which
prevents any additional inodes from being unlocked with the key.  Then,
it syncs the filesystem and evicts the inodes in the key's list.  The
normal inode eviction code will free and wipe the per-file keys (in
->i_crypt_info).  Note that freeing ->i_crypt_info without evicting the
inodes was also considered, but would have been racy.

Some inodes may still be in use when a master key is removed, and we
can't simply revoke random file descriptors, mmap's, etc.  Thus, the
ioctl simply skips in-use inodes, and returns -EBUSY to indicate that
some inodes weren't evicted.  The master key *secret* is still removed,
but the fscrypt_master_key struct remains to keep track of the remaining
inodes.  Userspace can then retry the ioctl to evict the remaining
inodes.  Alternatively, if userspace adds the key again, the refreshed
secret will be associated with the existing list of inodes so they
remain correctly tracked for future key removals.

The ioctl doesn't wipe pagecache pages.  Thus, we tolerate that after a
kernel compromise some portions of plaintext file contents may still be
recoverable from memory.  This can be solved be enabling page poisoning
system-wide, which security conscious users may choose to do.  But it's
very difficult to solve otherwise, e.g. note that plaintext file
contents may have been read in other places than pagecache pages.

Like FS_IOC_ADD_ENCRYPTION_KEY, FS_IOC_REMOVE_ENCRYPTION_KEY is
initially restricted to privileged users only.  This is sufficient for
some use cases, but not all.  A later patch will relax this restriction,
but it will require introducing key hashes, among other changes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h  |  46 ++++++-
 fs/crypto/keyring.c          | 240 ++++++++++++++++++++++++++++++++++-
 fs/crypto/keysetup.c         |  67 +++++++++-
 include/linux/fscrypt.h      |   7 +
 include/uapi/linux/fscrypt.h |   7 +
 5 files changed, 362 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index b4c431208555..b09fc2939a89 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -78,6 +78,19 @@ struct fscrypt_info {
 	/* Back-pointer to the inode */
 	struct inode *ci_inode;
 
+	/*
+	 * The master key with which this inode was unlocked (decrypted).  This
+	 * will be NULL if the master key was found in a process-subscribed
+	 * keyring rather than in the filesystem-level keyring.
+	 */
+	struct key *ci_master_key;
+
+	/*
+	 * Link in list of inodes that were unlocked with the master key.
+	 * Only used when ->ci_master_key is set.
+	 */
+	struct list_head ci_master_key_link;
+
 	/*
 	 * If non-NULL, then encryption is done using the master key directly
 	 * and ci_ctfm will equal ci_direct_key->dk_ctfm.
@@ -186,14 +199,45 @@ struct fscrypt_master_key_secret {
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
 
+	/*
+	 * Length of ->mk_decrypted_inodes, plus one if mk_secret is present.
+	 * Once this goes to 0, the master key is removed from ->s_master_keys.
+	 * The 'struct fscrypt_master_key' will continue to live as long as the
+	 * 'struct key' whose payload it is, but we won't let this reference
+	 * count rise again.
+	 */
+	refcount_t		mk_refcount;
+
+	/*
+	 * List of inodes that were unlocked using this key.  This allows the
+	 * inodes to be evicted efficiently if the key is removed.
+	 */
+	struct list_head	mk_decrypted_inodes;
+	spinlock_t		mk_decrypted_inodes_lock;
+
 } __randomize_layout;
 
+static inline bool
+is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
+{
+	return secret->size != 0;
+}
+
 extern struct key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 252e863d681d..82d272c20969 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -10,6 +10,7 @@
  * filesystem-level keyring, including the ioctls:
  *
  * - FS_IOC_ADD_ENCRYPTION_KEY: add a key
+ * - FS_IOC_REMOVE_ENCRYPTION_KEY: remove a key
  */
 
 #include <linux/key-type.h>
@@ -66,6 +67,13 @@ static void fscrypt_key_destroy(struct key *key)
 static void fscrypt_key_describe(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
+
+	if (key_is_positive(key)) {
+		const struct fscrypt_master_key *mk = key->payload.data[0];
+
+		if (!is_master_key_secret_present(&mk->mk_secret))
+			seq_puts(m, ": secret removed");
+	}
 }
 
 /*
@@ -186,6 +194,10 @@ static int add_new_master_key(struct fscrypt_master_key_secret *secret,
 
 	move_master_key_secret(&mk->mk_secret, secret);
 
+	refcount_set(&mk->mk_refcount, 1); /* secret is present */
+	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
+	spin_lock_init(&mk->mk_decrypted_inodes_lock);
+
 	format_mk_description(description, mk_spec);
 	key = key_alloc(&key_type_fscrypt, description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
@@ -207,6 +219,22 @@ static int add_new_master_key(struct fscrypt_master_key_secret *secret,
 	return err;
 }
 
+#define KEY_DEAD	1
+
+static int add_existing_master_key(struct fscrypt_master_key *mk,
+				   struct fscrypt_master_key_secret *secret,
+				   const struct fscrypt_key_specifier *mk_spec)
+{
+	if (is_master_key_secret_present(&mk->mk_secret))
+		return 0;
+
+	if (!refcount_inc_not_zero(&mk->mk_refcount))
+		return KEY_DEAD;
+
+	move_master_key_secret(&mk->mk_secret, secret);
+	return 0;
+}
+
 static int add_master_key(struct super_block *sb,
 			  struct fscrypt_master_key_secret *secret,
 			  const struct fscrypt_key_specifier *mk_spec)
@@ -216,6 +244,7 @@ static int add_master_key(struct super_block *sb,
 	int err;
 
 	mutex_lock(&fscrypt_add_key_mutex); /* serialize find + link */
+retry:
 	key = fscrypt_find_master_key(sb, mk_spec);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
@@ -227,8 +256,21 @@ static int add_master_key(struct super_block *sb,
 			goto out_unlock;
 		err = add_new_master_key(secret, mk_spec, sb->s_master_keys);
 	} else {
+		/*
+		 * Found the key in ->s_master_keys.  Re-add the secret if
+		 * needed.
+		 */
+		down_write(&key->sem);
+		err = add_existing_master_key(key->payload.data[0], secret,
+					      mk_spec);
+		up_write(&key->sem);
+		if (err == KEY_DEAD) {
+			/* Key being removed or needs to be removed */
+			key_invalidate(key);
+			key_put(key);
+			goto retry;
+		}
 		key_put(key);
-		err = 0;
 	}
 out_unlock:
 	mutex_unlock(&fscrypt_add_key_mutex);
@@ -277,6 +319,202 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
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
+static int evict_decrypted_inodes(struct fscrypt_master_key *mk,
+				  struct super_block *sb)
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
+		fscrypt_warn(sb, "%lu inodes still busy after removing key with description %*phN (%sino: %lu)",
+			     num_busy, master_key_spec_len(&mk->mk_spec),
+			     (u8 *)&mk->mk_spec.u,
+			     (num_busy > 1 ? "example " : ""), busy_ino);
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
+	 * easier to correctly implement.
+	 */
+	err2 = evict_decrypted_inodes(mk, sb);
+
+	return err1 ?: err2;
+}
+
+/*
+ * Try to remove an fscrypt master encryption key.  If other users have also
+ * added the key, we'll remove the current user's usage of the key, then return
+ * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.
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
+	struct fscrypt_remove_key_arg arg;
+	struct key *key;
+	struct fscrypt_master_key *mk;
+	int err;
+	bool dead;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.__reserved, 0, sizeof(arg.__reserved)))
+		return -EINVAL;
+
+	if (!valid_key_spec(&arg.key_spec))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	/* Find the key being removed. */
+	key = fscrypt_find_master_key(sb, &arg.key_spec);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+	mk = key->payload.data[0];
+
+	down_write(&key->sem);
+
+	/* Wipe the secret. */
+	dead = false;
+	if (is_master_key_secret_present(&mk->mk_secret)) {
+		wipe_master_key_secret(&mk->mk_secret);
+		dead = refcount_dec_and_test(&mk->mk_refcount);
+	}
+	up_write(&key->sem);
+	if (dead) {
+		/*
+		 * We wiped the secret and no inodes reference the key anymore,
+		 * so it's free to remove.
+		 */
+		key_invalidate(key);
+		err = 0;
+	} else {
+		/* Some inodes still reference this key; try to evict them. */
+		err = try_to_lock_encrypted_files(sb, mk);
+	}
+	key_put(key);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key);
+
 int __init fscrypt_init_keyring(void)
 {
 	return register_key_type(&key_type_fscrypt);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index b63fb4e8aebd..8ffcfee73702 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -210,8 +210,16 @@ int fscrypt_set_derived_key(struct fscrypt_info *ci, const u8 *derived_key)
 
 /*
  * Find the master key, then set up the inode's actual encryption key.
+ *
+ * If the master key is found in the filesystem-level keyring, then the
+ * corresponding 'struct key' is returned in *master_key_ret with
+ * ->sem read-locked.  This is needed to ensure that only one task links the
+ * fscrypt_info into ->mk_decrypted_inodes (as multiple tasks may race to create
+ * an fscrypt_info for the same inode), and to synchronize the key being removed
+ * with a new inode starting to use it.
  */
-static int setup_file_encryption_key(struct fscrypt_info *ci)
+static int setup_file_encryption_key(struct fscrypt_info *ci,
+				     struct key **master_key_ret)
 {
 	struct key *key;
 	struct fscrypt_master_key *mk = NULL;
@@ -231,6 +239,13 @@ static int setup_file_encryption_key(struct fscrypt_info *ci)
 	}
 
 	mk = key->payload.data[0];
+	down_read(&key->sem);
+
+	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
+	if (!is_master_key_secret_present(&mk->mk_secret)) {
+		err = -ENOKEY;
+		goto out_release_key;
+	}
 
 	if (mk->mk_secret.size < ci->ci_mode->keysize) {
 		fscrypt_warn(NULL,
@@ -242,14 +257,22 @@ static int setup_file_encryption_key(struct fscrypt_info *ci)
 	}
 
 	err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
+	if (err)
+		goto out_release_key;
+
+	*master_key_ret = key;
+	return 0;
 
 out_release_key:
+	up_read(&key->sem);
 	key_put(key);
 	return err;
 }
 
 static void put_crypt_info(struct fscrypt_info *ci)
 {
+	struct key *key;
+
 	if (!ci)
 		return;
 
@@ -259,6 +282,26 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		crypto_free_skcipher(ci->ci_ctfm);
 		crypto_free_cipher(ci->ci_essiv_tfm);
 	}
+
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
 
@@ -267,6 +310,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	struct fscrypt_info *crypt_info;
 	struct fscrypt_context ctx;
 	struct fscrypt_mode *mode;
+	struct key *master_key = NULL;
 	int res;
 
 	if (inode->i_crypt_info)
@@ -319,13 +363,30 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	WARN_ON(mode->ivsize > FSCRYPT_MAX_IV_SIZE);
 	crypt_info->ci_mode = mode;
 
-	res = setup_file_encryption_key(crypt_info);
+	res = setup_file_encryption_key(crypt_info, &master_key);
 	if (res)
 		goto out;
 
-	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) == NULL)
+	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
+		if (master_key) {
+			struct fscrypt_master_key *mk =
+				master_key->payload.data[0];
+
+			refcount_inc(&mk->mk_refcount);
+			crypt_info->ci_master_key = key_get(master_key);
+			spin_lock(&mk->mk_decrypted_inodes_lock);
+			list_add(&crypt_info->ci_master_key_link,
+				 &mk->mk_decrypted_inodes);
+			spin_unlock(&mk->mk_decrypted_inodes_lock);
+		}
 		crypt_info = NULL;
+	}
+	res = 0;
 out:
+	if (master_key) {
+		up_read(&master_key->sem);
+		key_put(master_key);
+	}
 	if (res == -ENOKEY)
 		res = 0;
 	put_crypt_info(crypt_info);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index ddb54b8eab81..a8fabae9a5fe 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -114,6 +114,7 @@ extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyring.c */
 extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
+extern int fscrypt_ioctl_remove_key(struct file *filp, const void __user *arg);
 
 /* keysetup.c */
 extern int fscrypt_get_encryption_info(struct inode *);
@@ -321,6 +322,12 @@ static inline int fscrypt_ioctl_add_key(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_ioctl_remove_key(struct file *filp,
+					   const void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* keysetup.c */
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 7bed24632bda..3302a407131e 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -65,10 +65,17 @@ struct fscrypt_add_key_arg {
 	__u8 raw[];
 };
 
+/* Struct passed to FS_IOC_REMOVE_ENCRYPTION_KEY */
+struct fscrypt_remove_key_arg {
+	struct fscrypt_key_specifier key_spec;
+	__u32 __reserved[6];
+};
+
 #define FS_IOC_SET_ENCRYPTION_POLICY	  _IOR('f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	  _IOW('f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	  _IOW('f', 21, struct fscrypt_policy)
 #define FS_IOC_ADD_ENCRYPTION_KEY	 _IOWR('f', 23, struct fscrypt_add_key_arg)
+#define FS_IOC_REMOVE_ENCRYPTION_KEY	  _IOW('f', 24, struct fscrypt_remove_key_arg)
 
 /**********************************************************************/
 
-- 
2.20.1
