From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 2/2] rseq: compat: clear high bits of rseq_cs fields
Date: Tue, 26 Jun 2018 17:16:17 -0400
Message-ID: <20180626211617.8933-2-mathieu.desnoyers@efficios.com>
References: <20180626211617.8933-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180626211617.8933-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joelaf@google.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.
List-Id: linux-api@vger.kernel.org

Make the behavior rseq on compat tasks more robust by ensuring that
kernel/rseq.c:rseq_get_rseq_cs() clears the high bits of
rseq_cs->abort_ip, rseq_cs->start_ip and rseq_cs->post_commit_offset
when a 32-bit binary is run on a 64-bit kernel.

The intent here is that if user-space has garbage rather than zeroes
in its struct rseq_cs fields padding, the behavior will be the same
whether the binary is run on 32-bit or 64-bit kernels.

Use in_compat_syscall() when rseq_get_rseq_cs() is invoked from
system call context, and use is_compat_frame() when invoked from
signal delivery.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Watson <davejwatson@fb.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Chris Lameter <cl@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Hunter <ahh@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Maurer <bmaurer@fb.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/rseq.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 22b6acf1ad63..7b1d51b965fc 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -13,6 +13,7 @@
 #include <linux/syscalls.h>
 #include <linux/rseq.h>
 #include <linux/types.h>
+#include <linux/compat.h>
 #include <asm/ptrace.h>
 
 #define CREATE_TRACE_POINTS
@@ -112,7 +113,23 @@ static int rseq_reset_rseq_cpu_id(struct task_struct *t)
 	return 0;
 }
 
-static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
+#ifdef CONFIG_COMPAT
+static void rseq_cs_compat(struct ksignal *ksig, struct rseq_cs *rseq_cs)
+{
+	if (!(ksig ? is_compat_frame(ksig) : in_compat_syscall()))
+		return;
+
+	rseq_cs->abort_ip = (compat_uptr_t) rseq_cs->abort_ip;
+	rseq_cs->start_ip = (compat_uptr_t) rseq_cs->start_ip;
+	rseq_cs->post_commit_offset =
+		(compat_uptr_t) rseq_cs->post_commit_offset;
+}
+#else
+static void rseq_cs_compat(struct ksignal *ksig, struct rseq_cs *rseq_cs) { }
+#endif
+
+static int rseq_get_rseq_cs(struct ksignal *ksig, struct task_struct *t,
+			    struct rseq_cs *rseq_cs)
 {
 	struct rseq_cs __user *urseq_cs;
 	unsigned long ptr;
@@ -132,6 +149,7 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 		return -EFAULT;
 	if (rseq_cs->version > 0)
 		return -EINVAL;
+	rseq_cs_compat(ksig, rseq_cs);
 
 	/* Ensure that abort_ip is not in the critical section. */
 	if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
@@ -209,14 +227,14 @@ static bool in_rseq_cs(unsigned long ip, struct rseq_cs *rseq_cs)
 	return ip - rseq_cs->start_ip < rseq_cs->post_commit_offset;
 }
 
-static int rseq_ip_fixup(struct pt_regs *regs)
+static int rseq_ip_fixup(struct ksignal *ksig, struct pt_regs *regs)
 {
 	unsigned long ip = instruction_pointer(regs);
 	struct task_struct *t = current;
 	struct rseq_cs rseq_cs;
 	int ret;
 
-	ret = rseq_get_rseq_cs(t, &rseq_cs);
+	ret = rseq_get_rseq_cs(ksig, t, &rseq_cs);
 	if (ret)
 		return ret;
 
@@ -260,7 +278,7 @@ void __rseq_handle_notify_resume(struct ksignal *ksig, struct pt_regs *regs)
 		return;
 	if (unlikely(!access_ok(VERIFY_WRITE, t->rseq, sizeof(*t->rseq))))
 		goto error;
-	ret = rseq_ip_fixup(regs);
+	ret = rseq_ip_fixup(ksig, regs);
 	if (unlikely(ret < 0))
 		goto error;
 	if (unlikely(rseq_update_cpu_id(t)))
@@ -287,7 +305,7 @@ void rseq_syscall(struct pt_regs *regs)
 	if (!t->rseq)
 		return;
 	if (!access_ok(VERIFY_READ, t->rseq, sizeof(*t->rseq)) ||
-	    rseq_get_rseq_cs(t, &rseq_cs) || in_rseq_cs(ip, &rseq_cs))
+	    rseq_get_rseq_cs(NULL, t, &rseq_cs) || in_rseq_cs(ip, &rseq_cs))
 		force_sig(SIGSEGV, t);
 }
 
-- 
2.11.0
