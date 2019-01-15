From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 02/16] sched/core: uclamp: Extend sched_setattr() to support utilization clamping
Date: Tue, 15 Jan 2019 10:14:59 +0000
Message-ID: <20190115101513.2822-3-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

The SCHED_DEADLINE scheduling class provides an advanced and formal
model to define tasks requirements that can translate into proper
decisions for both task placements and frequencies selections. Other
classes have a more simplified model based on the POSIX concept of
priorities.

Such a simple priority based model however does not allow to exploit
most advanced features of the Linux scheduler like, for example, driving
frequencies selection via the schedutil cpufreq governor. However, also
for non SCHED_DEADLINE tasks, it's still interesting to define tasks
properties to support scheduler decisions.

Utilization clamping exposes to user-space a new set of per-task
attributes the scheduler can use as hints about the expected/required
utilization for a task. This allows to implement a "proactive" per-task
frequency control policy, a more advanced policy than the current one
based just on "passive" measured task utilization. For example, it's
possible to boost interactive tasks (e.g. to get better performance) or
cap background tasks (e.g. to be more energy/thermal efficient).

Introduce a new API to set utilization clamping values for a specified
task by extending sched_setattr(), a syscall which already allows to
define task specific properties for different scheduling classes. A new
pair of attributes allows to specify a minimum and maximum utilization
the scheduler can consider for a task.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v6:
 Message-ID: <20181107120942.GM9781@hirez.programming.kicks-ass.net>
 - add size check in sched_copy_attr()
 Others:
 - typos and changelog cleanups
---
 include/linux/sched.h            | 16 ++++++++
 include/uapi/linux/sched.h       |  4 +-
 include/uapi/linux/sched/types.h | 65 +++++++++++++++++++++++++++-----
 init/Kconfig                     | 21 +++++++++++
 init/init_task.c                 |  5 +++
 kernel/sched/core.c              | 43 +++++++++++++++++++++
 6 files changed, 144 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 224666226e87..65199309b866 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -280,6 +280,18 @@ struct vtime {
 	u64			gtime;
 };
 
+/**
+ * enum uclamp_id - Utilization clamp constraints
+ * @UCLAMP_MIN:	Minimum utilization
+ * @UCLAMP_MAX:	Maximum utilization
+ * @UCLAMP_CNT:	Utilization clamp constraints count
+ */
+enum uclamp_id {
+	UCLAMP_MIN = 0,
+	UCLAMP_MAX,
+	UCLAMP_CNT
+};
+
 struct sched_info {
 #ifdef CONFIG_SCHED_INFO
 	/* Cumulative counters: */
@@ -648,6 +660,10 @@ struct task_struct {
 #endif
 	struct sched_dl_entity		dl;
 
+#ifdef CONFIG_UCLAMP_TASK
+	int				uclamp[UCLAMP_CNT];
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* List of struct preempt_notifier: */
 	struct hlist_head		preempt_notifiers;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 43832a87016a..9ef6dad0f854 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -53,10 +53,12 @@
 #define SCHED_FLAG_RECLAIM		0x02
 #define SCHED_FLAG_DL_OVERRUN		0x04
 #define SCHED_FLAG_KEEP_POLICY		0x08
+#define SCHED_FLAG_UTIL_CLAMP		0x10
 
 #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
 			 SCHED_FLAG_RECLAIM		| \
 			 SCHED_FLAG_DL_OVERRUN		| \
-			 SCHED_FLAG_KEEP_POLICY)
+			 SCHED_FLAG_KEEP_POLICY		| \
+			 SCHED_FLAG_UTIL_CLAMP)
 
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
index 10fbb8031930..01439e07507c 100644
--- a/include/uapi/linux/sched/types.h
+++ b/include/uapi/linux/sched/types.h
@@ -9,6 +9,7 @@ struct sched_param {
 };
 
 #define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
