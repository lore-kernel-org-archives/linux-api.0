From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v7 03/11] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Mon, 28 Sep 2015 11:17:18 -0400
Message-ID: <1443453446-7827-4-git-send-email-cmetcalf@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

With task_isolation mode, the task is in principle guaranteed not to
be interrupted by the kernel, but only if it behaves.  In particular,
if it enters the kernel via system call, page fault, or any of a
number of other synchronous traps, it may be unexpectedly exposed
to long latencies.  Add a simple flag that puts the process into
a state where any such kernel entry is fatal; this is defined as
happening immediately after the SECCOMP test.

To allow the state to be entered and exited, we ignore the prctl()
syscall so that we can clear the bit again later, and we ignore
exit/exit_group to allow exiting the task without a pointless signal
killing you as you try to do so.

The signature of context_tracking_exit() changes to report whether
we, in fact, are exiting back to user space, so that we can track
user exceptions properly separately from other kernel entries.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/linux/context_tracking.h | 11 ++++++++---
 include/linux/isolation.h        | 16 ++++++++++++++++
 include/uapi/linux/prctl.h       |  1 +
 kernel/context_tracking.c        |  9 ++++++---
 kernel/isolation.c               | 41 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 008fc67d0d96..a840374f5d29 100644
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
index 67224df4b559..2b8038b0d1e1 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -201,5 +201,6 @@ struct prctl_mm_map {
 #define PR_SET_TASK_ISOLATION		48
 #define PR_GET_TASK_ISOLATION		49
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
+# define PR_TASK_ISOLATION_STRICT	(1 << 1)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 0a495ab35bc7..ffca3c3fe64a 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -144,15 +144,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
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
@@ -166,6 +167,7 @@ void context_tracking_exit(enum ctx_state state)
 			 */
 			rcu_user_exit();
 			if (state == CONTEXT_USER) {
+				from_user = true;
 				vtime_user_exit(current);
 				trace_user_exit(0);
 			}
@@ -175,6 +177,7 @@ void context_tracking_exit(enum ctx_state state)
 	context_tracking_recursion_exit();
 out_irq_restore:
 	local_irq_restore(flags);
+	return from_user;
 }
 NOKPROBE_SYMBOL(context_tracking_exit);
 EXPORT_SYMBOL_GPL(context_tracking_exit);
diff --git a/kernel/isolation.c b/kernel/isolation.c
index 6ace866c69f6..3779ba670472 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/swap.h>
 #include <linux/vmstat.h>
 #include <linux/isolation.h>
+#include <asm/unistd.h>
 #include "time/tick-sched.h"
 
 /*
@@ -75,3 +76,43 @@ void task_isolation_enter(void)
 		dump_stack();
 	}
 }
+
+static void kill_task_isolation_strict_task(void)
+{
+	/* RCU should have been enabled prior to this point. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
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
