From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/10] cgroup: introduce cgroup_[un]lock()
Date: Fri, 11 Mar 2016 10:41:19 -0500
Message-ID: <1457710888-31182-2-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Introduce thin wrappers which lock and unlock cgroup_mutex.  While
this doesn't introduce any functional differences now, they will later
be used to perform some extra operations around locking.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 100 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 59 insertions(+), 41 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e22df5d8..2297bf6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -237,6 +237,24 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			      bool is_add);
 
 /**
+ * cgroup_lock - lock cgroup_mutex and perform related operations
+ */
+static void cgroup_lock(void)
+	__acquires(&cgroup_mutex)
+{
+	mutex_lock(&cgroup_mutex);
+}
+
+/**
+ * cgroup_unlock - unlock cgroup_mutex and perform related operations
+ */
+static void cgroup_unlock(void)
+	__releases(&cgroup_mutex)
+{
+	mutex_unlock(&cgroup_mutex);
+}
+
+/**
  * cgroup_ssid_enabled - cgroup subsys enabled test by subsys ID
  * @ssid: subsys ID of interest
  *
@@ -1194,7 +1212,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 
 	cgroup_exit_root_id(root);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	kernfs_destroy_root(root->kf_root);
 	cgroup_free_root(root);
@@ -1373,7 +1391,7 @@ static void cgroup_kn_unlock(struct kernfs_node *kn)
 	else
 		cgrp = kn->parent->priv;
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	kernfs_unbreak_active_protection(kn);
 	cgroup_put(cgrp);
@@ -1419,7 +1437,7 @@ static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn,
 	if (drain_offline)
 		cgroup_lock_and_drain_offline(cgrp);
 	else
-		mutex_lock(&cgroup_mutex);
+		cgroup_lock();
 
 	if (!cgroup_is_dead(cgrp))
 		return cgrp;
@@ -1804,7 +1822,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
  out_unlock:
 	kfree(opts.release_agent);
 	kfree(opts.name);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return ret;
 }
 
@@ -2045,7 +2063,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			continue;
 
 		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			msleep(10);
 			ret = restart_syscall();
 			goto out_free;
@@ -2100,7 +2118,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
 		if (IS_ERR(pinned_sb) ||
 		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			if (!IS_ERR_OR_NULL(pinned_sb))
 				deactivate_super(pinned_sb);
 			msleep(10);
@@ -2135,7 +2153,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		cgroup_free_root(root);
 
 out_unlock:
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
@@ -2214,7 +2232,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 	int hierarchy_id = 1;
 	char *path = NULL;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	spin_lock_bh(&css_set_lock);
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
@@ -2229,7 +2247,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 	}
 
 	spin_unlock_bh(&css_set_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return path;
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
@@ -2790,7 +2808,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	struct cgroup_root *root;
 	int retval = 0;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
 
@@ -2805,7 +2823,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (retval)
 			break;
 	}
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	return retval;
 }
@@ -2968,7 +2986,7 @@ static void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 	int ssid;
 
 restart:
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		for_each_subsys(ss, ssid) {
@@ -2982,7 +3000,7 @@ static void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 			prepare_to_wait(&dsct->offline_waitq, &wait,
 					TASK_UNINTERRUPTIBLE);
 
-			mutex_unlock(&cgroup_mutex);
+			cgroup_unlock();
 			schedule();
 			finish_wait(&dsct->offline_waitq, &wait);
 
@@ -3426,11 +3444,11 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	kernfs_break_active_protection(new_parent);
 	kernfs_break_active_protection(kn);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	ret = kernfs_rename(kn, new_parent, new_name_str);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	kernfs_unbreak_active_protection(kn);
 	kernfs_unbreak_active_protection(new_parent);
@@ -3637,9 +3655,9 @@ int cgroup_rm_cftypes(struct cftype *cfts)
 {
 	int ret;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	ret = cgroup_rm_cftypes_locked(cfts);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return ret;
 }
 
@@ -3671,14 +3689,14 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	if (ret)
 		return ret;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	list_add_tail(&cfts->node, &ss->cfts);
 	ret = cgroup_apply_cftypes(cfts, true);
 	if (ret)
 		cgroup_rm_cftypes_locked(cfts);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return ret;
 }
 
@@ -4170,7 +4188,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	if (!cgroup_may_migrate_to(to))
 		return -EBUSY;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/* all tasks in @from are being moved, all csets are source */
 	spin_lock_bh(&css_set_lock);
