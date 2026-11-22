Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310369;
	b=f2BJjpGyblJoY4+Ysc3gHsewUQ0PmomQJOAZY39X9zOpXmZGiZ3n5JYzLdULaaFjkFAX
	 b1WhV3P4uf8J2d6z9ByFO6l4CyPv/NI2T7zL59sNv87CDkmv/+JiRW2UZD7OsLM6I5t9Q
	 hK5ZCdD3Y4AdrWKgFL3zY7xbucJWtLiGBRJFTEcHbq/cPvfyXS2bMCEky2DxWjZTc8xvc
	 vfF3x1cbUzGL5DdpwZdte2V1/Vaot4uxZLzFZBUYGYXEfssbOYm8jujRPn1FfYaA9vlxP
	 BtMO9FVEVqVsu70B/AjvWF33QEImc0DUoAi/cXOQbiqr4oSeihVBbjL+Q0QMyxbU8FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4z6np56kVnxQStxCBC8c9V6+2oN0lA53EHavFF4XX6A=;
	b=NEuI3iZcemXf5ci2sDDhWGHcBOoZqNqcuGp23wZppKhJn9PlxvAyn8eqdbXeq31mVk88
	 GLYKnMw4QNkJIY1xlyjWBceCNALfcylKCAAxD9GnjY0DHqV33OPn4BU+Zje0hegREpIJI
	 4XooPaE9/lBtxmQ44Wl6K++UkSyis/VJgeterdJ53tiB+fGLlVw1ylo8lUy2tUN7kagGs
	 M8yGd0XKd5nm19d67Xl+GVgUI0XjWmnhVqffye28bvYjTOx/QoFmxvo47N3eK9onR/iax
	 cCXk8GezryPBPs/VshncEWbtOg3fhq1DKyZPqLog6xcFtxdiolpjhPy9vapseuMRkpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edaT4Eo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9F127606A6BB;
	Sun, 22 Nov 2026 01:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edaT4Eo7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 81F9B1F000C4;
	Sun, 22 Nov 2026 01:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310369;
	bh=4z6np56kVnxQStxCBC8c9V6+2oN0lA53EHavFF4XX6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edaT4Eo7bTlBid4TqDyb8QBMZemgGiHL5dha+9yUx8CwWRdkqnHjFUcjFv24oA9vh
	 34wczfj3Y7C4WCD4QPx1XywjGD+c00oBYJ/5ss8GfjW4ePWgAQlvmrtAeWHKx8vHQF
	 DocuEgnlwmDmdbSg1ZJcnc9ieVh1L8nQfz94FZxXOYdJZAO2GuGz/+7c4Ez3UOdyXw
	 +h3wLOndVhuETUn7IiKFAj3LjX91y9kVhIXwE6f5o7q0T6CwhcvdjFS+h7xh9bwdsa
	 F4cJ2VeOFepsTSRM/XVbuLNr9sdvdtx5jZT6sEl3yUcRGtf9Nr/OpcAw8NWlVcGuI1
	 I14fUqvpMbSng==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 18/26] fs: Support FSCONFIG_SET_USERLAND in fsconfig()
Date: Sun, 22 Nov 2026 03:18:01 +0200
Message-ID: <20261122011809.2667684-19-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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
creating superblocks and detached mounts for an unentered userland.

Add FSCONFIG_SET_USERLAND and the ->set_userland() fs_context operation
so callers holding CAP_SYS_ADMIN in the target userland's user namespace
can bind a newly opened fs_context to that userland once before offering
parameters. Gate userland context binding on explicit FS_USERLAND_MOUNT
opt-in (or FS_USERNS_DELEGATABLE), mark tmpfs, ramfs, and devpts with
FS_USERLAND_MOUNT, refresh fc->cred when FSCONFIG_SET_USERLAND
authorizes and initializes the context, and keep devpts pty_reserve
restricted to host mounts.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/devpts/inode.c          |   4 +-
 fs/filesystems.c           |  15 ++++
 fs/fs_context.c            |  21 ++++--
 fs/fsopen.c                | 137 ++++++++++++++++++++++++++++++++++---
 fs/internal.h              |   6 ++
 fs/namespace.c             |  19 ++++-
 fs/ramfs/inode.c           |   2 +-
 include/linux/fs.h         |   1 +
 include/linux/fs_context.h |   6 ++
 include/uapi/linux/mount.h |   1 +
 mm/shmem.c                 |   5 +-
 11 files changed, 199 insertions(+), 18 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb..921b67d18fa2 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -434,6 +434,8 @@ static int devpts_init_fs_context(struct fs_context *fc)
 	fsi->mount_opts.max     = NR_UNIX98_PTY_MAX;
 
 	if (fc->purpose == FS_CONTEXT_FOR_MOUNT &&
+	    !fc->userland_bound &&
+	    fc->user_ns == &init_user_ns &&
 	    current->nsproxy->mnt_ns == init_task.nsproxy->mnt_ns)
 		fsi->mount_opts.reserve = true;
 
