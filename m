From: Petr Mladek <pmladek@suse.com>
Subject: [RFC v2 08/18] kthread: Allow to modify delayed kthread work
Date: Mon, 21 Sep 2015 15:03:49 +0200
Message-ID: <1442840639-6963-9-git-send-email-pmladek@suse.com>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

There are situations when we need to modify the delay of a delayed
kthread work. It is typically when the work depends on an event
and the initial delay means a timeout. In this case, we want to
queue the work immediately when the event happens.

The implementation of mod_delayed_kthread_work() is inspired
by a similar function from workqueues.

The function must work also in IRQ context. Therefore it could
not sleep. It must give up when a cancel_delayed_kthread_work()
is flushing the work in parallel. But this happens only
when the two operations are not synchronized any other way
and we would get the same result if the cancel() was called
just a bit later.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h |  4 ++++
 kernel/kthread.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 327d82875410..2110a55bd769 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -178,6 +178,10 @@ bool queue_delayed_kthread_work(struct kthread_worker *worker,
 				struct delayed_kthread_work *dwork,
 				unsigned long delay);
 
+bool mod_delayed_kthread_work(struct kthread_worker *worker,
+			      struct delayed_kthread_work *dwork,
+			      unsigned long delay);
+
 void flush_kthread_work(struct kthread_work *work);
 void flush_kthread_worker(struct kthread_worker *worker);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 8c6160eece72..27bf242064d1 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -943,6 +943,49 @@ fail:
 	return -EAGAIN;
 }
 
+/**
+ * mod_delayed_kthread_work - modify delay of or queue a delayed kthread work
+ * @worker: kthread worker to use
+ * @dwork: delayed kthread work to queue
+ * @delay: number of jiffies to wait before queuing
+ *
+ * If @dwork is idle, equivalent to queue_delayed_kthread work(); otherwise,
+ * modify @dwork's timer so that it expires after @delay.  If @delay is
+ * zero, @work is guaranteed to be queued immediately;
+ *
+ * Return: %false if @dwork was idle and queued, %true if @dwork was
+ * pending and its timer was modified.
+ *
+ * It returns %true also when cancel_kthread_work_sync() is flushing
+ * the work, see below. We are not able to queue the work in this case.
+ * But it happens only when the two calls are not synchronized. We would
+ * get the same result if cancel() was called just a bit later.
+ *
+ * This function is safe to call from any context including IRQ handler.
+ * See try_to_grab_pending_kthread_work() for details.
+ */
+bool mod_delayed_kthread_work(struct kthread_worker *worker,
+			      struct delayed_kthread_work *dwork,
+			      unsigned long delay)
+{
+	unsigned long flags;
+	int ret;
+
+	do {
+		ret = try_to_grab_pending_kthread_work(&dwork->work,
+						       true, &flags);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (likely(ret >= 0)) {
+		__queue_delayed_kthread_work(worker, dwork, delay);
+		local_irq_restore(flags);
+	}
+
+	/* -ENOENT from try_to_grab_pending() becomes %true. */
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mod_delayed_kthread_work);
+
 /* custom wait for canceling a kthread work */
 struct cktw_wait {
 	wait_queue_t		wait;
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
