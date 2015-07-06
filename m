From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 05/24] task_diag: add ability to get information about all tasks
Date: Mon,  6 Jul 2015 11:47:06 +0300
Message-ID: <1436172445-6979-6-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

For that we need to set NLM_F_DUMP. A response contain on a few packets.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/linux/taskstats_kern.h |  2 ++
 kernel/taskdiag.c              | 40 ++++++++++++++++++++++++++++++++++++++++
 kernel/taskstats.c             |  1 +
 3 files changed, 43 insertions(+)

diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index a1fd4f8..716835f 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -29,6 +29,8 @@ extern void taskstats_init_early(void);
 struct genl_info;
 struct sk_buff;
 int taskdiag_doit(struct sk_buff *skb, struct genl_info *info);
+struct netlink_callback;
+int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 7327e08..3497304 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -112,6 +112,46 @@ err:
 	return err;
 }
 
+int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct tgid_iter iter;
+	struct nlattr *na;
+	struct task_diag_pid req;
+	int rc;
+
+	if (nlmsg_len(cb->nlh) < GENL_HDRLEN + sizeof(req))
+		return -EINVAL;
+
+	na = nlmsg_data(cb->nlh) + GENL_HDRLEN;
+	if (na->nla_type < 0)
+		return -EINVAL;
+
+	memcpy(&req, nla_data(na), sizeof(req));
+
+	iter.tgid = cb->args[0];
+	iter.task = NULL;
+	for (iter = next_tgid(ns, iter);
+	     iter.task;
+	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		if (!ptrace_may_access(iter.task, PTRACE_MODE_READ))
+			continue;
+
+		rc = task_diag_fill(iter.task, skb, req.show_flags,
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
 int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *nla = info->attrs[TASK_DIAG_CMD_ATTR_GET];
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 0c90d11..40f2cdf2 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -691,6 +691,7 @@ static const struct genl_ops taskstats_ops[] = {
 	{
 		.cmd		= TASK_DIAG_CMD_GET,
 		.doit		= taskdiag_doit,
+		.dumpit		= taskdiag_dumpit,
 		.policy		= taskdiag_cmd_get_policy,
 	},
 #endif
-- 
2.1.0
