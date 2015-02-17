From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] kernel: add a netlink interface to get information about tasks
Date: Tue, 17 Feb 2015 11:20:20 +0300
Message-ID: <1424161226-15176-2-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

task_diag is based on netlink sockets and looks like socket-diag, which
is used to get information about sockets.

task_diag is a new interface which is going to raplace the proc file
system in cases when we need to get information in a binary format.

A request messages is described by the task_diag_pid structure:
struct task_diag_pid {
       __u64   show_flags;
       __u64   dump_stratagy;

       __u32   pid;
};

A respone is a set of netlink messages. Each message describes one task.
All task properties are divided on groups. A message contains the
TASK_DIAG_MSG group, and other groups if they have been requested in
show_flags. For example, if show_flags contains TASK_DIAG_SHOW_CRED, a
response will contain the TASK_DIAG_CRED group which is described by the
task_diag_creds structure.

struct task_diag_msg {
	__u32	tgid;
	__u32	pid;
	__u32	ppid;
	__u32	tpid;
	__u32	sid;
	__u32	pgid;
	__u8	state;
	char	comm[TASK_DIAG_COMM_LEN];
};

The dump_stratagy field will be used in following patches to request
information for a group of processes.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/taskdiag.h |  64 +++++++++++++++
 init/Kconfig                  |  12 +++
 kernel/Makefile               |   1 +
 kernel/taskdiag.c             | 179 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 256 insertions(+)
 create mode 100644 include/uapi/linux/taskdiag.h
 create mode 100644 kernel/taskdiag.c

diff --git a/include/uapi/linux/taskdiag.h b/include/uapi/linux/taskdiag.h
new file mode 100644
index 0000000..e1feb35
--- /dev/null
+++ b/include/uapi/linux/taskdiag.h
@@ -0,0 +1,64 @@
+#ifndef _LINUX_TASKDIAG_H
+#define _LINUX_TASKDIAG_H
+
+#include <linux/types.h>
+#include <linux/capability.h>
+
+#define TASKDIAG_GENL_NAME	"TASKDIAG"
+#define TASKDIAG_GENL_VERSION	0x1
+
+enum {
+	/* optional attributes which can be specified in show_flags */
+
+	/* other attributes */
+	TASK_DIAG_MSG = 64,
+};
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
+struct task_diag_msg {
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
+enum {
+	TASKDIAG_CMD_UNSPEC = 0,	/* Reserved */
+	TASKDIAG_CMD_GET,
+	__TASKDIAG_CMD_MAX,
+};
+#define TASKDIAG_CMD_MAX (__TASKDIAG_CMD_MAX - 1)
+
+#define TASK_DIAG_DUMP_ALL	0
+
+struct task_diag_pid {
+	__u64	show_flags;
+	__u64	dump_stratagy;
+
+	__u32	pid;
+};
+
+enum {
+	TASKDIAG_CMD_ATTR_UNSPEC = 0,
+	TASKDIAG_CMD_ATTR_GET,
+	__TASKDIAG_CMD_ATTR_MAX,
+};
+
+#define TASKDIAG_CMD_ATTR_MAX (__TASKDIAG_CMD_ATTR_MAX - 1)
+
+#endif /* _LINUX_TASKDIAG_H */
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971..e959ae3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -430,6 +430,18 @@ config TASKSTATS
 
 	  Say N if unsure.
 
+config TASK_DIAG
+	bool "Export task/process properties through netlink"
+	depends on NET
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
index a59481a..2d4fc71 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_TASK_DIAG) += taskdiag.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
new file mode 100644
index 0000000..5faf3f0
--- /dev/null
+++ b/kernel/taskdiag.c
@@ -0,0 +1,179 @@
+#include <uapi/linux/taskdiag.h>
+#include <net/genetlink.h>
+#include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+
+static struct genl_family family = {
+	.id		= GENL_ID_GENERATE,
+	.name		= TASKDIAG_GENL_NAME,
+	.version	= TASKDIAG_GENL_VERSION,
+	.maxattr	= TASKDIAG_CMD_ATTR_MAX,
+	.netnsok	= true,
+};
+
+static size_t taskdiag_packet_size(u64 show_flags)
+{
+	return nla_total_size(sizeof(struct task_diag_msg));
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
+static int fill_task_msg(struct task_struct *p, struct sk_buff *skb)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct task_diag_msg *msg;
+	struct nlattr *attr;
+	char tcomm[sizeof(p->comm)];
+	struct task_struct *tracer;
+
+	attr = nla_reserve(skb, TASK_DIAG_MSG, sizeof(struct task_diag_msg));
+	if (!attr)
+		return -EMSGSIZE;
+
+	msg = nla_data(attr);
+
+	rcu_read_lock();
+	msg->ppid = pid_alive(p) ?
+		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
+
+	msg->tpid = 0;
+	tracer = ptrace_parent(p);
+	if (tracer)
+		msg->tpid = task_pid_nr_ns(tracer, ns);
+
+	msg->tgid = task_tgid_nr_ns(p, ns);
+	msg->pid = task_pid_nr_ns(p, ns);
+	msg->sid = task_session_nr_ns(p, ns);
+	msg->pgid = task_pgrp_nr_ns(p, ns);
+
+	rcu_read_unlock();
+
+	get_task_comm(tcomm, p);
+	memset(msg->comm, 0, TASK_DIAG_COMM_LEN);
+	strncpy(msg->comm, tcomm, TASK_DIAG_COMM_LEN);
+
+	msg->state = get_task_state(p);
+
+	return 0;
+}
+
+static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
+				u64 show_flags, u32 portid, u32 seq)
+{
+	void *reply;
+	int err;
+
+	reply = genlmsg_put(skb, portid, seq, &family, 0, TASKDIAG_CMD_GET);
+	if (reply == NULL)
+		return -EMSGSIZE;
+
+	err = fill_task_msg(tsk, skb);
+	if (err)
+		goto err;
+
+	return genlmsg_end(skb, reply);
+err:
+	genlmsg_cancel(skb, reply);
+	return err;
+}
+
+static int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct task_struct *tsk = NULL;
+	struct task_diag_pid *req;
+	struct sk_buff *msg;
+	size_t size;
+	int rc;
+
+	req = nla_data(info->attrs[TASKDIAG_CMD_ATTR_GET]);
+	if (req == NULL)
+		return -EINVAL;
+
+	if (nla_len(info->attrs[TASKDIAG_CMD_ATTR_GET]) < sizeof(*req))
+		return -EINVAL;
+
+	size = taskdiag_packet_size(req->show_flags);
+	msg = genlmsg_new(size, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	tsk = find_task_by_vpid(req->pid);
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
+	rc = task_diag_fill(tsk, msg, req->show_flags,
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
+
+static const struct nla_policy
+			taskstats_cmd_get_policy[TASKDIAG_CMD_ATTR_MAX+1] = {
+	[TASKDIAG_CMD_ATTR_GET]  = {	.type = NLA_UNSPEC,
+					.len = sizeof(struct task_diag_pid)
+				},
+};
+
+static const struct genl_ops taskdiag_ops[] = {
+	{
+		.cmd		= TASKDIAG_CMD_GET,
+		.doit		= taskdiag_doit,
+		.policy		= taskstats_cmd_get_policy,
+	},
+};
+
+static int __init taskdiag_init(void)
+{
+	int rc;
+
+	rc = genl_register_family_with_ops(&family, taskdiag_ops);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+late_initcall(taskdiag_init);
-- 
2.1.0
