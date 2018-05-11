From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [PATCH v5 7/7] proc: add option to mount only a pids subset
Date: Fri, 11 May 2018 11:37:07 +0200
Message-ID: <20180511093707.GA1403@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This allows to hide all files and directories in the procfs that are not
related to tasks.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/generic.c       | 20 ++++++++++++++++++++
 fs/proc/inode.c         |  7 +++++++
 fs/proc/root.c          | 12 ++++++++++--
 include/linux/proc_fs.h | 21 +++++++++++++++++++++
 4 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 2078e70..af1295c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -266,6 +266,11 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
+	struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
+
+	if (proc_fs_pidonly(fs_info))
+		return ERR_PTR(-ENOENT);
+
 	return proc_lookup_de(dir, dentry, PDE(dir));
 }
 
@@ -322,10 +327,24 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
 int proc_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+
+	if (proc_fs_pidonly(fs_info))
+		return 1;
 
 	return proc_readdir_de(file, ctx, PDE(inode));
 }
 
+static int proc_dir_open(struct inode *inode, struct file *file)
+{
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
+
+	if (proc_fs_pidonly(fs_info))
+		return -ENOENT;
+
+	return 0;
+}
+
 /*
  * These are the generic /proc directory operations. They
  * use the in-memory "struct proc_dir_entry" tree to parse
@@ -335,6 +354,7 @@ static const struct file_operations proc_dir_operations = {
 	.llseek			= generic_file_llseek,
 	.read			= generic_read_dir,
 	.iterate_shared		= proc_readdir,
+	.open			= proc_dir_open,
 };
 
 /*
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 5e62598..9b7d9cb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -125,6 +125,9 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	if (limit_pids > PROC_LIMIT_PIDS_OFF)
 		seq_printf(seq, ",limit_pids=%u", limit_pids);
 
+	if (proc_fs_pidonly(fs_info))
+		seq_printf(seq, ",pidonly");
+
 	return 0;
 }
 
@@ -338,12 +341,16 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
 
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
+	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
 
+	if (proc_fs_pidonly(fs_info))
+		return -ENOENT;
+
 	/*
 	 * Ensure that
 	 * 1) PDE's ->release hook will be called no matter what
diff --git a/fs/proc/root.c b/fs/proc/root.c
index c72d22c..daa318e 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -28,17 +28,18 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_limit_pids, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_limit_pids, Opt_pidonly, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_limit_pids, "limit_pids=%u"},
+	{Opt_pidonly, "pidonly"},
 	{Opt_err, NULL},
 };
 
-/* We only parse 'limit_pids' option here */
+/* We only parse 'limit_pids' and 'pidonly' option here */
 int proc_parse_early_options(char *options, struct proc_fs_info *fs_info)
 {
 	char *p, *opts, *orig;
@@ -74,6 +75,11 @@ int proc_parse_early_options(char *options, struct proc_fs_info *fs_info)
 			proc_fs_set_newinstance(fs_info, true);
 			pr_info("proc: mounting a new procfs instance ");
 			break;
+		case Opt_pidonly:
+			proc_fs_set_pidonly(fs_info, PROC_PIDONLY_ON);
+			proc_fs_set_newinstance(fs_info, true);
+			pr_info("proc: mounting a new procfs instance ");
+			break;
 		case Opt_gid:
 		case Opt_hidepid:
 			break;
@@ -126,6 +132,7 @@ int proc_parse_options(char *options, struct proc_fs_info *fs_info)
 			}
 			proc_fs_set_hide_pid(fs_info, option);
 			break;
+		case Opt_pidonly:
 		case Opt_limit_pids:
 			break;
 		default:
@@ -198,6 +205,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	/* Set it as early as possible */
 	proc_fs_set_newinstance(fs_info, false);
 	proc_fs_set_limit_pids(fs_info, PROC_LIMIT_PIDS_OFF);
+	proc_fs_set_pidonly(fs_info, PROC_PIDONLY_OFF);
 
 	if (flags & SB_KERNMOUNT) {
 		ns = data;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 70e8b10..77137c1 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -18,6 +18,11 @@ enum { /* definitions for proc mount option limit_pids */
 	PROC_LIMIT_PIDS_PTRACE	= 1,	/* Limit pids to only ptracable pids */
 };
 
+enum {
+	PROC_PIDONLY_OFF = 0,
+	PROC_PIDONLY_ON = 1,
+};
+
 struct proc_fs_info {
 	struct super_block *sb;
 	struct pid_namespace *pid_ns;
@@ -26,6 +31,7 @@ struct proc_fs_info {
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 	bool newinstance; /* Private flag for new separated instances */
 	int limit_pids:1;
+	int pidonly:1;
 };
 
 #ifdef CONFIG_PROC_FS
@@ -60,6 +66,16 @@ static inline int proc_fs_set_limit_pids(struct proc_fs_info *fs_info, int value
 	return 0;
 }
 
+static inline int proc_fs_set_pidonly(struct proc_fs_info *fs_info, int value)
+{
+	if (value != PROC_PIDONLY_ON && value != PROC_PIDONLY_OFF)
+		return -EINVAL;
+
+	fs_info->pidonly = value;
+
+	return 0;
+}
+
 static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
 {
 	return fs_info->pid_ns->hide_pid;
@@ -80,6 +96,11 @@ static inline int proc_fs_limit_pids(struct proc_fs_info *fs_info)
 	return fs_info->limit_pids;
 }
 
+static inline int proc_fs_pidonly(struct proc_fs_info *fs_info)
+{
+	return fs_info->pidonly;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
-- 
2.10.5
