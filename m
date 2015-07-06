From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 21/24] task diag: Add support for TGID attribute
Date: Mon,  6 Jul 2015 11:47:22 +0300
Message-ID: <1436172445-6979-22-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add TGID attribute and put in every message. This is need for perf for
example when processing messages with maps.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/task_diag.h | 1 +
 kernel/taskdiag.c              | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 19c9579..935502b 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -15,6 +15,7 @@ enum {
 
 	/* other attributes */
 	TASK_DIAG_PID	= 64,	/* u32 */
+	TASK_DIAG_TGID,		/* u32 */
 
 	__TASK_DIAG_ATTR_MAX
 #define TASK_DIAG_ATTR_MAX (__TASK_DIAG_ATTR_MAX - 1)
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 6549df3..ccba538 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -13,6 +13,7 @@ static size_t taskdiag_packet_size(u64 show_flags, int n_vma)
 	size_t size;
 
 	size = nla_total_size(sizeof(u32)); /* PID */
+	       + nla_total_size(sizeof(u32)); /* TGID */
 
 	if (show_flags & TASK_DIAG_SHOW_BASE)
 		size += nla_total_size(sizeof(struct task_diag_base));
@@ -451,7 +452,7 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 	int err = 0, i = 0, n = 0;
 	bool progress = false;
 	int flags = 0;
-	u32 pid;
+	u32 pid, tgid;
 
 	if (cb) {
 		n = cb->args[2];
@@ -468,6 +469,11 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 	if (err)
 		goto err;
 
+	tgid = task_tgid_vnr(tsk);
+	err = nla_put_u32(skb, TASK_DIAG_TGID, tgid);
+	if (err)
+		goto err;
+
 	if (show_flags & TASK_DIAG_SHOW_BASE) {
 		if (i >= n)
 			err = fill_task_base(tsk, skb);
-- 
2.1.0
