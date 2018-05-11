From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [PATCH v5 3/7] proc: add helpers to set and get proc hidepid and gid
 mount options
Date: Fri, 11 May 2018 11:35:28 +0200
Message-ID: <20180511093528.GA1250@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Djalal Harouni <tixxdz@gmail.com>

This is a cleaning patch to add helpers to set and get proc mount
options instead of directly using them. This make it easy to track
what's happening and easy to update in future.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c          | 16 +++++++++-------
 fs/proc/inode.c         |  5 +++--
 fs/proc/internal.h      |  2 +-
 fs/proc/root.c          | 15 ++++++++++-----
 include/linux/proc_fs.h | 44 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e0c2afc..57fc895 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -684,13 +684,16 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
  * May current process learn task's sched/cmdline info (for hide_pid_min=1)
  * or euid/egid (for hide_pid_min=2)?
  */
-static bool has_pid_permissions(struct pid_namespace *pid,
+static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	int hide_pid = proc_fs_hide_pid(fs_info);
+	kgid_t gid = proc_fs_pid_gid(fs_info);
+
+	if (hide_pid < hide_pid_min)
 		return true;
-	if (in_group_p(pid->pid_gid))
+	if (in_group_p(gid))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -706,7 +709,7 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
+	has_perms = has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
@@ -1786,7 +1789,6 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	struct task_struct *task;
 	struct inode *inode = d_inode(path->dentry);
 	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
 
 	generic_fillattr(inode, stat);
 
@@ -1795,7 +1797,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3272,7 +3274,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		int len;
 
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
+		if (!has_pid_permissions(fs_info, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%u", iter.tgid);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index e34b89a..9585727 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -494,11 +494,12 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct proc_fs_info *fs_info = proc_sb(s);
-	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
 	int ret;
 
-	if (!proc_parse_options(data, ns))
+	get_pid_ns(fs_info->pid_ns);
+
+	if (!proc_parse_options(data, fs_info))
 		return -EINVAL;
 
 	/* User space would break if executables or devices appear on proc */
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 0f1692e..facc2d9 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -253,7 +253,7 @@ static inline void proc_tty_init(void) {}
  * root.c
  */
 extern struct proc_dir_entry proc_root;
-extern int proc_parse_options(char *options, struct pid_namespace *pid);
+extern int proc_parse_options(char *options, struct proc_fs_info *fs_info);
 
 extern void proc_self_init(void);
 extern int proc_remount(struct super_block *, int *, char *);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 184c42b..bdea220 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -37,11 +37,12 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
-int proc_parse_options(char *options, struct pid_namespace *pid)
+int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	kgid_t gid;
 
 	if (!options)
 		return 1;
@@ -57,7 +58,12 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			pid->pid_gid = make_kgid(current_user_ns(), option);
+			gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(gid)) {
+				pr_err("proc: invalid gid mount option.\n");
+				return 0;
+			}
+			proc_fs_set_pid_gid(fs_info, gid);
 			break;
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
@@ -67,7 +73,7 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
-			pid->hide_pid = option;
+			proc_fs_set_hide_pid(fs_info, option);
 			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
@@ -82,10 +88,9 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct proc_fs_info *fs_info = proc_sb(sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
 
 	sync_filesystem(sb);
-	return !proc_parse_options(data, pid);
+	return !proc_parse_options(data, fs_info);
 }
 
 static int proc_test_super(struct super_block *s, void *data)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 5e461f6..a7fc6a1 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -8,6 +8,10 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/refcount.h>
+#include <linux/pid_namespace.h>
+
+struct proc_dir_entry;
+struct pid_namespace;
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
@@ -15,8 +19,6 @@ struct proc_fs_info {
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 };
 
-struct proc_dir_entry;
-
 #ifdef CONFIG_PROC_FS
 
 static inline struct proc_fs_info *proc_sb(struct super_block *sb)
@@ -24,6 +26,26 @@ static inline struct proc_fs_info *proc_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+	fs_info->pid_ns->hide_pid = hide_pid;
+}
+
+static inline void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
+{
+	fs_info->pid_ns->pid_gid = gid;
+}
+
+static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
+{
+	return fs_info->pid_ns->hide_pid;
+}
+
+static inline kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
+{
+	return fs_info->pid_ns->pid_gid;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -60,6 +82,24 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+}
+
+static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
+{
+}
+
+static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
+{
+	return 0;
+}
+
+extern kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
+{
+	return GLOBAL_ROOT_GID;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.10.5
