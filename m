From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 20/25] fscrypt: allow unprivileged users to
 add/remove keys for v2 policies
Date: Mon, 23 Oct 2017 14:40:53 -0700
Message-ID: <20171023214058.128121-21-ebiggers3@gmail.com>
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

Having the FS_IOC_ADD_ENCRYPTION_KEY and FS_IOC_REMOVE_ENCRYPTION_KEY
ioctls be root-only is sufficient for some users of filesystem
encryption, e.g. Android and Chromium OS where all the encryption keys
are managed by a privileged process.  However, it is not sufficient for
general use where non-root users are setting up encrypted directories.
If these ioctls were root-only, such users would have to continue to use
process-subscribed keyrings and would continue to run into all the
problems noted earlier, including visibility problems when processes
running under different UIDs need to be able to access the files, and
the inability to remove the key, "locking" the directory.

Fortunately, we can indeed make the ioctls unprivileged, but only for v2
encryption policies and only after a few additional changes which this
patch implements.

First, to allow any user to add a key with filesystem-level visibility,
the keys must be identified using a cryptographic hash so that users
cannot add the wrong key for other users' files.  We use the
key_identifier for this, which is why v2 encryption policies are a
requirement.

Second, we charge each key a user adds to their quota for the keyrings
service.  Thus, a user can't cause a denial of service by adding a very
large number of keys.

Third, we have to be careful about when a key is allowed to be removed,
given that multiple users may add the same key (although that should
*not* normally be the case; it's astronomically unlikely for keys to
collide by chance, so it should only happen as a result of explicit
sharing or compromise).  One might consider only allowing the first user
who added a key to remove it, or allowing any user who knows a key to
remove it.  But neither of those are good enough because we don't want a
user on the system who knows another user's key to be able to cause a
denial of service where the former user removes the latter user's key at
an inopportune time.  After all, it *should* be the case that if you
have an encrypted directory and you give everyone in the world the key,
including malicious users on the same system, it should still be no less
secure than *not* using encryption.

The solution is to keep track of which users have added a key and only
really remove the key once all users have removed it.

However, it is tolerated that a user will be unable to remove a key,
i.e. unable to "lock" their encrypted files, if another user has added
the same key.  But in a sense, this is actually a good thing because it
will avoid providing a false notion of security where a key appears to
have been "removed" when actually it's still in memory, available to any
attacker who compromises the operating system kernel.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c           |   7 +
 fs/crypto/fscrypt_private.h  |   1 +
 fs/crypto/keyinfo.c          | 341 ++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/fscrypt.h |  11 +-
 4 files changed, 338 insertions(+), 22 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 489c504ac20d..e57a13889689 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -469,8 +469,14 @@ static int __init fscrypt_init(void)
 	if (err)
 		goto fail_free_info;
 
+	err = register_key_type(&key_type_fscrypt_mk_user);
+	if (err)
+		goto fail_unregister_fscrypt_mk_type;
+
 	return 0;
 
+fail_unregister_fscrypt_mk_type:
+	unregister_key_type(&key_type_fscrypt_mk);
 fail_free_info:
 	kmem_cache_destroy(fscrypt_info_cachep);
 fail_free_ctx:
@@ -494,6 +500,7 @@ static void __exit fscrypt_exit(void)
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 	kmem_cache_destroy(fscrypt_info_cachep);
 	unregister_key_type(&key_type_fscrypt_mk);
+	unregister_key_type(&key_type_fscrypt_mk_user);
 
 	fscrypt_essiv_cleanup();
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 6d420c9a85bd..d0a63086fa95 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -235,6 +235,7 @@ extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
 
 /* keyinfo.c */
 extern struct key_type key_type_fscrypt_mk;
