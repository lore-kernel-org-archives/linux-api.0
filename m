From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH v8 07/12] kthread: Add kthread_destroy_worker()
Date: Thu,  9 Jun 2016 15:52:01 +0200
Message-ID: <1465480326-31606-8-git-send-email-pmladek@suse.com>
References: <1465480326-31606-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1465480326-31606-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

The current kthread worker users call flush() and stop() explicitly.
This function drains the worker, stops it, and frees the kthread_worker
struct in one call.

It is supposed to be used together with kthread_create_worker*() that
allocates struct kthread_worker.

Also note that drain() correctly handles self-queuing works in compare
with flush().

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h |  2 ++
 kernel/kthread.c        | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 6fc0940b9657..c0a527581d95 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -137,4 +137,6 @@ void kthread_flush_work(struct kthread_work *work);
 void kthread_flush_worker(struct kthread_worker *worker);
 void kthread_drain_worker(struct kthread_worker *worker);
 
+void kthread_destroy_worker(struct kthread_worker *worker);
+
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index fa3c327be889..d9f59fdcf466 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -853,3 +853,24 @@ void kthread_drain_worker(struct kthread_worker *worker)
 	spin_unlock_irq(&worker->lock);
 }
 EXPORT_SYMBOL(kthread_drain_worker);
+
+/**
+ * kthread_destroy_worker - destroy a kthread worker
+ * @worker: worker to be destroyed
+ *
+ * Drain and destroy @worker.  It has the same conditions
+ * for use as kthread_drain_worker(), see above.
+ */
+void kthread_destroy_worker(struct kthread_worker *worker)
+{
+	struct task_struct *task;
+
+	task = worker->task;
+	if (WARN_ON(!task))
+		return;
+
+	kthread_drain_worker(worker);
+	kthread_stop(task);
+	kfree(worker);
+}
+EXPORT_SYMBOL(kthread_destroy_worker);
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
