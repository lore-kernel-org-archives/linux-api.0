From: Christian Brauner <christian@brauner.io>
Subject: [RFC-1 PATCH 1/1] fork: add CLONE_PIDFD via /proc/<pid>
Date: Thu, 11 Apr 2019 01:40:41 +0200
Message-ID: <20190410234045.29846-2-christian@brauner.io>
References: <20190410234045.29846-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410234045.29846-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

This is an RFC for the implementation of pidfds as /proc/<pid> file
descriptors. They can be retrieved through the clone() with the addition of
the CLONE_PIDFD flag.
The tricky part here is that we need to retrieve a file descriptor for
/proc/<pid> before clone's point of no return. Otherwise, we need to fail
the creation of a process that has already passed all barriers and is
visible in userspace. Getting that file descriptor then becomes a rather
intricate dance including allocating a detached dentry that we need to
commit once attach_pid() has been called.
Note that this RFC only includes the logic we think is needed to return
/proc/<pid> file descriptors from clone. It does *not* yet include the even
more complex logic needed to restrict procfs itself. And the additional
logic needed to prevent attacks such as openat(pidfd, "..", ...) and access
to /proc/<pid>/net/.

There are a couple of reasons why we stopped short of this and decided to
sent out an RFC first.
- Even the initial part of getting file descriptors from /proc/<pid> out
  out clone() required rather complex code that struck us as very
  inelegant and heavy (which granted, might partially caused by not seeing
  a cleaner way to implement this). Thus, it felt like we needed to see
  whether this is even remotely considered acceptable.
- While discussion further aspects of this approach with Al we received
  rather substantiated opposition to exposing even more codepaths to
  procfs.
- Restricting access to procfs properly requires a lot of invasive work
  even touching core vfs functions such as
  follow_dotdot()/follow_dotdot_rcu() which also caused 2.

Jann and I are providing a second RFC alongside this one that shows an
alternative and rather much simpler approach we think might be preferable.

Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Jann Horn <jann@thejh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/proc/base.c             | 130 ++++++++++++++++++++++++++++++++++---
 fs/proc/fd.c               |   4 +-
 fs/proc/internal.h         |   2 +-
 fs/proc/namespaces.c       |   2 +-
 include/linux/proc_fs.h    |  19 ++++++
 include/uapi/linux/sched.h |   1 +
 kernel/fork.c              |  40 ++++++++++--
 7 files changed, 180 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a803a0b75df..2f5d7bd5d047 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1731,7 +1731,7 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
 	*rgid = gid;
 }
 
-struct inode *proc_pid_make_inode(struct super_block * sb,
+struct inode *proc_pid_make_inode(struct super_block * sb, struct pid *pid,
 				  struct task_struct *task, umode_t mode)
 {
 	struct inode * inode;
@@ -1753,7 +1753,7 @@ struct inode *proc_pid_make_inode(struct super_block * sb,
 	/*
 	 * grab the reference to task.
 	 */
-	ei->pid = get_task_pid(task, PIDTYPE_PID);
+	ei->pid = pid ? get_pid(pid) : get_task_pid(task, PIDTYPE_PID);
 	if (!ei->pid)
 		goto out_unlock;
 
@@ -2070,7 +2070,7 @@ proc_map_files_instantiate(struct dentry *dentry,
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFLNK |
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, S_IFLNK |
 				    ((mode & FMODE_READ ) ? S_IRUSR : 0) |
 				    ((mode & FMODE_WRITE) ? S_IWUSR : 0));
 	if (!inode)
@@ -2428,7 +2428,7 @@ static struct dentry *proc_pident_instantiate(struct dentry *dentry,
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, p->mode);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, p->mode);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
@@ -3184,12 +3184,13 @@ void proc_flush_task(struct task_struct *task)
 	}
 }
 
