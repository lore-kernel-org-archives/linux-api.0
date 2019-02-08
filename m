From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v7 06/15] sched/core: uclamp: Reset uclamp values on RESET_ON_FORK
Date: Fri,  8 Feb 2019 10:05:45 +0000
Message-ID: <20190208100554.32196-7-patrick.bellasi@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

A forked tasks gets the same clamp values of its parent however, when
the RESET_ON_FORK flag is set on parent, e.g. via:

   sys_sched_setattr()
      sched_setattr()
         __sched_setscheduler(attr::SCHED_FLAG_RESET_ON_FORK)

the new forked task is expected to start with all attributes reset to
default values.

Do that for utilization clamp values too by caching the reset request
and propagating it into the existing uclamp_fork() call which already
provides the required initialization for other uclamp related bits.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 070caa1f72eb..8b282616e9c9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1071,7 +1071,7 @@ static void __setscheduler_uclamp(struct task_struct *p,
 	}
 }
 
-static void uclamp_fork(struct task_struct *p)
+static void uclamp_fork(struct task_struct *p, bool reset)
 {
 	unsigned int clamp_id;
 
@@ -1080,6 +1080,17 @@ static void uclamp_fork(struct task_struct *p)
 
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
 		p->uclamp[clamp_id].active = false;
+
+	if (likely(!reset))
+		return;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
+		unsigned int clamp_value = uclamp_none(clamp_id);
+
+		p->uclamp[clamp_id].user_defined = false;
+		p->uclamp[clamp_id].value = clamp_value;
+		p->uclamp[clamp_id].bucket_id = uclamp_bucket_id(clamp_value);
+	}
 }
 
 static void __init init_uclamp(void)
@@ -1124,7 +1135,7 @@ static inline int uclamp_validate(struct task_struct *p,
 }
 static void __setscheduler_uclamp(struct task_struct *p,
 				  const struct sched_attr *attr) { }
-static inline void uclamp_fork(struct task_struct *p) { }
+static inline void uclamp_fork(struct task_struct *p, bool reset) { }
 static inline void init_uclamp(void) { }
 #endif /* CONFIG_UCLAMP_TASK */
 
@@ -2711,6 +2722,7 @@ static inline void init_schedstats(void) {}
 int sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long flags;
+	bool reset;
 
 	__sched_fork(clone_flags, p);
 	/*
@@ -2728,7 +2740,8 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	/*
 	 * Revert to default priority/policy on fork if requested.
 	 */
-	if (unlikely(p->sched_reset_on_fork)) {
+	reset = p->sched_reset_on_fork;
+	if (unlikely(reset)) {
 		if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
@@ -2755,7 +2768,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
-	uclamp_fork(p);
+	uclamp_fork(p, reset);
 
 	/*
 	 * The child is not yet in the pid-hash so no cgroup attach races,
-- 
2.20.1
