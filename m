Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E742F719;
	Thu, 16 Jul 2026 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212485; cv=pass; b=C0OWpGVvwutjgBJ8QDvYFjUL5DBPWTmu4C8b9hxg3WW41b0s1TIFx/5LPdsjha43KkGzjZ4rwNlsSmdu5U0pp8ihibph3pdUunvRFeAUNJRFYBKLC01Zmq8O5+gADOaIZAdHSsm5Qom2RXa+fRwnyyVK0lGyKUexBwBNJKcgb3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212485; c=relaxed/simple;
	bh=rO7/2N6RikbahMLaBQcWuDrun5vMvTRa6Wm/crEWo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWt9sRgHh4SYqeuCPyEsJ9wMwNJEBxUQU0CZbWe1l1WTRHG9d9wULI8QjCnHlg76au0hBd98DW5/8r7s+pXLjh7aYcRLvg6vcqbrIbnk1aAnoZbNflfxYGtjXJjhtiHUIiIfj/eNNsYD1l6yA3mzBAIR18Vpv0iqZqP2trys/7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=L5/Ksxx2; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="L5/Ksxx2"
ARC-Seal: i=1; a=rsa-sha256; t=1784212366; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=LSCm0FXS6pTpDd80pgcCSlZZ9DRgtAQVdDw0tUlMTjQx796FrRBHIAGMYI/QNUQBitRAcSzamsTr4qhGgF8hMiIAfWnxyjqVT/zJg/os3Ganr9+Z1NZBqoVst6KrYjCGiwTKSBANWJEnbgd5Ofk5V1CWInqQt2u1LSFeCyOS3Dw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212366; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=R+66Hk3P5OQ2E30mtMifPx8I419shGND6XXMWm0+TK0=; 
	b=B6Bf2BDrgJ81BLAAxDodmQuRr44cTF5rZ7qZvpomg2yTeNltYLefCOtnNwUkXnGBLaS3mUrv3hju2/W9Vl9DFbmSlO7fE2iqjEONYlt9TUUe6Ij777QrlQJLgnEZ8IL0oTfAr0PujUwvEZC8XgSsWJDAs0fIZd24O32D0MDzz+E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212366;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=R+66Hk3P5OQ2E30mtMifPx8I419shGND6XXMWm0+TK0=;
	b=L5/Ksxx2qsSfR7lIJwR0Ln28svMHuFZSetawrEI3uJtZ0JsvWJKMcM0foWfQeOeA
	JuBKMJ68jKLjI+L7hIiF9jE82PdVWHCu9XRvPNusdoJBYXpUYh7w9GnlDc/h6mR18VU
	9IHWRT9rvlEH5nT9AtCnsD0AyUFxQR6z13TYvsuQ=
Received: by mx.zohomail.com with SMTPS id 1784212363492855.4721543764033;
	Thu, 16 Jul 2026 07:32:43 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 03/24] pidfs: add taskless future pidfd inodes
Date: Thu, 16 Jul 2026 22:31:29 +0800
Message-ID: <249610d94eb7bba17d625a84786a6b12c517f559.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Teach pidfs inodes to represent either a struct pid or a typed future
object. Use the ordinary pidfs file operations for both kinds and
resolve a future object through its callback.

Allocate a stable inode identity without allocating a task or struct
pid. Ordinary pidfd operations return -ESRCH until the future producer
publishes a process, while inode-only GETVERSION remains available.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfs.c            | 254 ++++++++++++++++++++++++++++++++++++++----
 include/linux/pid.h   |  10 ++
 include/linux/pidfs.h |  21 ++++
 3 files changed, 262 insertions(+), 23 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index c55f46c32801d..ebd8cc463811b 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -25,6 +25,7 @@
 #include <net/net_namespace.h>
 #include <linux/coredump.h>
 #include <linux/rhashtable.h>
+#include <linux/security.h>
 #include <linux/llist.h>
 #include <linux/xattr.h>
 #include <linux/cookie.h>
@@ -35,6 +36,8 @@
 #define PIDFS_PID_DEAD ERR_PTR(-ESRCH)
 
 static struct kmem_cache *pidfs_attr_cachep __ro_after_init;
+static const struct file_operations pidfs_file_operations;
+static struct vfsmount *pidfs_mnt __ro_after_init;
 
 static struct path pidfs_root_path = {};
 
