From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 05/16] sched/core: uclamp: Update CPU's refcount on clamp changes
Date: Tue, 15 Jan 2019 10:15:02 +0000
Message-ID: <20190115101513.2822-6-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Utilization clamp values enforced on a CPU by a task can be updated, for
example via a sched_setattr() syscall, while a task is RUNNABLE on that
CPU. A clamp value change always implies a clamp bucket refcount update
to ensure the new constraints are enforced.

Hook into uclamp_bucket_get() to trigger a CPU refcount syncup, via
uclamp_cpu_{inc,dec}_id(), whenever a task is RUNNABLE.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v6:
 Other:
 - wholesale s/group/bucket/
 - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
 - small documentation updates
---
 kernel/sched/core.c | 48 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 190137cd7b3b..67f059ee0a05 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -884,6 +884,38 @@ static inline void uclamp_cpu_dec(struct rq *rq, struct task_struct *p)
 		uclamp_cpu_dec_id(p, rq, clamp_id);
 }
 
+static inline void
+uclamp_task_update_active(struct task_struct *p, unsigned int clamp_id)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+
+	/*
+	 * Lock the task and the CPU where the task is (or was) queued.
+	 *
+	 * We might lock the (previous) rq of a !RUNNABLE task, but that's the
+	 * price to pay to safely serialize util_{min,max} updates with
+	 * enqueues, dequeues and migration operations.
+	 * This is the same locking schema used by __set_cpus_allowed_ptr().
+	 */
+	rq = task_rq_lock(p, &rf);
+
+	/*
+	 * Setting the clamp bucket is serialized by task_rq_lock().
+	 * If the task is not yet RUNNABLE and its task_struct is not
+	 * affecting a valid clamp bucket, the next time it's enqueued,
+	 * it will already see the updated clamp bucket value.
+	 */
+	if (!p->uclamp[clamp_id].active)
+		goto done;
+
+	uclamp_cpu_dec_id(p, rq, clamp_id);
+	uclamp_cpu_inc_id(p, rq, clamp_id);
+
+done:
+	task_rq_unlock(rq, p, &rf);
+}
+
 static void uclamp_bucket_dec(unsigned int clamp_id, unsigned int bucket_id)
 {
 	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
@@ -907,8 +939,8 @@ static void uclamp_bucket_dec(unsigned int clamp_id, unsigned int bucket_id)
 					  &uc_map_old.data, uc_map_new.data));
 }
 
-static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
-			      unsigned int clamp_value)
+static void uclamp_bucket_inc(struct task_struct *p, struct uclamp_se *uc_se,
+			      unsigned int clamp_id, unsigned int clamp_value)
 {
 	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
 	unsigned int prev_bucket_id = uc_se->bucket_id;
@@ -979,6 +1011,9 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
 	uc_se->value = clamp_value;
 	uc_se->bucket_id = bucket_id;
 
+	if (p)
+		uclamp_task_update_active(p, clamp_id);
+
 	if (uc_se->mapped)
 		uclamp_bucket_dec(clamp_id, prev_bucket_id);
 
@@ -1008,11 +1043,11 @@ static int __setscheduler_uclamp(struct task_struct *p,
 
 	mutex_lock(&uclamp_mutex);
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
-		uclamp_bucket_inc(&p->uclamp[UCLAMP_MIN],
+		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MIN],
 				  UCLAMP_MIN, lower_bound);
 	}
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MAX) {
-		uclamp_bucket_inc(&p->uclamp[UCLAMP_MAX],
+		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MAX],
 				  UCLAMP_MAX, upper_bound);
 	}
 	mutex_unlock(&uclamp_mutex);
@@ -1049,7 +1084,8 @@ static void uclamp_fork(struct task_struct *p, bool reset)
 
 		p->uclamp[clamp_id].mapped = false;
 		p->uclamp[clamp_id].active = false;
-		uclamp_bucket_inc(&p->uclamp[clamp_id], clamp_id, clamp_value);
+		uclamp_bucket_inc(NULL, &p->uclamp[clamp_id],
+				  clamp_id, clamp_value);
 	}
 }
 
@@ -1069,7 +1105,7 @@ static void __init init_uclamp(void)
 	memset(uclamp_maps, 0, sizeof(uclamp_maps));
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
 		uc_se = &init_task.uclamp[clamp_id];
-		uclamp_bucket_inc(uc_se, clamp_id, uclamp_none(clamp_id));
+		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(clamp_id));
 	}
 }
 
-- 
2.19.2
