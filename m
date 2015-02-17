From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2 1/2] sched/wait: add round robin wakeup mode
Date: Tue, 17 Feb 2015 19:33:38 +0000 (GMT)
Message-ID: <2ad4b90b552d73de1243c7f4c1dd78e0d509d48d.1424200151.git.jbaron@akamai.com>
References: <cover.1424200151.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424200151.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The motivation for this flag is to allow the distribution of wakeups from
a shared source in a balanced manner. Currently, we can add threads exclusively
but that often results in the same thread woken up again and again. In the case
where we are trying to balance work across threads this is not desirable.

The WQ_FLAG_ROUND_ROBIN is restricted to being exclusive as well, otherwise we
do not know who is being woken up.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/linux/wait.h | 11 +++++++++++
 kernel/sched/wait.c  | 10 ++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2232ed1..bbdef98 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -16,6 +16,7 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
 /* __wait_queue::flags */
 #define WQ_FLAG_EXCLUSIVE	0x01
 #define WQ_FLAG_WOKEN		0x02
+#define WQ_FLAG_ROUND_ROBIN	0x04
 
 struct __wait_queue {
 	unsigned int		flags;
@@ -109,6 +110,16 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
+
+/*
+ * rr relies on exclusive, otherwise we don't know which entry was woken
+ */
+static inline void add_wait_queue_rr(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_ROUND_ROBIN;
+	add_wait_queue_exclusive(q, wait);
+}
+
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 
 static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 852143a..dcb75dd 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -66,14 +66,20 @@ static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, int wake_flags, void *key)
 {
 	wait_queue_t *curr, *next;
+	LIST_HEAD(rotate_list);
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
 		if (curr->func(curr, mode, wake_flags, key) &&
-				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
-			break;
+					(flags & WQ_FLAG_EXCLUSIVE)) {
+			if ((flags & WQ_FLAG_ROUND_ROBIN) && (nr_exclusive > 0))
+				list_move_tail(&curr->task_list, &rotate_list);
+			if (!--nr_exclusive)
+				break;
+		}
 	}
+	list_splice_tail(&rotate_list, &q->task_list);
 }
 
 /**
-- 
1.8.2.rc2
