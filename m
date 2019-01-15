From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 03/16] sched/core: uclamp: Map TASK's clamp values into CPU's clamp buckets
Date: Tue, 15 Jan 2019 10:15:00 +0000
Message-ID: <20190115101513.2822-4-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Utilization clamping requires each CPU to know which clamp values are
assigned to tasks RUNNABLE on that CPU. A per-CPU array of reference
counters can be used where each entry tracks how many RUNNABLE tasks
require the same clamp value on each CPU. However, the range of clamp
values is too wide to track all the possible values in a per-CPU array.

Trade-off clamping precision for run-time and space efficiency using a
"bucketization and mapping" mechanism to translate "clamp values" into
"clamp buckets", each one representing a range of possible clamp values.

While the bucketization allows to use only a minimal set of clamp
buckets at run-time, the mapping ensures that the clamp buckets in use
are always at the beginning of the per-CPU array.

The minimum set of clamp buckets used at run-time depends on their
granularity and how many clamp values the target system expects to
use. Since on most systems we expect only a few different clamp
values, the bucketization and mapping mechanism increases our chances
to have all the required data fitting in one cache line.

For example, if we have only 20% and 25% clamped tasks, by setting:
   CONFIG_UCLAMP_BUCKETS_COUNT 20
we allocate 20 clamp buckets with 5% resolution each, however we will
use only 2 of them at run-time, since their 5% resolution is enough to
always distinguish the clamp values in use, and they will both fit
into a single cache line for each CPU.

Introduce the "bucketization and mapping" mechanisms which are required
for the implement of the per-CPU operations.

Add a new "uclamp_enabled" sched_class attribute to mark which class
will contribute to clamping the CPU utilization. Move few callbacks
around to ensure that the most used callbacks are all in the same cache
line along with the new attribute.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v6:
 Message-ID: <20181107144448.GH9761@hirez.programming.kicks-ass.net>
 - added bucketization support since the beginning to avoid
   semi-functional code in this patch
 Message-ID: <20181107141414.GF9761@hirez.programming.kicks-ass.net>
 - update cmpxchg loops to use "do { } while (cmpxchg(ptr, old, new) != old)"
 - switch to usage of try_cmpxchg()
 Message-ID: <20181107145527.GI9761@hirez.programming.kicks-ass.net>
 - use SCHED_WARN_ON() instead of CONFIG_SCHED_DEBUG guarded blocks
 - ensure se_count never underflow
 Message-ID: <20181112000910.GC3038@worktop>
 - wholesale s/group/bucket/
 Message-ID: <20181111164754.GA3038@worktop>
 - consistently use unary (++/--) operators
 Message-ID: <20181107142428.GG14309@e110439-lin>
 - added some better comments for invariant conditions
 Message-ID: <20181107145612.GJ14309@e110439-lin>
 - ensure UCLAMP_BUCKETS_COUNT >= 1
 Others:
 - added and make use of the bit_for() macro
 - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
 - documentation review and cleanup
---
 include/linux/log2.h           |  37 ++++++
 include/linux/sched.h          |  44 ++++++-
 include/linux/sched/task.h     |   6 +
 include/linux/sched/topology.h |   6 -
 include/uapi/linux/sched.h     |   6 +-
 init/Kconfig                   |  32 +++++
 init/init_task.c               |   4 -
 kernel/exit.c                  |   1 +
 kernel/sched/core.c            | 234 ++++++++++++++++++++++++++++++---
 kernel/sched/fair.c            |   4 +
 kernel/sched/sched.h           |  19 ++-
 11 files changed, 362 insertions(+), 31 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 2af7f77866d0..e2db25734532 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -224,4 +224,41 @@ int __order_base_2(unsigned long n)
 		ilog2((n) - 1) + 1) :		\
 	__order_base_2(n)			\
 )
