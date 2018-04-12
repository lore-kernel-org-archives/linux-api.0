From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 09/23] sched: Implement push_task_to_cpu (v2)
Date: Thu, 12 Apr 2018 15:27:46 -0400
Message-ID: <20180412192800.15708-10-mathieu.desnoyers@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Implement push_task_to_cpu(), which moves the task received as argument
to the destination cpu's runqueue. It only does so if the CPU is within
the CPU allowed mask of the task and if the CPU is active. If the CPU is
not part of the allowed mask, -EINVAL is returned. If the CPU is not
active, -EBUSY is returned.

It does not change the CPU allowed mask, and can therefore be used
within applications which rely on owning the sched_setaffinity() state.

It does not pin the task to the destination CPU, which means that the
scheduler may choose to move the task away from that CPU before the
task executes. Code invoking push_task_to_cpu() must be prepared to
retry in that case.

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
CC: linux-api@vger.kernel.org

---
Change since v1:
- Return -EBUSY if CPU is not active.
---
 kernel/sched/core.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |  9 +++++++++
 2 files changed, 51 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8e8bd91b9bd7..d65f227b0f18 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1062,6 +1062,48 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 		set_curr_task(rq, p);
 }
 
+int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+	int ret = 0;
+
+	rq = task_rq_lock(p, &rf);
+	update_rq_clock(rq);
+
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!cpumask_test_cpu(dest_cpu, cpu_active_mask)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (task_cpu(p) == dest_cpu)
+		goto out;
+
+	if (task_running(rq, p) || p->state == TASK_WAKING) {
+		struct migration_arg arg = { p, dest_cpu };
+		/* Need help from migration thread: drop lock and wait. */
+		task_rq_unlock(rq, p, &rf);
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		tlb_migrate_finish(p->mm);
+		return 0;
+	} else if (task_on_rq_queued(p)) {
+		/*
+		 * OK, since we're going to drop the lock immediately
+		 * afterwards anyway.
+		 */
+		rq = move_queued_task(rq, &rf, p, dest_cpu);
+	}
+out:
+	task_rq_unlock(rq, p, &rf);
+
+	return ret;
+}
+
 /*
  * Change a given task's CPU affinity. Migrate the thread to a
  * proper CPU and schedule it away if the CPU it's executing on
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb5fc458547f..43fdfcb0738a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1251,6 +1251,15 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+#ifdef CONFIG_SMP
+int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu);
+#else
+static inline int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
+{
+	return 0;
+}
+#endif
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
-- 
2.11.0
