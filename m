From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v6.1 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Fri, 28 Aug 2015 11:31:21 -0400
Message-ID: <1440775881-21631-1-git-send-email-cmetcalf@ezchip.com>
References: <20150826103651.GA30466@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150826103651.GA30466@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

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
and tile.  For arm64 we use an explict #ifdef CONFIG_TASK_ISOLATION
so we can both achieve no overhead for !TASK_ISOLATION, but also
achieve low latency (test TIF_NOHZ first) for TASK_ISOLATION.

The signature of context_tracking_exit() changes to report whether
we, in fact, are exiting back to user space, so that we can track
user exceptions properly separately from other kernel entries.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
This "v6.1" is just a tweak to the existing v6 series to reflect
Will Deacon's suggestions about the arm64 syscall entry code.
I've updated the git tree with this updated patch in the series.
A more disruptive change would be to capture the thread flags
up front like x86 and tile, which allows the test itself to be
optimized away if the task_isolation call becomes a no-op.

 arch/arm64/kernel/ptrace.c       |  6 ++++++
 arch/tile/kernel/ptrace.c        |  5 ++++-
 arch/x86/kernel/ptrace.c         |  2 ++
 include/linux/context_tracking.h | 11 ++++++++---
 include/linux/isolation.h        | 16 ++++++++++++++++
 include/uapi/linux/prctl.h       |  1 +
 kernel/context_tracking.c        |  9 ++++++---
 kernel/isolation.c               | 38 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d882b833dbdb..5d4284445f70 100644
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
 
+#ifdef CONFIG_TASK_ISOLATION
+	if (test_thread_flag(TIF_NOHZ) && task_isolation_strict())
+		task_isolation_syscall(regs->syscallno);
+#endif
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
index 9be72bc3613f..2f9ce9466daf 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1479,6 +1479,8 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	if (work & _TIF_NOHZ) {
 		user_exit();
 		work &= ~_TIF_NOHZ;
+		if (task_isolation_strict())
+			task_isolation_syscall(regs->orig_ax);
 	}
 
 #ifdef CONFIG_SECCOMP
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
index d4618cd9e23d..a89a6e9adfb4 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/swap.h>
 #include <linux/vmstat.h>
 #include <linux/isolation.h>
+#include <asm/unistd.h>
 #include "time/tick-sched.h"
 
 /*
@@ -73,3 +74,40 @@ void task_isolation_enter(void)
 		dump_stack();
 	}
 }
+
+static void kill_task_isolation_strict_task(void)
+{
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

