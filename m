From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v7 11/15] sched/core: uclamp: Extend CPU's cgroup controller
Date: Fri,  8 Feb 2019 10:05:50 +0000
Message-ID: <20190208100554.32196-12-patrick.bellasi@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

The cgroup CPU bandwidth controller allows to assign a specified
(maximum) bandwidth to the tasks of a group. However this bandwidth is
defined and enforced only on a temporal base, without considering the
actual frequency a CPU is running on. Thus, the amount of computation
completed by a task within an allocated bandwidth can be very different
depending on the actual frequency the CPU is running that task.
The amount of computation can be affected also by the specific CPU a
task is running on, especially when running on asymmetric capacity
systems like Arm's big.LITTLE.

With the availability of schedutil, the scheduler is now able
to drive frequency selections based on actual task utilization.
Moreover, the utilization clamping support provides a mechanism to
bias the frequency selection operated by schedutil depending on
constraints assigned to the tasks currently RUNNABLE on a CPU.

Giving the mechanisms described above, it is now possible to extend the
cpu controller to specify the minimum (or maximum) utilization which
should be considered for tasks RUNNABLE on a cpu.
This makes it possible to better defined the actual computational
power assigned to task groups, thus improving the cgroup CPU bandwidth
controller which is currently based just on time constraints.

Extend the CPU controller with a couple of new attributes util.{min,max}
which allows to enforce utilization boosting and capping for all the
tasks in a group. Specifically:

- util.min: defines the minimum utilization which should be considered
	    i.e. the RUNNABLE tasks of this group will run at least at a
		 minimum frequency which corresponds to the min_util
		 utilization

- util.max: defines the maximum utilization which should be considered
	    i.e. the RUNNABLE tasks of this group will run up to a
		 maximum frequency which corresponds to the max_util
		 utilization

These attributes:

a) are available only for non-root nodes, both on default and legacy
   hierarchies, while system wide clamps are defined by a generic
   interface which does not depends on cgroups

b) do not enforce any constraints and/or dependencies between the parent
   and its child nodes, thus relying:
   - on permission settings defined by the system management software,
     to define if subgroups can configure their clamp values
   - on the delegation model, to ensure that effective clamps are
     updated to consider both subgroup requests and parent group
     constraints

c) have higher priority than task-specific clamps, defined via
   sched_setattr(), thus allowing to control and restrict task requests

This patch provides the basic support to expose the two new attributes
and to validate their run-time updates, while we do not (yet) actually
allocated clamp buckets.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  27 +++++
 include/linux/sched.h                   |   7 +-
 init/Kconfig                            |  22 ++++
 kernel/sched/core.c                     | 148 ++++++++++++++++++++++++
 kernel/sched/sched.h                    |   5 +
 5 files changed, 207 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7bf3f129c68b..47710a77f4fa 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -909,6 +909,12 @@ controller implements weight and absolute bandwidth limit models for
 normal scheduling policy and absolute bandwidth allocation model for
 realtime scheduling policy.
 
+Cycles distribution is based, by default, on a temporal base and it
+does not account for the frequency at which tasks are executed.
+The (optional) utilization clamping support allows to enforce a minimum
+bandwidth, which should always be provided by a CPU, and a maximum bandwidth,
+which should never be exceeded by a CPU.
+
 WARNING: cgroup2 doesn't yet support control of realtime processes and
 the cpu controller can only be enabled when all RT processes are in
 the root cgroup.  Be aware that system management software may already
@@ -974,6 +980,27 @@ All time durations are in microseconds.
 	Shows pressure stall information for CPU. See
 	Documentation/accounting/psi.txt for details.
 
+  cpu.util.min
+        A read-write single value file which exists on non-root cgroups.
+        The default is "0", i.e. no utilization boosting.
+
+        The requested minimum utilization in the range [0, 1024].
+
+        This interface allows reading and setting minimum utilization clamp
+        values similar to the sched_setattr(2). This minimum utilization
+        value is used to clamp the task specific minimum utilization clamp.
+
+  cpu.util.max
+        A read-write single value file which exists on non-root cgroups.
+        The default is "1024". i.e. no utilization capping
+
+        The requested maximum utilization in the range [0, 1024].
+
+        This interface allows reading and setting maximum utilization clamp
+        values similar to the sched_setattr(2). This maximum utilization
+        value is used to clamp the task specific maximum utilization clamp.
+
+
 
 Memory
 ------
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 711ea303f4c7..9d38fd588bbb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -612,8 +612,11 @@ struct uclamp_se {
 	/*
 	 * Clamp value "obtained" by a scheduling entity.
 	 *
-	 * This cache the actual clamp value, possibly enforced by system
-	 * default clamps, a task is subject to while enqueued in a rq.
+	 * For a task, this is the value (possibly) enforced by the
+	 * task group the task is currently part of or by the system
+	 * default clamp values, whichever is the most restrictive.
+	 * For task groups, this is the value (possibly) enforced by a
+	 * parent task group.
 	 */
 	struct {
 		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
diff --git a/init/Kconfig b/init/Kconfig
index 34e23d5d95d1..87bd962ed848 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -866,6 +866,28 @@ config RT_GROUP_SCHED
 
 endif #CGROUP_SCHED
 
+config UCLAMP_TASK_GROUP
+	bool "Utilization clamping per group of tasks"
+	depends on CGROUP_SCHED
+	depends on UCLAMP_TASK
+	default n
+	help
+	  This feature enables the scheduler to track the clamped utilization
+	  of each CPU based on RUNNABLE tasks currently scheduled on that CPU.
+
+	  When this option is enabled, the user can specify a min and max
+	  CPU bandwidth which is allowed for each single task in a group.
+	  The max bandwidth allows to clamp the maximum frequency a task
+	  can use, while the min bandwidth allows to define a minimum
+	  frequency a task will always use.
+
+	  When task group based utilization clamping is enabled, an eventually
+	  specified task-specific clamp value is constrained by the cgroup
+	  specified clamp value. Both minimum and maximum task clamping cannot
+	  be bigger than the corresponding clamping defined at task group level.
+
+	  If in doubt, say N.
+
 config CGROUP_PIDS
 	bool "PIDs controller"
 	help
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 569564012ddc..122ab069ade5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1148,6 +1148,14 @@ static void __init init_uclamp(void)
 		uc_se = &uclamp_default[clamp_id];
 		uc_se->bucket_id = bucket_id;
 		uc_se->value = value;
+
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+		uc_se = &root_task_group.uclamp[clamp_id];
+		uc_se->bucket_id = bucket_id;
+		uc_se->value = value;
+		uc_se->effective.bucket_id = bucket_id;
+		uc_se->effective.value = value;
+#endif
 	}
 }
 