+extern struct key_type key_type_fscrypt_mk_user;
 extern void __exit fscrypt_essiv_cleanup(void);
 
 /* policy.c */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index ec181c4eca56..1fe44983239a 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -246,9 +246,16 @@ struct fscrypt_master_key {
 	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
 	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
 	 *
-	 * Locking: protected by key->sem.
+	 * Locking: protected by key->sem (outer) and mk_secret_sem (inner).
+	 * The reason for two locks is that key->sem also protects modifying
+	 * mk_users, which ranks it above the semaphore for the keyring key
+	 * type, which is in turn above page faults (via keyring_read).  But
+	 * sometimes filesystems call fscrypt_get_encryption_info() from within
+	 * a transaction, which ranks it below page faults.  So we need a
+	 * separate lock which protects *just* mk_secret, not also mk_users.
 	 */
 	struct fscrypt_master_key_secret	mk_secret;
+	struct rw_semaphore			mk_secret_sem;
 
 	/*
 	 * For v1 policy keys: an arbitrary key descriptor which was assigned by
@@ -258,6 +265,19 @@ struct fscrypt_master_key {
 	 */
 	struct fscrypt_key_specifier		mk_spec;
 
+	/*
+	 * Keyring which contains a key of type 'key_type_fscrypt_mk_user' for
+	 * each user who has added this key.  Normally there would be just one
+	 * user who adds a particular key, but it's possible that multiple users
+	 * would add the same key, and we don't want to allow one user to remove
+	 * it before the others want it removed too.
+	 *
+	 * This is NULL for v1 policy keys.
+	 *
+	 * Locking: protected by key->sem.
+	 */
+	struct key		*mk_users;
+
 	/*
 	 * Length of ->mk_decrypted_inodes, plus one if mk_secret is present.
 	 * Once this goes to 0, the master key is removed from ->s_master_keys.
@@ -314,6 +334,7 @@ static void move_master_key_secret(struct fscrypt_master_key_secret *dst,
 static void free_master_key(struct fscrypt_master_key *mk)
 {
 	wipe_master_key_secret(&mk->mk_secret);
+	key_put(mk->mk_users);
 	kzfree(mk);
 }
 
@@ -353,9 +374,42 @@ struct key_type key_type_fscrypt_mk = {
 	.describe		= fscrypt_key_describe,
 };
 
+static int fscrypt_mk_user_key_instantiate(struct key *key,
+					   struct key_preparsed_payload *prep)
+{
+	/*
+	 * We just charge FSCRYPT_MAX_KEY_SIZE bytes to the user's key quota for
+	 * each key, regardless of the exact key size.  The amount of memory
+	 * actually used is greater than the size of the raw key anyway.
+	 */
+	return key_payload_reserve(key, FSCRYPT_MAX_KEY_SIZE);
+}
+
+static void fscrypt_mk_user_key_describe(const struct key *key,
+					 struct seq_file *m)
+{
+	seq_puts(m, key->description);
+}
+
+/*
+ * Type of key in ->mk_users.  Each key of this type represents a particular
+ * user who has added a particular master key.
+ *
+ * Note that the name of this key type really should be something like
+ * ".fscrypt-user" instead of simply ".fscrypt".  But the shorter name is chosen
+ * mainly for simplicity of presentation in /proc/keys when read by a non-root
+ * user.  And it is expected to be rare that a key is actually added by multiple
+ * users, since users should keep their encryption keys confidential.
+ */
+struct key_type key_type_fscrypt_mk_user = {
+	.name			= ".fscrypt",
+	.instantiate		= fscrypt_mk_user_key_instantiate,
+	.describe		= fscrypt_mk_user_key_describe,
+};
+
 /*
- * Search ->s_master_keys.  Note that we mark the keyring reference as
- * "possessed" so that we can use the KEY_POS_SEARCH permission.
+ * Search either ->s_master_keys or ->mk_users.  Note that we mark the keyring
+ * reference as "possessed" so that we can use the KEY_POS_SEARCH permission.
  */
 static struct key *search_fscrypt_keyring(struct key *keyring,
 					  struct key_type *type,
@@ -378,6 +432,13 @@ static struct key *search_fscrypt_keyring(struct key *keyring,
 
 #define FSCRYPT_MK_DESCRIPTION_SIZE	(2 * FSCRYPT_KEY_IDENTIFIER_SIZE + 1)
 
+#define FSCRYPT_MK_USERS_DESCRIPTION_SIZE	\
+	(sizeof("fscrypt-") - 1 + 2 * FSCRYPT_KEY_IDENTIFIER_SIZE + \
+	 sizeof("-users") - 1 + 1)
+
+#define FSCRYPT_MK_USER_DESCRIPTION_SIZE	\
+	(2 * FSCRYPT_KEY_IDENTIFIER_SIZE + sizeof(".uid.") - 1 + 10 + 1)
+
 static void format_fs_keyring_description(
 			char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
 			const struct super_block *sb)
@@ -393,6 +454,23 @@ static void format_mk_description(
 		master_key_spec_len(mk_spec), mk_spec->max_specifier);
 }
 
+static void format_mk_users_keyring_description(
+			char description[FSCRYPT_MK_USERS_DESCRIPTION_SIZE],
+			const u8 mk_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+	sprintf(description, "fscrypt-%*phN-users",
+		FSCRYPT_KEY_IDENTIFIER_SIZE, mk_identifier);
+}
+
+static void format_mk_user_description(
+			char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE],
+			const u8 mk_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+
+	sprintf(description, "%*phN.uid.%u", FSCRYPT_KEY_IDENTIFIER_SIZE,
+		mk_identifier, __kuid_val(current_fsuid()));
+}
+
 /*
  * Find the specified master key in ->s_master_keys.
  * Returns ERR_PTR(-ENOKEY) if not found.
@@ -413,6 +491,80 @@ static struct key *find_master_key(struct super_block *sb,
 				      description);
 }
 
+/*
+ * Find the current user's key in the master key's ->mk_users.
+ * Returns ERR_PTR(-ENOKEY) if not found.
+ */
+static struct key *find_master_key_user(struct fscrypt_master_key *mk)
+{
+	char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE];
+
+	format_mk_user_description(description, mk->mk_spec.identifier);
+	return search_fscrypt_keyring(mk->mk_users, &key_type_fscrypt_mk_user,
+				      description);
+}
+
+static int allocate_master_key_users_keyring(struct fscrypt_master_key *mk)
+{
+	char description[FSCRYPT_MK_USERS_DESCRIPTION_SIZE];
+	struct key *mk_users;
+
+	format_mk_users_keyring_description(description,
+					    mk->mk_spec.identifier);
+
+	mk_users = keyring_alloc(description, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
+				 current_cred(), KEY_POS_SEARCH |
+				   KEY_USR_SEARCH | KEY_USR_READ | KEY_USR_VIEW,
+				 KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(mk_users))
+		return PTR_ERR(mk_users);
+
+	mk->mk_users = mk_users;
+	return 0;
+}
+
+/*
+ * Give the current user a key in ->mk_users.  This charges the user's quota and
+ * marks the master key as added by the current user, so that it cannot be
+ * removed by another user with the key.
+ */
+static int add_master_key_user(struct fscrypt_master_key *mk)
+{
+	char description[FSCRYPT_MK_USER_DESCRIPTION_SIZE];
+	struct key *mk_user;
+	int err;
+
+	format_mk_user_description(description, mk->mk_spec.identifier);
+	mk_user = key_alloc(&key_type_fscrypt_mk_user, description,
+			    current_fsuid(), current_gid(), current_cred(),
+			    KEY_POS_SEARCH | KEY_USR_VIEW, 0, NULL);
+	if (IS_ERR(mk_user))
+		return PTR_ERR(mk_user);
+
+	err = key_instantiate_and_link(mk_user, NULL, 0, mk->mk_users, NULL);
+	key_put(mk_user);
+	return err;
+}
+
+/*
+ * Remove the current user's key from ->mk_users, if present.
+ */
+static int remove_master_key_user(struct fscrypt_master_key *mk)
+{
+	struct key *mk_user;
+	int err;
+
+	mk_user = find_master_key_user(mk);
+	if (IS_ERR(mk_user)) {
+		if (mk_user != ERR_PTR(-ENOKEY))
+			return PTR_ERR(mk_user);
+		return 0;
+	}
+	err = key_unlink(mk->mk_users, mk_user);
+	key_put(mk_user);
+	return err;
+}
+
 static struct key *
 allocate_master_key(struct fscrypt_master_key_secret *secret,
 		    const struct fscrypt_key_specifier *mk_spec)
