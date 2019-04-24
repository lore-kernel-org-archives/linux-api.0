From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 5.2 05/10] rseq/selftests: x86: use ud1 instruction as RSEQ_SIG opcode
Date: Wed, 24 Apr 2019 11:24:57 -0400
Message-ID: <20190424152502.14246-6-mathieu.desnoyers@efficios.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Shuah Khan <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

Use ud1 as the guard instruction for the restartable sequence abort
handler. Its benefit compared to nopl is to trap execution if the
program ends up trying to execute it by mistake, which makes debugging
easier.

The 4-byte signature per se is unchanged (it is the instruction
operand). Only the opcode is changed from nopl to ud1.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Joel Fernandes <joelaf@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Dave Watson <davejwatson@fb.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Andi Kleen <andi@firstfloor.org>
CC: linux-kselftest@vger.kernel.org
CC: "H . Peter Anvin" <hpa@zytor.com>
CC: Chris Lameter <cl@linux.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
CC: Paul Turner <pjt@google.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ben Maurer <bmaurer@fb.com>
CC: linux-api@vger.kernel.org
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 tools/testing/selftests/rseq/rseq-x86.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq-x86.h b/tools/testing/selftests/rseq/rseq-x86.h
index 03095236f6fa..b2da6004fe30 100644
--- a/tools/testing/selftests/rseq/rseq-x86.h
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -7,6 +7,13 @@
 
 #include <stdint.h>
 
+/*
+ * RSEQ_SIG is used with the following reserved undefined instructions, which
+ * trap in user-space:
+ *
+ * x86-32:    0f b9 3d 53 30 05 53      ud1    0x53053053,%edi
+ * x86-64:    0f b9 3d 53 30 05 53      ud1    0x53053053(%rip),%edi
+ */
 #define RSEQ_SIG	0x53053053
 
 /*
@@ -88,8 +95,8 @@ do {									\
 
 #define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)		\
 		".pushsection __rseq_failure, \"ax\"\n\t"		\
-		/* Disassembler-friendly signature: nopl <sig>(%rip). */\
-		".byte 0x0f, 0x1f, 0x05\n\t"				\
+		/* Disassembler-friendly signature: ud1 <sig>(%rip),%edi. */ \
+		".byte 0x0f, 0xb9, 0x3d\n\t"				\
 		".long " __rseq_str(RSEQ_SIG) "\n\t"			\
 		__rseq_str(label) ":\n\t"				\
 		teardown						\
@@ -609,8 +616,8 @@ do {									\
 
 #define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)		\
 		".pushsection __rseq_failure, \"ax\"\n\t"		\
-		/* Disassembler-friendly signature: nopl <sig>. */	\
-		".byte 0x0f, 0x1f, 0x05\n\t"				\
+		/* Disassembler-friendly signature: ud1 <sig>,%edi. */	\
+		".byte 0x0f, 0xb9, 0x3d\n\t"				\
 		".long " __rseq_str(RSEQ_SIG) "\n\t"			\
 		__rseq_str(label) ":\n\t"				\
 		teardown						\
-- 
2.11.0
