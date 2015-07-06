From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/24] task_diag: add ability to split per-task data on a few netlink messages
Date: Mon,  6 Jul 2015 11:47:07 +0300
Message-ID: <1436172445-6979-7-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The size of requested per-task data can be bigger that the size of one
netlink skb. Currently we are able to split data into a few netlink
messages.

v2: set NLM_F_MULTI for multipart packets

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/taskdiag.c | 76 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 3497304..5771baf 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -84,13 +84,21 @@ static int fill_task_base(struct task_struct *p, struct sk_buff *skb)
 }
 
 static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
-				u64 show_flags, u32 portid, u32 seq)
+				u64 show_flags, u32 portid, u32 seq,
+				struct netlink_callback *cb)
 {
 	void *reply;
-	int err;
+	int err = 0, i = 0, n = 0;
+	int flags = 0;
 	u32 pid;
 
-	reply = genlmsg_put(skb, portid, seq, &taskstats_family, 0, TASK_DIAG_CMD_GET);
+	if (cb) {
+		n = cb->args[2];
+		flags |= NLM_F_MULTI;
+	}
+
+	reply = genlmsg_put(skb, portid, seq, &taskstats_family,
+					flags, TASK_DIAG_CMD_GET);
 	if (reply == NULL)
 		return -EMSGSIZE;
 
@@ -100,15 +108,26 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 		goto err;
 
 	if (show_flags & TASK_DIAG_SHOW_BASE) {
-		err = fill_task_base(tsk, skb);
+		if (i >= n)
+			err = fill_task_base(tsk, skb);
 		if (err)
 			goto err;
+		i++;
 	}
 
 	genlmsg_end(skb, reply);
+	if (cb)
+		cb->args[2] = 0;
+
 	return 0;
 err:
-	genlmsg_cancel(skb, reply);
+	if (err == -EMSGSIZE && i != 0) {
+		if (cb)
+			cb->args[2] = i;
+		genlmsg_end(skb, reply);
+	} else
+		genlmsg_cancel(skb, reply);
+
 	return err;
 }
 
@@ -138,7 +157,7 @@ int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 
 		rc = task_diag_fill(iter.task, skb, req.show_flags,
-				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq);
+				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq, cb);
 		if (rc < 0) {
 			put_task_struct(iter.task);
 			if (rc != -EMSGSIZE)
@@ -157,7 +176,7 @@ int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *nla = info->attrs[TASK_DIAG_CMD_ATTR_GET];
 	struct task_struct *tsk = NULL;
 	struct task_diag_pid req;
-	struct sk_buff *msg;
+	struct sk_buff *msg = NULL;
 	size_t size;
 	int rc;
 
@@ -174,35 +193,42 @@ int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 	 */
 	memcpy(&req, nla_data(nla), sizeof(req));
 
-	size = taskdiag_packet_size(req.show_flags);
-	msg = genlmsg_new(size, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
 	rcu_read_lock();
 	tsk = find_task_by_vpid(req.pid);
 	if (tsk)
 		get_task_struct(tsk);
 	rcu_read_unlock();
-	if (!tsk) {
-		rc = -ESRCH;
-		goto err;
-	};
+	if (!tsk)
+		return -ESRCH;
 
 	if (!ptrace_may_access(tsk, PTRACE_MODE_READ)) {
 		put_task_struct(tsk);
-		rc = -EPERM;
-		goto err;
+		return -EPERM;
+	}
+
+	size = taskdiag_packet_size(req.show_flags);
+
+	while (1) {
+		msg = genlmsg_new(size, GFP_KERNEL);
+		if (!msg) {
+			put_task_struct(tsk);
+			return -EMSGSIZE;
+		}
+
+		rc = task_diag_fill(tsk, msg, req.show_flags,
+					info->snd_portid, info->snd_seq, NULL);
+		if (rc != -EMSGSIZE)
+			break;
+
+		nlmsg_free(msg);
+		size += 128;
 	}
 
-	rc = task_diag_fill(tsk, msg, req.show_flags,
-				info->snd_portid, info->snd_seq);
 	put_task_struct(tsk);
-	if (rc < 0)
-		goto err;
+	if (rc < 0) {
+		nlmsg_free(msg);
+		return rc;
+	}
 
 	return genlmsg_reply(msg, info);
-err:
-	nlmsg_free(msg);
-	return rc;
 }
-- 
2.1.0
