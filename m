From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v2 for 4.15 07/10] membarrier: x86: Provide core serializing command
Date: Fri, 10 Nov 2017 16:37:14 -0500
Message-ID: <20171110213717.12457-8-mathieu.desnoyers@efficios.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.co>
List-Id: linux-api@vger.kernel.org

There are two places where core serialization is needed by membarrier:

1) When returning from the membarrier IPI,
2) After scheduler updates curr to a thread with a different mm, before
   going back to user-space, since the curr->mm is used by membarrier to
   check whether it needs to send an IPI to that CPU.

x86-32 uses iret as return from interrupt, and both iret and sysexit to go
back to user-space. The iret instruction is core serializing, but not
sysexit.

x86-64 uses iret as return from interrupt, which takes care of the IPI.
However, it can return to user-space through either sysretl (compat
code), sysretq, or iret. Given that sysret{l,q} is not core serializing,
we rely instead on write_cr3() performed by switch_mm() to provide core
serialization after changing the current mm, and deal with the special
case of kthread -> uthread (temporarily keeping current mm into
active_mm) by adding a sync_core_before_usermode() in that specific case.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@kernel.org>
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
CC: Russell King <linux@armlinux.org.uk>
CC: Greg Hackmann <ghackmann@google.com>
CC: Will Deacon <will.deacon@arm.com>
CC: David Sehr <sehr@google.com>
CC: x86@kernel.org
CC: linux-arch@vger.kernel.org

---
Changes since v1:
- Use the newly introduced sync_core_before_usermode(). Move all state
  handling to generic code.
---
 arch/x86/Kconfig          |  1 +
 arch/x86/entry/entry_32.S |  5 +++++
 arch/x86/entry/entry_64.S |  8 ++++++++
 arch/x86/mm/tlb.c         |  7 ++++---
 include/linux/sched/mm.h  | 12 ++++++++++++
 kernel/sched/core.c       |  6 +++++-
 kernel/sched/membarrier.c |  4 ++++
 7 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 54fbb8960d94..94bdf5fc7d94 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_PMEM_API		if X86_64
 	# Causing hangs/crashes, see the commit that added this change for details.
 	select ARCH_HAS_REFCOUNT		if BROKEN
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 4838037f97f6..04e5daba8456 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -553,6 +553,11 @@ restore_all:
 .Lrestore_nocheck:
 	RESTORE_REGS 4				# skip orig_eax/error_code
 .Lirq_return:
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler and when returning from
+	 * scheduler to user-space.
+	 */
 	INTERRUPT_RETURN
 
 .section .fixup, "ax"
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index bcfc5668dcb2..4859f04e1695 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -642,6 +642,10 @@ GLOBAL(restore_regs_and_iret)
 restore_c_regs_and_iret:
 	RESTORE_C_REGS
 	REMOVE_PT_GPREGS_FROM_STACK 8
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler.
+	 */
 	INTERRUPT_RETURN
 
 ENTRY(native_iret)
@@ -1122,6 +1126,10 @@ paranoid_exit_restore:
 	RESTORE_EXTRA_REGS
 	RESTORE_C_REGS
 	REMOVE_PT_GPREGS_FROM_STACK 8
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler.
+	 */
 	INTERRUPT_RETURN
 END(paranoid_exit)
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5abf9bfcca1f..3b13d6735fa5 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -147,9 +147,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 	this_cpu_write(cpu_tlbstate.is_lazy, false);
 
 	/*
-	 * The membarrier system call requires a full memory barrier
-	 * before returning to user-space, after storing to rq->curr.
-	 * Writing to CR3 provides that full memory barrier.
+	 * The membarrier system call requires a full memory barrier and
+	 * core serialization before returning to user-space, after
+	 * storing to rq->curr. Writing to CR3 provides that full
+	 * memory barrier and core serializing instruction.
 	 */
 	if (real_prev == next) {
 		VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[prev_asid].ctx_id) !=
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 49a5b37a215a..6d7399a9185c 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -222,6 +222,7 @@ enum {
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY		= (1U << 0),
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY	= (1U << 2),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE		= (1U << 3),
 };
 
 enum {
@@ -232,6 +233,14 @@ enum {
 #include <asm/membarrier.h>
 #endif
 
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+	if (likely(!(atomic_read(&mm->membarrier_state) &
+			MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE)))
+		return;
+	sync_core_before_usermode();
+}
+
 static inline void membarrier_execve(struct task_struct *t)
 {
 	atomic_set(&t->mm->membarrier_state, 0);
@@ -246,6 +255,9 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+}
 #endif
 
 #endif /* _LINUX_SCHED_MM_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4a1c9782267a..c3b8248c684d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2700,9 +2700,13 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	 * thread, mmdrop()'s implicit full barrier is required by the
 	 * membarrier system call, because the current active_mm can
 	 * become the current mm without going through switch_mm().
+	 * membarrier also requires a core serializing instruction
+	 * before going back to user-space after storing to rq->curr.
 	 */
-	if (mm)
+	if (mm) {
 		mmdrop(mm);
+		membarrier_mm_sync_core_before_usermode(mm);
+	}
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 82efa7c64902..c240158138ee 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -141,6 +141,10 @@ static int membarrier_register_private_expedited(int flags)
 		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED,
 			&mm->membarrier_state);
+	if (flags & MEMBARRIER_FLAG_SYNC_CORE) {
+		atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE,
+				&mm->membarrier_state);
+	}
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
 		/*
 		 * Ensure all future scheduler executions will observe the
-- 
2.11.0