@@ -4200,7 +4218,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	} while (task && !ret);
 out_err:
 	cgroup_migrate_finish(&preloaded_csets);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return ret;
 }
 
@@ -4507,7 +4525,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	    kernfs_type(kn) != KERNFS_DIR)
 		return -EINVAL;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/*
 	 * We aren't being called from kernfs and there's no guarantee on
@@ -4518,7 +4536,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	cgrp = rcu_dereference(kn->priv);
 	if (!cgrp || cgroup_is_dead(cgrp)) {
 		rcu_read_unlock();
-		mutex_unlock(&cgroup_mutex);
+		cgroup_unlock();
 		return -ENOENT;
 	}
 	rcu_read_unlock();
@@ -4546,7 +4564,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	css_task_iter_end(&it);
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -4847,7 +4865,7 @@ static void css_release_work_fn(struct work_struct *work)
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	css->flags |= CSS_RELEASED;
 	list_del_rcu(&css->sibling);
@@ -4874,7 +4892,7 @@ static void css_release_work_fn(struct work_struct *work)
 					 NULL);
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
@@ -5168,7 +5186,7 @@ static void css_killed_work_fn(struct work_struct *work)
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	do {
 		offline_css(css);
@@ -5177,7 +5195,7 @@ static void css_killed_work_fn(struct work_struct *work)
 		css = css->parent;
 	} while (css && atomic_dec_and_test(&css->online_cnt));
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 }
 
 /* css kill confirmation processing requires process context, bounce */
@@ -5330,7 +5348,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	pr_debug("Initializing cgroup subsys %s\n", ss->name);
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	idr_init(&ss->css_idr);
 	INIT_LIST_HEAD(&ss->cfts);
@@ -5374,7 +5392,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	BUG_ON(online_css(css));
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 }
 
 /**
@@ -5431,7 +5449,7 @@ int __init cgroup_init(void)
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	/*
 	 * Add init_css_set to the hash table so that dfl_root can link to
@@ -5442,7 +5460,7 @@ int __init cgroup_init(void)
 
 	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0));
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 
 	for_each_subsys(ss, ssid) {
 		if (ss->early_init) {
@@ -5548,7 +5566,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 	if (!buf)
 		goto out;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 	spin_lock_bh(&css_set_lock);
 
 	for_each_root(root) {
@@ -5602,7 +5620,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 	retval = 0;
 out_unlock:
 	spin_unlock_bh(&css_set_lock);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	kfree(buf);
 out:
 	return retval;
@@ -5620,7 +5638,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
 	 * subsys/hierarchy state.
 	 */
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	for_each_subsys(ss, i)
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
@@ -5628,7 +5646,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -5860,7 +5878,7 @@ static void cgroup_release_agent(struct work_struct *work)
 	char *pathbuf = NULL, *agentbuf = NULL, *path;
 	char *argv[3], *envp[3];
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
@@ -5880,11 +5898,11 @@ static void cgroup_release_agent(struct work_struct *work)
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 	goto out_free;
 out:
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 out_free:
 	kfree(agentbuf);
 	kfree(pathbuf);
@@ -6006,7 +6024,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
 	struct kernfs_node *kn;
 	struct cgroup *cgrp;
 
-	mutex_lock(&cgroup_mutex);
+	cgroup_lock();
 
 	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
 	if (kn) {
@@ -6021,7 +6039,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
 		cgrp = ERR_PTR(-ENOENT);
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
-- 
2.5.0
