From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v8 04/11] proc: move hide_pid, pid_gid from pid_namespace to proc_fs_info
Date: Mon, 10 Feb 2020 16:05:12 +0100
Message-ID: <20200210150519.538333-5-gladkov.alexey@gmail.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200210150519.538333-1-gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Solar Designer <solar-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a preparation patch that moves hide_pid and pid_gid parameters
to be stored inside procfs fs_info struct instead of making them per pid
namespace. Since we want to support multiple procfs instances we need to
make sure that all proc-specific parameters are also per-superblock.

Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c                | 18 +++++++++---------
 fs/proc/inode.c               |  9 ++++-----
 fs/proc/root.c                | 10 ++++++++--
 include/linux/pid_namespace.h |  8 --------
 include/linux/proc_fs.h       |  9 +++++++++
 5 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1eb366ad8b06..caca1929fee1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -695,13 +695,13 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
  * May current process learn task's sched/cmdline info (for hide_pid_min=1)
  * or euid/egid (for hide_pid_min=2)?
  */
-static bool has_pid_permissions(struct pid_namespace *pid,
+static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	if (fs_info->hide_pid < hide_pid_min)
 		return true;
-	if (in_group_p(pid->pid_gid))
+	if (in_group_p(fs_info->pid_gid))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -709,18 +709,18 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 
 static int proc_pid_permission(struct inode *inode, int mask)
 {
-	struct pid_namespace *pid = proc_pid_ns(inode);
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct task_struct *task;
 	bool has_perms;
 
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
+	has_perms = has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (pid->hide_pid == HIDEPID_INVISIBLE) {
+		if (fs_info->hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
@@ -1784,7 +1784,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode = d_inode(path->dentry);
-	struct pid_namespace *pid = proc_pid_ns(inode);
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct task_struct *task;
 
 	generic_fillattr(inode, stat);
@@ -1794,7 +1794,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	rcu_read_lock();
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3344,7 +3344,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		unsigned int len;
 
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
+		if (!has_pid_permissions(fs_info, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%u", iter.tgid);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b631608dfbcc..b90c233e5968 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -105,12 +105,11 @@ void __init proc_init_kmemcache(void)
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(root->d_sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
 
-	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
-	if (pid->hide_pid != HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+	if (!gid_eq(fs_info->pid_gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fs_info->pid_gid));
+	if (fs_info->hide_pid != HIDEPID_OFF)
+		seq_printf(seq, ",hidepid=%u", fs_info->hide_pid);
 
 	return 0;
 }
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 637e26cc795e..1ca47d446aa4 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -89,10 +89,16 @@ static void proc_apply_options(struct super_block *s,
 {
 	struct proc_fs_context *ctx = fc->fs_private;
 
+	if (pid_ns->proc_mnt) {
+		struct proc_fs_info *fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
+		ctx->fs_info->pid_gid = fs_info->pid_gid;
+		ctx->fs_info->hide_pid = fs_info->hide_pid;
+	}
+
 	if (ctx->mask & (1 << Opt_gid))
-		pid_ns->pid_gid = make_kgid(user_ns, ctx->gid);
+		ctx->fs_info->pid_gid = make_kgid(user_ns, ctx->gid);
 	if (ctx->mask & (1 << Opt_hidepid))
-		pid_ns->hide_pid = ctx->hidepid;
+		ctx->fs_info->hide_pid = ctx->hidepid;
 }
 
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index f91a8bf6e09e..66f47f1afe0d 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,12 +15,6 @@
 
 struct fs_pin;
 
-enum { /* definitions for pid_namespace's hide_pid field */
-	HIDEPID_OFF	  = 0,
-	HIDEPID_NO_ACCESS = 1,
-	HIDEPID_INVISIBLE = 2,
-};
-
 struct pid_namespace {
 	struct kref kref;
 	struct idr idr;
@@ -39,8 +33,6 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	struct work_struct proc_work;
-	kgid_t pid_gid;
-	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	struct ns_common ns;
 } __randomize_layout;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 59162988998e..5f0b1b7e4271 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -12,10 +12,19 @@ struct proc_dir_entry;
 struct seq_file;
 struct seq_operations;
 
+/* definitions for hide_pid field */
+enum {
+	HIDEPID_OFF	  = 0,
+	HIDEPID_NO_ACCESS = 1,
+	HIDEPID_INVISIBLE = 2,
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
+	kgid_t pid_gid;
+	int hide_pid;
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
-- 
2.24.1
