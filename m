From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 07/14] powerpc: Add support for restartable sequences
Date: Sun, 20 May 2018 22:08:11 +0800
Message-ID: <20180520140811.GB1121@tardis>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <20180430224433.17407-8-mathieu.desnoyers@efficios.com>
 <20180516161837.GI12198@hirez.programming.kicks-ass.net>
 <112970629.1913.1526501596485.JavaMail.zimbra@efficios.com>
 <20180517011949.GA1121@tardis>
 <277374719.2144.1526570889798.JavaMail.zimbra@efficios.com>
 <1526601043.1338308.1376191416.0444B8C5@webmail.messagingengine.com>
 <418003803.516.1526667437396.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <418003803.516.1526667437396.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

On Fri, May 18, 2018 at 02:17:17PM -0400, Mathieu Desnoyers wrote:
> ----- On May 17, 2018, at 7:50 PM, Boqun Feng boqun.feng@gmail.com wrote:
> [...]
> >> > I think you're right. So we have to introduce callsite to rseq_syscall()
> >> > in syscall path, something like:
> >> > 
> >> > diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> >> > index 51695608c68b..a25734a96640 100644
> >> > --- a/arch/powerpc/kernel/entry_64.S
> >> > +++ b/arch/powerpc/kernel/entry_64.S
> >> > @@ -222,6 +222,9 @@ system_call_exit:
> >> > 	mtmsrd	r11,1
> >> > #endif /* CONFIG_PPC_BOOK3E */
> >> > 
> >> > +	addi    r3,r1,STACK_FRAME_OVERHEAD
> >> > +	bl	rseq_syscall
> >> > +
> >> > 	ld	r9,TI_FLAGS(r12)
> >> > 	li	r11,-MAX_ERRNO
> >> > 	andi.
> >> > 		r0,r9,(_TIF_SYSCALL_DOTRACE|_TIF_SINGLESTEP|_TIF_USER_WORK_MASK|_TIF_PERSYSCALL_MASK)
> >> > 
> 
> By the way, I think this is not the right spot to call rseq_syscall, because
> interrupts are disabled. I think we should move this hunk right after system_call_exit.
> 

Good point.

> Would you like to implement and test an updated patch adding those calls for ppc 32 and 64 ?
> 

I'd like to help, but I don't have a handy ppc environment for test...
So I made the below patch which has only been build-tested, hope it
could be somewhat helpful.

Regards,
Boqun

--------------------------------->8
Subject: [PATCH] powerpc: Add syscall detection for restartable sequences

Syscalls are not allowed inside restartable sequences, so add a call to
rseq_syscall() at the very beginning of system call exiting path for
CONFIG_DEBUG_RSEQ=y kernel. This could help us to detect whether there
is a syscall issued inside restartable sequences.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 arch/powerpc/kernel/entry_32.S | 5 +++++
 arch/powerpc/kernel/entry_64.S | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index eb8d01bae8c6..2f134eebe7ed 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -365,6 +365,11 @@ syscall_dotrace_cont:
 	blrl			/* Call handler */
 	.globl	ret_from_syscall
 ret_from_syscall:
+#ifdef CONFIG_DEBUG_RSEQ
+	/* Check whether the syscall is issued inside a restartable sequence */
+	addi    r3,r1,STACK_FRAME_OVERHEAD
+	bl      rseq_syscall
+#endif
 	mr	r6,r3
 	CURRENT_THREAD_INFO(r12, r1)
 	/* disable interrupts so current_thread_info()->flags can't change */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 2cb5109a7ea3..2e2d59bb45d0 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -204,6 +204,11 @@ system_call:			/* label this so stack traces look sane */
  * This is blacklisted from kprobes further below with _ASM_NOKPROBE_SYMBOL().
  */
 system_call_exit:
+#ifdef CONFIG_DEBUG_RSEQ
+	/* Check whether the syscall is issued inside a restartable sequence */
+	addi    r3,r1,STACK_FRAME_OVERHEAD
+	bl      rseq_syscall
+#endif
 	/*
 	 * Disable interrupts so current_thread_info()->flags can't change,
 	 * and so that we don't get interrupted after loading SRR0/1.
-- 
2.16.2
