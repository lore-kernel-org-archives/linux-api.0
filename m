From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/10] cgroup: introduce resource group
Date: Fri, 11 Mar 2016 10:41:25 -0500
Message-ID: <1457710888-31182-8-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

cgroup v1 allowed tasks of a process to be put in different cgroups
thus allowing controlling resource distribution inside a process;
however, controlling in-process properties through filesystem
interface is highly unusual and has various issues around delegation,
ownership, and lack of integration with process altering operations.

rgroup (resource group) is a type of v2 cgroup which can be created by
setting CLONE_NEWRGRP during clone(2).  A newly created rgroup always
nests below the cgroup of the parent task, whether that is a sgroup
(system group) or rgroup.  rgroups are wholly owned by the associated
process and not visible through cgroupfs.

This patch implements the basic support for rgroups.

* New rgroup can be created through CLONE_NEWRGRP.  Top level rgroups
  are linked on the owning process's signal struct and all such signal
  structs are linked on the parent sgroup.

* A rgroup is destroyed automatically when it becomes depopulated.

* When a new process is forked, it is spawned in the nearest sgroup.

* When a task execs, is is moved to the nearest sgroup.

This patch doesn't yet implement actual resource control or
sub-hierarchy migration and all controllers are suppressed in rgroups.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/exec.c                   |   2 +-
 include/linux/cgroup-defs.h |  26 +++++
 include/linux/cgroup.h      |   2 +
 include/linux/sched.h       |   4 +
 include/uapi/linux/sched.h  |   1 +
 kernel/cgroup.c             | 229 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/fork.c               |  11 +++
 7 files changed, 266 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5b81bbb..286141e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1044,7 +1044,7 @@ static int de_thread(struct task_struct *tsk)
 	}
 
 	BUG_ON(!thread_group_leader(tsk));
-	return 0;
+	return cgroup_exec();
 
 killed:
 	/* protects against exit_notify() and __exit_signal() */
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 3c4a75b..f1ee756 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -201,6 +201,14 @@ struct css_set {
 	struct css_set *mg_dst_cset;
 
 	/*
+	 * If this cset points to a rgroup, the following is a cset which
+	 * is equivalent except that it points to the nearest sgroup.  This
+	 * allows tasks to be escaped to the nearest sgroup without
+	 * introducing deeply nested error cases.
+	 */
+	struct css_set *sgrp_cset;
+
+	/*
 	 * On the default hierarhcy, ->subsys[ssid] may point to a css
 	 * attached to an ancestor instead of the cgroup this css_set is
 	 * associated with.  The following node is anchored at
@@ -285,6 +293,24 @@ struct cgroup {
 	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
 
 	/*
+	 * If not NULL, the cgroup is a rgroup (resource group) of the
+	 * process associated with the following signal struct.  A rgroup
+	 * is used for in-process resource control.  rgroups are created by
+	 * specifying CLONE_NEWRGRP during clone(2), tied to the associated
+	 * process, and invisible and transparent to cgroupfs.
+	 *
+	 * The term "sgroup" (system group) is used for a cgroup which is
+	 * explicitly not a rgroup.
+	 */
+	struct signal_struct *rgrp_sig;
+
+	/* top-level rgroups linked on rgrp_sig->rgrps */
+	struct list_head rgrp_node;
+
+	/* signal structs with rgroups below this cgroup */
+	struct list_head rgrp_child_sigs;
+
+	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
 	 * for tasks); created on demand.
 	 */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1e00fc0..ca1ec50 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -107,6 +107,7 @@ extern void cgroup_cancel_fork(struct task_struct *p, unsigned long clone_flags,
 			       struct css_set *new_rgrp_cset);
 extern void cgroup_post_fork(struct task_struct *p, unsigned long clone_flags,
 			     struct css_set *new_rgrp_cset);
+int cgroup_exec(void);
 void cgroup_exit(struct task_struct *p);
 void cgroup_free(struct task_struct *p);
 
