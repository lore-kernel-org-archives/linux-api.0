From: Waiman Long <Waiman.Long@hp.com>
Subject: [RFC PATCH 3/5] spinning futex: move a wakened task to spinning
Date: Mon, 21 Jul 2014 11:24:29 -0400
Message-ID: <1405956271-34339-4-git-send-email-Waiman.Long@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
List-Id: linux-api@vger.kernel.org

This patch moves a wakened task back to the optimistic spinning loop
if the owner is running.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/futex.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ddc24d1..cca6457 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3215,8 +3215,8 @@ static inline int futex_spin_trylock(u32 __user *uaddr, u32 *puval,
  * loop. Preemption should have been disabled before calling this function.
  *
  * The number of spinners may temporarily exceed the threshold due to
- * racing (the spin count check and add aren't atomic), but that shouldn't
- * be a big problem.
+ * racing and from waiter joining the OSQ(the spin count check and add
+ * aren't atomic), but that shouldn't be a real problem.
  */
 static inline int futex_optspin(struct futex_q_head *qh,
 				struct futex_q_node *qn,
@@ -3297,7 +3297,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
 	struct futex_q_node	  qnode;
 	union futex_key		  key;
 	struct task_struct	 *owner;
-	bool			  gotlock;
+	bool			  gotlock, slept;
 	int			  ret, cnt;
 	u32			  uval, vpid, old;
 
@@ -3345,6 +3345,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
 	owner = ACCESS_ONCE(qh->owner);
 	if ((FUTEX_SPINCNT(qh) < futex_spincnt_max) &&
 	    (!owner || owner->on_cpu))
+optspin:
 		if (futex_optspin(qh, &qnode, uaddr, vpid))
 			goto penable_out;
 
@@ -3356,7 +3357,7 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
 	list_add_tail(&qnode.wnode, &qh->waitq);
 	__set_current_state(TASK_INTERRUPTIBLE);
 	spin_unlock(&qh->wlock);
-	gotlock = false;
+	slept = gotlock = false;
 	for (;;) {
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -3393,7 +3394,16 @@ static noinline int futex_spin_lock(u32 __user *uaddr, unsigned int flags)
 				break;
 		}
 
+		/*
+		 * Go back to spinning if the lock owner is running and the
+		 * spinner limit hasn't been reached.
+		 */
+		if (slept && (!owner || owner->on_cpu) &&
+		   (FUTEX_SPINCNT(qh) < futex_spincnt_max))
+			break;
+
 		schedule_preempt_disabled();
+		slept = true;
 
 		/*
 		 * Got a signal? Return EINTR
@@ -3427,6 +3437,8 @@ dequeue:
 		}
 	}
 	spin_unlock(&qh->wlock);
+	if (!ret && !gotlock)
+		goto optspin;
 
 penable_out:
 	preempt_enable();
-- 
1.7.1
