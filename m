From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] lsm: namespace hooks
Date: Thu, 27 Nov 2014 15:01:06 +0100
Message-ID: <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1417096866-25563-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nikolay Aleksandrov <nikolay-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matthew Dempsky <mdempsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This commit implements an empty LSM namespace that provides 5 hooks for
LSM modules to implement. Using those an LSM module can implement its
own namespace. The first one to take advantage of this mechanism is
Smack.

Look into the comments in the security.h below for info about specific
hooks.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/proc/namespaces.c          |   4 ++
 include/linux/lsm_namespace.h |  68 +++++++++++++++++++
 include/linux/nsproxy.h       |   2 +
 include/linux/proc_ns.h       |   2 +
 include/linux/security.h      |  80 +++++++++++++++++++++++
 include/uapi/linux/sched.h    |   3 +-
 kernel/fork.c                 |   2 +-
 kernel/nsproxy.c              |  22 ++++++-
 security/Kconfig              |   8 +++
 security/Makefile             |   1 +
 security/capability.c         |  33 ++++++++++
 security/lsm_namespace.c      | 147 ++++++++++++++++++++++++++++++++++++++++++
 security/security.c           |  42 ++++++++++++
 13 files changed, 408 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/lsm_namespace.h
 create mode 100644 security/lsm_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 8902609..266e8d8 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -12,10 +12,14 @@
 #include <linux/ipc_namespace.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/lsm_namespace.h>
 #include "internal.h"
 
 
 static const struct proc_ns_operations *ns_entries[] = {
+#ifdef CONFIG_SECURITY_NS
+	&lsmns_operations,
+#endif
 #ifdef CONFIG_NET_NS
 	&netns_operations,
 #endif
diff --git a/include/linux/lsm_namespace.h b/include/linux/lsm_namespace.h
new file mode 100644
index 0000000..7caf3db
--- /dev/null
+++ b/include/linux/lsm_namespace.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics.
+ *
+ * LSM namespaces
+ *
+ * Author(s):
+ *    Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software, you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_LSM_S_H
+#define _LINUX_LSM_S_H
+
+#include <linux/sched.h>
+#include <linux/kref.h>
+
+struct lsm_namespace {
+	struct kref			kref;
+	struct user_namespace		*user_ns;
+	unsigned int			proc_inum;
+	/* for LSM usage */
+	void				*private;
+};
+
+extern struct lsm_namespace init_lsm_ns;
+
+#ifdef CONFIG_SECURITY_NS
+
+struct lsm_namespace *copy_lsm_ns(unsigned long flags,
+				  struct user_namespace *user_ns,
+				  struct lsm_namespace *ns);
+void free_lsm_ns(struct kref *kref);
+
+static inline struct lsm_namespace *get_lsm_ns(struct lsm_namespace *ns)
+{
+	kref_get(&ns->kref);
+	return ns;
+}
+
+static inline void put_lsm_ns(struct lsm_namespace *ns)
+{
+	kref_put(&ns->kref, free_lsm_ns);
+}
+
+#else /* CONFIG_SECURITY_NS */
+
+static inline struct lsm_namespace *copy_lsm_ns(unsigned long flags,
+						struct user_namespace *user_ns,
+						struct lsm_namespace *ns)
+{
+	return ns;
+}
+
+static inline struct lsm_namespace *get_lsm_ns(struct lsm_namespace *ns)
+{
+	return ns;
+}
+
+static inline void put_lsm_ns(struct lsm_namespace *ns)
+{
+}
+
+#endif /* CONFIG_SECURITY_NS */
+
+#endif /* _LINUX_LSM_S_H */
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d..58c7de1 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -8,6 +8,7 @@ struct mnt_namespace;
 struct uts_namespace;
 struct ipc_namespace;
 struct pid_namespace;
+struct lsm_namespace;
 struct fs_struct;
 
 /*
@@ -33,6 +34,7 @@ struct nsproxy {
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
+	struct lsm_namespace *lsm_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 34a1e10..b5eaa50 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -27,6 +27,7 @@ extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
+extern const struct proc_ns_operations lsmns_operations;
 
 /*
  * We always define these enumerators
@@ -37,6 +38,7 @@ enum {
 	PROC_UTS_INIT_INO	= 0xEFFFFFFEU,
 	PROC_USER_INIT_INO	= 0xEFFFFFFDU,
 	PROC_PID_INIT_INO	= 0xEFFFFFFCU,
+	PROC_LSM_INIT_INO	= 0xEFFFFFFBU,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/linux/security.h b/include/linux/security.h
index 3b3aeb1..82a6ece 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -144,6 +144,7 @@ extern unsigned long dac_mmap_min_addr;
 /* forward declares to avoid warnings */
 struct sched_param;
 struct request_sock;
+struct lsm_namespace;
 
 /* bprm->unsafe reasons */
 #define LSM_UNSAFE_SHARE	1
@@ -1400,6 +1401,37 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	audit_rule_init.
  *	@rule contains the allocated rule
  *
+ * @lsmns_init:
+ *	Initialize initial LSM namespace. This function should allocate and
+ *	fill the private part of the init_lsm_ns.
+ *
+ * @lsmns_allow:
+ *	Run during a request to create/copy new lsm namespace while creating
+ *	new nsproxy structure. Returning failure here will block the whole
+ *	operation requested from userspace (e.g. unshare() or clone()).
+ *	This function can be effectively used to disallow new namespaces
+ *	creation.
+ *	@flags contains flags passed to the userspace syscall (e.g. CLONE_*)
+ *	@user_ns points to the associated user namespace
+ *	@old_ns pints to the lsm namespace under which the operation happens
+ *	Return 0 to allow or -ERRNO to disallow.
+ *
+ * @lsmns_setns:
+ *	Run during a setns syscall to add a process to an already existing
+ *	lsm namespace. Returning failure here will block the operation
+ *	requested from userspace (setns() with CLONE_NEWLSM).
+ *	@nsproxy contains a nsproxy to which the lsm namespace will be assigned.
+ *	@ns contains lsm namespace that is to be incorporated to the nsproxy.
+ *
+ * @lsmns_create:
+ *	Allocates and fills the private part of a new lsm namespace.
+ *	@ns points to a newly created lsm namespace.
+ *	Return a pointer to a namespace or ERR_PTR(-ERRNO) on error.
+ *
+ * @lsmns_free:
+ *	Deallocates the private part of a new lsm namespace.
+ *	@ns points to a lsm namespace about to be destroyed.
+ *
  * @inode_notifysecctx:
  *	Notify the security module of what the security context of an inode
  *	should be.  Initializes the incore security context managed by the
@@ -1729,6 +1761,15 @@ struct security_operations {
 				 struct audit_context *actx);
 	void (*audit_rule_free) (void *lsmrule);
 #endif /* CONFIG_AUDIT */
+
+#ifdef CONFIG_SECURITY_NS
+	void (*lsmns_init)(void);
+	int (*lsmns_allow)(unsigned long flags, struct user_namespace *user_ns,
+			   struct lsm_namespace *old_ns);
+	int (*lsmns_setns)(struct nsproxy *nsproxy, struct lsm_namespace *ns);
+	int (*lsmns_create)(struct lsm_namespace *ns);
+	void (*lsmns_free)(struct lsm_namespace *ns);
+#endif /* CONFIG_SECURITY_NS */
 };
 
 /* prototypes */
