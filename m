From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC 1/4] proc: add proc_fs_info struct to store proc options
Date: Thu, 30 Mar 2017 17:22:56 +0200
Message-ID: <1490887379-25880-2-git-send-email-tixxdz@gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7192-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, kirill@shutemov.name, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This is a preparation patch that adds a proc_fs_info to be able to store
different procfs options. Right now some mount options are stored inside
the pid namespace which make multiple proc share the same mount options.
This patch will help also to fix this.

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/locks.c              |  6 ++--
 fs/proc/base.c          | 31 +++++++++++--------
 fs/proc/generic.c       |  5 +++
 fs/proc/inode.c         |  8 +++--
 fs/proc/root.c          | 81 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/proc/self.c          |  8 +++--
 fs/proc/thread_self.c   |  6 ++--
 fs/proc_namespace.c     | 14 ++++-----
 include/linux/proc_fs.h | 17 +++++++++++
 9 files changed, 141 insertions(+), 35 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 2681132..dab5058 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2617,7 +2617,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	unsigned int fl_pid;
 
 	if (fl->fl_nspid) {
-		struct pid_namespace *proc_pidns = file_inode(f->file)->i_sb->s_fs_info;
+		struct proc_fs_info *fs_info = proc_sb(file_inode(f->file)->i_sb);
+		struct pid_namespace *proc_pidns = fs_info->pid_ns;
 
 		/* Don't let fl_pid change based on who is reading the file */
 		fl_pid = pid_nr_ns(fl->fl_nspid, proc_pidns);
@@ -2701,7 +2702,8 @@ static int locks_show(struct seq_file *f, void *v)
 {
 	struct locks_iterator *iter = f->private;
 	struct file_lock *fl, *bfl;
-	struct pid_namespace *proc_pidns = file_inode(f->file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(f->file)->i_sb);
+	struct pid_namespace *proc_pidns = fs_info->pid_ns;
 
 	fl = hlist_entry(v, struct file_lock, fl_link);
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c87b6b9..cd16979 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -695,7 +695,8 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 
 static int proc_pid_permission(struct inode *inode, int mask)
 {
-	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 	struct task_struct *task;
 	bool has_perms;
 
@@ -730,12 +731,12 @@ static const struct inode_operations proc_def_inode_operations = {
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
@@ -1732,9 +1733,10 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
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
 
@@ -2249,6 +2251,8 @@ static const struct seq_operations proc_timers_seq_ops = {
 static int proc_timers_open(struct inode *inode, struct file *file)
 {
 	struct timers_private *tp;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	tp = __seq_open_private(file, &proc_timers_seq_ops,
 			sizeof(struct timers_private));
@@ -2256,7 +2260,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
-	tp->ns = inode->i_sb->s_fs_info;
+	tp->ns = ns;
 	return 0;
 }
 
@@ -3077,13 +3081,13 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
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
@@ -3147,7 +3151,8 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
-	struct pid_namespace *ns = file_inode(file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(file)->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	loff_t pos = ctx->pos;
 
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
@@ -3371,7 +3376,8 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	struct task_struct *task;
 	struct task_struct *leader = get_proc_task(dir);
 	unsigned tid;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(dentry->d_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	if (!leader)
 		goto out_no_task;
@@ -3380,7 +3386,6 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	if (tid == ~0U)
 		goto out;
 
-	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tid, ns);
 	if (task)
@@ -3482,7 +3487,8 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *task;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	int tid;
 
 	if (proc_inode_is_dead(inode))
@@ -3494,7 +3500,6 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
-	ns = inode->i_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
 	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ee27feb..49c8cb9 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -28,6 +28,11 @@
 
 static DEFINE_RWLOCK(proc_subdir_lock);
 
+struct proc_fs_info *proc_sb(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
 	if (len < de->namelen)
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2cc7a80..e708288 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -103,7 +103,8 @@ void __init proc_init_inodecache(void)
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
-	struct pid_namespace *pid = sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 
 	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
@@ -473,7 +474,8 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct pid_namespace *ns = get_pid_ns(s->s_fs_info);
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
 	int ret;
 
@@ -495,7 +497,7 @@ int proc_fill_super(struct super_block *s, void *data, int silent)
 	 * top of it
 	 */
 	s->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
-	
+
 	pde_get(&proc_root);
 	root_inode = proc_get_inode(s, &proc_root);
 	if (!root_inode) {
diff --git a/fs/proc/root.c b/fs/proc/root.c
index deecb39..a683e93 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/sched/stat.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
@@ -79,16 +80,46 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 
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
+	int ret = 0;
+	struct proc_fs_info *p = data;
+	struct proc_fs_info *fs_info = proc_sb(s);
+
+	if (p->version == PROC_FS_V1 && fs_info->version == PROC_FS_V1 &&
+	    p->pid_ns == fs_info->pid_ns)
+		ret = 1;
+
+	return ret;
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
+	if (!(flags & MS_KERNMOUNT) && !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	fs_info = kzalloc(sizeof(*fs_info), GFP_NOFS);
+	if (!fs_info)
+		return ERR_PTR(-ENOMEM);
 
 	if (flags & MS_KERNMOUNT) {
 		ns = data;
@@ -97,20 +128,60 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		ns = task_active_pid_ns(current);
 	}
 
-	return mount_ns(fs_type, flags, data, ns, ns->user_ns, proc_fill_super);
+	fs_info->pid_ns = ns;
+	fs_info->version = PROC_FS_V1;
+	refcount_set(&fs_info->users, 1);
+
+	sb = sget_userns(fs_type, proc_test_super, proc_set_super, flags,
+			 ns->user_ns, fs_info);
+	if (IS_ERR(sb)) {
+		error = PTR_ERR(sb);
+		goto error_fs_info;
+	}
+
+	if (sb->s_root) {
+		struct proc_fs_info *old = proc_sb(sb);
+
+		refcount_inc(&old->users);
+		kfree(fs_info);
+	} else {
+		error = proc_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+		if (error) {
+			deactivate_locked_super(sb);
+			goto error;
+		}
+
+		sb->s_flags |= MS_ACTIVE;
+	}
+
+	return dget(sb->s_root);
+
+error_fs_info:
+	kfree(fs_info);
+error:
+	return ERR_PTR(error);
 }
 
-static void proc_kill_sb(struct super_block *sb)
+static void proc_destroy_sb(struct super_block *sb)
 {
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *ns = (struct pid_namespace *)fs_info->pid_ns;
 
-	ns = (struct pid_namespace *)sb->s_fs_info;
 	if (ns->proc_self)
 		dput(ns->proc_self);
 	if (ns->proc_thread_self)
 		dput(ns->proc_thread_self);
 	kill_anon_super(sb);
 	put_pid_ns(ns);
+	kfree(fs_info);
+}
+
+static void proc_kill_sb(struct super_block *sb)
+{
+	struct proc_fs_info *fs_info = proc_sb(sb);
+
+	if (refcount_dec_and_test(&fs_info->users))
+		proc_destroy_sb(sb);
 }
 
 static struct file_system_type proc_fs_type = {
diff --git a/fs/proc/self.c b/fs/proc/self.c
index 39857f6..9f95174 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -10,7 +10,8 @@ static const char *proc_self_get_link(struct dentry *dentry,
 				      struct inode *inode,
 				      struct delayed_call *done)
 {
-	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
@@ -34,9 +35,10 @@ static unsigned self_inum;
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
index 20614b6..13d9aef 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -10,7 +10,8 @@ static const char *proc_thread_self_get_link(struct dentry *dentry,
 					     struct inode *inode,
 					     struct delayed_call *done)
 {
-	struct pid_namespace *ns = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	pid_t pid = task_pid_nr_ns(current, ns);
 	char *name;
@@ -34,8 +35,9 @@ static unsigned thread_self_inum;
 
 int proc_setup_thread_self(struct super_block *s)
 {
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	struct inode *root_inode = d_inode(s->s_root);
-	struct pid_namespace *ns = s->s_fs_info;
 	struct dentry *thread_self;
 
 	inode_lock(root_inode);
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index b5713fe..d0ae937 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -36,23 +36,23 @@ static unsigned mounts_poll(struct file *file, poll_table *wait)
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
 		{ MS_SYNCHRONOUS, ",sync" },
 		{ MS_DIRSYNC, ",dirsync" },
 		{ MS_MANDLOCK, ",mand" },
 		{ MS_LAZYTIME, ",lazytime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = fs_opts; fs_infop->flag; fs_infop++) {
 		if (sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
@@ -62,7 +62,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 
 static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 {
-	static const struct proc_fs_info mnt_info[] = {
+	static const struct proc_fs_opts mnt_opts[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -71,9 +71,9 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
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
index 2d2bf59..e1cb9c3 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -6,11 +6,27 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/refcount.h>
+
+enum {
+	PROC_FS_V1	= 1,
+	PROC_FS_V2	= 2,
+};
+
+struct proc_fs_info {
+	refcount_t users;
+	struct pid_namespace *pid_ns;
+	kgid_t pid_gid;
+	int hide_pid;
+	int version;
+};
 
 struct proc_dir_entry;
 
 #ifdef CONFIG_PROC_FS
 
+extern struct proc_fs_info *proc_sb(struct super_block *sb);
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -53,6 +69,7 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
-- 
2.10.2
