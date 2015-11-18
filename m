From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 05/22] kthread: Add drain_kthread_worker()
Date: Wed, 18 Nov 2015 14:25:10 +0100
Message-ID: <1447853127-3461-6-git-send-email-pmladek@suse.com>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1447853127-3461-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

flush_kthread_worker() returns when the currently queued works are proceed.
But some other works might have been queued in the meantime.

This patch adds drain_kthread_work() that is inspired by drain_workqueue().
It returns when the queue is completely empty and warns when it takes too
long.

The initial implementation does not block queuing new works when draining.
It makes things much easier. The blocking would be useful to debug
potential problems but it is not clear if it is worth the complication
at the moment.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/kthread.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index df402e18bb5a..a18ad3b58f61 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -804,3 +804,37 @@ void flush_kthread_worker(struct kthread_worker *worker)
 	wait_for_completion(&fwork.done);
 }
 EXPORT_SYMBOL_GPL(flush_kthread_worker);
+
+/**
+ * drain_kthread_worker - drain a kthread worker
+ * @worker: worker to be drained
+ *
+ * Wait until there is no work queued for the given kthread worker.
+ * @worker is flushed repeatedly until it becomes empty.  The number
+ * of flushing is determined by the depth of chaining and should
+ * be relatively short.  Whine if it takes too long.
+ *
+ * The caller is responsible for blocking all users of this kthread
+ * worker from queuing new works. Also it is responsible for blocking
+ * the already queued works from an infinite re-queuing!
+ */
+void drain_kthread_worker(struct kthread_worker *worker)
+{
+	int flush_cnt = 0;
+
+	spin_lock_irq(&worker->lock);
+
+	while (!list_empty(&worker->work_list)) {
+		spin_unlock_irq(&worker->lock);
+
+		flush_kthread_worker(worker);
+		WARN_ONCE(flush_cnt++ > 10,
+			  "kthread worker %s: drain_kthread_worker() isn't complete after %u tries\n",
+			  worker->task->comm, flush_cnt);
+
+		spin_lock_irq(&worker->lock);
+	}
+
+	spin_unlock_irq(&worker->lock);
+}
+EXPORT_SYMBOL(drain_kthread_worker);
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
