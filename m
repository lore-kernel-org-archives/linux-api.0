From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping for RT tasks
Date: Tue, 15 Jan 2019 10:15:06 +0000
Message-ID: <20190115101513.2822-10-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Schedutil enforces a maximum frequency when RT tasks are RUNNABLE.
This mandatory policy can be made tunable from userspace to define a max
frequency which is still reasonable for the execution of a specific RT
workload while being also power/energy friendly.

Extend the usage of util_{min,max} to the RT scheduling class.

Add uclamp_default_perf, a special set of clamp values to be used
for tasks requiring maximum performance, i.e. by default all the non
clamped RT tasks.

Since utilization clamping applies now to both CFS and RT tasks,
schedutil clamps the combined utilization of these two classes.
The IOWait boost value is also subject to clamping for RT tasks.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
Changes in v6:
 Others:
 - wholesale s/group/bucket/
 - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
---
 kernel/sched/core.c              | 20 ++++++++++++++++----
 kernel/sched/cpufreq_schedutil.c | 27 +++++++++++++--------------
 kernel/sched/rt.c                |  4 ++++
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d1ea5825501a..1ed01f381641 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -746,6 +746,7 @@ unsigned int sysctl_sched_uclamp_util_max = SCHED_CAPACITY_SCALE;
  * Tasks specific clamp values are required to be within this range
  */
 static struct uclamp_se uclamp_default[UCLAMP_CNT];
+static struct uclamp_se uclamp_default_perf[UCLAMP_CNT];
 
 /**
  * Reference count utilization clamp buckets
@@ -858,16 +859,23 @@ static inline void
 uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
 		     unsigned int *clamp_value, unsigned int *bucket_id)
 {
+	struct uclamp_se *default_clamp;
+
 	/* Task specific clamp value */
 	*clamp_value = p->uclamp[clamp_id].value;
 	*bucket_id = p->uclamp[clamp_id].bucket_id;
 
+	/* RT tasks have different default values */
+	default_clamp = task_has_rt_policy(p)
+		? uclamp_default_perf
+		: uclamp_default;
+
 	/* System default restriction */
-	if (unlikely(*clamp_value < uclamp_default[UCLAMP_MIN].value ||
-		     *clamp_value > uclamp_default[UCLAMP_MAX].value)) {
+	if (unlikely(*clamp_value < default_clamp[UCLAMP_MIN].value ||
+		     *clamp_value > default_clamp[UCLAMP_MAX].value)) {
 		/* Keep it simple: unconditionally enforce system defaults */
-		*clamp_value = uclamp_default[clamp_id].value;
-		*bucket_id = uclamp_default[clamp_id].bucket_id;
+		*clamp_value = default_clamp[clamp_id].value;
+		*bucket_id = default_clamp[clamp_id].bucket_id;
 	}
 }
 
@@ -1282,6 +1290,10 @@ static void __init init_uclamp(void)
 
 		uc_se = &uclamp_default[clamp_id];
 		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(clamp_id));
+
+		/* RT tasks by default will go to max frequency */
+		uc_se = &uclamp_default_perf[clamp_id];
+		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(UCLAMP_MAX));
 	}
 }
 
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 520ee2b785e7..38a05a4f78cc 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -201,9 +201,6 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
 	unsigned long dl_util, util, irq;
 	struct rq *rq = cpu_rq(cpu);
 
-	if (type == FREQUENCY_UTIL && rt_rq_is_runnable(&rq->rt))
-		return max;
-
 	/*
 	 * Early check to see if IRQ/steal time saturates the CPU, can be
 	 * because of inaccuracies in how we track these -- see
@@ -219,15 +216,19 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
 	 * utilization (PELT windows are synchronized) we can directly add them
 	 * to obtain the CPU's actual utilization.
 	 *
-	 * CFS utilization can be boosted or capped, depending on utilization
-	 * clamp constraints requested by currently RUNNABLE tasks.
+	 * CFS and RT utilization can be boosted or capped, depending on
+	 * utilization clamp constraints requested by currently RUNNABLE
+	 * tasks.
 	 * When there are no CFS RUNNABLE tasks, clamps are released and
 	 * frequency will be gracefully reduced with the utilization decay.
 	 */
-	util = (type == ENERGY_UTIL)
-		? util_cfs
-		: uclamp_util(rq, util_cfs);
-	util += cpu_util_rt(rq);
+	util = cpu_util_rt(rq);
+	if (type == FREQUENCY_UTIL) {
+		util += cpu_util_cfs(rq);
+		util  = uclamp_util(rq, util);
+	} else {
+		util += util_cfs;
+	}
 
 	dl_util = cpu_util_dl(rq);
 
@@ -355,13 +356,11 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
 	 *
 	 * Since DL tasks have a much more advanced bandwidth control, it's
 	 * safe to assume that IO boost does not apply to those tasks.
-	 * Instead, since RT tasks are not utilization clamped, we don't want
-	 * to apply clamping on IO boost while there is blocked RT
-	 * utilization.
+	 * Instead, for CFS and RT tasks we clamp the IO boost max value
+	 * considering the current constraints for the CPU.
 	 */
 	max_boost = sg_cpu->iowait_boost_max;
-	if (!cpu_util_rt(cpu_rq(sg_cpu->cpu)))
-		max_boost = uclamp_util(cpu_rq(sg_cpu->cpu), max_boost);
+	max_boost = uclamp_util(cpu_rq(sg_cpu->cpu), max_boost);
 
 	/* Double the boost at each request */
 	if (sg_cpu->iowait_boost) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e4f398ad9e73..614b0bc359cb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2400,6 +2400,10 @@ const struct sched_class rt_sched_class = {
 	.switched_to		= switched_to_rt,
 
 	.update_curr		= update_curr_rt,
+
+#ifdef CONFIG_UCLAMP_TASK
+	.uclamp_enabled		= 1,
+#endif
 };
 
 #ifdef CONFIG_RT_GROUP_SCHED
-- 
2.19.2