@@ -548,6 +549,7 @@ static inline void cgroup_cancel_fork(struct task_struct *p,
 static inline void cgroup_post_fork(struct task_struct *p,
 				    unsigned long clone_flags,
 				    struct css_set *new_rgrp_cset) {}
+static inline int cgroup_exec(void) { return 0; }
 static inline void cgroup_exit(struct task_struct *p) {}
 static inline void cgroup_free(struct task_struct *p) {}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d4ae795..7886919 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -778,6 +778,10 @@ struct signal_struct {
 	unsigned audit_tty_log_passwd;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+#ifdef CONFIG_CGROUPS
+	struct list_head rgrps;		/* top-level rgroups under this sig */
+	struct list_head rgrp_node;	/* parent_sgrp->child_rgrp_sigs list */
+#endif
 
 	oom_flags_t oom_flags;
 	short oom_score_adj;		/* OOM kill score adjustment */
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index cc89dde..ac6cec9 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -9,6 +9,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_NEWRGRP	0x00001000	/* New resource group */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 70f9985..53f479c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -126,6 +126,13 @@ static struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
 static struct workqueue_struct *cgroup_destroy_wq;
 
 /*
+ * rgroups are automatically destroyed when they become unpopulated.
+ * Destructions are bounced through the following workqueue which is
+ * ordered to avoid trying to destroy a parent before its children.
+ */
+static struct workqueue_struct *rgroup_destroy_wq;
+
+/*
  * pidlist destructions need to be flushed on cgroup destruction.  Use a
  * separate workqueue as flush domain.
  */
@@ -228,6 +235,7 @@ static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
 static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
+static void rgroup_destroy_schedule(struct cgroup *rgrp);
 static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss);
 static void css_release(struct percpu_ref *ref);
@@ -242,6 +250,16 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 static void cgroup_lock(void)
 	__acquires(&cgroup_mutex)
 {
+	/*
+	 * In-flight rgroup destructions can interfere with subsequent
+	 * operations.  For example, rmdir of the nearest sgroup would fail
+	 * while rgroup destructions are in flight.  rgroup destructions
+	 * don't involve any time-consuming operations and the following
+	 * flush shouldn't be noticeable.
+	 */
+	if (rgroup_destroy_wq)
+		flush_workqueue(rgroup_destroy_wq);
+
 	mutex_lock(&cgroup_mutex);
 }
 
@@ -330,6 +348,11 @@ static bool cgroup_on_dfl(const struct cgroup *cgrp)
 	return cgrp->root == &cgrp_dfl_root;
 }
 
+static bool is_rgroup(struct cgroup *cgrp)
+{
+	return cgrp->rgrp_sig;
+}
+
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 			    gfp_t gfp_mask)
@@ -370,12 +393,29 @@ static struct cgroup *cgroup_parent(struct cgroup *cgrp)
 	return NULL;
 }
 
+/**
+ * nearest_sgroup - find the nearest system group
+ * @cgrp: cgroup of question
+ *
+ * Find the closest sgroup ancestor.  If @cgrp is not a rgroup, @cgrp is
+ * returned.  A rgroup subtree is always nested under a sgroup.
+ */
+static struct cgroup *nearest_sgroup(struct cgroup *cgrp)
+{
+	while (is_rgroup(cgrp))
+		cgrp = cgroup_parent(cgrp);
+	return cgrp;
+}
+
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 root_ss_mask = cgrp->root->subsys_mask;
 
+	if (is_rgroup(cgrp))
+		return 0;
+
 	if (parent)
 		return parent->subtree_control;
 
@@ -390,6 +430,9 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
+	if (is_rgroup(cgrp))
+		return 0;
+
 	if (parent)
 		return parent->subtree_ss_mask;
 
