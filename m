From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] proc: allow to change proc mount options per mount
Date: Thu, 23 Mar 2017 16:59:30 +0100
Message-ID: <1490284770-11005-1-git-send-email-tixxdz@gmail.com>
References: <CALCETrXqv8VUeO6MpKWDR6DFYBgmmT0nZVezBJsimtmmQgDksw@mail.gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXqv8VUeO6MpKWDR6DFYBgmmT0nZVezBJsimtmmQgDksw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

As per the discussion with Andy, and following what Al Viro suggested
maybe this can work ? the patch is still buggy on top of Linus' tree 093b995e3b

Currently hidepid mount option is propagated to all proc mounts that are
in the same pid namespace. This patch make it possible to have proc
mounts with different options inside the same pid namespace.

Since this may break userspace or code that checks/expects some device
identifiers, this mode is only supported when theo ption "version=2" is
passed.

[Buggy patch]

[tixxdz@fedora-kvm linux]$ sudo mount -t proc none /test
[tixxdz@fedora-kvm linux]$ sudo mount -t proc -o hidepid=2,version=2 none /test2
[tixxdz@fedora-kvm linux]$ ls -l /proc | head -6
total 0
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 1
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 10
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 100
dr-xr-xr-x.  9 gdm     gdm                   0 Mar 23 17:25 1005
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 101
[tixxdz@fedora-kvm linux]$ ls -l /test | head -16
total 0
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 1
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 10
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 100
dr-xr-xr-x.  9 gdm     gdm                   0 Mar 23 17:25 1005
dr-xr-xr-x.  9 root    root                  0 Mar 23 17:25 101
[tixxdz@fedora-kvm linux]$ ls -l /test2 | head -6
total 0
dr-xr-xr-x.  9 tixxdz tixxdz               0 Mar 23 17:27 1182
dr-xr-xr-x.  9 tixxdz tixxdz               0 Mar 23 17:27 1197
dr-xr-xr-x.  9 tixxdz tixxdz               0 Mar 23 17:27 1199
dr-xr-xr-x.  9 tixxdz tixxdz               0 Mar 23 17:27 1222
dr-xr-xr-x.  9 tixxdz tixxdz               0 Mar 23 17:27 1225


Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/locks.c              |   6 +-
 fs/proc/base.c          |  51 +++++++++-----
 fs/proc/generic.c       |   5 ++
 fs/proc/inode.c         |  10 +--
 fs/proc/root.c          | 181 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/proc/self.c          |   8 ++-
 fs/proc/thread_self.c   |   6 +-
 fs/proc_namespace.c     |  14 ++--
 include/linux/proc_fs.h |   9 +++
 9 files changed, 248 insertions(+), 42 deletions(-)

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
index c87b6b9..74b389d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -681,13 +681,24 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
  * May current process learn task's sched/cmdline info (for hide_pid_min=1)
  * or euid/egid (for hide_pid_min=2)?
  */
