From: Petr Mladek <pmladek@suse.com>
Subject: [RFC v2 04/18] kthread: Add destroy_kthread_worker()
Date: Mon, 21 Sep 2015 15:03:45 +0200
Message-ID: <1442840639-6963-5-git-send-email-pmladek@suse.com>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

The current kthread worker users call flush() and stop() explicitly.
The new function will make it easier and will do it better. Also it
frees the kthread_worker struct that has been allocated by
create_kthread_worker().

Note that flush() does not guarantee that the queue is empty. drain()
is more safe. It returns when the queue is really empty. Also it warns
when too many work is being queued when draining.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h |  2 ++
 kernel/kthread.c        | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index e390069a3f68..bef97e06d2b6 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -136,4 +136,6 @@ bool queue_kthread_work(struct kthread_worker *worker,
 void flush_kthread_work(struct kthread_work *work);
 void flush_kthread_worker(struct kthread_worker *worker);
 
+void destroy_kthread_worker(struct kthread_worker *worker);
+
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index e6424cf17cbd..65c263336b8b 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -809,3 +809,23 @@ void drain_kthread_worker(struct kthread_worker *worker)
 	spin_unlock_irq(&worker->lock);
 }
 EXPORT_SYMBOL(drain_kthread_worker);
+
+/**
+ * destroy_kthread_worker - destroy a kthread worker
+ * @worker: worker to be destroyed
+ *
+ * Destroy @worker. It should be idle when this is called.
+ */
+void destroy_kthread_worker(struct kthread_worker *worker)
+{
+	struct task_struct *task;
+
+	task = worker->task;
+	if (WARN_ON(!task))
+		return;
+
+	drain_kthread_worker(worker);
+	kthread_stop(task);
+	kfree(worker);
+}
+EXPORT_SYMBOL(destroy_kthread_worker);
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
