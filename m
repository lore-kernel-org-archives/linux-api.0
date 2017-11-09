From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v3 1/7] proc: add proc_fs_info struct to store proc information
Date: Thu,  9 Nov 2017 17:14:00 +0100
Message-ID: <1510244046-3256-2-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-10480-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
To: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This is a prepation patch that adds proc_fs_info to handle procfs
internal information. Right now procfs internal information is stored
inside the pid namespace which make it hard to change or modernize
procfs without affecting pid namespaces, furthermore this is blocking
all kind of changes that are needed to solve today's or future Linux
challenges, as noted by various maintainers and userspace needs:

"Here's another one: split up and modernize /proc." by Andy Lutomirski [1]

Discussion about kernel pointer leaks:
"And yes, as Kees and Daniel mentioned, it's definitely not just dmesg.
In fact, the primary things tend to be /proc and /sys, not dmesg
itself." By Linus Torvalds [2]

procfs is an important Linux API that offers features using filesystem
syscalls, hence lets handle it as a real filesystem, with its own
private information and avoid mixing it with PID namespaces since it is
more than PID namespace after all. This will allow later to support
separate instances each one with its own superblock, which will solve
lot of problems.

Other Linux interfaces like devpts were also updated to support
containers, sandboxes and multiple private instances [2]. Time to update
procfs also.

Patch changes:
* Adds proc_fs_info struct to store procfs mount information.
* Updates proc_mount() to directly handle mounts there.
* Updates all calls that need to access now proc_fs_info struct.

