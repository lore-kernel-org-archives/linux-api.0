From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v10 04/12] task_isolation: add initial support
Date: Wed, 2 Mar 2016 15:09:28 -0500
Message-ID: <1456949376-4910-5-git-send-email-cmetcalf@ezchip.com>
References: <1456949376-4910-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456949376-4910-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
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
task_isolation=CPULIST boot argument, which enables nohz_full and
isolcpus as well.  The "task_isolation" state is then indicated by
setting a new task struct field, task_isolation_flag, to the value
passed by prctl().  When the _ENABLE bit is set for a task, and it
is returning to userspace on a task isolation core, it calls the
new task_isolation_ready() / task_isolation_enter() routines to
take additional actions to help the task avoid being interrupted
in the future.

The task_isolation_ready() call plays an equivalent role to the
TIF_xxx flags when returning to userspace, and should be checked
in the loop check of the prepare_exit_to_usermode() routine or its
architecture equivalent.  It is called with interrupts disabled and
inspects the kernel state to determine if it is safe to return into
an isolated state.  In particular, if it sees that the scheduler
tick is still enabled, it reports that it is not yet safe.

Each time through the loop of TIF work to do, we call the new
task_isolation_enter() routine, which takes any actions that might
avoid a future interrupt to the core, such as a worker thread
being scheduled that could be quiesced now (e.g. the vmstat worker)
or a future IPI to the core to clean up some state that could be
cleaned up now (e.g. the mm lru per-cpu cache).  In addition, it
requests rescheduling if the scheduler dyntick is still running.

As a result of these tests on the "return to userspace" path, sys
calls (and page faults, etc.) can be inordinately slow.  However,
this quiescing guarantees that no unexpected interrupts will occur,
even if the application intentionally calls into the kernel.

Separate patches that follow provide these changes for x86, arm64,
and tile.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 Documentation/kernel-parameters.txt |   8 +++
 drivers/base/cpu.c                  |  18 ++++++
 include/linux/isolation.h           |  53 ++++++++++++++++
 include/linux/sched.h               |   3 +
 include/linux/tick.h                |   1 +
 include/uapi/linux/prctl.h          |   5 ++
 init/Kconfig                        |  20 ++++++
 kernel/Makefile                     |   1 +
 kernel/fork.c                       |   3 +
 kernel/isolation.c                  | 118 ++++++++++++++++++++++++++++++++++++
 kernel/sys.c                        |   9 +++
 kernel/time/tick-sched.c            |  31 ++++++----
 12 files changed, 257 insertions(+), 13 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a53c929f017..c8d0b42d984a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3747,6 +3747,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			neutralize any effect of /proc/sys/kernel/sysrq.
 			Useful for debugging.
 
+	task_isolation=	[KNL]
+			In kernels built with CONFIG_TASK_ISOLATION=y, set
+			the specified list of CPUs where cpus will be able
+			to use prctl(PR_SET_TASK_ISOLATION) to set up task
+			isolation mode.  Setting this boot flag implicitly
+			also sets up nohz_full and isolcpus mode for the
+			listed set of cpus.
+
 	tcpmhash_entries= [KNL,NET]
 			Set the number of tcp_metrics_hash slots.
 			Default value is 8192 or 16384 depending on total
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 691eeea2f19a..eaf40f4264ee 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/cpufeature.h>
 #include <linux/tick.h>
+#include <linux/isolation.h>
 
 #include "base.h"
 
