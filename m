From: Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 3/7] locking/rwsem: check for active writer/spinner before wakeup
Date: Sun,  3 Aug 2014 22:36:18 -0400
Message-ID: <1407119782-41119-4-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

On a highly contended rwsem, spinlock contention due to the slow
rwsem_wake() call can be a significant portion of the total CPU cycles
used. With writer lock stealing and writer optimistic spinning, there
is also a pretty good chance that the lock may have been stolen
before the waker wakes up the waiters. The woken tasks, if any,
will have to go back to sleep again.

This patch adds checking code at the beginning of the rwsem_wake()
and __rwsem_do_wake() function to look for spinner and active
writer respectively.  The presence of an active writer will abort the
wakeup operation.  The presence of a spinner will still allow wakeup
operation to proceed as long as the trylock operation succeeds. This
strikes a good balance between excessive spinlock contention especially
when there are a lot of active readers and a lot of failed fastpath
operations because there are tasks waiting in the queue.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/osq_lock.h    |    5 ++++
 kernel/locking/rwsem-xadd.c |   57 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
index 90230d5..79db546 100644
--- a/include/linux/osq_lock.h
+++ b/include/linux/osq_lock.h
@@ -24,4 +24,9 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
 	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
 }
 
+static inline bool osq_has_spinner(struct optimistic_spin_queue *lock)
+{
+	return atomic_read(&lock->tail) != OSQ_UNLOCKED_VAL;
+}
+
 #endif
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dce22b8..9f71a67 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -107,6 +107,37 @@ enum rwsem_wake_type {
 	RWSEM_WAKE_READ_OWNED	/* Waker thread holds the read lock */
 };
 
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+/*
+ * return true if there is an active writer by checking the owner field which
+ * should be set (not RWSEM_READ_OWNED) if there is one.
+ */
+static inline bool rwsem_has_active_writer(struct rw_semaphore *sem)
+{
+	struct task_struct *owner = ACCESS_ONCE(sem->owner);
+
+	return owner && (owner != RWSEM_READ_OWNED);
+}
+
+/*
+ * Return true if the rwsem has active spinner
+ */
+static inline bool rwsem_has_spinner(struct rw_semaphore *sem)
+{
+	return osq_has_spinner(&sem->osq);
+}
+#else /* CONFIG_RWSEM_SPIN_ON_OWNER */
+static inline bool rwsem_has_active_writer(struct rw_semaphore *sem)
+{
+	return false;	/* Assume it has no active writer */
+}
+
+static inline bool rwsem_has_spinner(struct rw_semaphore *sem)
+{
+	return false;
+}
+#endif /* CONFIG_RWSEM_SPIN_ON_OWNER */
+
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -125,6 +156,15 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct list_head *next;
 	long oldcount, woken, loop, adjustment;
 
+	/*
+	 * Abort the wakeup operation if there is an active writer as the
+	 * lock was stolen. up_write() should have cleared the owner field
+	 * before calling this function. If that field is now set, there must
+	 * be an active writer present.
+	 */
+	if (rwsem_has_active_writer(sem))
+		goto out;
+
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
 		if (wake_type == RWSEM_WAKE_ANY)
@@ -479,7 +519,22 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	/*
+	 * If a spinner is present, it is not necessary to do the wakeup.
+	 * Try to do wakeup when the trylock succeeds to avoid potential
+	 * spinlock contention which may introduce too much delay in the
+	 * unlock operation.
+	 *
+	 * In case the spinning writer is just going to break out of the loop,
+	 * it will still do a trylock in rwsem_down_write_failed() before
+	 * sleeping.
+	 */
+	if (rwsem_has_spinner(sem)) {
+		if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
+			return sem;
+	} else {
+		raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	}
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-- 
1.7.1
