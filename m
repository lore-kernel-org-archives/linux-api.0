From: Laurent Vivier <laurent@vivier.eu>
Subject: [RFC 1/2] ns: introduce binfmt_misc namespace
Date: Mon,  1 Oct 2018 01:46:27 +0200
Message-ID: <20180930234628.25528-2-laurent@vivier.eu>
References: <20180930234628.25528-1-laurent@vivier.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180930234628.25528-1-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@openvz.org>, containers@lists.linux-foundation.org, Laurent Vivier <laurent@vivier.eu>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Laurent Vivier <laurent@vivier.eu>
---
 fs/proc/namespaces.c             |   3 +
 include/linux/binfmt_namespace.h |  51 +++++++++++
 include/linux/nsproxy.h          |   2 +
 include/linux/proc_ns.h          |   2 +
 include/linux/user_namespace.h   |   1 +
 include/uapi/linux/sched.h       |   1 +
 init/Kconfig                     |   8 ++
 kernel/Makefile                  |   1 +
 kernel/binfmt_namespace.c        | 153 +++++++++++++++++++++++++++++++
 kernel/fork.c                    |   3 +-
 kernel/nsproxy.c                 |  18 +++-
 11 files changed, 240 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/binfmt_namespace.h
 create mode 100644 kernel/binfmt_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index dd2b35f78b09..4d86549a788f 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -33,6 +33,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_CGROUPS
 	&cgroupns_operations,
 #endif
+#ifdef CONFIG_BINFMT_NS
+	&binfmtns_operations,
+#endif
 };
 
 static const char *proc_ns_get_link(struct dentry *dentry,
diff --git a/include/linux/binfmt_namespace.h b/include/linux/binfmt_namespace.h
new file mode 100644
index 000000000000..8688869ee254
--- /dev/null
+++ b/include/linux/binfmt_namespace.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BINFMT_NAMESPACE_H
+#define _LINUX_BINFMT_NAMESPACE_H
+
+struct user_namespace;
+extern struct user_namespace init_user_ns;
+
+struct binfmt_namespace {
+	struct kref kref;
+	struct user_namespace *user_ns;
+	struct ucounts *ucounts;
+	struct ns_common ns;
+} __randomize_layout;
+extern struct binfmt_namespace init_binfmt_ns;
+
+#ifdef CONFIG_BINFMT_NS
+static inline void get_binfmt_ns(struct binfmt_namespace *ns)
+{
+	if (ns)
+		kref_get(&ns->kref);
+}
+
+extern struct binfmt_namespace *copy_binfmt_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct binfmt_namespace *old_ns);
+extern void free_binfmt_ns(struct kref *kref);
+
+static inline void put_binfmt_ns(struct binfmt_namespace *ns)
+{
+	if (ns)
+		kref_put(&ns->kref, free_binfmt_ns);
+}
+
+#else
+static inline void get_binfmt_ns(struct binfmt_namespace *ns)
+{
+}
+
+static inline void put_binfmt_ns(struct binfmt_namespace *ns)
+{
+}
+
+static inline struct binfmt_namespace *copy_binfmt_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct binfmt_namespace *old_ns)
+{
+	if (flags & CLONE_NEWBINFMT)
+		return ERR_PTR(-EINVAL);
+
+	return old_ns;
+}
+#endif
+#endif /* _LINUX_BINFMT_NAMESPACE_H */
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 2ae1b1a4d84d..8d2294477095 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -10,6 +10,7 @@ struct uts_namespace;
 struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
