From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/24] kernel: add a netlink interface to get information about tasks (v2)
Date: Mon,  6 Jul 2015 11:47:03 +0300
Message-ID: <1436172445-6979-3-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

task_diag is based on netlink sockets and looks like socket-diag, which
is used to get information about sockets.

task_diag is a new interface which is going to raplace the proc file
system in cases when we need to get information in a binary format.

A request messages is described by the task_diag_pid structure:
struct task_diag_pid {
       __u64   show_flags;
       __u64   dump_strategy;

       __u32   pid;
};

A respone is a set of netlink messages. Each message describes one task.
All task properties are divided on groups. A message contains the
TASK_DIAG_PID group, and other groups if they have been requested in
show_flags. For example, if show_flags contains TASK_DIAG_SHOW_BASE, a
response will contain the TASK_DIAG_CRED group which is described by the
task_diag_creds structure.

struct task_diag_base {
	__u32	tgid;
	__u32	pid;
	__u32	ppid;
	__u32	tpid;
	__u32	sid;
	__u32	pgid;
	__u8	state;
	char	comm[TASK_DIAG_COMM_LEN];
};

The dump_strategy field will be used in following patches to request
information for a group of processes.

v2: A few changes from David Ahern
    Use a consistent name
    Add max attr enum
    task diag: Send pid as u32
    Change _MSG/msg references to base
    Fix 8-byte alignment

Cc: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/linux/taskstats_kern.h |   7 ++
 include/uapi/linux/task_diag.h |  60 +++++++++++++++
 include/uapi/linux/taskstats.h |   2 +
 init/Kconfig                   |  12 +++
 kernel/Makefile                |   1 +
 kernel/taskdiag.c              | 168 +++++++++++++++++++++++++++++++++++++++++
 kernel/taskstats.c             |  25 +++++-
 7 files changed, 271 insertions(+), 4 deletions(-)
 create mode 100644 include/uapi/linux/task_diag.h
 create mode 100644 kernel/taskdiag.c

diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index 58de6ed..a1fd4f8 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -15,6 +15,8 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
+extern struct genl_family taskstats_family;
+
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -23,6 +25,11 @@ static inline void taskstats_tgid_free(struct signal_struct *sig)
 
 extern void taskstats_exit(struct task_struct *, int group_dead);
 extern void taskstats_init_early(void);
+
+struct genl_info;
+struct sk_buff;
+int taskdiag_doit(struct sk_buff *skb, struct genl_info *info);
+
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
new file mode 100644
index 0000000..3a1e6c4
--- /dev/null
+++ b/include/uapi/linux/task_diag.h
@@ -0,0 +1,60 @@
+#ifndef _LINUX_TASK_DIAG_H
+#define _LINUX_TASK_DIAG_H
+
+#include <linux/types.h>
+#include <linux/capability.h>
+
+enum {
+	/* optional attributes which can be specified in show_flags */
+	TASK_DIAG_BASE	= 0,
+
+	/* other attributes */
+	TASK_DIAG_PID	= 64,	/* u32 */
+
+	__TASK_DIAG_ATTR_MAX
+#define TASK_DIAG_ATTR_MAX (__TASK_DIAG_ATTR_MAX - 1)
+};
+
+#define TASK_DIAG_SHOW_BASE	(1ULL << TASK_DIAG_BASE)
+
+enum {
+	TASK_DIAG_RUNNING,
+	TASK_DIAG_INTERRUPTIBLE,
+	TASK_DIAG_UNINTERRUPTIBLE,
+	TASK_DIAG_STOPPED,
+	TASK_DIAG_TRACE_STOP,
+	TASK_DIAG_DEAD,
+	TASK_DIAG_ZOMBIE,
+};
+
+#define TASK_DIAG_COMM_LEN 16
+
+struct task_diag_base {
+	__u32	tgid;
+	__u32	pid;
+	__u32	ppid;
+	__u32	tpid;
+	__u32	sid;
+	__u32	pgid;
+	__u8	state;
+	char	comm[TASK_DIAG_COMM_LEN];
+};
+
+#define TASK_DIAG_DUMP_ALL	0
+
+struct task_diag_pid {
+	__u64	show_flags;
+	__u64	dump_strategy;
+
+	__u32	pid;
+};
+
+enum {
+	TASK_DIAG_CMD_ATTR_UNSPEC = 0,
+	TASK_DIAG_CMD_ATTR_GET,
+	__TASK_DIAG_CMD_ATTR_MAX,
+};
+
+#define TASK_DIAG_CMD_ATTR_MAX (__TASK_DIAG_CMD_ATTR_MAX - 1)
+
+#endif /* _LINUX_TASK_DIAG_H */
diff --git a/include/uapi/linux/taskstats.h b/include/uapi/linux/taskstats.h
index a1cc91b..04b974a 100644
--- a/include/uapi/linux/taskstats.h
+++ b/include/uapi/linux/taskstats.h
@@ -181,6 +181,8 @@ enum {
 	CGROUPSTATS_CMD_GET,		/* user->kernel request/get-response */
 	CGROUPSTATS_CMD_NEW,		/* kernel->user event */
 
+	TASK_DIAG_CMD_GET,
+
 	__TASKSTATS_CMD_MAX,
 };
 
