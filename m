From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v3 for 4.16 09/11] membarrier: x86: Provide core serializing command
Date: Wed, 10 Jan 2018 10:46:23 -0500
Message-ID: <20180110154625.4319-10-mathieu.desnoyers@efficios.com>
References: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.
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
active_mm) by adding a sync_core() in that specific case.

Use the new sync_core_before_usermode() to guarantee this.

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
- Add linux/processor.h include to include/linux/sched/mm.h.

Changes since v2:
- Fix use-after-free in membarrier_mm_sync_core_before_usermode.
---
 arch/x86/Kconfig          |  1 +
 arch/x86/entry/entry_32.S |  5 +++++
 arch/x86/entry/entry_64.S |  4 ++++
 arch/x86/mm/tlb.c         |  7 ++++---
 include/linux/sched/mm.h  | 12 ++++++++++++
 kernel/sched/core.c       |  6 +++++-
 kernel/sched/membarrier.c |  3 +++
 7 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 74248f712411..b5547e6bbcfc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_PMEM_API		if X86_64
 	# Causing hangs/crashes, see the commit that added this change for details.
 	select ARCH_HAS_REFCOUNT
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index ace8f321a5a1..e70b4d91e3c4 100644
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
index f048e384ff54..971c35eb9bfe 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -786,6 +786,10 @@ GLOBAL(restore_regs_and_return_to_kernel)
 	POP_EXTRA_REGS
 	POP_C_REGS
 	addq	$8, %rsp	/* skip regs->orig_ax */
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler.
+	 */
 	INTERRUPT_RETURN
 
 ENTRY(native_iret)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index c28cd5592b0d..df4e21371c89 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -201,9 +201,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
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
index 3ff217a071ca..fcd2cdc482c1 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/gfp.h>
+#include <linux/processor.h>
 
 /*
  * Routines for handling mm_structs
@@ -235,6 +236,14 @@ enum {
 #include <asm/membarrier.h>
 #endif
 
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+	if (likely(!(atomic_read(&mm->membarrier_state) &
+		     MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE)))
+		return;
+	sync_core_before_usermode();
+}
+
 static inline void membarrier_execve(struct task_struct *t)
 {
 	atomic_set(&t->mm->membarrier_state, 0);
@@ -250,6 +259,9 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+}
 #endif
 
 #endif /* _LINUX_SCHED_MM_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62f269980e29..f86cbba038b9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2662,9 +2662,13 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	 * thread, mmdrop()'s implicit full barrier is required by the
 	 * membarrier system call, because the current active_mm can
 	 * become the current mm without going through switch_mm().
+	 * membarrier also requires a core serializing instruction
+	 * before going back to user-space after storing to rq->curr.
 	 */
-	if (mm)
+	if (mm) {
+		membarrier_mm_sync_core_before_usermode(mm);
 		mmdrop(mm);
+	}
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index fcd2306c2367..e4f7b6dfb07b 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -242,6 +242,9 @@ static int membarrier_register_private_expedited(int flags)
 	if (atomic_read(&mm->membarrier_state) & state)
 		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED, &mm->membarrier_state);
+	if (flags & MEMBARRIER_FLAG_SYNC_CORE)
+		atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE,
+			  &mm->membarrier_state);
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
 		/*
 		 * Ensure all future scheduler executions will observe the
-- 
2.11.0
