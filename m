From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v3 6/7] proc: support new 'pids=all|ptraceable' mount option
Date: Thu,  9 Nov 2017 17:14:05 +0100
Message-ID: <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch introduces the new 'pids' mount option, as it was discussed
and suggested by Andy Lutomirski [1].

* If 'pids=' is passed without 'newinstance' then it has no effect.

* If 'newinstance,pids=all' then all processes will be shown in proc.

* If 'newinstance,pids=ptraceable' then only ptraceable processes will be
shown.

* 'pids=' takes precendence over 'hidepid=' since 'hidepid=' can be
  ignored if "gid=" was set and caller has the "gid=" set in its groups.
  We want to guarantee that LSM have a security path there that can not
  be disabled with "gid=".

This allows to support lightweight sandboxes in Embedded Linux.

Later Yama LSM can be updated to check that processes are able only
able to see their children inside /proc/, allowing to support more tight
cases.

[1] https://lkml.org/lkml/2017/4/26/646

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c          | 36 +++++++++++++++++++++++++++++-------
 fs/proc/inode.c         |  6 +++++-
 fs/proc/root.c          | 20 ++++++++++++++++++--
 include/linux/proc_fs.h | 30 ++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 54b527c..88b92bc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -686,13 +686,24 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	int hide_pid = proc_fs_hide_pid(fs_info);
-	kgid_t gid = proc_fs_pid_gid(fs_info);
+	int pids = proc_fs_pids(fs_info);
+
+	/*
+	 * If 'pids=all' or if it was not set then lets fallback
+	 * to 'hidepid' and 'gid', if those are not enforced too, then
+	 * ptrace checks are skipped. Otherwise ptrace permission is
+	 * required for all other cases.
+	 */
+	if (pids == PIDS_ALL) {
+		int hide_pid = proc_fs_hide_pid(fs_info);
+		kgid_t gid = proc_fs_pid_gid(fs_info);
+
+		if (hide_pid < hide_pid_min)
+			return true;
 
-	if (hide_pid < hide_pid_min)
-		return true;
-	if (in_group_p(gid))
-		return true;
+		if (in_group_p(gid))
+			return true;
+	}
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
 
@@ -701,6 +712,7 @@ static int proc_pid_permission(struct inode *inode, int mask)
 {
 	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
 	int hide_pid = proc_fs_hide_pid(fs_info);
+	int pids = proc_fs_pids(fs_info);
 	struct task_struct *task;
 	bool has_perms;
 
@@ -711,7 +723,8 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (hide_pid == HIDEPID_INVISIBLE) {
+		if (pids == PIDS_PTRACEABLE ||
+		    hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
@@ -3140,6 +3153,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	unsigned tgid;
 	struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
 	struct pid_namespace *ns = fs_info->pid_ns;
+	int pids = proc_fs_pids(fs_info);
 
 	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
@@ -3153,7 +3167,15 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	if (!task)
 		goto out;
 
+	/* Limit procfs to only ptraceable tasks */
+	if (pids != PIDS_ALL) {
+		cond_resched();
+		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
+			goto out_put_task;
+	}
+
 	result = proc_pid_instantiate(dir, dentry, task, NULL);
+out_put_task:
 	put_task_struct(task);
 out:
 	return ERR_PTR(result);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index faec32a..2707d5f 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -108,8 +108,12 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	int hide_pid = proc_fs_hide_pid(fs_info);
 	kgid_t pid_gid = proc_fs_pid_gid(fs_info);
 
-	if (proc_fs_newinstance(fs_info))
+	if (proc_fs_newinstance(fs_info)) {
+		int pids = proc_fs_pids(fs_info);
+
 		seq_printf(seq, ",newinstance");
+		seq_printf(seq, ",pids=%s", pids == PIDS_ALL ? "all" : "ptraceable");
+	}
 
 	if (!gid_eq(pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(current_user_ns(),pid_gid));
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 33ab965..5cdff69 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -28,13 +28,14 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_newinstance, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_newinstance, Opt_pids, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_newinstance, "newinstance"},
+	{Opt_pids, "pids=%s"},
 	{Opt_err, NULL},
 };
 
@@ -67,6 +68,7 @@ int proc_parse_early_options(char *options, struct proc_fs_info *fs_info)
 			break;
 		case Opt_gid:
 		case Opt_hidepid:
+		case Opt_pids:
 			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
@@ -83,7 +85,7 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
-	int option;
+	int option, ret = 0;
 	kgid_t gid;
 
 	if (!options)
@@ -119,6 +121,19 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 			break;
 		case Opt_newinstance:
 			break;
+		case Opt_pids:
+			if (strcmp(args[0].from, "all") == 0)
+				ret = proc_fs_set_pids(fs_info, PIDS_ALL);
+			else if (strcmp(args[0].from, "ptraceable") == 0)
+				ret = proc_fs_set_pids(fs_info, PIDS_PTRACEABLE);
+			else
+				ret = -EINVAL;
+
+			if (ret < 0) {
+				pr_err("proc: invalid 'pids' mount option.\n");
+				return 0;
+			}
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
@@ -188,6 +203,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 	/* Set it as early as possible */
 	proc_fs_set_newinstance(fs_info, false);
+	proc_fs_set_pids(fs_info, PIDS_ALL);
 
 	if (flags & SB_KERNMOUNT) {
 		ns = data;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index c123e5ec..0730f52 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -18,6 +18,11 @@ enum { /* definitions for 'hidepid' mount option */
 	HIDEPID_INVISIBLE = 2,
 };
 
+enum { /* definitions for 'pids' mount option */
+	PIDS_ALL	= 0,
+	PIDS_PTRACEABLE	= 1,
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self; /* For /proc/self/ */
@@ -25,6 +30,7 @@ struct proc_fs_info {
 	bool newinstance; /* Flag for new separated instances */
 	kgid_t pid_gid;
 	int hide_pid;
+	int pids;
 };
 
 #ifdef CONFIG_PROC_FS
@@ -49,6 +55,16 @@ static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool va
 	fs_info->newinstance = value;
 }
 
+static inline int proc_fs_set_pids(struct proc_fs_info *fs_info, int value)
+{
+	if (value != PIDS_ALL &&
+	    (value != PIDS_PTRACEABLE || !fs_info->newinstance))
+		return -EINVAL;
+
+	fs_info->pids = value;
+	return 0;
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return fs_info->hide_pid;
@@ -64,6 +80,11 @@ static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
 	return fs_info->newinstance;
 }
 
+static inline int proc_fs_pids(struct proc_fs_info *fs_info)
+{
+	return fs_info->pids;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -112,6 +133,10 @@ static inline void proc_fs_set_newinstance(struct proc_fs_info *fs_info, bool va
 {
 }
 
+static inline int proc_fs_set_pids(struct proc_fs_info *fs_info, int value)
+{
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return 0;
@@ -127,6 +152,11 @@ static inline bool proc_fs_newinstance(struct proc_fs_info *fs_info)
 	return false;
 }
 
+static inline int proc_fs_pids(struct proc_fs_info *fs_info)
+{
+	return 0;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.7.4