@@ -620,22 +663,26 @@ static void check_for_release(struct cgroup *cgrp);
 
 int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 {
+	cgrp = nearest_sgroup(cgrp);
 	return kernfs_name(cgrp->kn, buf, buflen);
 }
 
 char * __must_check cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen)
 {
+	cgrp = nearest_sgroup(cgrp);
 	return kernfs_path(cgrp->kn, buf, buflen);
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
 void pr_cont_cgroup_name(struct cgroup *cgrp)
 {
+	cgrp = nearest_sgroup(cgrp);
 	pr_cont_kernfs_name(cgrp->kn);
 }
 
 void pr_cont_cgroup_path(struct cgroup *cgrp)
 {
+	cgrp = nearest_sgroup(cgrp);
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
@@ -720,8 +767,14 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		if (!trigger)
 			break;
 
-		check_for_release(cgrp);
-		cgroup_file_notify(&cgrp->events_file);
+		/* rgroups are automatically destroyed when empty */
+		if (is_rgroup(cgrp)) {
+			if (!cgrp->populated_cnt)
+				rgroup_destroy_schedule(cgrp);
+		} else {
+			check_for_release(cgrp);
+			cgroup_file_notify(&cgrp->events_file);
+		}
 
 		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
@@ -856,6 +909,9 @@ static void put_css_set_locked(struct css_set *cset)
 		kfree(link);
 	}
 
+	if (cset->sgrp_cset)
+		put_css_set_locked(cset->sgrp_cset);
+
 	kfree_rcu(cset, rcu_head);
 }
 
@@ -1154,6 +1210,16 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
 	spin_unlock_bh(&css_set_lock);
 
+	if (is_rgroup(cset->dfl_cgrp)) {
+		struct cgroup *c = nearest_sgroup(cset->dfl_cgrp);
+
+		cset->sgrp_cset = find_css_set(cset, c);
+		if (!cset->sgrp_cset) {
+			put_css_set(cset);
+			return NULL;
+		}
+	}
+
 	return cset;
 }
 
@@ -1909,6 +1975,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->self.sibling);
 	INIT_LIST_HEAD(&cgrp->self.children);
 	INIT_LIST_HEAD(&cgrp->cset_links);
+	INIT_LIST_HEAD(&cgrp->rgrp_child_sigs);
+	INIT_LIST_HEAD(&cgrp->rgrp_node);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
 	cgrp->self.cgroup = cgrp;
@@ -3307,9 +3375,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				continue;
 			}
 
