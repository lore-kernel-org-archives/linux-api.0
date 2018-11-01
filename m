From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 01/16] rseq/selftests: Expose reference counter to coexist with glibc (v2)
Date: Thu,  1 Nov 2018 10:58:29 +0100
Message-ID: <20181101095844.24462-2-mathieu.desnoyers@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

In order to integrate rseq into user-space applications, expose a
reference counter TLS as a __rseq_refcount weak symbol so many rseq
users can be linked into the same application (e.g. librseq and glibc).
The reference count ensures that rseq syscall
registration/unregistration happens only for the most early/late user
for each thread, thus ensuring that rseq is registered across the
lifetime of all rseq users for a given thread.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Carlos O'Donell <carlos@redhat.com>
CC: Florian Weimer <fweimer@redhat.com>
CC: Joseph Myers <joseph@codesourcery.com>
CC: Szabolcs Nagy <szabolcs.nagy@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Maurer <bmaurer@fb.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Dave Watson <davejwatson@fb.com>
CC: Paul Turner <pjt@google.com>
CC: linux-api@vger.kernel.org
---
Changes since v1:
- Error out on refcount overflow/underflow.
- Expose __rseq_refcount weak symbol.
---
 tools/testing/selftests/rseq/rseq.c | 23 ++++++++++++++++-------
 tools/testing/selftests/rseq/rseq.h |  1 +
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 4847e97ed049..835e3917d220 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -25,18 +25,19 @@
 #include <syscall.h>
 #include <assert.h>
 #include <signal.h>
+#include <limits.h>
 
 #include "rseq.h"
 
 #define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
 
-__attribute__((tls_model("initial-exec"))) __thread
+__attribute__((weak)) __thread
 volatile struct rseq __rseq_abi = {
 	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
 };
 
-static __attribute__((tls_model("initial-exec"))) __thread
-volatile int refcount;
+__attribute__((weak)) __thread
+volatile uint32_t __rseq_refcount;
 
 static void signal_off_save(sigset_t *oldset)
 {
@@ -70,7 +71,11 @@ int rseq_register_current_thread(void)
 	sigset_t oldset;
 
 	signal_off_save(&oldset);
-	if (refcount++)
+	if (__rseq_refcount == UINT_MAX) {
+		ret = -1;
+		goto end;
+	}
+	if (__rseq_refcount++)
 		goto end;
 	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
 	if (!rc) {
@@ -78,9 +83,9 @@ int rseq_register_current_thread(void)
 		goto end;
 	}
 	if (errno != EBUSY)
-		__rseq_abi.cpu_id = -2;
+		__rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
 	ret = -1;
-	refcount--;
+	__rseq_refcount--;
 end:
 	signal_restore(oldset);
 	return ret;
@@ -92,7 +97,11 @@ int rseq_unregister_current_thread(void)
 	sigset_t oldset;
 
 	signal_off_save(&oldset);
-	if (--refcount)
+	if (!__rseq_refcount) {
+		ret = -1;
+		goto end;
+	}
+	if (--__rseq_refcount)
 		goto end;
 	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq),
 		      RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index c72eb70f9b52..47f815c19cef 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -45,6 +45,7 @@
 #endif
 
 extern __thread volatile struct rseq __rseq_abi;
+extern __thread volatile uint32_t __rseq_refcount;
 
 #define rseq_likely(x)		__builtin_expect(!!(x), 1)
 #define rseq_unlikely(x)	__builtin_expect(!!(x), 0)
-- 
2.11.0
