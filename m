From: Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 5/7] locking/rwsem: move down rwsem_down_read_failed function
Date: Sun,  3 Aug 2014 22:36:20 -0400
Message-ID: <1407119782-41119-6-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

Move the rwsem_down_read_failed() function down to below the optimistic
spinning section before enabling optimistic spinning for the readers.
There is no change in code.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |   96 +++++++++++++++++++++---------------------
 1 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 576d4cd..86618ea 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -239,54 +239,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	return sem;
 }
 
-/*
- * Wait for the read lock to be granted
- */
-__visible
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
-{
-	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_READ;
-	get_task_struct(tsk);
-
-	raw_spin_lock_irq(&sem->wait_lock);
-	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
-
-	/* If there are no active locks, wake the front queued process(es).
-	 *
-	 * If there are no writers and we are first in the queue,
-	 * wake our own waiter to join the existing active readers !
-	 */
-	if (count == RWSEM_WAITING_BIAS ||
-	    (count > RWSEM_WAITING_BIAS &&
-	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
-
-	raw_spin_unlock_irq(&sem->wait_lock);
-
-	/* wait to be given the lock */
-	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		if (!waiter.task)
-			break;
-		schedule();
-	}
-
-	tsk->state = TASK_RUNNING;
-
-	return sem;
-}
-
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
 	if (!(count & RWSEM_ACTIVE_MASK)) {
@@ -458,6 +410,54 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 #endif
 
 /*
+ * Wait for the read lock to be granted
+ */
+__visible
+struct rw_semaphore __sched * rwsem_down_read_failed(struct rw_semaphore *sem)
+{
+	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_READ;
+	get_task_struct(tsk);
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we're now waiting on the lock, but no longer actively locking */
+	count = rwsem_atomic_update(adjustment, sem);
+
+	/* If there are no active locks, wake the front queued process(es).
+	 *
+	 * If there are no writers and we are first in the queue,
+	 * wake our own waiter to join the existing active readers !
+	 */
+	if (count == RWSEM_WAITING_BIAS ||
+	    (count > RWSEM_WAITING_BIAS &&
+	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!waiter.task)
+			break;
+		schedule();
+	}
+
+	tsk->state = TASK_RUNNING;
+
+	return sem;
+}
+
+/*
  * Wait until we successfully acquire the write lock
  */
 __visible
-- 
1.7.1