@@ -3116,6 +3157,45 @@ static inline void security_audit_rule_free(void *lsmrule)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITY_NS
+
+void security_lsmns_init(void);
+int security_lsmns_allow(unsigned long flags, struct user_namespace *user_ns,
+			 struct lsm_namespace *old_ns);
+int security_lsmns_setns(struct nsproxy *nsproxy, struct lsm_namespace *ns);
+int security_lsmns_create(struct lsm_namespace *ns);
+void security_lsmns_free(struct lsm_namespace *ns);
+
+#else /* CONFIG_SECURITY_NS */
+
+static inline void security_lsmns_init(void)
+{
+}
+
+static inline int security_lsmns_allow(unsigned long flags,
+				       struct user_namespace *user_ns,
+				       struct lsm_namespace *old_ns)
+{
+	return 0;
+}
+
+static inline int security_lsmns_setns(struct nsproxy *nsproxy,
+				       struct lsm_namespace *ns)
+{
+	return 0;
+}
+
+static inline int security_lsmns_create(struct lsm_namespace *ns)
+{
+	return 0;
+}
+
+static inline void security_lsmns_free(struct lsm_namespace *ns)
+{
+}
+
+#endif /* CONFIG_SECURITY_NS */
+
 #ifdef CONFIG_SECURITYFS
 
 extern struct dentry *securityfs_create_file(const char *name, umode_t mode,
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 34f9d73..5ac7fb9 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -21,8 +21,7 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
-   and is now available for re-use. */
+#define CLONE_NEWLSM		0x02000000	/* New LSM namespace */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
diff --git a/kernel/fork.c b/kernel/fork.c
index ed4bc33..a5ac809 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1796,7 +1796,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWLSM))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing to
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..841228d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/lsm_namespace.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -39,6 +40,9 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_NET
 	.net_ns			= &init_net,
 #endif
