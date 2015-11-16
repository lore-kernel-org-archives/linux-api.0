From: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 5/8] cgroup: introduce cgroup namespaces
Date: Mon, 16 Nov 2015 13:51:42 -0600
Message-ID: <1447703505-29672-6-git-send-email-serge@hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1447703505-29672-1-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Introduce the ability to create new cgroup namespace. The newly created
cgroup namespace remembers the cgroup of the process at the point
of creation of the cgroup namespace (referred as cgroupns-root).
The main purpose of cgroup namespace is to virtualize the contents
of /proc/self/cgroup file. Processes inside a cgroup namespace
are only able to see paths relative to their namespace root
(unless they are moved outside of their cgroupns-root, at which point
 they will see a relative path from their cgroupns-root).
For a correctly setup container this enables container-tools
(like libcontainer, lxc, lmctfy, etc.) to create completely virtualized
containers without leaking system level cgroup hierarchy to the task.
This patch only implements the 'unshare' part of the cgroupns.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/proc/namespaces.c             |    3 +
 include/linux/cgroup.h           |   21 ++++---
 include/linux/cgroup_namespace.h |   46 ++++++++++++++
 include/linux/nsproxy.h          |    2 +
 include/linux/proc_ns.h          |    4 ++
 kernel/Makefile                  |    2 +-
 kernel/cgroup.c                  |   39 +++++++++++-
 kernel/cgroup_namespace.c        |  127 ++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                    |    2 +-
 kernel/nsproxy.c                 |   21 ++++++-
 10 files changed, 252 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/cgroup_namespace.h
 create mode 100644 kernel/cgroup_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index f6e8354..bd61075 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -28,6 +28,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 	&userns_operations,
 #endif
 	&mntns_operations,
+#ifdef CONFIG_CGROUPS
+	&cgroupns_operations,
+#endif
 };
 
 static const char *proc_ns_follow_link(struct dentry *dentry, void **cookie)
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 99096be..b3ce9d9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,6 +17,9 @@
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
 #include <linux/jump_label.h>
+#include <linux/nsproxy.h>
+#include <linux/types.h>
+#include <linux/ns_common.h>
 
 #include <linux/cgroup-defs.h>
 
@@ -237,6 +240,10 @@ static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 	return !(cgrp->self.flags & CSS_ONLINE);
 }
 
+static inline void css_get(struct cgroup_subsys_state *css);
+static inline void css_put(struct cgroup_subsys_state *css);
+static inline bool css_tryget(struct cgroup_subsys_state *css);
+
 static inline void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
@@ -284,9 +291,11 @@ static inline void cgroup_put(struct cgroup *cgrp)
 			;						\
 		else
 
-/*
- * Inline functions.
- */
+extern char * __must_check cgroup_path_ns(struct cgroup_namespace *ns,
+		struct cgroup *cgrp, char *buf, size_t buflen);
+
+extern char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
+		size_t buflen);
 
 /**
  * css_get - obtain a reference on the specified css
@@ -522,12 +531,6 @@ static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 	return kernfs_name(cgrp->kn, buf, buflen);
 }
 
-static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
-					      size_t buflen)
-{
-	return kernfs_path(cgrp->kn, buf, buflen);
-}
-
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
 {
 	pr_cont_kernfs_name(cgrp->kn);
diff --git a/include/linux/cgroup_namespace.h b/include/linux/cgroup_namespace.h
new file mode 100644
index 0000000..ed181c3
--- /dev/null
+++ b/include/linux/cgroup_namespace.h
@@ -0,0 +1,46 @@
+#ifndef _LINUX_CGROUP_NAMESPACE_H
+#define _LINUX_CGROUP_NAMESPACE_H
+
+#include <linux/nsproxy.h>
+#include <linux/cgroup.h>
+#include <linux/types.h>
+#include <linux/user_namespace.h>
+
+struct css_set;
+struct cgroup_namespace {
+	atomic_t		count;
+	struct ns_common	ns;
+	struct user_namespace	*user_ns;
+	struct css_set          *root_cgrps;
+};
+
+extern struct cgroup_namespace init_cgroup_ns;
+
+static inline struct cgroup_namespace *get_cgroup_ns(
+		struct cgroup_namespace *ns)
+{
+	if (ns)
+		atomic_inc(&ns->count);
+	return ns;
+}
+
+#ifdef CONFIG_CGROUPS
+extern void free_cgroup_ns(struct cgroup_namespace *ns);
+extern struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					       struct user_namespace *user_ns,
+					       struct cgroup_namespace *old_ns);
+#else /* CONFIG_CGROUP */
+static inline void free_cgroup_ns(struct cgroup_namespace *ns) { }
+static inline struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					struct user_namespace *user_ns,
+					struct cgroup_namespace *old_ns)
+{ return old_ns; }
+#endif
+
+static inline void put_cgroup_ns(struct cgroup_namespace *ns)
+{
+	if (ns && atomic_dec_and_test(&ns->count))
+		free_cgroup_ns(ns);
+}
+
+#endif  /* _LINUX_CGROUP_NAMESPACE_H */
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 35fa08f..ac0d65b 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -8,6 +8,7 @@ struct mnt_namespace;
 struct uts_namespace;
 struct ipc_namespace;
 struct pid_namespace;
