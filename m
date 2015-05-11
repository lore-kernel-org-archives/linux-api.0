From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCHv2 1/2] clone: Support passing tls argument via C rather than
 pt_regs magic
Date: Mon, 11 May 2015 12:29:19 -0700
Message-ID: <20150511192918.GA11361@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

clone with CLONE_SETTLS accepts an argument to set the thread-local
storage area for the new thread.  sys_clone declares an int argument
tls_val in the appropriate point in the argument list (based on the
various CLONE_BACKWARDS variants), but doesn't actually use or pass
along that argument.  Instead, sys_clone calls do_fork, which calls
copy_process, which calls the arch-specific copy_thread, and copy_thread
pulls the corresponding syscall argument out of the pt_regs captured at
kernel entry (knowing what argument of clone that architecture passes
tls in).

Apart from being awful and inscrutable, that also only works because
only one code path into copy_thread can pass the CLONE_SETTLS flag, and
that code path comes from sys_clone with its architecture-specific
argument-passing order.  This prevents introducing a new version of the
clone system call without propagating the same architecture-specific
position of the tls argument.

However, there's no reason to pull the argument out of pt_regs when
sys_clone could just pass it down via C function call arguments.

Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt
into, and a new copy_thread_tls that accepts the tls parameter as an
additional unsigned long (syscall-argument-sized) argument.
Change sys_clone's tls argument to an unsigned long (which does
not change the ABI), and pass that down to copy_thread_tls.

Architectures that don't opt into copy_thread_tls will continue to
ignore the C argument to sys_clone in favor of the pt_regs captured at
kernel entry, and thus will be unable to introduce new versions of the
clone syscall.

Patch co-authored by Josh Triplett and Thiago Macieira.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Acked-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/Kconfig             |  7 ++++++
 include/linux/sched.h    | 14 ++++++++++++
 include/linux/syscalls.h |  6 +++---
 kernel/fork.c            | 55 +++++++++++++++++++++++++++++++-----------------
 4 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 05d7a8a..4834a58 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -484,6 +484,13 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
 	  This spares a stack switch and improves cache usage on softirq
 	  processing.
 
+config HAVE_COPY_THREAD_TLS
+	bool
+	help
+	  Architecture provides copy_thread_tls to accept tls argument via
+	  normal C parameter passing, rather than extracting the syscall
+	  argument from pt_regs.
+
 #
 # ABI hall of shame
 #
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a419b65..2cc88c6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2480,8 +2480,22 @@ extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
 
+#ifdef CONFIG_HAVE_COPY_THREAD_TLS
+extern int copy_thread_tls(unsigned long, unsigned long, unsigned long,
+			struct task_struct *, unsigned long);
+#else
 extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *);
+
+/* Architectures that haven't opted into copy_thread_tls get the tls argument
+ * via pt_regs, so ignore the tls argument passed via C. */
+static inline int copy_thread_tls(
+		unsigned long clone_flags, unsigned long sp, unsigned long arg,
+		struct task_struct *p, unsigned long tls)
+{
+	return copy_thread(clone_flags, sp, arg, p);
+}
+#endif
 extern void flush_thread(void);
 extern void exit_thread(void);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 76d1e38..bb51bec 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -827,15 +827,15 @@ asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_fork(void);
 asmlinkage long sys_vfork(void);
 #ifdef CONFIG_CLONE_BACKWARDS
-asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
+asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, unsigned long,
 	       int __user *);
 #else
 #ifdef CONFIG_CLONE_BACKWARDS3
 asmlinkage long sys_clone(unsigned long, unsigned long, int, int __user *,
-			  int __user *, int);
+			  int __user *, unsigned long);
 #else
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
-	       int __user *, int);
+	       int __user *, unsigned long);
 #endif
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..b3dadf4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1192,7 +1192,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					unsigned long stack_size,
 					int __user *child_tidptr,
 					struct pid *pid,
-					int trace)
+					int trace,
+					unsigned long tls)
 {
 	int retval;
 	struct task_struct *p;
@@ -1401,7 +1402,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	retval = copy_io(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
-	retval = copy_thread(clone_flags, stack_start, stack_size, p);
+	retval = copy_thread_tls(clone_flags, stack_start, stack_size, p, tls);
 	if (retval)
 		goto bad_fork_cleanup_io;
 
@@ -1613,7 +1614,7 @@ static inline void init_idle_pids(struct pid_link *links)
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0);
+	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1628,11 +1629,13 @@ struct task_struct *fork_idle(int cpu)
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-long do_fork(unsigned long clone_flags,
-	      unsigned long stack_start,
-	      unsigned long stack_size,
-	      int __user *parent_tidptr,
-	      int __user *child_tidptr)
+static long _do_fork(
+		unsigned long clone_flags,
+		unsigned long stack_start,
+		unsigned long stack_size,
+		int __user *parent_tidptr,
+		int __user *child_tidptr,
+		unsigned long tls)
 {
 	struct task_struct *p;
 	int trace = 0;
@@ -1657,7 +1660,7 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, trace, tls);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1698,20 +1701,34 @@ long do_fork(unsigned long clone_flags,
 	return nr;
 }
 
+#ifndef CONFIG_HAVE_COPY_THREAD_TLS
+/* For compatibility with architectures that call do_fork directly rather than
+ * using the syscall entry points below. */
+long do_fork(unsigned long clone_flags,
+	      unsigned long stack_start,
+	      unsigned long stack_size,
+	      int __user *parent_tidptr,
+	      int __user *child_tidptr)
+{
+	return _do_fork(clone_flags, stack_start, stack_size,
+			parent_tidptr, child_tidptr, 0);
+}
+#endif
+
 /*
  * Create a kernel thread.
  */
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
-	return do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
-		(unsigned long)arg, NULL, NULL);
+	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
+		(unsigned long)arg, NULL, NULL, 0);
 }
 
 #ifdef __ARCH_WANT_SYS_FORK
 SYSCALL_DEFINE0(fork)
 {
 #ifdef CONFIG_MMU
-	return do_fork(SIGCHLD, 0, 0, NULL, NULL);
+	return _do_fork(SIGCHLD, 0, 0, NULL, NULL, 0);
 #else
 	/* can not support in nommu mode */
 	return -EINVAL;
@@ -1722,8 +1739,8 @@ SYSCALL_DEFINE0(fork)
 #ifdef __ARCH_WANT_SYS_VFORK
 SYSCALL_DEFINE0(vfork)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
-			0, NULL, NULL);
+	return _do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
+			0, NULL, NULL, 0);
 }
 #endif
 
@@ -1731,27 +1748,27 @@ SYSCALL_DEFINE0(vfork)
 #ifdef CONFIG_CLONE_BACKWARDS
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
-		 int, tls_val,
+		 unsigned long, tls,
 		 int __user *, child_tidptr)
 #elif defined(CONFIG_CLONE_BACKWARDS2)
 SYSCALL_DEFINE5(clone, unsigned long, newsp, unsigned long, clone_flags,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
-		 int, tls_val)
+		 unsigned long, tls)
 #elif defined(CONFIG_CLONE_BACKWARDS3)
 SYSCALL_DEFINE6(clone, unsigned long, clone_flags, unsigned long, newsp,
 		int, stack_size,
 		int __user *, parent_tidptr,
 		int __user *, child_tidptr,
-		int, tls_val)
+		unsigned long, tls)
 #else
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
-		 int, tls_val)
+		 unsigned long, tls)
 #endif
 {
-	return do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr);
+	return _do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr, tls);
 }
 #endif
 
-- 
2.1.4
