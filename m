From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.1 1/3] rseq: cleanup: Reflect removal of event counter in comments
Date: Tue,  5 Mar 2019 14:47:53 -0500
Message-ID: <20190305194755.2602-2-mathieu.desnoyers@efficios.com>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305194755.2602-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

The "event counter" was removed from rseq before it was merged upstream.
However, a few comments in the source code still refer to it. Adapt the
comments to match reality.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
---
 arch/arm/kernel/signal.c | 3 +--
 arch/x86/kernel/signal.c | 5 +----
 kernel/rseq.c            | 3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 76bb8de6bf6b..be5edfdde558 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -549,8 +549,7 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	int ret;
 
 	/*
-	 * Increment event counter and perform fixup for the pre-signal
-	 * frame.
+	 * Perform fixup for the pre-signal frame.
 	 */
 	rseq_signal_deliver(ksig, regs);
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 08dfd4c1a4f9..22c233b509da 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -688,10 +688,7 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 	sigset_t *set = sigmask_to_save();
 	compat_sigset_t *cset = (compat_sigset_t *) set;
 
-	/*
-	 * Increment event counter and perform fixup for the pre-signal
-	 * frame.
-	 */
+	/* Perform fixup for the pre-signal frame. */
 	rseq_signal_deliver(ksig, regs);
 
 	/* Set up the stack frame */
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 25e9a7b60eba..849afe749131 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -254,8 +254,7 @@ static int rseq_ip_fixup(struct pt_regs *regs)
  * - signal delivery,
  * and return to user-space.
  *
- * This is how we can ensure that the entire rseq critical section,
- * consisting of both the C part and the assembly instruction sequence,
+ * This is how we can ensure that the entire rseq critical section
  * will issue the commit instruction only if executed atomically with
  * respect to other threads scheduled on the same CPU, and with respect
  * to signal handlers.
-- 
2.11.0