-static struct dentry *proc_pid_instantiate(struct dentry * dentry,
-				   struct task_struct *task, const void *ptr)
+static struct inode *proc_pid_dentry_init(struct dentry *dentry,
+					  struct task_struct *task)
 {
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task,
+				    S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
@@ -3201,9 +3202,122 @@ static struct dentry *proc_pid_instantiate(struct dentry * dentry,
 	pid_update_inode(task, inode);
 
 	d_set_d_op(dentry, &pid_dentry_operations);
+	return inode;
+}
+
+static struct dentry *proc_pid_instantiate(struct dentry * dentry,
+				   struct task_struct *task, const void *ptr)
+{
+	struct inode *inode = proc_pid_dentry_init(dentry, task);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	return d_splice_alias(inode, dentry);
 }
 
+/*
+ * Open /proc/$pid before clone()'s point of no return, i.e. before
+ * attach_pid() has been called.
+ */
+int proc_pid_open_early(struct task_struct *task, struct pid *pid,
+			struct early_proc_pid *info)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct dentry *root = ns->proc_mnt->mnt_root;
+	pid_t vpid = pid_nr_ns(pid, ns);
+	struct inode *inode;
+	char pid_str[12];
+	int res;
+
+	if (WARN_ON(vpid == 0))
+		return -ESRCH;
+
+	/*
+	 * We can't use lookup_one_len() here. When this function is called
+	 * attach_pid() will not have been called which means that
+	 * proc_pid_lookup() will fail with ENOENT as it can't successfully
+	 * find_task_by_pid_ns().
+	 * We can just use d_alloc_name() though.
+	 */
+	snprintf(pid_str, sizeof(pid_str), "%d", vpid);
+	info->dentry = d_alloc_name(root, pid_str);
+	if (IS_ERR(info->dentry))
+		return PTR_ERR(info->dentry);
+
+	info->fd = __alloc_fd(current->files, 1, rlimit(RLIMIT_NOFILE),
+			      O_CLOEXEC);
+	if (info->fd < 0) {
+		res = info->fd;
+		goto out_put_dentry;
+	}
+
+	info->tmp_dentry = d_alloc_anon(root->d_sb);
+	if (!info->tmp_dentry) {
+		res = -ENOMEM;
+		goto out_put_fd;
+	}
+
+	inode = proc_pid_dentry_init(info->tmp_dentry, task);
+	if (IS_ERR(inode)) {
+		res = PTR_ERR(inode);
+		goto out_put_tmp_dentry;
+	}
+
+	d_instantiate(info->tmp_dentry, inode);
+	info->file = file_open_root(info->tmp_dentry, ns->proc_mnt, "/",
+				    O_RDONLY | O_NOFOLLOW | O_DIRECTORY, 0);
+	if (IS_ERR(info->file)) {
+		res = PTR_ERR(info->file);
+		goto out_put_tmp_dentry;
+	}
+
+	return 0;
+
+out_put_tmp_dentry:
+	dput(info->tmp_dentry);
+
+out_put_fd:
+	put_unused_fd(info->fd);
+
+out_put_dentry:
+	dput(info->dentry);
+
+	return res;
+}
+
+void proc_pid_dentry_commit_lock(struct early_proc_pid *info)
+{
+	lock_rename(info->tmp_dentry, info->dentry->d_parent);
+}
+
+/*
+ * Commit /proc/$pid after clone()'s point of no return, and install the file
+ * descriptor.
+ * Drops the locks acquired by proc_pid_dentry_commit_lock().
+ * Returns the file descriptor.
+ */
+int proc_pid_dentry_commit_unlock(struct early_proc_pid *info)
+{
+	/* commit the dentry */
+	d_move(info->tmp_dentry, info->dentry);
+	unlock_rename(info->tmp_dentry, info->dentry->d_parent);
+
+	/* release extra references */
+	dput(info->tmp_dentry);
+	dput(info->dentry);
+
+	/* install fd */
+	fd_install(info->fd, info->file);
+	return info->fd;
+}
+
+void proc_pid_dentry_abort(struct early_proc_pid *info)
+{
+	fput(info->file);
+	dput(info->tmp_dentry);
+	put_unused_fd(info->fd);
+	dput(info->dentry);
+}
+
 struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
 {
 	struct task_struct *task;
@@ -3480,7 +3594,7 @@ static struct dentry *proc_task_instantiate(struct dentry *dentry,
 	struct task_struct *task, const void *ptr)
 {
 	struct inode *inode;
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFDIR | S_IRUGO | S_IXUGO);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, S_IFDIR | S_IRUGO | S_IXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 81882a13212d..7e624695db5a 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -186,7 +186,7 @@ static struct dentry *proc_fd_instantiate(struct dentry *dentry,
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFLNK);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, S_IFLNK);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
@@ -325,7 +325,7 @@ static struct dentry *proc_fdinfo_instantiate(struct dentry *dentry,
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFREG | S_IRUSR);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, S_IFREG | S_IRUSR);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d1671e97f7fe..9b4cb85b96be 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -159,7 +159,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(const struct path *, struct kstat *, u32, unsigned int);
 extern int proc_setattr(struct dentry *, struct iattr *);
-extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
+extern struct inode *proc_pid_make_inode(struct super_block *, struct pid *pid, struct task_struct *, umode_t);
 extern void pid_update_inode(struct task_struct *, struct inode *);
 extern int pid_delete_dentry(const struct dentry *);
 extern int proc_pid_readdir(struct file *, struct dir_context *);
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index dd2b35f78b09..b77e4234a892 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -94,7 +94,7 @@ static struct dentry *proc_ns_instantiate(struct dentry *dentry,
 	struct inode *inode;
 	struct proc_inode *ei;
 
-	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFLNK | S_IRWXUGO);
+	inode = proc_pid_make_inode(dentry->d_sb, NULL, task, S_IFLNK | S_IRWXUGO);
 	if (!inode)
 		return ERR_PTR(-ENOENT);
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 52a283ba0465..e801481a8a24 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -75,6 +75,18 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    void *data);
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
 
