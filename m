From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cgroup: introduce cgroup namespaces
Date: Thu, 17 Jul 2014 12:52:11 -0700
Message-ID: <1405626731-12220-6-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1405626731-12220-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1405626731-12220-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Introduce the ability to create new cgroup namespace. The newly created
cgroup namespace remembers the 'struct cgroup *root_cgrp' at the point
of creation of the cgroup namespace. The task that creates the new
cgroup namespace and all its future children will now be restricted only
to the cgroup hierarchy under this root_cgrp. In the first version,
setns() is not supported for cgroup namespaces.
The main purpose of cgroup namespace is to virtualize the contents
of /proc/self/cgroup file. Processes inside a cgroup namespace
are only able to see paths relative to their namespace root.
This allows container-tools (like libcontainer, lxc, lmctfy, etc.)
to create completely virtualized containers without leaking system
level cgroup hierarchy to the task.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/proc/namespaces.c             |   3 +
 include/linux/cgroup.h           |  18 +++++-
 include/linux/cgroup_namespace.h |  62 +++++++++++++++++++
 include/linux/nsproxy.h          |   2 +
 include/linux/proc_ns.h          |   4 ++
 init/Kconfig                     |   9 +++
 kernel/Makefile                  |   1 +
 kernel/cgroup.c                  |  32 ++++++++++
 kernel/cgroup_namespace.c        | 128 +++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                    |   2 +-
 kernel/nsproxy.c                 |  19 +++++-
 11 files changed, 276 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/cgroup_namespace.h
 create mode 100644 kernel/cgroup_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 8902609..e04ed4b 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -32,6 +32,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 	&userns_operations,
 #endif
 	&mntns_operations,
+#ifdef CONFIG_CGROUP_NS
+	&cgroupns_operations,
+#endif
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4ea477f..d3c6070 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,6 +22,8 @@
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
 #include <linux/wait.h>
+#include <linux/nsproxy.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -469,6 +471,13 @@ struct cftype {
 #endif
 };
 
+struct cgroup_namespace {
+	atomic_t		count;
+	unsigned int		proc_inum;
+	struct user_namespace	*user_ns;
+	struct cgroup		*root_cgrp;
+};
+
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
@@ -591,10 +600,17 @@ static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 	return kernfs_name(cgrp->kn, buf, buflen);
 }
 
+static inline char * __must_check cgroup_path_ns(struct cgroup_namespace *ns,
+						 struct cgroup *cgrp, char *buf,
+						 size_t buflen)
+{
+	return kernfs_path_from_node(ns->root_cgrp->kn, cgrp->kn, buf, buflen);
+}
+
 static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
 					      size_t buflen)
 {
-	return kernfs_path(cgrp->kn, buf, buflen);
+	return cgroup_path_ns(current->nsproxy->cgroup_ns, cgrp, buf, buflen);
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
diff --git a/include/linux/cgroup_namespace.h b/include/linux/cgroup_namespace.h
new file mode 100644
index 0000000..9f637fe
--- /dev/null
+++ b/include/linux/cgroup_namespace.h
@@ -0,0 +1,62 @@
+#ifndef _LINUX_CGROUP_NAMESPACE_H
+#define _LINUX_CGROUP_NAMESPACE_H
+
+#include <linux/nsproxy.h>
+#include <linux/cgroup.h>
+#include <linux/types.h>
+#include <linux/user_namespace.h>
+
+extern struct cgroup_namespace init_cgroup_ns;
+
+static inline struct cgroup *task_cgroupns_root(struct task_struct *tsk)
+{
+	return tsk->nsproxy->cgroup_ns->root_cgrp;
+}
+
+#ifdef CONFIG_CGROUP_NS
+
+extern void free_cgroup_ns(struct cgroup_namespace *ns);
+
+static inline struct cgroup_namespace *get_cgroup_ns(
+		struct cgroup_namespace *ns)
+{
+	if (ns)
+		atomic_inc(&ns->count);
+	return ns;
+}
+
+static inline void put_cgroup_ns(struct cgroup_namespace *ns)
+{
+	if (ns && atomic_dec_and_test(&ns->count))
+		free_cgroup_ns(ns);
+}
+
+extern struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					       struct user_namespace *user_ns,
+					       struct cgroup_namespace *old_ns);
+
+#else  /* CONFIG_CGROUP_NS */
+
+static inline struct cgroup_namespace *get_cgroup_ns(
+		struct cgroup_namespace *ns)
+{
+	return &init_cgroup_ns;
+}
+
+static inline void put_cgroup_ns(struct cgroup_namespace *ns)
+{
+}
+
+static inline struct cgroup_namespace *copy_cgroup_ns(
+		unsigned long flags,
+		struct user_namespace *user_ns,
+		struct cgroup_namespace *old_ns) {
+	if (flags & CLONE_NEWCGROUP)
+		return ERR_PTR(-EINVAL);
+
+	return old_ns;
+}
+
+#endif  /* CONFIG_CGROUP_NS */
+
+#endif  /* _LINUX_CGROUP_NAMESPACE_H */
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d..44f388c 100644
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
index 34a1e10..e56dd73 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -6,6 +6,8 @@
 
 struct pid_namespace;
 struct nsproxy;
