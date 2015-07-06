From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 11/24] task_diag: add a new group to get task statistics
Date: Mon,  6 Jul 2015 11:47:12 +0300
Message-ID: <1436172445-6979-12-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/linux/taskstats_kern.h |  2 ++
 include/uapi/linux/task_diag.h |  2 ++
 kernel/taskdiag.c              | 30 ++++++++++++++++++++++++++++++
 kernel/taskstats.c             |  2 +-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index 716835f..8faec32 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -32,6 +32,8 @@ int taskdiag_doit(struct sk_buff *skb, struct genl_info *info);
 struct netlink_callback;
 int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 
+extern int fill_stats_for_pid(pid_t pid, struct taskstats *stats);
+
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index af192db..c51380a 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -8,6 +8,7 @@ enum {
 	/* optional attributes which can be specified in show_flags */
 	TASK_DIAG_BASE	= 0,
 	TASK_DIAG_CRED,
+	TASK_DIAG_STAT,
 
 	/* other attributes */
 	TASK_DIAG_PID	= 64,	/* u32 */
@@ -18,6 +19,7 @@ enum {
 
 #define TASK_DIAG_SHOW_BASE	(1ULL << TASK_DIAG_BASE)
 #define TASK_DIAG_SHOW_CRED	(1ULL << TASK_DIAG_CRED)
+#define TASK_DIAG_SHOW_STAT	(1ULL << TASK_DIAG_STAT)
 
 enum {
 	TASK_DIAG_RUNNING,
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 6dd3361..a49ccab 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -6,6 +6,7 @@
 #include <linux/ptrace.h>
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
+#include <linux/taskstats.h>
 
 static size_t taskdiag_packet_size(u64 show_flags)
 {
@@ -19,6 +20,9 @@ static size_t taskdiag_packet_size(u64 show_flags)
 	if (show_flags & TASK_DIAG_SHOW_CRED)
 		size += nla_total_size(sizeof(struct task_diag_creds));
 
+	if (show_flags & TASK_DIAG_SHOW_STAT)
+		size += nla_total_size(sizeof(struct taskstats));
+
 	return size;
 }
 
@@ -94,6 +98,24 @@ static inline void caps2diag(struct task_diag_caps *diag, const kernel_cap_t *ca
 		diag->cap[i] = cap->cap[i];
 }
 
+static int fill_stats(struct task_struct *tsk, struct sk_buff *skb)
+{
+	struct taskstats *diag_stats;
+	struct nlattr *attr;
+	int ret;
+
+	attr = nla_reserve(skb, TASK_DIAG_STAT, sizeof(struct taskstats));
+	if (!attr)
+		return -EMSGSIZE;
+
+	diag_stats = nla_data(attr);
+
+	ret = fill_stats_for_pid(task_pid_vnr(tsk), diag_stats);
+	if (ret)
+		return ret;
+	return 0;
+}
+
 static int fill_creds(struct task_struct *p, struct sk_buff *skb)
 {
 	struct user_namespace *user_ns = current_user_ns();
@@ -168,6 +190,14 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
 		i++;
 	}
 
+	if (show_flags & TASK_DIAG_SHOW_STAT) {
+		if (i >= n)
+			err = fill_stats(tsk, skb);
+		if (err)
+			goto err;
+		i++;
+	}
+
 	genlmsg_end(skb, reply);
 	if (cb)
 		cb->args[2] = 0;
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 40f2cdf2..3b3d660 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -192,7 +192,7 @@ static void fill_stats(struct user_namespace *user_ns,
 	xacct_add_tsk(stats, tsk);
 }
 
-static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
+int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
 {
 	struct task_struct *tsk;
 
-- 
2.1.0
