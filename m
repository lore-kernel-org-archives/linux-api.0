From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.18 4/6] rseq: uapi: declare rseq_cs field as union, update includes
Date: Sun,  8 Jul 2018 17:03:28 -0400
Message-ID: <20180708210330.27324-5-mathieu.desnoyers@efficios.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Declaring the rseq_cs field as a union between __u64 and two __u32
allows both 32-bit and 64-bit kernels to read the full __u64, and
therefore validate that a 32-bit user-space cleared the upper 32
bits, thus ensuring a consistent behavior between native 32-bit
kernels and 32-bit compat tasks on 64-bit kernels.

Check that the rseq_cs value read is < TASK_SIZE.

The asm/byteorder.h header needs to be included by rseq.h, now
that it is not using linux/types_32_64.h anymore.

Considering that only __32 and __u64 types are declared in linux/rseq.h,
the linux/types.h header should always be included for both kernel and
user-space code: including stdint.h is just for u64 and u32, which are
not used in this header at all.

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
 include/uapi/linux/rseq.h           | 27 +++++++++++++++++++--------
 kernel/rseq.c                       | 10 ++++++----
 tools/testing/selftests/rseq/rseq.h | 11 ++++++++++-
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index bf4188c13bec..9a402fdb60e9 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -10,13 +10,8 @@
  * Copyright (c) 2015-2018 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
  */
 
-#ifdef __KERNEL__
-# include <linux/types.h>
-#else
-# include <stdint.h>
-#endif
-
-#include <linux/types_32_64.h>
+#include <linux/types.h>
+#include <asm/byteorder.h>
 
 enum rseq_cpu_id_state {
 	RSEQ_CPU_ID_UNINITIALIZED		= -1,
@@ -111,7 +106,23 @@ struct rseq {
 	 * atomicity semantics. This field should only be updated by the
 	 * thread which registered this data structure. Aligned on 64-bit.
 	 */
-	LINUX_FIELD_u32_u64(rseq_cs);
+	union {
+		__u64 ptr64;
+#ifdef __LP64__
+		__u64 ptr;
+#else
+		struct {
+#if (defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)) || defined(__BIG_ENDIAN)
+			__u32 padding;		/* Initialized to zero. */
+			__u32 ptr32;
+#else /* LITTLE */
+			__u32 ptr32;
+			__u32 padding;		/* Initialized to zero. */
+#endif /* ENDIAN */
+		} ptr;
+#endif
+	} rseq_cs;
+
 	/*
 	 * Restartable sequences flags field.
 	 *
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 2a7748675be7..fcc5ea1daa1f 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -115,19 +115,21 @@ static int rseq_reset_rseq_cpu_id(struct task_struct *t)
 static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 {
 	struct rseq_cs __user *urseq_cs;
-	unsigned long ptr;
+	u64 ptr;
 	u32 __user *usig;
 	u32 sig;
 	int ret;
 
-	ret = get_user(ptr, &t->rseq->rseq_cs);
+	ret = get_user(ptr, &t->rseq->rseq_cs.ptr64);
 	if (ret)
 		return ret;
 	if (!ptr) {
 		memset(rseq_cs, 0, sizeof(*rseq_cs));
 		return 0;
 	}
-	urseq_cs = (struct rseq_cs __user *)ptr;
+	if (ptr >= TASK_SIZE)
+		return -EINVAL;
+	urseq_cs = (struct rseq_cs __user *)(unsigned long)ptr;
 	if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
 		return -EFAULT;
 
@@ -203,7 +205,7 @@ static int clear_rseq_cs(struct task_struct *t)
 	 *
 	 * Set rseq_cs to NULL.
 	 */
-	return put_user(0UL, &t->rseq->rseq_cs);
+	return put_user(0ULL, &t->rseq->rseq_cs.ptr64);
 }
 
 /*
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
index a4684112676c..f2073cfa4448 100644
--- a/tools/testing/selftests/rseq/rseq.h
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -133,6 +133,15 @@ static inline uint32_t rseq_current_cpu(void)
 	return cpu;
 }
 
+static inline void rseq_clear_rseq_cs(void)
+{
+#ifdef __LP64__
+	__rseq_abi.rseq_cs.ptr = 0;
+#else
+	__rseq_abi.rseq_cs.ptr.ptr32 = 0;
+#endif
+}
+
 /*
  * rseq_prepare_unload() should be invoked by each thread using rseq_finish*()
  * at least once between their last rseq_finish*() and library unload of the
@@ -143,7 +152,7 @@ static inline uint32_t rseq_current_cpu(void)
  */
 static inline void rseq_prepare_unload(void)
 {
-	__rseq_abi.rseq_cs = 0;
+	rseq_clear_rseq_cs();
 }
 
 #endif  /* RSEQ_H_ */
-- 
2.11.0
