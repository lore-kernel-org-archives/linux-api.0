From: Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 1/5] futex: add new exclusive lock & unlock command codes
Date: Mon, 21 Jul 2014 11:24:27 -0400
Message-ID: <1405956271-34339-2-git-send-email-Waiman.Long@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

This patch adds two new simple exclusive lock and unlock primitives
or command codes (FUTEX_SPIN_LOCK and FUTEX_SPIN_UNLOCK) to provide
to the users of the futex(2) syscall. These two primitives provide
an abstract for a mutual exclusive lock (mutex).

The semantics is about the same as the PI and robust futexes where
a locker atomically puts its thread ID into the futex word to get
lock and clear it to free the lock.

The major differences between the new primitives and the existing
ones are on how the waiters are enqueued into the waiting queue. The
existing primitives use a priority list to store the waiting tasks
from all the futexes that hashed to the same hash bucket.

The new primitives use two different lists. The first list off the
hash bucket is to store a new dynamically allocated data structure
(futex_q_head) that contains information about all the waiters for
a given futex.  So if two futexes hash to the same bucket, the list
will have 2 entries irrespective of the number of tasks contending
the futexes.

The second list is in the futex_q_head contains all the waiters
waiting for the futex to be freed. There are also 2 spinlocks used -
one in the hash bucket and one in the futex_q_head structure.

The main advantages of the 2-list approach is to reduce the amount of
spinlock contention that can happen to a heavily contended futex. It
is not unusually that over 90% of CPU cycles can be spent in the
lock spinning for a heavily contended futex. By making the lock more
granular, the spinlock contention can be reduced.

The disadvantage, however, is the need to dynamically allocate the new
structure. To reduce that overhead, a single-slot cache entry is added
to the futex hash bucket structure to hold a single free futex_q_head
structure. So as long as there is no futex address collision, the futex
code doesn't need to do a lot of memory allocation and deallocation.

With the new primitives, a simple 256-thread mutex micro-benchmark
on a 4-socket 40-core system gave the following perf profile:

   6.19%  futex_test  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
   5.17%  futex_test  [kernel.kallsyms]   [k] futex_spin_lock
   3.87%  futex_test  [kernel.kallsyms]   [k] _raw_spin_lock
   2.72%  futex_test  [kernel.kallsyms]   [k] drop_futex_key_refs
   2.46%  futex_test  [kernel.kallsyms]   [k] futex_spin_unlock
   2.36%  futex_test  [kernel.kallsyms]   [k] gup_pte_range
   1.87%  futex_test  [kernel.kallsyms]   [k] get_user_pages_fast
   1.84%  futex_test  [kernel.kallsyms]   [k] __audit_syscall_exit

The corresponding one with the wait-wake futex was as follows:

  93.52%  futex_test  [kernel.kallsyms]   [k] _raw_spin_lock
   1.14%  futex_test  [kernel.kallsyms]   [k] futex_wait_setup
   0.97%  futex_test  [kernel.kallsyms]   [k] futex_wake

In term of the reported system time used on a 10 million mutex
operations, the new primitives used only 12.7s while the old ones
needed 104.4s.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/uapi/linux/futex.h |    4 +
 kernel/futex.c             |  453 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 457 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index 0b1f716..58aa4fb 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -20,6 +20,8 @@
 #define FUTEX_WAKE_BITSET	10
 #define FUTEX_WAIT_REQUEUE_PI	11
 #define FUTEX_CMP_REQUEUE_PI	12
+#define FUTEX_SPIN_LOCK		13
+#define FUTEX_SPIN_UNLOCK	14
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -39,6 +41,8 @@
 					 FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
+#define FUTEX_SPIN_LOCK_PRIVATE		(FUTEX_SPIN_LOCK | FUTEX_PRIVATE_FLAG)
+#define FUTEX_SPIN_UNLOCK_PRIVATE	(FUTEX_SPIN_UNLOCK | FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
diff --git a/kernel/futex.c b/kernel/futex.c
index b632b5f..ec9b6ee 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -23,6 +23,9 @@
  *  Copyright (C) IBM Corporation, 2009
  *  Thanks to Thomas Gleixner for conceptual design and careful reviews.
  *
