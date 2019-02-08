From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Fri,  8 Feb 2019 10:05:42 +0000
Message-ID: <20190208100554.32196-4-patrick.bellasi@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Tasks without a user-defined clamp value are considered not clamped
and by default their utilization can have any value in the
[0..SCHED_CAPACITY_SCALE] range.

Tasks with a user-defined clamp value are allowed to request any value
in that range, and we unconditionally enforce the required clamps.
However, a "System Management Software" could be interested in limiting
the range of clamp values allowed for all tasks.

Add a privileged interface to define a system default configuration via:

  /proc/sys/kernel/sched_uclamp_util_{min,max}

which works as an unconditional clamp range restriction for all tasks.

The default configuration allows the full range of SCHED_CAPACITY_SCALE
values for each clamp index. If otherwise configured, a task specific
clamp is always capped by the corresponding system default value.

Do that by tracking, for each task, the "effective" clamp value and
bucket the task has been actual refcounted in at enqueue time. This
allows to lazy aggregate "requested" and "system default" values at
enqueue time and simplify refcounting updates at dequeue time.

The cached bucket ids are used to avoid (relatively) more expensive
integer divisions every time a task is enqueued.

An active flag is used to report when the "effective" value is valid and
thus the task actually refcounted in the corresponding rq's bucket.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v7:
 Message-ID: <20190124123009.2yulcf25ld66popd@e110439-lin>
 - make system defaults to support a "nice" policy where a task, for
   each clamp index, can get only "up to" what allowed by the system
   default setting, i.e. tasks are always allowed to request for less
