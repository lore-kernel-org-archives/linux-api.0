Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219809;
	b=Td18ivmYROPi1kv/s5uY2bt1hcXEIkGSBwzGLtxmUvd0TQdKfAO8brgBsn/DP8VEWZNh
	 AxOkYb1pSvPoIf2sHFlXGLVDo1rDlW/hCk3WdBl5S05btE21dGE9ibN5T5vyzdVRC1fco
	 HeoymLz1jgo1lS/gbTHotJyHxdftFTb8W2Xx1z6UP6ATNIxDJKtQGwrvbv0fJNvmtxd9s
	 J+sRGVIc1wkBfdlbbSDsjtRKtE3bPpIFMlf4BTjqqNqjZ3V7vECXs76kn/mxtmFlzEML8
	 rk8zQyXYw1b1okPgL20jNu728emRYwZbfOUUaTNBxVUmZnhFMdHr1P8C1li2jmf2DgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=n+/Upd/XJBQX3Y8J/z67FZG5Cdbg44xnD+RStO2b1yY=;
	b=bgoJH7BzxSAsymKxv2THhLr+1xd3GbQtUa7q1YO0WDIa+vQVRcSpnuyeo/8xIF4Uc46y
	 dF6/XYTA7aFfwHm+eyQSJEfLrFNJ4McrxoPAY+4woEyCPKbXPDF5XPaxJ+RTq7tk8FwUZ
	 DFZO0FO/uqz9r1TxB0MSJHYdGvHntWoHjioS3zA9OCbnONsZt/+KU45VAF1ivjwQJC0aF
	 9QRXiKEKlz03tAwajItt7XkoLuT/SOlxDbYk9E5QRWjpunqerjML6Jl12d1Ck3rNzAKp0
	 KTdrabg8QSgHXhdJtdLlk+KUL3Tu3Z129RS0p9dFbSJjrqU3f4Fe/DA9g6YqD0PrxDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JW0dWf1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B7F83606A699;
	Sat, 21 Nov 2026 00:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JW0dWf1x
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 749491F000EE;
	Sat, 21 Nov 2026 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219809;
	bh=n+/Upd/XJBQX3Y8J/z67FZG5Cdbg44xnD+RStO2b1yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JW0dWf1x0lJlzK4S39Vp3X3THtmdziDk02Ass16+FtroY9c78TALF/wmj98fjM9V/
	 IEDgTPLu/GBrHm5vqMrhJa6FSzXsRZKXXCjVJ0Xb2ciDwfOR/OdPZVBe4trLWi00A/
	 PBT9uusZnUltQ3vwQPVUfB6VGZhmH49usVTishcotKg2QK3mOPICJlhiE4Ewppmux0
	 jtvn+OlIE7OkyJCzvCMM1JqsR81jSY6Lk86pVaraD60sgxfRsAr22RzfaSSgQf7dSn
	 PEInB4ydc9ALMb30cwIDP1hkR/UwtNLYtm9k1EOYxRdFaei0gMGjWNhBwZvf+zlVNf
	 ugnAodp2Pz03g==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 17/25] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Sat, 21 Nov 2026 02:08:36 +0200
Message-ID: <20261121000844.1863324-18-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fsopen() and fsmount() gate on CAP_SYS_ADMIN in the caller's current
mount namespace and initialize filesystem contexts from current's user
and network namespaces, preventing an unprivileged external manager from
creating superblocks and detached mounts for an unentered root namespace.

