From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 04/16] arm: Add syscall detection for restartable sequences
Date: Sat,  2 Jun 2018 08:43:56 -0400
Message-ID: <20180602124408.8430-5-mathieu.desnoyers@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Syscalls are not allowed inside restartable sequences, so add a call to
rseq_syscall() at the very beginning of system call exiting path for
CONFIG_DEBUG_RSEQ=y kernel. This could help us to detect whether there
is a syscall issued inside restartable sequences.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
 arch/arm/kernel/entry-common.S | 25 +++++++++++++++++++------
 arch/arm/kernel/signal.c       |  7 +++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3c4f88701f22..b427ef8ec8c6 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -39,12 +39,13 @@ saved_pc	.req	lr
 
 	.section .entry.text,"ax",%progbits
 	.align	5
-#if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING))
+#if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING) || \
+	IS_ENABLED(CONFIG_DEBUG_RSEQ))
 /*
  * This is the fast syscall return path.  We do as little as possible here,
  * such as avoiding writing r0 to the stack.  We only use this path if we
- * have tracing and context tracking disabled - the overheads from those
- * features make this path too inefficient.
+ * have tracing, context tracking and rseq debug disabled - the overheads
+ * from those features make this path too inefficient.
  */
 ret_fast_syscall:
  UNWIND(.fnstart	)
@@ -71,14 +72,20 @@ fast_work_pending:
 	/* fall through to work_pending */
 #else
 /*
- * The "replacement" ret_fast_syscall for when tracing or context tracking
- * is enabled.  As we will need to call out to some C functions, we save
- * r0 first to avoid needing to save registers around each C function call.
+ * The "replacement" ret_fast_syscall for when tracing, context tracking,
+ * or rseq debug is enabled.  As we will need to call out to some C functions,
+ * we save r0 first to avoid needing to save registers around each C function
+ * call.
  */
 ret_fast_syscall:
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
+#if IS_ENABLED(CONFIG_DEBUG_RSEQ)
+	/* do_rseq_syscall needs interrupts enabled. */
+	mov	r0, sp				@ 'regs'
+	bl	do_rseq_syscall
+#endif
 	disable_irq_notrace			@ disable interrupts
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
 	cmp	r2, #TASK_SIZE
@@ -113,6 +120,12 @@ ENDPROC(ret_fast_syscall)
  */
 ENTRY(ret_to_user)
 ret_slow_syscall:
+#if IS_ENABLED(CONFIG_DEBUG_RSEQ)
+	/* do_rseq_syscall needs interrupts enabled. */
+	enable_irq_notrace			@ enable interrupts
+	mov	r0, sp				@ 'regs'
+	bl	do_rseq_syscall
+#endif
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 5879ab3f53c1..f09e9d66d605 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -710,3 +710,10 @@ asmlinkage void addr_limit_check_failed(void)
 {
 	addr_limit_user_check();
 }
+
+#ifdef CONFIG_DEBUG_RSEQ
+asmlinkage void do_rseq_syscall(struct pt_regs *regs)
+{
+	rseq_syscall(regs);
+}
+#endif
-- 
2.11.0
