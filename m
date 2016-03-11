From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] cgroup: implement rgroup subtree migration
Date: Fri, 11 Mar 2016 10:41:27 -0500
Message-ID: <1457710888-31182-10-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, pjt@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Currently, when a process with rgroups is migrated, rgroup subtrees
are not preserved and all threads are put directly under the migration
destination cgroup.  This patch implements rgroup subtree migration so
that rgroup subtrees are preserved across process migration.

Early during process migration, cgroup_migrate_copy_rgrps() duplicates
rgroup subtrees of a process under the destination cgroup and links
the counterparts with newly added src_cgrp->rgrp_target.  Also,
subsystems can implement css_copy() method to copy over settings and
whatever states necessary.  Once copying is complete, the actual
migration uses ->rgrp_target as destination.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Turner <pjt@google.com>
---
 include/linux/cgroup-defs.h |   5 ++
 kernel/cgroup.c             | 157 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f1ee756..9ffa2d8 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -310,6 +310,9 @@ struct cgroup {
 	/* signal structs with rgroups below this cgroup */
 	struct list_head rgrp_child_sigs;
 
+	/* target rgroup, used during rgroup subtree migration */
+	struct cgroup *rgrp_target;
+
 	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
 	 * for tasks); created on demand.
@@ -462,6 +465,8 @@ struct cgroup_subsys {
 	void (*css_offline)(struct cgroup_subsys_state *css);
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
+	int (*css_copy)(struct cgroup_subsys_state *to,
+			struct cgroup_subsys_state *from);
 	void (*css_reset)(struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_taskset *tset);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 283b7ed..6107a1f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -229,8 +229,12 @@ static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
+static struct cgroup *rgroup_create(struct cgroup *parent, struct signal_struct *sig);
 static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
 static void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
+static void cgroup_save_control(struct cgroup *cgrp);
+static void cgroup_propagate_control(struct cgroup *cgrp);
+static void cgroup_restore_control(struct cgroup *cgrp);
 static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
 static void css_task_iter_advance(struct css_task_iter *it);
@@ -2478,6 +2482,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 
 enum {
 	CGRP_MIGRATE_PROCESS	= (1 << 0), /* migrate the whole process */
+	CGRP_MIGRATE_COPY_RGRPS	= (1 << 1), /* copy rgroup subtree */
 };
 
 /**
@@ -2752,6 +2757,132 @@ static int cgroup_migrate(struct task_struct *leader, unsigned mflags,
 }
 
 /**
+ * cgroup_migrate_uncopy_rgrps - cancel in-flight rgroup subtree copying
+ * @dst_cgrp: migration target cgroup
+ * @leader: leader of process being migrated
+ *
+ * Undo cgroup_migrate_copy_rgrps().
+ */
+static void cgroup_migrate_uncopy_rgrps(struct cgroup *dst_cgrp,
+					struct task_struct *leader)
+{
+	struct signal_struct *sig = leader->signal;
+	struct cgroup *sgrp = nearest_sgroup(task_css_set(leader)->dfl_cgrp);
+	struct cgroup *rgrp, *dsct;
+	struct cgroup_subsys_state *d_css;
+
+	/* destroy rgroup copies */
+	list_for_each_entry(rgrp, &sig->rgrps, rgrp_node) {
+		cgroup_for_each_live_descendant_post(dsct, d_css, rgrp) {
+			if (dsct->rgrp_target) {
+				rgroup_destroy_schedule(dsct->rgrp_target);
+				dsct->rgrp_target = NULL;
+			}
+		}
+	}
+
+	/* move back @sig under the original nearest sgroup */
+	if (!list_empty(&sig->rgrp_node))
+		list_move_tail(&sig->rgrp_node, &sgrp->rgrp_child_sigs);
+
+	sgrp->rgrp_target = NULL;
+	cgroup_restore_control(sgrp);
+}
+
+/**
+ * cgroup_migrate_copy_rgrps - copy a process's rgroup subtrees
+ * @dst_cgrp: migration target cgroup
+ * @leader: leader of process being migrated
+ *
+ * @leader and its threads are being migrated under @dst_cgrp.  Copy the
+ * process's rgroup subtrees under @dst_cgrp and make the source rgroups
+ * and their nearest sgroup point to the counterpart in the copied subtrees
+ * via ->rgrp_target.
+ *
+ * Before process migration is complete, this operation can be canceled
+ * using cgroup_migrate_uncopy_rgrps().
+ */
+static int cgroup_migrate_copy_rgrps(struct cgroup *dst_cgrp,
+				     struct task_struct *leader)
+{
+	struct signal_struct *sig = leader->signal;
+	struct cgroup *sgrp = nearest_sgroup(task_css_set(leader)->dfl_cgrp);
+	struct cgroup *rgrp, *dsct;
+	struct cgroup_subsys_state *d_css;
+	int ret;
+
+	if (WARN_ON_ONCE(!cgroup_on_dfl(dst_cgrp)))
+		return -EINVAL;
+
+	/* save for uncopy */
+	cgroup_save_control(sgrp);
+	sgrp->rgrp_target = dst_cgrp;
+
+	/*
+	 * Move @sig under @dst_cgrp for correct control propagation and
+	 * update its control masks.
+	 */
+	if (!list_empty(&sig->rgrp_node))
+		list_move_tail(&sig->rgrp_node, &dst_cgrp->rgrp_child_sigs);
+
+	cgroup_propagate_control(dst_cgrp);
+
+	/*
+	 * Walk and copy each rgroup.  As top-level copies are appended to
+	 * &sig->rgrps, terminate on encountering one.
+	 */
+	list_for_each_entry(rgrp, &sig->rgrps, rgrp_node) {
+		if (cgroup_parent(rgrp) == dst_cgrp)
+			break;
+
+		cgroup_for_each_live_descendant_pre(dsct, d_css, rgrp) {
+			struct cgroup *parent = cgroup_parent(dsct);
+			struct cgroup *copy;
+			struct cgroup_subsys_state *copy_css;
+			int ssid;
+
+			if (WARN_ON_ONCE(!parent->rgrp_target) ||
+			    WARN_ON_ONCE(dsct->rgrp_target)) {
+				ret = -EINVAL;
+				goto out_uncopy;
+			}
+
+			/* create a copy and refresh its control masks */
+			copy = rgroup_create(parent->rgrp_target, sig);
+			if (IS_ERR(copy)) {
+				ret = PTR_ERR(copy);
+				goto out_uncopy;
+			}
+
+			copy->subtree_control = dsct->subtree_control;
+			cgroup_propagate_control(copy);
+
+			dsct->rgrp_target = copy;
+
+			/* copy subsystem states */
+			for_each_css(copy_css, ssid, copy) {
+				struct cgroup_subsys *ss = copy_css->ss;
+				struct cgroup_subsys_state *css =
+					cgroup_css(dsct, ss);
+
+				if (!ss->css_copy || !css)
+					continue;
+
+				ret = ss->css_copy(copy_css, css);
+				if (ret)
+					goto out_uncopy;
+			}
+		}
+	}
+
+	return 0;
+
+out_uncopy:
+	cgroup_migrate_uncopy_rgrps(dst_cgrp, leader);
+	return ret;
+}
+
+/**
  * cgroup_attach_task - attach a task or a whole threadgroup to a cgroup
  * @dst_cgrp: the cgroup to attach to
  * @leader: the task or the leader of the threadgroup to be attached
@@ -2762,6 +2893,7 @@ static int cgroup_migrate(struct task_struct *leader, unsigned mflags,
 static int cgroup_attach_task(struct cgroup *dst_cgrp,
 			      struct task_struct *leader, unsigned mflags)
 {
+	bool copy_rgrps = mflags & CGRP_MIGRATE_COPY_RGRPS;
 	LIST_HEAD(preloaded_csets);
 	struct task_struct *task;
 	int ret;
@@ -2769,13 +2901,25 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	if (!cgroup_may_migrate_to(dst_cgrp))
 		return -EBUSY;
 
+	if (copy_rgrps) {
+		ret = cgroup_migrate_copy_rgrps(dst_cgrp, leader);
+		if (ret)
+			return ret;
+	}
+
 	/* look up all src csets */
 	spin_lock_bh(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
-		cgroup_migrate_add_src(task_css_set(task), dst_cgrp,
-				       &preloaded_csets);
+		struct css_set *src_cset = task_css_set(task);
+		struct cgroup *dfl_cgrp = src_cset->dfl_cgrp;
+		struct cgroup *target_cgrp = dst_cgrp;
+
+		if (copy_rgrps)
+			target_cgrp = dfl_cgrp->rgrp_target;
+
+		cgroup_migrate_add_src(src_cset, target_cgrp, &preloaded_csets);
 		if (!(mflags & CGRP_MIGRATE_PROCESS))
 			break;
 	} while_each_thread(leader, task);
@@ -2788,6 +2932,10 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 		ret = cgroup_migrate(leader, mflags, dst_cgrp->root);
 
 	cgroup_migrate_finish(&preloaded_csets);
+
+	if (copy_rgrps && ret)
+		cgroup_migrate_uncopy_rgrps(dst_cgrp, leader);
+
 	return ret;
 }
 
@@ -2864,8 +3012,11 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 		tsk = current;
 	}
 
-	if (mflags & CGRP_MIGRATE_PROCESS)
+	if (mflags & CGRP_MIGRATE_PROCESS) {
 		tsk = tsk->group_leader;
+		if (cgroup_on_dfl(cgrp))
+			mflags |= CGRP_MIGRATE_COPY_RGRPS;
+	}
 
 	/*
 	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
-- 
2.5.0