@@ -290,6 +291,20 @@ static ssize_t print_cpus_nohz_full(struct device *dev,
 static DEVICE_ATTR(nohz_full, 0444, print_cpus_nohz_full, NULL);
 #endif
 
+#ifdef CONFIG_TASK_ISOLATION
+static ssize_t print_cpus_task_isolation(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	int n = 0, len = PAGE_SIZE-2;
+
+	n = scnprintf(buf, len, "%*pbl\n", cpumask_pr_args(task_isolation_map));
+
+	return n;
+}
+static DEVICE_ATTR(task_isolation, 0444, print_cpus_task_isolation, NULL);
+#endif
+
 static void cpu_device_release(struct device *dev)
 {
 	/*
@@ -460,6 +475,9 @@ static struct attribute *cpu_root_attrs[] = {
 #ifdef CONFIG_NO_HZ_FULL
 	&dev_attr_nohz_full.attr,
 #endif
+#ifdef CONFIG_TASK_ISOLATION
+	&dev_attr_task_isolation.attr,
+#endif
 #ifdef CONFIG_GENERIC_CPU_AUTOPROBE
 	&dev_attr_modalias.attr,
 #endif
diff --git a/include/linux/isolation.h b/include/linux/isolation.h
new file mode 100644
index 000000000000..c564cf1886bb
--- /dev/null
+++ b/include/linux/isolation.h
@@ -0,0 +1,53 @@
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
+
+/* cpus that are configured to support task isolation */
+extern cpumask_var_t task_isolation_map;
+
+extern int task_isolation_init(void);
+
+static inline bool task_isolation_possible(int cpu)
+{
+	return tick_nohz_full_enabled() &&
+		cpumask_test_cpu(cpu, task_isolation_map);
+}
+
+extern int task_isolation_set(unsigned int flags);
+
+static inline bool task_isolation_enabled(void)
+{
+	return (current->task_isolation_flags & PR_TASK_ISOLATION_ENABLE) &&
+		task_isolation_possible(raw_smp_processor_id());
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
+static inline void task_isolation_init(void) { }
+static inline bool task_isolation_possible(int cpu) { return false; }
+static inline bool task_isolation_enabled(void) { return false; }
+static inline bool task_isolation_ready(void) { return true; }
+static inline void task_isolation_enter(void) { }
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a10494a94cc3..df6eb22510c3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1830,6 +1830,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_TASK_ISOLATION
+	unsigned int	task_isolation_flags;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 97fd4e543846..b4c0f4dc909f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -158,6 +158,7 @@ extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(void);
+extern void tick_nohz_full_add_cpus(const struct cpumask *mask);
 #else
 static inline int housekeeping_any_cpu(void)
 {
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
index 22320804fbaf..6cab348fe454 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -782,6 +782,26 @@ config RCU_EXPEDITE_BOOT
 
 endmenu # "RCU Subsystem"
 
+config TASK_ISOLATION
+	bool "Provide hard CPU isolation from the kernel on demand"
+	depends on NO_HZ_FULL
+	help
+	 Allow userspace processes to place themselves on task_isolation
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
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2e391c754ae7..1890ea0dcd5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1413,6 +1413,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
+#ifdef CONFIG_TASK_ISOLATION
+	p->task_isolation_flags = 0; /* do not isolate */
+#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);
diff --git a/kernel/isolation.c b/kernel/isolation.c
new file mode 100644
index 000000000000..e954afd8cce8
--- /dev/null
+++ b/kernel/isolation.c
@@ -0,0 +1,118 @@
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
+cpumask_var_t task_isolation_map;
+static bool saw_boot_arg;
+
+/*
+ * Isolation requires both nohz and isolcpus support from the scheduler.
+ * We provide a boot flag that enables both for now, and which we can
+ * add other functionality to over time if needed.  Note that just
+ * specifying "nohz_full=... isolcpus=..." does not enable task isolation.
+ */
+static int __init task_isolation_setup(char *str)
+{
+	saw_boot_arg = true;
+
+	alloc_bootmem_cpumask_var(&task_isolation_map);
+	if (cpulist_parse(str, task_isolation_map) < 0) {
+		pr_warn("task_isolation: Incorrect cpumask '%s'\n", str);
+		return 1;
+	}
+
+	return 1;
+}
+__setup("task_isolation=", task_isolation_setup);
+
+int __init task_isolation_init(void)
+{
+	/* For offstack cpumask, ensure we allocate an empty cpumask early. */
+	if (!saw_boot_arg) {
+		zalloc_cpumask_var(&task_isolation_map, GFP_KERNEL);
+		return 0;
+	}
+
+	/*
+	 * Add our task_isolation cpus to nohz_full and isolcpus.  Note
+	 * that we are called relatively early in boot, from tick_init();
+	 * at this point neither nohz_full nor isolcpus has been used
+	 * to configure the system, but isolcpus has been allocated
+	 * already in sched_init().
+	 */
+	tick_nohz_full_add_cpus(task_isolation_map);
+	cpumask_or(cpu_isolated_map, cpu_isolated_map, task_isolation_map);
+
+	return 0;
+}
+
+/*
+ * This routine controls whether we can enable task-isolation mode.
+ * The task must be affinitized to a single task_isolation core or we will
+ * return EINVAL.  Although the application could later re-affinitize
+ * to a housekeeping core and lose task isolation semantics, this
+ * initial test should catch 99% of bugs with task placement prior to
+ * enabling task isolation.
+ */
+int task_isolation_set(unsigned int flags)
+{
+	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
+	    !task_isolation_possible(raw_smp_processor_id()))
+		return -EINVAL;
+
+	current->task_isolation_flags = flags;
+	return 0;
+}
+
+/*
+ * In task isolation mode we try to return to userspace only after
+ * attempting to make sure we won't be interrupted again.  This test
+ * is run with interrupts disabled to test that everything we need
+ * to be true is true before we can return to userspace.
+ */
+bool _task_isolation_ready(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	return (!lru_add_drain_needed(smp_processor_id()) &&
+		vmstat_idle() &&
+		tick_nohz_tick_stopped());
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
+	quiet_vmstat_sync();
+
+	/*
+	 * Request rescheduling unless we are in full dynticks mode.
+	 * We would eventually get pre-empted without this, and if there's
+	 * another task waiting, it would run; but by explicitly requesting
+	 * the reschedule, we reduce the latency.  We could directly call
+	 * schedule() here as well, but since our caller is the standard
+	 * place where schedule() is called, we defer to the caller.
+	 */
+	if (!tick_nohz_tick_stopped())
+		set_tsk_need_resched(current);
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index 78947de6f969..c1d621f1137e 100644
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0b17424349eb..14eb7dd06f26 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -24,6 +24,7 @@
 #include <linux/posix-timers.h>
 #include <linux/perf_event.h>
 #include <linux/context_tracking.h>
+#include <linux/isolation.h>
 
 #include <asm/irq_regs.h>
 
@@ -311,30 +312,34 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static int tick_nohz_init_all(void)
+void tick_nohz_full_add_cpus(const struct cpumask *mask)
 {
-	int err = -1;
+	if (!cpumask_weight(mask))
+		return;
 
-#ifdef CONFIG_NO_HZ_FULL_ALL
-	if (!alloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
+	if (tick_nohz_full_mask == NULL &&
+	    !zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
 		WARN(1, "NO_HZ: Can't allocate full dynticks cpumask\n");
-		return err;
+		return;
 	}
-	err = 0;
-	cpumask_setall(tick_nohz_full_mask);
+
+	cpumask_or(tick_nohz_full_mask, tick_nohz_full_mask, mask);
 	tick_nohz_full_running = true;
-#endif
-	return err;
 }
 
 void __init tick_nohz_init(void)
 {
 	int cpu;
 
-	if (!tick_nohz_full_running) {
-		if (tick_nohz_init_all() < 0)
-			return;
-	}
+	task_isolation_init();
+
+#ifdef CONFIG_NO_HZ_FULL_ALL
+	if (!tick_nohz_full_running)
+		tick_nohz_full_add_cpus(cpu_possible_mask);
+#endif
+
+	if (!tick_nohz_full_running)
+		return;
 
 	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
 		WARN(1, "NO_HZ: Can't allocate not-full dynticks cpumask\n");
-- 
2.1.2
