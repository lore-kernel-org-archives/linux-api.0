From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: [PATCH v7 13/15] sched/core: uclamp: Propagate system defaults to root group
Date: Fri,  8 Feb 2019 10:05:52 +0000
Message-ID: <20190208100554.32196-14-patrick.bellasi@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-1-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

The clamp values are not tunable at the level of the root task group.
That's for two main reasons:

 - the root group represents "system resources" which are always
   entirely available from the cgroup standpoint.

 - when tuning/restricting "system resources" makes sense, tuning must
   be done using a system wide API which should also be available when
   control groups are not.

When a system wide restriction is available, cgroups should be aware of
its value in order to know exactly how much "system resources" are
available for the subgroups.

Utilization clamping supports already the concepts of:

 - system defaults: which define the maximum possible clamp values
   usable by tasks.

 - effective clamps: which allows a parent cgroup to constraint (maybe
   temporarily) its descendants without losing the information related
   to the values "requested" from them.

Exploit these two concepts and bind them together in such a way that,
whenever system default are tuned, the new values are propagated to
(possibly) restrict or relax the "effective" value of nested cgroups.

Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/sched/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1e54517acd58..35e9f06af08d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -990,6 +990,14 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 		uclamp_rq_dec_id(p, rq, clamp_id);
 }
 
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+static void cpu_util_update_hier(struct cgroup_subsys_state *css,
+				 unsigned int clamp_id, unsigned int bucket_id,
+				 unsigned int value);
+#else
+#define cpu_util_update_hier(...)
+#endif
+
 int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
@@ -1025,6 +1033,13 @@ int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
 			uclamp_bucket_id(sysctl_sched_uclamp_util_max);
 	}
 
+	cpu_util_update_hier(&root_task_group.css, UCLAMP_MIN,
+			     uclamp_default[UCLAMP_MIN].bucket_id,
+			     uclamp_default[UCLAMP_MIN].value);
+	cpu_util_update_hier(&root_task_group.css, UCLAMP_MAX,
+			     uclamp_default[UCLAMP_MAX].bucket_id,
+			     uclamp_default[UCLAMP_MAX].value);
+
 	/*
 	 * Updating all the RUNNABLE task is expensive, keep it simple and do
 	 * just a lazy update at each next enqueue time.
-- 
2.20.1
