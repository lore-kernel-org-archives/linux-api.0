From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v2 2/6] proc: move /proc/{self|thread-self} dentries to proc_fs_info
Date: Tue, 25 Apr 2017 14:23:54 +0200
Message-ID: <1493123038-30590-3-git-send-email-tixxdz@gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7544-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Jeff Layton <jlayton@poochiereds.net>, bfields@fieldses.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, ebiederm@xmission.com, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This is a preparation patch that moves /proc/{self|thread-self} dentries
to be stored inside procfs fs_info struct instead of making them per pid
namespace. Since we want to support multiple procfs instances we need to
make sure that these dentries are also per-superblock instead of
per-pidns, unmounting a private procfs won't clash with other procfs
mounts.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c                | 4 ++--
 fs/proc/root.c                | 8 ++++----
 fs/proc/self.c                | 3 +--
 fs/proc/thread_self.c         | 5 ++---
 include/linux/pid_namespace.h | 4 +---
 include/linux/proc_fs.h       | 2 ++
 6 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index fa7d725..c96a9c6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3214,13 +3214,13 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
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
index a625361..f44b864 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -161,10 +161,10 @@ static void proc_kill_sb(struct super_block *sb)
 	struct proc_fs_info *fs_info = proc_sb(sb);
 	struct pid_namespace *ns = (struct pid_namespace *)fs_info->pid_ns;
 
-	if (ns->proc_self)
-		dput(ns->proc_self);
-	if (ns->proc_thread_self)
-		dput(ns->proc_thread_self);
+	if (fs_info->proc_self)
+		dput(fs_info->proc_self);
+	if (fs_info->proc_thread_self)
+		dput(fs_info->proc_thread_self);
 	kill_anon_super(sb);
 	put_pid_ns(ns);
 	kfree(fs_info);
diff --git a/fs/proc/self.c b/fs/proc/self.c
index 9f95174..d3aaf71 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -36,7 +36,6 @@ int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
 	struct proc_fs_info *fs_info = proc_sb(s);
-	struct pid_namespace *ns = fs_info->pid_ns;
 	struct dentry *self;
 
 	inode_lock(root_inode);
@@ -63,7 +62,7 @@ int proc_setup_self(struct super_block *s)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
 		return PTR_ERR(self);
 	}
-	ns->proc_self = self;
+	fs_info->proc_self = self;
 	return 0;
 }
 
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index 13d9aef..14ea8e6 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -36,7 +36,6 @@ static unsigned thread_self_inum;
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct proc_fs_info *fs_info = proc_sb(s);
-	struct pid_namespace *ns = fs_info->pid_ns;
 	struct inode *root_inode = d_inode(s->s_root);
 	struct dentry *thread_self;
 
@@ -61,10 +60,10 @@ int proc_setup_thread_self(struct super_block *s)
 	}
 	inode_unlock(root_inode);
 	if (IS_ERR(thread_self)) {
-		pr_err("proc_fill_super: can't allocate /proc/thread_self\n");
+		pr_err("proc_fill_super: can't allocate /proc/thread-self\n");
 		return PTR_ERR(thread_self);
 	}
-	ns->proc_thread_self = thread_self;
+	fs_info->proc_thread_self = thread_self;
 	return 0;
 }
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index c2a989d..306bdc6 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -38,9 +38,7 @@ struct pid_namespace {
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
index dd1dadd..7ba8540 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -10,6 +10,8 @@
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
+	struct dentry *proc_self; /* For /proc/self */
+	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 };
 
 struct proc_dir_entry;
-- 
2.10.2
