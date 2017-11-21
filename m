From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 16/22] rseq: selftests: arm: workaround gcc asm size guess
Date: Tue, 21 Nov 2017 09:18:54 -0500
Message-ID: <20171121141900.18471-17-mathieu.desnoyers@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Florian Weimer <fweimer@redhat.com>, Shuah Khan <shuah@kernel.or>
List-Id: linux-api@vger.kernel.org

Fixes assembler errors:
/tmp/cceKwI9a.s: Assembler messages:
/tmp/cceKwI9a.s:849: Error: co-processor offset out of range

with gcc prior to gcc-7. This can trigger if multiple rseq inline asm
are used within the same function.

My best guess on the cause of this issue is that gcc has a hard
time figuring out the actual size of the inline asm, and therefore
does not compute the offsets at which literal values can be
placed from the program counter accurately.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Hunter <ahh@google.com>
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
CC: Florian Weimer <fweimer@redhat.com>
CC: Shuah Khan <shuah@kernel.org>
CC: linux-kselftest@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 tools/testing/selftests/rseq/rseq-arm.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/rseq/rseq-arm.h b/tools/testing/selftests/rseq/rseq-arm.h
index 47953c0cef4f..6d3fda276f4d 100644
--- a/tools/testing/selftests/rseq/rseq-arm.h
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -79,12 +79,15 @@ do {									\
 		teardown						\
 		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
 
+#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
+
 static inline __attribute__((always_inline))
 int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
 		int cpu)
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -115,11 +118,14 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -129,6 +135,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -164,11 +171,14 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -177,6 +187,7 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -203,8 +214,10 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
 		  RSEQ_INJECT_CLOBBER
 		: abort
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 }
@@ -216,6 +229,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -253,11 +267,14 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -268,6 +285,7 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -306,11 +324,14 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -321,6 +342,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 {
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
@@ -359,11 +381,14 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -376,6 +401,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		"str %[src], %[rseq_scratch0]\n\t"
@@ -442,11 +468,14 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
 
@@ -459,6 +488,7 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 
 	RSEQ_INJECT_C(9)
 
+	rseq_workaround_gcc_asm_size_guess();
 	__asm__ __volatile__ goto (
 		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
 		"str %[src], %[rseq_scratch0]\n\t"
@@ -526,10 +556,13 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
 		  RSEQ_INJECT_CLOBBER
 		: abort, cmpfail
 	);
+	rseq_workaround_gcc_asm_size_guess();
 	return 0;
 abort:
+	rseq_workaround_gcc_asm_size_guess();
 	RSEQ_INJECT_FAILED
 	return -1;
 cmpfail:
+	rseq_workaround_gcc_asm_size_guess();
 	return 1;
 }
-- 
2.11.0
