From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/10] cgroup, sched: implement PRIO_RGRP for {set|get}priority()
Date: Fri, 11 Mar 2016 10:41:28 -0500
Message-ID: <1457710888-31182-11-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

One of the missing features in cgroup v2 is the ability to control cpu
cycle distribution hierarchically among threads of a process.  With
rgroup infrastructure in place, this can be implemented as a natural
extension of setpriority().

This patch introduces a new @which selector PRIO_RGRP for
{set|get}priority() which can be used only when the calling thread is
in a rgroup and respectively sets and gets the nice priority of the
rgroup that the calling thread belongs to.  The nice values have
exactly the same meaning as for a single task and top-level rgroups
compete with peer tasks as if the entire subtree is a single task with
the specified nice value.

setpriority(PRIO_RGRP, nice) automatically enables cpu controller upto
the rgroup of the thread.  The cpu controller is available iff it's
mounted on the default hierarchy and available on the nearest sgroup
(ie. the parent of the nearest sgroup should have it enabled in its
subtree_control).  If the controller isn't available, setpriority()
fails with -ENODEV.

If the cpu controller is made unavailable either through clearing of
subtree_control or migration to a cgroup which doesn't have it
available, cpu controller is disabled for the affected rgroup
subtrees.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h        |   4 +
 include/linux/sched.h         |   5 ++
 include/uapi/linux/resource.h |   1 +
 kernel/cgroup.c               | 190 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c           |  32 +++++++
 kernel/sys.c                  |  11 ++-
 6 files changed, 241 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ca1ec50..885c29e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -110,6 +110,8 @@ extern void cgroup_post_fork(struct task_struct *p, unsigned long clone_flags,
 int cgroup_exec(void);
 void cgroup_exit(struct task_struct *p);
 void cgroup_free(struct task_struct *p);
+int rgroup_setpriority(pid_t vpid, int nice);
+int rgroup_getpriority(pid_t vpid);
 
 int cgroup_init_early(void);
 int cgroup_init(void);
@@ -552,6 +554,8 @@ static inline void cgroup_post_fork(struct task_struct *p,
 static inline int cgroup_exec(void) { return 0; }
 static inline void cgroup_exit(struct task_struct *p) {}
 static inline void cgroup_free(struct task_struct *p) {}
+static inline int rgroup_setpriority(pid_t vpid, int nice) { return -ENODEV; }
+static inline int rgroup_getpriority(pid_t vpid) { return -ENODEV; }
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d3849ad..36fc5cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2371,6 +2371,11 @@ extern u64 scheduler_tick_max_deferment(void);
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+extern int cpu_cgroup_setpriority(struct cgroup_subsys_state *css, int nice);
+extern int cpu_cgroup_getpriority(struct cgroup_subsys_state *css);
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/include/uapi/linux/resource.h b/include/uapi/linux/resource.h
index 36fb3b5..da15cb1 100644
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -57,6 +57,7 @@ struct rlimit64 {
 #define	PRIO_PROCESS	0
 #define	PRIO_PGRP	1
 #define	PRIO_USER	2
+#define	PRIO_RGRP	3
 
 /*
  * Limit the stack by to some sane default: root can always
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6107a1f..92eb74d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6305,6 +6305,196 @@ void cgroup_free(struct task_struct *task)
 	put_css_set(cset);
 }
 
+/**
+ * task_rgroup_lock_and_drain_offline - lock a task's rgroup and drain
+ * @task: target task
+ *
+ * Look up @task's rgroup, lock, drain and return it.  If @task doesn't
+ * belong to a rgroup, ERR_PTR(-ENODEV) is returned.
+ */
+static struct cgroup *
+task_rgroup_lock_and_drain_offline(struct task_struct *task)
+{
+	struct cgroup *rgrp;
+
+retry:
+	rcu_read_lock();
+
+	do {
+		rgrp = task_css_set(task)->dfl_cgrp;
+		if (!is_rgroup(rgrp)) {
+			rcu_read_unlock();
+			return ERR_PTR(-ENODEV);
+		}
+
+		if (!cgroup_tryget(rgrp)) {
+			cpu_relax();
+			continue;
+		}
+	} while (false);
+
+	rcu_read_unlock();
+
+	cgroup_lock_and_drain_offline(rgrp);
+
+	/* did we race against migration? */
+	if (rgrp != task_css_set(task)->dfl_cgrp) {
+		cgroup_unlock();
+		goto retry;
+	}
+
+	/*
+	 * @task can't be moved to another cgroup while cgroup_mutex is
+	 * held.  No need to hold the extra reference.
+	 */
+	cgroup_put(rgrp);
+
+	return rgrp;
+}
+
+/**
+ * vpid_rgroup_lock_and_drain_offline - lock a vpid's rgroup and drain
+ * @vpid: target vpid
+ * @taskp: out paramter for the found task
+ *
+ * Look up the task for @vpid.  If @vpid is zero, %current is used.  If the
+ * task is found, look up its rgroup, lock, drain and return it.  On
+ * success, the task's refcnt is incremented and the *@taskp points to it.
+ * An ERR_PTR() value is returned on failure.
+ */
+static struct cgroup *
+vpid_rgroup_lock_and_drain_offline(pid_t vpid, struct task_struct **taskp)
+{
+	struct task_struct *task;
+	struct cgroup *rgrp;
+
+	rcu_read_lock();
+	if (vpid) {
+		task = find_task_by_vpid(vpid);
+		if (!task) {
+			rcu_read_unlock();
+			return ERR_PTR(-ESRCH);
+		}
+	} else {
+		task = current;
+	}
+	get_task_struct(task);
+	rcu_read_unlock();
+
+	rgrp = task_rgroup_lock_and_drain_offline(task);
+	if (IS_ERR(rgrp))
+		put_task_struct(task);
+	else
+		*taskp = task;
+
+	return rgrp;
+}
+
+/**
+ * rgroup_enable_subsys - enable a subsystem on a rgroup
+ * @rgrp: target rgroup
+ * @sgrp: nearest sgroup of @rgrp
+ * @ss: subsystem to enable
+ *
+ * Try to enable @ss on @rgrp.  On success, 0 is returned and @ss is
+ * enabled on @rgrp; otherwise, -errno is returned.  The caller must always
+ * call cgroup_finalize_control() afterwards.
+ */
+static int __maybe_unused rgroup_enable_subsys(struct cgroup *rgrp,
+					       struct cgroup *sgrp,
+					       struct cgroup_subsys *ss)
+{
+	struct cgroup *pos;
+	int ret;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	cgroup_save_control(sgrp);
+
+	for (pos = rgrp; pos != sgrp; pos = cgroup_parent(pos)) {
+		struct cgroup *parent = cgroup_parent(pos);
+
+		if (parent == sgrp)
+			pos->rgrp_sig->rgrp_subtree_control |= 1 << ss->id;
+		else
+			parent->subtree_control |= 1 << ss->id;
+	}
+
+	ret = cgroup_apply_control(sgrp);
+	if (ret)
+		return ret;
+
+	/* did control propagtion disable @ss? */
+	if (!cgroup_css(rgrp, ss))
+		return -ENODEV;
+
+	return 0;
+}
+
+int rgroup_setpriority(pid_t vpid, int nice)
+{
+	struct task_struct *task;
+	struct cgroup *rgrp;
+	struct cgroup *sgrp __maybe_unused;
+	int ret;
+
+	rgrp = vpid_rgroup_lock_and_drain_offline(vpid, &task);
+	if (IS_ERR(rgrp))
+		return PTR_ERR(rgrp);
+
+	/*
+	 * If @rgrp is top-level, it should be put under the same nice
+	 * level restriction as @task; otherwise, limits are already
+	 * applied higher up the hierarchy and there's no reason to
+	 * restrict nice levels.
+	 */
+	if (!is_rgroup(cgroup_parent(rgrp)) && !can_nice(task, nice)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	ret = -ENODEV;
+	/* do ifdef late to preserve the correct error response */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	sgrp = nearest_sgroup(rgrp);
+
+	/* enable cpu and apply weight */
+	ret = rgroup_enable_subsys(rgrp, sgrp, &cpu_cgrp_subsys);
+	if (!ret)
+		ret = cpu_cgroup_setpriority(cgroup_css(rgrp, &cpu_cgrp_subsys),
+					     nice);
+	cgroup_finalize_control(sgrp, ret);
+#endif
+
+out_unlock:
+	cgroup_unlock();
+	put_task_struct(task);
+	return ret;
+}
+
+int rgroup_getpriority(pid_t vpid)
+{
+	struct task_struct *task;
+	struct cgroup *rgrp;
+	int ret;
+
+	rgrp = vpid_rgroup_lock_and_drain_offline(vpid, &task);
+	if (IS_ERR(rgrp))
+		return PTR_ERR(rgrp);
+
+	ret = -ENODEV;
+	/* do ifdef late to preserve the correct error response */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (cgroup_css(rgrp, &cpu_cgrp_subsys)) {
+		ret = cpu_cgroup_getpriority(cgroup_css(rgrp, &cpu_cgrp_subsys));
+		ret = nice_to_rlimit(ret);
+	}
+#endif
+	cgroup_unlock();
+	put_task_struct(task);
+	return ret;
+}
+
 static void check_for_release(struct cgroup *cgrp)
 {
 	if (notify_on_release(cgrp) && !cgroup_is_populated(cgrp) &&
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 16ad92b..e22e0ce 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8747,6 +8747,35 @@ static int cpu_weight_write_u64(struct cgroup_subsys_state *css,
 
 	return sched_group_set_shares(css_tg(css), scale_load(weight));
 }
+
+static int cpu_cgroup_css_copy(struct cgroup_subsys_state *to,
+			       struct cgroup_subsys_state *from)
+{
+	struct task_group *to_tg = css_tg(to);
+	struct task_group *from_tg = css_tg(from);
+
+	return sched_group_set_shares(to_tg, from_tg->shares);
+}
+
+int cpu_cgroup_setpriority(struct cgroup_subsys_state *css, int nice)
+{
+	int prio = NICE_TO_PRIO(clamp_val(nice, MIN_NICE, MAX_NICE));
+	int weight = sched_prio_to_weight[prio - MAX_RT_PRIO];
+
+	return sched_group_set_shares(css_tg(css), scale_load(weight));
+}
+
+int cpu_cgroup_getpriority(struct cgroup_subsys_state *css)
+{
+	int weight = css_tg(css)->shares;
+	int idx;
+
+	for (idx = 0; idx < ARRAY_SIZE(sched_prio_to_weight) - 1; idx++)
+		if (weight >= sched_prio_to_weight[idx])
+			break;
+
+	return PRIO_TO_NICE(idx + MAX_RT_PRIO);
+}
 #endif
 
 static void __maybe_unused cpu_period_quota_print(struct seq_file *sf,
@@ -8835,6 +8864,9 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_free	= cpu_cgroup_css_free,
 	.css_online	= cpu_cgroup_css_online,
 	.css_offline	= cpu_cgroup_css_offline,
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	.css_copy	= cpu_cgroup_css_copy,
+#endif
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
diff --git a/kernel/sys.c b/kernel/sys.c
index 78947de..923f66a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -41,6 +41,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/version.h>
 #include <linux/ctype.h>
+#include <linux/cgroup.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -181,7 +182,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	struct pid *pgrp;
 	kuid_t uid;
 
-	if (which > PRIO_USER || which < PRIO_PROCESS)
+	if (which > PRIO_RGRP || which < PRIO_PROCESS)
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
@@ -191,6 +192,9 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	if (niceval > MAX_NICE)
 		niceval = MAX_NICE;
 
+	if (which == PRIO_RGRP)
+		return rgroup_setpriority(who, niceval);
+
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
@@ -251,9 +255,12 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 	struct pid *pgrp;
 	kuid_t uid;
 
-	if (which > PRIO_USER || which < PRIO_PROCESS)
+	if (which > PRIO_RGRP || which < PRIO_PROCESS)
 		return -EINVAL;
 
+	if (which == PRIO_RGRP)
+		return rgroup_getpriority(who);
+
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-- 
2.5.0
