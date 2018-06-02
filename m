From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 09/16] powerpc: Add syscall detection for restartable sequences
Date: Sat,  2 Jun 2018 08:44:01 -0400
Message-ID: <20180602124408.8430-10-mathieu.desnoyers@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Benjamin Herrenschmidt <benh>
List-Id: linux-api@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

Syscalls are not allowed inside restartable sequences, so add a call to
rseq_syscall() at the very beginning of system call exiting path for
CONFIG_DEBUG_RSEQ=y kernel. This could help us to detect whether there
is a syscall issued inside restartable sequences.

[ Tested on 64-bit powerpc kernel by Mathieu Desnoyers. Still needs to
  be tested on 32-bit powerpc kernel. ]

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/entry_32.S | 7 +++++++
 arch/powerpc/kernel/entry_64.S | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index eb8d01bae8c6..973577f2141c 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -365,6 +365,13 @@ syscall_dotrace_cont:
 	blrl			/* Call handler */
 	.globl	ret_from_syscall
 ret_from_syscall:
+#ifdef CONFIG_DEBUG_RSEQ
+	/* Check whether the syscall is issued inside a restartable sequence */
+	stw	r3,GPR3(r1)
+	addi    r3,r1,STACK_FRAME_OVERHEAD
+	bl      rseq_syscall
+	lwz	r3,GPR3(r1)
+#endif
 	mr	r6,r3
 	CURRENT_THREAD_INFO(r12, r1)
 	/* disable interrupts so current_thread_info()->flags can't change */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 51695608c68b..1c374387656a 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -184,6 +184,14 @@ system_call:			/* label this so stack traces look sane */
 
 .Lsyscall_exit:
 	std	r3,RESULT(r1)
+
+#ifdef CONFIG_DEBUG_RSEQ
+	/* Check whether the syscall is issued inside a restartable sequence */
+	addi    r3,r1,STACK_FRAME_OVERHEAD
+	bl      rseq_syscall
+	ld	r3,RESULT(r1)
+#endif
+
 	CURRENT_THREAD_INFO(r12, r1)
 
 	ld	r8,_MSR(r1)
-- 
2.11.0
