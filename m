From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/24] task_diag: add ability to dump children (v2)
Date: Mon,  6 Jul 2015 11:47:11 +0300
Message-ID: <1436172445-6979-11-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Now we can dump all task or children of a specified task.
It's an example how this interface can be expanded for different
use-cases.

v2: Fixes from David Ahern
    Add missing break in iter_stop
    Fix 8-byte alignment issues

Cc: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/task_diag.h |   1 +
 kernel/taskdiag.c              | 117 +++++++++++++++++++++++++++++++++++------
 2 files changed, 102 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 0e659d6..af192db 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -63,6 +63,7 @@ struct task_diag_creds {
 };
 
 #define TASK_DIAG_DUMP_ALL	0
+#define TASK_DIAG_DUMP_CHILDREN	1
 
 struct task_diag_pid {
 	__u64	show_flags;
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 5123e12..6dd3361 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -184,42 +184,127 @@ err:
 	return err;
 }
 
+struct task_iter {
+	struct task_diag_pid req;
+	struct pid_namespace *ns;
+	struct netlink_callback *cb;
+	struct task_struct *parent;
+
+	union {
+		struct tgid_iter tgid;
+		struct {
+			unsigned int		pos;
+			struct task_struct	*task;
+		};
+	};
+};
+
+static void iter_stop(struct task_iter *iter)
+{
+	struct task_struct *task;
+
+	if (iter->parent)
+		put_task_struct(iter->parent);
+
+	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_ALL:
+		task = iter->tgid.task;
+		break;
+	default:
+		task = iter->task;
+	}
+	if (task)
+		put_task_struct(task);
+}
+
+static struct task_struct *iter_start(struct task_iter *iter)
+{
+	if (iter->req.pid > 0) {
+		rcu_read_lock();
+		iter->parent = find_task_by_pid_ns(iter->req.pid, iter->ns);
+		if (iter->parent)
+			get_task_struct(iter->parent);
+		rcu_read_unlock();
+	}
+
+	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_CHILDREN:
+
+		if (iter->parent == NULL)
+			return ERR_PTR(-ESRCH);
+
+		iter->pos = iter->cb->args[0];
+		iter->task = task_next_child(iter->parent, NULL, iter->pos);
+		return iter->task;
+
+	case TASK_DIAG_DUMP_ALL:
+		iter->tgid.tgid = iter->cb->args[0];
+		iter->tgid.task = NULL;
+		iter->tgid = next_tgid(iter->ns, iter->tgid);
+		return iter->tgid.task;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static struct task_struct *iter_next(struct task_iter *iter)
+{
+	switch (iter->req.dump_strategy) {
+	case TASK_DIAG_DUMP_CHILDREN:
+		iter->pos++;
+		iter->task = task_next_child(iter->parent, iter->task, iter->pos);
+		iter->cb->args[0] = iter->pos;
+		return iter->task;
+
+	case TASK_DIAG_DUMP_ALL:
+		iter->tgid.tgid += 1;
+		iter->tgid = next_tgid(iter->ns, iter->tgid);
+		iter->cb->args[0] = iter->tgid.tgid;
+		return iter->tgid.task;
+	}
+
+	return NULL;
+}
+
 int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct pid_namespace *ns = task_active_pid_ns(current);
-	struct tgid_iter iter;
+	struct task_iter iter;
 	struct nlattr *na;
-	struct task_diag_pid req;
+	struct task_struct *task;
 	int rc;
 
-	if (nlmsg_len(cb->nlh) < GENL_HDRLEN + sizeof(req))
+	if (nlmsg_len(cb->nlh) < GENL_HDRLEN + sizeof(iter.req))
 		return -EINVAL;
 
 	na = nlmsg_data(cb->nlh) + GENL_HDRLEN;
 	if (na->nla_type < 0)
 		return -EINVAL;
 
-	memcpy(&req, nla_data(na), sizeof(req));
+	memcpy(&iter.req, nla_data(na), sizeof(iter.req));
 
-	iter.tgid = cb->args[0];
-	iter.task = NULL;
-	for (iter = next_tgid(ns, iter);
-	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
-		if (!ptrace_may_access(iter.task, PTRACE_MODE_READ))
-			continue;
+	iter.ns     = ns;
+	iter.cb     = cb;
+	iter.parent = NULL;
 
-		rc = task_diag_fill(iter.task, skb, req.show_flags,
+	task = iter_start(&iter);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	for (; task; task = iter_next(&iter)) {
+		if (!ptrace_may_access(task, PTRACE_MODE_READ))
+			continue;
+		rc = task_diag_fill(task, skb, iter.req.show_flags,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq, cb);
 		if (rc < 0) {
-			put_task_struct(iter.task);
-			if (rc != -EMSGSIZE)
+			if (rc != -EMSGSIZE) {
+				iter_stop(&iter);
 				return rc;
+			}
 			break;
 		}
 	}
-
-	cb->args[0] = iter.tgid;
+	iter_stop(&iter);
 
 	return skb->len;
 }
-- 
2.1.0
