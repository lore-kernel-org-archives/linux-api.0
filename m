From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 01/11] Fix: membarrier: add missing preempt off around smp_call_function_many
Date: Wed, 10 Jan 2018 10:46:15 -0500
Message-ID: <20180110154625.4319-2-mathieu.desnoyers@efficios.com>
References: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.
List-Id: linux-api@vger.kernel.org

smp_call_function_many requires disabling preemption around the call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>
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
CC: <stable@vger.kernel.org> #v4.14
---
 kernel/sched/membarrier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index dd7908743dab..9bcbacba82a8 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -89,7 +89,9 @@ static int membarrier_private_expedited(void)
 		rcu_read_unlock();
 	}
 	if (!fallback) {
+		preempt_disable();
 		smp_call_function_many(tmpmask, ipi_mb, NULL, 1);
+		preempt_enable();
 		free_cpumask_var(tmpmask);
 	}
 	cpus_read_unlock();
-- 
2.11.0
