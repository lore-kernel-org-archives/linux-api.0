From: Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 4/7] locking/rwsem: threshold limited spinning for active readers
Date: Sun,  3 Aug 2014 22:36:19 -0400
Message-ID: <1407119782-41119-5-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

Even thought only the writers can perform optimistic spinning, there
is still a chance that readers may take the lock before a spinning
writer can get it. In that case, the owner field will be NULL and the
spinning writer can spin indefinitely until its time quantum expires
when some lock owning readers are not running.

This patch tries to handle this special case by:
 1) setting the owner field to a special value RWSEM_READ_OWNED
    to indicate that the current or last owner is a reader.
 2) seting a threshold on how many times (currently 100) spinning will
    be done with active readers before giving up as there is no easy
    way to determine if all of them are currently running.

By doing so, it tries to strike a balance between giving up too early
and losing potential performance gain and wasting too many precious
CPU cycles when some lock owning readers are not running.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/rwsem.h       |    7 +++++++
 kernel/locking/rwsem-xadd.c |   23 ++++++++++++++++++++---
 kernel/locking/rwsem.c      |   17 ++++++++++++++++-
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 035d3c5..48e1e31 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -66,6 +66,13 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #endif
 
 #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+/*
+ * The owner field is set to RWSEM_READ_OWNED if the last owner(s) are
+ * readers. It is not reset until a writer takes over and set it to its
+ * task structure pointer or NULL when it frees the lock. So a value
+ * of RWSEM_READ_OWNED doesn't mean it currently has active readers.
+ */
+#define RWSEM_READ_OWNED	((struct task_struct *)-1)
 #define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
 #else
 #define __RWSEM_OPT_INIT(lockname)
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 9f71a67..576d4cd 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -304,6 +304,11 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 
 #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
+ * Threshold for optimistic spinning on readers
+ */
+#define RWSEM_READ_SPIN_THRESHOLD	100
+
+/*
  * Try to acquire write lock before the writer has been put on wait queue.
  */
 static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
@@ -332,7 +337,7 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(sem->owner);
-	if (owner)
+	if (owner && (owner != RWSEM_READ_OWNED))
 		on_cpu = owner->on_cpu;
 	rcu_read_unlock();
 
@@ -381,10 +386,17 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
 	return sem->owner == NULL;
 }
 
+/*
+ * With active writer, spinning is done by checking if that writer is on
+ * CPU. With active readers, there is no easy way to determine if all of
+ * them are active. So it fall back to spin a certain number of them
+ * RWSEM_READ_SPIN_THRESHOLD before giving up.
+ */
 static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
 	bool taken = false;
+	int  read_spincnt = 0;
 
 	preempt_disable();
 
@@ -397,8 +409,12 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 
 	while (true) {
 		owner = ACCESS_ONCE(sem->owner);
-		if (owner && !rwsem_spin_on_owner(sem, owner))
+		if (owner == RWSEM_READ_OWNED) {
+			if (++read_spincnt > RWSEM_READ_SPIN_THRESHOLD)
+				break;
+		} else if (owner && !rwsem_spin_on_owner(sem, owner)) {
 			break;
+		}
 
 		/* wait_lock will be acquired if write_lock is obtained */
 		if (rwsem_try_write_lock_unqueued(sem)) {
@@ -412,7 +428,8 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 		 * we're an RT task that will live-lock because we won't let
 		 * the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(current)))
+		if ((!owner || (owner == RWSEM_READ_OWNED)) &&
+		    (need_resched() || rt_task(current)))
 			break;
 
 		/*
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index e2d3bc7..9770439 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -18,6 +18,11 @@ static inline void rwsem_set_owner(struct rw_semaphore *sem)
 	sem->owner = current;
 }
 
+static inline void rwsem_set_owner_read(struct rw_semaphore *sem)
+{
+	sem->owner = RWSEM_READ_OWNED;
+}
+
 static inline void rwsem_clear_owner(struct rw_semaphore *sem)
 {
 	sem->owner = NULL;
@@ -28,6 +33,10 @@ static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
 }
 
+static inline void rwsem_set_owner_read(struct rw_semaphore *sem)
+{
+}
+
 static inline void rwsem_clear_owner(struct rw_semaphore *sem)
 {
 }
@@ -42,6 +51,7 @@ void __sched down_read(struct rw_semaphore *sem)
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	rwsem_set_owner_read(sem);
 }
 
 EXPORT_SYMBOL(down_read);
@@ -53,8 +63,10 @@ int down_read_trylock(struct rw_semaphore *sem)
 {
 	int ret = __down_read_trylock(sem);
 
-	if (ret == 1)
+	if (ret == 1) {
 		rwsem_acquire_read(&sem->dep_map, 0, 1, _RET_IP_);
+		rwsem_set_owner_read(sem);
+	}
 	return ret;
 }
 
@@ -127,6 +139,7 @@ void downgrade_write(struct rw_semaphore *sem)
 	 */
 	rwsem_clear_owner(sem);
 	__downgrade_write(sem);
+	rwsem_set_owner_read(sem);
 }
 
 EXPORT_SYMBOL(downgrade_write);
@@ -139,6 +152,7 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
+	rwsem_set_owner_read(sem);
 }
 
 EXPORT_SYMBOL(down_read_nested);
@@ -159,6 +173,7 @@ void down_read_non_owner(struct rw_semaphore *sem)
 	might_sleep();
 
 	__down_read(sem);
+	rwsem_set_owner_read(sem);
 }
 
 EXPORT_SYMBOL(down_read_non_owner);
-- 
1.7.1

