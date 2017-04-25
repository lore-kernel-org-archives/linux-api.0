From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v2 4/6] proc: support mounting private procfs instances inside same pid namespace
Date: Tue, 25 Apr 2017 14:23:56 +0200
Message-ID: <1493123038-30590-5-git-send-email-tixxdz@gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Jeff Layton <jlayton@poochiereds.net>, bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, ebiederm@xmission.com, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch allows to have multiple private procfs instances inside the
same pid namespace. Lot of other areas in the kernel and filesystems
have been updated to be able to support private instances, devpts is one
major example. The aim here is lightweight sandboxes, and to allow that we
have to modernize procfs internals.

1) The main aim of this work is to have on embedded systems one
supervisor for apps. Right now we have some lightweight sandbox support,
however if we create pid namespacess we have to manages all the
processes inside too, where our goal is to be able to run a bunch of
apps each one inside its own mount namespace without being able to
notice each other. We only want to use mount namespaces, and we want
procfs to behave more like a real mount point.

2) Linux Security Modules have multiple ptrace paths inside some
subsystems, however inside procfs, the implementation does not guarantee
that the ptrace() check which triggers the security_ptrace_check() hook
will always run. We have the 'hidepid' mount option that can be used to
force the ptrace_may_access() check inside has_pid_permissions() to run.
The problem is that 'hidepid' is per pid namespace and not attached to
the mount point, any remount or modification of 'hidepid' will propagate
to all other procfs mounts.

This also does not allow to support Yama LSM easily in desktop and user
sessions. Yama ptrace scope which restricts ptrace and some other
syscalls to be allowed only on inferiors, can be updated to have a
per-task context, where the context will be inherited during fork(),
clone() and preserved across execve(). If we support multiple private
procfs instances, then we may force the ptrace_may_access() on
/proc/<pids>/ to always run inside that new procfs instances. This will
allow to specifiy on user sessions if we should populate procfs with
pids that the user can ptrace or not.

By using Yama ptrace scope, some restricted users will only be able to see
inferiors inside /proc, they won't even be able to see their other
processes. Some software like Chromium, Firefox's crash handler, Wine
and others are already using Yama to restrict which processes can be
ptracable. With this change this will give the possibility to restrict
/proc/<pids>/ but more importantly this will give desktop users a
generic and usuable way to specifiy which users should see all processes
and which users can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change LSMs should be able to analyze
open/read/write/close...

3) This will modernize procfs and align it with all other filesystems
and subsystems that have been updated recently to be able to work in a
flexible way. This is the same as devpts where each mount now is a distinct
filesystem such that ptys and their indicies allocated in one mount are
independent from ptys and their indicies in all other mounts.

We have to align procfs and modernize it to have a per mount context
where at least the mount option do not propagate to all other mounts,
then maybe we can continue to implement new features. One example is to
require CAP_SYS_ADMIN in the init user namespace on some /proc/* which are
not pids and which are are not virtualized by design, or CAP_NET_ADMIN
inside userns on the net bits that are virtualized, etc.
These mount options won't propagate to previous mounts, and the system
will continue to be usable.

Ths patch introduces the new 'limit_pids' mount option as it was also
suggesed by Andy Lutomirski [1]. When this option is passed we
automatically create a private procfs instance. This is not the default
behaviour since we do not want to break userspace and we do not want to
provide different devices IDs by default, please see [1] for why.

* If 'limit_pids=0' this will create a private procfs instance without
  any restrictions.

* If 'limit_pids=1' this will create a private procfs instance where
processes will only be able to see pids that they can ptrace inside
/proc/

This allows to have a stable LSM path later inside has_pid_permissions()
to make sure that processes are not using filesystem syscall on
/proc/pid to inspect or write to pid where other mechanisms are supposed
to prevent this. This allows to align filesystem syscalls that go
through procfs on pids with the other syscalls that can be blocked by
seccomp filters.

Later Yama LSM can be updated to check that processes are able only
able to see their children inside /proc/.

[1] https://lkml.org/lkml/2017/3/31/324

Cc: Kees Cook <keescook@chromium.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c          | 21 ++++++++----
 fs/proc/inode.c         |  4 +++
 fs/proc/root.c          | 88 ++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/proc_fs.h | 51 ++++++++++++++++++++++++++++
 4 files changed, 153 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3351275..2e0f661 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -685,13 +685,22 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	int hide_pid = proc_fs_hide_pid(fs_info);
-	kgid_t gid = proc_fs_pid_gid(fs_info);
+	int limit_pids = proc_fs_limit_pids(fs_info);
 
-	if (hide_pid < hide_pid_min)
-		return true;
-	if (in_group_p(gid))
-		return true;
+	/*
+	 * If 'limit_pids' mount is set force a ptrace check,
+	 * we indicate that we are using a filesystem syscall
+	 * by passing PTRACE_MODE_READ_FSCREDS
+	 */
+	if (limit_pids == PROC_LIMIT_PIDS_OFF) {
+		int hide_pid = proc_fs_hide_pid(fs_info);
+		kgid_t gid = proc_fs_pid_gid(fs_info);
+
+		if (hide_pid < hide_pid_min)
+			return true;
+		if (in_group_p(gid))
+			return true;
+	}
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7c0e122..b4ee4a1 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -105,12 +105,16 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	struct super_block *sb = root->d_sb;
 	struct proc_fs_info *fs_info = proc_sb(sb);
 	struct pid_namespace *pid = fs_info->pid_ns;
