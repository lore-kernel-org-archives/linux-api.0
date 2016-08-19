From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v8 7/9] Restartable sequences: powerpc architecture support
Date: Fri, 19 Aug 2016 16:07:52 -0400
Message-ID: <1471637274-13583-8-git-send-email-mathieu.desnoyers@efficios.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

Call the rseq_handle_notify_resume() function on return to userspace if
TIF_NOTIFY_RESUME thread flag is set.

Increment the event counter and perform fixup on the pre-signal when a
signal is delivered on top of a restartable sequence critical section.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/powerpc/Kconfig         | 1 +
 arch/powerpc/kernel/signal.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 927d2ab..4847a8a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -119,6 +119,7 @@ config PPC
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
+	select HAVE_RSEQ
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select SPARSE_IRQ
 	select IRQ_DOMAIN
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index cb64d6f..339d0eb 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -131,6 +131,8 @@ static void do_signal(struct pt_regs *regs)
 	/* Re-enable the breakpoints for the signal stack */
 	thread_change_pc(current, regs);
 
+	rseq_signal_deliver(regs);
+
 	if (is32) {
         	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
 			ret = handle_rt_signal32(&ksig, oldset, regs);
@@ -157,6 +159,7 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
+		rseq_handle_notify_resume(regs);
 	}
 
 	user_enter();
-- 
2.1.4
