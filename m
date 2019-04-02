From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v8 13/16] sched/core: uclamp: Propagate parent clamps
Date: Tue,  2 Apr 2019 11:41:49 +0100
Message-ID: <20190402104153.25404-14-patrick.bellasi@arm.com>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402104153.25404-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

In order to properly support hierarchical resources control, the cgroup
delegation model requires that attribute writes from a child group never
fail but still are (potentially) constrained based on parent's assigned
resources. This requires to properly propagate and aggregate parent
attributes down to its descendants.

Let's implement this mechanism by adding a new "effective" clamp value
for each task group. The effective clamp value is defined as the smaller
value between the clamp value of a group and the effective clamp value
of its parent. This is the actual clamp value enforced on tasks in a
task group.

Since it can be interesting for userspace, e.g. system management
software, to know exactly what the currently propagated/enforced
configuration is, the effective clamp values are exposed to user-space
by means of a new pair of read-only attributes
cpu.util.{min,max}.effective.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>

---
Changes in v8:
 Message-ID: <20190313201010.GU2482@worktop.programming.kicks-ass.net>
 - to be aligned with the changes in the above message:
   add "effective" values uclamp_se instance beside the existing
   "requested" values instance
 Message-ID: <20190318165430.n222vuq4tv3ntbod@e110439-lin>
 - s/cpu_util_update_hier/cpu_util_update_eff/
---
 Documentation/admin-guide/cgroup-v2.rst |  19 +++++
 kernel/sched/core.c                     | 108 ++++++++++++++++++++++--
 kernel/sched/sched.h                    |   2 +
 3 files changed, 124 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 47710a77f4fa..7aad2435e961 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -990,6 +990,16 @@ All time durations are in microseconds.
         values similar to the sched_setattr(2). This minimum utilization
         value is used to clamp the task specific minimum utilization clamp.
 
+  cpu.util.min.effective
+        A read-only single value file which exists on non-root cgroups and
+        reports minimum utilization clamp value currently enforced on a task
+        group.
+
+        The actual minimum utilization in the range [0, 1024].
+
+        This value can be lower then cpu.util.min in case a parent cgroup
+        allows only smaller minimum utilization values.
+
   cpu.util.max
         A read-write single value file which exists on non-root cgroups.
         The default is "1024". i.e. no utilization capping
@@ -1000,6 +1010,15 @@ All time durations are in microseconds.
         values similar to the sched_setattr(2). This maximum utilization
         value is used to clamp the task specific maximum utilization clamp.
 
+  cpu.util.max.effective
+        A read-only single value file which exists on non-root cgroups and
+        reports maximum utilization clamp value currently enforced on a task
+        group.
+
+        The actual maximum utilization in the range [0, 1024].
+
+        This value can be lower then cpu.util.max in case a parent cgroup
+        is enforcing a more restrictive clamping on max utilization.
 
 
 Memory
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aeed2dd315cc..e09cf8881567 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -733,6 +733,18 @@ static void set_load_weight(struct task_struct *p, bool update_load)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
+/*
+ * Serializes updates of utilization clamp values
+ *
+ * The (slow-path) user-space triggers utilization clamp value updates which
+ * can require updates on (fast-path) scheduler's data structures used to
+ * support enqueue/dequeue operations.
+ * While the per-CPU rq lock protects fast-path update operations, user-space
+ * requests are serialized using a mutex to reduce the risk of conflicting
+ * updates or API abuses.
+ */
+static DEFINE_MUTEX(uclamp_mutex);
+
 /* Max allowed minimum utilization */
 unsigned int sysctl_sched_uclamp_util_min = SCHED_CAPACITY_SCALE;
 
@@ -1115,6 +1127,8 @@ static void __init init_uclamp(void)
 	unsigned int clamp_id;
 	int cpu;
 
+	mutex_init(&uclamp_mutex);
+
 	for_each_possible_cpu(cpu) {
 		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
 		cpu_rq(cpu)->uclamp_flags = 0;
@@ -1134,6 +1148,7 @@ static void __init init_uclamp(void)
 		uclamp_default[clamp_id] = uc_max;
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 		root_task_group.uclamp_req[clamp_id] = uc_max;
+		root_task_group.uclamp[clamp_id] = uc_max;
 #endif
 	}
 }
@@ -6730,8 +6745,10 @@ static inline int alloc_uclamp_sched_group(struct task_group *tg,
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	int clamp_id;
 
-	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
 		tg->uclamp_req[clamp_id] = parent->uclamp_req[clamp_id];
+		tg->uclamp[clamp_id] = parent->uclamp[clamp_id];
+	}
 #endif
 
 	return 1;
@@ -6984,6 +7001,44 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 }
 
 #ifdef CONFIG_UCLAMP_TASK_GROUP
