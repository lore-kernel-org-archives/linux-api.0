From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v4 2/5] nohz: support PR_CPU_ISOLATED_STRICT mode
Date: Mon, 13 Jul 2015 15:57:58 -0400
Message-ID: <1436817481-8732-3-git-send-email-cmetcalf@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

With cpu_isolated mode, the task is in principle guaranteed not to be
interrupted by the kernel, but only if it behaves.  In particular, if it
enters the kernel via system call, page fault, or any of a number of other
synchronous traps, it may be unexpectedly exposed to long latencies.
Add a simple flag that puts the process into a state where any such
kernel entry is fatal.

To allow the state to be entered and exited, we add an internal bit to
current->cpu_isolated_flags that is set when prctl() sets the flags.
We check the bit on syscall entry as well as on any exception_enter().
The prctl() syscall is ignored to allow clearing the bit again later,
and exit/exit_group are ignored to allow exiting the task without
a pointless signal killing you as you try to do so.

This change adds the syscall-detection hooks only for x86, arm64,
and tile.

The signature of context_tracking_exit() changes to report whether
we, in fact, are exiting back to user space, so that we can track
user exceptions properly separately from other kernel entries.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/arm64/kernel/ptrace.c       |  4 ++++
 arch/tile/kernel/ptrace.c        |  6 +++++-
 arch/x86/kernel/ptrace.c         |  2 ++
 include/linux/context_tracking.h | 11 ++++++++---
 include/linux/tick.h             | 16 ++++++++++++++++
 include/uapi/linux/prctl.h       |  1 +
 kernel/context_tracking.c        |  9 ++++++---
 kernel/time/tick-sched.c         | 38 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d882b833dbdb..7315b1579cbd 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1150,6 +1150,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
+	/* Ensure we report cpu_isolated violations in all circumstances. */
+	if (test_thread_flag(TIF_NOHZ) && tick_nohz_cpu_isolated_strict())
+		tick_nohz_cpu_isolated_syscall(regs->syscallno);
+
 	/* Do the secure computing check first; failures should be fast. */
 	if (secure_computing() == -1)
 		return -1;
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index f84eed8243da..d4e43a13bab1 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -259,8 +259,12 @@ int do_syscall_trace_enter(struct pt_regs *regs)
 	 * If TIF_NOHZ is set, we are required to call user_exit() before
 	 * doing anything that could touch RCU.
 	 */
-	if (work & _TIF_NOHZ)
+	if (work & _TIF_NOHZ) {
 		user_exit();
+		if (tick_nohz_cpu_isolated_strict())
+			tick_nohz_cpu_isolated_syscall(
+				regs->regs[TREG_SYSCALL_NR]);
+	}
 
 	if (work & _TIF_SYSCALL_TRACE) {
 		if (tracehook_report_syscall_entry(regs))
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 9be72bc3613f..860f346977e2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1479,6 +1479,8 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	if (work & _TIF_NOHZ) {
 		user_exit();
 		work &= ~_TIF_NOHZ;
+		if (tick_nohz_cpu_isolated_strict())
+			tick_nohz_cpu_isolated_syscall(regs->orig_ax);
 	}
 
 #ifdef CONFIG_SECCOMP
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index b96bd299966f..8b994e2a0330 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,7 @@
 
 #include <linux/sched.h>
 #include <linux/vtime.h>
+#include <linux/tick.h>
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
+			if (tick_nohz_cpu_isolated_strict())
+				tick_nohz_cpu_isolated_exception();
+		}
+	}
 
 	return prev_ctx;
 }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index cb5569181359..f79f6945f762 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -157,6 +157,8 @@ extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 extern void tick_nohz_cpu_isolated_enter(void);
+extern void tick_nohz_cpu_isolated_syscall(int nr);
+extern void tick_nohz_cpu_isolated_exception(void);
 #else
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
@@ -168,6 +170,8 @@ static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 static inline bool tick_nohz_is_cpu_isolated(void) { return false; }
 static inline void tick_nohz_cpu_isolated_enter(void) { }
+static inline void tick_nohz_cpu_isolated_syscall(int nr) { }
+static inline void tick_nohz_cpu_isolated_exception(void) { }
 #endif
 
 static inline bool is_housekeeping_cpu(int cpu)
@@ -200,4 +204,16 @@ static inline void tick_nohz_task_switch(struct task_struct *tsk)
 		__tick_nohz_task_switch(tsk);
 }
 
+static inline bool tick_nohz_cpu_isolated_strict(void)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (current->cpu_isolated_flags &
+	     (PR_CPU_ISOLATED_ENABLE | PR_CPU_ISOLATED_STRICT)) ==
+	    (PR_CPU_ISOLATED_ENABLE | PR_CPU_ISOLATED_STRICT))
+		return true;
+#endif
+	return false;
+}
+
 #endif
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index edb40b6b84db..0c11238a84fb 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -194,5 +194,6 @@ struct prctl_mm_map {
 #define PR_SET_CPU_ISOLATED	47
 #define PR_GET_CPU_ISOLATED	48
 # define PR_CPU_ISOLATED_ENABLE	(1 << 0)
+# define PR_CPU_ISOLATED_STRICT	(1 << 1)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index f9de3ee12723..fd051ea290ee 100644
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4cf093c012d1..9f495c7c7dc2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 
 #include <asm/irq_regs.h>
+#include <asm/unistd.h>
 
 #include "tick-internal.h"
 
@@ -446,6 +447,43 @@ void tick_nohz_cpu_isolated_enter(void)
 	}
 }
 
+static void kill_cpu_isolated_strict_task(void)
+{
+	dump_stack();
+	current->cpu_isolated_flags &= ~PR_CPU_ISOLATED_ENABLE;
+	send_sig(SIGKILL, current, 1);
+}
+
+/*
+ * This routine is called from syscall entry (with the syscall number
+ * passed in) if the _STRICT flag is set.
+ */
+void tick_nohz_cpu_isolated_syscall(int syscall)
+{
+	/* Ignore prctl() syscalls or any task exit. */
+	switch (syscall) {
+	case __NR_prctl:
+	case __NR_exit:
+	case __NR_exit_group:
+		return;
+	}
+
+	pr_warn("%s/%d: cpu_isolated strict mode violated by syscall %d\n",
+		current->comm, current->pid, syscall);
+	kill_cpu_isolated_strict_task();
+}
+
+/*
+ * This routine is called from any userspace exception if the _STRICT
+ * flag is set.
+ */
+void tick_nohz_cpu_isolated_exception(void)
+{
+	pr_warn("%s/%d: cpu_isolated strict mode violated by exception\n",
+		current->comm, current->pid);
+	kill_cpu_isolated_strict_task();
+}
+
 #endif
 
 /*
-- 
2.1.2
