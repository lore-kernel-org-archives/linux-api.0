From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 06/10] Fix: x86: Add missing core serializing instruction on migration
Date: Fri, 10 Nov 2017 16:37:13 -0500
Message-ID: <20171110213717.12457-7-mathieu.desnoyers@efficios.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.co>
List-Id: linux-api@vger.kernel.org

x86 has a missing core serializing instruction in migration scenarios.

Given that x86-32 can return to user-space with sysexit, and x86-64
through sysretq and sysretl, which are not core serializing, the
following user-space self-modifiying code (JIT) scenario can occur:

     CPU 0                      CPU 1

User-space self-modify code
Preempted
migrated              ->
                                scheduler selects task
                                Return to user-space (iret or sysexit)
                                User-space issues sync_core()
                      <-        migrated
scheduler selects task
Return to user-space (sysexit)
jump to modified code
Run modified code without sync_core() -> bug.

This migration pattern can return to user-space through sysexit,
sysretl, or sysretq, which are not core serializing, and therefore
breaks sequential consistency expectations from a single-threaded
process.

Fix this issue by invoking sync_core_before_usermode() the first
time a runqueue finishes a task switch after receiving a migrated
thread.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@kernel.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Andrew Hunter <ahh@google.com>
CC: Maged Michael <maged.michael@gmail.com>
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Dave Watson <davejwatson@fb.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrea Parri <parri.andrea@gmail.com>
CC: Russell King <linux@armlinux.org.uk>
CC: Greg Hackmann <ghackmann@google.com>
CC: Will Deacon <will.deacon@arm.com>
CC: David Sehr <sehr@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86@kernel.org
CC: linux-arch@vger.kernel.org
---
 kernel/sched/core.c  | 7 +++++++
 kernel/sched/sched.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c79e94278613..4a1c9782267a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -927,6 +927,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 
 	rq_lock(rq, rf);
 	BUG_ON(task_cpu(p) != new_cpu);
+	rq->need_sync_core = 1;
 	enqueue_task(rq, p, 0);
 	p->on_rq = TASK_ON_RQ_QUEUED;
 	check_preempt_curr(rq, p, 0);
@@ -2684,6 +2685,12 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	prev_state = prev->state;
 	vtime_task_switch(prev);
 	perf_event_task_sched_in(prev, current);
+#ifdef CONFIG_SMP
+	if (unlikely(rq->need_sync_core)) {
+		sync_core_before_usermode();
+		rq->need_sync_core = 0;
+	}
+#endif
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cab256c1720a..33e617bc491c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -734,6 +734,7 @@ struct rq {
 	/* For active balancing */
 	int active_balance;
 	int push_cpu;
+	int need_sync_core;
 	struct cpu_stop_work active_balance_work;
 	/* cpu of this runqueue: */
 	int cpu;
-- 
2.11.0
