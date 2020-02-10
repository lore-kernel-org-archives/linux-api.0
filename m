From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v8 03/11] proc: move /proc/{self|thread-self} dentries to proc_fs_info
Date: Mon, 10 Feb 2020 16:05:11 +0100
Message-ID: <20200210150519.538333-4-gladkov.alexey@gmail.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200210150519.538333-1-gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Solar Designer <solar-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a preparation patch that moves /proc/{self|thread-self} dentries
to be stored inside procfs fs_info struct instead of making them per pid
namespace. Since we want to support multiple procfs instances we need to
make sure that these dentries are also per-superblock instead of
per-pidns, unmounting a private procfs won't clash with other procfs
mounts.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c                | 5 +++--
 fs/proc/root.c                | 8 ++++----
 fs/proc/self.c                | 4 ++--
 fs/proc/thread_self.c         | 6 +++---
 include/linux/pid_namespace.h | 4 +---
 include/linux/proc_fs.h       | 2 ++
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 672e71c52dbd..1eb366ad8b06 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3316,6 +3316,7 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct tgid_iter iter;
+	struct proc_fs_info *fs_info = proc_sb_info(file_inode(file)->i_sb);
 	struct pid_namespace *ns = proc_pid_ns(file_inode(file));
 	loff_t pos = ctx->pos;
 
@@ -3323,13 +3324,13 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	if (pos == TGID_OFFSET - 2) {
-		struct inode *inode = d_inode(ns->proc_self);
+		struct inode *inode = d_inode(fs_info->proc_self);
 		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
 	if (pos == TGID_OFFSET - 1) {
-		struct inode *inode = d_inode(ns->proc_thread_self);
+		struct inode *inode = d_inode(fs_info->proc_thread_self);
 		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index d449f095f0f7..637e26cc795e 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -210,10 +210,10 @@ static void proc_kill_sb(struct super_block *sb)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(sb);
 
-	if (fs_info->pid_ns->proc_self)
-		dput(fs_info->pid_ns->proc_self);
-	if (fs_info->pid_ns->proc_thread_self)
-		dput(fs_info->pid_ns->proc_thread_self);
+	if (fs_info->proc_self)
+		dput(fs_info->proc_self);
+	if (fs_info->proc_thread_self)
+		dput(fs_info->proc_thread_self);
 	kill_anon_super(sb);
 	put_pid_ns(fs_info->pid_ns);
 	kfree(fs_info);
diff --git a/fs/proc/self.c b/fs/proc/self.c
index 57c0a1047250..846fc2b7c8a8 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -36,7 +36,7 @@ static unsigned self_inum __ro_after_init;
 int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct pid_namespace *ns = proc_pid_ns(root_inode);
+	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *self;
 	int ret = -ENOMEM;
 	
@@ -62,7 +62,7 @@ int proc_setup_self(struct super_block *s)
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
 	else
-		ns->proc_self = self;
+		fs_info->proc_self = self;
 
 	return ret;
 }
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index f61ae53533f5..2493cbbdfa6f 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -36,7 +36,7 @@ static unsigned thread_self_inum __ro_after_init;
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct pid_namespace *ns = proc_pid_ns(root_inode);
+	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *thread_self;
 	int ret = -ENOMEM;
 
@@ -60,9 +60,9 @@ int proc_setup_thread_self(struct super_block *s)
 	inode_unlock(root_inode);
 
 	if (ret)
-		pr_err("proc_fill_super: can't allocate /proc/thread_self\n");
+		pr_err("proc_fill_super: can't allocate /proc/thread-self\n");
 	else
-		ns->proc_thread_self = thread_self;
+		fs_info->proc_thread_self = thread_self;
 
 	return ret;
 }
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 49538b172483..f91a8bf6e09e 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -31,9 +31,7 @@ struct pid_namespace {
 	unsigned int level;
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
-	struct vfsmount *proc_mnt;
-	struct dentry *proc_self;
-	struct dentry *proc_thread_self;
+	struct vfsmount *proc_mnt; /* Internal proc mounted during each new pidns */
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 2d79489e55aa..59162988998e 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -14,6 +14,8 @@ struct seq_operations;
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
+	struct dentry *proc_self;        /* For /proc/self */
+	struct dentry *proc_thread_self; /* For /proc/thread-self */
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
-- 
2.24.1
