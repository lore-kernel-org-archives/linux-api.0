From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 20/24] task_diag: Only add VMAs for thread_group leader
Date: Mon,  6 Jul 2015 11:47:21 +0300
Message-ID: <1436172445-6979-21-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

threads of a process share the same VMAs, so when dumping all threads
for all processes only push vma data for group leader.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/taskdiag.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index e5a5eed..6549df3 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -443,9 +443,10 @@ err:
 }
 
 static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
-				u64 show_flags, u32 portid, u32 seq,
-				struct netlink_callback *cb)
+			  struct task_diag_pid *req, u32 portid, u32 seq,
+			  struct netlink_callback *cb)
 {
+	u64 show_flags = req->show_flags;
 	void *reply;
 	int err = 0, i = 0, n = 0;
 	bool progress = false;
@@ -492,6 +493,13 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 	}
 
 	if (show_flags & TASK_DIAG_SHOW_VMA) {
+		/* if the request is to dump all threads of all processes
+		 * only show VMAs for group leader.
+		 */
+		if (req->dump_strategy == TASK_DIAG_DUMP_ALL_THREAD &&
+		    !thread_group_leader(tsk))
+			goto done;
+
 		if (i >= n)
 			err = fill_vma(tsk, skb, cb, &progress, show_flags);
 		if (err)
@@ -499,6 +507,7 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 		i++;
 	}
 
+done:
 	genlmsg_end(skb, reply);
 	if (cb)
 		cb->args[2] = 0;
@@ -696,7 +705,7 @@ int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	for (; task; task = iter_next(&iter)) {
 		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			continue;
-		rc = task_diag_fill(task, skb, iter.req.show_flags,
+		rc = task_diag_fill(task, skb, &iter.req,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq, cb);
 		if (rc < 0) {
 			if (rc != -EMSGSIZE) {
@@ -755,7 +764,7 @@ int taskdiag_doit(struct sk_buff *skb, struct genl_info *info)
 			return -EMSGSIZE;
 		}
 
-		rc = task_diag_fill(tsk, msg, req.show_flags,
+		rc = task_diag_fill(tsk, msg, &req,
 					info->snd_portid, info->snd_seq, NULL);
 		if (rc != -EMSGSIZE)
 			break;
-- 
2.1.0
