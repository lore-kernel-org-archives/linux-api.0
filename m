From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 14/16] sched/core: uclamp: Map TG's clamp values into CPU's clamp buckets
Date: Tue, 15 Jan 2019 10:15:11 +0000
Message-ID: <20190115101513.2822-15-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Utilization clamping requires to map each different clamp value into one
of the available clamp buckets used at {en,de}queue time (fast-path).
Each time a TG's clamp value sysfs attribute is updated via:
   cpu_util_{min,max}_write_u64()
we need to update the task group reference to the new value's clamp
bucket and release the reference to the previous one.

Ensure that, whenever a task group is assigned a specific clamp_value,
this is properly translated into a unique clamp bucket to be used in the
fast-path. Do it by slightly refactoring uclamp_bucket_inc() to make the
(*task_struct) parameter optional and by reusing the code already
available for the per-task API.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>

---
Changes in v6:
 Others:
 - wholesale s/group/bucket/
 - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
---
 include/linux/sched.h |  4 ++--
 kernel/sched/core.c   | 53 +++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 05d286524d70..3f02128fe6b2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -617,8 +617,8 @@ struct sched_dl_entity {
  *   uclamp_bucket_dec() - for the old clamp value
  *
  * The active bit is set whenever a task has got an effective clamp bucket
- * and value assigned, which can be different from the user requested ones.
- * This allows to know a task is actually refcounting a CPU's clamp bucket.
+ * and value assigned, and it allows to know a task is actually refcounting a
+ * CPU's clamp bucket.
  */
 struct uclamp_se {
 	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ddbd591b305c..734b769db2ca 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1298,9 +1298,9 @@ static void __init init_uclamp(void)
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 		/* Init root TG's clamp bucket */
 		uc_se = &root_task_group.uclamp[clamp_id];
-		uc_se->value = uclamp_none(clamp_id);
-		uc_se->bucket_id = 0;
-		uc_se->effective.value = uclamp_none(clamp_id);
+		uclamp_bucket_inc(NULL, uc_se, clamp_id, uclamp_none(UCLAMP_MAX));
+		uc_se->effective.bucket_id = uc_se->bucket_id;
+		uc_se->effective.value = uc_se->value;
 #endif
 	}
 }
@@ -6880,6 +6880,16 @@ void ia64_set_curr_task(int cpu, struct task_struct *p)
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
+static inline void free_uclamp_sched_group(struct task_group *tg)
+{
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	int clamp_id;
+
+	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
+		uclamp_bucket_dec(clamp_id, tg->uclamp[clamp_id].bucket_id);
+#endif
+}
+
 static inline int alloc_uclamp_sched_group(struct task_group *tg,
 					   struct task_group *parent)
 {
@@ -6887,12 +6897,12 @@ static inline int alloc_uclamp_sched_group(struct task_group *tg,
 	int clamp_id;
 
 	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
-		tg->uclamp[clamp_id].value =
-			parent->uclamp[clamp_id].value;
-		tg->uclamp[clamp_id].bucket_id =
-			parent->uclamp[clamp_id].bucket_id;
+		uclamp_bucket_inc(NULL, &tg->uclamp[clamp_id], clamp_id,
+				  parent->uclamp[clamp_id].value);
 		tg->uclamp[clamp_id].effective.value =
 			parent->uclamp[clamp_id].effective.value;
+		tg->uclamp[clamp_id].effective.bucket_id =
+			parent->uclamp[clamp_id].effective.bucket_id;
 	}
 #endif
 
@@ -6901,6 +6911,7 @@ static inline int alloc_uclamp_sched_group(struct task_group *tg,
 
 static void sched_free_group(struct task_group *tg)
 {
+	free_uclamp_sched_group(tg);
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
 	autogroup_free(tg);
@@ -7147,7 +7158,8 @@ static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 static void cpu_util_update_hier(struct cgroup_subsys_state *css,
-				 int clamp_id, unsigned int value)
+				 unsigned int clamp_id, unsigned int bucket_id,
+				 unsigned int value)
 {
 	struct cgroup_subsys_state *top_css = css;
 	struct uclamp_se *uc_se, *uc_parent;
@@ -7159,8 +7171,10 @@ static void cpu_util_update_hier(struct cgroup_subsys_state *css,
 		 * groups we consider their current value.
 		 */
 		uc_se = &css_tg(css)->uclamp[clamp_id];
-		if (css != top_css)
+		if (css != top_css) {
 			value = uc_se->value;
+			bucket_id = uc_se->effective.bucket_id;
+		}
 
 		/*
 		 * Skip the whole subtrees if the current effective clamp is
@@ -7176,12 +7190,15 @@ static void cpu_util_update_hier(struct cgroup_subsys_state *css,
 		}
 
 		/* Propagate the most restrictive effective value */
-		if (uc_parent->effective.value < value)
+		if (uc_parent->effective.value < value) {
 			value = uc_parent->effective.value;
+			bucket_id = uc_parent->effective.bucket_id;
+		}
 		if (uc_se->effective.value == value)
 			continue;
 
 		uc_se->effective.value = value;
+		uc_se->effective.bucket_id = bucket_id;
 	}
 }
 
@@ -7194,6 +7211,7 @@ static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 	if (min_value > SCHED_CAPACITY_SCALE)
 		return -ERANGE;
 
+	mutex_lock(&uclamp_mutex);
 	rcu_read_lock();
 
 	tg = css_tg(css);
@@ -7204,11 +7222,16 @@ static int cpu_util_min_write_u64(struct cgroup_subsys_state *css,
 		goto out;
 	}
 
+	/* Update TG's reference count */
+	uclamp_bucket_inc(NULL, &tg->uclamp[UCLAMP_MIN], UCLAMP_MIN, min_value);
+
 	/* Update effective clamps to track the most restrictive value */
-	cpu_util_update_hier(css, UCLAMP_MIN, min_value);
+	cpu_util_update_hier(css, UCLAMP_MIN, tg->uclamp[UCLAMP_MIN].bucket_id,
+			     min_value);
 
 out:
 	rcu_read_unlock();
+	mutex_unlock(&uclamp_mutex);
 
 	return ret;
 }
@@ -7222,6 +7245,7 @@ static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
 	if (max_value > SCHED_CAPACITY_SCALE)
 		return -ERANGE;
 
+	mutex_lock(&uclamp_mutex);
 	rcu_read_lock();
 
 	tg = css_tg(css);
@@ -7232,11 +7256,16 @@ static int cpu_util_max_write_u64(struct cgroup_subsys_state *css,
 		goto out;
 	}
 
+	/* Update TG's reference count */
+	uclamp_bucket_inc(NULL, &tg->uclamp[UCLAMP_MAX], UCLAMP_MAX, max_value);
+
 	/* Update effective clamps to track the most restrictive value */
-	cpu_util_update_hier(css, UCLAMP_MAX, max_value);
+	cpu_util_update_hier(css, UCLAMP_MAX, tg->uclamp[UCLAMP_MAX].bucket_id,
+			     max_value);
 
 out:
 	rcu_read_unlock();
+	mutex_unlock(&uclamp_mutex);
 
 	return ret;
 }
-- 
2.19.2