@@ -429,16 +581,36 @@ allocate_master_key(struct fscrypt_master_key_secret *secret,
 	mk->mk_spec = *mk_spec;
 
 	move_master_key_secret(&mk->mk_secret, secret);
+	init_rwsem(&mk->mk_secret_sem);
 
 	refcount_set(&mk->mk_refcount, 1); /* secret is present */
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
 	spin_lock_init(&mk->mk_decrypted_inodes_lock);
 
+	if (mk_spec->type != FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR) {
+		err = allocate_master_key_users_keyring(mk);
+		if (err) {
+			key = ERR_PTR(err);
+			goto out_free_mk;
+		}
+
+		err = add_master_key_user(mk);
+		if (err) {
+			key = ERR_PTR(err);
+			goto out_free_mk;
+		}
+	}
+
+	/*
+	 * Note that we don't charge this key to anyone's quota since it's owned
+	 * by root, and the keys in ->mk_users are charged instead.
+	 */
 	format_mk_description(description, mk_spec);
 	key = key_alloc(&key_type_fscrypt_mk, description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
 			KEY_POS_SEARCH | KEY_USR_SEARCH |
-			KEY_USR_READ | KEY_USR_VIEW, 0, NULL);
+			KEY_USR_READ | KEY_USR_VIEW,
+			KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(key))
 		goto out_free_mk;
 
