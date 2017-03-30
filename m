From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC 4/4] proc: support flushing dcache entries of a task on multiple procfs mounts
Date: Thu, 30 Mar 2017 17:22:59 +0200
Message-ID: <1490887379-25880-5-git-send-email-tixxdz@gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7195-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, kirill@shutemov.name, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This allows to flush dcache entries of a task on multiple procfs mounts
per pid namespace.

Maybe this patch is nedded since this is just an optimization and maybe
it contains bugs.

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c                | 28 ++++++++++++++++++++++------
 fs/proc/inode.c               | 13 +++++++++++--
 fs/proc/root.c                | 13 +++++++++++++
 include/linux/pid_namespace.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h       |  5 +++++
 5 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index fd16566..0b96eb1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1739,7 +1739,6 @@ int pid_getattr(const struct path *path, struct kstat *stat,
 	struct task_struct *task;
 	struct inode *inode = d_inode(path->dentry);
 	struct proc_fs_info *fs_info = proc_sb(inode->i_sb);
-	struct pid_namespace *pid = fs_info->pid_ns;
 
 	generic_fillattr(inode, stat);
 
@@ -2967,7 +2966,8 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.permission	= proc_pid_permission,
 };
 
-static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
+static void proc_flush_task_mnt_root(struct dentry *mnt_root,
+				     pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
 	char buf[PROC_NUMBUF];
@@ -2976,7 +2976,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	/* no ->d_hash() rejects on procfs */
-	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
+	dentry = d_hash_and_lookup(mnt_root, &name);
 	if (dentry) {
 		d_invalidate(dentry);
 		dput(dentry);
@@ -2987,7 +2987,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
-	leader = d_hash_and_lookup(mnt->mnt_root, &name);
+	leader = d_hash_and_lookup(mnt_root, &name);
 	if (!leader)
 		goto out;
 
@@ -3042,14 +3042,30 @@ void proc_flush_task(struct task_struct *task)
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
+		pidns_procfs_lock_shared(pid_ns);
+		list_for_each_entry(fs_info_entry, &pid_ns->procfs_mounts,
+				    pidns_entry) {
+			if (proc_fs_get_unshare(fs_info_entry) == PROC_FS_V2) {
+				mnt_root = fs_info_entry->sb->s_root;
+				proc_flush_task_mnt_root(mnt_root, upid->nr,
+							 tgid->numbers[i].nr);
+			}
+		}
+		pidns_procfs_unlock_shared(pid_ns);
+
+		mnt_root = pid_ns->proc_mnt->mnt_root;
+		proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
 	}
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 5f7557d..73e49b3 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -478,10 +478,19 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 int proc_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct proc_fs_info *fs_info = proc_sb(s);
+	struct pid_namespace *ns = get_pid_ns(fs_info->pid_ns);
 	struct inode *root_inode;
-	int ret;
+	int ret, version;
 
-	get_pid_ns(fs_info->pid_ns);
+	fs_info->sb = s;
+
+	version = proc_fs_get_unshare(fs_info);
+
+	if (version == PROC_FS_V2) {
+		pidns_procfs_lock(ns);
+		list_add_tail(&fs_info->pidns_entry, &ns->procfs_mounts);
+		pidns_procfs_unlock(ns);
+	}
 
 	if (!proc_parse_options(data, fs_info))
 		return -EINVAL;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7a8f425..73f972f 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -222,6 +222,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 
 static void proc_destroy_sb(struct super_block *sb)
 {
+	int version;
 	struct proc_fs_info *fs_info = proc_sb(sb);
 	struct pid_namespace *ns = (struct pid_namespace *)fs_info->pid_ns;
 
@@ -229,6 +230,15 @@ static void proc_destroy_sb(struct super_block *sb)
 		dput(ns->proc_self);
 	if (ns->proc_thread_self)
 		dput(ns->proc_thread_self);
+
+	version = proc_fs_get_unshare(fs_info);
+
+	if (version == PROC_FS_V2) {
+		pidns_procfs_lock(ns);
+		list_del(&fs_info->pidns_entry);
+		pidns_procfs_unlock(ns);
+	}
+
 	kill_anon_super(sb);
 	put_pid_ns(ns);
 	kfree(fs_info);
@@ -352,6 +362,9 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 		return PTR_ERR(mnt);
 
 	ns->proc_mnt = mnt;
+	init_rwsem(&ns->rw_procfs_mnts);
+	INIT_LIST_HEAD(&ns->procfs_mounts);
+
 	return 0;
 }
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index c2a989d..05639c8 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -41,6 +41,8 @@ struct pid_namespace {
 	struct vfsmount *proc_mnt;
 	struct dentry *proc_self;
 	struct dentry *proc_thread_self;
+	struct rw_semaphore rw_procfs_mnts;
+	struct list_head procfs_mounts; /* list of separated procfs mounts */
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
@@ -107,4 +109,44 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pidmap_init(void);
 
+#ifdef CONFIG_PROC_FS
+static inline void pidns_procfs_lock(struct pid_namespace *pid_ns)
+{
+	down_write(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_procfs_unlock(struct pid_namespace *pid_ns)
+{
+	up_write(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_procfs_lock_shared(struct pid_namespace *pid_ns)
+{
+	down_read(&pid_ns->rw_procfs_mnts);
+}
+
+static inline void pidns_procfs_unlock_shared(struct pid_namespace *pid_ns)
+{
+	up_read(&pid_ns->rw_procfs_mnts);
+}
+#else /* !CONFIG_PROC_FS */
+
+static inline void pidns_procfs_lock(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_procfs_unlock(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_procfs_lock_shared(struct pid_namespace *pid_ns)
+{
+}
+
+static inline void pidns_procfs_unlock_shared(struct pid_namespace *pid_ns)
+{
+}
+
+#endif /* CONFIG_PROC_FS */
+
 #endif /* _LINUX_PID_NS_H */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e3a78a5..b2200e3 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -15,7 +15,12 @@ enum {
 
 struct proc_fs_info {
 	refcount_t users;
+
+	struct super_block *sb;
 	struct pid_namespace *pid_ns;
+
+	struct list_head pidns_entry; /* Node in procfs_mounts of a pidns */
+
 	kgid_t pid_gid;
 	int hide_pid;
 	int version;
-- 
2.10.2
