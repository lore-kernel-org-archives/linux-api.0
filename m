From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] workqueue: Replace pool->attach_mutex with global wq_pool_attach_mutex
Date: Wed, 16 May 2018 21:34:44 -0700
Message-ID: <20180517043448.3152269-3-tj@kernel.org>
References: <20180517043448.3152269-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517043448.3152269-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jiangshanlai@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, csmall@enc.com.au, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

To improve workqueue visibility, we want to be able to access
workqueue information from worker tasks.  The per-pool attach mutex
makes that difficult because there's no way of stabilizing task ->
worker pool association without knowing the pool first.

Worker attach/detach is a slow path and there's no need for different
pools to be able to perform them concurrently.  This patch replaces
the per-pool attach_mutex with global wq_pool_attach_mutex to prepare
for visibility improvement changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ca7959b..91fe0a6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,7 +66,7 @@ enum {
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
-	 * attach_mutex to avoid changing binding state while
+	 * wq_pool_attach_mutex to avoid changing binding state while
 	 * worker_attach_to_pool() is in progress.
 	 */
 	POOL_MANAGER_ACTIVE	= 1 << 0,	/* being managed */
@@ -123,7 +123,7 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * A: pool->attach_mutex protected.
+ * A: wq_pool_attach_mutex protected.
  *
  * PL: wq_pool_mutex protected.
  *
@@ -166,7 +166,6 @@ struct worker_pool {
 						/* L: hash of busy workers */
 
 	struct worker		*manager;	/* L: purely informational */
-	struct mutex		attach_mutex;	/* attach/detach exclusion */
 	struct list_head	workers;	/* A: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
 
@@ -297,6 +296,7 @@ static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
 
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
+static DEFINE_MUTEX(wq_pool_attach_mutex); /* protects worker attach/detach */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static DECLARE_WAIT_QUEUE_HEAD(wq_manager_wait); /* wait for manager to go away */
 
@@ -399,14 +399,14 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
  * @worker: iteration cursor
  * @pool: worker_pool to iterate workers of
  *
- * This must be called with @pool->attach_mutex.
+ * This must be called with wq_pool_attach_mutex.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool_worker(worker, pool)				\
 	list_for_each_entry((worker), &(pool)->workers, node)		\
-		if (({ lockdep_assert_held(&pool->attach_mutex); false; })) { } \
+		if (({ lockdep_assert_held(&wq_pool_attach_mutex); false; })) { } \
 		else
 
 /**
@@ -1724,7 +1724,7 @@ static struct worker *alloc_worker(int node)
 static void worker_attach_to_pool(struct worker *worker,
 				   struct worker_pool *pool)
 {
-	mutex_lock(&pool->attach_mutex);
+	mutex_lock(&wq_pool_attach_mutex);
 
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
@@ -1733,16 +1733,16 @@ static void worker_attach_to_pool(struct worker *worker,
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * The pool->attach_mutex ensures %POOL_DISASSOCIATED remains
-	 * stable across this function.  See the comments above the
-	 * flag definition for details.
+	 * The wq_pool_attach_mutex ensures %POOL_DISASSOCIATED remains
+	 * stable across this function.  See the comments above the flag
+	 * definition for details.
 	 */
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
 	list_add_tail(&worker->node, &pool->workers);
 
-	mutex_unlock(&pool->attach_mutex);
+	mutex_unlock(&wq_pool_attach_mutex);
 }
 
 /**
@@ -1759,11 +1759,11 @@ static void worker_detach_from_pool(struct worker *worker,
 {
 	struct completion *detach_completion = NULL;
 
-	mutex_lock(&pool->attach_mutex);
+	mutex_lock(&wq_pool_attach_mutex);
 	list_del(&worker->node);
 	if (list_empty(&pool->workers))
 		detach_completion = pool->detach_completion;
-	mutex_unlock(&pool->attach_mutex);
+	mutex_unlock(&wq_pool_attach_mutex);
 
 	/* clear leftover flags without pool->lock after it is detached */
 	worker->flags &= ~(WORKER_UNBOUND | WORKER_REBOUND);
@@ -3271,7 +3271,6 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	timer_setup(&pool->mayday_timer, pool_mayday_timeout, 0);
 
-	mutex_init(&pool->attach_mutex);
 	INIT_LIST_HEAD(&pool->workers);
 
 	ida_init(&pool->worker_ida);
@@ -3354,10 +3353,10 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
 
-	mutex_lock(&pool->attach_mutex);
+	mutex_lock(&wq_pool_attach_mutex);
 	if (!list_empty(&pool->workers))
 		pool->detach_completion = &detach_completion;
-	mutex_unlock(&pool->attach_mutex);
+	mutex_unlock(&wq_pool_attach_mutex);
 
 	if (pool->detach_completion)
 		wait_for_completion(pool->detach_completion);
@@ -4600,7 +4599,7 @@ static void unbind_workers(int cpu)
 	struct worker *worker;
 
 	for_each_cpu_worker_pool(pool, cpu) {
-		mutex_lock(&pool->attach_mutex);
+		mutex_lock(&wq_pool_attach_mutex);
 		spin_lock_irq(&pool->lock);
 
 		/*
@@ -4616,7 +4615,7 @@ static void unbind_workers(int cpu)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->attach_mutex);
+		mutex_unlock(&wq_pool_attach_mutex);
 
 		/*
 		 * Call schedule() so that we cross rq->lock and thus can
@@ -4657,7 +4656,7 @@ static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->attach_mutex);
+	lockdep_assert_held(&wq_pool_attach_mutex);
 
 	/*
 	 * Restore CPU affinity of all workers.  As all idle workers should
@@ -4727,7 +4726,7 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
 	static cpumask_t cpumask;
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->attach_mutex);
+	lockdep_assert_held(&wq_pool_attach_mutex);
 
 	/* is @cpu allowed for @pool? */
 	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
@@ -4762,14 +4761,14 @@ int workqueue_online_cpu(unsigned int cpu)
 	mutex_lock(&wq_pool_mutex);
 
 	for_each_pool(pool, pi) {
-		mutex_lock(&pool->attach_mutex);
+		mutex_lock(&wq_pool_attach_mutex);
 
 		if (pool->cpu == cpu)
 			rebind_workers(pool);
 		else if (pool->cpu < 0)
 			restore_unbound_workers_cpumask(pool, cpu);
 
-		mutex_unlock(&pool->attach_mutex);
+		mutex_unlock(&wq_pool_attach_mutex);
 	}
 
 	/* update NUMA affinity of unbound workqueues */
-- 
2.9.5