+
+static inline __attribute__((const))
+int __bits_per(unsigned long n)
+{
+	if (n < 2)
+		return 1;
+	if (is_power_of_2(n))
+		return order_base_2(n) + 1;
+	return order_base_2(n);
+}
+
+/**
+ * bits_per - calculate the number of bits required for the argument
+ * @n: parameter
+ *
+ * This is constant-capable and can be used for compile time
+ * initiaizations, e.g bitfields.
+ *
+ * The first few values calculated by this routine:
+ * bf(0) = 1
+ * bf(1) = 1
+ * bf(2) = 2
+ * bf(3) = 2
+ * bf(4) = 3
+ * ... and so on.
+ */
+#define bits_per(n)				\
+(						\
+	__builtin_constant_p(n) ? (		\
+		((n) == 0 || (n) == 1) ? 1 : (	\
+		((n) & (n - 1)) == 0 ?		\
+			ilog2((n) - 1) + 2 :	\
+			ilog2((n) - 1) + 1	\
+		)				\
+	) :					\
+	__bits_per(n)				\
+)
 #endif /* _LINUX_LOG2_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 65199309b866..4f72f956850f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,12 @@ struct sched_info {
 # define SCHED_FIXEDPOINT_SHIFT		10
 # define SCHED_FIXEDPOINT_SCALE		(1L << SCHED_FIXEDPOINT_SHIFT)
 
