From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v8 09/16] sched/cpufreq: uclamp: Add clamps for FAIR and RT tasks
Date: Tue,  2 Apr 2019 11:41:45 +0100
Message-ID: <20190402104153.25404-10-patrick.bellasi@arm.com>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402104153.25404-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Each time a frequency update is required via schedutil, a frequency is
selected to (possibly) satisfy the utilization reported by each
scheduling class and irqs. However, when utilization clamping is in use,
the frequency selection should consider userspace utilization clamping
hints.  This will allow, for example, to:

 - boost tasks which are directly affecting the user experience
   by running them at least at a minimum "requested" frequency

 - cap low priority tasks not directly affecting the user experience
   by running them only up to a maximum "allowed" frequency

These constraints are meant to support a per-task based tuning of the
frequency selection thus supporting a fine grained definition of
performance boosting vs energy saving strategies in kernel space.

Add support to clamp the utilization of RUNNABLE FAIR and RT tasks
within the boundaries defined by their aggregated utilization clamp
constraints.

Do that by considering the max(min_util, max_util) to give boosted tasks
the performance they need even when they happen to be co-scheduled with
other capped tasks.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/sched/cpufreq_schedutil.c | 15 ++++++++++++---
 kernel/sched/fair.c              |  4 ++++
 kernel/sched/rt.c                |  4 ++++
 kernel/sched/sched.h             | 23 +++++++++++++++++++++++
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 033ec7c45f13..70a8b87fa29c 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -201,8 +201,10 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
 	unsigned long dl_util, util, irq;
 	struct rq *rq = cpu_rq(cpu);
 
-	if (type == FREQUENCY_UTIL && rt_rq_is_runnable(&rq->rt))
+	if (!IS_BUILTIN(CONFIG_UCLAMP_TASK) &&
+	    type == FREQUENCY_UTIL && rt_rq_is_runnable(&rq->rt)) {
 		return max;
+	}
 
 	/*
 	 * Early check to see if IRQ/steal time saturates the CPU, can be
@@ -218,9 +220,16 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
 	 * CFS tasks and we use the same metric to track the effective
 	 * utilization (PELT windows are synchronized) we can directly add them
 	 * to obtain the CPU's actual utilization.
+	 *
+	 * CFS and RT utilization can be boosted or capped, depending on
+	 * utilization clamp constraints requested by currently RUNNABLE
+	 * tasks.
+	 * When there are no CFS RUNNABLE tasks, clamps are released and
+	 * frequency will be gracefully reduced with the utilization decay.
 	 */
-	util = util_cfs;
-	util += cpu_util_rt(rq);
+	util = util_cfs + cpu_util_rt(rq);
+	if (type == FREQUENCY_UTIL)
+		util = uclamp_util(rq, util);
 
 	dl_util = cpu_util_dl(rq);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8213ff6e365d..1ac98204de86 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10617,6 +10617,10 @@ const struct sched_class fair_sched_class = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_change_group	= task_change_group_fair,
 #endif
+
+#ifdef CONFIG_UCLAMP_TASK
+	.uclamp_enabled		= 1,
+#endif
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 90fa23d36565..d968f7209656 100644
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d8b182f1782c..b4c13f3beb2f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2275,6 +2275,29 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags)
 static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif /* CONFIG_CPU_FREQ */
 
+#ifdef CONFIG_UCLAMP_TASK
+static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
+{
+	unsigned int min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
+	unsigned int max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
+
+	/*
+	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
+	 * RUNNABLE tasks with _different_ clamps, we can end up with an
+	 * inversion. Fix it now when the clamps are applied.
+	 */
+	if (unlikely(min_util >= max_util))
+		return min_util;
+
+	return clamp(util, min_util, max_util);
+}
+#else /* CONFIG_UCLAMP_TASK */
+static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
+{
+	return util;
+}
+#endif /* CONFIG_UCLAMP_TASK */
+
 #ifdef arch_scale_freq_capacity
 # ifndef arch_scale_freq_invariant
 #  define arch_scale_freq_invariant()	true
-- 
2.20.1
