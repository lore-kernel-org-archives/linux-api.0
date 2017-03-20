From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [RFC] Add option to mount only a pids subset
Date: Mon, 20 Mar 2017 13:58:55 +0100
Message-ID: <20170320125855.GG4554@comp-core-i7-2640m-0182e6>
References: <20170312021257.GP29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170312021257.GP29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vasiliy Kulikov <segoon@openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org


Al Viro, this patch looks better ?

== Overview ==

Some of the container virtualization systems are mounted /proc inside
the container. This is done in most cases to operate with information
about the processes. Knowing that /proc filesystem is not fully
virtualized they are mounted on top of dangerous places empty files or
directories (for exmaple /proc/sys, /proc/kcore, /sys/firmware, etc.).

The structure of this filesystem is dynamic and any module can create a
new object which will not necessarily be virtualized. There are
proprietary modules that aren't in the mainline whose work we can not
verify.

This opens up a potential threat to the system. The developers of the
virtualization system can't predict all dangerous places in /proc by
definition.

A more effective solution would be to mount into the container only what
is necessary and ignore the rest.

Right now there is the opportunity to pass in the container any port of
the /proc filesystem using mount --bind expect the pids.

This patch allows to mount only the part of /proc related to pids without
rest objects. Since this is an option for /proc, flags applied to /proc
have an effect on this subset of filesystem.

Originally the idea was that the container will be mounted only pid
sunset and additional required files will be mounted on top using the
overlayfs.

But I found out that /proc does not support overlayfs and does not allow
to mount anything on top or under it.

== TODO ==

There is still work to do:

* Add overlayfs support.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/generic.c             |   5 ++
 fs/proc/inode.c               |   2 +
 fs/proc/internal.h            |   7 +++
 fs/proc/root.c                | 113 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/pid_namespace.h |   1 +
 5 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ee27feb..50bb1e9 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/uaccess.h>
+#include <linux/pid_namespace.h>
 
 #include "internal.h"
 
@@ -307,6 +308,10 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *file,
 int proc_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+
+	if (ns->pidfs && inode == d_inode(ns->pidfs))
+		return 1;
 
 	return proc_readdir_de(PDE(inode), file, ctx);
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2cc7a80..0c9be65 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -109,6 +109,8 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
 	if (pid->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+	if (root == pid->pidfs)
+		seq_printf(seq, ",pidonly");
 
 	return 0;
 }
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c5ae09b..a5a4bf1 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -260,7 +260,14 @@ static inline void proc_tty_init(void) {}
 /*
  * root.c
  */
+struct proc_options {
+	kgid_t pid_gid;
+	int hide_pid;
+	int pid_only;
+};
+
 extern struct proc_dir_entry proc_root;
+extern struct proc_dir_entry pidfs_root;
 extern int proc_parse_options(char *options, struct pid_namespace *pid);
 
 extern void proc_self_init(void);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index deecb39..c2443d5 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -26,16 +26,17 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_pidonly, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_pidonly, "pidonly"},
 	{Opt_err, NULL},
 };
 
-int proc_parse_options(char *options, struct pid_namespace *pid)
+static int proc_fill_options(char *options, struct proc_options *fs_opts)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -55,7 +56,7 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			pid->pid_gid = make_kgid(current_user_ns(), option);
+			fs_opts->pid_gid = make_kgid(current_user_ns(), option);
 			break;
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
@@ -65,7 +66,10 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
-			pid->hide_pid = option;
+			fs_opts->hide_pid = option;
+			break;
+		case Opt_pidonly:
+			fs_opts->pid_only = 1;
 			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
@@ -77,6 +81,72 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 	return 1;
 }
 
