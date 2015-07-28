From: Petr Mladek <pmladek@suse.com>
Subject: [RFC PATCH 06/14] kthread: Add kthread_worker_created()
Date: Tue, 28 Jul 2015 16:39:23 +0200
Message-ID: <1438094371-8326-7-git-send-email-pmladek@suse.com>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1438094371-8326-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

I would like to make cleaner kthread worker API and hide the definition
of struct kthread_worker. It will prevent any custom hacks and make
the API more secure.

This patch provides an API to check if the worker has been created
and hides the implementation details.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 24d72bac27db..02d3cc9ad923 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -122,6 +122,11 @@ extern void __init_kthread_worker(struct kthread_worker *worker,
 		(work)->func = (fn);					\
 	} while (0)
 
+static inline bool kthread_worker_created(struct kthread_worker *worker)
+{
+	return (worker && worker->task);
+}
+
 int kthread_worker_fn(void *worker_ptr);
 
 __printf(3, 4)
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