[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-January/004215.html
[2] http://www.openwall.com/lists/kernel-hardening/2017/10/05/5
[3] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/locks.c              |  6 +++--
 fs/proc/base.c          | 30 +++++++++++----------
 fs/proc/inode.c         |  8 +++---
 fs/proc/root.c          | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/proc/self.c          |  8 +++---
 fs/proc/thread_self.c   |  6 +++--
 fs/proc_namespace.c     | 14 +++++-----
 include/linux/proc_fs.h | 10 +++++++
 8 files changed, 117 insertions(+), 34 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 21b4dfa..6d5c473 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2624,7 +2624,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 {
 	struct inode *inode = NULL;
 	unsigned int fl_pid;
-	struct pid_namespace *proc_pidns = file_inode(f->file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(f->file)->i_sb);
+	struct pid_namespace *proc_pidns = fs_info->pid_ns;
 
 	fl_pid = locks_translate_pid(fl, proc_pidns);
 	/*
@@ -2704,7 +2705,8 @@ static int locks_show(struct seq_file *f, void *v)
 {
 	struct locks_iterator *iter = f->private;
 	struct file_lock *fl, *bfl;
-	struct pid_namespace *proc_pidns = file_inode(f->file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(f->file)->i_sb);
+	struct pid_namespace *proc_pidns = fs_info->pid_ns;
 
 	fl = hlist_entry(v, struct file_lock, fl_link);
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 31934cb..5fc2006 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -696,7 +696,8 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 
 static int proc_pid_permission(struct inode *inode, int mask)
 {
-	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 	struct task_struct *task;
 	bool has_perms;
 
@@ -731,12 +732,12 @@ static const struct inode_operations proc_def_inode_operations = {
 static int proc_single_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
-	struct pid_namespace *ns;
 	struct pid *pid;
 	struct task_struct *task;
 	int ret;
 
-	ns = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	pid = proc_pid(inode);
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
@@ -1774,9 +1775,10 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 int pid_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int query_flags)
 {
-	struct inode *inode = d_inode(path->dentry);
 	struct task_struct *task;
-	struct pid_namespace *pid = path->dentry->d_sb->s_fs_info;
+	struct inode *inode = d_inode(path->dentry);
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 
 	generic_fillattr(inode, stat);
 
@@ -2291,6 +2293,7 @@ static const struct seq_operations proc_timers_seq_ops = {
 static int proc_timers_open(struct inode *inode, struct file *file)
 {
 	struct timers_private *tp;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
 
 	tp = __seq_open_private(file, &proc_timers_seq_ops,
 			sizeof(struct timers_private));
@@ -2298,7 +2301,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
-	tp->ns = inode->i_sb->s_fs_info;
+	tp->ns = fs_info->pid_ns;
 	return 0;
 }
 
@@ -3133,13 +3136,13 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	int result = -ENOENT;
 	struct task_struct *task;
 	unsigned tgid;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
 		goto out;
 
-	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tgid, ns);
 	if (task)
@@ -3203,7 +3206,8 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
-	struct pid_namespace *ns = file_inode(file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(file)->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	loff_t pos = ctx->pos;
 
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
@@ -3432,7 +3436,8 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	struct task_struct *task;
 	struct task_struct *leader = get_proc_task(dir);
 	unsigned tid;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(dentry->d_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	if (!leader)
 		goto out_no_task;
@@ -3441,7 +3446,6 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	if (tid == ~0U)
 		goto out;
 
-	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tid, ns);
 	if (task)
@@ -3543,7 +3547,8 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *task;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	int tid;
 
 	if (proc_inode_is_dead(inode))
@@ -3555,7 +3560,6 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
-	ns = inode->i_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
 	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index dd0f826..9abc370 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -104,7 +104,8 @@ void __init proc_init_inodecache(void)
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
-	struct pid_namespace *pid = sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 
 	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
@@ -474,7 +475,8 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct pid_namespace *ns = get_pid_ns(s->s_fs_info);
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
 	int ret;
 
@@ -496,7 +498,7 @@ int proc_fill_super(struct super_block *s, void *data, int silent)
 	 * top of it
 	 */
 	s->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
-	
+
 	pde_get(&proc_root);
 	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode) {
diff --git a/fs/proc/root.c b/fs/proc/root.c
index ede8e64..43e2639 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/sched/stat.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
@@ -80,16 +81,45 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct pid_namespace *pid = sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 
 	sync_filesystem(sb);
 	return !proc_parse_options(data, pid);
 }
 
+static int proc_test_super(struct super_block *s, void *data)
+{
+	struct proc_fs_info *p = data;
+	struct proc_fs_info *fs_info = proc_sb(s);
+
+	return p->pid_ns == fs_info->pid_ns;
+}
+
+static int proc_set_super(struct super_block *sb, void *data)
+{
+	sb->s_fs_info = data;
+	return set_anon_super(sb, NULL);
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
+	int error;
+	struct super_block *sb;
 	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info;
+
+	/*
+	 * Don't allow mounting unless the caller has CAP_SYS_ADMIN over
+	 * the namespace.
+	 */
+	if (!(flags & SB_KERNMOUNT) && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	fs_info = kzalloc(sizeof(*fs_info), GFP_NOFS);
+	if (!fs_info)
+		return ERR_PTR(-ENOMEM);
 
 	if (flags & SB_KERNMOUNT) {
 		ns = data;
@@ -98,20 +128,51 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		ns = task_active_pid_ns(current);
 	}
 
-	return mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
+	fs_info->pid_ns = ns;
+
+	sb = sget_userns(fs_type, proc_test_super, proc_set_super, flags,
+			 ns->user_ns, fs_info);
+	if (IS_ERR(sb)) {
+		error = PTR_ERR(sb);
+		goto error_fs_info;
+	}
+
+	if (sb->s_root) {
+		kfree(fs_info);
+		if ((flags ^ sb->s_flags) & MS_RDONLY) {
+			error = -EBUSY;
+			goto error;
+		}
+	} else {
+		error = proc_fill_super(sb, data, flags & SB_SILENT ? 1 : 0);
+		if (error) {
+			deactivate_locked_super(sb);
+			goto error;
+		}
+
+		sb->s_flags |= SB_ACTIVE;
+	}
+
+	return dget(sb->s_root);
+
+error_fs_info:
+	kfree(fs_info);
+error:
+	return ERR_PTR(error);
 }
 
 static void proc_kill_sb(struct super_block *sb)
 {
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
-	ns = (struct pid_namespace *)sb->s_fs_info;
 	if (ns->proc_self)
 		dput(ns->proc_self);
 	if (ns->proc_thread_self)
 		dput(ns->proc_thread_self);
 	kill_anon_super(sb);
 	put_pid_ns(ns);
+	kfree(fs_info);
 }
 
 static struct file_system_type proc_fs_type = {
diff --git a/fs/proc/self.c b/fs/proc/self.c
index 31326bb..f773301 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -11,7 +11,8 @@ static const char *proc_self_get_link(struct dentry *dentry,
 				      struct inode *inode,
 				      struct delayed_call *done)
 {
-	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
@@ -35,9 +36,10 @@ static unsigned self_inum;
 int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct pid_namespace *ns = s->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	struct dentry *self;
-	
+
 	inode_lock(root_inode);
 	self = d_alloc_name(s->s_root, "self");
 	if (self) {
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index b813e3b..578887b 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -11,7 +11,8 @@ static const char *proc_thread_self_get_link(struct dentry *dentry,
 					     struct inode *inode,
 					     struct delayed_call *done)
 {
-	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	pid_t pid = task_pid_nr_ns(current, ns);
 	char *name;
@@ -35,8 +36,9 @@ static unsigned thread_self_inum;
 
 int proc_setup_thread_self(struct super_block *s)
 {
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	struct inode *root_inode = d_inode(s->s_root);
-	struct pid_namespace *ns = s->s_fs_info;
 	struct dentry *thread_self;
 
 	inode_lock(root_inode);
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index b786840..5389f43 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -37,23 +37,23 @@ static unsigned mounts_poll(struct file *file, poll_table *wait)
 	return res;
 }
 
-struct proc_fs_info {
+struct proc_fs_opts {
 	int flag;
 	const char *str;
 };
 
 static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
-	static const struct proc_fs_info fs_info[] = {
+	static const struct proc_fs_opts fs_opts[] = {
 		{ SB_SYNCHRONOUS, ",sync" },
 		{ SB_DIRSYNC, ",dirsync" },
 		{ SB_MANDLOCK, ",mand" },
 		{ SB_LAZYTIME, ",lazytime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = fs_opts; fs_infop->flag; fs_infop++) {
 		if (sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
@@ -63,7 +63,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 
 static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 {
-	static const struct proc_fs_info mnt_info[] = {
+	static const struct proc_fs_opts mnt_opts[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -72,9 +72,9 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = mnt_opts; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 928ef9e..9a3f6e9 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -8,10 +8,19 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 
+struct proc_fs_info {
+	struct pid_namespace *pid_ns;
+};
+
 struct proc_dir_entry;
 
 #ifdef CONFIG_PROC_FS
 
+static inline struct proc_fs_info *proc_sb(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -48,6 +57,7 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
-- 
2.7.4