+static void cpu_util_update_eff(struct cgroup_subsys_state *css,
+				unsigned int clamp_id)
+{
+	struct cgroup_subsys_state *top_css = css;
+	struct uclamp_se *uc_se, *uc_parent;
+	unsigned int value;
+
+	css_for_each_descendant_pre(css, top_css) {
+		value = css_tg(css)->uclamp_req[clamp_id].value;
+
+		uc_parent = NULL;
+		if (css_tg(css)->parent)
+			uc_parent = &css_tg(css)->parent->uclamp[clamp_id];
+
+		/*
+		 * Skip the whole subtrees if the current effective clamp is
+		 * already matching the TG's clamp value.
+		 * In this case, all the subtrees already have top_value, or a
+		 * more restrictive value, as effective clamp.
+		 */
+		uc_se = &css_tg(css)->uclamp[clamp_id];
+		if (uc_se->value == value &&
+		    uc_parent && uc_parent->value >= value) {
+			css = css_rightmost_descendant(css);
+			continue;
+		}
+
+		/* Propagate the most restrictive effective value */
+		if (uc_parent && uc_parent->value < value)
+			value = uc_parent->value;
+		if (uc_se->value == value)
+			continue;
+
+		uc_se->value = value;
+		uc_se->bucket_id = uclamp_bucket_id(value);
+	}
+}
+
 static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 				  struct cftype *cftype, u64 min_value)
 {
@@ -6993,6 +7048,7 @@ static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 	if (min_value > SCHED_CAPACITY_SCALE)
 		return -ERANGE;
 
+	mutex_lock(&uclamp_mutex);
 	rcu_read_lock();
 
 	tg = css_tg(css);
@@ -7011,8 +7067,12 @@ static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 	tg->uclamp_req[UCLAMP_MIN].value = min_value;
 	tg->uclamp_req[UCLAMP_MIN].bucket_id = uclamp_bucket_id(min_value);
 
+	/* Update effective clamps to track the most restrictive value */
+	cpu_util_update_eff(css, UCLAMP_MIN);
+
 out:
 	rcu_read_unlock();
+	mutex_unlock(&uclamp_mutex);
 
 	return ret;
 }
@@ -7026,6 +7086,7 @@ static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
 	if (max_value > SCHED_CAPACITY_SCALE)
 		return -ERANGE;
 
+	mutex_lock(&uclamp_mutex);
 	rcu_read_lock();
 
 	tg = css_tg(css);
@@ -7044,21 +7105,28 @@ static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
 	tg->uclamp_req[UCLAMP_MAX].value = max_value;
 	tg->uclamp_req[UCLAMP_MAX].bucket_id = uclamp_bucket_id(max_value);
 
+	/* Update effective clamps to track the most restrictive value */
+	cpu_util_update_eff(css, UCLAMP_MAX);
+
 out:
 	rcu_read_unlock();
+	mutex_unlock(&uclamp_mutex);
 
 	return ret;
 }
 
 static inline u64 cpu_uclamp_read(struct cgroup_subsys_state *css,
-				  enum uclamp_id clamp_id)
+				  enum uclamp_id clamp_id,
+				  bool effective)
 {
 	struct task_group *tg;
 	u64 util_clamp;
 
 	rcu_read_lock();
 	tg = css_tg(css);
-	util_clamp = tg->uclamp_req[clamp_id].value;
+	util_clamp = effective
+		? tg->uclamp[clamp_id].value
+		: tg->uclamp_req[clamp_id].value;
 	rcu_read_unlock();
 
 	return util_clamp;
@@ -7067,13 +7135,25 @@ static inline u64 cpu_uclamp_read(struct cgroup_subsys_state *css,
 static u64 cpu_util_min_read_u64(struct cgroup_subsys_state *css,
 				 struct cftype *cft)
 {
-	return cpu_uclamp_read(css, UCLAMP_MIN);
+	return cpu_uclamp_read(css, UCLAMP_MIN, false);
 }
 
 static u64 cpu_util_max_read_u64(struct cgroup_subsys_state *css,
 				 struct cftype *cft)
 {
-	return cpu_uclamp_read(css, UCLAMP_MAX);
+	return cpu_uclamp_read(css, UCLAMP_MAX, false);
+}
+
+static u64 cpu_util_min_effective_read_u64(struct cgroup_subsys_state *css,
+					   struct cftype *cft)
+{
+	return cpu_uclamp_read(css, UCLAMP_MIN, true);
+}
+
+static u64 cpu_util_max_effective_read_u64(struct cgroup_subsys_state *css,
+					   struct cftype *cft)
+{
+	return cpu_uclamp_read(css, UCLAMP_MAX, true);
 }
 #endif /* CONFIG_UCLAMP_TASK_GROUP */
 
@@ -7421,11 +7501,19 @@ static struct cftype cpu_legacy_files[] = {
 		.read_u64 = cpu_util_min_read_u64,
 		.write_u64 = cpu_util_min_write_u64,
 	},
+	{
+		.name = "util.min.effective",
+		.read_u64 = cpu_util_min_effective_read_u64,
+	},
 	{
 		.name = "util.max",
 		.read_u64 = cpu_util_max_read_u64,
 		.write_u64 = cpu_util_max_write_u64,
 	},
+	{
+		.name = "util.max.effective",
+		.read_u64 = cpu_util_max_effective_read_u64,
+	},
 #endif
 	{ }	/* Terminate */
 };
@@ -7601,12 +7689,22 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_util_min_read_u64,
 		.write_u64 = cpu_util_min_write_u64,
 	},
+	{
+		.name = "util.min.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_util_min_effective_read_u64,
+	},
 	{
 		.name = "util.max",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = cpu_util_max_read_u64,
 		.write_u64 = cpu_util_max_write_u64,
 	},
+	{
+		.name = "util.max.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_util_max_effective_read_u64,
+	},
 #endif
 	{ }	/* terminate */
 };
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b46b6912beba..b0d4c5e98305 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -403,6 +403,8 @@ struct task_group {
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	/* Clamp values requested for a task group */
 	struct uclamp_se	uclamp_req[UCLAMP_CNT];
+	/* Effective clamp values used for a task group */
+	struct uclamp_se	uclamp[UCLAMP_CNT];
 #endif
 
 };
-- 
2.20.1
