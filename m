From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.2 11/12] rseq/selftests: mips: use break instruction for RSEQ_SIG
Date: Mon, 29 Apr 2019 11:28:02 -0400
Message-ID: <20190429152803.7719-12-mathieu.desnoyers@efficios.com>
References: <20190429152803.7719-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429152803.7719-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

Use break as guard instruction for the restartable sequence abort
handler.

Previously, the chosen signature was simply data, based on the
assumption that it could always sit in a literal pool. However,
some compilation environments favor disabling literal pool. Therefore,
ensure the signature is a valid uncommon trap instruction.

Suggested-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Paul Burton <paul.burton@mips.com>
CC: James Hogan <jhogan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
---
 tools/testing/selftests/rseq/rseq-mips.h | 34 +++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/rseq-mips.h b/tools/testing/selftests/rseq/rseq-mips.h
index fe3eabcdcbe5..e989e7c14b09 100644
--- a/tools/testing/selftests/rseq/rseq-mips.h
+++ b/tools/testing/selftests/rseq/rseq-mips.h
@@ -7,7 +7,39 @@
  * (C) Copyright 2016-2018 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
  */
 
-#define RSEQ_SIG	0x53053053
+/*
+ * RSEQ_SIG uses the break instruction. The instruction pattern is:
+ *
+ * On MIPS:
+ *	0350000d        break     0x350
+ *
+ * On nanoMIPS:
+ *      00100350        break     0x350
+ *
+ * On microMIPS:
+ *      0000d407        break     0x350
+ *
+ * For nanoMIPS32 and microMIPS, the instruction stream is encoded as 16-bit
+ * halfwords, so the signature halfwords need to be swapped accordingly for
+ * little-endian.
+ */
+#if defined(__nanomips__)
+# ifdef __MIPSEL__
+#  define RSEQ_SIG	0x03500010
+# else
+#  define RSEQ_SIG	0x00100350
+# endif
+#elif defined(__mips_micromips)
+# ifdef __MIPSEL__
+#  define RSEQ_SIG	0xd4070000
+# else
+#  define RSEQ_SIG	0x0000d407
+# endif
+#elif defined(__mips__)
+# define RSEQ_SIG	0x0350000d
+#else
+/* Unknown MIPS architecture. */
+#endif
 
 #define rseq_smp_mb()	__asm__ __volatile__ ("sync" ::: "memory")
 #define rseq_smp_rmb()	rseq_smp_mb()
-- 
2.11.0
