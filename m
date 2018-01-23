From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 03/11] membarrier: Document scheduler barrier requirements (v5)
Date: Tue, 23 Jan 2018 10:57:25 -0500
Message-ID: <20180123155733.3404-4-mathieu.desnoyers@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Document the membarrier requirement on having a full memory barrier in
__schedule() after coming from user-space, before storing to rq->curr.
It is provided by smp_mb__after_spinlock() in __schedule().

Document that membarrier requires a full barrier on transition from
kernel thread to userspace thread. We currently have an implicit barrier
from atomic_dec_and_test() in mmdrop() that ensures this.

The x86 switch_mm_irqs_off() full barrier is currently provided by many
cpumask update operations as well as write_cr3(). Document that
write_cr3() provides this barrier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Andrew Hunter <ahh@google.com>
CC: Maged Michael <maged.michael@gmail.com>
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Dave Watson <davejwatson@fb.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrea Parri <parri.andrea@gmail.com>
CC: x86@kernel.org
---
Changes since v1:
- Update comments to match reality for code paths which are after
  storing to rq->curr, before returning to user-space, based on feedback
  from Andrea Parri.
Changes since v2:
- Update changelog (smp_mb__before_spinlock -> smp_mb__after_spinlock).
  Based on feedback from Andrea Parri.
Changes since v3:
- Clarify comments following feeback from Peter Zijlstra.
Changes since v4:
- Update comment regarding powerpc barrier.
---
 arch/x86/mm/tlb.c        |  5 +++++
 include/linux/sched/mm.h |  5 +++++
 kernel/sched/core.c      | 37 ++++++++++++++++++++++++++-----------
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a1561957dccb..c28cd5592b0d 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -200,6 +200,11 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 #endif
 	this_cpu_write(cpu_tlbstate.is_lazy, false);
 
+	/*
+	 * The membarrier system call requires a full memory barrier
+	 * before returning to user-space, after storing to rq->curr.
+	 * Writing to CR3 provides that full memory barrier.
+	 */
 	if (real_prev == next) {
 		VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[prev_asid].ctx_id) !=
 			   next->context.ctx_id);
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 1754396795f6..28aef7051d73 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -39,6 +39,11 @@ static inline void mmgrab(struct mm_struct *mm)
 extern void __mmdrop(struct mm_struct *);
 static inline void mmdrop(struct mm_struct *mm)
 {
+	/*
+	 * The implicit full barrier implied by atomic_dec_and_test is
+	 * required by the membarrier system call before returning to
+	 * user-space, after storing to rq->curr.
+	 */
 	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
 		__mmdrop(mm);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7e06dfa804b..f38c4c7e256a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2657,6 +2657,12 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	finish_arch_post_lock_switch();
 
 	fire_sched_in_preempt_notifiers(current);
+	/*
+	 * When transitioning from a kernel thread to a userspace
+	 * thread, mmdrop()'s implicit full barrier is required by the
+	 * membarrier system call, because the current active_mm can
+	 * become the current mm without going through switch_mm().
+	 */
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -2762,6 +2768,13 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
+	/*
+	 * If mm is non-NULL, we pass through switch_mm(). If mm is
+	 * NULL, we will pass through mmdrop() in finish_task_switch().
+	 * Both of these contain the full memory barrier required by
+	 * membarrier after storing to rq->curr, before returning to
+	 * user-space.
+	 */
 	if (!mm) {
 		next->active_mm = oldmm;
 		mmgrab(oldmm);
@@ -3298,6 +3311,9 @@ static void __sched notrace __schedule(bool preempt)
 	 * Make sure that signal_pending_state()->signal_pending() below
 	 * can't be reordered with __set_current_state(TASK_INTERRUPTIBLE)
 	 * done by the caller to avoid the race with signal_wake_up().
+	 *
+	 * The membarrier system call requires a full memory barrier
+	 * after coming from user-space, before storing to rq->curr.
 	 */
 	rq_lock(rq, &rf);
 	smp_mb__after_spinlock();
@@ -3345,17 +3361,16 @@ static void __sched notrace __schedule(bool preempt)
 		/*
 		 * The membarrier system call requires each architecture
 		 * to have a full memory barrier after updating
-		 * rq->curr, before returning to user-space. For TSO
-		 * (e.g. x86), the architecture must provide its own
-		 * barrier in switch_mm(). For weakly ordered machines
-		 * for which spin_unlock() acts as a full memory
-		 * barrier, finish_lock_switch() in common code takes
-		 * care of this barrier. For weakly ordered machines for
-		 * which spin_unlock() acts as a RELEASE barrier (only
-		 * arm64 and PowerPC), arm64 has a full barrier in
-		 * switch_to(), and PowerPC has
-		 * smp_mb__after_unlock_lock() before
-		 * finish_lock_switch().
+		 * rq->curr, before returning to user-space.
+		 *
+		 * Here are the schemes providing that barrier on the
+		 * various architectures:
+		 * - mm ? switch_mm() : mmdrop() for x86, s390, sparc, PowerPC.
+		 *   switch_mm() rely on membarrier_arch_switch_mm() on PowerPC.
+		 * - finish_lock_switch() for weakly-ordered
+		 *   architectures where spin_unlock is a full barrier,
+		 * - switch_to() for arm64 (weakly-ordered, spin_unlock
+		 *   is a RELEASE barrier),
 		 */
 		++*switch_count;
 
-- 
2.11.0
