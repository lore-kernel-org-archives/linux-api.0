From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] cgroup, fork: add @child and @clone_flags to threadgroup_change_begin/end()
Date: Fri, 11 Mar 2016 10:41:24 -0500
Message-ID: <1457710888-31182-7-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, pjt@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

When threadgroup_change_begin/end() are called from fork path, pass in
@child and @clone_flags so that fork path can be distinguished and
fork related information is available.

While at it, un-inline cgroup_threadgroup_change_begin/end() and fold
cgroup_fork() into cgroup_threadgroup_change_begin().  These changes
will be used to imlement in-process resource control.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c                   |  6 +++---
 include/linux/cgroup-defs.h | 39 ++++++++++++-------------------------
 include/linux/cgroup.h      |  2 --
 include/linux/sched.h       | 16 +++++++++++----
 kernel/cgroup.c             | 47 ++++++++++++++++++++++++++++++++++++---------
 kernel/fork.c               |  7 +++----
 kernel/signal.c             |  6 +++---
 7 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 828ec5f..5b81bbb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -936,7 +936,7 @@ static int de_thread(struct task_struct *tsk)
 		struct task_struct *leader = tsk->group_leader;
 
 		for (;;) {
-			threadgroup_change_begin(tsk);
+			threadgroup_change_begin(tsk, NULL, 0);
 			write_lock_irq(&tasklist_lock);
 			/*
 			 * Do this under tasklist_lock to ensure that
@@ -947,7 +947,7 @@ static int de_thread(struct task_struct *tsk)
 				break;
 			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
-			threadgroup_change_end(tsk);
+			threadgroup_change_end(tsk, NULL, 0);
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -1005,7 +1005,7 @@ static int de_thread(struct task_struct *tsk)
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
-		threadgroup_change_end(tsk);
+		threadgroup_change_end(tsk, NULL, 0);
 
 		release_task(leader);
 	}
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index d3d1f92..3c4a75b 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -514,31 +514,12 @@ struct cgroup_subsys {
 	unsigned int depends_on;
 };
 
-extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
-
-/**
- * cgroup_threadgroup_change_begin - threadgroup exclusion for cgroups
- * @tsk: target task
- *
- * Called from threadgroup_change_begin() and allows cgroup operations to
- * synchronize against threadgroup changes using a percpu_rw_semaphore.
- */
-static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk)
-{
-	percpu_down_read(&cgroup_threadgroup_rwsem);
-}
-
-/**
- * cgroup_threadgroup_change_end - threadgroup exclusion for cgroups
- * @tsk: target task
- *
- * Called from threadgroup_change_end().  Counterpart of
- * cgroup_threadcgroup_change_begin().
- */
-static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
-{
-	percpu_up_read(&cgroup_threadgroup_rwsem);
-}
+void cgroup_threadgroup_change_begin(struct task_struct *tsk,
+				     struct task_struct *child,
+				     unsigned long clone_flags);
+void cgroup_threadgroup_change_end(struct task_struct *tsk,
+				   struct task_struct *child,
+				   unsigned long clone_flags);
 
 #else	/* CONFIG_CGROUPS */
 
@@ -546,8 +527,12 @@ struct css_set;
 
 #define CGROUP_SUBSYS_COUNT 0
 
-static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk) {}
-static inline void cgroup_threadgroup_change_end(struct task_struct *tsk) {}
+static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk,
+						   struct task_struct *child,
+						   unsigned long clone_flags) {}
+static inline void cgroup_threadgroup_change_end(struct task_struct *tsk,
+						 struct task_struct *child,
+						 unsigned long clone_flags) {}
 
 #endif	/* CONFIG_CGROUPS */
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ebcf21f..1e00fc0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -101,7 +101,6 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
 