+struct task_struct;
+struct inode;
 
 struct proc_ns_operations {
 	const char *name;
@@ -27,6 +29,7 @@ extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
+extern const struct proc_ns_operations cgroupns_operations;
 
 /*
  * We always define these enumerators
@@ -37,6 +40,7 @@ enum {
 	PROC_UTS_INIT_INO	= 0xEFFFFFFEU,
 	PROC_USER_INIT_INO	= 0xEFFFFFFDU,
 	PROC_PID_INIT_INO	= 0xEFFFFFFCU,
+	PROC_CGROUP_INIT_INO	= 0xEFFFFFFBU,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99..2f43ec9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1101,6 +1101,15 @@ config DEBUG_BLK_CGROUP
 	Enable some debugging help. Currently it exports additional stat
 	files in a cgroup which can be useful for debugging.
 
+config CGROUP_NS
+	bool "CGroup Namespaces"
+	default n
+	help
+	  This options enables CGroup Namespaces which can be used to isolate
+	  cgroup paths. This feature is only useful when unified cgroup
+	  hierarchy is in use (i.e. cgroups are mounted with sane_behavior
+	  option).
+
 endif # CGROUPS
 
 config CHECKPOINT_RESTORE
diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b62..61c5791 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
+obj-$(CONFIG_CGROUP_NS) += cgroup_namespace.o
 obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_UTS_NS) += utsname.o
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8552513..c04e971 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -57,6 +57,8 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/proc_ns.h>
+#include <linux/cgroup_namespace.h>
 
 #include <linux/atomic.h>
 
@@ -196,6 +198,15 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
 
+struct cgroup_namespace init_cgroup_ns = {
+	.count = {
+		.counter = 1,
+	},
+	.proc_inum = PROC_CGROUP_INIT_INO,
+	.user_ns = &init_user_ns,
+	.root_cgrp = &cgrp_dfl_root.cgrp,
+};
+
 /* IDR wrappers which synchronize using cgroup_idr_lock */
 static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
 			    gfp_t gfp_mask)
@@ -2333,6 +2344,12 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	struct task_struct *task;
 	int ret;
 
+	/* Only allow changing cgroups accessible within task's cgroup
+	 * namespace. i.e. 'dst_cgrp' should be a descendant of task's
+	 * cgroupns->root_cgrp. */
+	if (!cgroup_is_descendant(dst_cgrp, task_cgroupns_root(leader)))
+		return -EPERM;
+
 	/* look up all src csets */
 	down_read(&css_set_rwsem);
 	rcu_read_lock();
@@ -4551,6 +4568,13 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
+
+	/* Allow mkdir only within process's cgroup namespace root. */
+	if (!cgroup_is_descendant(parent, task_cgroupns_root(current))) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
 	root = parent->root;
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
@@ -4819,6 +4843,14 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	cgrp = cgroup_kn_lock_live(kn);
 	if (!cgrp)
 		return 0;
+
+	/* Allow rmdir only within process's cgroup namespace root.
+	 * The process can't delete its own root anyways. */
+	if (!cgroup_is_descendant(cgrp, task_cgroupns_root(current))) {
+		cgroup_kn_unlock(kn);
+		return -EPERM;
+	}
+
 	cgroup_get(cgrp);	/* for @kn->priv clearing */
 
 	ret = cgroup_destroy_locked(cgrp);
diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
new file mode 100644
index 0000000..a2e6804
--- /dev/null
+++ b/kernel/cgroup_namespace.c
@@ -0,0 +1,128 @@
+
+#include <linux/cgroup.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/nsproxy.h>
+#include <linux/proc_ns.h>
+
+static struct cgroup_namespace *alloc_cgroup_ns(void)
+{
+	struct cgroup_namespace *new_ns;
+
+	new_ns = kmalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
+	if (new_ns)
+		atomic_set(&new_ns->count, 1);
+	return new_ns;
+}
+
+void free_cgroup_ns(struct cgroup_namespace *ns)
+{
+	cgroup_put(ns->root_cgrp);
+	put_user_ns(ns->user_ns);
+	proc_free_inum(ns->proc_inum);
+}
+EXPORT_SYMBOL(free_cgroup_ns);
+
+struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					struct user_namespace *user_ns,
+					struct cgroup_namespace *old_ns)
+{
+	struct cgroup_namespace *new_ns = NULL;
+	struct cgroup *cgrp = NULL;
+	int err;
+
+	BUG_ON(!old_ns);
+
+	if (!(flags & CLONE_NEWCGROUP))
+		return get_cgroup_ns(old_ns);
+
+	/* Allow only sysadmin to create cgroup namespace. */
+	err = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto err_out;
+
+	/* Prevent cgroup changes for this task. */
+	threadgroup_lock(current);
+
+	cgrp = get_task_cgroup(current);
+
+	/* Creating new CGROUPNS is supported only when unified hierarchy is in
+	 * use. */
+	err = -EINVAL;
+	if (!cgroup_on_dfl(cgrp))
+		goto err_out_unlock;
+
+	err = -ENOMEM;
+	new_ns = alloc_cgroup_ns();
+	if (!new_ns)
+		goto err_out_unlock;
+
+	err = proc_alloc_inum(&new_ns->proc_inum);
+	if (err)
+		goto err_out_unlock;
+
+	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->root_cgrp = cgrp;
+
+	threadgroup_unlock(current);
+
+	return new_ns;
+
+err_out_unlock:
+	threadgroup_unlock(current);
+err_out:
+	if (cgrp)
+		cgroup_put(cgrp);
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
+static void *cgroupns_get(struct task_struct *task)
+{
+	struct cgroup_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	rcu_read_lock();
+	nsproxy = task_nsproxy(task);
+	if (nsproxy) {
+		ns = nsproxy->cgroup_ns;
+		get_cgroup_ns(ns);
+	}
+	rcu_read_unlock();
+
+	return ns;
+}
+
+static void cgroupns_put(void *ns)
+{
+	put_cgroup_ns(ns);
+}
+
+static unsigned int cgroupns_inum(void *ns)
+{
+	struct cgroup_namespace *cgroup_ns = ns;
+
+	return cgroup_ns->proc_inum;
+}
+
+const struct proc_ns_operations cgroupns_operations = {
+	.name		= "cgroup",
+	.type		= CLONE_NEWCGROUP,
+	.get		= cgroupns_get,
+	.put		= cgroupns_put,
+	.install	= cgroupns_install,
+	.inum		= cgroupns_inum,
+};
+
+static __init int cgroup_namespaces_init(void)
+{
+	return 0;
+}
+subsys_initcall(cgroup_namespaces_init);
diff --git a/kernel/fork.c b/kernel/fork.c
index d2799d1..95981a1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1747,7 +1747,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing to
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..e20298c 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/cgroup_namespace.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -39,6 +40,7 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_NET
 	.net_ns			= &init_net,
 #endif
+	.cgroup_ns		= &init_cgroup_ns,
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -92,6 +94,13 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
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
@@ -101,6 +110,9 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	return new_nsp;
 
 out_net:
+	if (new_nsp->cgroup_ns)
+		put_cgroup_ns(new_nsp->cgroup_ns);
+out_cgroup:
 	if (new_nsp->pid_ns_for_children)
 		put_pid_ns(new_nsp->pid_ns_for_children);
 out_pid:
@@ -128,7 +140,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *new_ns;
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			      CLONE_NEWPID | CLONE_NEWNET)))) {
+			      CLONE_NEWPID | CLONE_NEWNET |
+			      CLONE_NEWCGROUP)))) {
 		get_nsproxy(old_ns);
 		return 0;
 	}
@@ -165,6 +178,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
+	if (ns->cgroup_ns)
+		put_cgroup_ns(ns->cgroup_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
@@ -180,7 +195,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
-- 
2.0.0.526.g5318336
