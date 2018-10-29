From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v5 01/15] sched/core: uclamp: extend sched_setattr to support utilization clamping
Date: Mon, 29 Oct 2018 18:32:55 +0000
Message-ID: <20181029183311.29175-2-patrick.bellasi@arm.com>
References: <20181029183311.29175-1-patrick.bellasi@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029183311.29175-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The SCHED_DEADLINE scheduling class provides an advanced and formal
model to define tasks requirements which can be translated into proper
decisions for both task placements and frequencies selections.
Other classes have a more simplified model which is essentially based on
the relatively simple concept of POSIX priorities.

Such a simple priority based model however does not allow to exploit
some of the most advanced features of the Linux scheduler like, for
example, driving frequencies selection via the schedutil cpufreq
governor. However, also for non SCHED_DEADLINE tasks, it's still
interesting to define tasks properties which can be used to better
support certain scheduler decisions.

Utilization clamping aims at exposing to user-space a new set of
per-task attributes which can be used to provide the scheduler with some
hints about the expected/required utilization for a task.
This will allow to implement a more advanced per-task frequency control
mechanism which is not based just on a "passive" measured task
utilization but on a more "proactive" approach. For example, it could be
possible to boost interactive tasks, thus getting better performance, or
cap background tasks, thus being more energy/thermal efficient.

Ultimately, such a mechanism can be considered similar to the cpufreq
powersave, performance and userspace governors but with a much fine
grained and per-task control.

Let's introduce a new API to set utilization clamping values for a
specified task by extending sched_setattr, a syscall which already
allows to define task specific properties for different scheduling
classes. Specifically, a new pair of attributes allows to specify a
minimum and maximum utilization which the scheduler should consider for
a task.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Steve Muckle <smuckle@google.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Quentin Perret <quentin.perret@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-api@vger.kernel.org

---
Changes in v5:
 Others:
 - rebased on v4.19

Changes in v4:
 Message-ID: <87897157-0b49-a0be-f66c-81cc2942b4dd@infradead.org>
 - remove not required default setting
 - fixed some tabs/spaces
 Message-ID: <20180807095905.GB2288@localhost.localdomain>
 - replace/rephrase "bandwidth" references to use "capacity"
 - better stress that this do not enforce any bandwidth requirement
   but "just" give hints to the scheduler
 - fixed some typos
 Others:
 - add support for SCHED_FLAG_RESET_ON_FORK
   default clamps are now set for init_task and inherited/reset at
   fork time (when then flag is set for the parent)
 - rebased on v4.19-rc1
Changes in v3:
 Message-ID: <CAJuCfpF6=L=0LrmNnJrTNPazT4dWKqNv+thhN0dwpKCgUzs9sg@mail.gmail.com>
 - removed UCLAMP_NONE not used by this patch
 Others:
 - rebased on tip/sched/core
Changes in v2:
 - rebased on v4.18-rc4
 - move at the head of the series

As discussed at OSPM, using a [0..SCHED_CAPACITY_SCALE] range seems to
be acceptable. However, an additional patch has been added at the end of
the series which introduces a simple abstraction to use a more
generic [0..100] range.

At OSPM we also discarded the idea to "recycle" the usage of
sched_runtime and sched_period which would have made the API too
much complex for limited benefits.
---
 include/linux/sched.h            | 13 +++++++
 include/uapi/linux/sched.h       |  4 +-
 include/uapi/linux/sched/types.h | 67 +++++++++++++++++++++++++++-----
 init/Kconfig                     | 21 ++++++++++
 init/init_task.c                 |  5 +++
 kernel/sched/core.c              | 39 +++++++++++++++++++
 6 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 977cb57d7bc9..880a0c5c1f87 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -279,6 +279,14 @@ struct vtime {
 	u64			gtime;
 };
 
