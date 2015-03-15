From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 7/7] clone4: Add a CLONE_FD flag to get task exit
 notification via fd
Date: Sun, 15 Mar 2015 01:00:20 -0700
Message-ID: <fdec4b70c7cd34e2eacf6a0e41d36f606a696da1.1426376419.git.josh@joshtriplett.org>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

When passed CLONE_FD, clone4 hands the caller a file descriptor
referring to the new process.  When the new process exits, the file
descriptor becomes readable, producing a structure containing the exit
status, exit code, and user/system times.  The file descriptor also
works in epoll, poll, and select.

This allows libraries to safely launch and manage child processes on
behalf of a caller, without taking over or interfering with process-wide
signal handling.  Without this, such a library would need to take over
or cooperate with the entire process's SIGCHLD handling, either via a
signal handler or a signalfd.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 include/linux/compat.h     |   2 +
 include/linux/sched.h      |   5 ++
 include/uapi/linux/sched.h |  16 +++++-
 init/Kconfig               |  11 +++++
 kernel/Makefile            |   1 +
 kernel/clonefd.c           | 121 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/clonefd.h           |  32 ++++++++++++
 kernel/exit.c              |   4 ++
 kernel/fork.c              |  22 +++++++--
 9 files changed, 209 insertions(+), 5 deletions(-)
 create mode 100644 kernel/clonefd.c
 create mode 100644 kernel/clonefd.h

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 6c4a68d..c90df5a 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -299,6 +299,8 @@ struct compat_clone4_args {
 	compat_ulong_t stack_start;
 	compat_ulong_t stack_size;
 	compat_ulong_t tls;
+	compat_uptr_t clonefd;
+	u32 clonefd_flags;
 };
 
 struct compat_statfs;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9daa017..1dc680b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1374,6 +1374,11 @@ struct task_struct {
 
 	unsigned autoreap:1; /* Do not become a zombie on exit */
 
+#ifdef CONFIG_CLONEFD
+	unsigned clonefd:1; /* Notify clonefd_wqh on exit */
+	wait_queue_head_t clonefd_wqh;
+#endif
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	struct restart_block restart_block;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index f606c0a..86627f0 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -41,6 +41,7 @@
  * Flags that only work with clone4.
  */
 #define CLONE_AUTOREAP	0x00001000	/* Automatically reap the process */
+#define CLONE_FD	0x00400000	/* Signal exit via file descriptor */
 
 #ifdef __KERNEL__
 /*
@@ -48,10 +49,21 @@
  * list above, but not exposed to userspace.
  */
 #define CLONE_VALID_FLAGS	(0xffffffffULL & ~(CLONE_PID | CLONE_DETACHED | CLONE_STOPPED))
-#define CLONE4_VALID_FLAGS	(CLONE_VALID_FLAGS | CLONE_AUTOREAP)
+#define CLONE4_VALID_FLAGS	(CLONE_VALID_FLAGS | CLONE_AUTOREAP | \
+				 (IS_ENABLED(CONFIG_CLONEFD) ? CLONE_FD : 0))
 #endif /* __KERNEL__ */
 
 /*
+ * Structure read from CLONE_FD file descriptor after process exits
+ */
+struct clonefd_info {
+	__s32 code;
+	__s32 status;
+	__u64 utime;
+	__u64 stime;
+};
+
+/*
  * Structure passed to clone4 for additional arguments.  Initialized to 0,
  * then overwritten with arguments from userspace, so arguments not supplied by
  * userspace will remain 0.  New versions of the kernel may safely append new
@@ -63,6 +75,8 @@ struct clone4_args {
 	__kernel_ulong_t stack_start;
 	__kernel_ulong_t stack_size;
 	__kernel_ulong_t tls;
+	int __user *clonefd;
+	__u32 clonefd_flags;
 };
 
 /*
diff --git a/init/Kconfig b/init/Kconfig
index 3ab6649..b444280 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1521,6 +1521,17 @@ config CLONE4
 
 	  If unsure, say Y.
 
+config CLONEFD
+	bool "Enable CLONE_FD flag for clone4()" if EXPERT
+	depends on CLONE4
+	select ANON_INODES
+	default y
+	help
+	  Enable the CLONE_FD flag for clone4(), which creates a file descriptor
+	  to receive child exit events rather than receiving a signal.
+
+	  If unsure, say Y.
+
 # syscall, maps, verifier
 config BPF_SYSCALL
 	bool "Enable bpf() system call" if EXPERT
diff --git a/kernel/Makefile b/kernel/Makefile
index 1408b33..368986c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -29,6 +29,7 @@ obj-y += rcu/
 obj-y += livepatch/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
+obj-$(CONFIG_CLONEFD) += clonefd.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/clonefd.c b/kernel/clonefd.c
new file mode 100644
index 0000000..eac560c
--- /dev/null
+++ b/kernel/clonefd.c
@@ -0,0 +1,121 @@
+/*
+ * Support functions for CLONE_FD
+ *
+ * Copyright (c) 2015 Intel Corporation
+ * Original authors: Josh Triplett <josh@joshtriplett.org>
+ *                   Thiago Macieira <thiago@macieira.org>
+ */
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include "clonefd.h"
+
+static int clonefd_release(struct inode *inode, struct file *file)
+{
+	put_task_struct(file->private_data);
+	return 0;
+}
+
+static unsigned int clonefd_poll(struct file *file, poll_table *wait)
+{
+	struct task_struct *p = file->private_data;
+	poll_wait(file, &p->clonefd_wqh, wait);
+	return p->exit_state ? (POLLIN | POLLRDNORM | POLLHUP) : 0;
+}
+
+static ssize_t clonefd_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct task_struct *p = file->private_data;
+	int ret = 0;
+
+	/* EOF after first read */
+	if (*ppos)
+		return 0;
+
+	if (file->f_flags & O_NONBLOCK)
+		ret = -EAGAIN;
+	else
+		ret = wait_event_interruptible(p->clonefd_wqh, p->exit_state);
+
+	if (p->exit_state) {
+		struct clonefd_info info = {};
+		cputime_t utime, stime;
+		task_exit_code_status(p->exit_code, &info.code, &info.status);
+		info.code &= ~__SI_MASK;
+		task_cputime(p, &utime, &stime);
+		info.utime = cputime_to_clock_t(utime + p->signal->utime);
+		info.stime = cputime_to_clock_t(stime + p->signal->stime);
+		ret = simple_read_from_buffer(buf, count, ppos, &info, sizeof(info));
+	}
+	return ret;
+}
+
+static struct file_operations clonefd_fops = {
+	.release = clonefd_release,
+	.poll = clonefd_poll,
+	.read = clonefd_read,
+	.llseek = no_llseek,
+};
+
+/* Do process exit notification for clonefd. */
+void clonefd_do_notify(struct task_struct *p)
+{
+	if (p->clonefd)
+		wake_up_all(&p->clonefd_wqh);
+}
+
+/* Handle the CLONE_FD case for copy_process. */
+int clonefd_do_clone(u64 clone_flags, struct task_struct *p,
+		     struct clone4_args *args, struct clonefd_setup *setup)
+{
+	int flags;
+	struct file *file;
+	int fd;
+
+	p->clonefd = !!(clone_flags & CLONE_FD);
+	if (!p->clonefd)
+		return 0;
+
+	if (args->clonefd_flags & ~(O_CLOEXEC | O_NONBLOCK))
+		return -EINVAL;
+
+	init_waitqueue_head(&p->clonefd_wqh);
+
+	get_task_struct(p);
+	flags = O_RDONLY | FMODE_ATOMIC_POS | args->clonefd_flags;
+	file = anon_inode_getfile("[process]", &clonefd_fops, p, flags);
+	if (IS_ERR(file)) {
+		put_task_struct(p);
+		return PTR_ERR(file);
+	}
+
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0) {
+		fput(file);
+		return fd;
+	}
+
+	setup->fd = fd;
+	setup->file = file;
+	return 0;
+}
+
+/* Clean up clonefd information after a partially complete clone */
+void clonefd_cleanup_failed_clone(struct clonefd_setup *setup)
+{
+	if (setup->file) {
+		put_unused_fd(setup->fd);
+		fput(setup->file);
+	}
+}
+
+/* Finish setting up the clonefd */
+void clonefd_install_fd(struct clone4_args *args, struct clonefd_setup *setup)
+{
+	if (setup->file) {
+		fd_install(setup->fd, setup->file);
+		put_user(setup->fd, args->clonefd);
+	}
+}
diff --git a/kernel/clonefd.h b/kernel/clonefd.h
new file mode 100644
index 0000000..2d8a67c
--- /dev/null
+++ b/kernel/clonefd.h
@@ -0,0 +1,32 @@
+/*
+ * Support functions for CLONE_FD
+ *
+ * Copyright (c) 2015 Intel Corporation
+ * Original authors: Josh Triplett <josh@joshtriplett.org>
+ *                   Thiago Macieira <thiago@macieira.org>
+ */
+#pragma once
+
+#include <linux/sched.h>
+
+#ifdef CONFIG_CLONEFD
+struct clonefd_setup {
+	int fd;
+	struct file *file;
+};
+int clonefd_do_clone(u64 clone_flags, struct task_struct *p,
+		     struct clone4_args *args, struct clonefd_setup *setup);
+void clonefd_cleanup_failed_clone(struct clonefd_setup *setup);
+void clonefd_install_fd(struct clone4_args *args, struct clonefd_setup *setup);
+void clonefd_do_notify(struct task_struct *p);
+#else /* CONFIG_CLONEFD */
+struct clonefd_setup {};
+static inline int clonefd_do_clone(u64 clone_flags, struct task_struct *p,
+				   struct clone4_args *args, struct clonefd_setup *setup)
+{
+	return 0;
+}
+static inline void clonefd_cleanup_failed_clone(struct clonefd_setup *setup) {}
+static inline void clonefd_install_fd(struct clone4_args *args, struct clonefd_setup *setup) {}
+static inline void clonefd_do_notify(struct task_struct *p) {}
+#endif /* CONFIG_CLONEFD */
diff --git a/kernel/exit.c b/kernel/exit.c
index feff10b..83278b8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -59,6 +59,8 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+#include "clonefd.h"
+
 static void exit_mm(struct task_struct *tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
@@ -615,6 +617,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (tsk->exit_state == EXIT_DEAD)
 		list_add(&tsk->ptrace_entry, &dead);
 
+	clonefd_do_notify(tsk);
+
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
 		wake_up_process(tsk->signal->group_exit_task);
diff --git a/kernel/fork.c b/kernel/fork.c
index c297e5e..8fdf0ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -87,6 +87,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/task.h>
 
+#include "clonefd.h"
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -1190,7 +1192,8 @@ init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
 static struct task_struct *copy_process(u64 clone_flags,
 					struct clone4_args *args,
 					struct pid *pid,
-					int trace)
+					int trace,
+					struct clonefd_setup *clonefd_setup)
 {
 	int retval;
 	struct task_struct *p;
@@ -1413,6 +1416,10 @@ static struct task_struct *copy_process(u64 clone_flags,
 			goto bad_fork_cleanup_io;
 	}
 
+	retval = clonefd_do_clone(clone_flags, p, args, clonefd_setup);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? args->ctid : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1507,7 +1514,7 @@ static struct task_struct *copy_process(u64 clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cleanup_clonefd;
 	}
 
 	if (likely(p->pid)) {
@@ -1559,6 +1566,8 @@ static struct task_struct *copy_process(u64 clone_flags,
 
 	return p;
 
+bad_fork_cleanup_clonefd:
+	clonefd_cleanup_failed_clone(clonefd_setup);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
@@ -1617,7 +1626,7 @@ struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
 	struct clone4_args args = {};
-	task = copy_process(CLONE_VM, &args, &init_struct_pid, 0);
+	task = copy_process(CLONE_VM, &args, &init_struct_pid, 0, NULL);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1637,6 +1646,7 @@ static long _do_fork(u64 clone_flags, struct clone4_args *args)
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	struct clonefd_setup clonefd_setup = {};
 
 	/*
 	 * Determine whether and which event to report to ptracer.  When
@@ -1656,7 +1666,7 @@ static long _do_fork(u64 clone_flags, struct clone4_args *args)
 			trace = 0;
 	}
 
-	p = copy_process(clone_flags, args, NULL, trace);
+	p = copy_process(clone_flags, args, NULL, trace, &clonefd_setup);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1679,6 +1689,8 @@ static long _do_fork(u64 clone_flags, struct clone4_args *args)
 			get_task_struct(p);
 		}
 
+		clonefd_install_fd(args, &clonefd_setup);
+
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
@@ -1822,6 +1834,8 @@ COMPAT_SYSCALL_DEFINE4(clone4, unsigned, flags_high, unsigned, flags_low,
 	kargs.stack_start = compat_kargs.stack_start;
 	kargs.stack_size = compat_kargs.stack_size;
 	kargs.tls = compat_kargs.tls;
+	kargs.clonefd = compat_ptr(compat_kargs.clonefd);
+	kargs.clonefd_flags = compat_kargs.clonefd_flags;
 	return _do_fork(flags, &kargs);
 }
 #endif /* CONFIG_COMPAT */
-- 
2.1.4