---
 include/linux/sched.h        |  24 ++++-
 include/linux/sched/sysctl.h |  11 +++
 kernel/sched/core.c          | 169 +++++++++++++++++++++++++++++++++--
 kernel/sysctl.c              |  16 ++++
 4 files changed, 210 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 45460e7a3eee..447261cd23ba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -584,14 +584,32 @@ struct sched_dl_entity {
  * Utilization clamp for a scheduling entity
  * @value:		clamp value "requested" by a se
  * @bucket_id:		clamp bucket corresponding to the "requested" value
+ * @effective:		clamp value and bucket actually "assigned" to the se
+ * @active:		the se is currently refcounted in a rq's bucket
  *
- * The bucket_id is the index of the clamp bucket matching the clamp value
- * which is pre-computed and stored to avoid expensive integer divisions from
- * the fast path.
+ * Both bucket_id and effective::bucket_id are the index of the clamp bucket
+ * matching the corresponding clamp value which are pre-computed and stored to
+ * avoid expensive integer divisions from the fast path.
+ *
+ * The active bit is set whenever a task has got an effective::value assigned,
+ * which can be different from the user requested clamp value. This allows to
+ * know a task is actually refcounting the rq's effective::bucket_id bucket.
  */
 struct uclamp_se {
+	/* Clamp value "requested" by a scheduling entity */
 	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
 	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
+	unsigned int active		: 1;
+	/*
+	 * Clamp value "obtained" by a scheduling entity.
+	 *
+	 * This cache the actual clamp value, possibly enforced by system
+	 * default clamps, a task is subject to while enqueued in a rq.
+	 */
+	struct {
+		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
+		unsigned int bucket_id	: bits_per(UCLAMP_BUCKETS);
+	} effective;
 };
 #endif /* CONFIG_UCLAMP_TASK */
 
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 99ce6d728df7..d4f6215ee03f 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -56,6 +56,11 @@ int sched_proc_update_handler(struct ctl_table *table, int write,
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
+#ifdef CONFIG_UCLAMP_TASK
+extern unsigned int sysctl_sched_uclamp_util_min;
+extern unsigned int sysctl_sched_uclamp_util_max;
+#endif
+
 #ifdef CONFIG_CFS_BANDWIDTH
 extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #endif
@@ -75,6 +80,12 @@ extern int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
+#ifdef CONFIG_UCLAMP_TASK
+extern int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
+				       void __user *buffer, size_t *lenp,
+				       loff_t *ppos);
+#endif
+
 extern int sysctl_numa_balancing(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e4f5e8c426ab..c0429bcbe09a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -720,6 +720,14 @@ static void set_load_weight(struct task_struct *p, bool update_load)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
+/* Max allowed minimum utilization */
+unsigned int sysctl_sched_uclamp_util_min = SCHED_CAPACITY_SCALE;
+
+/* Max allowed maximum utilization */
+unsigned int sysctl_sched_uclamp_util_max = SCHED_CAPACITY_SCALE;
+
+/* All clamps are required to be not greater then these values */
+static struct uclamp_se uclamp_default[UCLAMP_CNT];
 
 /* Integer ceil-rounded range for each bucket */
 #define UCLAMP_BUCKET_DELTA ((SCHED_CAPACITY_SCALE / UCLAMP_BUCKETS) + 1)
@@ -803,6 +811,70 @@ static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id,
 	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
 }
 
+/*
+ * The effective clamp bucket index of a task depends on, by increasing
+ * priority:
+ * - the task specific clamp value, when explicitly requested from userspace
+ * - the system default clamp value, defined by the sysadmin
+ *
+ * As a side effect, update the task's effective value:
+ *    task_struct::uclamp::effective::value
+ * to represent the clamp value of the task effective bucket index.
+ */
+static inline void
+uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
+		     unsigned int *clamp_value, unsigned int *bucket_id)
+{
+	/* Task specific clamp value */
+	*bucket_id = p->uclamp[clamp_id].bucket_id;
+	*clamp_value = p->uclamp[clamp_id].value;
+
+	/* Always apply system default restrictions */
+	if (unlikely(*clamp_value > uclamp_default[clamp_id].value)) {
+		*clamp_value = uclamp_default[clamp_id].value;
+		*bucket_id = uclamp_default[clamp_id].bucket_id;
+	}
+}
+
+static inline void
+uclamp_effective_assign(struct task_struct *p, unsigned int clamp_id)
+{
+	unsigned int clamp_value, bucket_id;
+
+	uclamp_effective_get(p, clamp_id, &clamp_value, &bucket_id);
+
+	p->uclamp[clamp_id].effective.value = clamp_value;
+	p->uclamp[clamp_id].effective.bucket_id = bucket_id;
+}
+
+static inline unsigned int uclamp_effective_bucket_id(struct task_struct *p,
+						      unsigned int clamp_id)
+{
+	unsigned int clamp_value, bucket_id;
+
+	/* Task currently refcounted: use back-annotated (effective) bucket */
+	if (p->uclamp[clamp_id].active)
+		return p->uclamp[clamp_id].effective.bucket_id;
+
+	uclamp_effective_get(p, clamp_id, &clamp_value, &bucket_id);
+
+	return bucket_id;
+}
+
+unsigned int uclamp_effective_value(struct task_struct *p,
+				    unsigned int clamp_id)
+{
+	unsigned int clamp_value, bucket_id;
+
+	/* Task currently refcounted: use back-annotated (effective) value */
+	if (p->uclamp[clamp_id].active)
+		return p->uclamp[clamp_id].effective.value;
+
+	uclamp_effective_get(p, clamp_id, &clamp_value, &bucket_id);
+
+	return clamp_value;
+}
+
 /*
  * When a task is enqueued on a rq, the clamp bucket currently defined by the
  * task's uclamp::bucket_id is reference counted on that rq. This also
@@ -817,12 +889,17 @@ static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id,
 static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
 				    unsigned int clamp_id)
 {
-	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
 	unsigned int rq_clamp, bkt_clamp, tsk_clamp;
+	unsigned int bucket_id;
+
+	uclamp_effective_assign(p, clamp_id);
+	bucket_id = uclamp_effective_bucket_id(p, clamp_id);
 
 	rq->uclamp[clamp_id].bucket[bucket_id].tasks++;
+	p->uclamp[clamp_id].active = true;
+
 	/* Reset clamp holds on idle exit */