+enum uclamp_id {
+	UCLAMP_MIN = 0, /* Minimum utilization */
+	UCLAMP_MAX,     /* Maximum utilization */
+
+	/* Utilization clamping constraints count */
+	UCLAMP_CNT
+};
+
 struct sched_info {
 #ifdef CONFIG_SCHED_INFO
 	/* Cumulative counters: */
@@ -649,6 +657,11 @@ struct task_struct {
 #endif
 	struct sched_dl_entity		dl;
 
+#ifdef CONFIG_UCLAMP_TASK
+	/* Utlization clamp values for this task */
+	int				uclamp[UCLAMP_CNT];
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* List of struct preempt_notifier: */
 	struct hlist_head		preempt_notifiers;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..c27d6e81517b 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -50,9 +50,11 @@
 #define SCHED_FLAG_RESET_ON_FORK	0x01
 #define SCHED_FLAG_RECLAIM		0x02
 #define SCHED_FLAG_DL_OVERRUN		0x04
+#define SCHED_FLAG_UTIL_CLAMP		0x08
 
 #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
 			 SCHED_FLAG_RECLAIM		| \
-			 SCHED_FLAG_DL_OVERRUN)
+			 SCHED_FLAG_DL_OVERRUN		| \
+			 SCHED_FLAG_UTIL_CLAMP)
 
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
index 10fbb8031930..fde7301ed28c 100644
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
@@ -53,6 +73,30 @@ struct sched_param {
  * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
  * only user of this new interface. More information about the algorithm
  * available in the scheduling class file or in Documentation/.
+ *
+ * Task Utilization Attributes
+ * ===========================
+ *
+ * A subset of sched_attr attributes allows to specify the utilization which
+ * should be expected by a task. These attributes allow to inform the
+ * scheduler about the utilization boundaries within which it is expected to
+ * schedule the task. These boundaries are valuable hints to support scheduler
+ * decisions on both task placement and frequencies selection.
+ *
+ *  @sched_util_min	represents the minimum utilization
+ *  @sched_util_max	represents the maximum utilization
+ *
+ * Utilization is a value in the range [0..SCHED_CAPACITY_SCALE] which
+ * represents the percentage of CPU time used by a task when running at the
+ * maximum frequency on the highest capacity CPU of the system. Thus, for
+ * example, a 20% utilization task is a task running for 2ms every 10ms.
+ *
+ * A task with a min utilization value bigger then 0 is more likely to be
+ * scheduled on a CPU which has a capacity big enough to fit the specified
+ * minimum utilization value.
+ * A task with a max utilization value smaller then 1024 is more likely to be
+ * scheduled on a CPU which do not necessarily have more capacity then the
+ * specified max utilization value.
  */
 struct sched_attr {
 	__u32 size;
@@ -70,6 +114,11 @@ struct sched_attr {
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
index 1e234e2f1cba..738974c4f628 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -613,6 +613,27 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 config GENERIC_SCHED_CLOCK
 	bool
 
+menu "Scheduler features"
+
+config UCLAMP_TASK
+	bool "Enable utilization clamping for RT/FAIR tasks"
+	depends on CPU_FREQ_GOV_SCHEDUTIL
+	help
+	  This feature enables the scheduler to track the clamped utilization
+	  of each CPU based on RUNNABLE tasks currently scheduled on that CPU.
+
+	  When this option is enabled, the user can specify a min and max CPU
+	  utilization which is allowed for RUNNABLE tasks.
+	  The max utilization allows to request a maximum frequency a task should
+	  use, while the min utilization allows to request a minimum frequency a
+	  task should use.
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
index ad97f3ba5ec5..3701bb1e6698 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -716,6 +716,28 @@ static void set_load_weight(struct task_struct *p, bool update_load)
 	}
 }
 
+#ifdef CONFIG_UCLAMP_TASK
+static inline int __setscheduler_uclamp(struct task_struct *p,
+					const struct sched_attr *attr)
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
@@ -2320,6 +2342,11 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
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
@@ -4215,6 +4242,13 @@ static int __sched_setscheduler(struct task_struct *p,
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
@@ -4721,6 +4755,11 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
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
2.18.0
