Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030580;
	b=AMoihwQ1AzZkwJWFh5VLJCqHeN8dJ+IR5dSEjj8sngaC/7YnTdtu5YpPlbl3rqJm0fzb
	 69mIfWDuoXnm0qU2IIvutKYVnIZSqYWffdXHX/hRT9htTpqBIFtCJ9Lxd9vToajhCAoB1
	 +XXoK2ubkRE4Cx+ngaogYr8Wx0hE39wgeTmZf49TZlAPb+eGpu590tmBja/sSgpkDHTPk
	 aIn6l1X5R8KfHfzGiyO92yJRzYHZeETxzF2V4cGYwECkg21PxRp0SQDT5fHZI6IDe6vyq
	 IjuREuUWTkSw05OTO1VrSfOHFs9jkrwmpW5Gv1qix+NgNWZIcpVwvJdAYW+ADXSlSDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=I/A+481x9vZu/lMn8hynTSVG91BJFcq5LkeFsMqpR4U=;
	b=yFSGoThSPu2zIbLGj+Sf/hTJYUyZiNPVtJWUKLRrpKOr0olSOnDoD+2g1zFg5WHxsSyS
	 9EgvtMq5NdI5uDu2g3Xc7YhpcRqwTCMi6Z44W/hQ+ZDlglXPos1zPfgR7dL+TGgM//SPs
	 zknL+uVH2n3e22io8+uLvp4qtdulgDvY6Jh2NkrEkmazGry+IeoDnOmwff/npewJAWOH1
	 XXDEucY/+1kIkyfETGxz5e13rOeqk8Wo5lH8Mt/9sTBnUl/P9YWiGa9ppwyLq5Px8wV78
	 fN2ktn+VwNdjXhk5jqs9TzsJFGeD2Qjsx0yVj996fjfPHO3nxrc42D8723D7bLqZ0gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9jwh43Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B226060A260D;
	Wed, 18 Nov 2026 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9jwh43Z
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CF2611F000C6;
	Wed, 18 Nov 2026 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030580;
	bh=I/A+481x9vZu/lMn8hynTSVG91BJFcq5LkeFsMqpR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9jwh43ZEPMVLJF/+R1eJOd1Ng95ZgNb/L+/efVkOtd9jznAghfX9ts4yhzFU1sQO
	 nPT9oe1jhArqrxJ5D0q9d5NLz4+hi29QBBcl86MKQCpmjRjhPw1d+oMV+l6sgWX0zn
	 9X65ErCl1lg23W2HLJ5SNblfGBjxOMxuRakPIMilqjjLtrkJUrIAXy/A0msEQl7hJ2
	 oRSJ8t8MGxc8W0tDzjfWsPW6WNwTnrs9BL3IzN2vLnOSrpy1IeOsoQgE/dLqWnuUIA
	 hCwPQmwqmeHqK+p+aw4pHYzoGcgNpsVgz0NW/QZBUjTPsRll+4sXvoRYlju3V8rGlz
	 bzjnqc7GB80bg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 08/13] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Wed, 18 Nov 2026 21:35:34 +0200
Message-ID: <20261118193539.240065-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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
mount namespace and initialize filesystem contexts from current's user,
network, PID, and IPC namespaces, preventing an unprivileged external
manager from creating superblocks and detached mounts for an unentered
root namespace.

Add FSCONFIG_SET_ROOTNS so callers holding CAP_SYS_ADMIN in the target
rootns user namespace can bind a newly opened fs_context to that rootns
once before offering parameters. Allow unprivileged callers to open
FS_USERNS_MOUNT contexts in FS_CONTEXT_AWAITING_NS without module
autoloading until FSCONFIG_SET_ROOTNS authorizes and initializes the
context, allocate fsmount()'s anonymous mount namespace in fc->user_ns,
enforce mount_too_revealing() for unprivileged callers in init_mnt_ns,
and wire ->set_rootns() for proc and mqueue.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/filesystems.c           |  15 +++++
 fs/fs_context.c            |  20 ++++--
 fs/fsopen.c                | 121 ++++++++++++++++++++++++++++++++++---
 fs/internal.h              |   6 ++
 fs/namespace.c             |  35 +++++++++--
 fs/proc/root.c             |  18 ++++++
 include/linux/fs_context.h |   5 ++
 include/uapi/linux/mount.h |   1 +
 ipc/mqueue.c               |  13 ++++
 9 files changed, 216 insertions(+), 18 deletions(-)

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
index a50584df97be..542dede2f864 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -259,7 +259,8 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 				      struct dentry *reference,
 				      unsigned int sb_flags,
 				      unsigned int sb_flags_mask,