+#define SCHED_ATTR_SIZE_VER1	56	/* add: util_{min,max} */
 
 /*
  * Extended scheduling parameters data structure.
@@ -21,8 +22,33 @@ struct sched_param {
  * the tasks may be useful for a wide variety of application fields, e.g.,
  * multimedia, streaming, automation and control, and many others.
  *
- * This variant (sched_attr) is meant at describing a so-called
- * sporadic time-constrained task. In such model a task is specified by:
+ * This variant (sched_attr) allows to define additional attributes to
+ * improve the scheduler knowledge about task requirements.
+ *
+ * Scheduling Class Attributes
+ * ===========================
+ *
+ * A subset of sched_attr attributes specifies the
+ * scheduling policy and relative POSIX attributes:
+ *
+ *  @size		size of the structure, for fwd/bwd compat.
+ *
+ *  @sched_policy	task's scheduling policy
+ *  @sched_nice		task's nice value      (SCHED_NORMAL/BATCH)
+ *  @sched_priority	task's static priority (SCHED_FIFO/RR)
+ *
+ * Certain more advanced scheduling features can be controlled by a
+ * predefined set of flags via the attribute:
+ *
+ *  @sched_flags	for customizing the scheduler behaviour
+ *
+ * Sporadic Time-Constrained Tasks Attributes
+ * ==========================================
+ *
+ * A subset of sched_attr attributes allows to describe a so-called
+ * sporadic time-constrained task.
+ *
+ * In such model a task is specified by:
  *  - the activation period or minimum instance inter-arrival time;
  *  - the maximum (or average, depending on the actual scheduling
  *    discipline) computation time of all instances, a.k.a. runtime;
@@ -34,14 +60,8 @@ struct sched_param {
  * than the runtime and must be completed by time instant t equal to
  * the instance activation time + the deadline.
  *
- * This is reflected by the actual fields of the sched_attr structure:
+ * This is reflected by the following fields of the sched_attr structure:
  *
- *  @size		size of the structure, for fwd/bwd compat.
- *
- *  @sched_policy	task's scheduling policy
- *  @sched_flags	for customizing the scheduler behaviour
- *  @sched_nice		task's nice value      (SCHED_NORMAL/BATCH)
- *  @sched_priority	task's static priority (SCHED_FIFO/RR)
  *  @sched_deadline	representative of the task's deadline
  *  @sched_runtime	representative of the task's runtime
  *  @sched_period	representative of the task's period
@@ -53,6 +73,28 @@ struct sched_param {
  * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
  * only user of this new interface. More information about the algorithm
  * available in the scheduling class file or in Documentation/.
+ *
+ * Task Utilization Attributes
+ * ===========================
+ *
+ * A subset of sched_attr attributes allows to specify the utilization
+ * expected for a task. These attributes allow to inform the scheduler about
+ * the utilization boundaries within which it should schedule tasks. These
+ * boundaries are valuable hints to support scheduler decisions on both task
+ * placement and frequency selection.
+ *
+ *  @sched_util_min	represents the minimum utilization
+ *  @sched_util_max	represents the maximum utilization
+ *
+ * Utilization is a value in the range [0..SCHED_CAPACITY_SCALE]. It
+ * represents the percentage of CPU time used by a task when running at the
+ * maximum frequency on the highest capacity CPU of the system. For example, a
+ * 20% utilization task is a task running for 2ms every 10ms.
+ *
+ * A task with a min utilization value bigger than 0 is more likely scheduled
+ * on a CPU with a capacity big enough to fit the specified value.
+ * A task with a max utilization value smaller than 1024 is more likely
+ * scheduled on a CPU with no more capacity than the specified value.
  */
 struct sched_attr {
 	__u32 size;
@@ -70,6 +112,11 @@ struct sched_attr {
 	__u64 sched_runtime;
 	__u64 sched_deadline;
 	__u64 sched_period;
+
+	/* Utilization hints */
+	__u32 sched_util_min;
+	__u32 sched_util_max;
+
 };
 
 #endif /* _UAPI_LINUX_SCHED_TYPES_H */
diff --git a/init/Kconfig b/init/Kconfig
index d47cb77a220e..ea7c928a177b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -640,6 +640,27 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 config GENERIC_SCHED_CLOCK
 	bool
 
+menu "Scheduler features"
+
+config UCLAMP_TASK
+	bool "Enable utilization clamping for RT/FAIR tasks"
+	depends on CPU_FREQ_GOV_SCHEDUTIL
+	help
+	  This feature enables the scheduler to track the clamped utilization
+	  of each CPU based on RUNNABLE tasks scheduled on that CPU.
+
+	  With this option, the user can specify the min and max CPU
+	  utilization allowed for RUNNABLE tasks. The max utilization defines
+	  the maximum frequency a task should use while the min utilization
+	  defines the minimum frequency it should use.
+
+	  Both min and max utilization clamp values are hints to the scheduler,
+	  aiming at improving its frequency selection policy, but they do not
+	  enforce or grant any specific bandwidth for tasks.
+
+	  If in doubt, say N.
+
+endmenu
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
diff --git a/init/init_task.c b/init/init_task.c
index 5aebe3be4d7c..5bfdcc3fb839 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -6,6 +6,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
 #include <linux/sched/task.h>
+#include <linux/sched/topology.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -91,6 +92,10 @@ struct task_struct init_task
 #endif
 #ifdef CONFIG_CGROUP_SCHED
 	.sched_task_group = &root_task_group,
+#endif
+#ifdef CONFIG_UCLAMP_TASK
+	.uclamp[UCLAMP_MIN] = 0,
+	.uclamp[UCLAMP_MAX] = SCHED_CAPACITY_SCALE,
 #endif
 	.ptraced	= LIST_HEAD_INIT(init_task.ptraced),
 	.ptrace_entry	= LIST_HEAD_INIT(init_task.ptrace_entry),
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a68763a4ccae..66ff83e115db 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -717,6 +717,28 @@ static void set_load_weight(struct task_struct *p, bool update_load)
 	}
 }
 
