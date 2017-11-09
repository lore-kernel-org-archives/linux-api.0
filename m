From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v3 4/7] proc: support mounting private procfs instances inside same pid namespace
Date: Thu,  9 Nov 2017 17:14:03 +0100
Message-ID: <1510244046-3256-5-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch allows to have multiple private procfs instances inside the
same pid namespace. For some cases procfs is more of a burden than an
API, it is blocking lot of other features, and from time to time we have
to workaround procfs to implement new features either in kernel or
userspace.

Discussion about security-related TODO items:
"Here's another one: split up and modernize /proc." By Andy Lutomirski [1]

Discussion about kernel pointer leaks:
"And yes, as Kees and Daniel mentioned, it's definitely not just dmesg.
In fact, the primary things tend to be /proc and /sys, not dmesg
itself." By Linus Torvalds [2]

Lot of other areas in the kernel and filesystems have been updated to be
able to support private instances, devpts is one major example. The aim
here is to modernize procfs, allow it to have multiple private instances,
so we can implement on top modern features or security mechanisms
without breaking userspace, or without affecting the shared procfs
mount. The new features will apply on the private instances, and after more
testing, months, maybe it can be made the default especially for IoT.

This allows to absorbe changes, make improvments without breaking use
cases, it is following the same path of devpts.

The final aim is to be able to do inside a lightweight sandbox:

  mount -t proc -onewinstance,pids=ptraceable none /proc

Which will be used for:

1) Embedded systems and IoT: usually we have one supervisor for
apps, we have some lightweight sandbox support, however if we create
pid namespaces we have to manage all the processes inside too,
where our goal is to be able to run a bunch of apps each one inside
its own mount namespace, maybe use network namespaces for vlans
setups, but right now we only want mount namespaces, without all the
other complexity. we want procfs to behave more like a real file system,
and block access to inodes that belong to other users. 'hidepid=' will
not work since it is a shared mount option.

2) Containers, sandboxes and Private instances of file systems - devpts case
Historically, lot of file systems inside Linux kernel view when instantiated
were just a mirror of an already created and mounted filesystem. This was the
case of devpts filesystem, it seems at that time the requirements were to
optimize things and reuse the same memory, etc. This design used to work but not
anymore with today’s containers, IoT, hostile environments and all the privacy
challenges that Linux faces.

In that regards, devpts was updated so that each new mounts is a total
independent file system by the following patches:
“devpts: Make each mount of devpts an independent filesystem” by
Eric W. Biederman [3] [4]

3) Linux Security Modules have multiple ptrace paths inside some
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
and which user can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change all LSMs should be able to analyze
open/read/write/close... on /proc/<pid>/

4) This will allow to implement new features either in kernel or
userspace without having to worry about procfs.
In containers, sandboxes, etc we have workarounds to hide some /proc
inodes, this should be supported natively without doing extra complex
work, the kernel should be able to support sane options that work with
today and future Linux use cases.

Changes of this patch:

* 'newinstance' mount option, it was also suggesed by Andy Lutomirski [5].
When this option is passed we automatically create a private procfs instance.

This is not the default behaviour since we do not want to break userspace
and we do not want to provide different devices IDs by default when
stat()ing inodes, I am not sure about all the use cases there [6].

* Also this patch moves the 'hidepid' and 'gid' mount options from being
defined and used inside PID namespaces to their private proc_fs_info
struct, cleaning both PID namespaces and procfs.

Use cases of 'newinstance' mount option:

* We create a private procfs instance that it is disconnected from the
shared or other procfs instances.

* "hidepid" instead of chaning all other mirrored procfs mounts, now
it will work only on the new private instance.

* "gid" instead of chaning all other mirrored procfs mounts, now it will
work only on the new private instance.

* The next patch that introduces "pids=ptraceable" mount option which
will take precendence over "hidepid" will only work when 'newinstance'
is set. Otherwise it is ignored.

This should allow later after real testing to have a smooth transition
to a procfs with default private instances.

