From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets refcounting
Date: Tue, 15 Jan 2019 10:15:01 +0000
Message-ID: <20190115101513.2822-5-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Utilization clamping allows to clamp the CPU's utilization within a
[util_min, util_max] range, depending on the set of RUNNABLE tasks on
that CPU. Each task references two "clamp buckets" defining its minimum
and maximum (util_{min,max}) utilization "clamp values". A CPU's clamp
bucket is active if there is at least one RUNNABLE tasks enqueued on
that CPU and refcounting that bucket.

When a task is {en,de}queued {on,from} a CPU, the set of active clamp
buckets on that CPU can change. Since each clamp bucket enforces a
different utilization clamp value, when the set of active clamp buckets
changes, a new "aggregated" clamp value is computed for that CPU.

Clamp values are always MAX aggregated for both util_min and util_max.
This ensures that no tasks can affect the performance of other
co-scheduled tasks which are more boosted (i.e. with higher util_min
clamp) or less capped (i.e. with higher util_max clamp).

Each task has a:
   task_struct::uclamp[clamp_id]::bucket_id
to track the "bucket index" of the CPU's clamp bucket it refcounts while
enqueued, for each clamp index (clamp_id).

Each CPU's rq has a:
   rq::uclamp[clamp_id]::bucket[bucket_id].tasks
to track how many tasks, currently RUNNABLE on that CPU, refcount each
clamp bucket (bucket_id) of a clamp index (clamp_id).

Each CPU's rq has also a:
   rq::uclamp[clamp_id]::bucket[bucket_id].value
to track the clamp value of each clamp bucket (bucket_id) of a clamp
index (clamp_id).

The unordered array rq::uclamp::bucket[clamp_id][] is scanned every time
we need to find a new MAX aggregated clamp value for a clamp_id. This
operation is required only when we dequeue the last task of a clamp
bucket tracking the current MAX aggregated clamp value. In these cases,
the CPU is either entering IDLE or going to schedule a less boosted or
more clamped task.

The expected number of different clamp values, configured at build time,
is small enough to fit the full unordered array into a single cache
line. In most use-cases we expect less than 10 different clamp values
for each clamp_id.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v6:
 Message-ID: <20181113151127.GA7681@darkstar>
 - use SCHED_WARN_ON() instead of CONFIG_SCHED_DEBUG guarded WARN()s
 - add some better inline documentation to explain per-CPU initializations
 - add some local variables to use library's max() for aggregation on
   bitfields attirbutes
 Message-ID: <20181112000910.GC3038@worktop>
 - wholesale s/group/bucket/
 Message-ID: <20181111164754.GA3038@worktop>
 - consistently use unary (++/--) operators
 Others:
 - updated from rq::uclamp::group[clamp_id][group_id]
             to rq::uclamp[clamp_id]::bucket[bucket_id]
   which better matches the layout already used for tasks, i.e.
                 p::uclamp[clamp_id]::value
 - use {WRITE,READ}_ONCE() for rq's clamp access
 - update layout of rq::uclamp_cpu to better match that of tasks,
   i.e now access CPU's clamp buckets as:
     rq->uclamp[clamp_id]{.bucket[bucket_id].value}
   which matches:
      p->uclamp[clamp_id]
