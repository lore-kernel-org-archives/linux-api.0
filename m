From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 05/10] cgroup, fork: add @new_rgrp_cset[p] and @clone_flags to cgroup fork callbacks
Date: Fri, 11 Mar 2016 10:41:23 -0500
Message-ID: <1457710888-31182-6-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add two extra arguments to cgroup_{can|cancel|post}_fork().  These
will be used to implement in-process resource control.  The extra
arguments aren't used yet.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup-defs.h |  2 ++
 include/linux/cgroup.h      | 21 +++++++++++++++------
 kernel/cgroup.c             | 15 ++++++++++++---
 kernel/fork.c               |  7 ++++---
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 34b42f0..d3d1f92 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -542,6 +542,8 @@ static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
 
 #else	/* CONFIG_CGROUPS */
 
+struct css_set;
+
 #define CGROUP_SUBSYS_COUNT 0
 
 static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk) {}
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4717f43..ebcf21f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -102,9 +102,12 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
 
 void cgroup_fork(struct task_struct *p);
-extern int cgroup_can_fork(struct task_struct *p);
-extern void cgroup_cancel_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p, unsigned long clone_flags,
+			   struct css_set **new_rgrp_csetp);
+extern void cgroup_cancel_fork(struct task_struct *p, unsigned long clone_flags,
+			       struct css_set *new_rgrp_cset);
+extern void cgroup_post_fork(struct task_struct *p, unsigned long clone_flags,
+			     struct css_set *new_rgrp_cset);
 void cgroup_exit(struct task_struct *p);
 void cgroup_free(struct task_struct *p);
 
@@ -538,9 +541,15 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
 				    struct dentry *dentry) { return -EINVAL; }
 
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline int cgroup_can_fork(struct task_struct *p) { return 0; }
-static inline void cgroup_cancel_fork(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p,
+				  unsigned long clone_flags,
+				  struct css_set **new_rgrp_csetp) { return 0; }
+static inline void cgroup_cancel_fork(struct task_struct *p,
+				      unsigned long clone_flags,
+				      struct css_set *new_rgrp_cset) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    unsigned long clone_flags,
+				    struct css_set *new_rgrp_cset) {}
 static inline void cgroup_exit(struct task_struct *p) {}
 static inline void cgroup_free(struct task_struct *p) {}
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8ecb8d6..ac207ae 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5704,12 +5704,15 @@ void cgroup_fork(struct task_struct *child)
 /**
  * cgroup_can_fork - called on a new task before the process is exposed
  * @child: the task in question.
+ * @clone_flags: CLONE_* flags for @child
+ * @new_rgrp_csetp: rgroup out parameter to be passed to post/cancel_fork
  *
  * This calls the subsystem can_fork() callbacks. If the can_fork() callback
  * returns an error, the fork aborts with that error code. This allows for
  * a cgroup subsystem to conditionally allow or deny new forks.
  */
-int cgroup_can_fork(struct task_struct *child)
+int cgroup_can_fork(struct task_struct *child, unsigned long clone_flags,
+		    struct css_set **new_rgrp_csetp)
 {
 	struct cgroup_subsys *ss;
 	int i, j, ret;
@@ -5736,11 +5739,14 @@ int cgroup_can_fork(struct task_struct *child)
 /**
  * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
  * @child: the task in question
+ * @clone_flags: CLONE_* flags for @child
+ * @new_rgrp_cset: *@new_rgrp_csetp from cgroup_can_fork()
  *
  * This calls the cancel_fork() callbacks if a fork failed *after*
  * cgroup_can_fork() succeded.
  */
-void cgroup_cancel_fork(struct task_struct *child)
+void cgroup_cancel_fork(struct task_struct *child, unsigned long clone_flags,
+			struct css_set *new_rgrp_cset)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5753,6 +5759,8 @@ void cgroup_cancel_fork(struct task_struct *child)
 /**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
+ * @clone_flags: CLONE_* flags for @child
+ * @new_rgrp_cset: *@new_rgrp_csetp from cgroup_can_fork()
  *
  * Adds the task to the list running through its css_set if necessary and
  * call the subsystem fork() callbacks.  Has to be after the task is
@@ -5760,7 +5768,8 @@ void cgroup_cancel_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, unsigned long clone_flags,
+		      struct css_set *new_rgrp_cset)
 {
 	struct cgroup_subsys *ss;
 	int i;
diff --git a/kernel/fork.c b/kernel/fork.c
index fd826de..812d477 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1249,6 +1249,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	struct css_set *new_rgrp_cset;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1525,7 +1526,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * between here and cgroup_post_fork() if an organisation operation is in
 	 * progress.
 	 */
-	retval = cgroup_can_fork(p);
+	retval = cgroup_can_fork(p, clone_flags, &new_rgrp_cset);
 	if (retval)
 		goto bad_fork_free_pid;
 
@@ -1607,7 +1608,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, clone_flags, new_rgrp_cset);
 	threadgroup_change_end(current);
 	perf_event_fork(p);
 
@@ -1617,7 +1618,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	return p;
 
 bad_fork_cancel_cgroup:
-	cgroup_cancel_fork(p);
+	cgroup_cancel_fork(p, clone_flags, new_rgrp_cset);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
-- 
2.5.0