-				      enum fs_context_purpose purpose)
+				      enum fs_context_purpose purpose,
+				      bool init)
 {
 	struct fs_context *fc;
 	int ret = -ENOMEM;
@@ -292,6 +293,9 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 		break;
 	}
 
+	if (!init)
+		return fc;
+
 	ret = fc->fs_type->init_fs_context(fc);
 	if (ret < 0)
 		goto err_fc;
@@ -307,10 +311,16 @@ struct fs_context *fs_context_for_mount(struct file_system_type *fs_type,
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
@@ -320,7 +330,8 @@ struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 		return ERR_PTR(-EINVAL);
 
 	return alloc_fs_context(dentry->d_sb->s_type, dentry, sb_flags,
-				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE);
+				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE,
+				true);
 }
 
 /**
@@ -337,7 +348,8 @@ struct fs_context *fs_context_for_submount(struct file_system_type *type,
 	struct fs_context *fc;
 	int ret;
 
-	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT);
+	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT,
+			      true);
 	if (IS_ERR(fc))
 		return fc;
 
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..3e36270baadb 100644
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
 
@@ -41,6 +46,76 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
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
+ * The context is initialized against the ``rootns`` network namespace,
+ * ``fc->user_ns`` is delegated to the ``rootns`` user namespace for
+ * ``FS_USERNS_MOUNT`` and ``FS_USERNS_DELEGATABLE`` filesystems when the
+ * mounter ``fsuid``/``fsgid`` map into it or the caller lacks
+ * ``CAP_SYS_ADMIN`` in its own user namespace, and ``proc`` and ``mqueue``
+ * contexts bind to the target ``rootns`` PID and IPC namespaces.
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
+	put_net(fc->net_ns);
+	fc->net_ns = get_net(c->ns->net_ns);
+	put_user_ns(fc->user_ns);
+	if ((fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE)) &&
+	    ((kuid_has_mapping(user_ns, fc->cred->fsuid) &&
+	      kgid_has_mapping(user_ns, fc->cred->fsgid)) ||
+	     !ns_capable(fc->cred->user_ns, CAP_SYS_ADMIN)))
+		fc->user_ns = get_user_ns(user_ns);
+	else
+		fc->user_ns = get_user_ns(fc->cred->user_ns);
+
+	ret = fc->fs_type->init_fs_context(fc);
+	if (ret < 0) {
+		fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+	}
+	fc->need_free = true;
+
+	if (fc->ops->set_rootns) {
+		ret = fc->ops->set_rootns(fc, c);
+		if (ret < 0)
+			return ret;
+	}
+	fc->rootns_bound = true;
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return 0;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
  * Only one message is returned for each read(2) call.
@@ -123,9 +198,11 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
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
@@ -137,17 +214,23 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 
 	audit_log_fsopen(fs_name);
 
-	fs_type = get_fs_type(fs_name);
+	fs_type = priv ? get_fs_type(fs_name) : get_fs_type_noload(fs_name);
 	kfree(fs_name);
 	if (!fs_type)
-		return -ENODEV;
+		return priv ? -ENODEV : -EPERM;
 
-	fc = fs_context_for_mount(fs_type, 0);
+	if (!priv && !(fs_type->fs_flags & FS_USERNS_MOUNT)) {
+		put_filesystem(fs_type);
+		return -EPERM;
+	}
+
+	fc = priv ? fs_context_for_mount(fs_type, 0) :
+		    fs_context_for_unpriv_mount(fs_type);
 	put_filesystem(fs_type);
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = priv ? FS_CONTEXT_CREATE_NS : FS_CONTEXT_AWAITING_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +305,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -291,6 +375,8 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 	ret = finish_clean_context(fc);
 	if (ret)
 		return ret;
+	if (fc->phase == FS_CONTEXT_AWAITING_NS && cmd != FSCONFIG_SET_ROOTNS)
+		return -EPERM;
 	switch (cmd) {
 	case FSCONFIG_CMD_CREATE:
 		return vfs_cmd_create(fc, false);
@@ -298,9 +384,17 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
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
@@ -390,6 +484,10 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -457,6 +555,12 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -482,6 +586,7 @@ SYSCALL_DEFINE5(fsconfig,
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
index 781380945d78..a6c0a31e275a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4623,7 +4623,8 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!(flags & FSMOUNT_NAMESPACE) && !may_mount())
+	if (!(flags & FSMOUNT_NAMESPACE) && !IS_ENABLED(CONFIG_ROOTNS) &&
+	    !may_mount())
 		return -EPERM;
 
 	if (attr_flags & ~FSMOUNT_VALID_FLAGS)
@@ -4658,6 +4659,16 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	if (ret)
 		return ret;
 
+	if (!(flags & FSMOUNT_NAMESPACE)) {
+		if (fc->rootns_bound) {
+			if (!ns_capable(fc->user_ns, CAP_SYS_ADMIN) &&
+			    !may_mount())
+				return -EPERM;
+		} else if (!may_mount()) {
+			return -EPERM;
+		}
+	}
+
 	/* There must be a valid superblock or we can't mount it */
 	ret = -EINVAL;
 	if (!fc->root)