+/*
+ * Increase resolution of cpu_capacity calculations
+ */
+#define SCHED_CAPACITY_SHIFT		SCHED_FIXEDPOINT_SHIFT
+#define SCHED_CAPACITY_SCALE		(1L << SCHED_CAPACITY_SHIFT)
+
 struct load_weight {
 	unsigned long			weight;
 	u32				inv_weight;
@@ -580,6 +586,42 @@ struct sched_dl_entity {
 	struct hrtimer inactive_timer;
 };
 
+#ifdef CONFIG_UCLAMP_TASK
+/*
+ * Number of utilization clamp buckets.
+ *
+ * The first clamp bucket (bucket_id=0) is used to track non clamped tasks, i.e.
+ * util_{min,max} (0,SCHED_CAPACITY_SCALE). Thus we allocate one more bucket in
+ * addition to the compile time configured number.
+ */
+#define UCLAMP_BUCKETS (CONFIG_UCLAMP_BUCKETS_COUNT + 1)
+
+/*
+ * Utilization clamp bucket
+ * @value:		clamp value tracked by a clamp bucket
+ * @bucket_id:		the bucket index used by the fast-path
+ * @mapped:		the bucket index is valid
+ *
+ * A utilization clamp bucket maps a:
+ *   clamp value (value), i.e.
+ *   util_{min,max} value requested from userspace
+ * to a:
+ *   clamp bucket index (bucket_id), i.e.
+ *   index of the per-cpu RUNNABLE tasks refcounting array
+ *
+ * The mapped bit is set whenever a task has been mapped on a clamp bucket for
+ * the first time. When this bit is set, any:
+ *   uclamp_bucket_inc() - for a new clamp value
+ * is matched by a:
+ *   uclamp_bucket_dec() - for the old clamp value
+ */
+struct uclamp_se {
+	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
+	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
+	unsigned int mapped		: 1;
+};
+#endif /* CONFIG_UCLAMP_TASK */
+
 union rcu_special {
 	struct {
 		u8			blocked;
@@ -661,7 +703,7 @@ struct task_struct {
 	struct sched_dl_entity		dl;
 
 #ifdef CONFIG_UCLAMP_TASK
-	int				uclamp[UCLAMP_CNT];
+	struct uclamp_se		uclamp[UCLAMP_CNT];
 #endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 44c6f15800ff..c3a71698b6b8 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -70,6 +70,12 @@ static inline void exit_thread(struct task_struct *tsk)
 #endif
 extern void do_group_exit(int);
 
+#ifdef CONFIG_UCLAMP_TASK
+extern void uclamp_exit_task(struct task_struct *p);
+#else
+static inline void uclamp_exit_task(struct task_struct *p) { }
+#endif /* CONFIG_UCLAMP_TASK */
+
 extern void exit_files(struct task_struct *);
 extern void exit_itimers(struct signal_struct *);
 
diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index c31d3a47a47c..04beadac6985 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -6,12 +6,6 @@
 
 #include <linux/sched/idle.h>
 
-/*
- * Increase resolution of cpu_capacity calculations
- */
-#define SCHED_CAPACITY_SHIFT	SCHED_FIXEDPOINT_SHIFT
-#define SCHED_CAPACITY_SCALE	(1L << SCHED_CAPACITY_SHIFT)
-
 /*
  * sched-domains (multiprocessor balancing) declarations:
  */
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 9ef6dad0f854..36c65da32b31 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -53,7 +53,11 @@
 #define SCHED_FLAG_RECLAIM		0x02
 #define SCHED_FLAG_DL_OVERRUN		0x04
 #define SCHED_FLAG_KEEP_POLICY		0x08
-#define SCHED_FLAG_UTIL_CLAMP		0x10
+
+#define SCHED_FLAG_UTIL_CLAMP_MIN	0x10
+#define SCHED_FLAG_UTIL_CLAMP_MAX	0x20
+#define SCHED_FLAG_UTIL_CLAMP	(SCHED_FLAG_UTIL_CLAMP_MIN | \
+				 SCHED_FLAG_UTIL_CLAMP_MAX)
 
 #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
 			 SCHED_FLAG_RECLAIM		| \
diff --git a/init/Kconfig b/init/Kconfig
index ea7c928a177b..e60950ec01c0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -660,7 +660,39 @@ config UCLAMP_TASK
 
 	  If in doubt, say N.
 
+config UCLAMP_BUCKETS_COUNT
+	int "Number of supported utilization clamp buckets"
+	range 5 20
+	default 5
+	depends on UCLAMP_TASK
+	help
+	  Defines the number of clamp buckets to use. The range of each bucket
+	  will be SCHED_CAPACITY_SCALE/UCLAMP_BUCKETS_COUNT. The higher the
+	  number of clamp buckets the finer their granularity and the higher
+	  the precision of clamping aggregation and tracking at run-time.
+
+	  For example, with the default configuration we will have 5 clamp
+	  buckets tracking 20% utilization each. A 25% boosted tasks will be
+	  refcounted in the [20..39]% bucket and will set the bucket clamp
+	  effective value to 25%.
+	  If a second 30% boosted task should be co-scheduled on the same CPU,
+	  that task will be refcounted in the same bucket of the first task and
+	  it will boost the bucket clamp effective value to 30%.
+	  The clamp effective value of a bucket is reset to its nominal value
+	  (20% in the example above) when there are anymore tasks refcounted in
+	  that bucket.
+
+	  An additional boost/capping margin can be added to some tasks. In the
+	  example above the 25% task will be boosted to 30% until it exits the
+	  CPU. If that should be considered not acceptable on certain systems,
+	  it's always possible to reduce the margin by increasing the number of
+	  clamp buckets to trade off used memory for run-time tracking
+	  precision.
+
+	  If in doubt, use the default value.
+
 endmenu
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
diff --git a/init/init_task.c b/init/init_task.c
index 5bfdcc3fb839..7f77741b6a9b 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -92,10 +92,6 @@ struct task_struct init_task
 #endif
 #ifdef CONFIG_CGROUP_SCHED
 	.sched_task_group = &root_task_group,
-#endif
-#ifdef CONFIG_UCLAMP_TASK
-	.uclamp[UCLAMP_MIN] = 0,
-	.uclamp[UCLAMP_MAX] = SCHED_CAPACITY_SCALE,
 #endif
 	.ptraced	= LIST_HEAD_INIT(init_task.ptraced),
 	.ptrace_entry	= LIST_HEAD_INIT(init_task.ptrace_entry),
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d14979577ee..c2a4aa4463be 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -877,6 +877,7 @@ void __noreturn do_exit(long code)
 
 	sched_autogroup_exit_task(tsk);
 	cgroup_exit(tsk);
+	uclamp_exit_task(tsk);
 
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 66ff83e115db..3f87898b13a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -718,25 +718,221 @@ static void set_load_weight(struct task_struct *p, bool update_load)
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
+/*
+ * Reference count utilization clamp buckets
+ * @value:	the utilization "clamp value" tracked by this clamp bucket
+ * @se_count:	the number of scheduling entities using this "clamp value"
+ * @data:	accessor for value and se_count reading
+ * @adata:	accessor for atomic operations on value and se_count
+ */
+union uclamp_map {
+	struct {
+		unsigned long value	: bits_per(SCHED_CAPACITY_SCALE);
+		unsigned long se_count	: BITS_PER_LONG -
+					  bits_per(SCHED_CAPACITY_SCALE);
+	};
+	unsigned long data;
+	atomic_long_t adata;
+};
+
+/*
+ * Map SEs "clamp value" into CPUs "clamp bucket"
+ *
+ * Matrix mapping "clamp values" (value) to "clamp buckets" (bucket_id),
+ * for each "clamp index" (clamp_id)
+ */
+static union uclamp_map uclamp_maps[UCLAMP_CNT][UCLAMP_BUCKETS];
+
+static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
+{
+#define UCLAMP_BUCKET_DELTA (SCHED_CAPACITY_SCALE / CONFIG_UCLAMP_BUCKETS_COUNT)
+#define UCLAMP_BUCKET_UPPER (UCLAMP_BUCKET_DELTA * CONFIG_UCLAMP_BUCKETS_COUNT)
+
+	if (clamp_value >= UCLAMP_BUCKET_UPPER)
+		return SCHED_CAPACITY_SCALE;
+
+	return UCLAMP_BUCKET_DELTA * (clamp_value / UCLAMP_BUCKET_DELTA);
+}
+
+static void uclamp_bucket_dec(unsigned int clamp_id, unsigned int bucket_id)
+{
+	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
+	union uclamp_map uc_map_old, uc_map_new;
+
+	uc_map_old.data = atomic_long_read(&uc_maps[bucket_id].adata);
+	do {
+		/*
+		 * Refcounting consistency check. If we release a non
+		 * referenced bucket: refcounting is broken and we warn.
+		 */
+		if (unlikely(!uc_map_old.se_count)) {
+			SCHED_WARN_ON(!uc_map_old.se_count);
+			return;
+		}
+
+		uc_map_new = uc_map_old;
+		uc_map_new.se_count--;
+
+	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
+					  &uc_map_old.data, uc_map_new.data));
+}
+
+static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
+			      unsigned int clamp_value)
+{
+	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
+	unsigned int prev_bucket_id = uc_se->bucket_id;
+	union uclamp_map uc_map_old, uc_map_new;
+	unsigned int free_bucket_id;
+	unsigned int bucket_value;
+	unsigned int bucket_id;
+
+	bucket_value = uclamp_bucket_value(clamp_value);
+
+	do {
+		/* Find the bucket_id of an already mapped clamp bucket... */
+		free_bucket_id = UCLAMP_BUCKETS;
+		for (bucket_id = 0; bucket_id < UCLAMP_BUCKETS; ++bucket_id) {
+			uc_map_old.data = atomic_long_read(&uc_maps[bucket_id].adata);
+			if (free_bucket_id == UCLAMP_BUCKETS && !uc_map_old.se_count)
+				free_bucket_id = bucket_id;
+			if (uc_map_old.value == bucket_value)
+				break;
+		}
+
+		/* ... or allocate a new clamp bucket */
+		if (bucket_id >= UCLAMP_BUCKETS) {
+			/*
+			 * A valid clamp bucket must always be available.
+			 * If we cannot find one: refcounting is broken and we
+			 * warn once. The sched_entity will be tracked in the
+			 * fast-path using its previous clamp bucket, or not
+			 * tracked at all if not yet mapped (i.e. it's new).
+			 */
+			if (unlikely(free_bucket_id == UCLAMP_BUCKETS)) {
+				SCHED_WARN_ON(free_bucket_id == UCLAMP_BUCKETS);
+				return;
+			}
+			bucket_id = free_bucket_id;
+			uc_map_old.data = atomic_long_read(&uc_maps[bucket_id].adata);
+		}
+
+		uc_map_new.se_count = uc_map_old.se_count + 1;
+		uc_map_new.value = bucket_value;
+
+	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
+					  &uc_map_old.data, uc_map_new.data));
+
+	uc_se->value = clamp_value;
+	uc_se->bucket_id = bucket_id;
+
+	if (uc_se->mapped)
+		uclamp_bucket_dec(clamp_id, prev_bucket_id);
+
+	/*
+	 * Task's sched_entity are refcounted in the fast-path only when they
+	 * have got a valid clamp_bucket assigned.
+	 */
+	uc_se->mapped = true;
+}
+
 static int __setscheduler_uclamp(struct task_struct *p,
 				 const struct sched_attr *attr)
 {
-	if (attr->sched_util_min > attr->sched_util_max)
-		return -EINVAL;
-	if (attr->sched_util_max > SCHED_CAPACITY_SCALE)
+	unsigned int lower_bound = p->uclamp[UCLAMP_MIN].value;
+	unsigned int upper_bound = p->uclamp[UCLAMP_MAX].value;
+	int result = 0;
+
+	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN)
+		lower_bound = attr->sched_util_min;
+
+	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MAX)
+		upper_bound = attr->sched_util_max;
+
+	if (lower_bound > upper_bound ||
+	    upper_bound > SCHED_CAPACITY_SCALE)
 		return -EINVAL;
 