@@ -510,12 +682,31 @@ static int add_master_key(struct super_block *sb,
 			goto out_put_key;
 	} else {
 		struct fscrypt_master_key *mk = key->payload.data[0];
+		struct key *mk_user;
 		bool rekey;
 
 		/* Found the key in ->s_master_keys */
 
 		down_write(&key->sem);
 
+		/*
+		 * If the current user is already in ->mk_users, then there's
+		 * nothing to do.
+		 */
+		if (mk->mk_users) {
+			mk_user = find_master_key_user(mk);
+			if (mk_user != ERR_PTR(-ENOKEY)) {
+				up_write(&key->sem);
+				if (IS_ERR(mk_user)) {
+					err = PTR_ERR(mk_user);
+				} else {
+					key_put(mk_user);
+					err = 0;
+				}
+				goto out_put_key;
+			}
+		}
+
 		/*
 		 * Take a reference if we'll be re-adding ->mk_secret.  If we
 		 * couldn't take a reference, then the key is being removed from
@@ -531,9 +722,24 @@ static int add_master_key(struct super_block *sb,
 			goto retry;
 		}
 
+		/* Add the current user to ->mk_users */
+		if (mk->mk_users) {
+			err = add_master_key_user(mk);
+			if (err) {
+				up_write(&key->sem);
+				if (rekey &&
+				    refcount_dec_and_test(&mk->mk_refcount))
+					key_invalidate(key);
+				goto out_put_key;
+			}
+		}
+
 		/* Re-add the secret key material if needed */
-		if (rekey)
+		if (rekey) {
+			down_write(&mk->mk_secret_sem);
 			move_master_key_secret(&mk->mk_secret, secret);
+			up_write(&mk->mk_secret_sem);
+		}
 		up_write(&key->sem);
 	}
 	err = 0;
@@ -548,6 +754,23 @@ static int add_master_key(struct super_block *sb,
  * Add a master encryption key to the filesystem, causing all files which were
  * encrypted with it to appear "unlocked" (decrypted) when accessed.  The key
  * can be removed later by FS_IOC_REMOVE_ENCRYPTION_KEY.
+ *
+ * When adding a key for use by v1 encryption policies, this ioctl is
+ * privileged, and userspace must provide the 'key_descriptor'.
+ *
+ * When adding a key for use by v2+ encryption policies, this ioctl is
+ * unprivileged.  This is needed, in general, to allow non-root users to use
+ * encryption without encountering the visibility problems of process-subscribed
+ * keyrings and the inability to properly remove keys.  This works by having
+ * each key identified by its cryptographically secure hash --- the
+ * 'key_identifier'.  The cryptographic hash ensures that a malicious user
+ * cannot add the wrong key for a given identifier.  Furthermore, each added key
+ * is charged to the appropriate user's quota for the keyrings service, which
+ * prevents a malicious user from adding too many keys.  Finally, we forbid a
+ * user from removing a key while other users have added it too, which prevents
+ * a user who knows another user's key from causing a denial-of-service by
+ * removing it at an inopportune time.  (We tolerate that a user who knows a key
+ * can prevent other users from removing it.)
  */
 int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 {
@@ -571,9 +794,6 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	if (!valid_key_spec(&arg.key_spec))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	memset(&secret, 0, sizeof(secret));
 	secret.size = arg.raw_size;
 	err = -EFAULT;
@@ -613,6 +833,15 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 				 arg.key_spec.identifier,
 				 FSCRYPT_KEY_IDENTIFIER_SIZE))
 			goto out_wipe_secret;
