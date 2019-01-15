From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 16/16] sched/core: uclamp: Update CPU's refcount on TG's clamp changes
Date: Tue, 15 Jan 2019 10:15:13 +0000
Message-ID: <20190115101513.2822-17-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On updates of task group (TG) clamp values, ensure that these new values
are enforced on all RUNNABLE tasks of the task group, i.e. all RUNNABLE
tasks are immediately boosted and/or clamped as requested.

Do that by slightly refactoring uclamp_bucket_inc(). An additional
parameter *cgroup_subsys_state (css) is used to walk the list of tasks
in the TGs and update the RUNNABLE ones. Do that by taking the rq
lock for each task, the same mechanism used for cpu affinity masks
updates.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>

---
Changes in v6:
 Others:
 - wholesale s/group/bucket/
 - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
 - small documentation updates
---
 kernel/sched/core.c | 56 +++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c8d1fc9880ff..36866a1b9f9d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1111,7 +1111,22 @@ static void uclamp_bucket_dec(unsigned int clamp_id, unsigned int bucket_id)
 					  &uc_map_old.data, uc_map_new.data));
 }
 
-static void uclamp_bucket_inc(struct task_struct *p, struct uclamp_se *uc_se,
+static inline void uclamp_bucket_inc_tg(struct cgroup_subsys_state *css,
+					int clamp_id, unsigned int bucket_id)
+{
+	struct css_task_iter it;
+	struct task_struct *p;
+
+	/* Update clamp buckets for RUNNABLE tasks in this TG */
+	css_task_iter_start(css, 0, &it);
+	while ((p = css_task_iter_next(&it)))
+		uclamp_task_update_active(p, clamp_id);
+	css_task_iter_end(&it);
+}
+
+static void uclamp_bucket_inc(struct task_struct *p,
+			      struct cgroup_subsys_state *css,
+			      struct uclamp_se *uc_se,
 			      unsigned int clamp_id, unsigned int clamp_value)
 {
 	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
@@ -1183,6 +1198,9 @@ static void uclamp_bucket_inc(struct task_struct *p, struct uclamp_se *uc_se,
 	uc_se->value = clamp_value;
 	uc_se->bucket_id = bucket_id;
 
+	if (css)
+		uclamp_bucket_inc_tg(css, clamp_id, bucket_id);
+
 	if (p)
 		uclamp_task_update_active(p, clamp_id);
 
@@ -1221,11 +1239,11 @@ int sched_uclamp_handler(struct ctl_table *table, int write,
 	}
 
 	if (old_min != sysctl_sched_uclamp_util_min) {
-		uclamp_bucket_inc(NULL, &uclamp_default[UCLAMP_MIN],
+		uclamp_bucket_inc(NULL, NULL, &uclamp_default[UCLAMP_MIN],
 				  UCLAMP_MIN, sysctl_sched_uclamp_util_min);
 	}
 	if (old_max != sysctl_sched_uclamp_util_max) {
-		uclamp_bucket_inc(NULL, &uclamp_default[UCLAMP_MAX],
+		uclamp_bucket_inc(NULL, NULL, &uclamp_default[UCLAMP_MAX],
 				  UCLAMP_MAX, sysctl_sched_uclamp_util_max);
 	}
 	goto done;
@@ -1260,12 +1278,12 @@ static int __setscheduler_uclamp(struct task_struct *p,
 	mutex_lock(&uclamp_mutex);
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		p->uclamp[UCLAMP_MIN].user_defined = true;
-		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MIN],
+		uclamp_bucket_inc(p, NULL, &p->uclamp[UCLAMP_MIN],
 				  UCLAMP_MIN, lower_bound);
 	}
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MAX) {
 		p->uclamp[UCLAMP_MAX].user_defined = true;
-		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MAX],
+		uclamp_bucket_inc(p, NULL, &p->uclamp[UCLAMP_MAX],
 				  UCLAMP_MAX, upper_bound);
 	}
 	mutex_unlock(&uclamp_mutex);
@@ -1304,7 +1322,7 @@ static void uclamp_fork(struct task_struct *p, bool reset)
 
 		p->uclamp[clamp_id].mapped = false;
 		p->uclamp[clamp_id].active = false;
-		uclamp_bucket_inc(NULL, &p->uclamp[clamp_id],
+		uclamp_bucket_inc(NULL, NULL, &p->uclamp[clamp_id],
 				  clamp_id, clamp_value);
 	}
 }
@@ -1326,19 +1344,23 @@ static void __init init_uclamp(void)
 	memset(uclamp_maps, 0, sizeof(uclamp_maps));
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
 		uc_se = &init_task.uclamp[clamp_id];
-		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(clamp_id));
+		uclamp_bucket_inc(NULL, NULL, uc_se, clamp_id,
+				  uclamp_none(clamp_id));
 
 		uc_se = &uclamp_default[clamp_id];
