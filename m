From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v3 7/7] proc: flush dcache entries from all procfs instances
Date: Thu,  9 Nov 2017 17:14:06 +0100
Message-ID: <1510244046-3256-8-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, me-xzjC0nNlxno@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, solar-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Flush dcache entries of a task when it terminates. The task may have
showed up in multiple procfs mounts per pid namespace, and we need to
walk the mounts and invalidate any left entires.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c                | 27 +++++++++++++++++++-----
 fs/proc/inode.c               |  9 +++++++-
 fs/proc/root.c                | 10 +++++++++
 include/linux/pid_namespace.h | 49 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h       |  2 ++
 5 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 88b92bc..27e52aa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3034,7 +3034,8 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.permission	= proc_pid_permission,
 };
 
-static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
+static void proc_flush_task_mnt_root(struct dentry *mnt_root,
+				     pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
 	char buf[PROC_NUMBUF];
@@ -3043,7 +3044,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	/* no ->d_hash() rejects on procfs */
-	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
+	dentry = d_hash_and_lookup(mnt_root, &name);
 	if (dentry) {
 		d_invalidate(dentry);
 		dput(dentry);
@@ -3054,7 +3055,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
-	leader = d_hash_and_lookup(mnt->mnt_root, &name);
+	leader = d_hash_and_lookup(mnt_root, &name);
 	if (!leader)
 		goto out;
 
@@ -3109,14 +3110,30 @@ void proc_flush_task(struct task_struct *task)
 	int i;
 	struct pid *pid, *tgid;
 	struct upid *upid;
+	struct proc_fs_info *fs_info_entry;
+	struct pid_namespace *pid_ns;
+	struct dentry *mnt_root;
 
 	pid = task_pid(task);
 	tgid = task_tgid(task);
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
-		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-					tgid->numbers[i].nr);
+		pid_ns = upid->ns;
+
+		pidns_proc_lock_shared(pid_ns);
+		list_for_each_entry(fs_info_entry, &pid_ns->procfs_mounts,
+				    pidns_entry) {
+			if (proc_fs_newinstance(fs_info_entry)) {
+				mnt_root = fs_info_entry->sb->s_root;
+				proc_flush_task_mnt_root(mnt_root, upid->nr,
+							 tgid->numbers[i].nr);
+			}
+		}
+		pidns_proc_unlock_shared(pid_ns);
+
+		mnt_root = pid_ns->proc_mnt->mnt_root;
+		proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
 	}
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2707d5f..8fcf0d7 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -484,10 +484,17 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
 	int ret;
 
-	get_pid_ns(fs_info->pid_ns);
+	fs_info->sb = s;
+
+	if (proc_fs_newinstance(fs_info)) {
+		pidns_proc_lock(ns);
+		list_add_tail(&fs_info->pidns_entry, &ns->procfs_mounts);
+		pidns_proc_unlock(ns);
+	}
 
 	if (!proc_parse_options(data, fs_info))
 		return -EINVAL;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 5cdff69..5503799 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -259,6 +259,13 @@ static void proc_kill_sb(struct super_block *sb)
 		dput(fs_info->proc_self);
 	if (fs_info->proc_thread_self)
 		dput(fs_info->proc_thread_self);
+
+	if (proc_fs_newinstance(fs_info)) {
+		pidns_proc_lock(ns);
+		list_del(&fs_info->pidns_entry);
+		pidns_proc_unlock(ns);
+	}
+
 	kill_anon_super(sb);
 	put_pid_ns(ns);
 	kfree(fs_info);
@@ -374,6 +381,9 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 		return PTR_ERR(mnt);
 
 	ns->proc_mnt = mnt;
+	init_rwsem(&ns->rw_procfs_mnts);
+	INIT_LIST_HEAD(&ns->procfs_mounts);
+
 	return 0;
 }
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 66f47f1..9a7a28d 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -26,6 +26,15 @@ struct pid_namespace {
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt; /* Internal proc mounted during each new pidns */
+
+	/* Serialize separated procfs access from super block create/destory */
+	struct rw_semaphore rw_procfs_mnts;
+
+	/*
+	 * List of separated procfs mounts, used to invalidate task dentry
+	 * from all the related procfs mounts.
+	 */
+	struct list_head procfs_mounts;
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
@@ -90,4 +99,44 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
 
+#ifdef CONFIG_PROC_FS
+static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
+{
+	down_write(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
+{
+	up_write(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
+{
+	down_read(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
+{
+	up_read(&pid_ns->rw_procfs_mnts);
+}
+#else /* !CONFIG_PROC_FS */
+
+static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
+{
+}
+
+#endif /* CONFIG_PROC_FS */
+
 #endif /* _LINUX_PID_NS_H */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 0730f52..e56fbab 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -24,7 +24,9 @@ enum { /* definitions for 'pids' mount option */
 };
 
 struct proc_fs_info {
+	struct super_block *sb;
 	struct pid_namespace *pid_ns;
+	struct list_head pidns_entry; /* Node in procfs_mounts of pidns */
 	struct dentry *proc_self; /* For /proc/self/ */
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 	bool newinstance; /* Flag for new separated instances */
-- 
2.7.4
