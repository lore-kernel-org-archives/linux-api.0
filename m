From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC 2/4] proc: add helpers to set/get hidepid and gid mount options
Date: Thu, 30 Mar 2017 17:22:57 +0200
Message-ID: <1490887379-25880-3-git-send-email-tixxdz@gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7193-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, kirill@shutemov.name, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This is a preparation patch to allow to set and get hidepid and gid
mount options correctly

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c          | 15 +++++++++------
 fs/proc/generic.c       | 37 +++++++++++++++++++++++++++++++++++++
 fs/proc/inode.c         |  5 +++--
 fs/proc/internal.h      |  2 +-
 fs/proc/root.c          | 13 ++++++++-----
 include/linux/proc_fs.h | 35 ++++++++++++++++++++++++++++++++---
 6 files changed, 90 insertions(+), 17 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index cd16979..fd16566 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -681,13 +681,16 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
  * May current process learn task's sched/cmdline info (for hide_pid_min=1)
  * or euid/egid (for hide_pid_min=2)?
  */
-static bool has_pid_permissions(struct pid_namespace *pid,
+static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	int hide_pid = proc_fs_get_hide_pid(fs_info);
+	kgid_t gid = proc_fs_get_pid_gid(fs_info);
+
+	if (hide_pid < hide_pid_min)
 		return true;
-	if (in_group_p(pid->pid_gid))
+	if (in_group_p(gid))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -703,7 +706,7 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
+	has_perms = has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
@@ -1745,7 +1748,7 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3179,7 +3182,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		int len;
 
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
+		if (!has_pid_permissions(fs_info, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%d", iter.tgid);
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 49c8cb9..7e5e419 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/printk.h>
+#include <linux/pid_namespace.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/idr.h>
@@ -33,6 +34,42 @@ struct proc_fs_info *proc_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+	/* For backward compatibility */
+	if (fs_info->version == PROC_FS_V1)
+		fs_info->pid_ns->hide_pid = hide_pid;
+	else if (fs_info->version == PROC_FS_V2)
+		fs_info->hide_pid = hide_pid;
+}
+
+void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
+{
+	/* For backward compatibility */
+	if (fs_info->version == PROC_FS_V1)
+		fs_info->pid_ns->pid_gid = gid;
+	else if (fs_info->version == PROC_FS_V2)
+		fs_info->pid_gid = gid;
+}
+
+int proc_fs_get_hide_pid(struct proc_fs_info *fs_info)
+{
+	/* For backward compatibility */
+	if (fs_info->version == PROC_FS_V1)
+		return fs_info->pid_ns->hide_pid;
+
+	return fs_info->hide_pid;
+}
+
+kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info)
+{
+	/* For backward compatibility */
+	if (fs_info->version == PROC_FS_V1)
+		return fs_info->pid_ns->pid_gid;
+
+	return fs_info->pid_gid;
+}
+
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
 	if (len < de->namelen)
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index e708288..ca47a0a 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -475,11 +475,12 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
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
index c5ae09b..126fa31 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -261,7 +261,7 @@ static inline void proc_tty_init(void) {}
  * root.c
  */
 extern struct proc_dir_entry proc_root;
-extern int proc_parse_options(char *options, struct pid_namespace *pid);
+extern int proc_parse_options(char *options, struct proc_fs_info *fs_info);
 
 extern void proc_self_init(void);
 extern int proc_remount(struct super_block *, int *, char *);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index a683e93..6a96c02 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -36,11 +36,12 @@ static const match_table_t tokens = {
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
@@ -56,7 +57,8 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			pid->pid_gid = make_kgid(current_user_ns(), option);
+			gid = make_kgid(current_user_ns(), option);
+			proc_fs_set_pid_gid(fs_info, gid);
 			break;
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
@@ -66,7 +68,7 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
-			pid->hide_pid = option;
+			proc_fs_set_hide_pid(fs_info, option);
 			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
@@ -81,10 +83,9 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct proc_fs_info *fs_info = proc_sb(sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
 
 	sync_filesystem(sb);
-	return !proc_parse_options(data, pid);
+	return !proc_parse_options(data, fs_info);
 }
 
 static int proc_test_super(struct super_block *s, void *data)
@@ -130,6 +131,8 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 	fs_info->pid_ns = ns;
 	fs_info->version = PROC_FS_V1;
+	fs_info->hide_pid = HIDEPID_OFF;
+	fs_info->pid_gid = GLOBAL_ROOT_GID;
 	refcount_set(&fs_info->users, 1);
 
 	sb = sget_userns(fs_type, proc_test_super, proc_set_super, flags,
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e1cb9c3..c23299d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -9,8 +9,8 @@
 #include <linux/refcount.h>
 
 enum {
-	PROC_FS_V1	= 1,
-	PROC_FS_V2	= 2,
+	PROC_FS_V1	= 1, /* Inside same pidns procfs mounts are shared */
+	PROC_FS_V2	= 2, /* New procfs mounts are separated by default */
 };
 
 struct proc_fs_info {
@@ -27,6 +27,13 @@ struct proc_dir_entry;
 
 extern struct proc_fs_info *proc_sb(struct super_block *sb);
 
+extern void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid);
+
+extern void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid);
+
+extern int proc_fs_get_hide_pid(struct proc_fs_info *fs_info);
+extern kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info);
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -38,7 +45,7 @@ extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 extern struct proc_dir_entry *proc_mkdir_mode(const char *, umode_t,
 					      struct proc_dir_entry *);
 struct proc_dir_entry *proc_create_mount_point(const char *name);
- 
+
 extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
 					       struct proc_dir_entry *,
 					       const struct file_operations *,
@@ -69,6 +76,28 @@ static inline void proc_flush_task(struct task_struct *task)
 {
 }
 
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+}
+
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+}
+
+static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
+{
+}
+
+static inline int proc_fs_get_hide_pid(struct proc_fs_info *fs_info)
+{
+	return 0;
+}
+
+extern kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info)
+{
+	return GLOBAL_ROOT_GID;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.10.2
