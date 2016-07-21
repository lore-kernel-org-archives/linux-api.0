From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v7 2/7] tracing: instrument restartable sequences
Date: Thu, 21 Jul 2016 17:14:17 -0400
Message-ID: <1469135662-31512-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
 include/trace/events/rseq.h | 60 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/rseq.c               | 18 +++++++++++---
 2 files changed, 75 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/events/rseq.h

diff --git a/include/trace/events/rseq.h b/include/trace/events/rseq.h
new file mode 100644
index 0000000..83fd31e
--- /dev/null
+++ b/include/trace/events/rseq.h
@@ -0,0 +1,60 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rseq
+
+#if !defined(_TRACE_RSEQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RSEQ_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(rseq_inc,
+
+	TP_PROTO(uint32_t event_counter, int ret),
+
+	TP_ARGS(event_counter, ret),
+
+	TP_STRUCT__entry(
+		__field(uint32_t, event_counter)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->event_counter = event_counter;
+		__entry->ret = ret;
+	),
+
+	TP_printk("event_counter=%u ret=%d",
+		__entry->event_counter, __entry->ret)
+);
+
+TRACE_EVENT(rseq_ip_fixup,
+
+	TP_PROTO(void __user *regs_ip, void __user *post_commit_ip,
+		void __user *abort_ip, uint32_t kevcount, int ret),
+
+	TP_ARGS(regs_ip, post_commit_ip, abort_ip, kevcount, ret),
+
+	TP_STRUCT__entry(
+		__field(void __user *, regs_ip)
+		__field(void __user *, post_commit_ip)
+		__field(void __user *, abort_ip)
+		__field(uint32_t, kevcount)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->regs_ip = regs_ip;
+		__entry->post_commit_ip = post_commit_ip;
+		__entry->abort_ip = abort_ip;
+		__entry->kevcount = kevcount;
+		__entry->ret = ret;
+	),
+
+	TP_printk("regs_ip=%p post_commit_ip=%p abort_ip=%p kevcount=%u ret=%d",
+		__entry->regs_ip, __entry->post_commit_ip, __entry->abort_ip,
+		__entry->kevcount, __entry->ret)
+);
+
+#endif /* _TRACE_SOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/rseq.c b/kernel/rseq.c
index e1c847b..cab326a 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -29,6 +29,9 @@
 #include <linux/rseq.h>
 #include <asm/ptrace.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/rseq.h>
+
 /*
  * Each restartable sequence assembly block defines a "struct rseq_cs"
  * structure which describes the post_commit_ip address, and the
@@ -90,8 +93,12 @@
 
 static int rseq_increment_event_counter(struct task_struct *t)
 {
-	if (__put_user(++t->rseq_event_counter,
-			&t->rseq->u.e.event_counter))
+	int ret;
+
+	ret = __put_user(++t->rseq_event_counter,
+			&t->rseq->u.e.event_counter);
+	trace_rseq_inc(t->rseq_event_counter, ret);
+	if (ret)
 		return -1;
 	return 0;
 }
@@ -134,8 +141,13 @@ static int rseq_ip_fixup(struct pt_regs *regs)
 	struct task_struct *t = current;
 	void __user *post_commit_ip = NULL;
 	void __user *abort_ip = NULL;
+	int ret;
 
-	if (rseq_get_rseq_cs(t, &post_commit_ip, &abort_ip))
+	ret = rseq_get_rseq_cs(t, &post_commit_ip, &abort_ip);
+	trace_rseq_ip_fixup((void __user *)instruction_pointer(regs),
+		post_commit_ip, abort_ip, t->rseq_event_counter,
+		ret);
+	if (ret)
 		return -1;
 
 	/* Handle potentially being within a critical section. */
-- 
2.1.4