diff --git a/init/Kconfig b/init/Kconfig
index 7d1ffd2..4d0483c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -432,6 +432,18 @@ config TASKSTATS
 
 	  Say N if unsure.
 
+config TASK_DIAG
+	bool "Export task/process properties through netlink"
+	depends on NET && TASKSTATS
+	default n
+	help
+	  Export selected properties for tasks/processes through the
+	  generic netlink interface. Unlike the proc file system, task_diag
+	  returns information in a binary format, allows to specify which
+	  information are required.
+
+	  Say N if unsure.
+
 config TASK_DELAY_ACCT
 	bool "Enable per-task delay accounting"
 	depends on TASKSTATS
diff --git a/kernel/Makefile b/kernel/Makefile
index 60c302c..ed6fed5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_TASK_DIAG) += taskdiag.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
new file mode 100644
index 0000000..7327e08
--- /dev/null
+++ b/kernel/taskdiag.c
@@ -0,0 +1,168 @@
+#include <linux/kernel.h>
+#include <linux/taskstats_kern.h>
+#include <linux/task_diag.h>
+#include <net/genetlink.h>
+#include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+
+static size_t taskdiag_packet_size(u64 show_flags)
+{
+	size_t size;
+
+	size = nla_total_size(sizeof(u32)); /* PID */
+
+	if (show_flags & TASK_DIAG_SHOW_BASE)
+		size += nla_total_size(sizeof(struct task_diag_base));
+
+	return size;
+}
+
+/*
+ * The task state array is a strange "bitmap" of
+ * reasons to sleep. Thus "running" is zero, and
+ * you can test for combinations of others with
+ * simple bit tests.
+ */
+static const __u8 task_state_array[] = {
+	TASK_DIAG_RUNNING,
+	TASK_DIAG_INTERRUPTIBLE,
+	TASK_DIAG_UNINTERRUPTIBLE,
+	TASK_DIAG_STOPPED,
+	TASK_DIAG_TRACE_STOP,
+	TASK_DIAG_DEAD,
+	TASK_DIAG_ZOMBIE,
+};
+
+static inline const __u8 get_task_state(struct task_struct *tsk)
+{
+	unsigned int state = (tsk->state | tsk->exit_state) & TASK_REPORT;
+
+	BUILD_BUG_ON(1 + ilog2(TASK_REPORT) != ARRAY_SIZE(task_state_array)-1);
+
+	return task_state_array[fls(state)];
+}
+
+static int fill_task_base(struct task_struct *p, struct sk_buff *skb)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct task_diag_base *base;
+	struct nlattr *attr;
+	char tcomm[sizeof(p->comm)];
+	struct task_struct *tracer;
+
+	attr = nla_reserve(skb, TASK_DIAG_BASE, sizeof(struct task_diag_base));
+	if (!attr)
+		return -EMSGSIZE;
+
+	base = nla_data(attr);
+
+	rcu_read_lock();
+	base->ppid = pid_alive(p) ?
+		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
+
+	base->tpid = 0;
+	tracer = ptrace_parent(p);
+	if (tracer)
+		base->tpid = task_pid_nr_ns(tracer, ns);
+
+	base->tgid = task_tgid_nr_ns(p, ns);
+	base->pid = task_pid_nr_ns(p, ns);
+	base->sid = task_session_nr_ns(p, ns);
+	base->pgid = task_pgrp_nr_ns(p, ns);
+
+	rcu_read_unlock();
+
+	get_task_comm(tcomm, p);
+	memset(base->comm, 0, TASK_DIAG_COMM_LEN);
+	strncpy(base->comm, tcomm, TASK_DIAG_COMM_LEN);
+
+	base->state = get_task_state(p);
+
+	return 0;
+}
+
+static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
+				u64 show_flags, u32 portid, u32 seq)
+{
+	void *reply;
+	int err;
+	u32 pid;
+
+	reply = genlmsg_put(skb, portid, seq, &taskstats_family, 0, TASK_DIAG_CMD_GET);
+	if (reply == NULL)
+		return -EMSGSIZE;
+
+	pid = task_pid_vnr(tsk);
+	err = nla_put_u32(skb, TASK_DIAG_PID, pid);
+	if (err)
+		goto err;
+
+	if (show_flags & TASK_DIAG_SHOW_BASE) {
+		err = fill_task_base(tsk, skb);
+		if (err)
+			goto err;
+	}
+
+	genlmsg_end(skb, reply);
+	return 0;
+err:
+	genlmsg_cancel(skb, reply);
+	return err;
+}
+
+int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *nla = info->attrs[TASK_DIAG_CMD_ATTR_GET];
+	struct task_struct *tsk = NULL;
+	struct task_diag_pid req;
+	struct sk_buff *msg;
+	size_t size;
+	int rc;
+
+	if (!nla_data(nla))
+		return -EINVAL;
+
+	if (nla_len(nla) < sizeof(req))
+		return -EINVAL;
+
+	/*
+	 * use a req variable to deal with alignment issues. task_diag_pid
+	 * contains u64 elements which means extended load operations can be
+	 * used and those can require 8-byte alignment (e.g., sparc)
+	 */
+	memcpy(&req, nla_data(nla), sizeof(req));
+
+	size = taskdiag_packet_size(req.show_flags);
+	msg = genlmsg_new(size, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	tsk = find_task_by_vpid(req.pid);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	if (!tsk) {
+		rc = -ESRCH;
+		goto err;
+	};
+
+	if (!ptrace_may_access(tsk, PTRACE_MODE_READ)) {
+		put_task_struct(tsk);
+		rc = -EPERM;
+		goto err;
+	}
+
+	rc = task_diag_fill(tsk, msg, req.show_flags,
+				info->snd_portid, info->snd_seq);
+	put_task_struct(tsk);
+	if (rc < 0)
+		goto err;
+
+	return genlmsg_reply(msg, info);
+err:
+	nlmsg_free(msg);
+	return rc;
+}
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 21f82c2..d70f1e5 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/taskstats_kern.h>
+#include <linux/task_diag.h>
 #include <linux/tsacct_kern.h>
 #include <linux/delayacct.h>
 #include <linux/cpumask.h>
