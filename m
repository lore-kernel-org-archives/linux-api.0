From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 v4 09/11] membarrier: x86: Provide core serializing command
Date: Mon, 29 Jan 2018 15:20:18 -0500
Message-ID: <20180129202020.8515-10-mathieu.desnoyers@efficios.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
Changes since v3:
- Move generic code into separate patch.
---
 arch/x86/Kconfig          | 1 +
 arch/x86/entry/entry_32.S | 5 +++++
 arch/x86/entry/entry_64.S | 4 ++++
 arch/x86/mm/tlb.c         | 7 ++++---
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0b44c8dd0e95..b5324f2e3162 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_REFCOUNT
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 60c4c342316c..267d747a867f 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -565,6 +565,11 @@ restore_all:
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
index ff6f8022612c..52e20d37cdd3 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -803,6 +803,10 @@ GLOBAL(restore_regs_and_return_to_kernel)
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
index 9fa7d2e0e15e..9b34121c8f05 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -229,9 +229,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
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
-- 
2.11.0