@@ -106,6 +109,64 @@ struct pidfs_attr {
 	};
 };
 
+struct pidfs_future_file {
+	struct pidfs_node node;
+	void *data;
+	const struct pidfs_future_file_ops *ops;
+	struct pidfs_attr *attr;
+	u64 ino;
+};
+
+static struct pidfs_node *pidfs_inode_node(const struct inode *inode)
+{
+	if (!pidfs_mnt || inode->i_sb != pidfs_mnt->mnt_sb ||
+	    inode->i_fop != &pidfs_file_operations)
+		return NULL;
+	return inode->i_private;
+}
+
+static struct pidfs_future_file *
+pidfs_future_file(const struct inode *inode)
+{
+	struct pidfs_node *node = pidfs_inode_node(inode);
+
+	if (!node || node->type != PIDFS_NODE_FUTURE)
+		return NULL;
+	return container_of(node, struct pidfs_future_file, node);
+}
+
+void *pidfs_future_file_data(const struct file *file,
+			     const struct pidfs_future_file_ops *ops)
+{
+	struct pidfs_future_file *future;
+
+	if (file->f_op != &pidfs_file_operations)
+		return NULL;
+	future = pidfs_future_file(file_inode(file));
+	return future && future->ops == ops ? future->data : NULL;
+}
+
+static struct pid *pidfs_inode_pid(const struct inode *inode)
+{
+	struct pidfs_future_file *future;
+	struct pidfs_node *node;
+	struct pid *pid;
+
+	node = pidfs_inode_node(inode);
+	if (!node)
+		return ERR_PTR(-EBADF);
+	if (node->type == PIDFS_NODE_PID)
+		return container_of(node, struct pid, pidfs_node);
+
+	future = pidfs_future_file(inode);
+	if (!future || !future->ops || !future->ops->get_pid)
+		return ERR_PTR(-EBADF);
+	pid = future->ops->get_pid(future->data);
+	if (WARN_ON_ONCE(!pid))
+		return ERR_PTR(-EBADF);
+	return pid;
+}
+
 #if BITS_PER_LONG == 32
 
 DEFINE_SPINLOCK(pidfs_ino_lock);
