From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v7 02/11] task_isolation: add initial support
Date: Mon, 28 Sep 2015 11:17:17 -0400
Message-ID: <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
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
prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) to do so.
Subsequent commits will add additional flags and additional
semantics.

The kernel must be built with the new TASK_ISOLATION Kconfig flag
to enable this mode, and the kernel booted with an appropriate
nohz_full=CPULIST boot argument.  The "task_isolation" state is then
indicated by setting a new task struct field, task_isolation_flag,
to the value passed by prctl().  When the _ENABLE bit is set for a
task, and it is returning to userspace on a nohz_full core, it calls
the new task_isolation_enter() routine to take additional actions
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

The task_isolation_enter() routine must be called just before the
hard return to userspace, so it is appropriately placed in the
prepare_exit_to_usermode() routine for an individual architecture
or some comparable location.  Separate patches that follow
provide these changes for x86, arm64, and tile.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/linux/isolation.h  | 24 +++++++++++++++
 include/linux/sched.h      |  3 ++
 include/uapi/linux/prctl.h |  5 +++
 init/Kconfig               | 20 ++++++++++++
 kernel/Makefile            |  1 +
 kernel/isolation.c         | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c               |  8 +++++
 7 files changed, 138 insertions(+)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

diff --git a/include/linux/isolation.h b/include/linux/isolation.h
new file mode 100644
index 000000000000..fd04011b1c1e
--- /dev/null
+++ b/include/linux/isolation.h
@@ -0,0 +1,24 @@
+/*
+ * Task isolation related global functions
+ */
+#ifndef _LINUX_ISOLATION_H
+#define _LINUX_ISOLATION_H
+
+#include <linux/tick.h>
+#include <linux/prctl.h>
+
+#ifdef CONFIG_TASK_ISOLATION
+static inline bool task_isolation_enabled(void)
+{
+	return tick_nohz_full_cpu(smp_processor_id()) &&
+		(current->task_isolation_flags & PR_TASK_ISOLATION_ENABLE);
+}
+
+extern void task_isolation_enter(void);
+extern void task_isolation_wait(void);
+#else
+static inline bool task_isolation_enabled(void) { return false; }
+static inline void task_isolation_enter(void) { }
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a4ab9daa387c..bd2dc26948a6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1800,6 +1800,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_TASK_ISOLATION
+	unsigned int	task_isolation_flags;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a8d0759a9e40..67224df4b559 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -197,4 +197,9 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* Enable/disable or query task_isolation mode for NO_HZ_FULL kernels. */
+#define PR_SET_TASK_ISOLATION		48
+#define PR_GET_TASK_ISOLATION		49
+# define PR_TASK_ISOLATION_ENABLE	(1 << 0)
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/init/Kconfig b/init/Kconfig
index c24b6f767bf0..4ff7f052059a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -787,6 +787,26 @@ config RCU_EXPEDITE_BOOT
 
 endmenu # "RCU Subsystem"
 
+config TASK_ISOLATION
+	bool "Provide hard CPU isolation from the kernel on demand"
+	depends on NO_HZ_FULL
+	help
+	 Allow userspace processes to place themselves on nohz_full
+	 cores and run prctl(PR_SET_TASK_ISOLATION) to "isolate"
+	 themselves from the kernel.  On return to userspace,
+	 isolated tasks will first arrange that no future kernel
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
 config BUILD_BIN2C
 	bool
 	default n
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf008ecb3..693a2ba35679 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_TORTURE_TEST) += torture.o
 obj-$(CONFIG_MEMBARRIER) += membarrier.o
 
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
+obj-$(CONFIG_TASK_ISOLATION) += isolation.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/isolation.c b/kernel/isolation.c
new file mode 100644
index 000000000000..6ace866c69f6
--- /dev/null
+++ b/kernel/isolation.c
@@ -0,0 +1,77 @@
+/*
+ *  linux/kernel/isolation.c
+ *
+ *  Implementation for task isolation.
+ *
+ *  Distributed under GPLv2.
+ */
+
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/vmstat.h>
+#include <linux/isolation.h>
+#include "time/tick-sched.h"
+
+/*
+ * Rather than continuously polling for the next_event in the
+ * tick_cpu_device, architectures can provide a method to save power
+ * by sleeping until an interrupt arrives.
+ *
+ * Note that it must be guaranteed for a particular architecture
+ * that if next_event is not KTIME_MAX, then a timer interrupt will
+ * occur, otherwise the sleep may never awaken.
+ */
+void __weak task_isolation_wait(void)
+{
+	cpu_relax();
+}
+
+/*
+ * We normally return immediately to userspace.
+ *
+ * In task_isolation mode we wait until no more interrupts are
+ * pending.  Otherwise we nap with interrupts enabled and wait for the
+ * next interrupt to fire, then loop back and retry.
+ *
+ * Note that if you schedule two task_isolation processes on the same
+ * core, neither will ever leave the kernel, and one will have to be
+ * killed manually.  Otherwise in situations where another process is
+ * in the runqueue on this cpu, this task will just wait for that
+ * other task to go idle before returning to user space.
+ */
+void task_isolation_enter(void)
+{
+	struct clock_event_device *dev =
+		__this_cpu_read(tick_cpu_device.evtdev);
+	struct task_struct *task = current;
+	unsigned long start = jiffies;
+	bool warned = false;
+
+	if (WARN_ON(irqs_disabled()))
+		local_irq_enable();
+
+	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
+	lru_add_drain();
+
+	/* Quieten the vmstat worker so it won't interrupt us. */
+	quiet_vmstat();
+
+	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
+		if (!warned && (jiffies - start) >= (5 * HZ)) {
+			pr_warn("%s/%d: cpu %d: task_isolation task blocked for %ld seconds\n",
+				task->comm, task->pid, smp_processor_id(),
+				(jiffies - start) / HZ);
+			warned = true;
+		}
+		cond_resched();
+		if (test_thread_flag(TIF_SIGPENDING))
+			break;
+		task_isolation_wait();
+	}
+	if (warned) {
+		pr_warn("%s/%d: cpu %d: task_isolation task unblocked after %ld seconds\n",
+			task->comm, task->pid, smp_processor_id(),
+			(jiffies - start) / HZ);
+		dump_stack();
+	}
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index fa2f2f671a5c..a2c6eb1d4ad9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2266,6 +2266,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+#ifdef CONFIG_TASK_ISOLATION
+	case PR_SET_TASK_ISOLATION:
+		me->task_isolation_flags = arg2;
+		break;
+	case PR_GET_TASK_ISOLATION:
+		error = me->task_isolation_flags;
+		break;
+#endif
 	default:
 		error = -EINVAL;
 		break;
-- 
2.1.2