-void cgroup_fork(struct task_struct *p);
 extern int cgroup_can_fork(struct task_struct *p, unsigned long clone_flags,
 			   struct css_set **new_rgrp_csetp);
 extern void cgroup_cancel_fork(struct task_struct *p, unsigned long clone_flags,
@@ -540,7 +539,6 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
 static inline int cgroupstats_build(struct cgroupstats *stats,
 				    struct dentry *dentry) { return -EINVAL; }
 
-static inline void cgroup_fork(struct task_struct *p) {}
 static inline int cgroup_can_fork(struct task_struct *p,
 				  unsigned long clone_flags,
 				  struct css_set **new_rgrp_csetp) { return 0; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 80d6ed1..d4ae795 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2783,6 +2783,8 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
 /**
  * threadgroup_change_begin - mark the beginning of changes to a threadgroup
  * @tsk: task causing the changes
+ * @child: child task if forking, NULL otherwise
+ * @clone_flags: clone flags if forking
  *
  * All operations which modify a threadgroup - a new thread joining the
  * group, death of a member thread (the assertion of PF_EXITING) and
@@ -2791,21 +2793,27 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
  * subsystems needing threadgroup stability can hook into for
  * synchronization.
  */
-static inline void threadgroup_change_begin(struct task_struct *tsk)
+static inline void threadgroup_change_begin(struct task_struct *tsk,
+					    struct task_struct *child,
+					    unsigned long clone_flags)
 {
 	might_sleep();
-	cgroup_threadgroup_change_begin(tsk);
+	cgroup_threadgroup_change_begin(tsk, child, clone_flags);
 }
 
 /**
  * threadgroup_change_end - mark the end of changes to a threadgroup
  * @tsk: task causing the changes
+ * @child: child task if forking, NULL otherwise
+ * @clone_flags: clone flags if forking
  *
  * See threadgroup_change_begin().
  */
-static inline void threadgroup_change_end(struct task_struct *tsk)
+static inline void threadgroup_change_end(struct task_struct *tsk,
+					  struct task_struct *child,
+					  unsigned long clone_flags)
 {
-	cgroup_threadgroup_change_end(tsk);
+	cgroup_threadgroup_change_end(tsk, child, clone_flags);
 }
 
 #ifndef __HAVE_THREAD_FUNCTIONS
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ac207ae..70f9985 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -110,7 +110,7 @@ static DEFINE_SPINLOCK(cgroup_file_kn_lock);
  */
 static DEFINE_SPINLOCK(release_agent_path_lock);
 
-struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
+static struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
 
 #define cgroup_assert_mutex_or_rcu_locked()				\
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
@@ -5688,17 +5688,46 @@ static const struct file_operations proc_cgroupstats_operations = {
 };
 
 /**
- * cgroup_fork - initialize cgroup related fields during copy_process()
- * @child: pointer to task_struct of forking parent process.
+ * cgroup_threadgroup_change_begin - threadgroup exclusion for cgroups
+ * @tsk: target task
+ * @child: child task if forking, NULL otherwise
+ * @clone_flags: clone flags if forking
  *
- * A task is associated with the init_css_set until cgroup_post_fork()
- * attaches it to the parent's css_set.  Empty cg_list indicates that
- * @child isn't holding reference to its css_set.
+ * Called from threadgroup_change_begin() and allows cgroup operations to
+ * synchronize against threadgroup changes using a percpu_rw_semaphore.
  */
-void cgroup_fork(struct task_struct *child)
+void cgroup_threadgroup_change_begin(struct task_struct *tsk,
+				     struct task_struct *child,
+				     unsigned long clone_flags)
 {
-	RCU_INIT_POINTER(child->cgroups, &init_css_set);
-	INIT_LIST_HEAD(&child->cg_list);
+	if (child) {
+		/*
+		 * A task is associated with the init_css_set until
+		 * cgroup_post_fork() attaches it to the parent's css_set.
+		 * Empty cg_list indicates that @child isn't holding
+		 * reference to its css_set.
+		 */
+		RCU_INIT_POINTER(child->cgroups, &init_css_set);
+		INIT_LIST_HEAD(&child->cg_list);
+	}
+
+	percpu_down_read(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_threadgroup_change_end - threadgroup exclusion for cgroups
+ * @tsk: target task
+ * @child: child task if forking, NULL otherwise
+ * @clone_flags: clone flags if forking
+ *
+ * Called from threadgroup_change_end().  Counterpart of
+ * cgroup_threadcgroup_change_begin().
+ */
+void cgroup_threadgroup_change_end(struct task_struct *tsk,
+				   struct task_struct *child,
+				   unsigned long clone_flags)
+{
+	percpu_up_read(&cgroup_threadgroup_rwsem);
 }
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index 812d477..840b662 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1368,8 +1368,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
-	threadgroup_change_begin(current);
-	cgroup_fork(p);
+	threadgroup_change_begin(current, p, clone_flags);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
 	if (IS_ERR(p->mempolicy)) {
@@ -1609,7 +1608,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	proc_fork_connector(p);
 	cgroup_post_fork(p, clone_flags, new_rgrp_cset);
-	threadgroup_change_end(current);
+	threadgroup_change_end(current, p, clone_flags);
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
@@ -1650,7 +1649,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
 #endif
-	threadgroup_change_end(current);
+	threadgroup_change_end(current, p, clone_flags);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
diff --git a/kernel/signal.c b/kernel/signal.c
index f3f1f7a..1679c02 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2389,11 +2389,11 @@ void exit_signals(struct task_struct *tsk)
 	 * @tsk is about to have PF_EXITING set - lock out users which
 	 * expect stable threadgroup.
 	 */
-	threadgroup_change_begin(tsk);
+	threadgroup_change_begin(tsk, NULL, 0);
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
-		threadgroup_change_end(tsk);
+		threadgroup_change_end(tsk, NULL, 0);
 		return;
 	}
 
@@ -2404,7 +2404,7 @@ void exit_signals(struct task_struct *tsk)
 	 */
 	tsk->flags |= PF_EXITING;
 
-	threadgroup_change_end(tsk);
+	threadgroup_change_end(tsk, NULL, 0);
 
 	if (!signal_pending(tsk))
 		goto out;
-- 
2.5.0