+int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	struct proc_options opts = { 0 };
+
+	if (!proc_fill_options(options, &opts))
+		return 0;
+
+	pid->pid_gid = opts.pid_gid;
+	pid->hide_pid = opts.hide_pid;
+
+	return 1;
+}
+
+static int pidfs_register_dir(struct dentry *root, char *name, struct inode *inode)
+{
+	struct inode *root_inode = d_inode(root);
+	struct dentry *child;
+
+	inode_lock(root_inode);
+	child = d_alloc_name(root, name);
+	if (child) {
+		d_add(child, inode);
+	} else {
+		child = ERR_PTR(-ENOMEM);
+	}
+	inode_unlock(root_inode);
+	if (IS_ERR(child)) {
+		pr_err("pidfs_register_dir: can't allocate /pidfs/%s\n", name);
+		return PTR_ERR(child);
+	}
+	return 0;
+}
+
+static int fill_pidfs_root(struct super_block *s)
+{
+	struct pid_namespace *ns = get_pid_ns(s->s_fs_info);
+	struct inode *root_inode;
+	struct dentry *root;
+	int ret;
+
+	pde_get(&pidfs_root);
+	root_inode = proc_get_inode(s, &pidfs_root);
+	if (!root_inode) {
+		pr_err("pidfs_fill_root: get root inode failed\n");
+		return -ENOMEM;
+	}
+
+	root = d_make_root(root_inode);
+	if (!root) {
+		pr_err("pidfs_fill_root: allocate dentry failed\n");
+		return -ENOMEM;
+	}
+
+	ret = pidfs_register_dir(root, "self", d_inode(ns->proc_self));
+	if (ret)
+		return ret;
+
+	ret = pidfs_register_dir(root, "thread-self", d_inode(ns->proc_thread_self));
+	if (ret)
+		return ret;
+
+	ns->pidfs = root;
+
+	return 0;
+}
+
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct pid_namespace *pid = sb->s_fs_info;
@@ -89,6 +159,8 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	struct pid_namespace *ns;
+	static struct dentry *root;
+	struct proc_options opts = { 0 };
 
 	if (flags & MS_KERNMOUNT) {
 		ns = data;
@@ -97,7 +169,23 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		ns = task_active_pid_ns(current);
 	}
 
-	return mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
+	root = mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
+
+	if (!IS_ERR(root)) {
+		if (!proc_fill_options(data, &opts))
+			return ERR_PTR(-EINVAL);
+
+		if (opts.pid_only) {
+			int ret;
+
+			if (!ns->pidfs && (ret = fill_pidfs_root(root->d_sb)))
+				return ERR_PTR(ret);
+
+			root = ns->pidfs;
+		}
+	}
+
+	return root;
 }
 
 static void proc_kill_sb(struct super_block *sb)
@@ -109,6 +197,8 @@ static void proc_kill_sb(struct super_block *sb)
 		dput(ns->proc_self);
 	if (ns->proc_thread_self)
 		dput(ns->proc_thread_self);
+	if (ns->pidfs)
+		dput(ns->pidfs);
 	kill_anon_super(sb);
 	put_pid_ns(ns);
 }
@@ -214,6 +304,19 @@ struct proc_dir_entry proc_root = {
 	.name		= "/proc",
 };
 
+struct proc_dir_entry pidfs_root = {
+	.low_ino	= PROC_ROOT_INO,
+	.namelen	= 5,
+	.mode		= S_IFDIR | S_IRUGO | S_IXUGO,
+	.nlink		= 2,
+	.count		= ATOMIC_INIT(1),
+	.proc_iops	= &proc_root_inode_operations,
+	.proc_fops	= &proc_root_operations,
+	.parent		= &pidfs_root,
+	.subdir		= RB_ROOT,
+	.name		= "/pidfs",
+};
+
 int pid_ns_prepare_proc(struct pid_namespace *ns)
 {
 	struct vfsmount *mnt;
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index c2a989d..e7b4d64 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -41,6 +41,7 @@ struct pid_namespace {
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_self;
 	struct dentry *proc_thread_self;
+	struct dentry *pidfs;
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
-- 
2.10.2
