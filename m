From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v5 2/6] cpu_isolated: add initial support
Date: Tue, 28 Jul 2015 15:49:36 -0400
Message-ID: <1438112980-9981-3-git-send-email-cmetcalf@ezchip.com>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

The existing nohz_full mode is designed as a "soft" isolation mode
that makes tradeoffs to minimize userspace interruptions while
still attempting to avoid overheads in the kernel entry/exit path,
to provide 100% kernel semantics, etc.

However, some applications require a "hard" commitment from the
kernel to avoid interruptions, in particular userspace device
driver style applications, such as high-speed networking code.

This change introduces a framework to allow applications
to elect to have the "hard" semantics as needed, specifying
prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
Subsequent commits will add additional flags and additional
semantics.

The kernel must be built with the new CPU_ISOLATED Kconfig flag
to enable this mode, and the kernel booted with an appropriate
nohz_full=CPULIST boot argument.  The "cpu_isolated" state is then
indicated by setting a new task struct field, cpu_isolated_flags,
to the value passed by prctl().  When the _ENABLE bit is set for a
task, and it is returning to userspace on a nohz_full core, it calls
the new cpu_isolated_enter() routine to take additional actions
to help the task avoid being interrupted in the future.

Initially, there are only three actions taken.  First, the
task calls lru_add_drain() to prevent being interrupted by a
subsequent lru_add_drain_all() call on another core.  Then, it calls
quiet_vmstat() to quieten the vmstat worker to avoid a follow-on
interrupt.  Finally, the code checks for pending timer interrupts
and quiesces until they are no longer pending.  As a result, sys
calls (and page faults, etc.) can be inordinately slow.  However,
this quiescing guarantees that no unexpected interrupts will occur,
even if the application intentionally calls into the kernel.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/kernel/process.c   |  9 ++++++
 include/linux/cpu_isolated.h | 24 +++++++++++++++
 include/linux/sched.h        |  3 ++
 include/uapi/linux/prctl.h   |  5 ++++
 kernel/context_tracking.c    |  3 ++
 kernel/sys.c                 |  8 +++++
 kernel/time/Kconfig          | 20 +++++++++++++
 kernel/time/Makefile         |  1 +
 kernel/time/cpu_isolated.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 144 insertions(+)
 create mode 100644 include/linux/cpu_isolated.h
 create mode 100644 kernel/time/cpu_isolated.c

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index e036c0aa9792..7db6f8386417 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -70,6 +70,15 @@ void arch_cpu_idle(void)
 	_cpu_idle();
 }
 
+#ifdef CONFIG_CPU_ISOLATED
+void cpu_isolated_wait(void)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	_cpu_idle();
+	set_current_state(TASK_RUNNING);
+}
+#endif
+
 /*
  * Release a thread_info structure
  */
diff --git a/include/linux/cpu_isolated.h b/include/linux/cpu_isolated.h
new file mode 100644
index 000000000000..a3d17360f7ae
--- /dev/null
+++ b/include/linux/cpu_isolated.h
@@ -0,0 +1,24 @@
+/*
+ * CPU isolation related global functions
+ */
+#ifndef _LINUX_CPU_ISOLATED_H
+#define _LINUX_CPU_ISOLATED_H
+
+#include <linux/tick.h>
+#include <linux/prctl.h>
+
+#ifdef CONFIG_CPU_ISOLATED
+static inline bool is_cpu_isolated(void)
+{
+	return tick_nohz_full_cpu(smp_processor_id()) &&
+		(current->cpu_isolated_flags & PR_CPU_ISOLATED_ENABLE);
+}
+
+extern void cpu_isolated_enter(void);
+extern void cpu_isolated_wait(void);
+#else
+static inline bool is_cpu_isolated(void) { return false; }
+static inline void cpu_isolated_enter(void) { }
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04b5ada460b4..0bb248385d88 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1776,6 +1776,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_CPU_ISOLATED
+	unsigned int	cpu_isolated_flags;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
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
index 0a495ab35bc7..36b6509c3e2a 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -20,6 +20,7 @@
 #include <linux/hardirq.h>
 #include <linux/export.h>
 #include <linux/kprobes.h>
