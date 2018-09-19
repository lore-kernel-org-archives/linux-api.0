From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 01/20] ns: Introduce Time Namespace
Date: Wed, 19 Sep 2018 21:50:18 +0100
Message-ID: <20180919205037.9574-2-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@openvz.org>

Time Namespace isolates clock values.

The kernel provides access to several clocks CLOCK_REALTIME,
CLOCK_MONOTONIC, CLOCK_BOOTTIME, etc.

CLOCK_REALTIME
      System-wide  clock  that  measures real (i.e., wall-clock) time.

CLOCK_MONOTONIC
      Clock that cannot be set and represents monotonic time since
      some  unspecified starting point.

CLOCK_BOOTTIME
      Identical  to  CLOCK_MONOTONIC, except it also includes any time
      that the system is suspended.

For many users, the time namespace means the ability to changes time in
a container (CLOCK_REALTIME).

But in a context of the checkpoint/restore functionality, monotonic and
bootime clocks become interesting. Both clocks are monotonic with
unspecified staring points. These clocks are widely used to measure time
slices, set timers. After restoring or migrating processes, we have to
guarantee that they never go backward. In an ideal case, the behavior of
these clocks should be the same as for a case when a whole system is
suspended. All this means that we need to be able to set CLOCK_MONOTONIC
and CLOCK_BOOTTIME clocks, what can be done by adding per-namespace
offsets for clocks.

Link: https://criu.org/Time_namespace
Link: https://lists.openvz.org/pipermail/criu/2018-June/041504.html
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 fs/proc/namespaces.c           |   3 +
 include/linux/nsproxy.h        |   1 +
 include/linux/proc_ns.h        |   1 +
 include/linux/time_namespace.h |  59 ++++++++++++++
 include/linux/user_namespace.h |   1 +
 include/uapi/linux/sched.h     |   1 +
 init/Kconfig                   |   7 ++
 kernel/Makefile                |   1 +
 kernel/fork.c                  |   3 +-
 kernel/nsproxy.c               |  19 ++++-
 kernel/time_namespace.c        | 169 +++++++++++++++++++++++++++++++++++++++++
 11 files changed, 262 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/time_namespace.h
 create mode 100644 kernel/time_namespace.c

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index dd2b35f78b09..faee2facb4f3 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -33,6 +33,9 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_CGROUPS
 	&cgroupns_operations,
 #endif
