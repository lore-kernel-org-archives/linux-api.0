From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 2/2] rseq: validate rseq->rseq_cs padding to be zero
Date: Mon,  2 Jul 2018 16:40:58 -0400
Message-ID: <20180702204058.819-2-mathieu.desnoyers@efficios.com>
References: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

On 32-bit kernels, the rseq->rseq_cs_padding field is never read by the
kernel. However, 64-bit kernels dealing with 32-bit compat tasks read the
full 64-bit in its entirety, and terminates the offending process with
a segmentation fault if the upper 32 bits are set due to failure of
copy_from_user().

Ensure that both 32-bit and 64-bit kernels dealing with 32-bit tasks end
up terminating offending tasks with a segmentation fault if the upper
32-bit padding bits (rseq->rseq_cs_padding) are set by explicitly ensuring
that padding is zero on 32-bit kernels.

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
 kernel/rseq.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 2e5d88f09baf..c4c48157198f 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -112,6 +112,29 @@ static int rseq_reset_rseq_cpu_id(struct task_struct *t)
 	return 0;
 }
 
+#ifndef __LP64__
+/*
+ * Ensure that padding is zero.
+ */
+static int check_rseq_cs_padding(struct task_struct *t)
+{
+	unsigned long pad;
+	int ret;
+
+	ret = __get_user(pad, &t->rseq->rseq_cs_padding);
+	if (ret)
+		return ret;
+	if (pad)
+		return -EFAULT;
+	return 0;
+}
+#else
+static int check_rseq_cs_padding(struct task_struct *t)
+{
+	return 0;
+}
+#endif
+
 static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 {
 	struct rseq_cs __user *urseq_cs;
@@ -123,6 +146,9 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	ret = __get_user(ptr, &t->rseq->rseq_cs);
 	if (ret)
 		return ret;
+	ret = check_rseq_cs_padding(t);
+	if (ret)
+		return ret;
 	if (!ptr) {
 		memset(rseq_cs, 0, sizeof(*rseq_cs));
 		return 0;
-- 
2.11.0
