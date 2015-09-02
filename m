From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6.2 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Wed, 2 Sep 2015 14:38:21 -0400
Message-ID: <1441219101-30402-1-git-send-email-cmetcalf@ezchip.com>
References: <20150902101347.GF25720@arm.com> <CALCETrXQY3PvLaZXQgN1bw5s7JP6LZSZzChRziFenAiQWA3XpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150902101347.GF25720-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This change updates just one patch of the patch series, so rather than
spamming out the whole series again, I've just updated this patch:

- Will Deacon suggested using IS_ENABLED(CONFIG_TASK_ISOLATION) and
  also recommended having the same ordering between SECCOMP and
  TASK_ISOLATION on all platforms, an excellent suggestion.

- Andy Lutomirski suggested using rcu_lockdep_assert(rcu_is_watching())
  to ensure RCU was properly turned back on during our syscall
  test-and-kill for strict mode.

I will update a full PATCH v7 once there seem to be no further
comments on the rest of the v6 series.

--
From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Date: Tue, 28 Jul 2015 13:25:46 -0400
Subject: [PATCH v6.2 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT mode

With task_isolation mode, the task is in principle guaranteed not to
be interrupted by the kernel, but only if it behaves.  In particular,
if it enters the kernel via system call, page fault, or any of a
number of other synchronous traps, it may be unexpectedly exposed
to long latencies.  Add a simple flag that puts the process into
a state where any such kernel entry is fatal.

To allow the state to be entered and exited, we ignore the prctl()
syscall so that we can clear the bit again later, and we ignore
exit/exit_group to allow exiting the task without a pointless signal
killing you as you try to do so.

This change adds the syscall-detection hooks only for x86, arm64,
and tile.  We specify that it happens immediately after the
SECCOMP test, which appropriately should be tested first.

The signature of context_tracking_exit() changes to report whether
we, in fact, are exiting back to user space, so that we can track
user exceptions properly separately from other kernel entries.

Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/kernel/ptrace.c       |  6 ++++++
 arch/tile/kernel/ptrace.c        |  5 ++++-
 arch/x86/kernel/ptrace.c         | 10 +++++++++-
 include/linux/context_tracking.h | 11 ++++++++---
 include/linux/isolation.h        | 16 ++++++++++++++++
 include/uapi/linux/prctl.h       |  1 +
 kernel/context_tracking.c        |  9 ++++++---
 kernel/isolation.c               | 41 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d882b833dbdb..737f62db8a6f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -37,6 +37,7 @@
 #include <linux/regset.h>
 #include <linux/tracehook.h>
 #include <linux/elf.h>
+#include <linux/isolation.h>
 
 #include <asm/compat.h>
 #include <asm/debug-monitors.h>
@@ -1154,6 +1155,11 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	if (secure_computing() == -1)
 		return -1;
 
+	if (IS_ENABLED(CONFIG_TASK_ISOLATION) &&
+	    test_thread_flag(TIF_NOHZ) &&
+	    task_isolation_strict())
+		task_isolation_syscall(regs->syscallno);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index f84eed8243da..c327cb918a44 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -259,8 +259,11 @@ int do_syscall_trace_enter(struct pt_regs *regs)
 	 * If TIF_NOHZ is set, we are required to call user_exit() before
 	 * doing anything that could touch RCU.
 	 */
-	if (work & _TIF_NOHZ)
+	if (work & _TIF_NOHZ) {
 		user_exit();
+		if (task_isolation_strict())
+			task_isolation_syscall(regs->regs[TREG_SYSCALL_NR]);
+	}
 
 	if (work & _TIF_SYSCALL_TRACE) {
 		if (tracehook_report_syscall_entry(regs))
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 9be72bc3613f..821699513a94 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1478,7 +1478,8 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	 */
 	if (work & _TIF_NOHZ) {
 		user_exit();
-		work &= ~_TIF_NOHZ;
+		if (!IS_ENABLED(CONFIG_TASK_ISOLATION))
+			work &= ~_TIF_NOHZ;
 	}
 
 #ifdef CONFIG_SECCOMP
@@ -1527,6 +1528,13 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	}
 #endif
 
+	/* Now check task isolation, if needed. */
+	if (IS_ENABLED(CONFIG_TASK_ISOLATION) && (work & _TIF_NOHZ)) {
+		work &= ~_TIF_NOHZ;
+		if (task_isolation_strict())
+			task_isolation_syscall(regs->orig_ax);
+	}
+
 	/* Do our best to finish without phase 2. */
 	if (work == 0)
 		return ret;  /* seccomp and/or nohz only (ret == 0 here) */
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index b96bd299966f..e0ac0228fea1 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,7 @@
 
 #include <linux/sched.h>
 #include <linux/vtime.h>
+#include <linux/isolation.h>
 #include <linux/context_tracking_state.h>
 #include <asm/ptrace.h>
 
@@ -11,7 +12,7 @@
 extern void context_tracking_cpu_set(int cpu);
 
 extern void context_tracking_enter(enum ctx_state state);
-extern void context_tracking_exit(enum ctx_state state);
+extern bool context_tracking_exit(enum ctx_state state);
 extern void context_tracking_user_enter(void);
 extern void context_tracking_user_exit(void);
 
@@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
 		return 0;
 
 	prev_ctx = this_cpu_read(context_tracking.state);
-	if (prev_ctx != CONTEXT_KERNEL)
-		context_tracking_exit(prev_ctx);
+	if (prev_ctx != CONTEXT_KERNEL) {
+		if (context_tracking_exit(prev_ctx)) {
+			if (task_isolation_strict())
+				task_isolation_exception();
+		}
+	}
 
 	return prev_ctx;
 }
