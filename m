From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v5 03/20] kthread: Add create_kthread_worker*()
Date: Wed, 24 Feb 2016 16:56:24 +0100
Message-ID: <20160224155624.GZ3305@pathway.suse.cz>
References: <1456153030-12400-4-git-send-email-pmladek@suse.com>
 <201602222335.d3Pey8SI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <201602222335.d3Pey8SI%fengguang.wu@intel.com>
Sender: owner-linux-mm@kvack.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2016-02-22 23:48:53, kbuild test robot wrote:
> Hi Petr,
> 
> [auto build test ERROR on soc-thermal/next]
> [also build test ERROR on v4.5-rc5 next-20160222]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Petr-Mladek/kthread-Use-kthread-worker-API-more-widely/20160222-230250
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal next
> config: xtensa-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    kernel/kthread.c: In function 'create_kthread_worker_on_cpu':
> >> kernel/kthread.c:691:9: error: incompatible type for argument 3 of '__create_kthread_worker'
>      return __create_kthread_worker(cpu, namefmt, NULL);
>             ^
>    kernel/kthread.c:622:1: note: expected 'va_list' but argument is of type 'void *'
>     __create_kthread_worker(int cpu, const char namefmt[], va_list args)
>     ^
> >> kernel/kthread.c:692:1: warning: control reaches end of non-void function [-Wreturn-type]
>     }
>     ^
> 
> vim +/__create_kthread_worker +691 kernel/kthread.c
> 
>    685	 * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
>    686	 * when the worker was SIGKILLed.
>    687	 */
>    688	struct kthread_worker *
>    689	create_kthread_worker_on_cpu(int cpu, const char namefmt[])
>    690	{
>  > 691		return __create_kthread_worker(cpu, namefmt, NULL);
>  > 692	}
>    693	EXPORT_SYMBOL(create_kthread_worker_on_cpu);
>    694	
>    695	/* insert @work before @pos in @worker */

I can be fixed by passing a fake va_list. It is not used when
__create_kthread_worker() is called with a valid CPU number.

See below an updated patch that passes the build.


>From 5e6c252921c0370a88d2ce5f61370fef573afcaa Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Tue, 23 Jun 2015 17:09:19 +0200
Subject: [PATCH 3/3] kthread: Add create_kthread_worker*()

Kthread workers are currently created using the classic kthread API,
namely kthread_run(). kthread_worker_fn() is passed as the @threadfn
parameter.

This patch defines create_kthread_worker() and
create_kthread_worker_on_cpu() functions that hide implementation details.

They enforce using kthread_worker_fn() for the main thread. But I doubt
that there are any plans to create any alternative. In fact, I think
that we do not want any alternative main thread because it would be
hard to support consistency with the rest of the kthread worker API.

The naming and function is inspired by the workqueues API like the rest
of the kthread worker API.

Note that we need to bind per-CPU kthread workers already when they are
created. It makes the life easier. kthread_bind() could not be used later
for an already running worker.

