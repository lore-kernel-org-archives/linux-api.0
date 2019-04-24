From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 5.2 09/10] rseq/selftests: powerpc code signature: generate valid instructions
Date: Wed, 24 Apr 2019 11:25:01 -0400
Message-ID: <20190424152502.14246-10-mathieu.desnoyers@efficios.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Shuah Khan <shuah@kernel.org>
List-Id: linux-api@vger.kernel.org

Use "twui" as the guard instruction for the restartable sequence abort
handler.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Alan Modra <amodra@gmail.com>
CC: linuxppc-dev@lists.ozlabs.org
---
 tools/testing/selftests/rseq/rseq-ppc.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selftests/rseq/rseq-ppc.h
index 9df18487fa9f..76be90196fe4 100644
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -6,7 +6,15 @@
  * (C) Copyright 2016-2018 - Boqun Feng <boqun.feng@gmail.com>
  */
 
-#define RSEQ_SIG	0x53053053
+/*
+ * RSEQ_SIG is used with the following trap instruction:
+ *
+ * powerpc-be:    0f e5 00 0b           twui   r5,11
+ * powerpc64-le:  0b 00 e5 0f           twui   r5,11
+ * powerpc64-be:  0f e5 00 0b           twui   r5,11
+ */
+
+#define RSEQ_SIG	0x0fe5000b
 
 #define rseq_smp_mb()		__asm__ __volatile__ ("sync"	::: "memory", "cc")
 #define rseq_smp_lwsync()	__asm__ __volatile__ ("lwsync"	::: "memory", "cc")
-- 
2.11.0
