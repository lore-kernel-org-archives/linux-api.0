From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/10] cgroup: introduce CGRP_MIGRATE_* flags
Date: Fri, 11 Mar 2016 10:41:21 -0500
Message-ID: <1457710888-31182-4-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently, the only migration modifier is boolean @threadgroup.  Make
the functions pass around unsigned flag mask instead and replace
@threadgroup with CGRP_MIGRATE_PROCESS.  This will allow addition of
other modifiers.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4c3c43e..8ecb8d6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2403,6 +2403,10 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 	return NULL;
 }
 
+enum {
+	CGRP_MIGRATE_PROCESS	= (1 << 0), /* migrate the whole process */
+};
+
 /**
  * cgroup_taskset_migrate - migrate a taskset
  * @tset: taget taskset
@@ -2634,7 +2638,7 @@ static int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
 /**
  * cgroup_migrate - migrate a process or task to a cgroup
  * @leader: the leader of the process or the task to migrate
- * @threadgroup: whether @leader points to the whole process or a single task
+ * @mflags: CGRP_MIGRATE_* flags
  * @root: cgroup root migration is taking place on
  *
  * Migrate a process or task denoted by @leader.  If migrating a process,
@@ -2649,7 +2653,7 @@ static int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
  * decided for all targets by invoking group_migrate_prepare_dst() before
  * actually starting migrating.
  */
-static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
+static int cgroup_migrate(struct task_struct *leader, unsigned mflags,
 			  struct cgroup_root *root)
 {
 	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
@@ -2665,7 +2669,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	task = leader;
 	do {
 		cgroup_taskset_add(task, &tset);
-		if (!threadgroup)
+		if (!(mflags & CGRP_MIGRATE_PROCESS))
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
@@ -2678,12 +2682,12 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
  * cgroup_attach_task - attach a task or a whole threadgroup to a cgroup
  * @dst_cgrp: the cgroup to attach to
  * @leader: the task or the leader of the threadgroup to be attached
- * @threadgroup: attach the whole threadgroup?
+ * @mflags: CGRP_MIGRATE_* flags
  *
  * Call holding cgroup_mutex and cgroup_threadgroup_rwsem.
  */
 static int cgroup_attach_task(struct cgroup *dst_cgrp,
-			      struct task_struct *leader, bool threadgroup)
+			      struct task_struct *leader, unsigned mflags)
 {
 	LIST_HEAD(preloaded_csets);
 	struct task_struct *task;
@@ -2699,7 +2703,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	do {
 		cgroup_migrate_add_src(task_css_set(task), dst_cgrp,
 				       &preloaded_csets);
-		if (!threadgroup)
+		if (!(mflags & CGRP_MIGRATE_PROCESS))
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
@@ -2708,7 +2712,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (!ret)
-		ret = cgroup_migrate(leader, threadgroup, dst_cgrp->root);
+		ret = cgroup_migrate(leader, mflags, dst_cgrp->root);
 
 	cgroup_migrate_finish(&preloaded_csets);
 	return ret;
@@ -2761,7 +2765,7 @@ static int cgroup_procs_write_permission(struct task_struct *task,
  * cgroup_mutex and threadgroup.
  */
 static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
-				    size_t nbytes, loff_t off, bool threadgroup)
+				    size_t nbytes, loff_t off, unsigned mflags)
 {
 	struct task_struct *tsk;
 	struct cgroup *cgrp;
@@ -2787,7 +2791,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 		tsk = current;
 	}
 
-	if (threadgroup)
+	if (mflags & CGRP_MIGRATE_PROCESS)
 		tsk = tsk->group_leader;
 
 	/*
@@ -2805,7 +2809,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 
 	ret = cgroup_procs_write_permission(tsk, cgrp, of);
 	if (!ret)
-		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+		ret = cgroup_attach_task(cgrp, tsk, mflags);
 
 	put_task_struct(tsk);
 	goto out_unlock_threadgroup;
@@ -2840,7 +2844,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		from_cgrp = task_cgroup_from_root(from, root);
 		spin_unlock_bh(&css_set_lock);
 
-		retval = cgroup_attach_task(from_cgrp, tsk, false);
+		retval = cgroup_attach_task(from_cgrp, tsk, 0);
 		if (retval)
 			break;
 	}
@@ -2853,13 +2857,13 @@ EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
-	return __cgroup_procs_write(of, buf, nbytes, off, false);
+	return __cgroup_procs_write(of, buf, nbytes, off, 0);
 }
 
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
-	return __cgroup_procs_write(of, buf, nbytes, off, true);
+	return __cgroup_procs_write(of, buf, nbytes, off, CGRP_MIGRATE_PROCESS);
 }
 
 static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
@@ -4233,7 +4237,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			ret = cgroup_migrate(task, false, to->root);
+			ret = cgroup_migrate(task, 0, to->root);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
-- 
2.5.0
