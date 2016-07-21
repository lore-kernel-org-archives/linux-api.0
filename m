From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v7 3/7] Restartable sequences: ARM 32 architecture support
Date: Thu, 21 Jul 2016 17:14:18 -0400
Message-ID: <1469135662-31512-4-git-send-email-mathieu.desnoyers@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Call the rseq_handle_notify_resume() function on return to
userspace if TIF_NOTIFY_RESUME thread flag is set.

Increment the event counter and perform fixup on the pre-signal frame
when a signal is delivered on top of a restartable sequence critical
section.

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
 arch/arm/Kconfig         | 1 +
 arch/arm/kernel/signal.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 90542db..636e14b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -75,6 +75,7 @@ config ARM
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE if (SMP && ARM_LPAE)
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RSEQ
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 7b8f214..907da02 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -475,6 +475,12 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	int ret;
 
 	/*
+	 * Increment event counter and perform fixup for the pre-signal
+	 * frame.
+	 */
+	rseq_signal_deliver(regs);
+
+	/*
 	 * Set up the stack frame
 	 */
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
@@ -594,6 +600,7 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 			} else {
 				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
+				rseq_handle_notify_resume(regs);
 			}
 		}
 		local_irq_disable();
-- 
2.1.4