+#ifdef CONFIG_SECURITY
+	.lsm_ns			= &init_lsm_ns,
+#endif
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -67,6 +71,12 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
+	new_nsp->lsm_ns = copy_lsm_ns(flags, user_ns, tsk->nsproxy->lsm_ns);
+	if (IS_ERR(new_nsp->lsm_ns)) {
+		err = PTR_ERR(new_nsp->lsm_ns);
+		goto out_lsm;
+	}
+
 	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns, new_fs);
 	if (IS_ERR(new_nsp->mnt_ns)) {
 		err = PTR_ERR(new_nsp->mnt_ns);
@@ -113,6 +123,9 @@ out_uts:
 	if (new_nsp->mnt_ns)
 		put_mnt_ns(new_nsp->mnt_ns);
 out_ns:
+	if (new_nsp->lsm_ns)
+		put_lsm_ns(new_nsp->lsm_ns);
+out_lsm:
 	kmem_cache_free(nsproxy_cachep, new_nsp);
 	return ERR_PTR(err);
 }
@@ -128,7 +141,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *new_ns;
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			      CLONE_NEWPID | CLONE_NEWNET)))) {
+			      CLONE_NEWPID | CLONE_NEWNET | CLONE_NEWLSM)))) {
 		get_nsproxy(old_ns);
 		return 0;
 	}
@@ -157,6 +170,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 
 void free_nsproxy(struct nsproxy *ns)
 {
+	if (ns->lsm_ns)
+		put_lsm_ns(ns->lsm_ns);
 	if (ns->mnt_ns)
 		put_mnt_ns(ns->mnt_ns);
 	if (ns->uts_ns)
@@ -165,7 +180,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
-	put_net(ns->net_ns);
+	if (ns->net_ns)
+		put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
 }
 
@@ -180,7 +196,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWLSM)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
diff --git a/security/Kconfig b/security/Kconfig
index beb86b5..7b2118b 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -70,6 +70,14 @@ config SECURITY_PATH
 	  implement pathname based access controls.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_NS
+	bool "Security namespace for LSM modules"
+	depends on SECURITY
+	help
+	  This enables security namespaces for Linux Security Modules.
+	  The implementation is specific to currently selected LSM module.
+	  If you are unsure how to answer this question, answer N.
+
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
 	depends on HAVE_INTEL_TXT
diff --git a/security/Makefile b/security/Makefile
index 05f1c93..f333265 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_SECURITY_NS)		+= lsm_namespace.o
 
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
diff --git a/security/capability.c b/security/capability.c
index a74fde6..e043cc9 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -919,6 +919,32 @@ static void cap_audit_rule_free(void *lsmrule)
 }
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITY_NS
+void cap_lsmns_init(void)
+{
+}
+
+int cap_lsmns_allow(unsigned long flags, struct user_namespace *user_ns,
+		    struct lsm_namespace *old_ns)
+{
+	return 0;
+}
+
+int cap_lsmns_setns(struct nsproxy *nsproxy, struct lsm_namespace *ns)
+{
+	return 0;
+}
+
+int cap_lsmns_create(struct lsm_namespace *ns)
+{
+	return 0;
+}
+
+void cap_lsmns_free(struct lsm_namespace *ns)
+{
+}
+#endif /* CONFIG_SECURITY_NS */
+
 #define set_to_cap_if_null(ops, function)				\
 	do {								\
 		if (!ops->function) {					\
@@ -1134,4 +1160,11 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, audit_rule_match);
 	set_to_cap_if_null(ops, audit_rule_free);
 #endif
+#ifdef CONFIG_SECURITY_NS
+	set_to_cap_if_null(ops, lsmns_init);
+	set_to_cap_if_null(ops, lsmns_allow);
+	set_to_cap_if_null(ops, lsmns_setns);
+	set_to_cap_if_null(ops, lsmns_create);
+	set_to_cap_if_null(ops, lsmns_free);
+#endif
 }
