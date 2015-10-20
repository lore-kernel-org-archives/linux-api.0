From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v8 04/14] task_isolation: add initial support
Date: Tue, 20 Oct 2015 16:36:02 -0400
Message-ID: <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

The existing nohz_full mode is designed as a "soft" isolation mode
that makes tradeoffs to minimize userspace interruptions while
still attempting to avoid overheads in the kernel entry/exit path,
to provide 100% kernel semantics, etc.

However, some applications require a "hard" commitment from the
kernel to avoid interruptions, in particular userspace device driver
style applications, such as high-speed networking code.

This change introduces a framework to allow applications
to elect to have the "hard" semantics as needed, specifying
prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE) to do so.
Subsequent commits will add additional flags and additional
semantics.

The kernel must be built with the new TASK_ISOLATION Kconfig flag
to enable this mode, and the kernel booted with an appropriate
nohz_full=CPULIST boot argument.  The "task_isolation" state is then
indicated by setting a new task struct field, task_isolation_flag,
to the value passed by prctl().  When the _ENABLE bit is set for
a task, and it is returning to userspace on a nohz_full core,
it calls the new task_isolation_ready() / task_isolation_enter()
routines to take additional actions to help the task avoid being
interrupted in the future.

The task_isolation_ready() call plays an equivalent role to the
TIF_xxx flags when returning to userspace, and should be checked
in the loop check of the prepare_exit_to_usermode() routine or its
architecture equivalent.  It is called with interrupts disabled and
inspects the kernel state to determine if it is safe to return into
an isolated state.  In particular, if it sees that the scheduler
tick is still enabled, it sets the TIF_NEED_RESCHED bit to notify
the scheduler to attempt to schedule a different task.

Each time through the loop of TIF work to do, we call the new
task_isolation_enter() routine, which takes any actions that might
avoid a future interrupt to the core, such as a worker thread
being scheduled that could be quiesced now (e.g. the vmstat worker)
or a future IPI to the core to clean up some state that could be
cleaned up now (e.g. the mm lru per-cpu cache).

As a result of these tests on the "return to userspace" path, sys
calls (and page faults, etc.) can be inordinately slow.  However,
this quiescing guarantees that no unexpected interrupts will occur,
even if the application intentionally calls into the kernel.

Separate patches that follow provide these changes for x86, arm64,
and tile.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/linux/isolation.h  | 38 ++++++++++++++++++++++
 include/linux/sched.h      |  3 ++
 include/uapi/linux/prctl.h |  5 +++
 init/Kconfig               | 20 ++++++++++++
 kernel/Makefile            |  1 +
 kernel/isolation.c         | 78 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c               |  9 ++++++
 7 files changed, 154 insertions(+)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

diff --git a/include/linux/isolation.h b/include/linux/isolation.h
new file mode 100644
index 000000000000..4bef90024924
--- /dev/null
+++ b/include/linux/isolation.h
@@ -0,0 +1,38 @@
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
+extern int task_isolation_set(unsigned int flags);
+static inline bool task_isolation_enabled(void)
+{
+	return tick_nohz_full_cpu(smp_processor_id()) &&
+		(current->task_isolation_flags & PR_TASK_ISOLATION_ENABLE);
+}
+
+extern bool _task_isolation_ready(void);
+extern void _task_isolation_enter(void);
+
+static inline bool task_isolation_ready(void)
+{
+	return !task_isolation_enabled() || _task_isolation_ready();
+}
+
+static inline void task_isolation_enter(void)
+{
+	if (task_isolation_enabled())
+		_task_isolation_enter();
+}
+
+#else
+static inline bool task_isolation_enabled(void) { return false; }
+static inline bool task_isolation_ready(void) { return true; }
+static inline void task_isolation_enter(void) { }
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b7b9501b41af..7a50f6904675 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1812,6 +1812,9 @@ struct task_struct {
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
index 000000000000..9a73235db0bb
--- /dev/null
+++ b/kernel/isolation.c
@@ -0,0 +1,78 @@
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
+#include <linux/syscalls.h>
+#include "time/tick-sched.h"
+
+/*
+ * This routine controls whether we can enable task-isolation mode.
+ * The task must be affinitized to a single nohz_full core or we will
+ * return EINVAL.  Although the application could later re-affinitize
+ * to a housekeeping core and lose task isolation semantics, this
+ * initial test should catch 99% of bugs with task placement prior to
+ * enabling task isolation.
+ */
+int task_isolation_set(unsigned int flags)
+{
+	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
+	    !tick_nohz_full_cpu(smp_processor_id()))
+		return -EINVAL;
+
+	current->task_isolation_flags = flags;
+	return 0;
+}
+
+/*
+ * In task isolation mode we try to return to userspace only after
+ * attempting to make sure we won't be interrupted again.  To handle
+ * the periodic scheduler tick, we test to make sure that the tick is
+ * stopped, and if it isn't yet, we request a reschedule so that if
+ * another task needs to run to completion first, it can do so.
+ * Similarly, if any other subsystems require quiescing, we will need
+ * to do that before we return to userspace.
+ */
+bool _task_isolation_ready(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	/* If we need to drain the LRU cache, we're not ready. */
+	if (lru_add_drain_needed(smp_processor_id()))
+		return false;
+
+	/* If vmstats need updating, we're not ready. */
+	if (!vmstat_idle())
+		return false;
+
+	/* If the tick is running, request rescheduling; we're not ready. */
+	if (!tick_nohz_tick_stopped()) {
+		set_tsk_need_resched(current);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Each time we try to prepare for return to userspace in a process
+ * with task isolation enabled, we run this code to quiesce whatever
+ * subsystems we can readily quiesce to avoid later interrupts.
+ */
+void _task_isolation_enter(void)
+{
+	WARN_ON_ONCE(irqs_disabled());
+
+	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
+	lru_add_drain();
+
+	/* Quieten the vmstat worker so it won't interrupt us. */
+	quiet_vmstat();
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index fa2f2f671a5c..f1b1d333f74d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -41,6 +41,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/version.h>
 #include <linux/ctype.h>
+#include <linux/isolation.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -2266,6 +2267,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+#ifdef CONFIG_TASK_ISOLATION
+	case PR_SET_TASK_ISOLATION:
+		error = task_isolation_set(arg2);
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

