From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Thu, 12 Mar 2015 18:41:05 -0700
Message-ID: <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
References: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426180120.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

When passed CLONE_FD, clone4 will return a file descriptor rather than a
PID.  When the child process exits, it gets automatically reaped, and
the file descriptor becomes readable, producing a structure containing
the exit code and user/system time.  The file descriptor also works in
epoll, poll, or select.

This allows libraries to safely launch and manage child processes on
behalf of a caller, without taking over or interfering with process-wide
signal handling.  Without this, such a library would need to take over
or cooperate with the entire process's SIGCHLD handling, either via a
signal handler or a signalfd.

CLONE_FD will never return a file descriptor in the 0-2 range; thus, a 0
return from clone4 still indicates the child process.

Since a process created with CLONE_FD does not send any exit signal, the
low byte of the clone flags no longer needs to contain a signal number,
freeing it up for use as CLONE_FD-specific flags; use that to provide
the usual CLOEXEC and NONBLOCK flags.

CLONE_FD takes the value of the unused CLONE_PID, so CLONE4_VALID_ARGS
now includes CLONE_FD; CLONE_VALID_ARGS still doesn't, and sys_clone
still ignores that flag, as only clone4 can use it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 include/linux/sched.h      |   5 ++
 include/uapi/linux/sched.h |  23 ++++++++-
 init/Kconfig               |  11 ++++
 kernel/Makefile            |   1 +
 kernel/clonefd.c           | 123 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/clonefd.h           |  27 ++++++++++
 kernel/exit.c              |  10 +++-
 kernel/fork.c              |  40 ++++++++++++---
 8 files changed, 231 insertions(+), 9 deletions(-)
 create mode 100644 kernel/clonefd.c
 create mode 100644 kernel/clonefd.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 668c58f..55cf10bb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1351,6 +1351,9 @@ struct task_struct {
 #if defined(SPLIT_RSS_COUNTING)
 	struct task_rss_stat	rss_stat;
 #endif
+#ifdef CONFIG_CLONEFD
+	wait_queue_head_t clonefd_wqh;
+#endif
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
@@ -1372,6 +1375,8 @@ struct task_struct {
 	unsigned memcg_kmem_skip_account:1;
 #endif
 
+	unsigned autoreap:1; /* Do not become a zombie on exit */
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	struct restart_block restart_block;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index b5b8012..d2082c61 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -38,10 +38,31 @@
 #define CLONE_STOPPED	0x02000000
 
 /*
+ * Flags that only work with clone4.
+ */
+#define CLONE_FD	0x00001000	/* set if we want a file descriptor rather than a PID */
+
+/*
  * Valid flags for clone and for clone4
  */
 #define CLONE_VALID_FLAGS	(0xffffffffULL & ~(CLONE_PID | CLONE_DETACHED | CLONE_STOPPED))
-#define CLONE4_VALID_FLAGS	CLONE_VALID_FLAGS
+#define CLONE4_VALID_FLAGS	(CLONE_VALID_FLAGS | CLONE_FD)
+
+/*
+ * Flags passed in the low byte when using CLONE_FD, in place of the signal.
+ */
+#define CLONEFD_CLOEXEC		0x00000001	/* Used with CLONE_FD to set O_CLOEXEC on new fd */
+#define CLONEFD_NONBLOCK	0x00000002	/* Used with CLONE_FD to set O_NONBLOCK on new fd */
+
+/*
+ * Structure read from CLONE_FD file descriptor after process exits
+ */
+struct clonefd_info {
+        __s32 code;
+        __s32 status;
+        __u64 utime;
+        __u64 stime;
+};
 
 /*
  * Structure passed to clone4 for additional arguments.  Initialized to 0,
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
index 0000000..78fb776
--- /dev/null
+++ b/kernel/clonefd.c
@@ -0,0 +1,123 @@
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
+	return p->exit_state == EXIT_DEAD ? (POLLIN | POLLRDNORM) : 0;
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
+		ret = wait_event_interruptible(p->clonefd_wqh, p->exit_state == EXIT_DEAD);
+
+	if (p->exit_state == EXIT_DEAD) {
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
+	if (p->autoreap)
+		wake_up_all(&p->clonefd_wqh);
+}
+
+/* Handle the CLONE_FD case for copy_process. */
+int clonefd_do_clone(u64 clone_flags, struct task_struct *p, struct clonefd_setup *setup)
+{
+	int flags;
+	struct file *file;
+	int fd;
+
+	if (!(clone_flags & CLONE_FD))
+		return 0;
+
+	p->autoreap = 1;
+	init_waitqueue_head(&p->clonefd_wqh);
+
+	get_task_struct(p);
+	flags = O_RDONLY | FMODE_ATOMIC_POS
+	      | (clone_flags & CLONEFD_CLOEXEC ? O_CLOEXEC : 0)
+	      | (clone_flags & CLONEFD_NONBLOCK ? O_NONBLOCK : 0);
+	file = anon_inode_getfile("[process]", &clonefd_fops, p, flags);
+	if (IS_ERR(file)) {
+		put_task_struct(p);
+		return PTR_ERR(file);
+	}
+
+	/*
+	 * We avoid allocating a low fd so that clone can still return 0 in the
+	 * child; the child shouldn't have to change just because the parent
+	 * used CLONE_FD.
+	 */
+	fd = alloc_fd(3, flags);
+	if (fd < 0) {
+		fput(file);
+		return fd;
+	}
+
+	setup->fd = fd;
+	setup->file = file;
+
+	return 0;
+}
+
+/* Clean up clonefd information after a partially complete clone */
+void clonefd_cleanup_failed_clone(struct task_struct *p, struct clonefd_setup *setup)
+{
+	if (setup->fd)
+		put_unused_fd(setup->fd);
+	if (setup->file)
+		fput(setup->file);
+}
+
+/* Finish setting up the clonefd */
+int clonefd_install_fd(struct task_struct *p, struct clonefd_setup *setup)
+{
+	fd_install(setup->fd, setup->file);
+	return setup->fd;
+}
diff --git a/kernel/clonefd.h b/kernel/clonefd.h
new file mode 100644
index 0000000..07bd31f
--- /dev/null
+++ b/kernel/clonefd.h
@@ -0,0 +1,27 @@
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
+int clonefd_do_clone(u64 clone_flags, struct task_struct *p, struct clonefd_setup *setup);
+void clonefd_cleanup_failed_clone(struct task_struct *p, struct clonefd_setup *setup);
+int clonefd_install_fd(struct task_struct *p, struct clonefd_setup *setup);
+void clonefd_do_notify(struct task_struct *p);
+#else /* CONFIG_CLONEFD */
+struct clonefd_setup {};
+static inline int clonefd_do_clone(u64 clone_flags, struct task_struct *p, struct clonefd_setup *setup) { return 0; }
+static inline void clonefd_cleanup_failed_clone (struct task_struct *p, struct clonefd_setup *setup) {}
+static inline int clonefd_install_fd(struct task_struct *p, struct clonefd_setup *setup) { return -EINVAL; }
+static inline void clonefd_do_notify(struct task_struct *p) {}
+#endif /* CONFIG_CLONEFD */
diff --git a/kernel/exit.c b/kernel/exit.c
index feff10b..a2c8520 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -59,6 +59,8 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+#include "clonefd.h"
+
 static void exit_mm(struct task_struct *tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
@@ -598,7 +600,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
-	if (unlikely(tsk->ptrace)) {
+	if (tsk->autoreap) {
+		autoreap = true;
+	} else if (unlikely(tsk->ptrace)) {
 		int sig = thread_group_leader(tsk) &&
 				thread_group_empty(tsk) &&
 				!ptrace_reparented(tsk) ?
@@ -612,8 +616,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	}
 
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
-	if (tsk->exit_state == EXIT_DEAD)
+	if (tsk->exit_state == EXIT_DEAD) {
 		list_add(&tsk->ptrace_entry, &dead);
+		clonefd_do_notify(tsk);
+	}
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
diff --git a/kernel/fork.c b/kernel/fork.c
index e29edea..00cab05 100644
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
@@ -321,6 +323,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (err)
 		goto free_ti;
 
+	tsk->autoreap = 0;
+
 	tsk->stack = ti;
 #ifdef CONFIG_SECCOMP
 	/*
@@ -1193,7 +1197,8 @@ static struct task_struct *copy_process(u64 clone_flags,
 					int __user *child_tidptr,
 					struct pid *pid,
 					int trace,
-					unsigned long tls)
+					unsigned long tls,
+					struct clonefd_setup *clonefd_setup)
 {
 	int retval;
 	struct task_struct *p;
@@ -1244,6 +1249,16 @@ static struct task_struct *copy_process(u64 clone_flags,
 			return ERR_PTR(-EINVAL);
 	}
 
+	/*
+	 * If using CLONE_FD, the low byte is used for additional flags; check
+	 * for unknown flags.
+	 */
+	if (clone_flags & CLONE_FD) {
+		if (!IS_ENABLED(CONFIG_CLONEFD) ||
+		    (clone_flags & CSIGNAL & ~(CLONEFD_CLOEXEC | CLONEFD_NONBLOCK)))
+			return ERR_PTR(-EINVAL);
+	}
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
@@ -1416,6 +1431,10 @@ static struct task_struct *copy_process(u64 clone_flags,
 			goto bad_fork_cleanup_io;
 	}
 
+	retval = clonefd_do_clone(clone_flags, p, clonefd_setup);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1456,7 +1475,9 @@ static struct task_struct *copy_process(u64 clone_flags,
 		p->group_leader = current->group_leader;
 		p->tgid = current->tgid;
 	} else {
-		if (clone_flags & CLONE_PARENT)
+		if (clone_flags & CLONE_FD)
+			p->exit_signal = 0;
+		else if (clone_flags & CLONE_PARENT)
 			p->exit_signal = current->group_leader->exit_signal;
 		else
 			p->exit_signal = (clone_flags & CSIGNAL);
@@ -1508,7 +1529,7 @@ static struct task_struct *copy_process(u64 clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cleanup_clonefd;
 	}
 
 	if (likely(p->pid)) {
@@ -1560,6 +1581,8 @@ static struct task_struct *copy_process(u64 clone_flags,
 
 	return p;
 
+bad_fork_cleanup_clonefd:
+	clonefd_cleanup_failed_clone(p, clonefd_setup);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
@@ -1617,7 +1640,7 @@ static inline void init_idle_pids(struct pid_link *links)
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0);
+	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0, NULL);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1643,6 +1666,7 @@ static long _do_fork(
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	struct clonefd_setup clonefd_setup = {};
 
 	/*
 	 * Determine whether and which event to report to ptracer.  When
@@ -1653,7 +1677,8 @@ static long _do_fork(
 	if (!(clone_flags & CLONE_UNTRACED)) {
 		if (clone_flags & CLONE_VFORK)
 			trace = PTRACE_EVENT_VFORK;
-		else if ((clone_flags & CSIGNAL) != SIGCHLD)
+		else if ((clone_flags & CLONE_FD) ||
+			 (clone_flags & CSIGNAL) != SIGCHLD)
 			trace = PTRACE_EVENT_CLONE;
 		else
 			trace = PTRACE_EVENT_FORK;
@@ -1663,7 +1688,7 @@ static long _do_fork(
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls);
+			 child_tidptr, NULL, trace, tls, &clonefd_setup);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1686,6 +1711,9 @@ static long _do_fork(
 			get_task_struct(p);
 		}
 
+		if (clone_flags & CLONE_FD)
+			nr = clonefd_install_fd(p, &clonefd_setup);
+
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
-- 
2.1.4
