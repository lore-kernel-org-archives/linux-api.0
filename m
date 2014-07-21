From: Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 4/5] spinning futex: put waiting tasks in a sorted rbtree
Date: Mon, 21 Jul 2014 11:24:30 -0400
Message-ID: <1405956271-34339-5-git-send-email-Waiman.Long@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

A simple FIFO list for the waiting tasks is easy to use. However, it
differs in behavior from the other futex primitives that the waiting
tasks are put in a priority list.

In order to make a sorted list ranked on priority as well as the
order they enter the kernel, we need to convert the simple list into
a rbtree.

This patch changes the waiting queue into an rbtree sorted first by
process priority followed by the order the tasks enter the kernel.

The optimistic spinning itself is strictly FIFO. There is no easy
way to make it priority based. In fact, the spinlock contention in
a wait-wake futex when the contending tasks enter the kernel also
serves as a kind of FIFO queue for processing the request. Priority
doesn't play a role there too.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/futex.c |   64 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cca6457..12d855c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3011,10 +3011,11 @@ void exit_robust_list(struct task_struct *curr)
 /**
  * struct futex_q_head - head of the optspin futex queue, one per unique key
  * @hnode:	list entry from the hash bucket
- * @waitq:	a list of waiting tasks
+ * @waitq:	a rbtree of waiting tasks sorted by priority & sequence number
  * @key:	the key the futex is hashed on
  * @osq:	pointer to optimisitic spinning queue
  * @owner:	task_struct pointer of the futex owner
+ * @seq:	last used sequence number + 1
  * @otid:	TID of the futex owner
  * @wlock:	spinlock for managing wait queue
  * @lcnt:	locker count (spinners + waiters)
@@ -3027,7 +3028,7 @@ void exit_robust_list(struct task_struct *curr)
  *    - enqueue into the spinner queue and wait for its turn.
  * 4) For waiter:
  *    - lock futex queue head spinlock
- *    - enqueue into the wait queue
+ *    - enqueue into the wait rbtree queue
  *    - release the lock & sleep
  * 5) For unlocker:
  *    - locate the queue head just like a locker does
@@ -3037,10 +3038,11 @@ void exit_robust_list(struct task_struct *curr)
  */
 struct futex_q_head {
 	struct list_head	      hnode;
-	struct list_head	      waitq;
+	struct rb_root		      waitq;
 	union futex_key		      key;
 	struct optimistic_spin_queue *osq;
 	struct task_struct	     *owner;
+	unsigned long		      seq;
 	pid_t			      otid;
 	spinlock_t		      wlock;
 	atomic_t		      lcnt;
@@ -3050,10 +3052,14 @@ struct futex_q_head {
  * struct futex_q_node - a node in the optspin futex queue
  * @wnode:	a list entry for the waiting queue
  * @task:	task_struct pointer of the current task
+ * @seq:	unique sequence number that shows order of kernel entry
+ * @prio:	process priority
  */
 struct futex_q_node {
-	struct list_head	wnode;
+	struct rb_node		wnode;
 	struct task_struct     *task;
+	unsigned long		seq;
+	int			prio;
 };
 
 /*
@@ -3113,7 +3119,7 @@ qhead_alloc_init(struct futex_hash_bucket *hb, union futex_key *key, u32 uval)
 		if (unlikely(!qh->owner))
 			qh->otid = 0;
 		atomic_set(&qh->lcnt, 1);
-		INIT_LIST_HEAD(&qh->waitq);
+		qh->waitq = RB_ROOT;
 		spin_lock_init(&qh->wlock);
 		list_add(&qh->hnode, &hb->oslist);
 	}
@@ -3155,7 +3161,7 @@ qhead_free(struct futex_q_head *qh, struct futex_hash_bucket *hb)
 	/*
 	 * Free the queue head structure
 	 */
-	BUG_ON(!list_empty(&qh->waitq) || qh->osq);
+	BUG_ON(!RB_EMPTY_ROOT(&qh->waitq) || qh->osq);
 	list_del(&qh->hnode);
 	spin_unlock(&hb->lock);
 	if (qh->owner)
@@ -3167,6 +3173,38 @@ qhead_free(struct futex_q_head *qh, struct futex_hash_bucket *hb)
 }
 
 /*
+ * qnode_insert - insert queue node into an rbtree sorted by priority
+ * 		  and then the unique sequence number
+ */
+static inline void qnode_insert(struct rb_root *root, struct futex_q_node *node)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	/*
+	 * Locate where to put the new node
+	 */
+	while (*new) {
+		struct futex_q_node *this = container_of(*new,
+					    struct futex_q_node, wnode);
+		parent = *new;
+		if (likely(node->prio == this->prio)) {
+			if (node->seq < this->seq)
+				new = &(parent->rb_left);
+			else /* node->seq > this->seq */
+				new = &(parent->rb_right);
+		} else if (node->prio < this->prio) {
+			new =  &(parent->rb_left);
+		} else {
+			new = &(parent->rb_right);
+		}
+	}
+
+	/* Add new node and rebalance tree */
+	rb_link_node(&node->wnode, parent, new);
+	rb_insert_color(&node->wnode, root);
+}
+
+/*
  * futex_spin_trylock - attempt to take the lock
  * Return: 1 if successful or an error happen
  *	   0 otherwise
@@ -3336,6 +3374,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
 	} else {
 		atomic_inc(&qh->lcnt);
 	}
+	qnode.seq = qh->seq++;
 	spin_unlock(&hb->lock);
 
 	/*
@@ -3353,8 +3392,9 @@ optspin:
 	 * Put the task into the wait queue and sleep
 	 */
 	get_task_struct(qnode.task);
+	qnode.prio = min(qnode.task->normal_prio, MAX_RT_PRIO);
 	spin_lock(&qh->wlock);
-	list_add_tail(&qnode.wnode, &qh->waitq);
+	qnode_insert(&qh->waitq, &qnode);
 	__set_current_state(TASK_INTERRUPTIBLE);
 	spin_unlock(&qh->wlock);
 	slept = gotlock = false;
@@ -3421,12 +3461,12 @@ dequeue:
 	 */
 	put_task_struct(qnode.task);
 	spin_lock(&qh->wlock);
-	list_del(&qnode.wnode);
+	rb_erase(&qnode.wnode, &qh->waitq);
 
 	/*
 	 * Try to clear the waiter bit if the wait queue is empty
 	 */
-	if (list_empty(&qh->waitq)) {
+	if (RB_EMPTY_ROOT(&qh->waitq)) {
 		int retval = get_futex_value_locked(&uval, uaddr);
 
 		if (!retval && FUTEX_HAS_WAITERS(uval)) {
@@ -3529,9 +3569,9 @@ static noinline int futex_spin_unlock(u32 __user *uaddr, unsigned int flags)
 	lcnt = atomic_read(&qh->lcnt);
 	if (lcnt) {
 		spin_lock(&qh->wlock);
-		if (!list_empty(&qh->waitq))
-			wtask = list_entry(qh->waitq.next, struct futex_q_node,
-					   wnode)->task;
+		if (!RB_EMPTY_ROOT(&qh->waitq))
+			wtask = container_of(rb_first(&qh->waitq),
+				struct futex_q_node, wnode)->task;
 		spin_unlock(&qh->wlock);
 	}
 	spin_unlock(&hb->lock);
-- 
1.7.1
