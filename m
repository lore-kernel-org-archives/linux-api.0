From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v14 4/6] sched/core: uclamp: Use TG's clamps to restrict TASK's clamps
Date: Thu, 22 Aug 2019 14:28:09 +0100
Message-ID: <20190822132811.31294-5-patrick.bellasi@arm.com>
References: <20190822132811.31294-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190822132811.31294-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org

When a task specific clamp value is configured via sched_setattr(2), this
value is accounted in the corresponding clamp bucket every time the task is
{en,de}qeued. However, when cgroups are also in use, the task specific
clamp values could be restricted by the task_group (TG) clamp values.

Update uclamp_cpu_inc() to aggregate task and TG clamp values. Every time a
task is enqueued, it's accounted in the clamp bucket tracking the smaller
clamp between the task specific value and its TG effective value. This
allows to:

1. ensure cgroup clamps are always used to restrict task specific requests,
   i.e. boosted not more than its TG effective protection and capped at
   least as its TG effective limit.

2. implement a "nice-like" policy, where tasks are still allowed to request
   less than what enforced by their TG effective limits and protections

Do this by exploiting the concept of "effective" clamp, which is already
used by a TG to track parent enforced restrictions.

Apply task group clamp restrictions only to tasks belonging to a child
group. While, for tasks in the root group or in an autogroup, system
defaults are still enforced.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Reviewed-by: Michal Koutny <mkoutny@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/sched/core.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3ca054ad3f3e..04fc161e4dbe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -873,16 +873,42 @@ unsigned int uclamp_rq_max_value(struct rq *rq, unsigned int clamp_id,
 	return uclamp_idle_value(rq, clamp_id, clamp_value);
 }
 
+static inline struct uclamp_se
+uclamp_tg_restrict(struct task_struct *p, unsigned int clamp_id)
+{
+	struct uclamp_se uc_req = p->uclamp_req[clamp_id];
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	struct uclamp_se uc_max;
+
+	/*
+	 * Tasks in autogroups or root task group will be
+	 * restricted by system defaults.
+	 */
+	if (task_group_is_autogroup(task_group(p)))
+		return uc_req;
+	if (task_group(p) == &root_task_group)
+		return uc_req;
+
+	uc_max = task_group(p)->uclamp[clamp_id];
+	if (uc_req.value > uc_max.value || !uc_req.user_defined)
+		return uc_max;
+#endif
+
+	return uc_req;
+}
+
 /*
  * The effective clamp bucket index of a task depends on, by increasing
  * priority:
  * - the task specific clamp value, when explicitly requested from userspace
+ * - the task group effective clamp value, for tasks not either in the root
+ *   group or in an autogroup
  * - the system default clamp value, defined by the sysadmin
  */
 static inline struct uclamp_se
 uclamp_eff_get(struct task_struct *p, unsigned int clamp_id)
 {
-	struct uclamp_se uc_req = p->uclamp_req[clamp_id];
+	struct uclamp_se uc_req = uclamp_tg_restrict(p, clamp_id);
 	struct uclamp_se uc_max = uclamp_default[clamp_id];
 
 	/* System default restrictions always apply */
-- 
2.22.0