+#ifdef CONFIG_TIME_NS
+	&timens_operations,
+#endif
 };
 
 static const char *proc_ns_get_link(struct dentry *dentry,
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 2ae1b1a4d84d..5355229c0ce7 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -35,6 +35,7 @@ struct nsproxy {
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
+	struct time_namespace *time_ns;
 	struct cgroup_namespace *cgroup_ns;
 };
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index d31cb6215905..b97b802ab04d 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -32,6 +32,7 @@ extern const struct proc_ns_operations pidns_for_children_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
 extern const struct proc_ns_operations cgroupns_operations;
+extern const struct proc_ns_operations timens_operations;
 
 /*
  * We always define these enumerators
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
new file mode 100644
index 000000000000..bf98f35efe07
--- /dev/null
+++ b/include/linux/time_namespace.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TIMENS_H
+#define _LINUX_TIMENS_H
+
+
+#include <linux/sched.h>
+#include <linux/kref.h>
+#include <linux/nsproxy.h>
+#include <linux/ns_common.h>
+#include <linux/err.h>
+
+struct user_namespace;
+extern struct user_namespace init_user_ns;
+
+struct time_namespace {
+	struct kref kref;
+	struct user_namespace *user_ns;
+	struct ucounts *ucounts;
+	struct ns_common ns;
+} __randomize_layout;
+extern struct time_namespace init_time_ns;
+
+#ifdef CONFIG_TIME_NS
+static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
+{
+	kref_get(&ns->kref);
+	return ns;
+}
+
+extern struct time_namespace *copy_time_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct time_namespace *old_ns);
+extern void free_time_ns(struct kref *kref);
+
+static inline void put_time_ns(struct time_namespace *ns)
+{
+	kref_put(&ns->kref, free_time_ns);
+}
+
+#else
+static inline void get_time_ns(struct time_namespace *ns)
+{
+}
+
+static inline void put_time_ns(struct time_namespace *ns)
+{
+}
+
+static inline struct time_namespace *copy_time_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct time_namespace *old_ns)
+{
+	if (flags & CLONE_NEWTIME)
+		return ERR_PTR(-EINVAL);
+
+	return old_ns;
+}
+
+#endif
+
+#endif /* _LINUX_TIMENS_H */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index d6b74b91096b..bf84f93dc411 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -45,6 +45,7 @@ enum ucount_type {
 	UCOUNT_NET_NAMESPACES,
 	UCOUNT_MNT_NAMESPACES,
 	UCOUNT_CGROUP_NAMESPACES,
+	UCOUNT_TIME_NAMESPACES,
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_INOTIFY_INSTANCES,
 	UCOUNT_INOTIFY_WATCHES,
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..adffac53c76e 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -10,6 +10,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_NEWTIME	0x00001000	/* New time namespace */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/init/Kconfig b/init/Kconfig
index 1e234e2f1cba..dc2b40f7d73f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,6 +927,13 @@ config UTS_NS
 	  In this namespace tasks see different info provided with the
 	  uname() system call
 
+config TIME_NS
+	bool "TIME namespace"
+	default y
+	help
+	  In this namespace boottime and monotonic clocks can be set.
+	  The time will keep going with the same pace.
+
 config IPC_NS
 	bool "IPC namespace"
 	depends on (SYSVIPC || POSIX_MQUEUE)
diff --git a/kernel/Makefile b/kernel/Makefile
index 7a63d567fdb5..bc92feb6987d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
 obj-$(CONFIG_UTS_NS) += utsname.o
+obj-$(CONFIG_TIME_NS) += time_namespace.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
diff --git a/kernel/fork.c b/kernel/fork.c
index f0b58479534f..384f88912b63 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2365,7 +2365,8 @@ static int check_unshare_flags(unsigned long unshare_flags)
 	if (unshare_flags & ~(CLONE_THREAD|CLONE_FS|CLONE_NEWNS|CLONE_SIGHAND|
 				CLONE_VM|CLONE_FILES|CLONE_SYSVSEM|
 				CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWNET|
-				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP))
+				CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWCGROUP|
+				CLONE_NEWTIME))
 		return -EINVAL;
 	/*
 	 * Not implemented, but pretend it works if there is nothing
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f6c5d330059a..5e482e538365 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/time_namespace.h>
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
@@ -44,6 +45,9 @@ struct nsproxy init_nsproxy = {
 #ifdef CONFIG_CGROUPS
 	.cgroup_ns		= &init_cgroup_ns,
 #endif
+#ifdef CONFIG_TIME_NS
+	.time_ns		= &init_time_ns,
+#endif
 };
 
 static inline struct nsproxy *create_nsproxy(void)
@@ -110,8 +114,16 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_net;
 	}
 
+	new_nsp->time_ns = copy_time_ns(flags, user_ns, tsk->nsproxy->time_ns);
+	if (IS_ERR(new_nsp->time_ns)) {
+		err = PTR_ERR(new_nsp->time_ns);
+		goto out_time;
+	}
+
 	return new_nsp;
 
+out_time:
+	put_net(new_nsp->net_ns);
 out_net:
 	put_cgroup_ns(new_nsp->cgroup_ns);
 out_cgroup:
@@ -143,7 +155,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 			      CLONE_NEWPID | CLONE_NEWNET |
-			      CLONE_NEWCGROUP)))) {
+			      CLONE_NEWCGROUP | CLONE_NEWTIME)))) {
 		get_nsproxy(old_ns);
 		return 0;
 	}
@@ -180,6 +192,8 @@ void free_nsproxy(struct nsproxy *ns)
 		put_ipc_ns(ns->ipc_ns);
 	if (ns->pid_ns_for_children)
 		put_pid_ns(ns->pid_ns_for_children);
+	if (ns->time_ns)
+		put_time_ns(ns->time_ns);
 	put_cgroup_ns(ns->cgroup_ns);
 	put_net(ns->net_ns);
 	kmem_cache_free(nsproxy_cachep, ns);
@@ -196,7 +210,8 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
-			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP)))
+			       CLONE_NEWNET | CLONE_NEWPID | CLONE_NEWCGROUP |
+			       CLONE_NEWTIME)))
 		return 0;
 
 	user_ns = new_cred ? new_cred->user_ns : current_user_ns();
diff --git a/kernel/time_namespace.c b/kernel/time_namespace.c
new file mode 100644
index 000000000000..902cd9c22159
--- /dev/null
+++ b/kernel/time_namespace.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: Andrei Vagin <avagin@openvz.org>
+ * Author: Dmitry Safonov <dima@arista.com>
+ */
+
+#include <linux/export.h>
+#include <linux/time.h>
+#include <linux/time_namespace.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/cred.h>
+#include <linux/user_namespace.h>
+#include <linux/proc_ns.h>
+#include <linux/sched/task.h>
+
+static struct ucounts *inc_time_namespaces(struct user_namespace *ns)
+{
+	return inc_ucount(ns, current_euid(), UCOUNT_TIME_NAMESPACES);
+}
+
+static void dec_time_namespaces(struct ucounts *ucounts)
+{
+	dec_ucount(ucounts, UCOUNT_TIME_NAMESPACES);
+}
+
+static struct time_namespace *create_time_ns(void)
+{
+	struct time_namespace *time_ns;
+
+	time_ns = kmalloc(sizeof(struct time_namespace), GFP_KERNEL);
+	if (time_ns)
+		kref_init(&time_ns->kref);
+	return time_ns;
+}
+
+/*
+ * Clone a new ns copying an original timename, setting refcount to 1
+ * @old_ns: namespace to clone
+ * Return ERR_PTR(-ENOMEM) on error (failure to allocate), new ns otherwise
+ */
+static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
+					  struct time_namespace *old_ns)
+{
+	struct time_namespace *ns;
+	struct ucounts *ucounts;
+	int err;
+
+	err = -ENOSPC;
+	ucounts = inc_time_namespaces(user_ns);
+	if (!ucounts)
+		goto fail;
+
+	err = -ENOMEM;
+	ns = create_time_ns();
+	if (!ns)
+		goto fail_dec;
+
+	err = ns_alloc_inum(&ns->ns);
+	if (err)
+		goto fail_free;
+
+	ns->ucounts = ucounts;
+	ns->ns.ops = &timens_operations;
+	ns->user_ns = get_user_ns(user_ns);
+	return ns;
+
+fail_free:
+	kfree(ns);
+fail_dec:
+	dec_time_namespaces(ucounts);
+fail:
+	return ERR_PTR(err);
+}
+
+/*
+ * Copy task tsk's time namespace, or clone it if flags
+ * specifies CLONE_NEWTIME.  In latter case, changes to the
+ * timename of this process won't be seen by parent, and vice
+ * versa.
+ */
+struct time_namespace *copy_time_ns(unsigned long flags,
+	struct user_namespace *user_ns, struct time_namespace *old_ns)
+{
+	if (!(flags & CLONE_NEWTIME))
+		return get_time_ns(old_ns);
+
+	return clone_time_ns(user_ns, old_ns);
+}
+
+void free_time_ns(struct kref *kref)
+{
+	struct time_namespace *ns;
+
+	ns = container_of(kref, struct time_namespace, kref);
+	dec_time_namespaces(ns->ucounts);
+	put_user_ns(ns->user_ns);
+	ns_free_inum(&ns->ns);
+	kfree(ns);
+}
+
+static inline struct time_namespace *to_time_ns(struct ns_common *ns)
+{
+	return container_of(ns, struct time_namespace, ns);
+}
+
+static struct ns_common *timens_get(struct task_struct *task)
+{
+	struct time_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy) {
+		ns = nsproxy->time_ns;
+		get_time_ns(ns);
+	}
+	task_unlock(task);
+
+	return ns ? &ns->ns : NULL;
+}
+
+static void timens_put(struct ns_common *ns)
+{
+	put_time_ns(to_time_ns(ns));
+}
+
+static int timens_install(struct nsproxy *nsproxy, struct ns_common *new)
+{
+	struct time_namespace *ns = to_time_ns(new);
+
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
+		return -EPERM;
+
+	get_time_ns(ns);
+	put_time_ns(nsproxy->time_ns);
+	nsproxy->time_ns = ns;
+	return 0;
+}
+
+static struct user_namespace *timens_owner(struct ns_common *ns)
+{
+	return to_time_ns(ns)->user_ns;
+}
+
+const struct proc_ns_operations timens_operations = {
+	.name		= "time",
+	.type		= CLONE_NEWTIME,
+	.get		= timens_get,
+	.put		= timens_put,
+	.install	= timens_install,
+	.owner		= timens_owner,
+};
+
+struct time_namespace init_time_ns = {
+	.kref = KREF_INIT(2),
+	.user_ns = &init_user_ns,
+	.ns.inum = PROC_UTS_INIT_INO,
+#ifdef CONFIG_UTS_NS
+	.ns.ops = &timens_operations,
+#endif
+};
+
+static int __init time_ns_init(void)
+{
+	return 0;
+}
+subsys_initcall(time_ns_init);
-- 
2.13.6
