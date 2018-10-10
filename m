From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 01/16] rseq/selftests: Add reference counter to coexist with glibc
Date: Wed, 10 Oct 2018 15:19:21 -0400
Message-ID: <20181010191936.7495-2-mathieu.desnoyers@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

In order to integrate rseq into user-space applications, add a reference
counter field after the struct rseq TLS ABI so many rseq users can be
linked into the same application (e.g. librseq and glibc). The
reference count ensures that rseq syscall registration/unregistration
happens only for the most early/late user for each thread, thus ensuring
that rseq is registered across the lifetime of all rseq users for a
given thread.

Therefore, struct rseq contains the fields shared between kernel
and user-space, and represents the ABI between kernel and user-space.
The extra field added after struct rseq is an ABI between user-space
executable and libraries, but the kernel does not care about that field,
so it is not part of the Linux uapi.

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
 tools/testing/selftests/rseq/rseq.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 4847e97ed049..7e9ae973f786 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -30,13 +30,29 @@
 
 #define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
 
-__attribute__((tls_model("initial-exec"))) __thread
-volatile struct rseq __rseq_abi = {
+/*
+ * linux/rseq.h defines struct rseq as aligned on 32 bytes. The kernel ABI
+ * size is 20 bytes. For support of multiple rseq users within a process,
+ * user-space defines an extra 4 bytes field as a reference count, for a
+ * total of 24 bytes.
+ */
+struct libc_rseq {
+	/* kernel-userspace ABI. */
+	__u32 cpu_id_start;
+	__u32 cpu_id;
+	__u64 rseq_cs;
+	__u32 flags;
+	/* user-space ABI. */
+	__u32 refcount;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+__attribute__((visibility("hidden"))) __thread
+volatile struct libc_rseq __lib_rseq_abi = {
 	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
 };
 
-static __attribute__((tls_model("initial-exec"))) __thread
-volatile int refcount;
+extern __attribute__((weak, alias("__lib_rseq_abi"))) __thread
+volatile struct rseq __rseq_abi;
 
 static void signal_off_save(sigset_t *oldset)
 {
@@ -70,7 +86,7 @@ int rseq_register_current_thread(void)
 	sigset_t oldset;
 
 	signal_off_save(&oldset);
-	if (refcount++)
+	if (__lib_rseq_abi.refcount++)
 		goto end;
 	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
 	if (!rc) {
@@ -78,9 +94,9 @@ int rseq_register_current_thread(void)
 		goto end;
 	}
 	if (errno != EBUSY)
-		__rseq_abi.cpu_id = -2;
+		__rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
 	ret = -1;
-	refcount--;
+	__lib_rseq_abi.refcount--;
 end:
 	signal_restore(oldset);
 	return ret;
@@ -92,7 +108,7 @@ int rseq_unregister_current_thread(void)
 	sigset_t oldset;
 
 	signal_off_save(&oldset);
-	if (--refcount)
+	if (--__lib_rseq_abi.refcount)
 		goto end;
 	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq),
 		      RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
-- 
2.11.0
