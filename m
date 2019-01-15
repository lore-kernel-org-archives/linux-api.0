From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 10/16] sched/core: Add uclamp_util_with()
Date: Tue, 15 Jan 2019 10:15:07 +0000
Message-ID: <20190115101513.2822-11-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Currently uclamp_util() allows to clamp a specified utilization
considering the clamp values requested by RUNNABLE tasks in a CPU.
Sometimes however, it could be interesting to verify how clamp values
will change when a task is going to be running on a given CPU.
For example, the Energy Aware Scheduler (EAS) is interested in
evaluating and comparing the energy impact of different scheduling
decisions.

Add uclamp_util_with() which allows to clamp a given utilization by
considering the possible impact on CPU clamp values of a specified task.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  |  4 ++--
 kernel/sched/sched.h | 21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1ed01f381641..b41db1190d28 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -904,8 +904,8 @@ static inline unsigned int uclamp_effective_bucket_id(struct task_struct *p,
 	return bucket_id;
 }
 
-static unsigned int uclamp_effective_value(struct task_struct *p,
-					   unsigned int clamp_id)
+unsigned int uclamp_effective_value(struct task_struct *p,
+				    unsigned int clamp_id)
 {
 	unsigned int clamp_value, bucket_id;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 95d62a2a0b44..b7ce3023d023 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2268,11 +2268,20 @@ static inline unsigned int uclamp_none(int clamp_id)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
+unsigned int uclamp_effective_value(struct task_struct *p, unsigned int clamp_id);
+
+static __always_inline
+unsigned int uclamp_util_with(struct rq *rq, unsigned int util,
+			      struct task_struct *p)
 {
 	unsigned int min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
 	unsigned int max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
 
+	if (p) {
+		min_util = max(min_util, uclamp_effective_value(p, UCLAMP_MIN));
+		max_util = max(max_util, uclamp_effective_value(p, UCLAMP_MAX));
+	}
+
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
 	 * RUNNABLE tasks with _different_ clamps, we can end up with an
@@ -2283,7 +2292,17 @@ static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
 
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
2.19.2