+#ifdef CONFIG_UCLAMP_TASK
+static int __setscheduler_uclamp(struct task_struct *p,
+				 const struct sched_attr *attr)
+{
+	if (attr->sched_util_min > attr->sched_util_max)
+		return -EINVAL;
+	if (attr->sched_util_max > SCHED_CAPACITY_SCALE)
+		return -EINVAL;
+
+	p->uclamp[UCLAMP_MIN] = attr->sched_util_min;
+	p->uclamp[UCLAMP_MAX] = attr->sched_util_max;
+
+	return 0;
+}
+#else /* CONFIG_UCLAMP_TASK */
+static inline int __setscheduler_uclamp(struct task_struct *p,
+					const struct sched_attr *attr)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_UCLAMP_TASK */
+
 static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (!(flags & ENQUEUE_NOCLOCK))
@@ -2326,6 +2348,11 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 		p->prio = p->normal_prio = __normal_prio(p);
 		set_load_weight(p, false);
 
+#ifdef CONFIG_UCLAMP_TASK
+		p->uclamp[UCLAMP_MIN] = 0;
+		p->uclamp[UCLAMP_MAX] = SCHED_CAPACITY_SCALE;
+#endif
+
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:
@@ -4214,6 +4241,13 @@ static int __sched_setscheduler(struct task_struct *p,
 			return retval;
 	}
 
+	/* Configure utilization clamps for the task */
+	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP) {
+		retval = __setscheduler_uclamp(p, attr);
+		if (retval)
+			return retval;
+	}
+
 	/*
 	 * Make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
@@ -4499,6 +4533,10 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 	if (ret)
 		return -EFAULT;
 
+	if ((attr->sched_flags & SCHED_FLAG_UTIL_CLAMP) &&
+	    size < SCHED_ATTR_SIZE_VER1)
+		return -EINVAL;
+
 	/*
 	 * XXX: Do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
@@ -4729,6 +4767,11 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 	else
 		attr.sched_nice = task_nice(p);
 
+#ifdef CONFIG_UCLAMP_TASK
+	attr.sched_util_min = p->uclamp[UCLAMP_MIN];
+	attr.sched_util_max = p->uclamp[UCLAMP_MAX];
+#endif
+
 	rcu_read_unlock();
 
 	retval = sched_read_attr(uattr, &attr, size);
-- 
2.19.2
