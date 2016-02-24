From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v5 10/20] kthread: Better support freezable kthread
 workers
Date: Wed, 24 Feb 2016 17:25:52 +0100
Message-ID: <20160224162552.GC3305@pathway.suse.cz>
References: <1456153030-12400-11-git-send-email-pmladek@suse.com>
 <201602230123.XPAUOgW6%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <201602230123.XPAUOgW6%fengguang.wu@intel.com>
Sender: owner-linux-mm@kvack.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 2016-02-23 01:33:12, kbuild test robot wrote:
> Hi Petr,
> 
> [auto build test WARNING on soc-thermal/next]
> [also build test WARNING on v4.5-rc5 next-20160222]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Petr-Mladek/kthread-Use-kthread-worker-API-more-widely/20160222-230250
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal next
> reproduce: make htmldocs
> 
> All warnings (new ones prefixed by >>):
> 
>    include/linux/init.h:1: warning: no structured comments found
> >> kernel/kthread.c:671: warning: No description found for parameter 'flags'
>    kernel/kthread.c:700: warning: No description found for parameter 'flags'

Please find below an updated version of the patch that fixes the above
warnings:


>From 66fbe9142d4761a7010a73eeb69ef315053684cb Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Mon, 22 Jun 2015 15:05:16 +0200
Subject: [PATCH 10/10] kthread: Better support freezable kthread workers

This patch allows to make kthread worker freezable via a new @flags
parameter. It will allow to avoid an init work in some kthreads.

It currently does not affect the function of kthread_worker_fn()
but it might help to do some optimization or fixes eventually.

I currently do not know about any other use for the @flags
parameter but I believe that we will want more flags
in the future.

Finally, I hope that it will not cause confusion with @flags member
in struct kthread. Well, I guess that we will want to rework the
basic kthreads implementation once all kthreads are converted into
kthread workers or workqueues. It is possible that we will merge
the two structures.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/kthread.h | 11 ++++++++---
 kernel/kthread.c        | 20 ++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 531730f8a8a7..b57786c40c2c 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -65,7 +65,12 @@ struct kthread_work;
 typedef void (*kthread_work_func_t)(struct kthread_work *work);
 void delayed_kthread_work_timer_fn(unsigned long __data);
 
+enum {
+	KTW_FREEZABLE		= 1 << 2,	/* freeze during suspend */
+};
+
 struct kthread_worker {
+	unsigned int		flags;
 	spinlock_t		lock;
 	struct list_head	work_list;
 	struct list_head	delayed_work_list;
@@ -154,12 +159,12 @@ extern void __init_kthread_worker(struct kthread_worker *worker,
 
 int kthread_worker_fn(void *worker_ptr);
 
-__printf(1, 2)
+__printf(2, 3)
 struct kthread_worker *
-create_kthread_worker(const char namefmt[], ...);
+create_kthread_worker(unsigned int flags, const char namefmt[], ...);
 
 struct kthread_worker *
-create_kthread_worker_on_cpu(int cpu, const char namefmt[]);
+create_kthread_worker_on_cpu(int cpu, unsigned int flags, const char namefmt[]);
 
 bool queue_kthread_work(struct kthread_worker *worker,
 			struct kthread_work *work);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 43b46daafb4d..4450474301c7 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -556,11 +556,11 @@ void __init_kthread_worker(struct kthread_worker *worker,
 				const char *name,
 				struct lock_class_key *key)
 {
+	memset(worker, 0, sizeof(struct kthread_worker));
 	spin_lock_init(&worker->lock);
 	lockdep_set_class_and_name(&worker->lock, key, name);
 	INIT_LIST_HEAD(&worker->work_list);
 	INIT_LIST_HEAD(&worker->delayed_work_list);
-	worker->task = NULL;
 }
 EXPORT_SYMBOL_GPL(__init_kthread_worker);
 
@@ -590,6 +590,10 @@ int kthread_worker_fn(void *worker_ptr)
 	 */
 	WARN_ON(worker->task && worker->task != current);
 	worker->task = current;
+
+	if (worker->flags & KTW_FREEZABLE)
+		set_freezable();
+
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
 
@@ -623,7 +627,8 @@ repeat:
 EXPORT_SYMBOL_GPL(kthread_worker_fn);
 
 static struct kthread_worker *
-__create_kthread_worker(int cpu, const char namefmt[], va_list args)
+__create_kthread_worker(int cpu, unsigned int flags,
+			const char namefmt[], va_list args)
 {
 	struct kthread_worker *worker;
 	struct task_struct *task;
@@ -643,6 +648,7 @@ __create_kthread_worker(int cpu, const char namefmt[], va_list args)
 	if (IS_ERR(task))
 		goto fail_task;
 
+	worker->flags = flags;
 	worker->task = task;
 	wake_up_process(task);
 	return worker;
@@ -654,6 +660,7 @@ fail_task:
 
 /**
  * create_kthread_worker - create a kthread worker
+ * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
  * Returns a pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
@@ -661,13 +668,13 @@ fail_task:
  * when the worker was SIGKILLed.
  */
 struct kthread_worker *
-create_kthread_worker(const char namefmt[], ...)
+create_kthread_worker(unsigned int flags, const char namefmt[], ...)
 {
 	struct kthread_worker *worker;
 	va_list args;
 
 	va_start(args, namefmt);
-	worker = __create_kthread_worker(-1, namefmt, args);
+	worker = __create_kthread_worker(-1, flags, namefmt, args);
 	va_end(args);
 
 	return worker;
@@ -678,6 +685,7 @@ EXPORT_SYMBOL(create_kthread_worker);
  * create_kthread_worker_on_cpu - create a kthread worker and bind it
  *	it to a given CPU and the associated NUMA node.
  * @cpu: CPU number
+ * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
  *
  * Use a valid CPU number if you want to bind the kthread worker
@@ -690,11 +698,11 @@ EXPORT_SYMBOL(create_kthread_worker);
  * when the worker was SIGKILLed.
  */
 struct kthread_worker *
-create_kthread_worker_on_cpu(int cpu, const char namefmt[])
+create_kthread_worker_on_cpu(int cpu, unsigned int flags, const char namefmt[])
 {
 	va_list fake_args;
 
-	return __create_kthread_worker(cpu, namefmt, fake_args);
+	return __create_kthread_worker(cpu, flags, namefmt, fake_args);
 }
 EXPORT_SYMBOL(create_kthread_worker_on_cpu);
 
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