-	p->uclamp[UCLAMP_MIN] = attr->sched_util_min;
-	p->uclamp[UCLAMP_MAX] = attr->sched_util_max;
+	mutex_lock(&uclamp_mutex);
+	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
+		uclamp_bucket_inc(&p->uclamp[UCLAMP_MIN],
+				  UCLAMP_MIN, lower_bound);
+	}
+	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MAX) {
+		uclamp_bucket_inc(&p->uclamp[UCLAMP_MAX],
+				  UCLAMP_MAX, upper_bound);
+	}
+	mutex_unlock(&uclamp_mutex);
 
-	return 0;
+	return result;
+}
+
+void uclamp_exit_task(struct task_struct *p)
+{
+	unsigned int clamp_id;
+
+	if (unlikely(!p->sched_class->uclamp_enabled))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		if (!p->uclamp[clamp_id].mapped)
+			continue;
+		uclamp_bucket_dec(clamp_id, p->uclamp[clamp_id].bucket_id);
+	}
+}
+
+static void uclamp_fork(struct task_struct *p, bool reset)
+{
+	unsigned int clamp_id;
+
+	if (unlikely(!p->sched_class->uclamp_enabled))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		unsigned int clamp_value = p->uclamp[clamp_id].value;
+
+		if (unlikely(reset))
+			clamp_value = uclamp_none(clamp_id);
+
+		p->uclamp[clamp_id].mapped = false;
+		uclamp_bucket_inc(&p->uclamp[clamp_id], clamp_id, clamp_value);
+	}
+}
+
+static void __init init_uclamp(void)
+{
+	struct uclamp_se *uc_se;
+	unsigned int clamp_id;
+
+	mutex_init(&uclamp_mutex);
+
+	memset(uclamp_maps, 0, sizeof(uclamp_maps));
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		uc_se = &init_task.uclamp[clamp_id];
+		uclamp_bucket_inc(uc_se, clamp_id, uclamp_none(clamp_id));
+	}
 }