-		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(clamp_id));
+		uclamp_bucket_inc(NULL, NULL, uc_se, clamp_id,
+				  uclamp_none(clamp_id));
 
 		/* RT tasks by default will go to max frequency */
 		uc_se = &uclamp_default_perf[clamp_id];
-		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(UCLAMP_MAX));
+		uclamp_bucket_inc(NULL, NULL, uc_se, clamp_id,
+				  uclamp_none(UCLAMP_MAX));
 
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 		/* Init root TG's clamp bucket */
 		uc_se = &root_task_group.uclamp[clamp_id];
-		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(UCLAMP_MAX));
+		uclamp_bucket_inc(NULL, NULL, uc_se, clamp_id,
+				  uclamp_none(UCLAMP_MAX));
 		uc_se->effective.bucket_id = uc_se->bucket_id;
 		uc_se->effective.value = uc_se->value;
 #endif
@@ -6937,8 +6959,8 @@ static inline int alloc_uclamp_sched_group(struct task_group *tg,
 	int clamp_id;
 
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
-		uclamp_bucket_inc(NULL, &tg->uclamp[clamp_id], clamp_id,
-				  parent->uclamp[clamp_id].value);
+		uclamp_bucket_inc(NULL, NULL, &tg->uclamp[clamp_id],
+				  clamp_id, parent->uclamp[clamp_id].value);
 		tg->uclamp[clamp_id].effective.value =
 			parent->uclamp[clamp_id].effective.value;
 		tg->uclamp[clamp_id].effective.bucket_id =
@@ -7239,6 +7261,10 @@ static void cpu_util_update_hier(struct cgroup_subsys_state *css,
 
 		uc_se->effective.value = value;
 		uc_se->effective.bucket_id = bucket_id;
+
+		/* Immediately updated descendants active tasks */
+		if (css != top_css)
+			uclamp_bucket_inc_tg(css, clamp_id, bucket_id);
 	}
 }
 
@@ -7263,7 +7289,8 @@ static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 	}
 
 	/* Update TG's reference count */
-	uclamp_bucket_inc(NULL, &tg->uclamp[UCLAMP_MIN], UCLAMP_MIN, min_value);
+	uclamp_bucket_inc(NULL, css, &tg->uclamp[UCLAMP_MIN],
+			  UCLAMP_MIN, min_value);
 
 	/* Update effective clamps to track the most restrictive value */
 	cpu_util_update_hier(css, UCLAMP_MIN, tg->uclamp[UCLAMP_MIN].bucket_id,
@@ -7297,7 +7324,8 @@ static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
 	}
 
 	/* Update TG's reference count */
-	uclamp_bucket_inc(NULL, &tg->uclamp[UCLAMP_MAX], UCLAMP_MAX, max_value);
+	uclamp_bucket_inc(NULL, css, &tg->uclamp[UCLAMP_MAX],
+			  UCLAMP_MAX, max_value);
 
 	/* Update effective clamps to track the most restrictive value */
 	cpu_util_update_hier(css, UCLAMP_MAX, tg->uclamp[UCLAMP_MAX].bucket_id,
-- 
2.19.2