+	} else {
+		/*
+		 * Only root can add keys that are identified by an arbitrary
+		 * descriptor rather than by a cryptographic hash --- since
+		 * otherwise a malicious user could add the wrong key.
+		 */
+		err = -EACCES;
+		if (!capable(CAP_SYS_ADMIN))
+			goto out_wipe_secret;
 	}
 
 	err = add_master_key(sb, &secret, &arg.key_spec);
@@ -744,7 +973,9 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 }
 
 /*
- * Try to remove an fscrypt master encryption key.
+ * Try to remove an fscrypt master encryption key.  If other users have also
+ * added the key, we'll remove the current user's usage of the key, then return
+ * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.
  *
  * First we wipe the actual master key secret from memory, so that no more
  * inodes can be unlocked with it.  Then, we try to evict all cached inodes that
@@ -775,13 +1006,33 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
-	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
+	if (arg.flags & ~FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS)
+		return -EINVAL;
+
+	if (arg.reserved1)
+		return -EINVAL;
+
+	if (memchr_inv(arg.reserved2, 0, sizeof(arg.reserved2)))
 		return -EINVAL;
 
 	if (!valid_key_spec(&arg.key_spec))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	/*
+	 * Only root can request that the key be removed no matter how many
+	 * user(s) have added it.
+	 */
+	if ((arg.flags & FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	/*
+	 * Only root can remove keys that are identified by an arbitrary
+	 * descriptor rather than by a cryptographic hash --- since only root
+	 * can add such keys.
+	 */
+	if (arg.key_spec.type != FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER &&
+	    !capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	key = find_master_key(sb, &arg.key_spec);
@@ -790,10 +1041,34 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
 	mk = key->payload.data[0];
 
 	down_write(&key->sem);
+
+	if (mk->mk_users && mk->mk_users->keys.nr_leaves_on_tree != 0) {
+		if (arg.flags & FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS)
+			err = keyring_clear(mk->mk_users);
+		else
+			err = remove_master_key_user(mk);
+		if (err) {
+			up_write(&key->sem);
+			goto out_put_key;
+		}
+		if (mk->mk_users->keys.nr_leaves_on_tree != 0) {
+			/*
+			 * Other users have still added the key too.  We removed
+			 * the current user's usage of the key if there was one,
+			 * but we still can't remove the key itself.
+			 */
+			err = -EUSERS;
+			up_write(&key->sem);
+			goto out_put_key;
+		}
+	}
+
 	dead = false;
 	if (is_master_key_secret_present(&mk->mk_secret)) {
+		down_write(&mk->mk_secret_sem);
 		wipe_master_key_secret(&mk->mk_secret);
 		dead = refcount_dec_and_test(&mk->mk_refcount);
+		up_write(&mk->mk_secret_sem);
 	}
 	up_write(&key->sem);
 	if (dead) {
@@ -802,6 +1077,7 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
 	} else {
 		err = try_to_lock_encrypted_files(sb, mk);
 	}
+out_put_key:
 	key_put(key);
 	return err;
 }
@@ -818,6 +1094,15 @@ EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key);
  * regular file in it (which can confuse the "incompletely removed" state with
  * absent or present).
  *
+ * In addition, for v2 policy keys we allow applications to determine, via
+ * ->status_flags and ->user_count, whether the key has been added by the
+ * current user, by other users, or by both.  Most applications should not need
+ * this, since ordinarily only one user should know a given key.  However, if a
+ * secret key is shared by multiple users, applications may wish to add an
+ * already-present key to prevent other users from removing it.  This ioctl can
+ * be used to check whether that really is the case before the work is done to
+ * add the key --- which might e.g. require prompting the user for a passphrase.
+ *
  * Note: this ioctl only works with keys added to the filesystem-level keyring.
  * It does *not* work with keys added via the old mechanism which involved
  * process-subscribed keyrings.
@@ -839,6 +1124,8 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 	if (!valid_key_spec(&arg.key_spec))
 		return -EINVAL;
 
+	arg.status_flags = 0;
+	arg.user_count = 0;
 	arg.reserved2 = 0;
 	memset(arg.reserved3, 0, sizeof(arg.reserved3));
 
@@ -860,6 +1147,19 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 	}
 
 	arg.status = FSCRYPT_KEY_STATUS_PRESENT;