@@ -166,6 +227,7 @@ static u64 pidfs_alloc_ino(void)
 
 void pidfs_prepare_pid(struct pid *pid)
 {
+	pid->pidfs_node.type = PIDFS_NODE_PID;
 	pid->stashed = NULL;
 	pid->attr = NULL;
 	pid->ino = 0;
@@ -275,7 +337,7 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
 	struct pid_namespace *ns;
 	pid_t nr = -1;
 
-	if (likely(pid_has_task(pid, PIDTYPE_PID))) {
+	if (!IS_ERR(pid) && likely(pid_has_task(pid, PIDTYPE_PID))) {
 		ns = proc_pid_ns(file_inode(m->file)->i_sb);
 		nr = pid_nr_ns(pid, ns);
 	}
@@ -305,11 +367,15 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
  */
 static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 {
-	struct pid *pid = pidfd_pid(file);
 	struct task_struct *task;
 	__poll_t poll_flags = 0;
+	struct pid *pid = pidfd_pid(file);
+
+	if (IS_ERR(pid))
+		return PTR_ERR(pid) == -ESRCH ? 0 : EPOLLHUP;
 
 	poll_wait(file, &pid->wait_pidfd, pts);
+
 	/*
 	 * Don't wake waiters if the thread-group leader exited
 	 * prematurely. They either get notified when the last subthread
@@ -376,6 +442,8 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 
 	BUILD_BUG_ON(sizeof(struct pidfd_info) != PIDFD_INFO_SIZE_VER3);
 
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
 	if (!uinfo)
 		return -EINVAL;
 	if (usize < PIDFD_INFO_SIZE_VER0)
@@ -532,6 +600,7 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct task_struct *task __free(put_task) = NULL;
 	struct nsproxy *nsp __free(put_nsproxy) = NULL;
 	struct ns_common *ns_common = NULL;
+	struct pid *pid;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -544,11 +613,15 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return put_user(file_inode(file)->i_generation, argp);
 	}
 
+	pid = pidfd_pid(file);
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
+
 	/* Extensible IOCTL that does not open namespace FDs, take a shortcut */
 	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
 		return pidfd_info(file, cmd, arg);
 
-	task = get_pid_task(pidfd_pid(file), PIDTYPE_PID);
+	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
 		return -ESRCH;
 
@@ -673,11 +746,14 @@ static long pidfd_compat_ioctl(struct file *file, unsigned int cmd,
 
 static int pidfs_file_release(struct inode *inode, struct file *file)
 {
-	struct pid *pid = inode->i_private;
+	struct pid *pid;
 	struct task_struct *task;
 
 	if (!(file->f_flags & PIDFD_AUTOKILL))
 		return 0;
+	pid = pidfd_pid(file);
+	if (IS_ERR(pid))
+		return 0;
 
 	guard(rcu)();
 	task = pid_task(pid, PIDTYPE_TGID);
@@ -705,9 +781,9 @@ static const struct file_operations pidfs_file_operations = {
 
 struct pid *pidfd_pid(const struct file *file)
 {
-	if (file->f_op != &pidfs_file_operations)
+	if (unlikely(file->f_op != &pidfs_file_operations))
 		return ERR_PTR(-EBADF);
-	return file_inode(file)->i_private;
+	return pidfs_inode_pid(file_inode(file));
 }
 
 /*
@@ -797,8 +873,6 @@ void pidfs_coredump(const struct coredump_params *cprm)
 }
 #endif
 
-static struct vfsmount *pidfs_mnt __ro_after_init;
-
 /*
  * The vfs falls back to simple_setattr() if i_op->setattr() isn't
  * implemented. Let's reject it completely until we have a clean
@@ -820,7 +894,10 @@ static int pidfs_getattr(struct mnt_idmap *idmap, const struct path *path,
 static ssize_t pidfs_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
 	struct inode *inode = d_inode(dentry);
-	struct pid *pid = inode->i_private;
+	struct pid *pid = pidfs_inode_pid(inode);
+
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
 
 	return simple_xattr_list(inode, &pid->attr->xattrs, buf, size);
 }
@@ -833,10 +910,25 @@ static const struct inode_operations pidfs_inode_operations = {
 
 static void pidfs_evict_inode(struct inode *inode)
 {
-	struct pid *pid = inode->i_private;
+	struct pidfs_future_file *future;
+	struct pidfs_node *node = pidfs_inode_node(inode);
 
 	clear_inode(inode);
-	put_pid(pid);
+	if (!node)
+		return;
+	if (node->type == PIDFS_NODE_PID) {
+		put_pid(container_of(node, struct pid, pidfs_node));
+		return;
+	}
+	if (WARN_ON_ONCE(node->type != PIDFS_NODE_FUTURE))
+		return;
+
+	future = container_of(node, struct pidfs_future_file, node);
+	if (future->ops->release)
+		future->ops->release(future->data);
+	if (future->attr)
+		kmem_cache_free(pidfs_attr_cachep, future->attr);
+	kfree(future);
 }
 
 static const struct super_operations pidfs_sops = {
@@ -854,15 +946,24 @@ static char *pidfs_dname(struct dentry *dentry, char *buffer, int buflen)
 	return dynamic_dname(buffer, buflen, "anon_inode:[pidfd]");
 }
 
+static void pidfs_dentry_prune(struct dentry *dentry)
+{
+	if (dentry->d_fsdata)
+		stashed_dentry_prune(dentry);
+}
+
 const struct dentry_operations pidfs_dentry_operations = {
 	.d_dname	= pidfs_dname,
-	.d_prune	= stashed_dentry_prune,
+	.d_prune	= pidfs_dentry_prune,
 };
 
 static int pidfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 			   struct inode *parent)
 {
-	const struct pid *pid = inode->i_private;
+	const struct pid *pid = pidfs_inode_pid(inode);
+
+	if (IS_ERR(pid))
+		return FILEID_INVALID;
 
 	if (*max_len < 2) {
 		*max_len = 2;
@@ -974,22 +1075,36 @@ static const struct export_operations pidfs_export_operations = {
 	.permission	= pidfs_export_permission,
 };
 
-static int pidfs_init_inode(struct inode *inode, void *data)
+static void pidfs_init_common_inode(struct inode *inode,
+				    struct pidfs_node *node, u64 ino)
 {
-	const struct pid *pid = data;
-
-	inode->i_private = data;
+	inode->i_private = node;
 	inode->i_flags |= S_PRIVATE | S_ANON_INODE;
 	/* We allow to set xattrs. */
 	inode->i_flags &= ~S_IMMUTABLE;
-	inode->i_mode |= S_IRWXU;
+	inode->i_mode = S_IFREG | 0700;
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
 	inode->i_op = &pidfs_inode_operations;
 	inode->i_fop = &pidfs_file_operations;
-	inode->i_ino = pidfs_ino(pid->ino);
-	inode->i_generation = pidfs_gen(pid->ino);
+	inode->i_ino = pidfs_ino(ino);
+	inode->i_generation = pidfs_gen(ino);
+}
+
+static int pidfs_init_inode(struct inode *inode, void *data)
+{
+	struct pid *pid = data;
+
+	pidfs_init_common_inode(inode, &pid->pidfs_node, pid->ino);
 	return 0;
 }
 
+static bool pidfs_inode_data_matches(const struct inode *inode,
+				     const void *data)
+{
+	return pidfs_inode_pid(inode) == data;
+}
+
 static void pidfs_put_data(void *data)
 {
 	struct pid *pid = data;
@@ -1044,9 +1159,11 @@ int pidfs_register_pid_gfp(struct pid *pid, gfp_t gfp)
 static struct dentry *pidfs_stash_dentry(struct dentry **stashed,
 					 struct dentry *dentry)
 {
+	struct pid *pid = pidfs_inode_pid(d_inode(dentry));
 	int ret;
-	struct pid *pid = d_inode(dentry)->i_private;
 
+	if (WARN_ON_ONCE(IS_ERR(pid)))
+		return ERR_CAST(pid);
 	VFS_WARN_ON_ONCE(stashed != &pid->stashed);
 
 	ret = pidfs_register_pid(pid);
@@ -1060,15 +1177,19 @@ static const struct stashed_operations pidfs_stashed_ops = {
 	.stash_dentry	= pidfs_stash_dentry,
 	.init_inode	= pidfs_init_inode,
 	.put_data	= pidfs_put_data,
+	.data_matches	= pidfs_inode_data_matches,
 };
 
 static int pidfs_xattr_get(const struct xattr_handler *handler,
 			   struct dentry *unused, struct inode *inode,
 			   const char *suffix, void *value, size_t size)
 {
-	struct pid *pid = inode->i_private;
+	struct pid *pid = pidfs_inode_pid(inode);
 	const char *name = xattr_full_name(handler, suffix);
 
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
+
 	return simple_xattr_get(&pidfs_xa_cache, &pid->attr->xattrs, name, value, size);
 }
 
@@ -1077,10 +1198,13 @@ static int pidfs_xattr_set(const struct xattr_handler *handler,
 			   struct inode *inode, const char *suffix,
 			   const void *value, size_t size, int flags)
 {
-	struct pid *pid = inode->i_private;
+	struct pid *pid = pidfs_inode_pid(inode);
 	const char *name = xattr_full_name(handler, suffix);
 	struct simple_xattr *old_xattr;
 
+	if (IS_ERR(pid))
+		return PTR_ERR(pid);
+
 	/* Ensure we're the only one to set @attr->xattrs. */
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
@@ -1158,6 +1282,90 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
 	return pidfd_file;
 }
 
+/**
+ * pidfs_alloc_future_file - allocate a taskless pidfs file
+ * @name: anonymous file name used by LSM initialization
+ * @data: producer data retained for the inode lifetime
+ * @ops: callbacks that resolve and release @data
+ * @flags: file status flags
+ *
+ * Ownership of @data transfers to the returned file on success. One serialized
+ * producer owns all later association and publication transitions. It may
+ * associate one preallocated pid with
+ * pidfs_future_file_set_pid(), publish its pidfs metadata with
+ * pidfs_future_file_publish_pid(), make @ops->get_pid() resolve that pid, and
+ * finally wake waiters with pidfs_future_file_notify().
+ *
+ * A task associated with the future pid must not become runnable before
+ * publication metadata and exit-wakeup forwarding are installed.
+ *
+ * Return: A new pidfs file on success or an error pointer on failure.
+ */
+struct file *pidfs_alloc_future_file(const char *name, void *data,
+				     const struct pidfs_future_file_ops *ops,
+				     unsigned int flags)
+{
+	struct pidfs_future_file *future;
+	struct inode *inode;
+	struct file *file;
+	u64 ino;
+	int ret;
+
+	if (!ops || !ops->get_pid)
+		return ERR_PTR(-EINVAL);
+
+	future = kzalloc_obj(*future, GFP_KERNEL_ACCOUNT);
+	if (!future)
+		return ERR_PTR(-ENOMEM);
+	future->attr = kmem_cache_zalloc(pidfs_attr_cachep, GFP_KERNEL_ACCOUNT);
+	if (!future->attr) {
+		kfree(future);
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD_RCU(&future->attr->xattrs);
+
+	inode = new_inode_pseudo(pidfs_mnt->mnt_sb);
+	if (!inode) {
+		kmem_cache_free(pidfs_attr_cachep, future->attr);
+		kfree(future);
+		return ERR_PTR(-ENOMEM);
+	}
+	/* Preserve the anonymous-inode creation check for future pidfds. */
+	ret = security_inode_init_security_anon(inode, &QSTR(name), NULL);
+	if (ret) {
+		iput(inode);
+		kmem_cache_free(pidfs_attr_cachep, future->attr);
+		kfree(future);
+		return ERR_PTR(ret);
+	}
+	ino = pidfs_alloc_ino();
+	simple_inode_init_ts(inode);
+	pidfs_init_common_inode(inode, NULL, ino);
+
+	file = alloc_file_pseudo(inode, pidfs_mnt, name, flags,
+				 &pidfs_file_operations);
+	if (IS_ERR(file)) {
+		iput(inode);
+		kmem_cache_free(pidfs_attr_cachep, future->attr);
+		kfree(future);
+		return file;
+	}
+
+	future->node.type = PIDFS_NODE_FUTURE;
+	future->data = data;
+	future->ops = ops;
+	future->ino = ino;
+	inode->i_private = &future->node;
+	return file;
+}
+
+u64 pidfs_future_file_ino(const struct file *file)
+{
+	struct pidfs_future_file *future = pidfs_future_file(file_inode(file));
+
+	return future ? future->ino : 0;
+}
+
 void __init pidfs_init(void)
 {
 	if (rhashtable_init(&pidfs_ino_ht, &pidfs_ino_ht_params))
diff --git a/include/linux/pid.h b/include/linux/pid.h
index ddaef0bbc8ba3..a29ffe2a5fa8e 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -50,6 +50,15 @@
 
 struct pidfs_attr;
 
+enum pidfs_node_type {
+	PIDFS_NODE_PID,
+	PIDFS_NODE_FUTURE,
+};
+
+struct pidfs_node {
+	enum pidfs_node_type type;
+};
+
 struct upid {
 	int nr;
 	struct pid_namespace *ns;
@@ -59,6 +68,7 @@ struct pid {
 	refcount_t count;
 	unsigned int level;
 	spinlock_t lock;
+	struct pidfs_node pidfs_node;
 	struct {
 		u64 ino;
 		struct rhash_head pidfs_hash;
diff --git a/include/linux/pidfs.h b/include/linux/pidfs.h
index 0abf7da9ab236..6b7fbc54ab388 100644
--- a/include/linux/pidfs.h
+++ b/include/linux/pidfs.h
@@ -5,8 +5,29 @@
 #include <linux/gfp_types.h>
 
 struct coredump_params;
+struct file;
+struct pid;
+
+/**
+ * struct pidfs_future_file_ops - callbacks for a taskless pidfs file
+ * @get_pid: Return the published, borrowed, non-NULL process identity, or an
+ *	error pointer while the producer is still taskless. The producer must
+ *	keep the returned pid alive for the future inode lifetime.
+ * @release: Optionally release producer-owned data when the pidfs inode is
+ *	evicted. If provided, this is called at most once.
+ */
+struct pidfs_future_file_ops {
+	struct pid *(*get_pid)(void *data);
+	void (*release)(void *data);
+};
 
 struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags);
+struct file *pidfs_alloc_future_file(const char *name, void *data,
+				     const struct pidfs_future_file_ops *ops,
+				     unsigned int flags);
+void *pidfs_future_file_data(const struct file *file,
+			     const struct pidfs_future_file_ops *ops);
+u64 pidfs_future_file_ino(const struct file *file);
 void __init pidfs_init(void);
 void pidfs_prepare_pid(struct pid *pid);
 int pidfs_add_pid(struct pid *pid);
-- 
2.52.0