+struct early_proc_pid {
+	struct dentry *dentry;
+	struct dentry *tmp_dentry;
+	struct file *file;
+	int fd;
+};
+int proc_pid_open_early(struct task_struct *task, struct pid *pid,
+			struct early_proc_pid *info);
+void proc_pid_dentry_commit_lock(struct early_proc_pid *info);
+int proc_pid_dentry_commit_unlock(struct early_proc_pid *info);
+void proc_pid_dentry_abort(struct early_proc_pid *info);
+
 #else /* CONFIG_PROC_FS */
 
 static inline void proc_root_init(void)
@@ -120,6 +132,13 @@ static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
 	return ERR_PTR(-EBADF);
 }
 
+struct early_proc_pid {};
+static inline int proc_pid_open_early(struct task_struct *task,
+		struct pid *pid, struct early_proc_pid *info) { return -EINVAL; }
+void proc_pid_dentry_commit_lock(struct early_proc_pid *info) { }
+static inline int proc_pid_dentry_commit_unlock(struct early_proc_pid *info) { return -EINVAL; }
+static inline void proc_pid_dentry_abort(struct early_proc_pid *info) { }
+
 #endif /* CONFIG_PROC_FS */
 
 struct net;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..cd9bd14ce56d 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -10,6 +10,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_PIDFD	0x00001000	/* create new pid file descriptor */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9dcd18aa210b..31b405eee020 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -32,6 +32,7 @@
 #include <linux/sem.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/fsnotify.h>
 #include <linux/iocontext.h>
 #include <linux/key.h>
 #include <linux/binfmts.h>
@@ -1678,11 +1679,13 @@ static __latent_entropy struct task_struct *copy_process(
 					struct pid *pid,
 					int trace,
 					unsigned long tls,
-					int node)
+					int node,
+					int *pidfd)
 {
 	int retval;
 	struct task_struct *p;
 	struct multiprocess_signals delayed;
+	struct early_proc_pid proc_pid_info;
 
 	/*
 	 * Don't allow sharing the root directory with processes in a different
@@ -1936,6 +1939,17 @@ static __latent_entropy struct task_struct *copy_process(
 		}
 	}
 
+	/*
+	 * This has to happen after we've potentially unshared the file
+	 * descriptor table (so that the pidfd doesn't leak into the child if
+	 * the fd table isn't shared).
+	 */
+	if (clone_flags & CLONE_PIDFD) {
+		retval = proc_pid_open_early(p, pid, &proc_pid_info);
+		if (retval)
+			goto bad_fork_free_pid;
+	}
+
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1996,7 +2010,7 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	retval = cgroup_can_fork(p);
 	if (retval)
-		goto bad_fork_free_pid;
+		goto bad_fork_abort_cgroup;
 
 	/*
 	 * From this point on we must avoid any synchronous user-space
@@ -2009,6 +2023,9 @@ static __latent_entropy struct task_struct *copy_process(
 	p->start_time = ktime_get_ns();
 	p->real_start_time = ktime_get_boot_ns();
 
+	if (clone_flags & CLONE_PIDFD)
+		proc_pid_dentry_commit_lock(&proc_pid_info);
+
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
@@ -2091,12 +2108,16 @@ static __latent_entropy struct task_struct *copy_process(
 		attach_pid(p, PIDTYPE_PID);
 		nr_threads++;
 	}
+
 	total_forks++;
 	hlist_del_init(&delayed.node);
 	spin_unlock(&current->sighand->siglock);
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (clone_flags & CLONE_PIDFD)
+		*pidfd = proc_pid_dentry_commit_unlock(&proc_pid_info);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	cgroup_threadgroup_change_end(current);
@@ -2111,8 +2132,11 @@ static __latent_entropy struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	cgroup_cancel_fork(p);
-bad_fork_free_pid:
+bad_fork_abort_cgroup:
 	cgroup_threadgroup_change_end(current);
+	if (clone_flags & CLONE_PIDFD)
+		proc_pid_dentry_abort(&proc_pid_info);
+bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
 bad_fork_cleanup_thread:
@@ -2177,7 +2201,7 @@ struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
 	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0,
-			    cpu_to_node(cpu));
+			    cpu_to_node(cpu), NULL);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task);
 		init_idle(task, cpu);
@@ -2202,7 +2226,7 @@ long _do_fork(unsigned long clone_flags,
 	struct completion vfork;
 	struct pid *pid;
 	struct task_struct *p;
-	int trace = 0;
+	int trace = 0, pidfd;
 	long nr;
 
 	/*
@@ -2224,7 +2248,7 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
+			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE, &pidfd);
 	add_latent_entropy();
 
 	if (IS_ERR(p))
@@ -2260,6 +2284,10 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	put_pid(pid);
+
+	if (clone_flags & CLONE_PIDFD)
+		nr = pidfd;
+
 	return nr;
 }
 
-- 
2.21.0