@@ -4699,7 +4710,8 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(fc->rootns_bound ? fc->user_ns :
+			  current->nsproxy->mnt_ns->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
 	mnt = real_mount(new_path.mnt);
@@ -6582,6 +6594,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
 				int *new_mnt_flags)
 {
+	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
 
@@ -6611,6 +6624,11 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		/* Don't miss readonly hidden in the superblock flags */
 		if (sb_rdonly(mnt->mnt.mnt_sb))
 			mnt_flags |= MNT_LOCK_READONLY;
+		if (foreign_ns) {
+			if (mnt_flags & MNT_READONLY)
+				mnt_flags |= MNT_LOCK_READONLY;
+			mnt_flags |= MNT_LOCK_ATIME;
+		}
 
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
@@ -6629,7 +6647,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(child->mnt.mnt_flags & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6650,13 +6668,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
 
-	if (ns->user_ns == &init_user_ns)
-		return false;
-
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	if (ns->user_ns == &init_user_ns &&
+	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+		return false;
+
+	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
+	    current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..323296b03089 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -323,6 +325,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = rootns->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +351,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..b1adcd6ed693 100644
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
@@ -110,6 +113,7 @@ struct fs_context {
 	bool			global:1;	/* Goes into &init_user_ns */
 	bool			oldapi:1;	/* Coming from mount(2) */
 	bool			exclusive:1;    /* create new superblock, reject existing one */
+	bool			rootns_bound:1;	/* Bound via FSCONFIG_SET_ROOTNS */
 };
 
 struct fs_context_operations {
@@ -117,6 +121,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	int (*set_rootns)(struct fs_context *fc, struct rootns *rootns);
 	int (*get_tree)(struct fs_context *fc);
 	int (*reconfigure)(struct fs_context *fc);
 };
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index ac865edac517..cb55cfcfc92e 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -105,6 +105,7 @@ enum fsconfig_command {
 	FSCONFIG_CMD_CREATE	= 6,	/* Create new or reuse existing superblock */
 	FSCONFIG_CMD_RECONFIGURE = 7,	/* Invoke superblock reconfiguration */
 	FSCONFIG_CMD_CREATE_EXCL = 8,	/* Create new superblock, fail if reusing existing superblock */
+	FSCONFIG_SET_ROOTNS	= 9,	/* Set a rootns, supplied by fd */
 };
 
 /*
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..f94e9b566bd0 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/rootns.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,17 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1625,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3

