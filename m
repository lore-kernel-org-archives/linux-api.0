From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 06/16] x86: Add support for restartable sequences (v2)
Date: Sat,  2 Jun 2018 08:43:58 -0400
Message-ID: <20180602124408.8430-7-mathieu.desnoyers@efficios.com>
References: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602124408.8430-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Call the rseq_handle_notify_resume() function on return to userspace if
TIF_NOTIFY_RESUME thread flag is set.

Perform fixup on the pre-signal frame when a signal is delivered on top
of a restartable sequence critical section.

Check that system calls are not invoked from within rseq critical
sections by invoking rseq_signal() from syscall_return_slowpath().
With CONFIG_DEBUG_RSEQ, such behavior results in termination of the
process with SIGSEGV.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org

---

Changes since v1:
- Call rseq_signal() when returning from a system call.
---
 arch/x86/Kconfig         | 1 +
 arch/x86/entry/common.c  | 3 +++
 arch/x86/kernel/signal.c | 6 ++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c07f492b871a..62e00a1a7cf7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -180,6 +180,7 @@ config X86
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if X86_64 && UNWINDER_FRAME_POINTER && STACK_VALIDATION
 	select HAVE_STACK_VALIDATION		if X86_64
+	select HAVE_RSEQ
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index fbf6a6c3fd2d..92190879b228 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -164,6 +164,7 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
 		if (cached_flags & _TIF_NOTIFY_RESUME) {
 			clear_thread_flag(TIF_NOTIFY_RESUME);
 			tracehook_notify_resume(regs);
+			rseq_handle_notify_resume(regs);
 		}
 
 		if (cached_flags & _TIF_USER_RETURN_NOTIFY)
@@ -254,6 +255,8 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 	    WARN(irqs_disabled(), "syscall %ld left IRQs disabled", regs->orig_ax))
 		local_irq_enable();
 
+	rseq_syscall(regs);
+
 	/*
 	 * First do one-time work.  If these work items are enabled, we
 	 * want to run them exactly once per syscall exit with IRQs on.
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index da270b95fe4d..445ca11ff863 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -688,6 +688,12 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 	sigset_t *set = sigmask_to_save();
 	compat_sigset_t *cset = (compat_sigset_t *) set;
 
+	/*
+	 * Increment event counter and perform fixup for the pre-signal
+	 * frame.
+	 */
+	rseq_signal_deliver(regs);
+
 	/* Set up the stack frame */
 	if (is_ia32_frame(ksig)) {
 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
-- 
2.11.0