+struct binfmt_namespace;
 struct fs_struct;
 
 /*
@@ -36,6 +37,7 @@ struct nsproxy {
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
 	struct cgroup_namespace *cgroup_ns;
+	struct binfmt_namespace *binfmt_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index d31cb6215905..6afa2dbc5204 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -32,6 +32,7 @@ extern const struct proc_ns_operations pidns_for_children_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
 extern const struct proc_ns_operations cgroupns_operations;
+extern const struct proc_ns_operations binfmtns_operations;
 
 /*
  * We always define these enumerators
@@ -43,6 +44,7 @@ enum {
 	PROC_USER_INIT_INO	= 0xEFFFFFFDU,
 	PROC_PID_INIT_INO	= 0xEFFFFFFCU,
 	PROC_CGROUP_INIT_INO	= 0xEFFFFFFBU,
+	PROC_BINFMT_INIT_INO	= 0xEFFFFFFAU,
 };
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index d6b74b91096b..81365a22362c 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -45,6 +45,7 @@ enum ucount_type {
 	UCOUNT_NET_NAMESPACES,
 	UCOUNT_MNT_NAMESPACES,
 	UCOUNT_CGROUP_NAMESPACES,
+	UCOUNT_BINFMT_NAMESPACES,
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_INOTIFY_INSTANCES,
 	UCOUNT_INOTIFY_WATCHES,
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..51fe40681e8e 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -10,6 +10,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_NEWBINFMT	0x00001000	/* New binfmt_misc namespace */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/init/Kconfig b/init/Kconfig
index 1e234e2f1cba..4874719a2799 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -965,6 +965,14 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+config BINFMT_NS
+	bool "binfmt_misc Namespace"
+	depends on BINFMT_MISC
+	default y
+	help
+	  This allows to use several binfmt_misc configurations on
+	  the same system.
+
 endif # NAMESPACES
 
 config CHECKPOINT_RESTORE