Add FSCONFIG_SET_ROOTNS and the ->set_rootns() fs_context operation so
callers holding CAP_SYS_ADMIN in the target rootns user namespace can
bind a newly opened fs_context to that rootns once before offering
parameters. Allow unprivileged callers to open FS_USERNS_MOUNT contexts
in FS_CONTEXT_AWAITING_NS without module autoloading until
FSCONFIG_SET_ROOTNS authorizes and initializes the context, and keep
devpts pty_reserve restricted to host mounts.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/devpts/inode.c          |   2 +
 fs/filesystems.c           |  15 ++++
 fs/fs_context.c            |  21 ++++--
 fs/fsopen.c                | 140 ++++++++++++++++++++++++++++++++++---
 fs/internal.h              |   6 ++
 fs/namespace.c             |  19 ++++-
 include/linux/fs_context.h |   6 ++
 include/uapi/linux/mount.h |   1 +
 8 files changed, 196 insertions(+), 14 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb..db5a5c7a07db 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -434,6 +434,8 @@ static int devpts_init_fs_context(struct fs_context *fc)
 	fsi->mount_opts.max     = NR_UNIX98_PTY_MAX;
 
 	if (fc->purpose == FS_CONTEXT_FOR_MOUNT &&
+	    !fc->rootns_bound &&
+	    fc->user_ns == &init_user_ns &&
 	    current->nsproxy->mnt_ns == init_task.nsproxy->mnt_ns)
 		fsi->mount_opts.reserve = true;
 
diff --git a/fs/filesystems.c b/fs/filesystems.c
index 3083d904df9b..9429844bf6bf 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <linux/fs_parser.h>
 #include <linux/rculist.h>