+#include <linux/cpu_isolated.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/context_tracking.h>
@@ -99,6 +100,8 @@ void context_tracking_enter(enum ctx_state state)
 			 * on the tick.
 			 */
 			if (state == CONTEXT_USER) {
+				if (is_cpu_isolated())
+					cpu_isolated_enter();
 				trace_user_enter(0);
 				vtime_user_enter(current);
 			}
diff --git a/kernel/sys.c b/kernel/sys.c
index 259fda25eb6b..c68417ff4800 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2267,6 +2267,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+#ifdef CONFIG_CPU_ISOLATED
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
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 579ce1b929af..141969149994 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -195,5 +195,25 @@ config HIGH_RES_TIMERS
 	  hardware is not capable then this option only increases
 	  the size of the kernel image.
 
+config CPU_ISOLATED
+	bool "Provide hard CPU isolation from the kernel on demand"
+	depends on NO_HZ_FULL
+	help
+	 Allow userspace processes to place themselves on nohz_full
+	 cores and run prctl(PR_SET_CPU_ISOLATED) to "isolate"
+	 themselves from the kernel.  On return to userspace,
+	 cpu-isolated tasks will first arrange that no future kernel
+	 activity will interrupt the task while the task is running
+	 in userspace.  This "hard" isolation from the kernel is
+	 required for userspace tasks that are running hard real-time
+	 tasks in userspace, such as a 10 Gbit network driver in userspace.
+
+	 Without this option, but with NO_HZ_FULL enabled, the kernel
+	 will make a best-faith, "soft" effort to shield a single userspace
+	 process from interrupts, but makes no guarantees.
+
+	 You should say "N" unless you are intending to run a
+	 high-performance userspace driver or similar task.
+
 endmenu
 endif
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 49eca0beed32..984081cce974 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
 obj-$(CONFIG_TEST_UDELAY)			+= test_udelay.o
+obj-$(CONFIG_CPU_ISOLATED)			+= cpu_isolated.o
diff --git a/kernel/time/cpu_isolated.c b/kernel/time/cpu_isolated.c
new file mode 100644
index 000000000000..e27259f30caf
--- /dev/null
+++ b/kernel/time/cpu_isolated.c
@@ -0,0 +1,71 @@
+/*
+ *  linux/kernel/time/cpu_isolated.c
+ *
+ *  Implementation for cpu isolation.
+ *
+ *  Distributed under GPLv2.
+ */
+
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/vmstat.h>
+#include <linux/cpu_isolated.h>
+#include "tick-sched.h"
+
+/*
+ * Rather than continuously polling for the next_event in the
+ * tick_cpu_device, architectures can provide a method to save power
+ * by sleeping until an interrupt arrives.
+ */
+void __weak cpu_isolated_wait(void)
+{
+	cpu_relax();
+}
+
+/*
+ * We normally return immediately to userspace.
+ *
+ * In cpu_isolated mode we wait until no more interrupts are
+ * pending.  Otherwise we nap with interrupts enabled and wait for the
+ * next interrupt to fire, then loop back and retry.
+ *
+ * Note that if you schedule two cpu_isolated processes on the same
+ * core, neither will ever leave the kernel, and one will have to be
+ * killed manually.  Otherwise in situations where another process is
+ * in the runqueue on this cpu, this task will just wait for that
+ * other task to go idle before returning to user space.
+ */
+void cpu_isolated_enter(void)
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
+	/* Quieten the vmstat worker so it won't interrupt us. */
+	quiet_vmstat();
+
+	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
+		if (!warned && (jiffies - start) >= (5 * HZ)) {
+			pr_warn("%s/%d: cpu %d: cpu_isolated task blocked for %ld seconds\n",
+				task->comm, task->pid, smp_processor_id(),
+				(jiffies - start) / HZ);
+			warned = true;
+		}
+		if (should_resched())
+			schedule();
+		if (test_thread_flag(TIF_SIGPENDING))
+			break;
+		cpu_isolated_wait();
+	}
+	if (warned) {
+		pr_warn("%s/%d: cpu %d: cpu_isolated task unblocked after %ld seconds\n",
+			task->comm, task->pid, smp_processor_id(),
+			(jiffies - start) / HZ);
+		dump_stack();
+	}
+}
-- 
2.1.2
