From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Sun, 14 Apr 2019 22:14:34 +0200
Message-ID: <20190414201436.19502-3-christian@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190414201436.19502-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

As discussed this patchset makes it possible to retrieve pid file
descriptors at process creation time by introducing the new flag
CLONE_PIDFD to the clone() system call. Linus originally suggested to
implement this as a new flag to clone() instead of making it a separate
system call. As spotted by Linus, there is exactly one bit for clone()
left.

CLONE_PIDFD returns file descriptors based on the anonymous inode
implementation in the kernel that will also be used to implement the new
mount api. They serve as a simple opaque handle on pids. Logically, this
makes it possible to interpret a pidfd differently, narrowing or widening
the scope of various operations (e.g. signal sending). Thus, a pidfd cannot
just refer to a tgid, but also a tid, or in theory - given appropriate flag
arguments in relevant syscalls - a process group or session. A pidfd does
not represent a privilege. This does not imply it cannot ever be that way
but for now this is not the case.

A pidfd comes with additional information in fdinfo if the kernel supports
procfs. The fdinfo file contains the pid of the process in the callers pid
namespace in the same format as the procfs status file, i.e. "Pid:\t%d".

To remove worries about missing metadata access this patchset comes with a
sample program that illustrates how a combination of CLONE_PIDFD, fdinfo,
and pidfd_send_signal() can be used to gain race-free access to process
metadata through /proc/<pid>. The sample program can easily be translated
into a helper that would be suitable for inclusion in libc so that users
don't have to worry about writing it themselves.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Jann Horn <jann@thejh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/pid.h        |   2 +
 include/uapi/linux/sched.h |   1 +
 kernel/fork.c              | 117 +++++++++++++++++++++++++++++++++++--
 3 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index b6f4ba16065a..3c8ef5a199ca 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -66,6 +66,8 @@ struct pid
 
 extern struct pid init_struct_pid;
 
+extern const struct file_operations pidfd_fops;
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..06fa224d2c48 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -10,6 +10,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_PIDFD	0x00001000	/* set if a pidfd instead of a pid should be returned */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9dcd18aa210b..4825d5205604 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/anon_inodes.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -21,8 +22,10 @@
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
+#include <linux/seq_file.h>
 #include <linux/rtmutex.h>
 #include <linux/init.h>
+#include <linux/fsnotify.h>
 #include <linux/unistd.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
@@ -1662,6 +1665,87 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
+static int pidfd_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+
+	file->private_data = NULL;
+	put_pid(pid);
+	return 0;
+}
+
+#ifdef CONFIG_PROC_FS
+static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct pid_namespace *ns = proc_pid_ns(file_inode(m->file));
+	struct pid *pid = f->private_data;
+
+	seq_put_decimal_ull(m, "Pid:\t", pid_nr_ns(pid, ns));
+	seq_putc(m, '\n');
+}
+#endif
+
+const struct file_operations pidfd_fops = {
+	.release = pidfd_release,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo = pidfd_show_fdinfo,
+#endif
+};
+
+/**
+ * pidfd_create() - Create a new pid file descriptor.
+ *
+ * @pid:  struct pid that the pidfd will reference
+ * @file: struct file referencing @pid to return to caller
+ *
+ * This creates a new pid file descriptor with the O_CLOEXEC flag set.
+ *
+ * Note, that this function can only be called after the fd table has
+ * potentially been shared to avoid leaking the pidfd to the new process.
+ *
+ * File descriptor numbering for pidfds starts at 1. This allows users
+ * of CLONE_PIDFD to perform the same checks as for pids, i.e.:
+ * pid/pidfd <  0: error
+ * pid/pidfd == 0: child
+ * pid/pidfd >  0: parent
+ *
+ * Return: On success, a cloexec pidfd ready to be installed through
+ *         fd_install() will be returned. The corresponding file will be
+ *         returned through @file.
+ *         On error, a negative errno number will be returned.
+ */
+static int pidfd_create(struct pid *pid, struct file **file)
+{
+	unsigned int flags = O_RDWR | O_CLOEXEC;
+	int error, fd;
+	struct file *f;
+
+	error = __alloc_fd(current->files, 1, rlimit(RLIMIT_NOFILE), flags);
+	if (error < 0)
+		return error;
+	fd = error;
+
+	f = anon_inode_getfile("pidfd", &pidfd_fops, get_pid(pid), flags);
+	if (IS_ERR(f)) {
+		put_pid(pid);
+		error = PTR_ERR(f);
+		goto err_put_unused_fd;
+	}
+
+	*file = f;
+	return fd;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+	return error;
+}
+
+static inline void pidfd_put(int fd, struct file *file)
+{
+	put_unused_fd(fd);
+	fput(file);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1678,11 +1762,12 @@ static __latent_entropy struct task_struct *copy_process(
 					struct pid *pid,
 					int trace,
 					unsigned long tls,
-					int node)
+					int node, int *pidfd)
 {
 	int retval;
 	struct task_struct *p;
 	struct multiprocess_signals delayed;
+	struct file *pidfdf = NULL;
 
 	/*
 	 * Don't allow sharing the root directory with processes in a different
@@ -1936,6 +2021,18 @@ static __latent_entropy struct task_struct *copy_process(
 		}
 	}
 
+	/*
+	 * This has to happen after we've potentially unshared the file
+	 * descriptor table (so that the pidfd doesn't leak into the child if
+	 * the fd table isn't shared).
+	 */
+	if (clone_flags & CLONE_PIDFD) {
+		retval = pidfd_create(pid, &pidfdf);
+		if (retval < 0)
+			goto bad_fork_free_pid;
+		*pidfd = retval;
+	}
+
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1996,7 +2093,7 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	retval = cgroup_can_fork(p);
 	if (retval)
-		goto bad_fork_free_pid;
+		goto bad_fork_put_pidfd;
 
 	/*
 	 * From this point on we must avoid any synchronous user-space
@@ -2097,6 +2194,9 @@ static __latent_entropy struct task_struct *copy_process(
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (clone_flags & CLONE_PIDFD)
+		fd_install(*pidfd, pidfdf);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	cgroup_threadgroup_change_end(current);
@@ -2111,6 +2211,9 @@ static __latent_entropy struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	cgroup_cancel_fork(p);
+bad_fork_put_pidfd:
+	if (clone_flags & CLONE_PIDFD)
+		pidfd_put(*pidfd, pidfdf);
 bad_fork_free_pid:
 	cgroup_threadgroup_change_end(current);
 	if (pid != &init_struct_pid)
@@ -2177,7 +2280,7 @@ struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
 	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0,
-			    cpu_to_node(cpu));
+			    cpu_to_node(cpu), NULL);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task);
 		init_idle(task, cpu);
@@ -2202,7 +2305,7 @@ long _do_fork(unsigned long clone_flags,
 	struct completion vfork;
 	struct pid *pid;
 	struct task_struct *p;
-	int trace = 0;
+	int pidfd, trace = 0;
 	long nr;
 
 	/*
@@ -2224,7 +2327,7 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
+			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE, &pidfd);
 	add_latent_entropy();
 
 	if (IS_ERR(p))
@@ -2260,6 +2363,10 @@ long _do_fork(unsigned long clone_flags,
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
