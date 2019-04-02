From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v8 10/16] sched/core: uclamp: Add uclamp_util_with()
Date: Tue,  2 Apr 2019 11:41:46 +0100
Message-ID: <20190402104153.25404-11-patrick.bellasi@arm.com>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402104153.25404-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

So far uclamp_util() allows to clamp a specified utilization considering
the clamp values requested by RUNNABLE tasks in a CPU. For the Energy
Aware Scheduler (EAS) it is interesting to test how clamp values will
change when a task is becoming RUNNABLE on a given CPU.
For example, EAS is interested in comparing the energy impact of
different scheduling decisions and the clamp values can play a role on
that.

Add uclamp_util_with() which allows to clamp a given utilization by
considering the possible impact on CPU clamp values of a specified task.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v8:
 Others:
 - s/uclamp_effective_value()/uclamp_eff_value()/
---
 kernel/sched/sched.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b4c13f3beb2f..a1ed3d94652a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2276,11 +2276,20 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif /* CONFIG_CPU_FREQ */
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
+unsigned int uclamp_eff_value(struct task_struct *p, unsigned int clamp_id);
+
+static __always_inline
+unsigned int uclamp_util_with(struct rq *rq, unsigned int util,
+			      struct task_struct *p)
 {
 	unsigned int min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
 	unsigned int max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
 
+	if (p) {
+		min_util = max(min_util, uclamp_eff_value(p, UCLAMP_MIN));
+		max_util = max(max_util, uclamp_eff_value(p, UCLAMP_MAX));
+	}
+
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
 	 * RUNNABLE tasks with _different_ clamps, we can end up with an
@@ -2291,7 +2300,17 @@ static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
 
 	return clamp(util, min_util, max_util);
 }
+
+static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
+{
+	return uclamp_util_with(rq, util, NULL);
+}
 #else /* CONFIG_UCLAMP_TASK */
+static inline unsigned int uclamp_util_with(struct rq *rq, unsigned int util,
+					    struct task_struct *p)
+{
+	return util;
+}
 static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
 {
 	return util;
-- 
2.20.1
