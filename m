From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 07/11] proc: flush task dcache entries from all procfs instances
Date: Sat, 25 Jan 2020 14:05:37 +0100
Message-ID: <20200125130541.450409-8-gladkov.alexey@gmail.com>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200125130541.450409-1-gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Solar Designer <solar-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This allows to flush dcache entries of a task on multiple procfs mounts
per pid namespace.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c                | 23 ++++++++++++++-----
 fs/proc/root.c                | 14 ++++++++++++
 include/linux/pid_namespace.h | 42 +++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h       |  2 ++
 4 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4ccb280a3e79..f4f1bcb28603 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3133,7 +3133,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.permission	= proc_pid_permission,
 };
 
-static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
+static void proc_flush_task_mnt_root(struct dentry *mnt_root, pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
 	char buf[10 + 1];
@@ -3142,7 +3142,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	/* no ->d_hash() rejects on procfs */
-	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
+	dentry = d_hash_and_lookup(mnt_root, &name);
 	if (dentry) {
 		d_invalidate(dentry);
 		dput(dentry);
@@ -3153,7 +3153,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
-	leader = d_hash_and_lookup(mnt->mnt_root, &name);
+	leader = d_hash_and_lookup(mnt_root, &name);
 	if (!leader)
 		goto out;
 
@@ -3208,14 +3208,27 @@ void proc_flush_task(struct task_struct *task)
 	int i;
 	struct pid *pid, *tgid;
 	struct upid *upid;
+	struct pid_namespace *pid_ns;
+	struct dentry *mnt_root;
+	struct proc_fs_info *fs_info;
 
 	pid = task_pid(task);
 	tgid = task_tgid(task);
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
-		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-					tgid->numbers[i].nr);
+
+		pid_ns = upid->ns;
+
+		pidns_proc_lock_shared(pid_ns);
+		list_for_each_entry(fs_info, &pid_ns->proc_mounts, pidns_entry) {
+			mnt_root = fs_info->m_super->s_root;
+			proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
+		}
+		pidns_proc_unlock_shared(pid_ns);
+
+		mnt_root = pid_ns->proc_mnt->mnt_root;
+		proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
 	}
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 5d5cba4c899b..3bb8df360cf7 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -112,6 +112,12 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 
 	proc_apply_options(ctx->fs_info, fc, pid_ns, current_user_ns());
 
+	ctx->fs_info->m_super = s;
+
+	pidns_proc_lock(pid_ns);
+	list_add_tail(&ctx->fs_info->pidns_entry, &pid_ns->proc_mounts);
+	pidns_proc_unlock(pid_ns);
+
 	/* User space would break if executables or devices appear on proc */
 	s->s_iflags |= SB_I_USERNS_VISIBLE | SB_I_NOEXEC | SB_I_NODEV;
 	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
@@ -215,6 +221,11 @@ static void proc_kill_sb(struct super_block *sb)
 		dput(fs_info->proc_self);
 	if (fs_info->proc_thread_self)
 		dput(fs_info->proc_thread_self);
+
+	pidns_proc_lock(fs_info->pid_ns);
+	list_del(&fs_info->pidns_entry);
+	pidns_proc_unlock(fs_info->pid_ns);
+
 	kill_anon_super(sb);
 	put_pid_ns(fs_info->pid_ns);
 	kfree(fs_info);
@@ -336,6 +347,9 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 		ctx->fs_info->pid_ns = ns;
 	}
 
+	init_rwsem(&ns->rw_proc_mounts);
+	INIT_LIST_HEAD(&ns->proc_mounts);
+
 	mnt = fc_mount(fc);
 	put_fs_context(fc);
 	if (IS_ERR(mnt))
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 66f47f1afe0d..297b39604312 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -26,6 +26,8 @@ struct pid_namespace {
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt; /* Internal proc mounted during each new pidns */
+	struct rw_semaphore rw_proc_mounts;
+	struct list_head proc_mounts; /* list of separated procfs mounts */
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
@@ -90,4 +92,44 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
 
+#ifdef CONFIG_PROC_FS
+static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
+{
+	down_write(&pid_ns->rw_proc_mounts);
+}
+
+static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
+{
+	up_write(&pid_ns->rw_proc_mounts);
+}
+
+static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
+{
+	down_read(&pid_ns->rw_proc_mounts);
+}
+
+static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
+{
+	up_read(&pid_ns->rw_proc_mounts);
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
index 5f0b1b7e4271..f307940f8311 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -20,6 +20,8 @@ enum {
 };
 
 struct proc_fs_info {
+	struct list_head pidns_entry;    /* Node in procfs_mounts of a pidns */
+	struct super_block *m_super;
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
-- 
2.24.1