---
 include/linux/sched.h |   6 ++
 kernel/sched/core.c   | 152 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h  |  49 ++++++++++++++
 3 files changed, 207 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4f72f956850f..84294925d006 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -601,6 +601,7 @@ struct sched_dl_entity {
  * @value:		clamp value tracked by a clamp bucket
  * @bucket_id:		the bucket index used by the fast-path
  * @mapped:		the bucket index is valid
+ * @active:		the se is currently refcounted in a CPU's clamp bucket
  *
  * A utilization clamp bucket maps a:
  *   clamp value (value), i.e.
@@ -614,11 +615,16 @@ struct sched_dl_entity {
  *   uclamp_bucket_inc() - for a new clamp value
  * is matched by a:
  *   uclamp_bucket_dec() - for the old clamp value
+ *
+ * The active bit is set whenever a task has got an effective clamp bucket
+ * and value assigned, which can be different from the user requested ones.
+ * This allows to know a task is actually refcounting a CPU's clamp bucket.
  */
 struct uclamp_se {
 	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
 	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
 	unsigned int mapped		: 1;
+	unsigned int active		: 1;
 };
 #endif /* CONFIG_UCLAMP_TASK */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3f87898b13a0..190137cd7b3b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -766,6 +766,124 @@ static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
 	return UCLAMP_BUCKET_DELTA * (clamp_value / UCLAMP_BUCKET_DELTA);
 }
 
+static inline void uclamp_cpu_update(struct rq *rq, unsigned int clamp_id)
+{
+	unsigned int max_value = 0;
+	unsigned int bucket_id;
+
+	for (bucket_id = 0; bucket_id < UCLAMP_BUCKETS; ++bucket_id) {
+		unsigned int bucket_value;
+
+		if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)
+			continue;
+
+		/* Both min and max clamps are MAX aggregated */
+		bucket_value = rq->uclamp[clamp_id].bucket[bucket_id].value;
+		max_value = max(max_value, bucket_value);
+		if (max_value >= SCHED_CAPACITY_SCALE)
+			break;
+	}
+	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
+}
+
+/*
+ * When a task is enqueued on a CPU's rq, the clamp bucket currently defined by
+ * the task's uclamp::bucket_id is reference counted on that CPU. This also
+ * immediately updates the CPU's clamp value if required.
+ *
+ * Since tasks know their specific value requested from user-space, we track
+ * within each bucket the maximum value for tasks refcounted in that bucket.
+ */
+static inline void uclamp_cpu_inc_id(struct task_struct *p, struct rq *rq,
+				     unsigned int clamp_id)
+{
+	unsigned int cpu_clamp, grp_clamp, tsk_clamp;
+	unsigned int bucket_id;
+
+	if (unlikely(!p->uclamp[clamp_id].mapped))
+		return;
+
+	bucket_id = p->uclamp[clamp_id].bucket_id;
+	p->uclamp[clamp_id].active = true;
+
+	rq->uclamp[clamp_id].bucket[bucket_id].tasks++;
+
+	/* CPU's clamp buckets track the max effective clamp value */
+	tsk_clamp = p->uclamp[clamp_id].value;
+	grp_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
+	rq->uclamp[clamp_id].bucket[bucket_id].value = max(grp_clamp, tsk_clamp);
+
+	/* Update CPU clamp value if required */
+	cpu_clamp = READ_ONCE(rq->uclamp[clamp_id].value);
+	WRITE_ONCE(rq->uclamp[clamp_id].value, max(cpu_clamp, tsk_clamp));
+}
+
+/*
+ * When a task is dequeued from a CPU's rq, the CPU's clamp bucket reference
+ * counted by the task is released. If this is the last task reference
+ * counting the CPU's max active clamp value, then the CPU's clamp value is
+ * updated.
+ * Both the tasks reference counter and the CPU's cached clamp values are
+ * expected to be always valid, if we detect they are not we skip the updates,
+ * enforce a consistent state and warn.
+ */
+static inline void uclamp_cpu_dec_id(struct task_struct *p, struct rq *rq,
+				     unsigned int clamp_id)
+{
+	unsigned int clamp_value;
+	unsigned int bucket_id;
+
+	if (unlikely(!p->uclamp[clamp_id].mapped))
+		return;
+
+	bucket_id = p->uclamp[clamp_id].bucket_id;
+	p->uclamp[clamp_id].active = false;
+
+	SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
+	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
+		rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
+
+	/* We accept to (possibly) overboost tasks still RUNNABLE */
+	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
+		return;
+	clamp_value = rq->uclamp[clamp_id].bucket[bucket_id].value;
+
+	/* The CPU's clamp value is expected to always track the max */
+	SCHED_WARN_ON(clamp_value > rq->uclamp[clamp_id].value);
+
+	if (clamp_value >= READ_ONCE(rq->uclamp[clamp_id].value)) {
+		/*
+		 * Reset CPU's clamp bucket value to its nominal value whenever
+		 * there are anymore RUNNABLE tasks refcounting it.
+		 */
+		rq->uclamp[clamp_id].bucket[bucket_id].value =
+			uclamp_maps[clamp_id][bucket_id].value;
+		uclamp_cpu_update(rq, clamp_id);
+	}
+}
+
+static inline void uclamp_cpu_inc(struct rq *rq, struct task_struct *p)
+{
+	unsigned int clamp_id;
+
+	if (unlikely(!p->sched_class->uclamp_enabled))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
+		uclamp_cpu_inc_id(p, rq, clamp_id);
+}
+
+static inline void uclamp_cpu_dec(struct rq *rq, struct task_struct *p)
+{
+	unsigned int clamp_id;
+
+	if (unlikely(!p->sched_class->uclamp_enabled))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
+		uclamp_cpu_dec_id(p, rq, clamp_id);
+}
+
 static void uclamp_bucket_dec(unsigned int clamp_id, unsigned int bucket_id)
 {
 	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
@@ -798,6 +916,7 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
 	unsigned int free_bucket_id;
 	unsigned int bucket_value;
 	unsigned int bucket_id;
+	int cpu;
 
 	bucket_value = uclamp_bucket_value(clamp_value);
 
@@ -835,6 +954,28 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
 	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
 					  &uc_map_old.data, uc_map_new.data));
 
+	/*
+	 * Ensure each CPU tracks the correct value for this clamp bucket.
+	 * This initialization of per-CPU variables is required only when a
+	 * clamp value is requested for the first time from a slow-path.
+	 */
+	if (unlikely(!uc_map_old.se_count)) {
+		for_each_possible_cpu(cpu) {
+			struct uclamp_cpu *uc_cpu =
+				&cpu_rq(cpu)->uclamp[clamp_id];
+
+			/* CPU's tasks count must be 0 for free buckets */
+			SCHED_WARN_ON(uc_cpu->bucket[bucket_id].tasks);
+			if (unlikely(uc_cpu->bucket[bucket_id].tasks))
+				uc_cpu->bucket[bucket_id].tasks = 0;
+
+			/* Minimize cache lines invalidation */
+			if (uc_cpu->bucket[bucket_id].value == bucket_value)
+				continue;
+			uc_cpu->bucket[bucket_id].value = bucket_value;
+		}
+	}
+
 	uc_se->value = clamp_value;
 	uc_se->bucket_id = bucket_id;
 