-	tsk_clamp = p->uclamp[clamp_id].value;
+	tsk_clamp = uclamp_effective_value(p, clamp_id);
 	uclamp_idle_reset(rq, clamp_id, tsk_clamp);
 
 	/*
@@ -847,12 +924,15 @@ static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
 static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
 				    unsigned int clamp_id)
 {
-	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
 	unsigned int rq_clamp, bkt_clamp;
+	unsigned int bucket_id;
+
+	bucket_id = uclamp_effective_bucket_id(p, clamp_id);
 
 	SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
 	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
 		rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
+	p->uclamp[clamp_id].active = false;
 
 	/*
 	 * Keep "local clamping" simple and accept to (possibly) overboost
@@ -898,9 +978,72 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 		uclamp_rq_dec_id(p, rq, clamp_id);
 }
 
+int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	int old_min, old_max;
+	int result = 0;
+
+	old_min = sysctl_sched_uclamp_util_min;
+	old_max = sysctl_sched_uclamp_util_max;
+
+	result = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (result)
+		goto undo;
+	if (!write)
+		goto done;
+
+	if (sysctl_sched_uclamp_util_min > sysctl_sched_uclamp_util_max ||
+	    sysctl_sched_uclamp_util_max > SCHED_CAPACITY_SCALE) {
+		result = -EINVAL;
+		goto undo;
+	}
+
+	if (old_min != sysctl_sched_uclamp_util_min) {
+		uclamp_default[UCLAMP_MIN].value =
+			sysctl_sched_uclamp_util_min;
+		uclamp_default[UCLAMP_MIN].bucket_id =
+			uclamp_bucket_id(sysctl_sched_uclamp_util_min);
+	}
+	if (old_max != sysctl_sched_uclamp_util_max) {
+		uclamp_default[UCLAMP_MAX].value =
+			sysctl_sched_uclamp_util_max;
+		uclamp_default[UCLAMP_MAX].bucket_id =
+			uclamp_bucket_id(sysctl_sched_uclamp_util_max);
+	}
+
+	/*
+	 * Updating all the RUNNABLE task is expensive, keep it simple and do
+	 * just a lazy update at each next enqueue time.
+	 */
+	goto done;
+
+undo:
+	sysctl_sched_uclamp_util_min = old_min;
+	sysctl_sched_uclamp_util_max = old_max;
+done:
+
+	return result;
+}
+
+static void uclamp_fork(struct task_struct *p)
+{
+	unsigned int clamp_id;
+
+	if (unlikely(!p->sched_class->uclamp_enabled))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
+		p->uclamp[clamp_id].active = false;
+}
+
 static void __init init_uclamp(void)
 {
+	struct uclamp_se *uc_se;
+	unsigned int bucket_id;
 	unsigned int clamp_id;
+	unsigned int value;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -909,18 +1052,28 @@ static void __init init_uclamp(void)
 	}
 
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
-		unsigned int clamp_value = uclamp_none(clamp_id);
-		unsigned int bucket_id = uclamp_bucket_id(clamp_value);
-		struct uclamp_se *uc_se = &init_task.uclamp[clamp_id];
+		value = uclamp_none(clamp_id);
+		bucket_id = uclamp_bucket_id(value);
+
+		uc_se = &init_task.uclamp[clamp_id];
+		uc_se->bucket_id = bucket_id;
+		uc_se->value = value;
+	}
 
+	/* System defaults allow max clamp values for both indexes */
+	value = uclamp_none(UCLAMP_MAX);
+	bucket_id = uclamp_bucket_id(value);
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		uc_se = &uclamp_default[clamp_id];
 		uc_se->bucket_id = bucket_id;
-		uc_se->value = clamp_value;
+		uc_se->value = value;
 	}
 }
 
 #else /* CONFIG_UCLAMP_TASK */
 static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p) { }
 static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p) { }
+static inline void uclamp_fork(struct task_struct *p) { }
 static inline void init_uclamp(void) { }
 #endif /* CONFIG_UCLAMP_TASK */
 
@@ -2551,6 +2704,8 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
+	uclamp_fork(p);
+
 	/*
 	 * The child is not yet in the pid-hash so no cgroup attach races,
 	 * and the cgroup is pinned to this child due to cgroup_fork()
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 987ae08147bf..72277f09887d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -446,6 +446,22 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
 	},
+#ifdef CONFIG_UCLAMP_TASK
+	{
+		.procname	= "sched_uclamp_util_min",
+		.data		= &sysctl_sched_uclamp_util_min,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sched_uclamp_handler,
+	},
+	{
+		.procname	= "sched_uclamp_util_max",
+		.data		= &sysctl_sched_uclamp_util_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_sched_uclamp_handler,
+	},
+#endif
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
-- 
2.20.1