This patch does _not_ convert existing kthread workers. The kthread worker
API need more improvements first, e.g. a function to destroy the worker.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h |  7 ++++
 kernel/kthread.c        | 97 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 94 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index e691b6a23f72..943900c7ce35 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -124,6 +124,13 @@ extern void __init_kthread_worker(struct kthread_worker *worker,
 
 int kthread_worker_fn(void *worker_ptr);
 
+__printf(1, 2)
+struct kthread_worker *
+create_kthread_worker(const char namefmt[], ...);
+
+struct kthread_worker *
+create_kthread_worker_on_cpu(int cpu, const char namefmt[]);
+
 bool queue_kthread_work(struct kthread_worker *worker,
 			struct kthread_work *work);
 void flush_kthread_work(struct kthread_work *work);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index bfe8742c4217..cd46276f2690 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -567,23 +567,24 @@ EXPORT_SYMBOL_GPL(__init_kthread_worker);
  * kthread_worker_fn - kthread function to process kthread_worker
  * @worker_ptr: pointer to initialized kthread_worker
  *
- * This function can be used as @threadfn to kthread_create() or
- * kthread_run() with @worker_ptr argument pointing to an initialized
- * kthread_worker.  The started kthread will process work_list until
- * the it is stopped with kthread_stop().  A kthread can also call
- * this function directly after extra initialization.
+ * This function implements the main cycle of kthread worker. It processes
+ * work_list until it is stopped with kthread_stop(). It sleeps when the queue
+ * is empty.
  *
- * Different kthreads can be used for the same kthread_worker as long
- * as there's only one kthread attached to it at any given time.  A
- * kthread_worker without an attached kthread simply collects queued
- * kthread_works.
+ * The works are not allowed to keep any locks, disable preemption or interrupts
+ * when they finish. There is defined a safe point for freezing when one work
+ * finishes and before a new one is started.
  */
 int kthread_worker_fn(void *worker_ptr)
 {
 	struct kthread_worker *worker = worker_ptr;
 	struct kthread_work *work;
 
-	WARN_ON(worker->task);
+	/*
+	 * FIXME: Update the check and remove the assignment when all kthread
+	 * worker users are created using create_kthread_worker*() functions.
+	 */
+	WARN_ON(worker->task && worker->task != current);
 	worker->task = current;
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
@@ -617,6 +618,82 @@ repeat:
 }
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
+static struct kthread_worker *
+__create_kthread_worker(int cpu, const char namefmt[], va_list args)
+{
+	struct kthread_worker *worker;
+	struct task_struct *task;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (!worker)
+		return ERR_PTR(-ENOMEM);
+
+	init_kthread_worker(worker);
+
+	if (cpu >= 0)
+		task = kthread_create_on_cpu(kthread_worker_fn, worker,
+					     cpu, namefmt);
+	else
+		task = __kthread_create_on_node(kthread_worker_fn, worker,
+						-1, namefmt, args);
+	if (IS_ERR(task))
+		goto fail_task;
+
+	worker->task = task;
+	wake_up_process(task);
+	return worker;
+
+fail_task:
+	kfree(worker);
+	return ERR_CAST(task);
+}
+
+/**
+ * create_kthread_worker - create a kthread worker
+ * @namefmt: printf-style name for the kthread worker (task).
+ *
+ * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
+ * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
+ * when the worker was SIGKILLed.
+ */
+struct kthread_worker *
+create_kthread_worker(const char namefmt[], ...)
+{
+	struct kthread_worker *worker;
+	va_list args;
+
+	va_start(args, namefmt);
+	worker = __create_kthread_worker(-1, namefmt, args);
+	va_end(args);
+
+	return worker;
+}
+EXPORT_SYMBOL(create_kthread_worker);
+
+/**
+ * create_kthread_worker_on_cpu - create a kthread worker and bind it
+ *	it to a given CPU and the associated NUMA node.
+ * @cpu: CPU number
+ * @namefmt: printf-style name for the kthread worker (task).
+ *
+ * Use a valid CPU number if you want to bind the kthread worker
+ * to the given CPU and the associated NUMA node.
+ *
+ * @namefmt might include one "%d" that will get replaced by CPU number.
+ *
+ * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
+ * when the needed structures could not get allocated, and ERR_PTR(-EINTR)
+ * when the worker was SIGKILLed.
+ */
+struct kthread_worker *
+create_kthread_worker_on_cpu(int cpu, const char namefmt[])
+{
+	va_list fake_args;
+
+	return __create_kthread_worker(cpu, namefmt, fake_args);
+}
+EXPORT_SYMBOL(create_kthread_worker_on_cpu);
+
 /* insert @work before @pos in @worker */
 static void insert_kthread_work(struct kthread_worker *worker,
 			       struct kthread_work *work,
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
