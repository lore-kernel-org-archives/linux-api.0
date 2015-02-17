From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 6/7] task_diag: add ability to dump children
Date: Tue, 17 Feb 2015 11:20:25 +0300
Message-ID: <1424161226-15176-7-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

Now we can dump all task or children of a specified task.
It's an example how this interface can be expanded for different
use-cases.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/taskdiag.h |  1 +
 kernel/taskdiag.c             | 83 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/taskdiag.h b/include/uapi/linux/taskdiag.h
index db12f6d..d8a9e92 100644
--- a/include/uapi/linux/taskdiag.h
+++ b/include/uapi/linux/taskdiag.h
@@ -68,6 +68,7 @@ enum {
 #define TASKDIAG_CMD_MAX (__TASKDIAG_CMD_MAX - 1)
 
 #define TASK_DIAG_DUMP_ALL	0
+#define TASK_DIAG_DUMP_CHILDREN	1
 
 struct task_diag_pid {
 	__u64	show_flags;
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 6ccbcaf..951ecbd 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -155,12 +155,71 @@ err:
 	return err;
 }
 
+struct task_iter {
+	struct task_diag_pid *req;
+	struct pid_namespace *ns;
+	struct netlink_callback *cb;
+
+	union {
+		struct tgid_iter tgid;
+		struct child_iter child;
+	};
+};
+
+static struct task_struct *iter_start(struct task_iter *iter)
+{
+	switch (iter->req->dump_stratagy) {
+	case TASK_DIAG_DUMP_CHILDREN:
+		rcu_read_lock();
+		iter->child.parent = find_task_by_pid_ns(iter->req->pid, iter->ns);
+		if (iter->child.parent)
+			get_task_struct(iter->child.parent);
+		rcu_read_unlock();
+
+		if (iter->child.parent == NULL)
+			return ERR_PTR(-ESRCH);
+
+		iter->child.pos = iter->cb->args[0];
+		iter->child.task = NULL;
+		iter->child = next_child(iter->child);
+		return iter->child.task;
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
+	switch (iter->req->dump_stratagy) {
+	case TASK_DIAG_DUMP_CHILDREN:
+		iter->child.pos += 1;
+		iter->child = next_child(iter->child);
+		iter->cb->args[0] = iter->child.pos;
+		return iter->child.task;
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
 static int taskdiag_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct pid_namespace *ns = task_active_pid_ns(current);
-	struct tgid_iter iter;
+	struct task_iter iter;
 	struct nlattr *na;
 	struct task_diag_pid *req;
+	struct task_struct *task;
 	int rc;
 
 	if (nlmsg_len(cb->nlh) < GENL_HDRLEN + sizeof(*req))
@@ -172,26 +231,28 @@ static int taskdiag_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 
 	req = (struct task_diag_pid *) nla_data(na);
 
-	iter.tgid = cb->args[0];
-	iter.task = NULL;
-	for (iter = next_tgid(ns, iter);
-	     iter.task;
-	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
-		if (!ptrace_may_access(iter.task, PTRACE_MODE_READ))
+	iter.req = req;
+	iter.ns  = ns;
+	iter.cb  = cb;
+
+	task = iter_start(&iter);
+	if (IS_ERR(task) < 0)
+		return PTR_ERR(task);
+
+	for (; task; task = iter_next(&iter)) {
+		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			continue;
 
-		rc = task_diag_fill(iter.task, skb, req->show_flags,
+		rc = task_diag_fill(task, skb, req->show_flags,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq);
 		if (rc < 0) {
-			put_task_struct(iter.task);
+			put_task_struct(task);
 			if (rc != -EMSGSIZE)
 				return rc;
 			break;
 		}
 	}
 
-	cb->args[0] = iter.tgid;
-
 	return skb->len;
 }
 
-- 
2.1.0