diff --git a/include/linux/isolation.h b/include/linux/isolation.h
index fd04011b1c1e..27a4469831c1 100644
--- a/include/linux/isolation.h
+++ b/include/linux/isolation.h
@@ -15,10 +15,26 @@ static inline bool task_isolation_enabled(void)
 }
 
 extern void task_isolation_enter(void);
+extern void task_isolation_syscall(int nr);
+extern void task_isolation_exception(void);
 extern void task_isolation_wait(void);
 #else
 static inline bool task_isolation_enabled(void) { return false; }
 static inline void task_isolation_enter(void) { }
+static inline void task_isolation_syscall(int nr) { }
+static inline void task_isolation_exception(void) { }
 #endif
 
+static inline bool task_isolation_strict(void)
+{
+#ifdef CONFIG_TASK_ISOLATION
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (current->task_isolation_flags &
+	     (PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_STRICT)) ==
+	    (PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_STRICT))
+		return true;
+#endif
+	return false;
+}
+
 #endif
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 79da784fe17a..e16e13911e8a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -194,5 +194,6 @@ struct prctl_mm_map {
 #define PR_SET_TASK_ISOLATION		47
 #define PR_GET_TASK_ISOLATION		48
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
+# define PR_TASK_ISOLATION_STRICT	(1 << 1)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index c57c99f5c4d7..17a71f7b66b8 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -147,15 +147,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
  * This call supports re-entrancy. This way it can be called from any exception
  * handler without needing to know if we came from userspace or not.
  */
-void context_tracking_exit(enum ctx_state state)
+bool context_tracking_exit(enum ctx_state state)
 {
 	unsigned long flags;
+	bool from_user = false;
 
 	if (!context_tracking_is_enabled())
-		return;
+		return false;
 
 	if (in_interrupt())
-		return;
+		return false;
 
 	local_irq_save(flags);
 	if (!context_tracking_recursion_enter())
@@ -169,6 +170,7 @@ void context_tracking_exit(enum ctx_state state)
 			 */
 			rcu_user_exit();
 			if (state == CONTEXT_USER) {
+				from_user = true;
 				vtime_user_exit(current);
 				trace_user_exit(0);
 			}
@@ -178,6 +180,7 @@ void context_tracking_exit(enum ctx_state state)
 	context_tracking_recursion_exit();
 out_irq_restore:
 	local_irq_restore(flags);
+	return from_user;
 }
 NOKPROBE_SYMBOL(context_tracking_exit);
 EXPORT_SYMBOL_GPL(context_tracking_exit);
diff --git a/kernel/isolation.c b/kernel/isolation.c
index d4618cd9e23d..caa40583fe0b 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/swap.h>
 #include <linux/vmstat.h>
 #include <linux/isolation.h>
+#include <asm/unistd.h>
 #include "time/tick-sched.h"
 
 /*
@@ -73,3 +74,43 @@ void task_isolation_enter(void)
 		dump_stack();
 	}
 }
+
+static void kill_task_isolation_strict_task(void)
+{
+	/* RCU should have been enabled prior to checking the syscall. */
+	rcu_lockdep_assert(rcu_is_watching(), "syscall entry without RCU");
+
+	dump_stack();
+	current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
+	send_sig(SIGKILL, current, 1);
+}
+
+/*
+ * This routine is called from syscall entry (with the syscall number
+ * passed in) if the _STRICT flag is set.
+ */
+void task_isolation_syscall(int syscall)
+{
+	/* Ignore prctl() syscalls or any task exit. */
+	switch (syscall) {
+	case __NR_prctl:
+	case __NR_exit:
+	case __NR_exit_group:
+		return;
+	}
+
+	pr_warn("%s/%d: task_isolation strict mode violated by syscall %d\n",
+		current->comm, current->pid, syscall);
+	kill_task_isolation_strict_task();
+}
+
+/*
+ * This routine is called from any userspace exception if the _STRICT
+ * flag is set.
+ */
+void task_isolation_exception(void)
+{
+	pr_warn("%s/%d: task_isolation strict mode violated by exception\n",
+		current->comm, current->pid);
+	kill_task_isolation_strict_task();
+}
-- 
2.1.2