@@ -6739,6 +6747,23 @@ void ia64_set_curr_task(int cpu, struct task_struct *p)
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
+static inline int alloc_uclamp_sched_group(struct task_group *tg,
+					   struct task_group *parent)
+{
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	int clamp_id;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		tg->uclamp[clamp_id].value =
+			parent->uclamp[clamp_id].value;
+		tg->uclamp[clamp_id].bucket_id =
+			parent->uclamp[clamp_id].bucket_id;
+	}
+#endif
+
+	return 1;
+}
+
 static void sched_free_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
@@ -6762,6 +6787,9 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	if (!alloc_uclamp_sched_group(tg, parent))
+		goto err;
+
 	return tg;
 
 err:
@@ -6982,6 +7010,100 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 		sched_move_task(task);
 }
 
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
+				  struct cftype *cftype, u64 min_value)
+{
+	struct task_group *tg;
+	int ret = 0;
+
+	if (min_value > SCHED_CAPACITY_SCALE)
+		return -ERANGE;
+
+	rcu_read_lock();
+
+	tg = css_tg(css);
+	if (tg == &root_task_group) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (tg->uclamp[UCLAMP_MIN].value == min_value)
+		goto out;
+	if (tg->uclamp[UCLAMP_MAX].value < min_value) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Update tg's "requested" clamp value */
+	tg->uclamp[UCLAMP_MIN].value = min_value;
+	tg->uclamp[UCLAMP_MIN].bucket_id = uclamp_bucket_id(min_value);
+
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
+				  struct cftype *cftype, u64 max_value)
+{
+	struct task_group *tg;
+	int ret = 0;
+
+	if (max_value > SCHED_CAPACITY_SCALE)
+		return -ERANGE;
+
+	rcu_read_lock();
+
+	tg = css_tg(css);
+	if (tg == &root_task_group) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (tg->uclamp[UCLAMP_MAX].value == max_value)
+		goto out;
+	if (tg->uclamp[UCLAMP_MIN].value > max_value) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Update tg's "requested" clamp value */
+	tg->uclamp[UCLAMP_MAX].value = max_value;
+	tg->uclamp[UCLAMP_MAX].bucket_id = uclamp_bucket_id(max_value);
+
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static inline u64 cpu_uclamp_read(struct cgroup_subsys_state *css,
+				  enum uclamp_id clamp_id)
+{
+	struct task_group *tg;
+	u64 util_clamp;
+
+	rcu_read_lock();
+	tg = css_tg(css);
+	util_clamp = tg->uclamp[clamp_id].value;
+	rcu_read_unlock();
+
+	return util_clamp;
+}
+
+static u64 cpu_util_min_read_u64(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	return cpu_uclamp_read(css, UCLAMP_MIN);
+}
+
+static u64 cpu_util_max_read_u64(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	return cpu_uclamp_read(css, UCLAMP_MAX);
+}
+#endif /* CONFIG_UCLAMP_TASK_GROUP */
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup_subsys_state *css,
 				struct cftype *cftype, u64 shareval)
@@ -7319,6 +7441,18 @@ static struct cftype cpu_legacy_files[] = {
 		.read_u64 = cpu_rt_period_read_uint,
 		.write_u64 = cpu_rt_period_write_uint,
 	},
+#endif
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	{
+		.name = "util.min",
+		.read_u64 = cpu_util_min_read_u64,
+		.write_u64 = cpu_util_min_write_u64,
+	},
+	{
+		.name = "util.max",
+		.read_u64 = cpu_util_max_read_u64,
+		.write_u64 = cpu_util_max_write_u64,
+	},
 #endif
 	{ }	/* Terminate */
 };
@@ -7486,6 +7620,20 @@ static struct cftype cpu_files[] = {
 		.seq_show = cpu_max_show,
 		.write = cpu_max_write,
 	},
+#endif
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	{
+		.name = "util.min",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_util_min_read_u64,
+		.write_u64 = cpu_util_min_write_u64,
+	},
+	{
+		.name = "util.max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_util_max_read_u64,
+		.write_u64 = cpu_util_max_write_u64,
+	},
 #endif
 	{ }	/* terminate */
 };
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b9acef080d99..a97396295b47 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -399,6 +399,11 @@ struct task_group {
 #endif
 
 	struct cfs_bandwidth	cfs_bandwidth;
+
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	struct			uclamp_se uclamp[UCLAMP_CNT];
+#endif
+
 };
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-- 
2.20.1
