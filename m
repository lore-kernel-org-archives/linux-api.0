From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v3 2/7] proc: move /proc/{self|thread-self} dentries to proc_fs_info
Date: Thu,  9 Nov 2017 17:14:01 +0100
Message-ID: <1510244046-3256-3-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-10481-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
To: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This is a preparation patch that moves /proc/{self|thread-self} dentries
to be stored inside procfs proc_fs_info struct instead of making them
per PID namespace. Since we want to support multiple procfs instances we
need to make sure that these dentries are also per-superblock instead of
per-pidns, and we want to make sure that unmounting a private procfs
won't clash with other procfs mounts.

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
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
index 5fc2006..0d9b4214 100644
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
index 43e2639..b225ae5 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -166,10 +166,10 @@ static void proc_kill_sb(struct super_block *sb)
 	struct proc_fs_info *fs_info = proc_sb(sb);
 	struct pid_namespace *ns = fs_info->pid_ns;
 
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
index f773301..8a67cf0 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -37,7 +37,6 @@ int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
 	struct proc_fs_info *fs_info = proc_sb(s);
-	struct pid_namespace *ns = fs_info->pid_ns;
 	struct dentry *self;
 
 	inode_lock(root_inode);
@@ -64,7 +63,7 @@ int proc_setup_self(struct super_block *s)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
 		return PTR_ERR(self);
 	}
-	ns->proc_self = self;
+	fs_info->proc_self = self;
 	return 0;
 }
 
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index 578887b..6e3225f 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -37,7 +37,6 @@ static unsigned thread_self_inum;
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct proc_fs_info *fs_info = proc_sb(s);
-	struct pid_namespace *ns = fs_info->pid_ns;
 	struct inode *root_inode = d_inode(s->s_root);
 	struct dentry *thread_self;
 
@@ -62,10 +61,10 @@ int proc_setup_thread_self(struct super_block *s)
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
index 49538b1..f91a8bf 100644
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
index 9a3f6e9..8f89069 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -10,6 +10,8 @@
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
+	struct dentry *proc_self; /* For /proc/self/ */
+	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 };
 
 struct proc_dir_entry;
-- 
2.7.4