[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-January/004215.html
[2] http://www.openwall.com/lists/kernel-hardening/2017/10/05/5
[3] https://lwn.net/Articles/689539/
[4] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14
[5] https://lkml.org/lkml/2017/5/2/407
[6] https://lkml.org/lkml/2017/5/3/357

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c                |  4 +--
 fs/proc/inode.c               | 14 +++++---
 fs/proc/root.c                | 78 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/pid_namespace.h |  2 --
 include/linux/proc_fs.h       | 30 ++++++++++++++---
 5 files changed, 110 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f324c49..54b527c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -700,7 +700,7 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 static int proc_pid_permission(struct inode *inode, int mask)
 {
 	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
+	int hide_pid = proc_fs_hide_pid(fs_info);
 	struct task_struct *task;
 	bool has_perms;
 
@@ -711,7 +711,7 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (pid->hide_pid == HIDEPID_INVISIBLE) {
+		if (hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index bdd808d..faec32a 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -105,12 +105,16 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
 	struct proc_fs_info *fs_info = proc_sb(sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
+	int hide_pid = proc_fs_hide_pid(fs_info);
+	kgid_t pid_gid = proc_fs_pid_gid(fs_info);
 
-	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
-	if (pid->hide_pid != HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+	if (proc_fs_newinstance(fs_info))
+		seq_printf(seq, ",newinstance");
+
+	if (!gid_eq(pid_gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(current_user_ns(),pid_gid));
+	if (hide_pid != HIDEPID_OFF)
+		seq_printf(seq, ",hidepid=%u", hide_pid);
 
 	return 0;
 }
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 48cc481..33ab965 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -28,15 +28,57 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_newinstance, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_newinstance, "newinstance"},
 	{Opt_err, NULL},
 };
 
+/* We only parse 'newinstance' option here */
+int proc_parse_early_options(char *options, struct proc_fs_info *fs_info)
+{
+	char *p, *opts, *orig;
+	substring_t args[MAX_OPT_ARGS];
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
+		case Opt_newinstance:
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
@@ -75,6 +117,8 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 			}
 			proc_fs_set_hide_pid(fs_info, option);
 			break;
+		case Opt_newinstance:
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
@@ -87,18 +131,34 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 
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
+
+	if (!proc_fs_newinstance(p) && !proc_fs_newinstance(fs_info) &&
+	    p->pid_ns == fs_info->pid_ns)
+		return 1;
 
-	return p->pid_ns == fs_info->pid_ns;
+	return 0;
 }
 
 static int proc_set_super(struct super_block *sb, void *data)
@@ -110,7 +170,7 @@ static int proc_set_super(struct super_block *sb, void *data)
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	int error;
+	int error = 0;
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_fs_info *fs_info;
@@ -126,10 +186,18 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	if (!fs_info)
 		return ERR_PTR(-ENOMEM);
 
+	/* Set it as early as possible */
+	proc_fs_set_newinstance(fs_info, false);
+
 	if (flags & SB_KERNMOUNT) {
 		ns = data;
 		data = NULL;
 	} else {
+		/* Parse early mount options if not a kernel mount */
+		error = proc_parse_early_options(data, fs_info);
+		if (error < 0)
+			goto error_fs_info;
+
 		ns = task_active_pid_ns(current);
 	}
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index f91a8bf..786ea04 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -39,8 +39,6 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	struct work_struct proc_work;
-	kgid_t pid_gid;
-	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	struct ns_common ns;
 } __randomize_layout;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 047d0d0..408b51d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -16,6 +16,9 @@ struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self; /* For /proc/self/ */
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
+	bool newinstance; /* Flag for new separated instances */
+	kgid_t pid_gid;
+	int hide_pid;
 };
 
 #ifdef CONFIG_PROC_FS
@@ -27,22 +30,32 @@ static inline struct proc_fs_info *proc_sb(struct super_block *sb)
 
 static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
 {
-	fs_info->pid_ns->hide_pid = hide_pid;
+	fs_info->hide_pid = hide_pid;
 }
 
 static inline void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
 {
-	fs_info->pid_ns->pid_gid = gid;
+	fs_info->pid_gid = gid;
+}
+
+static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool value)
+{
+	fs_info->newinstance = value;
 }
 
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
-	return fs_info->pid_ns->hide_pid;
+	return fs_info->hide_pid;
 }
 
 static inline kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
 {
-	return fs_info->pid_ns->pid_gid;
+	return fs_info->pid_gid;
+}
+
+static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
+{
+	return fs_info->newinstance;
 }
 
 extern void proc_root_init(void);
@@ -89,6 +102,10 @@ static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
 {
 }
 
+static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool value)
+{
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return 0;
@@ -99,6 +116,11 @@ extern kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
 	return GLOBAL_ROOT_GID;
 }
 
+static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
+{
+	return false;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.7.4
