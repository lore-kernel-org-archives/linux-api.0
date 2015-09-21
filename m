From: Petr Mladek <pmladek@suse.com>
Subject: [RFC v2 03/18] kthread: Add drain_kthread_worker()
Date: Mon, 21 Sep 2015 15:03:44 +0200
Message-ID: <1442840639-6963-4-git-send-email-pmladek@suse.com>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

flush_kthread_worker() returns when the currently queued works are proceed.
But some other works might have been queued in the meantime.

This patch adds drain_kthread_work() that is inspired by drain_workqueue().
It returns when the queue is completely empty and warns when it takes too
long.

The initial implementation does not block queuing new works when draining.
It makes things much easier. The blocking would be useful to debug
potential problems but it is not clear if it is worth
the complication at the moment.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/kthread.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 8f8813b42632..e6424cf17cbd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -770,3 +770,42 @@ void flush_kthread_worker(struct kthread_worker *worker)
 	wait_for_completion(&fwork.done);
 }
 EXPORT_SYMBOL_GPL(flush_kthread_worker);
+
+/**
+ * drain_kthread_worker - drain a kthread worker
+ * @worker: worker to be drained
+ *
+ * Wait until there is none work queued for the given kthread worker.
+ * Only currently running work on @worker can queue further work items
+ * on it.  @worker is flushed repeatedly until it becomes empty.
+ * The number of flushing is determined by the depth of chaining
+ * and should be relatively short.  Whine if it takes too long.
+ *
+ * The caller is responsible for blocking all existing works
+ * from an infinite re-queuing!
+ *
+ * Also the caller is responsible for blocking all the kthread
+ * worker users from queuing any new work. It is especially
+ * important if the queue has to stay empty once this function
+ * finishes.
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