diff --git a/security/lsm_namespace.c b/security/lsm_namespace.c
new file mode 100644
index 0000000..8f7ec3b
--- /dev/null
+++ b/security/lsm_namespace.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics.
+ *
+ * LSM namespaces
+ *
+ * Author(s):
+ *    Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software, you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/lsm_namespace.h>
+#include <linux/user_namespace.h>
+#include <linux/nsproxy.h>
+#include <linux/proc_ns.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+
+
+/* private functions */
+
+static struct lsm_namespace *create_lsm_ns(struct user_namespace *user_ns,
+					   struct lsm_namespace *old_ns)
+{
+	struct lsm_namespace *ns;
+	int err;
+
+	ns = kmalloc(sizeof(struct lsm_namespace), GFP_KERNEL);
+	if (ns == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	err = proc_alloc_inum(&ns->proc_inum);
+	if (err)
+		goto freeout;
+
+	kref_init(&ns->kref);
+	ns->user_ns = get_user_ns(user_ns);
+	ns->private = NULL;
+
+	err = security_lsmns_create(ns);
+	if (err) {
+		put_user_ns(user_ns);
+		goto freeout;
+	}
+
+	return ns;
+
+freeout:
+	kfree(ns);
+	return ERR_PTR(err);
+}
+
+/* public functions */
+
+struct lsm_namespace *copy_lsm_ns(unsigned long flags,
+				  struct user_namespace *user_ns,
+				  struct lsm_namespace *ns)
+{
+	int err;
+
+	err = security_lsmns_allow(flags, user_ns, ns);
+	if (err)
+		return ERR_PTR(err);
+
+	if (!(flags & CLONE_NEWLSM))
+		return get_lsm_ns(ns);
+	return create_lsm_ns(user_ns, ns);
+}
+
+void free_lsm_ns(struct kref *kref)
+{
+	struct lsm_namespace *ns;
+
+	ns = container_of(kref, struct lsm_namespace, kref);
+
+	security_lsmns_free(ns);
+
+	put_user_ns(ns->user_ns);
+	proc_free_inum(ns->proc_inum);
+	kfree(ns);
+}
+
+/* proc_ns_operations hooks */
+
+static void *lsmns_get(struct task_struct *task)
+{
+	struct lsm_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy)
+		ns = get_lsm_ns(nsproxy->lsm_ns);
+	task_unlock(task);
+
+	return ns;
+}
+
+static void lsmns_put(void *ns)
+{
+	put_lsm_ns(ns);
+}
+
+static int lsmns_install(struct nsproxy *nsproxy, void *ns)
+{
+	struct lsm_namespace *new = ns;
+	int err;
+
+	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN) ||
+	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = security_lsmns_setns(nsproxy, new);
+	if (err)
+		return err;
+
+	put_lsm_ns(nsproxy->lsm_ns);
+	nsproxy->lsm_ns = get_lsm_ns(new);
+
+	return 0;
+}
+
+static unsigned int lsmns_inum(void *ns)
+{
+	struct lsm_namespace *lsm_ns = ns;
+
+	return lsm_ns->proc_inum;
+}
+
+const struct proc_ns_operations lsmns_operations = {
+	.name		= "lsm",
+	.type		= CLONE_NEWLSM,
+	.get		= lsmns_get,
+	.put		= lsmns_put,
+	.install	= lsmns_install,
+	.inum		= lsmns_inum,
+};
+
+static __init int lsm_namespaces_init(void)
+{
+	security_lsmns_init();
+
+	return 0;
+}
+subsys_initcall(lsm_namespaces_init);
diff --git a/security/security.c b/security/security.c
index e41b1a8..200365f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -25,10 +25,22 @@
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/backing-dev.h>
+#include <linux/lsm_namespace.h>
+#include <linux/proc_ns.h>
 #include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
 
+struct lsm_namespace init_lsm_ns = {
+	.kref = {
+		.refcount	= ATOMIC_INIT(1),
+	},
+	.user_ns		= &init_user_ns,
+	.proc_inum		= PROC_LSM_INIT_INO,
+	/* module specific and to be initialized in lsmns_init() */
+	.private		= NULL,
+};
+
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
@@ -1472,3 +1484,33 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 }
 
 #endif /* CONFIG_AUDIT */
+
+#ifdef CONFIG_SECURITY_NS
+
+void security_lsmns_init(void)
+{
+	security_ops->lsmns_init();
+}
+
+int security_lsmns_allow(unsigned long flags, struct user_namespace *user_ns,
+			 struct lsm_namespace *old_ns)
+{
+	return security_ops->lsmns_allow(flags, user_ns, old_ns);
+}
+
+int security_lsmns_setns(struct nsproxy *nsproxy, struct lsm_namespace *ns)
+{
+	return security_ops->lsmns_setns(nsproxy, ns);
+}
+
+int security_lsmns_create(struct lsm_namespace *ns)
+{
+	return security_ops->lsmns_create(ns);
+}
+
+void security_lsmns_free(struct lsm_namespace *ns)
+{
+	security_ops->lsmns_free(ns);
+}
+
+#endif /* CONFIG_SECURITY_NS */
-- 
1.9.3
