From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v7 07/15] sched/core: uclamp: Set default clamps for RT tasks
Date: Fri,  8 Feb 2019 10:05:46 +0000
Message-ID: <20190208100554.32196-8-patrick.bellasi@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

By default FAIR tasks start without clamps, i.e. neither boosted nor
capped, and they run at the best frequency matching their utilization
demand.  This default behavior does not fit RT tasks which instead are
expected to run at the maximum available frequency, if not otherwise
required by explicitly capping them.

Enforce the correct behavior for RT tasks by setting util_min to max
whenever:

 1. a task is switched to the RT class and it does not already have a
    user-defined clamp value assigned.

 2. a task is forked from a parent with RESET_ON_FORK set.

NOTE: utilization clamp values are cross scheduling class attributes and
thus they are never changed/reset once a value has been explicitly
defined from user-space.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8b282616e9c9..569564012ddc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1049,6 +1049,28 @@ static int uclamp_validate(struct task_struct *p,
 static void __setscheduler_uclamp(struct task_struct *p,
 				  const struct sched_attr *attr)
 {
+	unsigned int clamp_id;
+
+	/*
+	 * On scheduling class change, reset to default clamps for tasks
+	 * without a task-specific value.
+	 */
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		unsigned int clamp_value = uclamp_none(clamp_id);
+		struct uclamp_se *uc_se = &p->uclamp[clamp_id];
+
+		/* Keep using defined clamps across class changes */
+		if (uc_se->user_defined)
+			continue;
+
+		/* By default, RT tasks always get 100% boost */
+		if (unlikely(rt_task(p) && clamp_id == UCLAMP_MIN))
+			clamp_value = uclamp_none(UCLAMP_MAX);
+
+		uc_se->bucket_id = uclamp_bucket_id(clamp_value);
+		uc_se->value = clamp_value;
+	}
+
 	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)))
 		return;
 
@@ -1087,6 +1109,10 @@ static void uclamp_fork(struct task_struct *p, bool reset)
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
 		unsigned int clamp_value = uclamp_none(clamp_id);
 
+		/* By default, RT tasks always get 100% boost */
+		if (unlikely(rt_task(p) && clamp_id == UCLAMP_MIN))
+			clamp_value = uclamp_none(UCLAMP_MAX);
+
 		p->uclamp[clamp_id].user_defined = false;
 		p->uclamp[clamp_id].value = clamp_value;
 		p->uclamp[clamp_id].bucket_id = uclamp_bucket_id(clamp_value);
-- 
2.20.1
