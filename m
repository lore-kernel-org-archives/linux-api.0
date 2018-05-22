From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 03/14] arm: Add restartable sequences support
Date: Tue, 22 May 2018 14:19:33 -0400 (EDT)
Message-ID: <1564615700.2786.1527013173112.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <20180430224433.17407-4-mathieu.desnoyers@efficios.com> <20180516161809.GH12198@hirez.programming.kicks-ass.net> <670368504.1912.1526501593893.JavaMail.zimbra@efficios.com> <20180517133230.GA2688@arm.com> <2135166002.2147.1526571001678.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2135166002.2147.1526571001678.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

----- On May 17, 2018, at 11:30 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

[...]
> 
> Or as proposed by Boqun, we can simply call rseq_syscall in a CONFIG_DEBUG_RSEQ
> ifdef. Given that this is a debug option, is it worth it to add the
> current->rseq
> test for NULL in assembly before the call, or do we want to favor simplicity ?
> 

Based on advice from Will Deacon, I alternatively tried to add a new TIF_RSEQ thread
flags, but unfortunately bits 1 through 8 are already used, and this is all that fits
in an immediate operand on arm32 for the fast-path thread flag syscall work mask check
in assembly.

So considering that this is a kernel debug option, I took the approach of adding a
call at the very beginning of return from syscall fast and slow paths, which is only
compiled in if CONFIG_DEBUG_RSEQ=y.

Does the following approach make sense ?


arm: Add syscall detection for restartable sequences

Syscalls are not allowed inside restartable sequences, so add a call to
rseq_syscall() at the very beginning of system call exiting path for
CONFIG_DEBUG_RSEQ=y kernel. This could help us to detect whether there
is a syscall issued inside restartable sequences.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3c4f887..b427ef8 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -39,12 +39,13 @@ saved_pc    .req    lr
 
        .section .entry.text,"ax",%progbits
        .align  5
-#if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING))
+#if !(IS_ENABLED(CONFIG_TRACE_IRQFLAGS) || IS_ENABLED(CONFIG_CONTEXT_TRACKING) || \
+       IS_ENABLED(CONFIG_DEBUG_RSEQ))
 /*
  * This is the fast syscall return path.  We do as little as possible here,
  * such as avoiding writing r0 to the stack.  We only use this path if we
- * have tracing and context tracking disabled - the overheads from those
- * features make this path too inefficient.
+ * have tracing, context tracking and rseq debug disabled - the overheads
+ * from those features make this path too inefficient.
  */
 ret_fast_syscall:
  UNWIND(.fnstart       )
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
  UNWIND(.fnstart       )
  UNWIND(.cantunwind    )
        str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
+#if IS_ENABLED(CONFIG_DEBUG_RSEQ)
+       /* do_rseq_syscall needs interrupts enabled. */
+       mov     r0, sp                          @ 'regs'
+       bl      do_rseq_syscall
+#endif
        disable_irq_notrace                     @ disable interrupts
        ldr     r2, [tsk, #TI_ADDR_LIMIT]
        cmp     r2, #TASK_SIZE
@@ -113,6 +120,12 @@ ENDPROC(ret_fast_syscall)
  */
 ENTRY(ret_to_user)
 ret_slow_syscall:
+#if IS_ENABLED(CONFIG_DEBUG_RSEQ)
+       /* do_rseq_syscall needs interrupts enabled. */
+       enable_irq_notrace                      @ enable interrupts
+       mov     r0, sp                          @ 'regs'
+       bl      do_rseq_syscall
+#endif
        disable_irq_notrace                     @ disable interrupts
 ENTRY(ret_to_user_from_irq)
        ldr     r2, [tsk, #TI_ADDR_LIMIT]
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 5879ab3..f09e9d66 100644
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
+       rseq_syscall(regs);
+}
+#endif



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