-static bool has_pid_permissions(struct pid_namespace *pid,
+static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	int hide_pid;
+	kgid_t pid_gid;
+	int version = fs_info->version;
+
+	if (version == 2) {
+		hide_pid = fs_info->hide_pid;
+		pid_gid = fs_info->pid_gid;
+	} else {
+		hide_pid = fs_info->pid_ns->hide_pid;
+		pid_gid = fs_info->pid_ns->pid_gid;
+	}
+	if (hide_pid < hide_pid_min)
 		return true;
-	if (in_group_p(pid->pid_gid))
+	if (in_group_p(pid_gid))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -695,14 +706,15 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 
 static int proc_pid_permission(struct inode *inode, int mask)
 {
-	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
 	struct task_struct *task;
 	bool has_perms;
 
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
+	has_perms = has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
@@ -730,12 +742,12 @@ static const struct inode_operations proc_def_inode_operations = {
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
@@ -1734,7 +1746,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct task_struct *task;
-	struct pid_namespace *pid = path->dentry->d_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
 
 	generic_fillattr(inode, stat);
 
@@ -1743,7 +1755,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -2249,6 +2261,8 @@ static const struct seq_operations proc_timers_seq_ops = {
 static int proc_timers_open(struct inode *inode, struct file *file)
 {
 	struct timers_private *tp;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	tp = __seq_open_private(file, &proc_timers_seq_ops,
 			sizeof(struct timers_private));
@@ -2256,7 +2270,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
-	tp->ns = inode->i_sb->s_fs_info;
+	tp->ns = ns;
 	return 0;
 }
 
@@ -3077,13 +3091,13 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
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
@@ -3147,7 +3161,8 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
-	struct pid_namespace *ns = file_inode(file)->i_sb->s_fs_info;
+	struct proc_fs_info *fs_info = proc_sb(file_inode(file)->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	loff_t pos = ctx->pos;
 
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
@@ -3174,7 +3189,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		int len;
 
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
+		if (!has_pid_permissions(fs_info, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%d", iter.tgid);
@@ -3371,7 +3386,8 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	struct task_struct *task;
 	struct task_struct *leader = get_proc_task(dir);
 	unsigned tid;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(dentry->d_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 
 	if (!leader)
 		goto out_no_task;
@@ -3380,7 +3396,6 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
 	if (tid == ~0U)
 		goto out;
 
-	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tid, ns);
 	if (task)
@@ -3482,7 +3497,8 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *task;
-	struct pid_namespace *ns;
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+	struct pid_namespace *ns = fs_info->pid_ns;
 	int tid;
 
 	if (proc_inode_is_dead(inode))
@@ -3494,7 +3510,6 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
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
index 2cc7a80..4743943 100644
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
@@ -473,11 +474,12 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct pid_namespace *ns = get_pid_ns(s->s_fs_info);
+	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
 	int ret;
 
-	if (!proc_parse_options(data, ns))
+	if (fs_info->version == 1 && !proc_parse_options(data, ns))
 		return -EINVAL;
 
 	/* User space would break if executables or devices appear on proc */
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
index deecb39..d4047ef 100644
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
@@ -26,12 +27,13 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_version ,Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_version, "version=%u"},
 	{Opt_err, NULL},
 };
 
@@ -67,6 +69,8 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 			}
 			pid->hide_pid = option;
 			break;
+		case Opt_version:
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
@@ -77,40 +81,205 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 	return 1;
 }
 
+struct proc_options {
+	int version;	/* version field auto set to 1 to not break userspace */
+	kgid_t pid_gid;
+	int hide_pid;
+};
+
+int proc_parse_early_options(char *options, void *holder,
+			     struct proc_options *fs_options)
+{
+	char *p, *opts, *orig;
+	substring_t args[MAX_OPT_ARGS];
+	int option, ret = 0;
+
+	if (!options)
+		return 0;
+
+	opts = kstrdup(options, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+
+	orig = opts;
+
+	while ((p = strsep(&opts, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_version:
+			if (match_int(&args[0], &option)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			if (option < 1 || option > 2) {
+				pr_err("proc: version value must be 1 or 2.\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			fs_options->version = option;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			fs_options->pid_gid = make_kgid(current_user_ns(), option);
+			break;
+		case Opt_hidepid:
+			if (match_int(&args[0], &option)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			if (option < 0 || option > 2) {
+				pr_err("proc: hidepid value must be between 0 and 2.\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			fs_options->hide_pid = option;
+			break;
+		case Opt_err:
+			/*
+			 * pr_err("proc: unrecognized mount option \"%s\" ", p);
+			 * ret = -EINVAL;
+			 * goto out;
+			 */
+		default:
+			break;
+		}
+	}
+
+out:
+	kfree(orig);
+	return ret;
+}
+
+static int proc_test_super(struct super_block *s, void *data)
+{
+	int ret = 0;
+	struct proc_fs_info *p = data;
+	struct proc_fs_info *fs_info = proc_sb(s);
+
+	if (p->version == 1 && p->pid_ns == fs_info->pid_ns)
+		ret = 1;
+	/*
+	if (p->version == 2 && p->pid_ns == fs_info->pid_ns &&
+	    p->hide_pid == fs_info->hide_pid &&
+	    gid_eq(p->pid_gid, fs_info->pid_gid))
+		ret = 1;
+	*/
+	return ret;
+}
+
+static int proc_set_super(struct super_block *sb, void *data)
+{
+	sb->s_fs_info = data;
+	return set_anon_super(sb, NULL);
+}
+
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct pid_namespace *pid = sb->s_fs_info;
+	int error;
+	struct proc_fs_info *fs_info = proc_sb(sb);
+	struct pid_namespace *pid = fs_info->pid_ns;
+	struct proc_options fs_options = { 1, GLOBAL_ROOT_GID, 0 };
 
 	sync_filesystem(sb);
-	return !proc_parse_options(data, pid);
+	error = proc_parse_early_options(data, sb->s_type, &fs_options);
+	if (error < 0)
+		return error;
+
+	if (fs_options.version == 1) {
+		error = proc_parse_options(data, pid);
+		if (!error)
+			return -EINVAL;
+	}
+
+	fs_info->version = fs_options.version;
+	fs_info->pid_gid = fs_options.pid_gid;
+	fs_info->hide_pid = fs_options.hide_pid;
+
+	return 0;
 }
 
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	struct pid_namespace *ns;
+	struct super_block *sb;
+	struct proc_fs_info *fs_info = NULL;
+	struct proc_options fs_options = { 1, GLOBAL_ROOT_GID, 0 };
+	int error = 0;
+
+	if (!(flags & MS_KERNMOUNT)) {
+		if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+			return ERR_PTR(-EPERM);
+
+
+		error = proc_parse_early_options(data, fs_type, &fs_options);
+		if (error)
+			return ERR_PTR(error);
+	}
+
+	fs_info = kzalloc(sizeof(struct proc_fs_info), GFP_NOFS);
+	if (!fs_info)
+		return ERR_PTR(-ENOMEM);
+
+	fs_info->version = fs_options.version;
+	fs_info->pid_gid = fs_options.pid_gid;
+	fs_info->hide_pid = fs_options.hide_pid;
 
 	if (flags & MS_KERNMOUNT) {
 		ns = data;
 		data = NULL;
+		fs_info->version = 1; /* Lets restore this */
 	} else {
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
+	} else {
+		error = proc_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+		if (error) {
+			deactivate_locked_super(sb);
+			goto error_fs_info;
+		}
+
+		sb->s_flags |= MS_ACTIVE;
+	}
+
+	return dget(sb->s_root);
+
+error_fs_info:
+	kfree(fs_info);
+	return ERR_PTR(error);
 }
 
 static void proc_kill_sb(struct super_block *sb)
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
index 2d2bf59..27a1e85 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -7,10 +7,18 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 
+struct proc_fs_info {
+	struct pid_namespace *pid_ns;
+	int version;
+	kgid_t pid_gid;
+	int hide_pid;
+};
+
 struct proc_dir_entry;
 
 #ifdef CONFIG_PROC_FS
 
+extern struct proc_fs_info *proc_sb(struct super_block *sb);
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -53,6 +61,7 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
-- 
2.10.2
