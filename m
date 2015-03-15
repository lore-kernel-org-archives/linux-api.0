From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 4/7] kernel/fork.c: Pass arguments to _do_fork and
 copy_process using clone4_args
Date: Sun, 15 Mar 2015 00:59:54 -0700
Message-ID: <2d46fa8e483396f7db99266886c996acb01ded35.1426376419.git.josh@joshtriplett.org>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Rather than continuing to add arguments to _do_fork and copy_process for
future clone4 extensions, with corresponding churn in every caller, pass
the arguments using the clone4_args structure instead.  This allows
clone4 to avoid unpacking the arguments, and allows other callers to use
C99 structure initializers to only initialize the arguments they care
about.  Future extensions to clone4_args will thus not need to touch
clone4, fork, vfork, or other callers of _do_fork.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 kernel/fork.c | 77 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8a21f9e..db9012a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1188,12 +1188,9 @@ init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
  * flags). The actual kick-off is left to the caller.
  */
 static struct task_struct *copy_process(u64 clone_flags,
-					unsigned long stack_start,
-					unsigned long stack_size,
-					int __user *child_tidptr,
+					struct clone4_args *args,
 					struct pid *pid,
-					int trace,
-					unsigned long tls)
+					int trace)
 {
 	int retval;
 	struct task_struct *p;
@@ -1405,7 +1402,7 @@ static struct task_struct *copy_process(u64 clone_flags,
 	retval = copy_io(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
-	retval = copy_thread_tls(clone_flags, stack_start, stack_size, p, tls);
+	retval = copy_thread_tls(clone_flags, args->stack_start, args->stack_size, p, args->tls);
 	if (retval)
 		goto bad_fork_cleanup_io;
 
@@ -1416,11 +1413,11 @@ static struct task_struct *copy_process(u64 clone_flags,
 			goto bad_fork_cleanup_io;
 	}
 
-	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
+	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? args->ctid : NULL;
 	/*
 	 * Clear TID on mm_release()?
 	 */
-	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr : NULL;
+	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->ctid : NULL;
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1617,7 +1614,8 @@ static inline void init_idle_pids(struct pid_link *links)
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0);
+	struct clone4_args args = {};
+	task = copy_process(CLONE_VM, &args, &init_struct_pid, 0);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1632,13 +1630,7 @@ struct task_struct *fork_idle(int cpu)
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-static long _do_fork(
-		u64 clone_flags,
-		unsigned long stack_start,
-		unsigned long stack_size,
-		int __user *parent_tidptr,
-		int __user *child_tidptr,
-		unsigned long tls)
+static long _do_fork(u64 clone_flags, struct clone4_args *args)
 {
 	struct task_struct *p;
 	int trace = 0;
@@ -1662,8 +1654,7 @@ static long _do_fork(
 			trace = 0;
 	}
 
-	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls);
+	p = copy_process(clone_flags, args, NULL, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1678,7 +1669,7 @@ static long _do_fork(
 		nr = pid_vnr(pid);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
-			put_user(nr, parent_tidptr);
+			put_user(nr, args->ptid);
 
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
@@ -1722,9 +1713,13 @@ long do_fork(unsigned long clone_flags,
 	      int __user *parent_tidptr,
 	      int __user *child_tidptr)
 {
-	return _do_fork(squelch_clone_flags(clone_flags),
-			stack_start, stack_size,
-			parent_tidptr, child_tidptr, 0);
+	struct clone4_args kargs = {
+		.ptid = parent_tidptr,
+		.ctid = child_tidptr,
+		.stack_start = stack_start,
+		.stack_start = stack_size,
+	};
+	return _do_fork(squelch_clone_flags(clone_flags), &kargs);
 }
 #endif
 
@@ -1733,15 +1728,19 @@ long do_fork(unsigned long clone_flags,
  */
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
-	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
-		(unsigned long)arg, NULL, NULL, 0);
+	struct clone4_args kargs = {
+		.stack_start = (unsigned long)fn,
+		.stack_size = (unsigned long)arg,
+	};
+	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, &kargs);
 }
 
 #ifdef __ARCH_WANT_SYS_FORK
 SYSCALL_DEFINE0(fork)
 {
 #ifdef CONFIG_MMU
-	return _do_fork(SIGCHLD, 0, 0, NULL, NULL, 0);
+	struct clone4_args kargs = {};
+	return _do_fork(SIGCHLD, &kargs);
 #else
 	/* can not support in nommu mode */
 	return -EINVAL;
@@ -1752,8 +1751,8 @@ SYSCALL_DEFINE0(fork)
 #ifdef __ARCH_WANT_SYS_VFORK
 SYSCALL_DEFINE0(vfork)
 {
-	return _do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 0,
-			0, NULL, NULL, 0);
+	struct clone4_args kargs = {};
+	return _do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, &kargs);
 }
 #endif
 
@@ -1781,8 +1780,13 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 unsigned long, tls)
 #endif
 {
-	return _do_fork(squelch_clone_flags(clone_flags), newsp, 0,
-			parent_tidptr, child_tidptr, tls);
+	struct clone4_args kargs = {
+		.ptid = parent_tidptr,
+		.ctid = child_tidptr,
+		.stack_start = newsp,
+		.tls = tls,
+	};
+	return _do_fork(squelch_clone_flags(clone_flags), &kargs);
 }
 #endif
 
@@ -1796,8 +1800,7 @@ SYSCALL_DEFINE4(clone4, unsigned, flags_high, unsigned, flags_low,
 		return -EINVAL;
 	if (args_size && copy_from_user(&kargs, args, args_size))
 		return -EFAULT;
-	return _do_fork(flags, kargs.stack_start, kargs.stack_size,
-			kargs.ptid, kargs.ctid, kargs.tls);
+	return _do_fork(flags, &kargs);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1807,15 +1810,17 @@ COMPAT_SYSCALL_DEFINE4(clone4, unsigned, flags_high, unsigned, flags_low,
 {
 	u64 flags = (u64)flags_high << 32 | flags_low;
 	struct compat_clone4_args compat_kargs = {};
+	struct clone4_args kargs = {};
 	if (args_size > sizeof(compat_kargs))
 		return -EINVAL;
 	if (args_size && copy_from_user(&compat_kargs, args, args_size))
 		return -EFAULT;
-	return _do_fork(flags, compat_kargs.stack_start,
-			compat_kargs.stack_size,
-			compat_ptr(compat_kargs.ptid),
-			compat_ptr(compat_kargs.ctid),
-			compat_kargs.tls);
+	kargs.ptid = compat_ptr(compat_kargs.ptid);
+	kargs.ctid = compat_ptr(compat_kargs.ctid);
+	kargs.stack_start = compat_kargs.stack_start;
+	kargs.stack_size = compat_kargs.stack_size;
+	kargs.tls = compat_kargs.tls;
+	return _do_fork(flags, &kargs);
 }
 #endif /* CONFIG_COMPAT */
 #endif /* CONFIG_CLONE4 */
-- 
2.1.4
