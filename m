From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
Date: Mon, 03 Nov 2014 17:56:59 -0800
Message-ID: <5458326B.4000409@google.com>
References: <adityakali-cgroupns>
	<1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-6-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1414783141-6947-6-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org


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
---
  fs/proc/namespaces.c             |   1 +
  include/linux/cgroup.h           |  18 +++++-
  include/linux/cgroup_namespace.h |  36 +++++++++++
  include/linux/nsproxy.h          |   2 +
  include/linux/proc_ns.h          |   4 ++
  kernel/Makefile                  |   2 +-
  kernel/cgroup.c                  |  14 +++++
  kernel/cgroup_namespace.c        | 127 
+++++++++++++++++++++++++++++++++++++++
  kernel/fork.c                    |   2 +-
  kernel/nsproxy.c                 |  19 +++++-
  10 files changed, 220 insertions(+), 5 deletions(-)
  create mode 100644 include/linux/cgroup_namespace.h
  create mode 100644 kernel/cgroup_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 8902609..55bc5da 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -32,6 +32,7 @@ static const struct proc_ns_operations *ns_entries[] = {
  	&userns_operations,
  #endif
  	&mntns_operations,
+	&cgroupns_operations,
  };

  static const struct file_operations ns_file_operations = {
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4a0eb2d..aa86495 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,6 +22,8 @@
  #include <linux/seq_file.h>
  #include <linux/kernfs.h>
  #include <linux/wait.h>
+#include <linux/nsproxy.h>
+#include <linux/types.h>

  #ifdef CONFIG_CGROUPS

@@ -460,6 +462,13 @@ struct cftype {
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

@@ -584,10 +593,17 @@ static inline int cgroup_name(struct cgroup *cgrp, 
char *buf, size_t buflen)
  	return kernfs_name(cgrp->kn, buf, buflen);
  }

+static inline char * __must_check cgroup_path_ns(struct 
cgroup_namespace *ns,
+						 struct cgroup *cgrp, char *buf,
+						 size_t buflen)
+{
+	return kernfs_path_from_node(ns->root_cgrp->kn, cgrp->kn, buf, buflen);
+}
+
  static inline char * __must_check cgroup_path(struct cgroup *cgrp, 
char *buf,
  					      size_t buflen)
  {
-	return kernfs_path(cgrp->kn, buf, buflen);
+	return cgroup_path_ns(current->nsproxy->cgroup_ns, cgrp, buf, buflen);
  }

  static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
diff --git a/include/linux/cgroup_namespace.h 
b/include/linux/cgroup_namespace.h
new file mode 100644
index 0000000..0b97b8d
--- /dev/null
+++ b/include/linux/cgroup_namespace.h
@@ -0,0 +1,36 @@
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
+static inline struct cgroup *current_cgroupns_root(void)
+{
+	return current->nsproxy->cgroup_ns->root_cgrp;
+}
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
diff --git a/kernel/Makefile b/kernel/Makefile
index dc5c775..d9731e2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
  obj-$(CONFIG_KEXEC) += kexec.o
  obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
  obj-$(CONFIG_COMPAT) += compat.o
-obj-$(CONFIG_CGROUPS) += cgroup.o
+obj-$(CONFIG_CGROUPS) += cgroup.o cgroup_namespace.o
  obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
  obj-$(CONFIG_CPUSETS) += cpuset.o
  obj-$(CONFIG_UTS_NS) += utsname.o
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9c622b9..7e5d597 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -57,6 +57,8 @@
  #include <linux/vmalloc.h> /* TODO: replace with more sophisticated 
array */
  #include <linux/kthread.h>
  #include <linux/delay.h>
+#include <linux/proc_ns.h>
+#include <linux/cgroup_namespace.h>

  #include <linux/atomic.h>

@@ -195,6 +197,15 @@ static void kill_css(struct cgroup_subsys_state *css);
  static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
  			      bool is_add);

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
  static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int 
end,
  			    gfp_t gfp_mask)
@@ -4550,6 +4561,7 @@ static int cgroup_mkdir(struct kernfs_node 
*parent_kn, const char *name,
  	parent = cgroup_kn_lock_live(parent_kn);
  	if (!parent)
  		return -ENODEV;
+
  	root = parent->root;

  	/* allocate the cgroup and its ID, 0 is reserved for the root */
@@ -4922,6 +4934,8 @@ int __init cgroup_init(void)
  	unsigned long key;
  	int ssid, err;

+	get_user_ns(init_cgroup_ns.user_ns);
+
  	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
  	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));

diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
new file mode 100644
index 0000000..0e0ef3a
--- /dev/null
+++ b/kernel/cgroup_namespace.c
@@ -0,0 +1,127 @@
+/*
+ *  Copyright (C) 2014 Google Inc.
+ *
+ *  Author: Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org)
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by 
the Free
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
+static struct cgroup_namespace *alloc_cgroup_ns(void)
+{
+	struct cgroup_namespace *new_ns;
+
+	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
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
+	kfree(ns);
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
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		goto err_out;
+
+	/* CGROUPNS only virtualizes the cgroup path on the unified hierarchy.
+	 */
+	cgrp = get_task_cgroup(current);
+
+	err = -ENOMEM;
+	new_ns = alloc_cgroup_ns();
+	if (!new_ns)
+		goto err_out;
+
+	err = proc_alloc_inum(&new_ns->proc_inum);
+	if (err)
+		goto err_out;
+
+	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->root_cgrp = cgrp;
+
+	return new_ns;
+
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
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy) {
+		ns = nsproxy->cgroup_ns;
+		get_cgroup_ns(ns);
+	}
+	task_unlock(task);
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
index 9b7d746..d22d793 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1797,7 +1797,7 @@ static int check_unshare_flags(unsigned long 
unshare_flags)
  	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
  				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
  				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP))
  		return -EINVAL;
  	/*
  	 * Not implemented, but pretend it works if there is nothing to
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ef42d0a..a8b1970 100644
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
@@ -92,6 +94,13 @@ static struct nsproxy *create_new_namespaces(unsigned 
long flags,
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
@@ -101,6 +110,9 @@ static struct nsproxy 
*create_new_namespaces(unsigned long flags,
  	return new_nsp;

  out_net:
+	if (new_nsp->cgroup_ns)
+		put_cgroup_ns(new_nsp->cgroup_ns);
+out_cgroup:
  	if (new_nsp->pid_ns_for_children)
  		put_pid_ns(new_nsp->pid_ns_for_children);
  out_pid:
@@ -128,7 +140,8 @@ int copy_namespaces(unsigned long flags, struct 
task_struct *tsk)
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
@@ -180,7 +195,7 @@ int unshare_nsproxy_namespaces(unsigned long 
unshare_flags,
  	int err = 0;

  	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP)))
  		return 0;

  	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
-- 
2.1.0.rc2.206.gedb03e5
