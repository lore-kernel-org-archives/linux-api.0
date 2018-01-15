From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.16 04/10] membarrier: provide SHARED_EXPEDITED command (v2)
Date: Mon, 15 Jan 2018 14:10:58 -0500
Message-ID: <20180115191104.12437-5-mathieu.desnoyers@efficios.com>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115191104.12437-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.
List-Id: linux-api@vger.kernel.org

Allow expedited membarrier to be used for data shared between processes
(shared memory).

Processes wishing to receive the membarriers register with
MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED. Those which want to issue
membarrier invoke MEMBARRIER_CMD_SHARED_EXPEDITED.

This allows extremely simple kernel-level implementation: we have almost
everything we need with the PRIVATE_EXPEDITED barrier code. All we need
to do is to add a flag in the mm_struct that will be used to check
whether we need to send the IPI to the current thread of each CPU.

There is a slight downside to this approach compared to targeting
specific shared memory users: when performing a membarrier operation,
all registered "shared" receivers will get the barrier, even if they
don't share a memory mapping with the "sender" issuing
MEMBARRIER_CMD_SHARED_EXPEDITED.

This registration approach seems to fit the requirement of not
disturbing processes that really deeply care about real-time: they
simply should not register with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
CC: x86@kernel.org
---
Changes since v1:
- Add missing preempt disable around smp_call_function_many().
---
 arch/powerpc/include/asm/membarrier.h |   3 +-
 include/linux/sched/mm.h              |   6 +-
 include/uapi/linux/membarrier.h       |  34 ++++++++--
 kernel/sched/membarrier.c             | 114 ++++++++++++++++++++++++++++++++--
 4 files changed, 143 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
index 98ff4f1fcf2b..20cd79ed3fc6 100644
--- a/arch/powerpc/include/asm/membarrier.h
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -13,7 +13,8 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 	 * store to rq->curr.
 	 */
 	if (likely(!(atomic_read(&next->membarrier_state) &
-		     MEMBARRIER_STATE_PRIVATE_EXPEDITED) || !prev))
+		     (MEMBARRIER_STATE_PRIVATE_EXPEDITED |
+		      MEMBARRIER_STATE_SHARED_EXPEDITED)) || !prev))
 		return;
 
 	/*
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 28aef7051d73..cbeecd287589 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -219,8 +219,10 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 
 #ifdef CONFIG_MEMBARRIER
 enum {
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY	= (1U << 0),
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED		= (1U << 1),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY		= (1U << 0),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
+	MEMBARRIER_STATE_SHARED_EXPEDITED_READY			= (1U << 2),
+	MEMBARRIER_STATE_SHARED_EXPEDITED			= (1U << 3),
 };
 
 #ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membarrier.h
index 4e01ad7ffe98..2de01e595d3b 100644
--- a/include/uapi/linux/membarrier.h
+++ b/include/uapi/linux/membarrier.h
@@ -40,6 +40,28 @@
  *                          (non-running threads are de facto in such a
  *                          state). This covers threads from all processes
  *                          running on the system. This command returns 0.
+ * @MEMBARRIER_CMD_SHARED_EXPEDITED:
+ *                          Execute a memory barrier on all running threads
+ *                          part of a process which previously registered
+ *                          with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.
+ *                          Upon return from system call, the caller thread
+ *                          is ensured that all running threads have passed
+ *                          through a state where all memory accesses to
+ *                          user-space addresses match program order between
+ *                          entry to and return from the system call
+ *                          (non-running threads are de facto in such a
+ *                          state). This only covers threads from processes
+ *                          which registered with
+ *                          MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.
+ *                          This command returns 0. Given that
+ *                          registration is about the intent to receive
+ *                          the barriers, it is valid to invoke
+ *                          MEMBARRIER_CMD_SHARED_EXPEDITED from a
+ *                          non-registered process.
+ * @MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED:
+ *                          Register the process intent to receive
+ *                          MEMBARRIER_CMD_SHARED_EXPEDITED memory
+ *                          barriers. Always returns 0.
  * @MEMBARRIER_CMD_PRIVATE_EXPEDITED:
  *                          Execute a memory barrier on each running
  *                          thread belonging to the same process as the current
@@ -70,12 +92,12 @@
  * the value 0.
  */
 enum membarrier_cmd {
-	MEMBARRIER_CMD_QUERY				= 0,
-	MEMBARRIER_CMD_SHARED				= (1 << 0),
-	/* reserved for MEMBARRIER_CMD_SHARED_EXPEDITED (1 << 1) */
-	/* reserved for MEMBARRIER_CMD_PRIVATE (1 << 2) */
-	MEMBARRIER_CMD_PRIVATE_EXPEDITED		= (1 << 3),
-	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED	= (1 << 4),
+	MEMBARRIER_CMD_QUERY					= 0,
+	MEMBARRIER_CMD_SHARED					= (1 << 0),
+	MEMBARRIER_CMD_SHARED_EXPEDITED				= (1 << 1),
+	MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED		= (1 << 2),
+	MEMBARRIER_CMD_PRIVATE_EXPEDITED			= (1 << 3),
+	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED		= (1 << 4),
 };
 
 #endif /* _UAPI_LINUX_MEMBARRIER_H */
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 678577267a9a..14bc8bf9e736 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -27,7 +27,9 @@
  * except MEMBARRIER_CMD_QUERY.
  */
 #define MEMBARRIER_CMD_BITMASK	\
