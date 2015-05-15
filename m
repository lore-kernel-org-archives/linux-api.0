From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v2 2/5] nohz: support PR_CPU_ISOLATED_STRICT mode
Date: Fri, 15 May 2015 17:27:28 -0400
Message-ID: <1431725251-20943-2-git-send-email-cmetcalf@ezchip.com>
References: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com>
 <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
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

This change adds the syscall-detection hooks only for x86 and tile;
I am happy to try to add more for additional platforms in the final
version.

The signature of context_tracking_exit() changes to report whether
we, in fact, are exiting back to user space, so that we can track
user exceptions properly separately from other kernel entries.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/kernel/ptrace.c        |  6 +++++-
 arch/x86/kernel/ptrace.c         |  2 ++
 include/linux/context_tracking.h | 11 ++++++++---
 include/linux/tick.h             | 16 ++++++++++++++++
 include/uapi/linux/prctl.h       |  1 +
 kernel/context_tracking.c        |  9 ++++++---
 kernel/time/tick-sched.c         | 38 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 76 insertions(+), 7 deletions(-)

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
index a7bc79480719..7f784054ddea 100644
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
index 2821838256b4..d042f4cda39d 100644
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
 extern void __context_tracking_task_switch(struct task_struct *prev,
@@ -37,8 +38,12 @@ static inline enum ctx_state exception_enter(void)
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
index ec1953474a65..b7ffb10337ba 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -147,6 +147,8 @@ extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 extern void tick_nohz_cpu_isolated_enter(void);
+extern void tick_nohz_cpu_isolated_syscall(int nr);
+extern void tick_nohz_cpu_isolated_exception(void);
 #else
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
@@ -157,6 +159,8 @@ static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 static inline bool tick_nohz_is_cpu_isolated(void) { return false; }
 static inline void tick_nohz_cpu_isolated_enter(void) { }
+static inline void tick_nohz_cpu_isolated_syscall(int nr) { }
+static inline void tick_nohz_cpu_isolated_exception(void) { }
 #endif
 
 static inline bool is_housekeeping_cpu(int cpu)
@@ -189,4 +193,16 @@ static inline void tick_nohz_task_switch(struct task_struct *tsk)
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
index 66739d7c1350..c82509caa42e 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -131,15 +131,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
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
 	if (__this_cpu_read(context_tracking.state) == state) {
@@ -150,6 +151,7 @@ void context_tracking_exit(enum ctx_state state)
 			 */
 			rcu_user_exit();
 			if (state == CONTEXT_USER) {
+				from_user = true;
 				vtime_user_exit(current);
 				trace_user_exit(0);
 			}
@@ -157,6 +159,7 @@ void context_tracking_exit(enum ctx_state state)
 		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
 	}
 	local_irq_restore(flags);
+	return from_user;
 }
 NOKPROBE_SYMBOL(context_tracking_exit);
 EXPORT_SYMBOL_GPL(context_tracking_exit);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f1551c946c45..273820cd484a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 
 #include <asm/irq_regs.h>
+#include <asm/unistd.h>
 
 #include "tick-internal.h"
 
@@ -440,6 +441,43 @@ void tick_nohz_cpu_isolated_enter(void)
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
