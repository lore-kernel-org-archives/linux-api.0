From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 11/25] fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
Date: Mon, 23 Oct 2017 14:40:44 -0700
Message-ID: <20171023214058.128121-12-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023214058.128121-1-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ryo Hashimoto <hashimoto-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sarthak Kukreti <sarthakkukreti-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a new ioctl, FS_IOC_GET_ENCRYPTION_KEY_STATUS.  Given a key
specified by 'struct fscrypt_key_specifier' (the same way a key is
specified for the ioctls which add and remove keys), it returns status
information in a 'struct fscrypt_get_key_status_args'.

The main motivation for this is that applications need to be able to
check whether an encrypted directory is "unlocked" or not, so that they
can add the key if it is not, and avoid adding the key (which may
involve prompting the user for a passphrase) if it already is.  It's
possible to use some workarounds such as checking whether opening a
regular file fails with ENOKEY, or checking whether the filenames "look
like gibberish" or not.  However, no workaround is usable in all cases.

It's also not a simple matter of locked/unlocked anymore because we also
have a partially locked state, where FS_IOC_REMOVE_ENCRYPTION_KEY has
removed the secret but some encrypted files are still in use.  This
difference can be important for applications.  Moreover, after later
patches some applications will also need a way to determine whether a
key was added by the current user vs. by some other user.

Ideally we'd have been able to use keyctl_search() to check whether a
key is present or not, rather than introducing a new ioctl.  However,
even if the keyrings permission system was fixed to allow granting
read-only access to a keyring (currently the "Search" permission allows
keyctl_invalidate()), it still wouldn't work out because the fscrypt
master keys can be in states other than just present/absent, as
described above.  Moreover, we'd still have to at least add an ioctl
which retrieves the ID of ->s_master_keys.

/proc/keys cannot really be the API either, since reading /proc/keys
involves iterating through all keys on the system and is primarily meant
as a debugging interface.  We also don't necessarily want to grant
everyone VIEW access to all the fscrypt keys as that would imply
everyone being able to list them as well.

Therefore, a new ioctl to get an fscrypt key's status seems like the
best solution.  It is also consistent with the ioctls to add and remove
keys.

Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/crypto/keyinfo.c             | 64 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt_notsupp.h |  6 ++++
 include/linux/fscrypt_supp.h    |  1 +
 include/uapi/linux/fscrypt.h    | 17 +++++++++++
 4 files changed, 88 insertions(+)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index dc2697cf9114..4052030a4c96 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -566,6 +566,70 @@ int fscrypt_ioctl_remove_key(struct file *filp, const void __user *uarg)
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_remove_key);
 
+/*
+ * Retrieve the status of an fscrypt master encryption key.
+ *
+ * We set ->status to indicate whether the key is absent, present, or
+ * incompletely removed.  "Incompletely removed" means that the master key
+ * secret has been removed, but some files which had been unlocked with it are
+ * still in use.  This field allows applications to easily determine the state
+ * of an encrypted directory without using a hack such as trying to open a
+ * regular file in it (which can confuse the "incompletely removed" state with
+ * absent or present).
+ *
+ * Note: this ioctl only works with keys added to the filesystem-level keyring.
+ * It does *not* work with keys added via the old mechanism which involved
+ * process-subscribed keyrings.
+ */
+int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
+{
+	struct super_block *sb = file_inode(filp)->i_sb;
+	struct fscrypt_get_key_status_args arg;
+	struct key *key;
+	struct fscrypt_master_key *mk;
+	int err;
+
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.reserved1, 0, sizeof(arg.reserved1)))
+		return -EINVAL;
+
+	if (!valid_key_spec(&arg.key_spec))
+		return -EINVAL;
+
+	arg.reserved2 = 0;
+	memset(arg.reserved3, 0, sizeof(arg.reserved3));
+
+	key = find_master_key(sb, &arg.key_spec);
+	if (IS_ERR(key)) {
+		if (key != ERR_PTR(-ENOKEY))
+			return PTR_ERR(key);
+		arg.status = FSCRYPT_KEY_STATUS_ABSENT;
+		err = 0;
+		goto out;
+	}
+	mk = key->payload.data[0];
+	down_read(&key->sem);
+
+	if (!is_master_key_secret_present(&mk->mk_secret)) {
+		arg.status = FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED;
+		err = 0;
+		goto out_release_key;
+	}
+
+	arg.status = FSCRYPT_KEY_STATUS_PRESENT;
+	err = 0;
+out_release_key:
+	up_read(&key->sem);
+	key_put(key);
+out:
+	if (!err && copy_to_user(uarg, &arg, sizeof(arg)))
+		err = -EFAULT;
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_ioctl_get_key_status);
+
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 {
 	struct fscrypt_completion_result *ecr = req->data;
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 92616bfdc294..bd60f951b06a 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -95,6 +95,12 @@ static inline int fscrypt_ioctl_remove_key(struct file *filp,
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_ioctl_get_key_status(struct file *filp,
+					       void __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_get_encryption_info(struct inode *inode)
 {
 	return -EOPNOTSUPP;
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index 620ca4f1bafe..ace278056dbe 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -44,6 +44,7 @@ extern int fscrypt_inherit_context(struct inode *, struct inode *,
 /* keyinfo.c */
 extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
 extern int fscrypt_ioctl_remove_key(struct file *filp, const void __user *arg);
+extern int fscrypt_ioctl_get_key_status(struct file *filp, void __user *arg);
 extern int fscrypt_get_encryption_info(struct inode *);
 extern void fscrypt_put_encryption_info(struct inode *, struct fscrypt_info *);
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 5d02f138668c..9da153df238a 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -72,11 +72,28 @@ struct fscrypt_remove_key_args {
 	struct fscrypt_key_specifier key_spec;
 };
 
+/* Struct passed to FS_IOC_GET_ENCRYPTION_KEY_STATUS */
+struct fscrypt_get_key_status_args {
+	/* input */
+	__u64 reserved1[3];
+	struct fscrypt_key_specifier key_spec;
+
+	/* output */
+	__u32 status;
+#define FSCRYPT_KEY_STATUS_ABSENT		1
+#define FSCRYPT_KEY_STATUS_PRESENT		2
+#define FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED	3
+	__u32 reserved2;
+
+	__u64 reserved3[7];
+};
+
 #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR( 'f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW( 'f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	_IOW( 'f', 21, struct fscrypt_policy)
 #define FS_IOC_ADD_ENCRYPTION_KEY	_IOWR('f', 22, struct fscrypt_add_key_args)
 #define FS_IOC_REMOVE_ENCRYPTION_KEY	_IOR( 'f', 23, struct fscrypt_remove_key_args)
+#define FS_IOC_GET_ENCRYPTION_KEY_STATUS _IOWR('f',24, struct fscrypt_get_key_status_args)
 
 /**********************************************************************/
 
-- 
2.15.0.rc0.271.g36b669edcc-goog
