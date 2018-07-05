From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 2/5] rseq: uapi: update uapi comments
Date: Thu,  5 Jul 2018 14:05:58 -0400
Message-ID: <20180705180601.18423-3-mathieu.desnoyers@efficios.com>
References: <20180705180601.18423-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705180601.18423-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Update rseq uapi header comments to reflect that user-space need to do
thread-local loads/stores from/to the struct rseq fields.

As a consequence of this added requirement, the kernel does not need
to perform loads/stores with single-copy atomicity.

Update the comment associated to the "flags" fields to describe
more accurately that it's only useful to facilitate single-stepping
through rseq critical sections with debuggers.

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
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
 include/uapi/linux/rseq.h | 69 ++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index 519ad6e176d1..bf4188c13bec 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -67,28 +67,30 @@ struct rseq_cs {
 struct rseq {
 	/*
 	 * Restartable sequences cpu_id_start field. Updated by the
-	 * kernel, and read by user-space with single-copy atomicity
-	 * semantics. Aligned on 32-bit. Always contains a value in the
-	 * range of possible CPUs, although the value may not be the
-	 * actual current CPU (e.g. if rseq is not initialized). This
-	 * CPU number value should always be compared against the value
-	 * of the cpu_id field before performing a rseq commit or
-	 * returning a value read from a data structure indexed using
-	 * the cpu_id_start value.
+	 * kernel. Read by user-space with single-copy atomicity
+	 * semantics. This field should only be read by the thread which
+	 * registered this data structure. Aligned on 32-bit. Always
+	 * contains a value in the range of possible CPUs, although the
+	 * value may not be the actual current CPU (e.g. if rseq is not
+	 * initialized). This CPU number value should always be compared
+	 * against the value of the cpu_id field before performing a rseq
+	 * commit or returning a value read from a data structure indexed
+	 * using the cpu_id_start value.
 	 */
 	__u32 cpu_id_start;
 	/*
-	 * Restartable sequences cpu_id field. Updated by the kernel,
-	 * and read by user-space with single-copy atomicity semantics.
-	 * Aligned on 32-bit. Values RSEQ_CPU_ID_UNINITIALIZED and
-	 * RSEQ_CPU_ID_REGISTRATION_FAILED have a special semantic: the
-	 * former means "rseq uninitialized", and latter means "rseq
-	 * initialization failed". This value is meant to be read within
-	 * rseq critical sections and compared with the cpu_id_start
-	 * value previously read, before performing the commit instruction,
-	 * or read and compared with the cpu_id_start value before returning
-	 * a value loaded from a data structure indexed using the
-	 * cpu_id_start value.
+	 * Restartable sequences cpu_id field. Updated by the kernel.
+	 * Read by user-space with single-copy atomicity semantics. This
+	 * field should only be read by the thread which registered this
+	 * data structure. Aligned on 32-bit. Values
+	 * RSEQ_CPU_ID_UNINITIALIZED and RSEQ_CPU_ID_REGISTRATION_FAILED
+	 * have a special semantic: the former means "rseq uninitialized",
+	 * and latter means "rseq initialization failed". This value is
+	 * meant to be read within rseq critical sections and compared
+	 * with the cpu_id_start value previously read, before performing
+	 * the commit instruction, or read and compared with the
+	 * cpu_id_start value before returning a value loaded from a data
+	 * structure indexed using the cpu_id_start value.
 	 */
 	__u32 cpu_id;
 	/*
@@ -105,27 +107,28 @@ struct rseq {
 	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
 	 * before reclaiming memory that contains the targeted struct rseq_cs.
 	 *
-	 * Read and set by the kernel with single-copy atomicity semantics.
-	 * Set by user-space with single-copy atomicity semantics. Aligned
-	 * on 64-bit.
+	 * Read and set by the kernel. Set by user-space with single-copy
+	 * atomicity semantics. This field should only be updated by the
+	 * thread which registered this data structure. Aligned on 64-bit.
 	 */
 	LINUX_FIELD_u32_u64(rseq_cs);
 	/*
-	 * - RSEQ_DISABLE flag:
+	 * Restartable sequences flags field.
+	 *
+	 * This field should only be updated by the thread which
+	 * registered this data structure. Read by the kernel.
+	 * Mainly used for single-stepping through rseq critical sections
+	 * with debuggers.
 	 *
-	 * Fallback fast-track flag for single-stepping.
-	 * Set by user-space if lack of progress is detected.
-	 * Cleared by user-space after rseq finish.
-	 * Read by the kernel.
 	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
-	 *     Inhibit instruction sequence block restart and event
-	 *     counter increment on preemption for this thread.
+	 *     Inhibit instruction sequence block restart on preemption
+	 *     for this thread.
 	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
-	 *     Inhibit instruction sequence block restart and event
-	 *     counter increment on signal delivery for this thread.
+	 *     Inhibit instruction sequence block restart on signal
+	 *     delivery for this thread.
 	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
-	 *     Inhibit instruction sequence block restart and event
-	 *     counter increment on migration for this thread.
+	 *     Inhibit instruction sequence block restart on migration for
+	 *     this thread.
 	 */
 	__u32 flags;
 } __attribute__((aligned(4 * sizeof(__u64))));
-- 
2.11.0