+struct cgroup_namespace;
 struct fs_struct;
 
 /*
@@ -33,6 +34,7 @@ struct nsproxy {
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
+	struct cgroup_namespace *cgroup_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 42dfc61..de0e771 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -9,6 +9,8 @@
 struct pid_namespace;
 struct nsproxy;
 struct path;
+struct task_struct;
+struct inode;
 
 struct proc_ns_operations {
 	const char *name;
@@ -24,6 +26,7 @@ extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
+extern const struct proc_ns_operations cgroupns_operations;
 
 /*
  * We always define these enumerators
@@ -34,6 +37,7 @@ enum {
 	PROC_UTS_INIT_INO	= 0xEFFFFFFEU,
 	PROC_USER_INIT_INO	= 0xEFFFFFFDU,
 	PROC_PID_INIT_INO	= 0xEFFFFFFCU,
+	PROC_CGROUP_INIT_INO	= 0xEFFFFFFBU,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf00..1dce664 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -54,7 +54,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
-obj-$(CONFIG_CGROUPS) += cgroup.o
+obj-$(CONFIG_CGROUPS) += cgroup.o cgroup_namespace.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += cgroup_pids.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e972259..1d696de 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -57,6 +57,8 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/proc_ns.h>
+#include <linux/cgroup_namespace.h>
 
 #include <linux/atomic.h>
 
@@ -290,6 +292,15 @@ static bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
 	return cgrp->root == &cgrp_dfl_root;
 }
+struct cgroup_namespace init_cgroup_ns = {
+	.count = {
+		.counter = 1,
+	},
+	.user_ns = &init_user_ns,
+	.ns.ops = &cgroupns_operations,
+	.ns.inum = PROC_CGROUP_INIT_INO,
+	.root_cgrps = &init_css_set,
+};
 
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
@@ -749,7 +760,7 @@ static void put_css_set_locked(struct css_set *cset)
 	kfree_rcu(cset, rcu_head);
 }
 
-static void put_css_set(struct css_set *cset)
+void put_css_set(struct css_set *cset)
 {
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
@@ -767,7 +778,7 @@ static void put_css_set(struct css_set *cset)
 /*
  * refcounted get/put for css_set objects
  */
-static inline void get_css_set(struct css_set *cset)
+void get_css_set(struct css_set *cset)
 {
 	atomic_inc(&cset->refcount);
 }
@@ -2148,6 +2159,28 @@ static struct file_system_type cgroup_fs_type = {
 	.kill_sb = cgroup_kill_sb,
 };
 
+char * __must_check cgroup_path_ns(struct cgroup_namespace *ns,
+						 struct cgroup *cgrp, char *buf,
+						 size_t buflen)
+{
+	if (ns) {
+		struct cgroup *root;
+		root = cset_cgroup_from_root(ns->root_cgrps, cgrp->root);
+		return kernfs_path_from_node(root->kn, cgrp->kn, buf,
+					     buflen);
+	} else {
+		return kernfs_path(cgrp->kn, buf, buflen);
+	}
+}
+
+char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
+					      size_t buflen)
+{
+	return cgroup_path_ns(current->nsproxy->cgroup_ns, cgrp, buf,
+				      buflen);
+}
+EXPORT_SYMBOL_GPL(cgroup_path);
+
 /**
  * task_cgroup_path - cgroup path of a task in the first cgroup hierarchy
  * @task: target task
@@ -5237,6 +5270,8 @@ int __init cgroup_init(void)
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
+	get_user_ns(init_cgroup_ns.user_ns);
+
 	mutex_lock(&cgroup_mutex);
 
 	/* Add init_css_set to the hash table */
diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
new file mode 100644
index 0000000..ef20777
--- /dev/null
+++ b/kernel/cgroup_namespace.c
@@ -0,0 +1,127 @@
+/*
+ *  Copyright (C) 2014 Google Inc.
+ *
+ *  Author: Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org)
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the Free
+ *  Software Foundation, version 2 of the License.
+ */
+
+#include <linux/cgroup.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/nsproxy.h>
+#include <linux/proc_ns.h>
+
+const struct proc_ns_operations cgroupns_operations;
+
+static struct cgroup_namespace *alloc_cgroup_ns(void)
+{
+	struct cgroup_namespace *new_ns;
+	int ret;
+
+	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
+	if (!new_ns)
+		return ERR_PTR(-ENOMEM);
+	ret = ns_alloc_inum(&new_ns->ns);
+	if (ret) {
+		kfree(new_ns);
+		return ERR_PTR(ret);
+	}
+	atomic_set(&new_ns->count, 1);
+	new_ns->ns.ops = &cgroupns_operations;
+	return new_ns;
+}
+
+extern void put_css_set(struct css_set *cset);
+extern  void get_css_set(struct css_set *cset);
+
+void free_cgroup_ns(struct cgroup_namespace *ns)
+{
+	put_css_set(ns->root_cgrps);
+	put_user_ns(ns->user_ns);
+	ns_free_inum(&ns->ns);
+	kfree(ns);
+}
+EXPORT_SYMBOL(free_cgroup_ns);
+
+struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					struct user_namespace *user_ns,
+					struct cgroup_namespace *old_ns)
+{
+	struct cgroup_namespace *new_ns = NULL;
+	struct css_set *cgrps = NULL;
+	int err;
+
+	BUG_ON(!old_ns);
+
+	if (!(flags & CLONE_NEWCGROUP))
+		return get_cgroup_ns(old_ns);
+
+	/* Allow only sysadmin to create cgroup namespace. */
+	err = -EPERM;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		goto err_out;
+
+	cgrps = task_css_set(current);
+	get_css_set(cgrps);
+
+	err = -ENOMEM;
+	new_ns = alloc_cgroup_ns();
+	if (!new_ns)
+		goto err_out;
+
+	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->root_cgrps = cgrps;
+
+	return new_ns;
+
+err_out:
+	if (cgrps)
+		put_css_set(cgrps);
+	kfree(new_ns);
+	return ERR_PTR(err);
+}
+
+static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
+{
+	pr_info("setns not supported for cgroup namespace");
+	return -EINVAL;
+}
+
+static struct ns_common *cgroupns_get(struct task_struct *task)
+{
+	struct cgroup_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy) {
+		ns = nsproxy->cgroup_ns;
+		get_cgroup_ns(ns);
+	}
+	task_unlock(task);
+
+	return ns ? &ns->ns : NULL;
+}
+
+static void cgroupns_put(struct ns_common *ns)
+{
+	put_cgroup_ns(to_cg_ns(ns));
+}
+
+const struct proc_ns_operations cgroupns_operations = {
+	.name		= "cgroup",
+	.type		= CLONE_NEWCGROUP,
+	.get		= cgroupns_get,
+	.put		= cgroupns_put,
+	.install	= cgroupns_install,
+};
+
+static __init int cgroup_namespaces_init(void)
+{
+	return 0;
+}
+subsys_initcall(cgroup_namespaces_init);
diff --git a/kernel/fork.c b/kernel/fork.c
index f97f2c4..c16e6a3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1884,7 +1884,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 49746c8..7f51796 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/cgroup_namespace.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -39,6 +40,9 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_NET
 	.net_ns			= &init_net,
 #endif
+#ifdef CONFIG_CGROUPS
+	.cgroup_ns		= &init_cgroup_ns,
+#endif
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -92,6 +96,13 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_pid;
 	}
 
+	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
+					    tsk->nsproxy->cgroup_ns);
+	if (IS_ERR(new_nsp->cgroup_ns)) {
+		err = PTR_ERR(new_nsp->cgroup_ns);
+		goto out_cgroup;
+	}
+
 	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
 	if (IS_ERR(new_nsp->net_ns)) {
 		err = PTR_ERR(new_nsp->net_ns);
@@ -101,6 +112,9 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	return new_nsp;
 
 out_net:
+	if (new_nsp->cgroup_ns)
+		put_cgroup_ns(new_nsp->cgroup_ns);
+out_cgroup:
 	if (new_nsp->pid_ns_for_children)
 		put_pid_ns(new_nsp->pid_ns_for_children);
 out_pid:
@@ -128,7 +142,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *new_ns;
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			      CLONE_NEWPID | CLONE_NEWNET)))) {
+			      CLONE_NEWPID | CLONE_NEWNET |
+			      CLONE_NEWCGROUP)))) {
 		get_nsproxy(old_ns);
 		return 0;
 	}
@@ -165,6 +180,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
+	if (ns->cgroup_ns)
+		put_cgroup_ns(ns->cgroup_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
@@ -180,7 +197,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
-- 
1.7.9.5
