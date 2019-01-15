From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v6 06/16] sched/core: uclamp: Enforce last task UCLAMP_MAX
Date: Tue, 15 Jan 2019 10:15:03 +0000
Message-ID: <20190115101513.2822-7-patrick.bellasi@arm.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190115101513.2822-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

When the task sleeps, it removes its max utilization clamp from its CPU.
However, the blocked utilization on that CPU can be higher than the max
clamp value enforced while the task was running. This allows undesired
CPU frequency increases while a CPU is idle, for example, when another
CPU on the same frequency domain triggers a frequency update, since
schedutil can now see the full not clamped blocked utilization of the
idle CPU.

Fix this by using
  uclamp_cpu_dec_id(p, rq, UCLAMP_MAX)
    uclamp_cpu_update(rq, UCLAMP_MAX, clamp_value)
to detect when a CPU has no more RUNNABLE clamped tasks and to flag this
condition.

Don't track any minimum utilization clamps since an idle CPU never
requires a minimum frequency. The decay of the blocked utilization is
good enough to reduce the CPU frequency.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
Changes in v6:
 Others:
 - moved UCLAMP_FLAG_IDLE management into dedicated functions:
   uclamp_idle_value() and uclamp_idle_reset()
 - switched from rq::uclamp::flags to rq::uclamp_flags, since now
   rq::uclamp is a per-clamp_id array
---
 kernel/sched/core.c  | 51 +++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h |  2 ++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67f059ee0a05..b7ac516a70be 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -766,9 +766,45 @@ static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
 	return UCLAMP_BUCKET_DELTA * (clamp_value / UCLAMP_BUCKET_DELTA);
 }
 
-static inline void uclamp_cpu_update(struct rq *rq, unsigned int clamp_id)
+static inline unsigned int
+uclamp_idle_value(struct rq *rq, unsigned int clamp_id, unsigned int clamp_value)
+{
+	/*
+	 * Avoid blocked utilization pushing up the frequency when we go
+	 * idle (which drops the max-clamp) by retaining the last known
+	 * max-clamp.
+	 */
+	if (clamp_id == UCLAMP_MAX) {
+		rq->uclamp_flags |= UCLAMP_FLAG_IDLE;
+		return clamp_value;
+	}
+
+	return uclamp_none(UCLAMP_MIN);
+}
+
+static inline void uclamp_idle_reset(struct rq *rq, unsigned int clamp_id,
+				     unsigned int clamp_value)
+{
+	/* Reset max-clamp retention only on idle exit */
+	if (!(rq->uclamp_flags & UCLAMP_FLAG_IDLE))
+		return;
+
+	WRITE_ONCE(rq->uclamp[clamp_id].value, clamp_value);
+
+	/*
+	 * This function is called for both UCLAMP_MIN (before) and UCLAMP_MAX
+	 * (after). The idle flag is reset only the second time, when we know
+	 * that UCLAMP_MIN has been already updated.
+	 */
+	if (clamp_id == UCLAMP_MAX)
+		rq->uclamp_flags &= ~UCLAMP_FLAG_IDLE;
+}
+
+static inline void uclamp_cpu_update(struct rq *rq, unsigned int clamp_id,
+				     unsigned int clamp_value)
 {
 	unsigned int max_value = 0;
+	bool buckets_active = false;
 	unsigned int bucket_id;
 
 	for (bucket_id = 0; bucket_id < UCLAMP_BUCKETS; ++bucket_id) {
@@ -776,6 +812,7 @@ static inline void uclamp_cpu_update(struct rq *rq, unsigned int clamp_id)
 
 		if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)
 			continue;
+		buckets_active = true;
 
 		/* Both min and max clamps are MAX aggregated */
 		bucket_value = rq->uclamp[clamp_id].bucket[bucket_id].value;
@@ -783,6 +820,10 @@ static inline void uclamp_cpu_update(struct rq *rq, unsigned int clamp_id)
 		if (max_value >= SCHED_CAPACITY_SCALE)
 			break;
 	}
+
+	if (unlikely(!buckets_active))
+		max_value = uclamp_idle_value(rq, clamp_id, clamp_value);
+
 	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
 }
 
@@ -808,8 +849,11 @@ static inline void uclamp_cpu_inc_id(struct task_struct *p, struct rq *rq,
 
 	rq->uclamp[clamp_id].bucket[bucket_id].tasks++;
 
-	/* CPU's clamp buckets track the max effective clamp value */
+	/* Reset clamp holds on idle exit */
 	tsk_clamp = p->uclamp[clamp_id].value;
+	uclamp_idle_reset(rq, clamp_id, tsk_clamp);
+
+	/* CPU's clamp buckets track the max effective clamp value */
 	grp_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
 	rq->uclamp[clamp_id].bucket[bucket_id].value = max(grp_clamp, tsk_clamp);
 
@@ -858,7 +902,7 @@ static inline void uclamp_cpu_dec_id(struct task_struct *p, struct rq *rq,
 		 */
 		rq->uclamp[clamp_id].bucket[bucket_id].value =
 			uclamp_maps[clamp_id][bucket_id].value;
-		uclamp_cpu_update(rq, clamp_id);
+		uclamp_cpu_update(rq, clamp_id, clamp_value);
 	}
 }
 
@@ -1100,6 +1144,7 @@ static void __init init_uclamp(void)
 	for_each_possible_cpu(cpu) {
 		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_cpu));
 		cpu_rq(cpu)->uclamp[UCLAMP_MAX].value = uclamp_none(UCLAMP_MAX);
+		cpu_rq(cpu)->uclamp_flags = 0;
 	}
 
 	memset(uclamp_maps, 0, sizeof(uclamp_maps));
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 06ff7d890ff6..b7f3ee8ba164 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -882,6 +882,8 @@ struct rq {
 #ifdef CONFIG_UCLAMP_TASK
 	/* Utilization clamp values based on CPU's RUNNABLE tasks */
 	struct uclamp_cpu	uclamp[UCLAMP_CNT] ____cacheline_aligned;
+	unsigned int		uclamp_flags;
+#define UCLAMP_FLAG_IDLE 0x01
 #endif
 
 	struct cfs_rq		cfs;
-- 
2.19.2
