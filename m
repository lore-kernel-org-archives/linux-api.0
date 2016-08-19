From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v8 2/9] tracing: instrument restartable sequences
Date: Fri, 19 Aug 2016 16:07:47 -0400
Message-ID: <1471637274-13583-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471637274-13583-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/trace/events/rseq.h | 64 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/rseq.c               | 11 +++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/rseq.h

diff --git a/include/trace/events/rseq.h b/include/trace/events/rseq.h
new file mode 100644
index 0000000..63a8eb7
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
index 32bc1d2..a102fcc 100644
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
@@ -137,6 +140,7 @@ static bool rseq_update_cpu_id_event_counter(struct task_struct *t)
 	u.e.event_counter = ++t->rseq_event_counter;
 	if (__put_user(u.v, &t->rseq->u.v))
 		return false;
+	trace_rseq_update(t);
 	return true;
 }
 
@@ -168,8 +172,13 @@ static bool rseq_ip_fixup(struct pt_regs *regs)
 	void __user *start_ip = NULL;
 	void __user *post_commit_ip = NULL;
 	void __user *abort_ip = NULL;
+	bool ret;
 
-	if (!rseq_get_rseq_cs(t, &start_ip, &post_commit_ip, &abort_ip))
+	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_ip, &abort_ip);
+	trace_rseq_ip_fixup((void __user *)instruction_pointer(regs),
+		start_ip, post_commit_ip, abort_ip, t->rseq_event_counter,
+		ret);
+	if (!ret)
 		return false;
 
 	/* Handle potentially not being within a critical section. */
-- 
2.1.4
