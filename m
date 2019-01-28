From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] Fix: membarrier: racy access to p->mm in membarrier_global_expedited()
Date: Mon, 28 Jan 2019 17:07:07 -0500
Message-ID: <20190128220707.30774-1-mathieu.desnoyers@efficios.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, stable@
List-Id: linux-api@vger.kernel.org

Jann Horn identified a racy access to p->mm in the global expedited
command of the membarrier system call.

The suggested fix is to hold the task_lock() around the accesses to
p->mm and to the mm_struct membarrier_state field to guarantee the
existence of the mm_struct.

Link: https://lore.kernel.org/lkml/CAG48ez2G8ctF8dHS42TF37pThfr3y0RNOOYTmxvACm4u8Yu3cw@mail.gmail.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Tested-by: Jann Horn <jannh@google.com>
CC: Jann Horn <jannh@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra (Intel) <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Andrea Parri <parri.andrea@gmail.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Dave Watson <davejwatson@fb.com>
CC: David Sehr <sehr@google.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Maged Michael <maged.michael@gmail.com>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Paul Mackerras <paulus@samba.org>
CC: Russell King <linux@armlinux.org.uk>
CC: Will Deacon <will.deacon@arm.com>
CC: stable@vger.kernel.org # v4.16+
CC: linux-api@vger.kernel.org
---
 kernel/sched/membarrier.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 76e0eaf4654e..305fdcc4c5f7 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -81,12 +81,27 @@ static int membarrier_global_expedited(void)
 
 		rcu_read_lock();
 		p = task_rcu_dereference(&cpu_rq(cpu)->curr);
-		if (p && p->mm && (atomic_read(&p->mm->membarrier_state) &
-				   MEMBARRIER_STATE_GLOBAL_EXPEDITED)) {
-			if (!fallback)
-				__cpumask_set_cpu(cpu, tmpmask);
-			else
-				smp_call_function_single(cpu, ipi_mb, NULL, 1);
+		/*
+		 * Skip this CPU if the runqueue's current task is NULL or if
+		 * it is a kernel thread.
+		 */
+		if (p && READ_ONCE(p->mm)) {
+			bool mm_match;
+
+			/*
+			 * Read p->mm and access membarrier_state while holding
+			 * the task lock to ensure existence of mm.
+			 */
+			task_lock(p);
+			mm_match = p->mm && (atomic_read(&p->mm->membarrier_state) &
+					     MEMBARRIER_STATE_GLOBAL_EXPEDITED);
+			task_unlock(p);
+			if (mm_match) {
+				if (!fallback)
+					__cpumask_set_cpu(cpu, tmpmask);
+				else
+					smp_call_function_single(cpu, ipi_mb, NULL, 1);
+			}
 		}
 		rcu_read_unlock();
 	}
-- 
2.17.1
