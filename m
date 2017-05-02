From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v5] pid_ns: Introduce ioctl to set vector of ns_last_pid's
 on ns hierarhy
Date: Tue, 2 May 2017 12:48:52 +0300
Message-ID: <149371848646.24418.16693733830230366252.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On implementing of nested pid namespaces support in CRIU
(checkpoint-restore in userspace tool) we run into
the situation, that it's impossible to create a task with
specific NSpid effectively. After commit 49f4d8b93ccf
"pidns: Capture the user namespace and filter ns_last_pid"
it is impossible to set ns_last_pid on any pid namespace,
except task's active pid_ns (before the commit it was possible
to write to pid_ns_for_children). Thus, if a restored task
in a container has more than one pid_ns levels, the restorer
code must have a task helper for every pid namespace
of the task's pid_ns hierarhy.

This is a big problem, because of communication with
a helper for every pid_ns in the hierarchy is not cheap.
It's not performance-good as it implies many helpers wakeups
to create a single task (independently, how you communicate
with the helpers). This patch tries to decide the problem.

It introduces a new pid_ns ioctl(NS_SET_LAST_PID_VEC),
which allows to write a vector of last pids on pid_ns hierarchy.
The vector is passed as array of pids in struct ns_ioc_pid_vec,
written in reverse order. The first number corresponds to
the opened namespace ns_last_pid, the second is to its parent, etc.
So, if you have the pid namespaces hierarchy like:

pid_ns1 (grand father)
  |
  v
pid_ns2 (father)
  |
  v
pid_ns3 (child)

and the pid_ns3 is open, then the corresponding vector will be
{last_ns_pid3, last_ns_pid2, last_ns_pid1}. This vector may be
short and it may contain less levels. For example,
{last_ns_pid3, last_ns_pid2} or even {last_ns_pid3}, in dependence
of which levels you want to populate.

v5: Move pid_max up for !CONFIG_CHECKPOINT_RESTORE builds
(found by kbuild test robot).

v4: Declare struct ns_ioc_pid_vec directly instead of include uapi file.
Make the interface independent of CONFIG_CHECKPOINT_RESTORE.
Include linux/types.h in nsfs.h for pid_t.
Get all vectors at once.
Make checks atomical.

v3: Use __u32 in uapi instead of unsigned int.

v2: Kill pid_ns->child_reaper check as it's impossible to have
such a pid namespace file open.
Use generic namespaces ioctl() number.
Pass pids as array, not as a string.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/nsfs.c                     |    5 +++++
 include/linux/pid_namespace.h |    9 ++++++++-
 include/uapi/linux/nsfs.h     |    8 ++++++++
 kernel/pid_namespace.c        |   38 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 323f492e0822..f669a1552003 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -6,6 +6,7 @@
 #include <linux/ktime.h>
 #include <linux/seq_file.h>
 #include <linux/user_namespace.h>
+#include <linux/pid_namespace.h>
 #include <linux/nsfs.h>
 #include <linux/uaccess.h>
 
@@ -186,6 +187,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		argp = (uid_t __user *) arg;
 		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
 		return put_user(uid, argp);
+	case NS_SET_LAST_PID_VEC:
+		if (ns->ops->type != CLONE_NEWPID)
+			return -EINVAL;
+		return pidns_set_last_pid_vec(ns, (void *)arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index c2a989dee876..661fad08bf8c 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -54,6 +54,7 @@ struct pid_namespace {
 	struct ns_common ns;
 };
 
+struct ns_ioc_pid_vec;
 extern struct pid_namespace init_pid_ns;
 
 #define PIDNS_HASH_ADDING (1U << 31)
@@ -71,7 +72,8 @@ extern struct pid_namespace *copy_pid_ns(unsigned long flags,
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
 extern void put_pid_ns(struct pid_namespace *ns);
-
+extern long pidns_set_last_pid_vec(struct ns_common *ns,
+				   struct ns_ioc_pid_vec __user *vec);
 #else /* !CONFIG_PID_NS */
 #include <linux/err.h>
 
@@ -101,6 +103,11 @@ static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 {
 	return 0;
 }
+static inline long pidns_set_last_pid_vec(struct ns_common *ns,
+					  struct ns_ioc_pid_vec __user *vec)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_PID_NS */
 
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 1a3ca79f466b..9d320276eafe 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -2,6 +2,7 @@
 #define __LINUX_NSFS_H
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 #define NSIO	0xb7
 
@@ -14,5 +15,12 @@
 #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
 /* Get owner UID (in the caller's user namespace) for a user namespace */
 #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
+/* Set a vector of ns_last_pid for a pid namespace stack */
+#define NS_SET_LAST_PID_VEC	_IO(NSIO, 0x5)
+
+struct ns_ioc_pid_vec {
+	__u32	nr;
+	pid_t	pid[0];
+};
 
 #endif /* __LINUX_NSFS_H */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index de461aa0bf9a..d675b4d22dfe 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/sched/task.h>
 #include <linux/sched/signal.h>
+#include <uapi/linux/nsfs.h>
 
 struct pid_cache {
 	int nr_ids;
@@ -32,6 +33,7 @@ struct pid_cache {
 static LIST_HEAD(pid_caches_lh);
 static DEFINE_MUTEX(pid_caches_mutex);
 static struct kmem_cache *pid_ns_cachep;
+extern int pid_max;
 
 /*
  * creates the kmem cache to allocate pids from.
@@ -311,7 +313,6 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 	return proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 }
 
-extern int pid_max;
 static int zero = 0;
 static struct ctl_table pid_ns_ctl_table[] = {
 	{
@@ -428,6 +429,41 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
 	return &get_pid_ns(pid_ns)->ns;
 }
 
+long pidns_set_last_pid_vec(struct ns_common *ns,
+			    struct ns_ioc_pid_vec __user *vec)
+{
+	struct pid_namespace *pid_ns = to_pid_ns(ns), *top;
+	pid_t pid[MAX_PID_NS_LEVEL];
+	u32 i, nr;
+
+	BUILD_BUG_ON(sizeof(pid_t) * MAX_PID_NS_LEVEL > 128);
+	if (get_user(nr, &vec->nr))
+		return -EFAULT;
+	if (nr > MAX_PID_NS_LEVEL || nr < 1)
+		return -EINVAL;
+	if (copy_from_user(pid, &vec->pid[0], nr * sizeof(pid_t)) != 0)
+		return -EFAULT;
+
+	top = pid_ns;
+	for (i = 0; i < nr-1; i++) {
+		top = top->parent;
+		if (!top || pid[i] < 0 || pid[i] > pid_max)
+			return -EINVAL;
+	}
+	if (!ns_capable(top->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (pid[nr-1] < 0 || pid[nr-1] > pid_max)
+		return -EINVAL;
+
+	for (i = 0; i < nr; i++) {
+		/* Write directly: see the comment in pid_ns_ctl_handler() */
+		pid_ns->last_pid = pid[i];
+		pid_ns = pid_ns->parent;
+	}
+
+	return 0;
+}
+
 static struct user_namespace *pidns_owner(struct ns_common *ns)
 {
 	return to_pid_ns(ns)->user_ns;
