From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 02/14] tracing: instrument restartable sequences
Date: Thu, 12 Oct 2017 19:03:14 -0400
Message-ID: <20171012230326.19984-3-mathieu.desnoyers@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
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
 MAINTAINERS                 |  1 +
 include/trace/events/rseq.h | 64 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/rseq.c               |  7 +++++
 3 files changed, 72 insertions(+)
 create mode 100644 include/trace/events/rseq.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f05c526fe1e8..9d6a830a8c32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11233,6 +11233,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	kernel/rseq.c
 F:	include/uapi/linux/rseq.h
+F:	include/trace/events/rseq.h
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
diff --git a/include/trace/events/rseq.h b/include/trace/events/rseq.h
new file mode 100644
index 000000000000..63a8eb7d553d
--- /dev/null
+++ b/include/trace/events/rseq.h
@@ -0,0 +1,64 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rseq
+
+#if !defined(_TRACE_RSEQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RSEQ_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+TRACE_EVENT(rseq_update,
+
+	TP_PROTO(struct task_struct *t),
+
+	TP_ARGS(t),
+
+	TP_STRUCT__entry(
+		__field(s32, cpu_id)
+		__field(u32, event_counter)
+	),
+
+	TP_fast_assign(
+		__entry->cpu_id = raw_smp_processor_id();
+		__entry->event_counter = t->rseq_event_counter;
+	),
+
+	TP_printk("cpu_id=%d event_counter=%u",
+		__entry->cpu_id, __entry->event_counter)
+);
+
+TRACE_EVENT(rseq_ip_fixup,
+
+	TP_PROTO(void __user *regs_ip, void __user *start_ip,
+		void __user *post_commit_ip, void __user *abort_ip,
+		u32 kevcount, int ret),
+
+	TP_ARGS(regs_ip, start_ip, post_commit_ip, abort_ip, kevcount, ret),
+
+	TP_STRUCT__entry(
+		__field(void __user *, regs_ip)
+		__field(void __user *, start_ip)
+		__field(void __user *, post_commit_ip)
+		__field(void __user *, abort_ip)
+		__field(u32, kevcount)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->regs_ip = regs_ip;
+		__entry->start_ip = start_ip;
+		__entry->post_commit_ip = post_commit_ip;
+		__entry->abort_ip = abort_ip;
+		__entry->kevcount = kevcount;
+		__entry->ret = ret;
+	),
+
+	TP_printk("regs_ip=%p start_ip=%p post_commit_ip=%p abort_ip=%p kevcount=%u ret=%d",
+		__entry->regs_ip, __entry->start_ip, __entry->post_commit_ip,
+		__entry->abort_ip, __entry->kevcount, __entry->ret)
+);
+
+#endif /* _TRACE_SOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 706a83bd885c..31582e5ff3be 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -32,6 +32,9 @@
 #include <linux/types.h>
 #include <asm/ptrace.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/rseq.h>
+
 /*
  * The restartable sequences mechanism is the overlap of two distinct
  * restart mechanisms: a sequence counter tracking preemption and signal
@@ -139,6 +142,7 @@ static bool rseq_update_cpu_id_event_counter(struct task_struct *t,
 			t->rseq_event_counter;
 	if (__put_user(u.v, &t->rseq->u.v))
 		return false;
+	trace_rseq_update(t);
 	return true;
 }
 
@@ -230,6 +234,9 @@ static int rseq_ip_fixup(struct pt_regs *regs)
 
 	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_ip, &abort_ip,
 			&cs_flags);
+	trace_rseq_ip_fixup((void __user *)instruction_pointer(regs),
+		start_ip, post_commit_ip, abort_ip, t->rseq_event_counter,
+		ret);
 	if (!ret)
 		return -EFAULT;
 
-- 
2.11.0