diff --git a/kernel/Makefile b/kernel/Makefile
index 7a63d567fdb5..313c80f5883f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_CGROUPS) += cgroup/
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
+obj-$(CONFIG_BINFMT_NS) += binfmt_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
diff --git a/kernel/binfmt_namespace.c b/kernel/binfmt_namespace.c
new file mode 100644
index 000000000000..63a80bcd70df
--- /dev/null
+++ b/kernel/binfmt_namespace.c
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/slab.h>
+#include <linux/user_namespace.h>
+#include <linux/cred.h>
+#include <linux/binfmt_namespace.h>
+#include <linux/proc_ns.h>
+#include <linux/sched/task.h>
+
+static struct ucounts *inc_binfmt_namespaces(struct user_namespace *ns)
+{
+	return inc_ucount(ns, current_euid(), UCOUNT_BINFMT_NAMESPACES);
+}
+
+static void dec_binfmt_namespaces(struct ucounts *ucounts)
+{
+	dec_ucount(ucounts, UCOUNT_BINFMT_NAMESPACES);
+}
+
+static struct binfmt_namespace *create_binfmt_ns(void)
+{
+	struct binfmt_namespace *binfmt_ns;
+
+	binfmt_ns = kmalloc(sizeof(struct binfmt_namespace), GFP_KERNEL);
+	if (binfmt_ns)
+		kref_init(&binfmt_ns->kref);
+	return binfmt_ns;
+}
+
+static struct binfmt_namespace *clone_binfmt_ns(struct user_namespace *user_ns,
+					       struct binfmt_namespace *old_ns)
+{
+	struct binfmt_namespace *ns;
+	struct ucounts *ucounts;
+	int err;
+
+	err = -ENOSPC;
+	ucounts = inc_binfmt_namespaces(user_ns);
+	if (!ucounts)
+		goto fail;
+
+	err = -ENOMEM;
+	ns = create_binfmt_ns();
+	if (!ns)
+		goto fail_dec;
+
+	err = ns_alloc_inum(&ns->ns);
+	if (err)
+		goto fail_free;
+
+	ns->ucounts = ucounts;
+	ns->ns.ops = &binfmtns_operations;
+	ns->user_ns = get_user_ns(user_ns);
+	return ns;
+
+fail_free:
+	kfree(ns);
+fail_dec:
+	dec_binfmt_namespaces(ucounts);
+fail:
+	return ERR_PTR(err);
+}
+
+struct binfmt_namespace *copy_binfmt_ns(unsigned long flags,
+		struct user_namespace *user_ns, struct binfmt_namespace *old_ns)
+{
+	if (!(flags & CLONE_NEWBINFMT)) {
+		get_binfmt_ns(old_ns);
+		return old_ns;
+	}
+
+	return clone_binfmt_ns(user_ns, old_ns);
+}
+
+void free_binfmt_ns(struct kref *kref)
+{
+	struct binfmt_namespace *ns;
+
+	ns = container_of(kref, struct binfmt_namespace, kref);
+	dec_binfmt_namespaces(ns->ucounts);
+	put_user_ns(ns->user_ns);
+	ns_free_inum(&ns->ns);
+	kfree(ns);
+}
+
+static inline struct binfmt_namespace *to_binfmt_ns(struct ns_common *ns)
+{
+	return container_of(ns, struct binfmt_namespace, ns);
+}
+
+static struct ns_common *binfmtns_get(struct task_struct *task)
+{
+	struct binfmt_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy) {
+		ns = nsproxy->binfmt_ns;
+		get_binfmt_ns(ns);
+	}
+	task_unlock(task);
+
+	return ns ? &ns->ns : NULL;
+}
+
+static void binfmtns_put(struct ns_common *ns)
+{
+	put_binfmt_ns(to_binfmt_ns(ns));
+}
+
+static int binfmtns_install(struct nsproxy *nsproxy, struct ns_common *new)
+{
+	struct binfmt_namespace *ns = to_binfmt_ns(new);
+
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+		return -EPERM;
+
+	get_binfmt_ns(ns);
+	put_binfmt_ns(nsproxy->binfmt_ns);
+	nsproxy->binfmt_ns = ns;
+	return 0;
+}
+
+static struct user_namespace *binfmtns_owner(struct ns_common *ns)
+{
+	return to_binfmt_ns(ns)->user_ns;
+}
+
+const struct proc_ns_operations binfmtns_operations = {
+	.name		= "binfmt_misc",
+	.type		= CLONE_NEWBINFMT,
+	.get		= binfmtns_get,
+	.put		= binfmtns_put,
+	.install	= binfmtns_install,
+	.owner		= binfmtns_owner,
+};
+
+struct binfmt_namespace init_binfmt_ns = {
+	.kref = KREF_INIT(2),
+	.user_ns = &init_user_ns,
+	.ns.inum = PROC_BINFMT_INIT_INO,
+#ifdef CONFIG_BINFMT_NS
+	.ns.ops = &binfmtns_operations,
+#endif
+};
+
+static int __init binfmt_ns_init(void)
+{
+	return 0;
+}
+subsys_initcall(binfmt_ns_init);
diff --git a/kernel/fork.c b/kernel/fork.c
index f0b58479534f..d89cf8b89e43 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2365,7 +2365,8 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP|
+				CLONE_NEWBINFMT))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f6c5d330059a..386028e6da39 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/binfmt_namespace.h>
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
@@ -44,6 +45,9 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_CGROUPS
 	.cgroup_ns		= &init_cgroup_ns,
 #endif
+#if IS_ENABLED(BINFMT_MISC)
+	.binfmt_ns		= &init_binfmt_ns,
+#endif
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -110,6 +114,13 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_net;
 	}
 
+	new_nsp->binfmt_ns = copy_binfmt_ns(flags, user_ns,
+					    tsk->nsproxy->binfmt_ns);
+	if (IS_ERR(new_nsp->binfmt_ns)) {
+		err = PTR_ERR(new_nsp->binfmt_ns);
+		goto out_net;
+	}
+
 	return new_nsp;
 
 out_net:
@@ -143,7 +154,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 			      CLONE_NEWPID | CLONE_NEWNET |
-			      CLONE_NEWCGROUP)))) {
+			      CLONE_NEWCGROUP | CLONE_NEWBINFMT)))) {
 		get_nsproxy(old_ns);
 		return 0;
 	}
@@ -180,6 +191,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
+	if (ns->binfmt_ns)
+		put_binfmt_ns(ns->binfmt_ns);
 	put_cgroup_ns(ns->cgroup_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
@@ -196,7 +209,8 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP |
+			       CLONE_NEWBINFMT)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
-- 
2.17.1