+
 #else /* CONFIG_UCLAMP_TASK */
 static inline int __setscheduler_uclamp(struct task_struct *p,
 					const struct sched_attr *attr)
 {
 	return -EINVAL;
 }
+static inline void uclamp_fork(struct task_struct *p, bool reset) { }
+static inline void init_uclamp(void) { }
 #endif /* CONFIG_UCLAMP_TASK */
 
 static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -2320,6 +2516,7 @@ static inline void init_schedstats(void) {}
 int sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long flags;
+	bool reset;
 
 	__sched_fork(clone_flags, p);
 	/*
@@ -2337,7 +2534,8 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	/*
 	 * Revert to default priority/policy on fork if requested.
 	 */
-	if (unlikely(p->sched_reset_on_fork)) {
+	reset = p->sched_reset_on_fork;
+	if (unlikely(reset)) {
 		if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
@@ -2348,11 +2546,6 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 		p->prio = p->normal_prio = __normal_prio(p);
 		set_load_weight(p, false);
 
-#ifdef CONFIG_UCLAMP_TASK
-		p->uclamp[UCLAMP_MIN] = 0;
-		p->uclamp[UCLAMP_MAX] = SCHED_CAPACITY_SCALE;
-#endif
-
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:
@@ -2369,6 +2562,8 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
+	uclamp_fork(p, reset);
+
 	/*
 	 * The child is not yet in the pid-hash so no cgroup attach races,
 	 * and the cgroup is pinned to this child due to cgroup_fork()
@@ -4613,10 +4808,15 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
-	if (p != NULL)
-		retval = sched_setattr(p, &attr);
+	if (likely(p))
+		get_task_struct(p);
 	rcu_read_unlock();
 
+	if (likely(p)) {
+		retval = sched_setattr(p, &attr);
+		put_task_struct(p);
+	}
+
 	return retval;
 }
 
@@ -4768,8 +4968,8 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 		attr.sched_nice = task_nice(p);
 
 #ifdef CONFIG_UCLAMP_TASK
-	attr.sched_util_min = p->uclamp[UCLAMP_MIN];
-	attr.sched_util_max = p->uclamp[UCLAMP_MAX];
+	attr.sched_util_min = p->uclamp[UCLAMP_MIN].value;
+	attr.sched_util_max = p->uclamp[UCLAMP_MAX].value;
 #endif
 
 	rcu_read_unlock();
@@ -6125,6 +6325,8 @@ void __init sched_init(void)
 
 	psi_init();
 
+	init_uclamp();
+
 	scheduler_running = 1;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 50aa2aba69bd..5de061b055d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10540,6 +10540,10 @@ const struct sched_class fair_sched_class = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_change_group	= task_change_group_fair,
 #endif
+
+#ifdef CONFIG_UCLAMP_TASK
+	.uclamp_enabled		= 1,
+#endif
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d04530bf251f..a0b238156161 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1630,10 +1630,12 @@ extern const u32		sched_prio_to_wmult[40];
 struct sched_class {
 	const struct sched_class *next;
 
+#ifdef CONFIG_UCLAMP_TASK
+	int uclamp_enabled;
+#endif
+
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
-	void (*yield_task)   (struct rq *rq);
-	bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
 
 	void (*check_preempt_curr)(struct rq *rq, struct task_struct *p, int flags);
 
@@ -1666,7 +1668,6 @@ struct sched_class {
 	void (*set_curr_task)(struct rq *rq);
 	void (*task_tick)(struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork)(struct task_struct *p);
-	void (*task_dead)(struct task_struct *p);
 
 	/*
 	 * The switched_from() call is allowed to drop rq->lock, therefore we
@@ -1683,12 +1684,17 @@ struct sched_class {
 
 	void (*update_curr)(struct rq *rq);
 
+	void (*yield_task)   (struct rq *rq);
+	bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
+
 #define TASK_SET_GROUP		0
 #define TASK_MOVE_GROUP		1
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_change_group)(struct task_struct *p, int type);
 #endif
+
+	void (*task_dead)(struct task_struct *p);
 };
 
 static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
@@ -2203,6 +2209,13 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags)
 static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif /* CONFIG_CPU_FREQ */
 
+static inline unsigned int uclamp_none(int clamp_id)
+{
+	if (clamp_id == UCLAMP_MIN)
+		return 0;
+	return SCHED_CAPACITY_SCALE;
+}
+
 #ifdef arch_scale_freq_capacity
 # ifndef arch_scale_freq_invariant
 #  define arch_scale_freq_invariant()	true
-- 
2.19.2