@@ -41,7 +42,7 @@ static DEFINE_PER_CPU(__u32, taskstats_seqnum);
 static int family_registered;
 struct kmem_cache *taskstats_cache;
 
-static struct genl_family family = {
+struct genl_family taskstats_family = {
 	.id		= GENL_ID_GENERATE,
 	.name		= TASKSTATS_GENL_NAME,
 	.version	= TASKSTATS_GENL_VERSION,
@@ -92,9 +93,9 @@ static int prepare_reply(struct genl_info *info, u8 cmd, struct sk_buff **skbp,
 	if (!info) {
 		int seq = this_cpu_inc_return(taskstats_seqnum) - 1;
 
-		reply = genlmsg_put(skb, 0, seq, &family, 0, cmd);
+		reply = genlmsg_put(skb, 0, seq, &taskstats_family, 0, cmd);
 	} else
-		reply = genlmsg_put_reply(skb, info, &family, 0, cmd);
+		reply = genlmsg_put_reply(skb, info, &taskstats_family, 0, cmd);
 	if (reply == NULL) {
 		nlmsg_free(skb);
 		return -EINVAL;
@@ -664,6 +665,15 @@ err:
 	nlmsg_free(rep_skb);
 }
 
+#ifdef CONFIG_TASK_DIAG
+static const struct nla_policy
+			taskdiag_cmd_get_policy[TASK_DIAG_CMD_ATTR_MAX+1] = {
+	[TASK_DIAG_CMD_ATTR_GET]  = {	.type = NLA_UNSPEC,
+					.len = sizeof(struct task_diag_pid)
+				},
+};
+#endif
+
 static const struct genl_ops taskstats_ops[] = {
 	{
 		.cmd		= TASKSTATS_CMD_GET,
@@ -676,6 +686,13 @@ static const struct genl_ops taskstats_ops[] = {
 		.doit		= cgroupstats_user_cmd,
 		.policy		= cgroupstats_cmd_get_policy,
 	},
+#ifdef CONFIG_TASK_DIAG
+	{
+		.cmd		= TASK_DIAG_CMD_GET,
+		.doit		= taskdiag_doit,
+		.policy		= taskdiag_cmd_get_policy,
+	},
+#endif
 };
 
 /* Needed early in initialization */
@@ -694,7 +711,7 @@ static int __init taskstats_init(void)
 {
 	int rc;
 
-	rc = genl_register_family_with_ops(&family, taskstats_ops);
+	rc = genl_register_family_with_ops(&taskstats_family, taskstats_ops);
 	if (rc)
 		return rc;
 
-- 
2.1.0