@@ -457,7 +459,7 @@ static struct file_system_type devpts_fs_type = {
 	.init_fs_context = devpts_init_fs_context,
 	.parameters	= devpts_param_specs,
 	.kill_sb	= devpts_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
 };
 
 /*
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
index 70024870fefa..33cc9163c670 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -13,9 +13,14 @@
 #include <linux/security.h>
 #include <linux/anon_inodes.h>
 #include <linux/namei.h>
+#include <linux/capability.h>
+#include <linux/nsproxy.h>
+#include <linux/userland.h>
+#include <linux/user_namespace.h>
 #include <linux/file.h>
 #include <uapi/linux/mount.h>
 #include <linux/audit.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -41,6 +46,92 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
 	return p;
 }
 
+/**
+ * DOC: FSCONFIG_SET_USERLAND
+ *
+ * ``fsconfig(fsfd, FSCONFIG_SET_USERLAND, NULL, NULL, userland_fd)`` binds a newly
+ * opened ``FS_USERLAND_MOUNT`` or ``FS_USERNS_DELEGATABLE`` filesystem context
+ * to ``userland_fd`` once before parameters are supplied. Requires
+ * ``CAP_SYS_ADMIN`` in the userland's user namespace and binds the context to the
+ * userland's user, network, PID (``proc``), and IPC (``mqueue``) namespaces.
+ */
+static int fsconfig_set_userland(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct user_namespace *user_ns;
+	struct net *net;
+	struct userland *c;
+	int ret;
+
+	if (!userland_is_file(param->file))
+		return -EINVAL;
+
+	c = param->file->private_data;
+	user_ns = c->user_ns;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (!(fc->fs_type->fs_flags &
+	      (FS_USERLAND_MOUNT | FS_USERNS_DELEGATABLE)))
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
+	scoped_guard(spinlock, &c->lock)
+		net = get_net(c->ns->net_ns);
+	put_cred(fc->cred);
+	fc->cred = get_current_cred();
+	put_net(fc->net_ns);
+	fc->net_ns = net;
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(user_ns);
+
+	fc->userland_bound = true;
+	fc->userland_mnt_id = c->ns->mnt_ns->ns.ns_id;
+
+	ret = fc->fs_type->init_fs_context(fc);
+	if (ret < 0) {
+		fc->userland_bound = false;
+		fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+	}
+	fc->need_free = true;
+
+	if (fc->ops->set_userland) {
+		ret = fc->ops->set_userland(fc, c);
+		if (ret < 0) {
+			fc->userland_bound = false;
+			fc->phase = FS_CONTEXT_FAILED;
+			return ret;
+		}
+	}
+	if (fc->user_ns != user_ns) {
+		fc->userland_bound = false;
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
@@ -123,9 +214,11 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	struct file_system_type *fs_type;
 	struct fs_context *fc;
 	const char *fs_name;
+	bool priv;
 	int ret;
 
-	if (!may_mount())
+	priv = may_mount();
+	if (!priv && !IS_ENABLED(CONFIG_USERLAND))
 		return -EPERM;
 
 	if (flags & ~FSOPEN_CLOEXEC)
@@ -137,17 +230,23 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 
 	audit_log_fsopen(fs_name);
 
-	fs_type = get_fs_type(fs_name);
+	fs_type = priv ? get_fs_type(fs_name) : get_fs_type_noload(fs_name);
 	kfree(fs_name);
 	if (!fs_type)
-		return -ENODEV;
+		return priv ? -ENODEV : -EPERM;
+
+	if (!priv && !(fs_type->fs_flags & FS_USERLAND_MOUNT)) {
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
@@ -222,7 +321,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -291,6 +391,8 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 	ret = finish_clean_context(fc);
 	if (ret)
 		return ret;
+	if (fc->phase == FS_CONTEXT_AWAITING_NS && cmd != FSCONFIG_SET_USERLAND)
+		return -EPERM;
 	switch (cmd) {
 	case FSCONFIG_CMD_CREATE:
 		return vfs_cmd_create(fc, false);
@@ -298,9 +400,17 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 		return vfs_cmd_create(fc, true);
 	case FSCONFIG_CMD_RECONFIGURE:
 		return vfs_cmd_reconfigure(fc);
+	case FSCONFIG_SET_USERLAND:
+		if (fc->phase != FS_CONTEXT_AWAITING_NS &&
+		    fc->phase != FS_CONTEXT_CREATE_NS)
+			return -EBUSY;
+		return fsconfig_set_userland(fc, param);
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
@@ -390,6 +500,10 @@ SYSCALL_DEFINE5(fsconfig,
 		if (!_key || _value || aux < 0)
 			return -EINVAL;
 		break;
+	case FSCONFIG_SET_USERLAND:
+		if (_key || _value || aux < 0)
+			return -EINVAL;
+		break;
 	case FSCONFIG_CMD_CREATE:
 	case FSCONFIG_CMD_CREATE_EXCL:
 	case FSCONFIG_CMD_RECONFIGURE:
@@ -457,6 +571,12 @@ SYSCALL_DEFINE5(fsconfig,
 			goto out_key;
 		param.dirfd = aux;
 		break;
+	case FSCONFIG_SET_USERLAND:
+		ret = -EBADF;
+		param.file = fget(aux);
+		if (!param.file)
+			goto out_key;
+		break;
 	default:
 		break;
 	}
@@ -482,6 +602,7 @@ SYSCALL_DEFINE5(fsconfig,
 			putname(param.name);
 		break;
 	case FSCONFIG_SET_FD:
+	case FSCONFIG_SET_USERLAND:
 		if (param.file)
 			fput(param.file);
 		break;
diff --git a/fs/internal.h b/fs/internal.h
index ee3f796241ac..c7b57263ac83 100644
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
index 57b4e8755fe9..9c4ac2df172d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4705,16 +4705,19 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
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
+	if (!(flags & FSMOUNT_NAMESPACE) && !IS_ENABLED(CONFIG_USERLAND) &&
+	    !priv)
 		return -EPERM;
 
 	if (attr_flags & ~FSMOUNT_VALID_FLAGS)
@@ -4749,6 +4752,15 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	if (ret)
 		return ret;
 
+	if (fc->userland_bound) {
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
@@ -4790,9 +4802,12 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(fc->userland_bound ? fc->user_ns :
+			  current->nsproxy->mnt_ns->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
+	if (fc->userland_bound)
+		ns->seq_origin = fc->userland_mnt_id;
 	mnt = real_mount(new_path.mnt);
 	ns->root = mnt;
 	ns->nr_mounts = 1;
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index ef91b933d4e6..d15542145704 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -319,7 +319,7 @@ static struct file_system_type ramfs_fs_type = {
 	.init_fs_context = ramfs_init_fs_context,
 	.parameters	= ramfs_fs_parameters,
 	.kill_sb	= ramfs_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
 };
 
 static int __init init_ramfs_fs(void)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5b3a100aba77..afb514600372 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2306,6 +2306,7 @@ struct file_system_type {
 #define FS_USERNS_MOUNT_RESTRICTED 512	/* Restrict mount in userns if not already visible */
 #define FS_USERNS_DELEGATABLE	1024	/* Can be mounted inside userns from outside */
 #define FS_DISALLOW_NOTIFY	2048	/* No fsnotify marks on its objects */
+#define FS_USERLAND_MOUNT	4096	/* Supports FSCONFIG_SET_USERLAND */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	int (*init_fs_context)(struct fs_context *);
 	const struct fs_parameter_spec *parameters;
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..a98e5a40d54c 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -23,6 +23,7 @@ struct net;
 struct pid_namespace;
 struct super_block;
 struct user_namespace;
+struct userland;
 struct vfsmount;
 struct path;
 
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
+	u64			userland_mnt_id;	/* Target userland mnt_ns ID */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		s_iflags;	/* OR'd with sb->s_iflags */
@@ -110,6 +114,7 @@ struct fs_context {
 	bool			global:1;	/* Goes into &init_user_ns */
 	bool			oldapi:1;	/* Coming from mount(2) */
 	bool			exclusive:1;    /* create new superblock, reject existing one */
+	bool			userland_bound:1;	/* Bound via FSCONFIG_SET_USERLAND */
 };
 
 struct fs_context_operations {
@@ -117,6 +122,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	int (*set_userland)(struct fs_context *fc, struct userland *userland);
 	int (*get_tree)(struct fs_context *fc);
 	int (*reconfigure)(struct fs_context *fc);
 };
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index cb4f7175db02..4c70c0183f5e 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -107,6 +107,7 @@ enum fsconfig_command {
 	FSCONFIG_CMD_CREATE	= 6,	/* Create new or reuse existing superblock */
 	FSCONFIG_CMD_RECONFIGURE = 7,	/* Invoke superblock reconfiguration */
 	FSCONFIG_CMD_CREATE_EXCL = 8,	/* Create new superblock, fail if reusing existing superblock */
+	FSCONFIG_SET_USERLAND	= 9,	/* Set target userland, supplied by fd */
 };
 
 /*
diff --git a/mm/shmem.c b/mm/shmem.c
index 10cef89b00b0..61503304be6b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5592,7 +5592,8 @@ static struct file_system_type shmem_fs_type = {
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERLAND_MOUNT |
+			  FS_ALLOW_IDMAP | FS_MGTIME,
 };
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_TMPFS)
@@ -6021,7 +6022,7 @@ static struct file_system_type shmem_fs_type = {
 	.init_fs_context = ramfs_init_fs_context,
 	.parameters	= ramfs_fs_parameters,
 	.kill_sb	= ramfs_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
 };
 
 void __init shmem_init(void)
-- 
2.47.3