-			/* a child has it enabled? */
+			/* a child sgroup has it enabled? */
 			cgroup_for_each_live_child(child, cgrp) {
-				if (child->subtree_control & (1 << ssid)) {
+				if (!is_rgroup(child) &&
+				    child->subtree_control & (1 << ssid)) {
 					ret = -EBUSY;
 					goto out_unlock;
 				}
@@ -5060,7 +5129,8 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 	return ERR_PTR(err);
 }
 
-static struct cgroup *cgroup_create(struct cgroup *parent)
+static struct cgroup *cgroup_create(struct cgroup *parent,
+				    struct signal_struct *rgrp_sig)
 {
 	struct cgroup_root *root = parent->root;
 	struct cgroup *cgrp, *tcgrp;
@@ -5103,6 +5173,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &cgrp->flags);
 
 	cgrp->self.serial_nr = css_serial_nr_next++;
+	cgrp->rgrp_sig = rgrp_sig;
 
 	/* allocation complete, commit to creation */
 	list_add_tail_rcu(&cgrp->self.sibling, &cgroup_parent(cgrp)->self.children);
@@ -5156,7 +5227,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (!parent)
 		return -ENODEV;
 
-	cgrp = cgroup_create(parent);
+	cgrp = cgroup_create(parent, NULL);
 	if (IS_ERR(cgrp)) {
 		ret = PTR_ERR(cgrp);
 		goto out_unlock;
@@ -5201,6 +5272,75 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	return ret;
 }
 
+static void rgroup_destroy_work_fn(struct work_struct *work)
+{
+	struct cgroup *rgrp = container_of(work, struct cgroup,
+					   self.destroy_work);
+	struct signal_struct *sig = rgrp->rgrp_sig;
+
+	/*
+	 * cgroup_lock() flushes rgroup_destroy_wq and using it here would
+	 * lead to deadlock.  Grab cgroup_mutex directly.
+	 */
+	mutex_lock(&cgroup_mutex);
+
+	if (WARN_ON_ONCE(cgroup_destroy_locked(rgrp))) {
+		mutex_unlock(&cgroup_mutex);
+		return;
+	}
+
+	list_del(&rgrp->rgrp_node);
+
+	if (sig && list_empty(&sig->rgrps)) {
+		list_del(&sig->rgrp_node);
+		put_signal_struct(sig);
+	}
+
+	mutex_unlock(&cgroup_mutex);
+}
+
+/**
+ * rgroup_destroy_schedule - schedule destruction of a rgroup
+ * @rgrp: rgroup to be destroyed
+ *
+ * Schedule destruction of @rgrp.  Destructions are guarantee to be
+ * performed in order and flushed on cgroup_lock().
+ */
+static void rgroup_destroy_schedule(struct cgroup *rgrp)
+{
+	INIT_WORK(&rgrp->self.destroy_work, rgroup_destroy_work_fn);
+	queue_work(rgroup_destroy_wq, &rgrp->self.destroy_work);
+}
+
+/**
+ * rgroup_create - create a rgroup
+ * @parent: parent cgroup (sgroup or rgroup)
+ * @sig: signal_struct of the target process
+ *
+ * Create a rgroup under @parent for the process associated with @sig.
+ */
+static struct cgroup *rgroup_create(struct cgroup *parent,
+				    struct signal_struct *sig)
+{
+	struct cgroup *rgrp;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	rgrp = cgroup_create(parent, sig);
+	if (IS_ERR(rgrp))
+		return rgrp;
+
+	if (!is_rgroup(parent))
+		list_add_tail(&rgrp->rgrp_node, &sig->rgrps);
+
+	if (list_empty(&sig->rgrp_node)) {
+		atomic_inc(&sig->sigcnt);
+		list_add_tail(&sig->rgrp_node, &parent->rgrp_child_sigs);
+	}
+
+	return rgrp;
+}
+
 /*
  * This is called when the refcnt of a css is confirmed to be killed.
  * css_tryget_online() is now guaranteed to fail.  Tell the subsystem to
@@ -5562,6 +5702,9 @@ static int __init cgroup_wq_init(void)
 	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
 	BUG_ON(!cgroup_destroy_wq);
 
+	rgroup_destroy_wq = alloc_ordered_workqueue("rgroup_destroy", 0);
+	BUG_ON(!rgroup_destroy_wq);
+
 	/*
 	 * Used to destroy pidlists and separate to serve as flush domain.
 	 * Cap @max_active to 1 too.
@@ -5694,7 +5837,8 @@ static const struct file_operations proc_cgroupstats_operations = {
  * @clone_flags: clone flags if forking
  *
  * Called from threadgroup_change_begin() and allows cgroup operations to
- * synchronize against threadgroup changes using a percpu_rw_semaphore.
+ * synchronize against threadgroup changes using a percpu_rw_semaphore.  If
+ * clone(2) is requesting a new rgroup, also grab cgroup_mutex.
  */
 void cgroup_threadgroup_change_begin(struct task_struct *tsk,
 				     struct task_struct *child,
@@ -5709,6 +5853,9 @@ void cgroup_threadgroup_change_begin(struct task_struct *tsk,
 		 */
 		RCU_INIT_POINTER(child->cgroups, &init_css_set);
 		INIT_LIST_HEAD(&child->cg_list);
+
+		if (clone_flags & CLONE_NEWRGRP)
+			cgroup_lock();
 	}
 
 	percpu_down_read(&cgroup_threadgroup_rwsem);
@@ -5728,6 +5875,9 @@ void cgroup_threadgroup_change_end(struct task_struct *tsk,
 				   unsigned long clone_flags)
 {
 	percpu_up_read(&cgroup_threadgroup_rwsem);
+
+	if (child && (clone_flags & CLONE_NEWRGRP))
+		cgroup_unlock();
 }
 
 /**
@@ -5746,6 +5896,23 @@ int cgroup_can_fork(struct task_struct *child, unsigned long clone_flags,
 	struct cgroup_subsys *ss;
 	int i, j, ret;
 
+	if (clone_flags & CLONE_NEWRGRP) {
+		struct css_set *cset = task_css_set(current);
+		struct cgroup *rgrp;
+
+		rgrp = rgroup_create(cset->dfl_cgrp, current->signal);
+		if (IS_ERR(rgrp))
+			return PTR_ERR(rgrp);
+
+		*new_rgrp_csetp = find_css_set(cset, rgrp);
+		if (IS_ERR(*new_rgrp_csetp)) {
+			rgroup_destroy_schedule(rgrp);
+			return PTR_ERR(*new_rgrp_csetp);
+		}
+	} else {
+		*new_rgrp_csetp = NULL;
+	}
+
 	do_each_subsys_mask(ss, i, have_canfork_callback) {
 		ret = ss->can_fork(child);
 		if (ret)
@@ -5780,6 +5947,11 @@ void cgroup_cancel_fork(struct task_struct *child, unsigned long clone_flags,
 	struct cgroup_subsys *ss;
 	int i;
 
+	if (new_rgrp_cset) {
+		rgroup_destroy_schedule(new_rgrp_cset->dfl_cgrp);
+		put_css_set(new_rgrp_cset);
+	}
+
 	for_each_subsys(ss, i)
 		if (ss->cancel_fork)
 			ss->cancel_fork(child);
@@ -5828,11 +6000,29 @@ void cgroup_post_fork(struct task_struct *child, unsigned long clone_flags,
 		struct css_set *cset;
 
 		spin_lock_bh(&css_set_lock);
-		cset = task_css_set(current);
+
+		/*
+		 * If @new_rgrp_cset is set, it contains the requested new
+		 * rgroup created by cgroup_can_fork().
+		 */
+		if (new_rgrp_cset) {
+			cset = new_rgrp_cset;
+		} else {
+			cset = task_css_set(current);
+			/*
+			 * If a new process is being created, it shouldn't
+			 * be put in this process's rgroup.  Escape it to
+			 * the nearest sgroup.
+			 */
+			if (!(clone_flags & CLONE_THREAD) && cset->sgrp_cset)
+				cset = cset->sgrp_cset;
+		}
+
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
 			css_set_move_task(child, NULL, cset, false);
 		}
+
 		spin_unlock_bh(&css_set_lock);
 	}
 
