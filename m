From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v2 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 15 May 2015 17:27:27 -0400
Message-ID: <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com>
References: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

The existing nohz_full mode makes tradeoffs to minimize userspace
interruptions while still attempting to avoid overheads in the
kernel entry/exit path, to provide 100% kernel semantics, etc.

However, some applications require a stronger commitment from the
kernel to avoid interruptions, in particular userspace device
driver style applications, such as high-speed networking code.

This change introduces a framework to allow applications to elect
to have the stronger semantics as needed, specifying
prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
Subsequent commits will add additional flags and additional
semantics.

The "cpu_isolated" state is indicated by setting a new task struct
field, cpu_isolated_flags, to the value passed by prctl().  When the
_ENABLE bit is set for a task, and it is returning to userspace
on a nohz_full core, it calls the new tick_nohz_cpu_isolated_enter()
routine to take additional actions to help the task avoid being
interrupted in the future.

Initially, there are only two actions taken.  First, the task
calls lru_add_drain() to prevent being interrupted by a subsequent
lru_add_drain_all() call on another core.  Then, the code checks for
pending timer interrupts and quiesces until they are no longer pending.
As a result, sys calls (and page faults, etc.) can be inordinately slow.
However, this quiescing guarantees that no unexpected interrupts will
occur, even if the application intentionally calls into the kernel.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/linux/sched.h      |  3 +++
 include/linux/tick.h       | 10 +++++++++
 include/uapi/linux/prctl.h |  5 +++++
 kernel/context_tracking.c  |  3 +++
 kernel/sys.c               |  8 ++++++++
 kernel/time/tick-sched.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 80 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8222ae40ecb0..fb4ba400d7e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1732,6 +1732,9 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+	unsigned int	cpu_isolated_flags;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index f8492da57ad3..ec1953474a65 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -10,6 +10,7 @@
 #include <linux/context_tracking_state.h>
 #include <linux/cpumask.h>
 #include <linux/sched.h>
+#include <linux/prctl.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void __init tick_init(void);
@@ -134,11 +135,18 @@ static inline bool tick_nohz_full_cpu(int cpu)
 	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
 }
 
+static inline bool tick_nohz_is_cpu_isolated(void)
+{
+	return tick_nohz_full_cpu(smp_processor_id()) &&
+		(current->cpu_isolated_flags & PR_CPU_ISOLATED_ENABLE);
+}
+
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
+extern void tick_nohz_cpu_isolated_enter(void);
 #else
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
@@ -147,6 +155,8 @@ static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
+static inline bool tick_nohz_is_cpu_isolated(void) { return false; }
+static inline void tick_nohz_cpu_isolated_enter(void) { }
 #endif
 
 static inline bool is_housekeeping_cpu(int cpu)
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 31891d9535e2..edb40b6b84db 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -190,4 +190,9 @@ struct prctl_mm_map {
 # define PR_FP_MODE_FR		(1 << 0)	/* 64b FP registers */
 # define PR_FP_MODE_FRE		(1 << 1)	/* 32b compatibility */
 
+/* Enable/disable or query cpu_isolated mode for NO_HZ_FULL kernels. */
+#define PR_SET_CPU_ISOLATED	47
+#define PR_GET_CPU_ISOLATED	48
+# define PR_CPU_ISOLATED_ENABLE	(1 << 0)
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 72d59a1a6eb6..66739d7c1350 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -20,6 +20,7 @@
 #include <linux/hardirq.h>
 #include <linux/export.h>
 #include <linux/kprobes.h>
+#include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/context_tracking.h>
@@ -85,6 +86,8 @@ void context_tracking_enter(enum ctx_state state)
 			 * on the tick.
 			 */
 			if (state == CONTEXT_USER) {
+				if (tick_nohz_is_cpu_isolated())
+					tick_nohz_cpu_isolated_enter();
 				trace_user_enter(0);
 				vtime_user_enter(current);
 			}
diff --git a/kernel/sys.c b/kernel/sys.c
index a4e372b798a5..3fd9e47f8fc8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2243,6 +2243,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+#ifdef CONFIG_NO_HZ_FULL
+	case PR_SET_CPU_ISOLATED:
+		me->cpu_isolated_flags = arg2;
+		break;
+	case PR_GET_CPU_ISOLATED:
+		error = me->cpu_isolated_flags;
+		break;
+#endif
 	default:
 		error = -EINVAL;
 		break;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 914259128145..f1551c946c45 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -24,6 +24,7 @@
 #include <linux/posix-timers.h>
 #include <linux/perf_event.h>
 #include <linux/context_tracking.h>
+#include <linux/swap.h>
 
 #include <asm/irq_regs.h>
 
@@ -389,6 +390,56 @@ void __init tick_nohz_init(void)
 	pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
 		cpumask_pr_args(tick_nohz_full_mask));
 }
+
+/*
+ * We normally return immediately to userspace.
+ *
+ * In "cpu_isolated" mode we wait until no more interrupts are
+ * pending.  Otherwise we nap with interrupts enabled and wait for the
+ * next interrupt to fire, then loop back and retry.
+ *
+ * Note that if you schedule two "cpu_isolated" processes on the same
+ * core, neither will ever leave the kernel, and one will have to be
+ * killed manually.  Otherwise in situations where another process is
+ * in the runqueue on this cpu, this task will just wait for that
+ * other task to go idle before returning to user space.
+ */
+void tick_nohz_cpu_isolated_enter(void)
+{
+	struct clock_event_device *dev =
+		__this_cpu_read(tick_cpu_device.evtdev);
+	struct task_struct *task = current;
+	unsigned long start = jiffies;
+	bool warned = false;
+
+	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
+	lru_add_drain();
+
+	while (ACCESS_ONCE(dev->next_event.tv64) != KTIME_MAX) {
+		if (!warned && (jiffies - start) >= (5 * HZ)) {
+			pr_warn("%s/%d: cpu %d: cpu_isolated task blocked for %ld jiffies\n",
+				task->comm, task->pid, smp_processor_id(),
+				(jiffies - start));
+			warned = true;
+		}
+		if (should_resched())
+			schedule();
+		if (test_thread_flag(TIF_SIGPENDING))
+			break;
+
+		/* Idle with interrupts enabled and wait for the tick. */
+		set_current_state(TASK_INTERRUPTIBLE);
+		arch_cpu_idle();
+		set_current_state(TASK_RUNNING);
+	}
+	if (warned) {
+		pr_warn("%s/%d: cpu %d: cpu_isolated task unblocked after %ld jiffies\n",
+			task->comm, task->pid, smp_processor_id(),
+			(jiffies - start));
+		dump_stack();
+	}
+}
+
 #endif
 
 /*
-- 
2.1.2
