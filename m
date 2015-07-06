From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 19/24] task_diag: Add option to dump all threads for all tasks
Date: Mon,  6 Jul 2015 11:47:20 +0300
Message-ID: <1436172445-6979-20-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

New dump strategy to walk all threads of all processes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/task_diag.h |  7 +++---
 kernel/taskdiag.c              | 55 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 4a1cecb..19c9579 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -149,9 +149,10 @@ static inline struct task_diag_vma_stat *task_diag_vma_stat(struct task_diag_vma
 		vma = (void *) vma + vma->vma_len)
 
 #define TASK_DIAG_DUMP_ALL	0
-#define TASK_DIAG_DUMP_CHILDREN	1
-#define TASK_DIAG_DUMP_THREAD	2
-#define TASK_DIAG_DUMP_ONE	3
+#define TASK_DIAG_DUMP_ALL_THREAD	1
+#define TASK_DIAG_DUMP_CHILDREN	2
+#define TASK_DIAG_DUMP_THREAD	3
+#define TASK_DIAG_DUMP_ONE	4
 
 struct task_diag_pid {
 	__u64	show_flags;
diff --git a/kernel/taskdiag.c b/kernel/taskdiag.c
index 20494ee..e5a5eed 100644
--- a/kernel/taskdiag.c
+++ b/kernel/taskdiag.c
@@ -521,13 +521,9 @@ struct task_iter {
 	struct netlink_callback *cb;
 	struct task_struct *parent;
 
-	union {
-		struct tgid_iter tgid;
-		struct {
-			unsigned int		pos;
-			struct task_struct	*task;
-		};
-	};
+	struct tgid_iter tgid;
+	unsigned int		pos;
+	struct task_struct	*task;
 };
 
 static void iter_stop(struct task_iter *iter)
@@ -541,6 +537,12 @@ static void iter_stop(struct task_iter *iter)
 	case TASK_DIAG_DUMP_ALL:
 		task = iter->tgid.task;
 		break;
+	case TASK_DIAG_DUMP_ALL_THREAD:
+		/* release both tgid task and thread task */
+		if (iter->task)
+			put_task_struct(iter->task);
+		task = iter->tgid.task;
+		break;
 	default:
 		task = iter->task;
 	}
@@ -590,6 +592,25 @@ static struct task_struct *iter_start(struct task_iter *iter)
 		iter->tgid.task = NULL;
 		iter->tgid = next_tgid(iter->ns, iter->tgid);
 		return iter->tgid.task;
+
+	case TASK_DIAG_DUMP_ALL_THREAD:
+		iter->pos = iter->cb->args[1];
+		iter->tgid.tgid = iter->cb->args[0];
+		iter->tgid.task = NULL;
+		iter->tgid = next_tgid(iter->ns, iter->tgid);
+		if (!iter->tgid.task)
+			return NULL;
+
+		iter->task = task_first_tid(iter->tgid.task, 0, iter->pos, iter->ns);
+		if (!iter->task) {
+			iter->pos = 0;
+			iter->tgid.tgid += 1;
+			iter->tgid = next_tgid(iter->ns, iter->tgid);
+			iter->task = iter->tgid.task;
+			if (iter->task)
+				get_task_struct(iter->task);
+		}
+		return iter->task;
 	}
 
 	return ERR_PTR(-EINVAL);
@@ -622,6 +643,24 @@ static struct task_struct *iter_next(struct task_iter *iter)
 		iter->tgid = next_tgid(iter->ns, iter->tgid);
 		iter->cb->args[0] = iter->tgid.tgid;
 		return iter->tgid.task;
+
+	case TASK_DIAG_DUMP_ALL_THREAD:
+		iter->pos++;
+		iter->task = task_next_tid(iter->task);
+		if (!iter->task) {
+			iter->pos = 0;
+			iter->tgid.tgid += 1;
+			iter->tgid = next_tgid(iter->ns, iter->tgid);
+			iter->task = iter->tgid.task;
+			if (iter->task)
+				get_task_struct(iter->task);
+		}
+
+		/* save current position */
+		iter->cb->args[0] = iter->tgid.tgid;
+		iter->cb->args[1] = iter->pos;
+
+		return iter->task;
 	}
 
 	return NULL;
@@ -647,6 +686,8 @@ int taskdiag_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	iter.ns     = ns;
 	iter.cb     = cb;
 	iter.parent = NULL;
+	iter.pos    = 0;
+	iter.task   = NULL;
 
 	task = iter_start(&iter);
 	if (IS_ERR(task))
-- 
2.1.0