+	int limit_pids = proc_fs_limit_pids(fs_info);
 
 	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
 	if (pid->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
 
+	if (limit_pids > PROC_LIMIT_PIDS_OFF)
+		seq_printf(seq, ",limit_pids=%u", limit_pids);
+
 	return 0;
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index a76ceb0..f398c14 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -27,15 +27,66 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_limit_pids, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_limit_pids, "limit_pids=%u"},
 	{Opt_err, NULL},
 };
 
+/* We only parse 'limit_pids' option here */
+int proc_parse_early_options(char *options, struct proc_fs_info *fs_info)
+{
+	char *p, *opts, *orig;
+	substring_t args[MAX_OPT_ARGS];
+	int option, ret;
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
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_limit_pids:
+			if (match_int(&args[0], &option))
+				return -EINVAL;
+			ret = proc_fs_set_limit_pids(fs_info, option);
+			if (ret < 0) {
+				pr_err("proc: faild to parse mount option "
+				       "\"%s\" \n", p);
+				return ret;
+			}
+			proc_fs_set_newinstance(fs_info, true);
+			pr_info("proc: mounting a new procfs instance ");
+			break;
+		case Opt_gid:
+		case Opt_hidepid:
+			break;
+		default:
+			pr_err("proc: unrecognized mount option \"%s\" "
+			       "or missing value\n", p);
+			return -EINVAL;
+		}
+	}
+
+	kfree(orig);
+	return 0;
+}
+
 int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 {
 	char *p;
@@ -74,6 +125,8 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 			}
 			proc_fs_set_hide_pid(fs_info, option);
 			break;
+		case Opt_limit_pids:
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
@@ -86,18 +139,34 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
+	int error;
 	struct proc_fs_info *fs_info = proc_sb(sb);
 
 	sync_filesystem(sb);
+
+	/*
+	 * If this is a new instance, then parse again the proc mount
+	 * options.
+	 */
+	if (proc_fs_newinstance(fs_info)) {
+		error = proc_parse_early_options(data, fs_info);
+		if (error < 0)
+			return error;
+	}
+
 	return !proc_parse_options(data, fs_info);
 }
 
-static int proc_test_super(struct super_block *s, void *data)
+static int proc_test_super(struct super_block *sb, void *data)
 {
 	struct proc_fs_info *p = data;
-	struct proc_fs_info *fs_info = proc_sb(s);
+	struct proc_fs_info *fs_info = proc_sb(sb);
 
-	return p->pid_ns == fs_info->pid_ns;
+	if (!proc_fs_newinstance(p) && !proc_fs_newinstance(fs_info) &&
+	    p->pid_ns == fs_info->pid_ns)
+		return 1;
+
+	return 0;
 }
 
 static int proc_set_super(struct super_block *sb, void *data)
@@ -109,7 +178,7 @@ static int proc_set_super(struct super_block *sb, void *data)
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	int error;
+	int error = 0;
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_fs_info *fs_info;
@@ -125,10 +194,19 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	if (!fs_info)
 		return ERR_PTR(-ENOMEM);
 
+	/* Set it as early as possible */
+	proc_fs_set_newinstance(fs_info, false);
+	proc_fs_set_limit_pids(fs_info, PROC_LIMIT_PIDS_OFF);
+
 	if (flags & MS_KERNMOUNT) {
 		ns = data;
 		data = NULL;
 	} else {
+		/* Parse early mount options if not a MS_KERNMOUNT */
+		error = proc_parse_early_options(data, fs_info);
+		if (error < 0)
+			goto error_fs_info;
+
 		ns = task_active_pid_ns(current);
 	}
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 7a8d641..0fddb84 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -12,10 +12,17 @@
 struct proc_dir_entry;
 struct pid_namespace;
 
+enum { /* definitions for proc mount option limit_pids */
+	PROC_LIMIT_PIDS_OFF	= 0,	/* Limit pids is off */
+	PROC_LIMIT_PIDS_PTRACE	= 1,	/* Limit pids to only ptracable pids */
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self; /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
+	bool newinstance; /* Private flag for new separated instances */
+	int limit_pids:1;
 };
 
 #ifdef CONFIG_PROC_FS
@@ -35,6 +42,21 @@ static inline void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
 	fs_info->pid_ns->pid_gid = gid;
 }
 
+static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool value)
+{
+	fs_info->newinstance = value;
+}
+
+static inline int proc_fs_set_limit_pids(struct proc_fs_info *fs_info, int value)
+{
+	if (value < PROC_LIMIT_PIDS_OFF || value > PROC_LIMIT_PIDS_PTRACE)
+		return -EINVAL;
+
+	fs_info->limit_pids = value;
+
+	return 0;
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return fs_info->pid_ns->hide_pid;
@@ -45,6 +67,16 @@ static inline kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
 	return fs_info->pid_ns->pid_gid;
 }
 
+static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
+{
+	return fs_info->newinstance;
+}
+
+static inline int proc_fs_limit_pids(struct proc_fs_info *fs_info)
+{
+	return fs_info->limit_pids;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -95,6 +127,15 @@ static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
 {
 }
 
+static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool value)
+{
+}
+
+static inline int proc_fs_set_limit_pids(struct proc_fs_info *fs_info, int value)
+{
+	return 0;
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return 0;
@@ -105,6 +146,16 @@ extern kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
 	return GLOBAL_ROOT_GID;
 }
 
+static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
+{
+	return false;
+}
+
+static inline int proc_fs_limit_pids(struct proc_fs_info *fs_info)
+{
+	return 0;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.10.2

