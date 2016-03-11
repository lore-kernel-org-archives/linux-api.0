From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/10] cgroup: implement rgroup control mask handling
Date: Fri, 11 Mar 2016 10:41:26 -0500
Message-ID: <1457710888-31182-9-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

To support in-process resource control, the previous patch implemented
the basic rgroup infrastructure which allows creating rgroups by
specifying CLONE_NEWRGRP during clone(2).  This patch implements
control mask handling for rgroups so that controllers can be enabled
on them.

There can be multiple top-level rgroups per process, all nested right
below the sgroup that the process belongs to.  They should share the
same control masks which can be different from those of top-level
rgroups belonging to different processes or peer tasks.  These
top-level rgroup control masks are added to signal_struct and all
control mask handling functions are updated accordingly.

Note that a top-level rgroup should behave the same as a peer task
rather than a peer sibling cgroup.  As such, the set of controllers
avaialble to a rgroup should be the same as the set for peer tasks.
To satisfy this requirement, controller availability for a top-level
rgroup is constrainted by cgroup_{control|ss_mask}(nearest_sgrp)
instead of nearest_sgrp->subtree_{control|ss_mask}.

After this change, csses can be created on rgroups.  The
css_{clear|populate}_dir() are updated to become noops for csses on
rgroups.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h |  4 ++++
 kernel/cgroup.c       | 49 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7886919..d3849ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -781,6 +781,10 @@ struct signal_struct {
 #ifdef CONFIG_CGROUPS
 	struct list_head rgrps;		/* top-level rgroups under this sig */
 	struct list_head rgrp_node;	/* parent_sgrp->child_rgrp_sigs list */
+	u16 rgrp_subtree_control;	/* control for top-level rgroups */
+	u16 rgrp_subtree_ss_mask;	/* ss_mask for top-level rgroups */
+	u16 rgrp_old_subtree_control;	/* used during control updates */
+	u16 rgrp_old_subtree_ss_mask;	/* used during control updates */
 #endif
 
 	oom_flags_t oom_flags;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 53f479c..283b7ed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -413,8 +413,8 @@ static u16 cgroup_control(struct cgroup *cgrp)
 	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 root_ss_mask = cgrp->root->subsys_mask;
 
-	if (is_rgroup(cgrp))
-		return 0;
+	if (is_rgroup(cgrp) && !is_rgroup(parent))
+		return cgrp->rgrp_sig->rgrp_subtree_control;
 
 	if (parent)
 		return parent->subtree_control;
@@ -430,8 +430,8 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
-	if (is_rgroup(cgrp))
-		return 0;
+	if (is_rgroup(cgrp) && !is_rgroup(parent))
+		return cgrp->rgrp_sig->rgrp_subtree_ss_mask;
 
 	if (parent)
 		return parent->subtree_ss_mask;
@@ -1565,6 +1565,9 @@ static void css_clear_dir(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_VISIBLE;
 
+	if (is_rgroup(cgrp))
+		return;
+
 	list_for_each_entry(cfts, &css->ss->cfts, node)
 		cgroup_addrm_files(css, cgrp, cfts, false);
 }
@@ -1584,6 +1587,9 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 	if ((css->flags & CSS_VISIBLE) || !cgrp->kn)
 		return 0;
 
+	if (is_rgroup(cgrp))
+		goto done;
+
 	if (!css->ss) {
 		if (cgroup_on_dfl(cgrp))
 			cfts = cgroup_dfl_base_files;
@@ -1600,9 +1606,8 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 			goto err;
 		}
 	}
-
+done:
 	css->flags |= CSS_VISIBLE;
-
 	return 0;
 err:
 	list_for_each_entry(cfts, &css->ss->cfts, node) {
@@ -3116,8 +3121,15 @@ static void cgroup_save_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
+		struct signal_struct *sig;
+
 		dsct->old_subtree_control = dsct->subtree_control;
 		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
+
+		list_for_each_entry(sig, &dsct->rgrp_child_sigs, rgrp_node) {
+			sig->rgrp_old_subtree_control = sig->rgrp_subtree_control;
+			sig->rgrp_old_subtree_ss_mask = sig->rgrp_subtree_ss_mask;
+		}
 	}
 }
 
@@ -3135,10 +3147,19 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
+		struct signal_struct *sig;
+
 		dsct->subtree_control &= cgroup_control(dsct);
 		dsct->subtree_ss_mask =
 			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
 						    cgroup_ss_mask(dsct));
+
+		list_for_each_entry(sig, &dsct->rgrp_child_sigs, rgrp_node) {
+			sig->rgrp_subtree_control &= cgroup_control(dsct);
+			sig->rgrp_subtree_ss_mask =
+				cgroup_calc_subtree_ss_mask(sig->rgrp_subtree_control,
+							    cgroup_ss_mask(dsct));
+		}
 	}
 }
 
@@ -3155,6 +3176,13 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
+		struct signal_struct *sig;
+
+		list_for_each_entry(sig, &dsct->rgrp_child_sigs, rgrp_node) {
+			sig->rgrp_subtree_control = sig->rgrp_old_subtree_control;
+			sig->rgrp_subtree_ss_mask = sig->rgrp_old_subtree_ss_mask;
+		}
+
 		dsct->subtree_control = dsct->old_subtree_control;
 		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
 	}
@@ -5326,6 +5354,15 @@ static struct cgroup *rgroup_create(struct cgroup *parent,
 
 	lockdep_assert_held(&cgroup_mutex);
 
+	if (list_empty(&sig->rgrps)) {
+		WARN_ON_ONCE(is_rgroup(parent));
+
+		sig->rgrp_subtree_control = 0;
+		sig->rgrp_subtree_ss_mask =
+			cgroup_calc_subtree_ss_mask(sig->rgrp_subtree_control,
+						    cgroup_ss_mask(parent));
+	}
+
 	rgrp = cgroup_create(parent, sig);
 	if (IS_ERR(rgrp))
 		return rgrp;
-- 
2.5.0
