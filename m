From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC 3/4] proc: support mounting new procfs instances inside same pid namespace
Date: Thu, 30 Mar 2017 17:22:58 +0200
Message-ID: <1490887379-25880-4-git-send-email-tixxdz@gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7194-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, kirill@shutemov.name, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch adds support for 'unshare' mount option to have multiple
separated procfs inside the same pid namespace. This allows to solve lot
of problem for containers and their specific use cases.

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/generic.c       | 10 +++++++++
 fs/proc/inode.c         |  3 +++
 fs/proc/root.c          | 59 +++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/proc_fs.h | 12 ++++++++++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7e5e419..7ae5377 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -52,6 +52,11 @@ void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
 		fs_info->pid_gid = gid;
 }
 
+void proc_fs_set_unshare(struct proc_fs_info *fs_info, int version)
+{
+	fs_info->version = version;
+}
+
 int proc_fs_get_hide_pid(struct proc_fs_info *fs_info)
 {
 	/* For backward compatibility */
@@ -70,6 +75,11 @@ kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info)
 	return fs_info->pid_gid;
 }
 
+int proc_fs_get_unshare(struct proc_fs_info *fs_info)
+{
+	return fs_info->version;
+}
+
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
 	if (len < de->namelen)
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index ca47a0a..5f7557d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -111,6 +111,9 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	if (pid->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
 
+	if (proc_fs_get_unshare(fs_info) == PROC_FS_V2)
+		seq_printf(seq, ",unshare");
+
 	return 0;
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 6a96c02..7a8f425 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -27,15 +27,52 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_unshare, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_unshare, "unshare"},
 	{Opt_err, NULL},
 };
 
+/* We only parse 'unshare' option here */
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
+		case Opt_unshare:
+			pr_info("proc: mounting a new procfs instance ");
+			proc_fs_set_unshare(fs_info, PROC_FS_V2);
+			break;
+		default:
+			break;
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
@@ -70,6 +107,8 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 			}
 			proc_fs_set_hide_pid(fs_info, option);
 			break;
+		case Opt_unshare:
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
@@ -82,9 +121,19 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
+	int error, version;
 	struct proc_fs_info *fs_info = proc_sb(sb);
 
+	version = proc_fs_get_unshare(fs_info);
+
 	sync_filesystem(sb);
+
+	if (version == PROC_FS_V2) {
+		error = proc_parse_early_options(data, fs_info);
+		if (error < 0)
+			return error;
+	}
+
 	return !proc_parse_options(data, fs_info);
 }
 
@@ -122,15 +171,21 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	if (!fs_info)
 		return ERR_PTR(-ENOMEM);
 
+	/* Set it as early as possible */
+	proc_fs_set_unshare(fs_info, PROC_FS_V1);
+
 	if (flags & MS_KERNMOUNT) {
 		ns = data;
 		data = NULL;
 	} else {
+		error = proc_parse_early_options(data, fs_info);
+		if (error < 0)
+			goto error_fs_info;
+
 		ns = task_active_pid_ns(current);
 	}
 
 	fs_info->pid_ns = ns;
-	fs_info->version = PROC_FS_V1;
 	fs_info->hide_pid = HIDEPID_OFF;
 	fs_info->pid_gid = GLOBAL_ROOT_GID;
 	refcount_set(&fs_info->users, 1);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index c23299d..e3a78a5 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -31,8 +31,11 @@ extern void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid);
 
 extern void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid);
 
+extern void proc_fs_set_unshare(struct proc_fs_info *fs_info, int version);
+
 extern int proc_fs_get_hide_pid(struct proc_fs_info *fs_info);
 extern kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info);
+extern int proc_fs_get_unshare(struct proc_fs_info *fs_info);
 
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
@@ -84,6 +87,10 @@ static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_p
 {
 }
 
+static inline void proc_fs_set_unshare(struct proc_fs_info *fs_info, int version)
+{
+}
+
 static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
 {
 }
@@ -98,6 +105,11 @@ extern kgid_t proc_fs_get_pid_gid(struct proc_fs_info *fs_info)
 	return GLOBAL_ROOT_GID;
 }
 
+static inline int proc_fs_get_unshare(struct proc_fs_info *fs_info)
+{
+	return PROC_FS_V1;
+}
+
 extern inline struct proc_fs_info *proc_sb(struct super_block *sb) { return NULL;}
 static inline struct proc_dir_entry *proc_symlink(const char *name,
 		struct proc_dir_entry *parent,const char *dest) { return NULL;}
-- 
2.10.2
