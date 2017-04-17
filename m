From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of ns_last_pid's
 on ns hierarhy
Date: Mon, 17 Apr 2017 20:36:17 +0300
Message-ID: <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: serge@hallyn.com, ebiederm@xmission.com, agruenba@redhat.com, linux-api@vger.kernel.org, oleg@redhat.com, linux-kernel@vger.kernel.org, paul@paul-moore.com, ktkhai@virtuozzo.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
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
a helper for every pid_ns in the hierarchy is not cheap
and not performance-good as it implies many helpers wakeups
to create a single task (independently, how you communicate
with the helpers). This patch tries to decide the problem.

It introduces a new pid_ns ns_ioctl(PIDNS_REQ_SET_LAST_PID_VEC),
which allows to write a vector of last pids on pid_ns hierarchy.
The vector is passed as a ":"-delimited string with pids,
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

and the ns of task's of pid_ns3 is open, then the corresponding
vector will be "last_ns_pid3:last_ns_pid2:last_ns_pid1". This
vector may be short and it may contain less levels, for example,
"last_ns_pid3:last_ns_pid2" or even "last_ns_pid3", in dependence
of which levels you want to populate.

To write in a pid_ns's ns_last_pid we check that the writer task
has CAP_SYS_ADMIN permittions in this pid_ns's user_ns.

One note about struct pidns_ioc_req. It's made extensible and
may expanded in the future. The always existing fields present
at the moment, the future fields and they sizes may be determined
by pidns_ioc_req::req by the future code.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/uapi/linux/nsfs.h |    9 +++++
 kernel/pid_namespace.c    |   88 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 544bbb661475..37bb4af917b5 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -17,4 +17,13 @@
 /* Execute namespace-specific ioctl */
 #define NS_SPECIFIC_IOC		_IO(NSIO, 0x5)
 
+struct pidns_ioc_req {
+/* Set vector of last pids in namespace hierarchy */
+#define PIDNS_REQ_SET_LAST_PID_VEC	0x1
+	unsigned int req;
+	void __user *data;
+	unsigned int data_size;
+	char std_fields[0];
+};
+
 #endif /* __LINUX_NSFS_H */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index de461aa0bf9a..0e86fa15cd92 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -21,6 +21,8 @@
 #include <linux/export.h>
 #include <linux/sched/task.h>
 #include <linux/sched/signal.h>
+#include <linux/vmalloc.h>
+#include <uapi/linux/nsfs.h>
 
 struct pid_cache {
 	int nr_ids;
@@ -428,6 +430,91 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
 	return &get_pid_ns(pid_ns)->ns;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long set_last_pid_vec(struct pid_namespace *pid_ns,
+			     struct pidns_ioc_req *req)
+{
+	char *str, *p;
+	int ret = 0;
+	pid_t pid;
+
+	read_lock(&tasklist_lock);
+	if (!pid_ns->child_reaper)
+		ret = -EINVAL;
+	read_unlock(&tasklist_lock);
+	if (ret)
+		return ret;
+
+	if (req->data_size >= PAGE_SIZE)
+		return -EINVAL;
+	str = vmalloc(req->data_size + 1);
+	if (!str)
+		return -ENOMEM;
+	if (copy_from_user(str, req->data, req->data_size)) {
+		ret = -EFAULT;
+		goto out_vfree;
+	}
+	str[req->data_size] = '\0';
+
+	p = str;
+	while (p && *p != '\0') {
+		if (!ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN)) {
+			ret = -EPERM;
+			goto out_vfree;
+		}
+
+		if (sscanf(p, "%d", &pid) != 1 || pid < 0 || pid > pid_max) {
+			ret = -EINVAL;
+			goto out_vfree;
+		}
+
+		/* Write directly: see the comment in pid_ns_ctl_handler() */
+		pid_ns->last_pid = pid;
+
+		p = strchr(p, ':');
+		pid_ns = pid_ns->parent;
+		if (p) {
+			if (!pid_ns) {
+				ret = -EINVAL;
+				goto out_vfree;
+			}
+			p++;
+		}
+	}
+
+	ret = 0;
+out_vfree:
+	vfree(str);
+	return ret;
+}
+#else	/* CONFIG_CHECKPOINT_RESTORE */
+static long set_last_pid_vec(struct pid_namespace *pid_ns,
+			     struct pidns_ioc_req *req)
+{
+	return -ENOTTY;
+}
+#endif	/* CONFIG_CHECKPOINT_RESTORE */
+
+static long pidns_ioctl(struct ns_common *ns, unsigned long arg)
+{
+	struct pid_namespace *pid_ns = to_pid_ns(ns);
+	struct pidns_ioc_req user_req;
+	int ret;
+
+	ret = copy_from_user(&user_req, (void *)arg,
+			     offsetof(struct pidns_ioc_req, std_fields));
+	if (ret)
+		return ret;
+
+	switch (user_req.req) {
+	case PIDNS_REQ_SET_LAST_PID_VEC:
+		return set_last_pid_vec(pid_ns, &user_req);
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
 static struct user_namespace *pidns_owner(struct ns_common *ns)
 {
 	return to_pid_ns(ns)->user_ns;
@@ -441,6 +528,7 @@ const struct proc_ns_operations pidns_operations = {
 	.install	= pidns_install,
 	.owner		= pidns_owner,
 	.get_parent	= pidns_get_parent,
+	.ns_ioctl	= pidns_ioctl,
 };
 
 static __init int pid_namespaces_init(void)