+ *  Optimistic-spinning futexes by Waiman Long
+ *  Copyright (C) 2014 Hewlett-Packard Development Company, L.P.
+ *
  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
  *  enough at me, Linus for the original (flawed) idea, Matthew
  *  Kirkwood for proof-of-concept implementation.
@@ -253,6 +256,8 @@ struct futex_hash_bucket {
 	atomic_t waiters;
 	spinlock_t lock;
 	struct plist_head chain;
+	struct list_head oslist;	/* Optimistic spinning list */
+	void *qhcache;			/* Cache for a free queue head */
 } ____cacheline_aligned_in_smp;
 
 static unsigned long __read_mostly futex_hashsize;
@@ -2939,6 +2944,446 @@ void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
+/*=========================================
+ *	Optimistic Spinning Futexes
+ *=========================================
+ *
+ * A major difference between the optimistic spinning (optspin) futex and a
+ * wait-wake futex is the fact we need a central data structure to hold
+ * information on all the spinning and waiting tasks for a given optspin
+ * futex. We can't use the futex_q structure for that purpose. Instead,
+ * we have to dynamically allocate a new futex_q_head structure to hold that
+ * information.
+ *
+ * To ease implementation, these new futex_q_head structures are queued in a
+ * different list within the futex hash bucket. To reduce the memory allocation
+ * and deallocation overhead, another field is added to the hash bucket to
+ * cache the last freed futex_q_head structure. This improves performance
+ * at the expense of a bit higher memory overhead. As long as there is no futex
+ * address hash collision, there is no need to do a lot of memory allocation
+ * and deallocation for using optspin futex.
+ *
+ * The states of each spinning or waiting task are stored in a futex_q_node
+ * structure allocated from the task's kernel stack, just like futex_q.
+ *
+ * Data structure diagram:
+ *
+ * hash	       futex	    futex
+ * table       qhead 0      qhead 1
+ * |    |
+ * +----+     +------+     +------+
+ * | p  |---->| next |---->| next |----> ....
+ * +----+     +------+     +------+
+ * |    |        |            |
+ *               |
+ *            +------+     +------+
+ *            |node 0|---->|node 1|----> ....
+ *            +------+     +------+
+ *
+ * Locking
+ * -------
+ * Two spinlocks are used by the optspin futexes - the hash bucket spinlock
+ * and the queue head spinlock.
+ *
+ * The hash bucket spinlock protects against the searching and modification
+ * of the futex queue head list as well as the increment of the atomic locker
+ * count. The decrement of locker count is done outside the lock. When the
+ * count reaches 0, the queue head structure can then be deallocated.
+ *
+ * The queue head spinlock protects the futex wait queue from modification.
+ */
+#define FUTEX_TID(u)		(pid_t)((u) & FUTEX_TID_MASK)
+#define FUTEX_HAS_WAITERS(u)	((u) & FUTEX_WAITERS)
+
+/**
+ * struct futex_q_head - head of the optspin futex queue, one per unique key
+ * @hnode:	list entry from the hash bucket
+ * @waitq:	a list of waiting tasks
+ * @key:	the key the futex is hashed on
+ * @wlock:	spinlock for managing wait queue
+ * @lcnt:	locker count
+ *
+ * Locking sequence
+ * ----------------
+ * 1) Lock hash bucket spinlock, locate the futex queue head
+ * 2) Inc lcnt (lock) or read lcnt (unlock), release hash bucket spinlock
+ * 3) For waiter:
+ *    - lock futex queue head spinlock
+ *    - enqueue into the wait queue
+ *    - release the lock & sleep
+ * 4) For unlocker:
+ *    - locate the queue head just like a locker does
+ *    - Take the queue head lock and wake up the first waiter there.
+ */
+struct futex_q_head {
+	struct list_head	      hnode;
+	struct list_head	      waitq;
+	union futex_key		      key;
+	pid_t			      otid;
+	spinlock_t		      wlock;
+	atomic_t		      lcnt;
+};
+
+/**
+ * struct futex_q_node - a node in the optspin futex queue
+ * @wnode:	a list entry for the waiting queue
+ * @task:	task_struct pointer of the current task
+ */
+struct futex_q_node {
+	struct list_head	wnode;
+	struct task_struct     *task;
+};
+
+
+/*
+ * find_qhead - Find a queue head structure with the matching key
+ *
+ * The caller must hold the hash bucket spinlock.
+ */
+static inline struct futex_q_head *
+find_qhead(struct futex_hash_bucket *hb, union futex_key *key)
+{
+	struct futex_q_head *qh;
+
+	list_for_each_entry(qh, &hb->oslist, hnode)
+		if (match_futex(&qh->key, key))
+			return qh;
+	return NULL;
+}
+
+/*
+ * qhead_alloc_init - allocate and initialize a queue head structure.
+ *
+ * The caller must hold the hash bucket spinlock.
+ *
+ * A one-slot queue head structure cache is added to the futex hash bucket
+ * to minimize overhead due to memory allocation and deallocation under light
+ * contention with no hash bucket collision.
+ */
+static inline struct futex_q_head *
+qhead_alloc_init(struct futex_hash_bucket *hb, union futex_key *key)
+{
+	struct futex_q_head *qh = NULL;
+	static const struct futex_q_head qh0 = { { 0 } };
+
+	if (hb->qhcache)
+		qh = xchg(&hb->qhcache, NULL);
+	if (!qh)
+		qh = kmalloc(sizeof(struct futex_q_head), GFP_KERNEL);
+
+	/*
+	 * Initialize the queue head structure
+	 */
+	if (qh) {
+		*qh = qh0;
+		qh->key = *key;
+		atomic_set(&qh->lcnt, 1);
+		INIT_LIST_HEAD(&qh->waitq);
+		spin_lock_init(&qh->wlock);
+		list_add(&qh->hnode, &hb->oslist);
+	}
+	return qh;
+}
+
+/*
+ * free_qhead - put queue head structure back to the free qh cache or free it
+ */
+static inline void
+qhead_free(struct futex_q_head *qh, struct futex_hash_bucket *hb)
+{
+	bool found;
+	struct futex_q_head *qhead;
+
+	/*
+	 * Try to free the queue head structure if no one is using it
+	 * Must take the hash bucket lock to make sure that no one
+	 * else is touching the locker count.
+	 */
+	spin_lock(&hb->lock);
+
+	/*
+	 * First make sure that qh is still there and unused in the
+	 * hashed list.
+	 */
+	found = false;
+	list_for_each_entry(qhead, &hb->oslist, hnode)
+		if (qhead == qh) {
+			found = true;
+			break;
+		}
+
+	if (!found || atomic_read(&qh->lcnt)) {
+		spin_unlock(&hb->lock);
+		return;
+	}
+
+	/*
+	 * Free the queue head structure
+	 */
+	BUG_ON(!list_empty(&qh->waitq));
+	list_del(&qh->hnode);
+	spin_unlock(&hb->lock);
+
+	if (!hb->qhcache && (cmpxchg(&hb->qhcache, NULL, qh) == NULL))
+		return;
+	kfree(qh);
+}
+
+/*
+ * futex_spin_trylock - attempt to take the lock
+ * Return: 1 if successful or an error happen
+ *	   0 otherwise
+ *
+ * Side effect: The uval and ret will be updated.
+ */
+static inline int futex_spin_trylock(u32 __user *uaddr, u32 *puval,
+				       int *pret, u32 vpid)
+{
+	u32	  old;
+
+	*pret = get_futex_value_locked(puval, uaddr);
+	if (*pret)
+		return 1;
+
+	if (FUTEX_TID(*puval))
+		return 0;	/* The mutex is not free */
+
+	old = *puval;
+
+	*pret = cmpxchg_futex_value_locked(puval, uaddr, old, vpid | old);
+	if (*pret)
+		return 1;
+	if (*puval == old) {
+		/* Adjust uval to reflect current value */
+		*puval = vpid | old;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * futex_spin_lock
+ */
+static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
+{
+	struct futex_hash_bucket *hb;
+	struct futex_q_head	 *qh = NULL;
+	struct futex_q_node	  qnode;
+	union futex_key		  key;
+	bool			  gotlock;
+	int			  ret, cnt;
+	u32			  uval, vpid, old;
+
+	qnode.task  = current;
+	vpid = task_pid_vnr(qnode.task);
+
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
+	if (unlikely(ret))
+		return ret;
+
+	hb = hash_futex(&key);
+	spin_lock(&hb->lock);
+
+	/*
+	 * Locate the queue head for the given key
+	 */
+	qh = find_qhead(hb, &key);
+
+	/*
+	 * Check the futex value under the hash bucket lock as it might
+	 * be changed.
+	 */
+	if (futex_spin_trylock(uaddr, &uval, &ret, vpid))
+		goto hbunlock_out;
+
+	if (!qh) {
+		/*
+		 * First waiter:
+		 * Allocate a queue head structure & initialize it
+		 */
+		qh = qhead_alloc_init(hb, &key);
+		if (unlikely(!qh)) {
+			ret = -ENOMEM;
+			goto hbunlock_out;
+		}
+	} else {
+		atomic_inc(&qh->lcnt);
+	}
+	spin_unlock(&hb->lock);
+
+	/*
+	 * Put the task into the wait queue and sleep
+	 */
+	preempt_disable();
+	get_task_struct(qnode.task);
+	spin_lock(&qh->wlock);
+	list_add_tail(&qnode.wnode, &qh->waitq);
+	__set_current_state(TASK_INTERRUPTIBLE);
+	spin_unlock(&qh->wlock);
+	gotlock = false;
+	for (;;) {
+		ret = get_user(uval, uaddr);
+		if (ret)
+			break;
+		while ((FUTEX_TID(uval) == 0) || !FUTEX_HAS_WAITERS(uval)) {
+			/*
+			 * Make sure the waiter bit is set before sleeping
+			 * and get the lock if it is available.
+			 */
+			if (FUTEX_TID(uval) == 0) {
+				old = uval;
+				ret = futex_atomic_cmpxchg_inatomic(&uval,
+					uaddr, old, vpid);
+				if (ret) {
+					goto dequeue;
+				} else if (uval == old) {
+					gotlock = true;
+					goto dequeue;
+				}
+				continue;
+			}
+
+			old = uval;
+			ret = futex_atomic_cmpxchg_inatomic(&uval, uaddr, old,
+					FUTEX_TID(old) | FUTEX_WAITERS);
+			if (ret)
+				goto dequeue;
+			if (uval == old)
+				break;
+		}
+
+		schedule_preempt_disabled();
+
+		/*
+		 * Got a signal? Return EINTR
+		 */
+		if (unlikely(signal_pending(qnode.task))) {
+			ret = -EINTR;
+			break;	/* Remove from queue */
+		}
+	}
+dequeue:
+	__set_current_state(TASK_RUNNING);
+	/*
+	 * Remove itself from the wait queue and go back to optimistic
+	 * spinning if it hasn't got the lock yet.
+	 */
+	put_task_struct(qnode.task);
+	spin_lock(&qh->wlock);
+	list_del(&qnode.wnode);
+
+	/*
+	 * Try to clear the waiter bit if the wait queue is empty
+	 */
+	if (list_empty(&qh->waitq)) {
+		int retval = get_futex_value_locked(&uval, uaddr);
+
+		if (!retval && FUTEX_HAS_WAITERS(uval)) {
+			old   = uval;
+			uval &= ~FUTEX_WAITERS;
+			(void)cmpxchg_futex_value_locked(&uval, uaddr, old,
+							  uval);
+		}
+	}
+	spin_unlock(&qh->wlock);
+	preempt_enable();
+
+	cnt = atomic_dec_return(&qh->lcnt);
+	if (cnt == 0)
+		qhead_free(qh, hb);
+	/*
+	 * Need to set the waiters bit there are still waiters
+	 */
+	else if (!ret)
+		ret = put_user(vpid | FUTEX_WAITERS, uaddr);
+out:
+	put_futex_key(&key);
+	return ret;
+
+hbunlock_out:
+	spin_unlock(&hb->lock);
+	goto out;
+}
+
+/*
+ * futex_spin_unlock
+ */
+static noinline int futex_spin_unlock(u32 __user *uaddr, unsigned int flags)
+{
+	struct futex_hash_bucket *hb;
+	struct futex_q_head	 *qh;
+	union futex_key		  key;
+	struct task_struct	 *wtask;	/* Task to be woken */
+	int			  ret, lcnt;
+	u32			  uval, old, vpid = task_pid_vnr(current);
+
+	ret = get_user(uval, uaddr);
+	if (ret)
+		return ret;
+
+	/*
+	 * The unlocker may have cleared the TID value and another task may
+	 * steal it. However, if its TID is still set, we need to clear
+	 * it as well as the FUTEX_WAITERS bit.
+	 */
+	while (FUTEX_TID(uval) == vpid) {
+		old   = uval;
+		uval &= ~(FUTEX_TID_MASK | FUTEX_WAITERS);
+		ret   = futex_atomic_cmpxchg_inatomic(&uval, uaddr, old, uval);
+		if (ret)
+			return ret;
+		if (uval == old)
+			break;
+	}
+	/*
+	 * Need to wake up a waiter
+	 */
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
+	if (unlikely(ret))
+		return ret;
+
+	hb = hash_futex(&key);
+	spin_lock(&hb->lock);
+
+	/*
+	 * Locate the queue head for the given key
+	 */
+	qh = find_qhead(hb, &key);
+	if (!qh) {
+		spin_unlock(&hb->lock);
+		ret = -ESRCH;	/* Invalid futex address */
+		goto out;
+	}
+
+	/*
+	 * The hash bucket lock is being hold while retrieving the task
+	 * structure from the queue head to make sure that the qh structure
+	 * won't go away under the hood.
+	 * Preemption is disabled during the wakeup process to avoid having
+	 * a long gap between getting the task structure and waking it up.
+	 */
+	wtask = NULL;
+	preempt_disable();
+	lcnt = atomic_read(&qh->lcnt);
+	if (lcnt) {
+		spin_lock(&qh->wlock);
+		if (!list_empty(&qh->waitq))
+			wtask = list_entry(qh->waitq.next, struct futex_q_node,
+					   wnode)->task;
+		spin_unlock(&qh->wlock);
+	}
+	spin_unlock(&hb->lock);
+	if (wtask && wake_up_process(wtask))
+		ret = 1;
+	else if (!wtask)
+		ret = -ESRCH;
+	preempt_enable();
+out:
+	put_futex_key(&key);
+	return ret;
+}
+
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
@@ -2960,6 +3405,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	case FUTEX_TRYLOCK_PI:
 	case FUTEX_WAIT_REQUEUE_PI:
 	case FUTEX_CMP_REQUEUE_PI:
+	case FUTEX_SPIN_LOCK:
+	case FUTEX_SPIN_UNLOCK:
 		if (!futex_cmpxchg_enabled)
 			return -ENOSYS;
 	}
@@ -2991,6 +3438,10 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 					     uaddr2);
 	case FUTEX_CMP_REQUEUE_PI:
 		return futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
+	case FUTEX_SPIN_LOCK:
+		return futex_spin_lock(uaddr, flags);
+	case FUTEX_SPIN_UNLOCK:
+		return futex_spin_unlock(uaddr, flags);
 	}
 	return -ENOSYS;
 }
@@ -3072,7 +3523,9 @@ static int __init futex_init(void)
 	for (i = 0; i < futex_hashsize; i++) {
 		atomic_set(&futex_queues[i].waiters, 0);
 		plist_head_init(&futex_queues[i].chain);
+		INIT_LIST_HEAD(&futex_queues[i].oslist);
 		spin_lock_init(&futex_queues[i].lock);
+		futex_queues[i].qhcache = NULL;
 	}
 
 	return 0;
-- 
1.7.1