@@ -5846,6 +6036,29 @@ void cgroup_post_fork(struct task_struct *child, unsigned long clone_flags,
 	} while_each_subsys_mask();
 }
 
+int cgroup_exec(void)
+{
+	struct cgroup *cgrp;
+	bool is_rgrp;
+	int ret;
+
+	/* whether a task is in a sgroup or rgroup is immutable */
+	rcu_read_lock();
+	is_rgrp = is_rgroup(task_css_set(current)->dfl_cgrp);
+	rcu_read_unlock();
+
+	if (!is_rgrp)
+		return 0;
+
+	/* exec should reset rgroup, escape to the nearest sgroup */
+	cgroup_lock();
+	cgrp = nearest_sgroup(task_css_set(current)->dfl_cgrp);
+	ret = cgroup_attach_task(cgrp, current, CGRP_MIGRATE_PROCESS);
+	cgroup_unlock();
+
+	return ret;
+}
+
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
diff --git a/kernel/fork.c b/kernel/fork.c
index 840b662..70903fc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -234,6 +234,9 @@ EXPORT_SYMBOL(free_task);
 
 static inline void free_signal_struct(struct signal_struct *sig)
 {
+#ifdef CONFIG_CGROUPS
+	WARN_ON_ONCE(!list_empty(&sig->rgrps));
+#endif
 	taskstats_tgid_free(sig);
 	sched_autogroup_exit(sig);
 	kmem_cache_free(signal_cachep, sig);
@@ -1159,6 +1162,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	mutex_init(&sig->cred_guard_mutex);
 
+#ifdef CONFIG_CGROUPS
+	INIT_LIST_HEAD(&sig->rgrps);
+	INIT_LIST_HEAD(&sig->rgrp_node);
+#endif
 	return 0;
 }
 
@@ -1293,6 +1300,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			return ERR_PTR(-EINVAL);
 	}
 
+	/* Only threads can be put in child resource groups. */
+	if (!(clone_flags & CLONE_THREAD) && (clone_flags & CLONE_NEWRGRP))
+		return ERR_PTR(-EINVAL);
+
 	retval = security_task_create(clone_flags);
 	if (retval)
 		goto fork_out;
-- 
2.5.0
