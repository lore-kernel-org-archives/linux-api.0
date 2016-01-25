From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 12/22] kthread: Use try_lock_kthread_work() in flush_kthread_work()
Date: Mon, 25 Jan 2016 16:45:01 +0100
Message-ID: <1453736711-6703-13-git-send-email-pmladek@suse.com>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1453736711-6703-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

Remove code duplication and use the new try_lock_kthread_work()
function in flush_kthread_work() as well.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/kthread.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 53c4d5a7c723..7193582fe299 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -956,16 +956,12 @@ void flush_kthread_work(struct kthread_work *work)
 	struct kthread_worker *worker;
 	bool noop = false;
 
-retry:
-	worker = work->worker;
-	if (!worker)
+	local_irq_disable();
+	if (!try_lock_kthread_work(work, false)) {
+		local_irq_enable();
 		return;
-
-	spin_lock_irq(&worker->lock);
-	if (work->worker != worker) {
-		spin_unlock_irq(&worker->lock);
-		goto retry;
 	}
+	worker = work->worker;
 
 	if (!list_empty(&work->node))
 		insert_kthread_work(worker, &fwork.work, work->node.next);
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