+	if (mk->mk_users) {
+		struct key *mk_user;
+
+		arg.user_count = mk->mk_users->keys.nr_leaves_on_tree;
+		mk_user = find_master_key_user(mk);
+		if (!IS_ERR(mk_user)) {
+			arg.status_flags |= FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF;
+			key_put(mk_user);
+		} else if (mk_user != ERR_PTR(-ENOKEY)) {
+			err = PTR_ERR(mk_user);
+			goto out_release_key;
+		}
+	}
 	err = 0;
 out_release_key:
 	up_read(&key->sem);
@@ -1029,11 +1329,12 @@ static int find_and_derive_key_legacy(const struct inode *inode,
  * Find the master key, then derive the inode's actual encryption key.
  *
  * If the master key is found in the filesystem-level keyring, then the
- * corresponding 'struct key' is returned read-locked in *master_key_ret.  This
- * is needed because we need to hold the semaphore until we link the new
- * fscrypt_info into ->mk_decrypted_inodes, but in the case where multiple tasks
- * are racing to set up an inode's ->i_crypt_info, only the winner should link
- * its fscrypt_info into ->mk_decrypted_inodes.
+ * corresponding 'struct key' is returned in *master_key_ret with
+ * ->mk_secret_sem read-locked.  This is needed because we need to hold
+ * ->mk_secret_sem until we link the new fscrypt_info into
+ * ->mk_decrypted_inodes, but in the case where multiple tasks are racing to set
+ * up an inode's ->i_crypt_info, only the winner should link its fscrypt_info
+ * into ->mk_decrypted_inodes.
  */
 static int find_and_derive_key(const struct inode *inode,
 			       const union fscrypt_context *ctx,
@@ -1073,7 +1374,7 @@ static int find_and_derive_key(const struct inode *inode,
 						  derived_keysize);
 	}
 	mk = key->payload.data[0];
-	down_read(&key->sem);
+	down_read(&mk->mk_secret_sem);
 
 	/* Has the secret been removed using FS_IOC_REMOVE_ENCRYPTION_KEY? */
 	if (!is_master_key_secret_present(&mk->mk_secret)) {
@@ -1117,7 +1418,7 @@ static int find_and_derive_key(const struct inode *inode,
 	return 0;
 
 out_release_key:
-	up_read(&key->sem);
+	up_read(&mk->mk_secret_sem);
 	key_put(key);
 	return err;
 }
@@ -1361,7 +1662,9 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	}
 out:
 	if (master_key) {
-		up_read(&master_key->sem);
+		struct fscrypt_master_key *mk = master_key->payload.data[0];
+
+		up_read(&mk->mk_secret_sem);
 		key_put(master_key);
 	}
 	if (res == -ENOKEY)
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 1918bdc0c6d7..901e87d8fb74 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -102,7 +102,10 @@ struct fscrypt_add_key_args {
 
 /* Struct passed to FS_IOC_REMOVE_ENCRYPTION_KEY */
 struct fscrypt_remove_key_args {
-	__u64 reserved[3];
+	__u32 flags;
+#define FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS	0x00000001
+	__u32 reserved1;
+	__u64 reserved2[2];
 	struct fscrypt_key_specifier key_spec;
 };
 
@@ -117,9 +120,11 @@ struct fscrypt_get_key_status_args {
 #define FSCRYPT_KEY_STATUS_ABSENT		1
 #define FSCRYPT_KEY_STATUS_PRESENT		2
 #define FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED	3
+	__u32 status_flags;
+#define FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF   0x00000001
+	__u32 user_count;
 	__u32 reserved2;
-
-	__u64 reserved3[7];
+	__u64 reserved3[6];
 };
 
 #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR( 'f', 19, struct fscrypt_policy)
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
