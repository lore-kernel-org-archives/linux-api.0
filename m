From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [PATCH v5 6/7] proc: flush task dcache entries from all procfs
 instances
Date: Fri, 11 May 2018 11:36:45 +0200
Message-ID: <20180511093645.GA1365@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Djalal Harouni <tixxdz@gmail.com>

This allows to flush dcache entries of a task on multiple procfs mounts
per pid namespace.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c                | 27 ++++++++++++++++++++++-----
 fs/proc/inode.c               |  9 ++++++++-
 fs/proc/root.c                | 10 ++++++++++
 include/linux/pid_namespace.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h       |  2 ++
 5 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 31baeef..987d702 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3068,7 +3068,8 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
 	.permission	= proc_pid_permission,
 };
 
-static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
+static void proc_flush_task_mnt_root(struct dentry *mnt_root,
+				     pid_t pid, pid_t tgid)
 {
 	struct dentry *dentry, *leader, *dir;
 	char buf[10 + 1];
@@ -3077,7 +3078,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%u", pid);
 	/* no ->d_hash() rejects on procfs */
-	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
+	dentry = d_hash_and_lookup(mnt_root, &name);
 	if (dentry) {
 		d_invalidate(dentry);
 		dput(dentry);
@@ -3088,7 +3089,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
-	leader = d_hash_and_lookup(mnt->mnt_root, &name);
+	leader = d_hash_and_lookup(mnt_root, &name);
 	if (!leader)
 		goto out;
 
@@ -3143,14 +3144,30 @@ void proc_flush_task(struct task_struct *task)
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
index 985df4b..5e62598 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -498,10 +498,17 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
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
index c5ce241..c72d22c 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -249,6 +249,13 @@ static void proc_kill_sb(struct super_block *sb)
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
@@ -357,6 +364,9 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 		return PTR_ERR(mnt);
 
 	ns->proc_mnt = mnt;
+	init_rwsem(&ns->rw_procfs_mnts);
+	INIT_LIST_HEAD(&ns->procfs_mounts);
+
 	return 0;
 }
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index f91a8bf..767fc96 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -32,6 +32,8 @@ struct pid_namespace {
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt; /* Internal proc mounted during each new pidns */
+	struct rw_semaphore rw_procfs_mnts;
+	struct list_head procfs_mounts; /* list of separated procfs mounts */
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
@@ -98,4 +100,44 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
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
index 2d16d0e..70e8b10 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -19,7 +19,9 @@ enum { /* definitions for proc mount option limit_pids */
 };
 
 struct proc_fs_info {
+	struct super_block *sb;
 	struct pid_namespace *pid_ns;
+	struct list_head pidns_entry; /* Node in procfs_mounts of a pidns */
 	struct dentry *proc_self; /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self/ */
 	bool newinstance; /* Private flag for new separated instances */
-- 
2.10.5
