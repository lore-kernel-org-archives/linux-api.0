From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v3 1/3] sched/wait: add __wake_up_rotate()
Date: Tue, 24 Feb 2015 21:25:42 +0000 (GMT)
Message-ID: <97a87e7644a2408f140c8ecdb1d71d6606d9df2b.1424805740.git.jbaron@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424805740.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Create a special queue where waiters are 'rotated' to the end of the queue
after they are woken up. Waiters are expected to be added 'exclusively'
to this queue, and the wakeup must occur with __wake_up_rotate().

The current issue with just adding a waiter as exclusive is that it that often
results in the same thread woken up again and again. The first intended user of
this functionality is epoll.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/linux/wait.h |  1 +
 kernel/sched/wait.c  | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2232ed1..86f06f4 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -152,6 +152,7 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *k
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
+void __wake_up_rotate(wait_queue_head_t *q, unsigned int mode, int nr_exclusive, int wake_flags, void *key);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
 int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
 void wake_up_bit(void *, int);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 852143a..2ceed03 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -157,6 +157,33 @@ void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
 /*
+ * Special wait queue were anything added as excluive will be rotated to the
+ * back of the queue in order to balance the wakeups.
+ */
+void __wake_up_rotate(wait_queue_head_t *q, unsigned int mode,
+		      int nr_exclusive, int wake_flags, void *key)
+{
+	unsigned long flags;
+	wait_queue_t *curr, *next;
+	LIST_HEAD(rotate_list);
+
+	spin_lock_irqsave(&q->lock, flags);
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
+		unsigned wq_flags = curr->flags;
+
+		if (curr->func(curr, mode, wake_flags, key) &&
+					(wq_flags & WQ_FLAG_EXCLUSIVE)) {
+			if (nr_exclusive > 0)
+				list_move_tail(&curr->task_list, &rotate_list);
+			if (!--nr_exclusive)
+				break;
+		}
+	}
+	list_splice_tail(&rotate_list, &q->task_list);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+/*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
  * wake-function that tests for the wait-queue being active
-- 
1.8.2.rc2