@@ -907,6 +1048,7 @@ static void uclamp_fork(struct task_struct *p, bool reset)
 			clamp_value = uclamp_none(clamp_id);
 
 		p->uclamp[clamp_id].mapped = false;
+		p->uclamp[clamp_id].active = false;
 		uclamp_bucket_inc(&p->uclamp[clamp_id], clamp_id, clamp_value);
 	}
 }
@@ -915,9 +1057,15 @@ static void __init init_uclamp(void)
 {
 	struct uclamp_se *uc_se;
 	unsigned int clamp_id;
+	int cpu;
 
 	mutex_init(&uclamp_mutex);
 
+	for_each_possible_cpu(cpu) {
+		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_cpu));
+		cpu_rq(cpu)->uclamp[UCLAMP_MAX].value = uclamp_none(UCLAMP_MAX);
+	}
+
 	memset(uclamp_maps, 0, sizeof(uclamp_maps));
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
 		uc_se = &init_task.uclamp[clamp_id];
@@ -926,6 +1074,8 @@ static void __init init_uclamp(void)
 }
 
 #else /* CONFIG_UCLAMP_TASK */
+static inline void uclamp_cpu_inc(struct rq *rq, struct task_struct *p) { }
+static inline void uclamp_cpu_dec(struct rq *rq, struct task_struct *p) { }
 static inline int __setscheduler_uclamp(struct task_struct *p,
 					const struct sched_attr *attr)
 {
@@ -945,6 +1095,7 @@ static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 		psi_enqueue(p, flags & ENQUEUE_WAKEUP);
 	}
 
+	uclamp_cpu_inc(rq, p);
 	p->sched_class->enqueue_task(rq, p, flags);
 }
 
@@ -958,6 +1109,7 @@ static inline void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 		psi_dequeue(p, flags & DEQUEUE_SLEEP);
 	}
 
+	uclamp_cpu_dec(rq, p);
 	p->sched_class->dequeue_task(rq, p, flags);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a0b238156161..06ff7d890ff6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -797,6 +797,50 @@ extern void rto_push_irq_work_func(struct irq_work *work);
 #endif
 #endif /* CONFIG_SMP */
 
+#ifdef CONFIG_UCLAMP_TASK
+/*
+ * struct uclamp_bucket - Utilization clamp bucket
+ * @value: utilization clamp value for tasks on this clamp bucket
+ * @tasks: number of RUNNABLE tasks on this clamp bucket
+ *
+ * Keep track of how many tasks are RUNNABLE for a given utilization
+ * clamp value.
+ */
+struct uclamp_bucket {
+	unsigned long value : bits_per(SCHED_CAPACITY_SCALE);
+	unsigned long tasks : BITS_PER_LONG - bits_per(SCHED_CAPACITY_SCALE);
+};
+
+/*
+ * struct uclamp_cpu - CPU's utilization clamp
+ * @value: currently active clamp values for a CPU
+ * @bucket: utilization clamp buckets affecting a CPU
+ *
+ * Keep track of RUNNABLE tasks on a CPUs to aggregate their clamp values.
+ * A clamp value is affecting a CPU where there is at least one task RUNNABLE
+ * (or actually running) with that value.
+ *
+ * We have up to UCLAMP_CNT possible different clamp values, which are
+ * currently only two: minmum utilization and maximum utilization.
+ *
+ * All utilization clamping values are MAX aggregated, since:
+ * - for util_min: we want to run the CPU at least at the max of the minimum
+ *   utilization required by its currently RUNNABLE tasks.
+ * - for util_max: we want to allow the CPU to run up to the max of the
+ *   maximum utilization allowed by its currently RUNNABLE tasks.
+ *
+ * Since on each system we expect only a limited number of different
+ * utilization clamp values (CONFIG_UCLAMP_bucketS_COUNT), we use a simple
+ * array to track the metrics required to compute all the per-CPU utilization
+ * clamp values. The additional slot is used to track the default clamp
+ * values, i.e. no min/max clamping at all.
+ */
+struct uclamp_cpu {
+	unsigned int value;
+	struct uclamp_bucket bucket[UCLAMP_BUCKETS];
+};
+#endif /* CONFIG_UCLAMP_TASK */
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -835,6 +879,11 @@ struct rq {
 	unsigned long		nr_load_updates;
 	u64			nr_switches;
 
+#ifdef CONFIG_UCLAMP_TASK
+	/* Utilization clamp values based on CPU's RUNNABLE tasks */
+	struct uclamp_cpu	uclamp[UCLAMP_CNT] ____cacheline_aligned;
+#endif
+
 	struct cfs_rq		cfs;
 	struct rt_rq		rt;
 	struct dl_rq		dl;
-- 
2.19.2