+#include "internal.h"
 
 /*
  * Read-mostly filesystem drivers list.
@@ -390,6 +391,20 @@ static struct file_system_type *__get_fs_type(const char *name, int len)
 	return fs;
 }
 
+struct file_system_type *get_fs_type_noload(const char *name)
+{
+	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	int len = dot ? dot - name : strlen(name);
+
+	fs = __get_fs_type(name, len);
+	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
+		put_filesystem(fs);
+		fs = NULL;
+	}
+	return fs;
+}
+
 struct file_system_type *get_fs_type(const char *name)
 {
 	struct file_system_type *fs;
diff --git a/fs/fs_context.c b/fs/fs_context.c
index a50584df97be..cd004750b99c 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -249,6 +249,7 @@ EXPORT_SYMBOL(generic_parse_monolithic);
  * @sb_flags: Filesystem/superblock flags (SB_*)
  * @sb_flags_mask: Applicable members of @sb_flags
  * @purpose: The purpose that this configuration shall be used for.
+ * @init: Whether to initialise the filesystem context immediately.
  *
  * Open a filesystem and create a mount context.  The mount context is
  * initialised with the supplied flags and, if a submount/automount from
@@ -259,7 +260,8 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 				      struct dentry *reference,
 				      unsigned int sb_flags,
 				      unsigned int sb_flags_mask,
-				      enum fs_context_purpose purpose)
+				      enum fs_context_purpose purpose,
+				      bool init)
 {
 	struct fs_context *fc;
 	int ret = -ENOMEM;
@@ -292,6 +294,9 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 		break;
 	}
 
+	if (!init)
+		return fc;
+
 	ret = fc->fs_type->init_fs_context(fc);
 	if (ret < 0)
 		goto err_fc;
@@ -307,10 +312,16 @@ struct fs_context *fs_context_for_mount(struct file_system_type *fs_type,
 					unsigned int sb_flags)
 {
 	return alloc_fs_context(fs_type, NULL, sb_flags, 0,
-					FS_CONTEXT_FOR_MOUNT);
+				FS_CONTEXT_FOR_MOUNT, true);
 }
 EXPORT_SYMBOL(fs_context_for_mount);
 
+struct fs_context *fs_context_for_unpriv_mount(struct file_system_type *fs_type)
+{
+	return alloc_fs_context(fs_type, NULL, 0, 0,
+				FS_CONTEXT_FOR_MOUNT, false);
+}
+
 struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 					unsigned int sb_flags,
 					unsigned int sb_flags_mask)
@@ -320,7 +331,8 @@ struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 		return ERR_PTR(-EINVAL);
 
 	return alloc_fs_context(dentry->d_sb->s_type, dentry, sb_flags,
-				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE);
+				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE,
+				true);
 }
 
 /**
@@ -337,7 +349,8 @@ struct fs_context *fs_context_for_submount(struct file_system_type *type,
 	struct fs_context *fc;
 	int ret;
 
-	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT);
+	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT,
+			      true);
 	if (IS_ERR(fc))
 		return fc;
 
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..e0d65f6018a7 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -13,9 +13,14 @@
 #include <linux/security.h>
 #include <linux/anon_inodes.h>
 #include <linux/namei.h>
+#include <linux/capability.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
+#include <linux/user_namespace.h>
 #include <linux/file.h>
 #include <uapi/linux/mount.h>
 #include <linux/audit.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -41,6 +46,95 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
 	return p;
 }
 
+/**
+ * DOC: FSCONFIG_SET_ROOTNS
+ *
+ * ``fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, rootnsfd)`` binds a newly
+ * opened filesystem context to ``rootnsfd`` once before any parameters are
+ * supplied (subsequent calls fail with ``-EBUSY``).
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` in the target ``rootns`` user
+ * namespace, allowing unprivileged callers to configure ``FS_USERNS_MOUNT``
+ * filesystems without entering the user namespace first.
+ *
+ * The filesystem must support ``FS_USERNS_MOUNT`` or
+ * ``FS_USERNS_DELEGATABLE`` (failing with ``-EOPNOTSUPP`` otherwise). The
+ * context is initialized against the ``rootns`` network and user namespaces,
+ * and ``proc`` and ``mqueue`` contexts bind to the target ``rootns`` PID and
+ * IPC namespaces.
+ */
+static int fsconfig_set_rootns(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct user_namespace *user_ns;
+	struct rootns *c;
+	int ret;
+
+	if (!is_rootns_file(param->file))
+		return -EINVAL;
+
+	c = param->file->private_data;
+	user_ns = c->user_ns;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (!(fc->fs_type->fs_flags &
+	      (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE)))
+		return -EOPNOTSUPP;
+
+	if (fc->need_free && fc->ops && fc->ops->free)
+		fc->ops->free(fc);
+	fc->need_free = false;
+	fc->fs_private = NULL;
+	fc->s_fs_info = NULL;
+	fc->ops = NULL;
+	fc->sb_flags = 0;
+	fc->global = false;
+	security_free_mnt_opts(&fc->security);
+
+	if (fc->log.prefix && strcmp(fc->fs_type->name, fc->log.prefix)) {
+		struct file_system_type *orig;
+
+		orig = get_fs_type_noload(fc->log.prefix);
+		if (!orig) {
+			fc->phase = FS_CONTEXT_FAILED;
+			return -ENODEV;
+		}
+		put_filesystem(fc->fs_type);
+		fc->fs_type = orig;
+	}
+
+	put_net(fc->net_ns);
+	fc->net_ns = get_net(c->ns->net_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(user_ns);
+
+	fc->rootns_bound = true;
+	fc->rootns_mnt_id = c->ns->mnt_ns->ns.ns_id;
+
+	ret = fc->fs_type->init_fs_context(fc);
+	if (ret < 0) {
+		fc->rootns_bound = false;
+		fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+	}
+	fc->need_free = true;
+
+	if (fc->ops->set_rootns) {
+		ret = fc->ops->set_rootns(fc, c);
+		if (ret < 0) {
+			fc->rootns_bound = false;
+			fc->phase = FS_CONTEXT_FAILED;
+			return ret;
+		}
+	}
+	if (fc->user_ns != user_ns) {
+		fc->rootns_bound = false;
+		fc->phase = FS_CONTEXT_FAILED;
+		return -EOPNOTSUPP;
+	}
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return 0;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
  * Only one message is returned for each read(2) call.
@@ -123,9 +217,11 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	struct file_system_type *fs_type;
 	struct fs_context *fc;
 	const char *fs_name;
+	bool priv;
 	int ret;
 
-	if (!may_mount())
+	priv = may_mount();
+	if (!priv && !IS_ENABLED(CONFIG_ROOTNS))
 		return -EPERM;
 
 	if (flags & ~FSOPEN_CLOEXEC)
@@ -137,17 +233,23 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 
 	audit_log_fsopen(fs_name);
 
-	fs_type = get_fs_type(fs_name);
+	fs_type = priv ? get_fs_type(fs_name) : get_fs_type_noload(fs_name);
 	kfree(fs_name);
 	if (!fs_type)
-		return -ENODEV;
+		return priv ? -ENODEV : -EPERM;
+
+	if (!priv && !(fs_type->fs_flags & FS_USERNS_MOUNT)) {
+		put_filesystem(fs_type);
+		return -EPERM;
+	}
 
-	fc = fs_context_for_mount(fs_type, 0);
+	fc = priv ? fs_context_for_mount(fs_type, 0) :
+		    fs_context_for_unpriv_mount(fs_type);
 	put_filesystem(fs_type);
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = priv ? FS_CONTEXT_CREATE_NS : FS_CONTEXT_AWAITING_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +324,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -291,6 +394,8 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 	ret = finish_clean_context(fc);
 	if (ret)
 		return ret;
+	if (fc->phase == FS_CONTEXT_AWAITING_NS && cmd != FSCONFIG_SET_ROOTNS)
+		return -EPERM;
 	switch (cmd) {
 	case FSCONFIG_CMD_CREATE:
 		return vfs_cmd_create(fc, false);
@@ -298,9 +403,17 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 		return vfs_cmd_create(fc, true);
 	case FSCONFIG_CMD_RECONFIGURE:
 		return vfs_cmd_reconfigure(fc);
+	case FSCONFIG_SET_ROOTNS:
+		if (fc->phase != FS_CONTEXT_AWAITING_NS &&
+		    fc->phase != FS_CONTEXT_CREATE_NS)
+			return -EBUSY;
+		return fsconfig_set_rootns(fc, param);
+
 	default:
-		if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
-		    fc->phase != FS_CONTEXT_RECONF_PARAMS)
+		if (fc->phase == FS_CONTEXT_CREATE_NS)
+			fc->phase = FS_CONTEXT_CREATE_PARAMS;
+		else if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
+			 fc->phase != FS_CONTEXT_RECONF_PARAMS)
 			return -EBUSY;
 
 		return vfs_parse_fs_param(fc, param);
@@ -390,6 +503,10 @@ SYSCALL_DEFINE5(fsconfig,
 		if (!_key || _value || aux < 0)
 			return -EINVAL;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		if (_key || _value || aux < 0)
+			return -EINVAL;
+		break;
 	case FSCONFIG_CMD_CREATE:
 	case FSCONFIG_CMD_CREATE_EXCL:
 	case FSCONFIG_CMD_RECONFIGURE:
@@ -457,6 +574,12 @@ SYSCALL_DEFINE5(fsconfig,
 			goto out_key;
 		param.dirfd = aux;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		ret = -EBADF;
+		param.file = fget(aux);
+		if (!param.file)
+			goto out_key;
+		break;
 	default:
 		break;
 	}
@@ -482,6 +605,7 @@ SYSCALL_DEFINE5(fsconfig,
 			putname(param.name);
 		break;
 	case FSCONFIG_SET_FD:
+	case FSCONFIG_SET_ROOTNS:
 		if (param.file)
 			fput(param.file);
 		break;
diff --git a/fs/internal.h b/fs/internal.h
index 3f2fbac40f8e..d6815bf6ea9b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -40,12 +40,18 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
  */
 extern void __init chrdev_init(void);
 
+/*
+ * filesystems.c
+ */
+struct file_system_type *get_fs_type_noload(const char *name);
+
 /*
  * fs_context.c
  */
 extern int parse_monolithic_mount_data(struct fs_context *, void *);
 extern void vfs_clean_context(struct fs_context *fc);
 extern int finish_clean_context(struct fs_context *fc);
+struct fs_context *fs_context_for_unpriv_mount(struct file_system_type *fs_type);
 
 /*
  * namei.c
diff --git a/fs/namespace.c b/fs/namespace.c
index 1e7d776c0966..162ecb52f6eb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4699,16 +4699,19 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	struct vfsmount *new_mnt;
 	struct mount *mnt;
 	unsigned int mnt_flags = 0;
+	bool priv;
 	long ret;
 
 	if ((flags & ~(FSMOUNT_CLOEXEC | FSMOUNT_NAMESPACE)) != 0)
 		return -EINVAL;
 
+	priv = may_mount();
 	if ((flags & FSMOUNT_NAMESPACE) &&
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!(flags & FSMOUNT_NAMESPACE) && !may_mount())
+	if (!(flags & FSMOUNT_NAMESPACE) && !IS_ENABLED(CONFIG_ROOTNS) &&
+	    !priv)
 		return -EPERM;
 
 	if (attr_flags & ~FSMOUNT_VALID_FLAGS)
@@ -4743,6 +4746,15 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	if (ret)
 		return ret;
 
+	if (fc->rootns_bound) {
+		if (flags & FSMOUNT_NAMESPACE)
+			return -EINVAL;
+		if (!ns_capable(fc->user_ns, CAP_SYS_ADMIN))
+			return -EPERM;
+	} else if (!(flags & FSMOUNT_NAMESPACE) && !priv) {
+		return -EPERM;
+	}
+
 	/* There must be a valid superblock or we can't mount it */
 	ret = -EINVAL;
 	if (!fc->root)
@@ -4784,9 +4796,12 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(fc->rootns_bound ? fc->user_ns :
+			  current->nsproxy->mnt_ns->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
+	if (fc->rootns_bound)
+		ns->seq_origin = fc->rootns_mnt_id;
 	mnt = real_mount(new_path.mnt);
 	ns->root = mnt;
 	ns->nr_mounts = 1;
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..42648bec5cfa 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -21,6 +21,7 @@ struct file_system_type;
 struct mnt_namespace;
 struct net;
 struct pid_namespace;
+struct rootns;
 struct super_block;
 struct user_namespace;
 struct vfsmount;
@@ -36,6 +37,8 @@ enum fs_context_purpose {
  * Userspace usage phase for fsopen/fspick.
  */
 enum fs_context_phase {
+	FS_CONTEXT_AWAITING_NS,		/* Unprivileged context awaiting target ns */
+	FS_CONTEXT_CREATE_NS,		/* Set namespaces for sb creation */
 	FS_CONTEXT_CREATE_PARAMS,	/* Loading params for sb creation */
 	FS_CONTEXT_CREATING,		/* A superblock is being created */
 	FS_CONTEXT_AWAITING_MOUNT,	/* Superblock created, awaiting fsmount() */
@@ -101,6 +104,7 @@ struct fs_context {
 	const char		*source;	/* The source name (eg. dev path) */
 	void			*security;	/* LSM options */
 	void			*s_fs_info;	/* Proposed s_fs_info */
+	u64			rootns_mnt_id;	/* Target rootns mnt_ns ID */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		s_iflags;	/* OR'd with sb->s_iflags */
@@ -110,6 +114,7 @@ struct fs_context {
 	bool			global:1;	/* Goes into &init_user_ns */
 	bool			oldapi:1;	/* Coming from mount(2) */
 	bool			exclusive:1;    /* create new superblock, reject existing one */
+	bool			rootns_bound:1;	/* Bound via FSCONFIG_SET_ROOTNS */
 };
 
 struct fs_context_operations {
@@ -117,6 +122,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	int (*set_rootns)(struct fs_context *fc, struct rootns *rootns);
 	int (*get_tree)(struct fs_context *fc);
 	int (*reconfigure)(struct fs_context *fc);
 };
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index cb4f7175db02..5d4d93edb9df 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -107,6 +107,7 @@ enum fsconfig_command {
 	FSCONFIG_CMD_CREATE	= 6,	/* Create new or reuse existing superblock */
 	FSCONFIG_CMD_RECONFIGURE = 7,	/* Invoke superblock reconfiguration */
 	FSCONFIG_CMD_CREATE_EXCL = 8,	/* Create new superblock, fail if reusing existing superblock */
+	FSCONFIG_SET_ROOTNS	= 9,	/* Set a rootns, supplied by fd */
 };
 
 /*
-- 
2.47.3

