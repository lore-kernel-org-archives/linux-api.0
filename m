From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/7] task-diag: add ability to get information about all tasks
Date: Tue, 17 Feb 2015 11:20:22 +0300
Message-ID: <1424161226-15176-4-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

For that we need to set NLM_F_DUMP. Currently here are no
filters. Any suggestions are welcome.

I think we can add request for children, threads, session or group
members.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/taskdiag.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 5faf3f0..da4a51b 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -102,6 +102,46 @@ err:
 	return err;
 }
 
+static int taskdiag_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct tgid_iter iter;
+	struct nlattr *na;
+	struct task_diag_pid *req;
+	int rc;
+
+	if (nlmsg_len(cb->nlh) < GENL_HDRLEN + sizeof(*req))
+		return -EINVAL;
+
+	na = nlmsg_data(cb->nlh) + GENL_HDRLEN;
+	if (na->nla_type < 0)
+		return -EINVAL;
+
+	req = (struct task_diag_pid *) nla_data(na);
+
+	iter.tgid = cb->args[0];
+	iter.task = NULL;
+	for (iter = next_tgid(ns, iter);
+	     iter.task;
+	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		if (!ptrace_may_access(iter.task, PTRACE_MODE_READ))
+			continue;
+
+		rc = task_diag_fill(iter.task, skb, req->show_flags,
+				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq);
+		if (rc < 0) {
+			put_task_struct(iter.task);
+			if (rc != -EMSGSIZE)
+				return rc;
+			break;
+		}
+	}
+
+	cb->args[0] = iter.tgid;
+
+	return skb->len;
+}
+
 static int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct task_struct *tsk = NULL;
@@ -161,6 +201,7 @@ static const struct genl_ops taskdiag_ops[] = {
 	{
 		.cmd		= TASKDIAG_CMD_GET,
 		.doit		= taskdiag_doit,
+		.dumpit		= taskdiag_dumpid,
 		.policy		= taskstats_cmd_get_policy,
 	},
 };
-- 
2.1.0