-	(MEMBARRIER_CMD_SHARED | MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
+	(MEMBARRIER_CMD_SHARED | MEMBARRIER_CMD_SHARED_EXPEDITED \
+	| MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED \
+	| MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED)
 
 static void ipi_mb(void *info)
@@ -35,6 +37,73 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static int membarrier_shared_expedited(void)
+{
+	int cpu;
+	bool fallback = false;
+	cpumask_var_t tmpmask;
+
+	if (num_online_cpus() == 1)
+		return 0;
+
+	/*
+	 * Matches memory barriers around rq->curr modification in
+	 * scheduler.
+	 */
+	smp_mb();	/* system call entry is not a mb. */
+
+	/*
+	 * Expedited membarrier commands guarantee that they won't
+	 * block, hence the GFP_NOWAIT allocation flag and fallback
+	 * implementation.
+	 */
+	if (!zalloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
+		/* Fallback for OOM. */
+		fallback = true;
+	}
+
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		struct task_struct *p;
+
+		/*
+		 * Skipping the current CPU is OK even through we can be
+		 * migrated at any point. The current CPU, at the point
+		 * where we read raw_smp_processor_id(), is ensured to
+		 * be in program order with respect to the caller
+		 * thread. Therefore, we can skip this CPU from the
+		 * iteration.
+		 */
+		if (cpu == raw_smp_processor_id())
+			continue;
+		rcu_read_lock();
+		p = task_rcu_dereference(&cpu_rq(cpu)->curr);
+		if (p && p->mm && (atomic_read(&p->mm->membarrier_state) &
+				   MEMBARRIER_STATE_SHARED_EXPEDITED)) {
+			if (!fallback)
+				__cpumask_set_cpu(cpu, tmpmask);
+			else
+				smp_call_function_single(cpu, ipi_mb, NULL, 1);
+		}
+		rcu_read_unlock();
+	}
+	if (!fallback) {
+		preempt_disable();
+		smp_call_function_many(tmpmask, ipi_mb, NULL, 1);
+		preempt_enable();
+		free_cpumask_var(tmpmask);
+	}
+	cpus_read_unlock();
+
+	/*
+	 * Memory barrier on the caller thread _after_ we finished
+	 * waiting for the last IPI. Matches memory barriers around
+	 * rq->curr modification in scheduler.
+	 */
+	smp_mb();	/* exit from system call is not a mb */
+	return 0;
+}
+
 static int membarrier_private_expedited(void)
 {
 	int cpu;
@@ -105,7 +174,38 @@ static int membarrier_private_expedited(void)
 	return 0;
 }
 
-static void membarrier_register_private_expedited(void)
+static int membarrier_register_shared_expedited(void)
+{
+	struct task_struct *p = current;
+	struct mm_struct *mm = p->mm;
+
+	if (atomic_read(&mm->membarrier_state) &
+	    MEMBARRIER_STATE_SHARED_EXPEDITED_READY)
+		return 0;
+	atomic_or(MEMBARRIER_STATE_SHARED_EXPEDITED, &mm->membarrier_state);
+	if (atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1) {
+		/*
+		 * For single mm user, single threaded process, we can
+		 * simply issue a memory barrier after setting
+		 * MEMBARRIER_STATE_SHARED_EXPEDITED to guarantee that
+		 * no memory access following registration is reordered
+		 * before registration.
+		 */
+		smp_mb();
+	} else {
+		/*
+		 * For multi-mm user threads, we need to ensure all
+		 * future scheduler executions will observe the new
+		 * thread flag state for this mm.
+		 */
+		synchronize_sched();
+	}
+	atomic_or(MEMBARRIER_STATE_SHARED_EXPEDITED_READY,
+		  &mm->membarrier_state);
+	return 0;
+}
+
+static int membarrier_register_private_expedited(void)
 {
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
@@ -117,7 +217,7 @@ static void membarrier_register_private_expedited(void)
 	 */
 	if (atomic_read(&mm->membarrier_state)
 			& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY)
-		return;
+		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED, &mm->membarrier_state);
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
 		/*
@@ -128,6 +228,7 @@ static void membarrier_register_private_expedited(void)
 	}
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
 			&mm->membarrier_state);
+	return 0;
 }
 
 /**
@@ -177,11 +278,14 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
 		if (num_online_cpus() > 1)
 			synchronize_sched();
 		return 0;
+	case MEMBARRIER_CMD_SHARED_EXPEDITED:
+		return membarrier_shared_expedited();
+	case MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED:
+		return membarrier_register_shared_expedited();
 	case MEMBARRIER_CMD_PRIVATE_EXPEDITED:
 		return membarrier_private_expedited();
 	case MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED:
-		membarrier_register_private_expedited();
-		return 0;
+		return membarrier_register_private_expedited();
 	default:
 		return -EINVAL;
 	}
-- 
2.11.0
