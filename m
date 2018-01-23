From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/11] membarrier: provide GLOBAL_EXPEDITED command (v3)
Date: Tue, 23 Jan 2018 10:57:26 -0500
Message-ID: <20180123155733.3404-5-mathieu.desnoyers@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Allow expedited membarrier to be used for data shared between processes
through shared memory.

Processes wishing to receive the membarriers register with
MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED. Those which want to issue
membarrier invoke MEMBARRIER_CMD_GLOBAL_EXPEDITED.

This allows extremely simple kernel-level implementation: we have almost
everything we need with the PRIVATE_EXPEDITED barrier code. All we need
to do is to add a flag in the mm_struct that will be used to check
whether we need to send the IPI to the current thread of each CPU.

There is a slight downside to this approach compared to targeting
specific shared memory users: when performing a membarrier operation,
all registered "global" receivers will get the barrier, even if they
don't share a memory mapping with the sender issuing
MEMBARRIER_CMD_GLOBAL_EXPEDITED.

This registration approach seems to fit the requirement of not
disturbing processes that really deeply care about real-time: they
simply should not register with MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED.

In order to align the membarrier command names, the "MEMBARRIER_CMD_SHARED"
command is renamed to "MEMBARRIER_CMD_GLOBAL", keeping an alias of
MEMBARRIER_CMD_SHARED to MEMBARRIER_CMD_GLOBAL for UAPI header backward
compatibility.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
CC: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
CC: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
CC: Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
Changes since v1:
- Add missing preempt disable around smp_call_function_many().
Changes since v2:
- UAPI documentation fix based on Thomas Gleixner's feedback.
- Rename SHARED to GLOBAL.
---
 arch/powerpc/include/asm/membarrier.h |   3 +-
 include/linux/sched/mm.h              |   6 +-
 include/uapi/linux/membarrier.h       |  42 ++++++++++--
 kernel/sched/membarrier.c             | 120 +++++++++++++++++++++++++++++++---
 4 files changed, 153 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
index 98ff4f1fcf2b..6e20bb5c74ea 100644
--- a/arch/powerpc/include/asm/membarrier.h
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -13,7 +13,8 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 	 * store to rq->curr.
 	 */
 	if (likely(!(atomic_read(&next->membarrier_state) &
-		     MEMBARRIER_STATE_PRIVATE_EXPEDITED) || !prev))
+		     (MEMBARRIER_STATE_PRIVATE_EXPEDITED |
+		      MEMBARRIER_STATE_GLOBAL_EXPEDITED)) || !prev))
 		return;
 
 	/*
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 28aef7051d73..c7ad7a70cfef 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -219,8 +219,10 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 
 #ifdef CONFIG_MEMBARRIER
 enum {
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY	= (1U << 0),
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED		= (1U << 1),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY		= (1U << 0),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
+	MEMBARRIER_STATE_GLOBAL_EXPEDITED_READY			= (1U << 2),
+	MEMBARRIER_STATE_GLOBAL_EXPEDITED			= (1U << 3),
 };
 
 #ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membarrier.h
index 4e01ad7ffe98..d252506e1b5e 100644
--- a/include/uapi/linux/membarrier.h
+++ b/include/uapi/linux/membarrier.h
@@ -31,7 +31,7 @@
  * enum membarrier_cmd - membarrier system call command
  * @MEMBARRIER_CMD_QUERY:   Query the set of supported commands. It returns
  *                          a bitmask of valid commands.
- * @MEMBARRIER_CMD_SHARED:  Execute a memory barrier on all running threads.
+ * @MEMBARRIER_CMD_GLOBAL:  Execute a memory barrier on all running threads.
  *                          Upon return from system call, the caller thread
  *                          is ensured that all running threads have passed
  *                          through a state where all memory accesses to
@@ -40,6 +40,28 @@
  *                          (non-running threads are de facto in such a
  *                          state). This covers threads from all processes
  *                          running on the system. This command returns 0.
+ * @MEMBARRIER_CMD_GLOBAL_EXPEDITED:
+ *                          Execute a memory barrier on all running threads
+ *                          of all processes which previously registered
+ *                          with MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED.
+ *                          Upon return from system call, the caller thread
+ *                          is ensured that all running threads have passed
+ *                          through a state where all memory accesses to
+ *                          user-space addresses match program order between
+ *                          entry to and return from the system call
+ *                          (non-running threads are de facto in such a
+ *                          state). This only covers threads from processes
+ *                          which registered with
+ *                          MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED.
+ *                          This command returns 0. Given that
+ *                          registration is about the intent to receive
+ *                          the barriers, it is valid to invoke
+ *                          MEMBARRIER_CMD_GLOBAL_EXPEDITED from a
+ *                          non-registered process.
+ * @MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED:
+ *                          Register the process intent to receive
+ *                          MEMBARRIER_CMD_GLOBAL_EXPEDITED memory
+ *                          barriers. Always returns 0.
  * @MEMBARRIER_CMD_PRIVATE_EXPEDITED:
  *                          Execute a memory barrier on each running
  *                          thread belonging to the same process as the current
@@ -64,18 +86,24 @@
  *                          Register the process intent to use
  *                          MEMBARRIER_CMD_PRIVATE_EXPEDITED. Always
  *                          returns 0.
+ * @MEMBARRIER_CMD_SHARED:
+ *                          Alias to MEMBARRIER_CMD_GLOBAL. Provided for
+ *                          header backward compatibility.
  *
  * Command to be passed to the membarrier system call. The commands need to
  * be a single bit each, except for MEMBARRIER_CMD_QUERY which is assigned to
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
+	MEMBARRIER_CMD_GLOBAL					= (1 << 0),
+	MEMBARRIER_CMD_GLOBAL_EXPEDITED				= (1 << 1),
+	MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED		= (1 << 2),
+	MEMBARRIER_CMD_PRIVATE_EXPEDITED			= (1 << 3),
+	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED		= (1 << 4),
+
+	/* Alias for header backward compatibility. */
+	MEMBARRIER_CMD_SHARED			= MEMBARRIER_CMD_GLOBAL,
 };
 
 #endif /* _UAPI_LINUX_MEMBARRIER_H */
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 678577267a9a..d2087d5f9837 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -27,7 +27,9 @@
  * except MEMBARRIER_CMD_QUERY.
  */
 #define MEMBARRIER_CMD_BITMASK	\
-	(MEMBARRIER_CMD_SHARED | MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
+	(MEMBARRIER_CMD_GLOBAL | MEMBARRIER_CMD_GLOBAL_EXPEDITED \
+	| MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED \
+	| MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
 	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED)
 
 static void ipi_mb(void *info)
@@ -35,6 +37,73 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static int membarrier_global_expedited(void)
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
+				   MEMBARRIER_STATE_GLOBAL_EXPEDITED)) {
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
+static int membarrier_register_global_expedited(void)
+{
+	struct task_struct *p = current;
+	struct mm_struct *mm = p->mm;
+
+	if (atomic_read(&mm->membarrier_state) &
+	    MEMBARRIER_STATE_GLOBAL_EXPEDITED_READY)
+		return 0;
+	atomic_or(MEMBARRIER_STATE_GLOBAL_EXPEDITED, &mm->membarrier_state);
+	if (atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1) {
+		/*
+		 * For single mm user, single threaded process, we can
+		 * simply issue a memory barrier after setting
+		 * MEMBARRIER_STATE_GLOBAL_EXPEDITED to guarantee that
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
+	atomic_or(MEMBARRIER_STATE_GLOBAL_EXPEDITED_READY,
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
@@ -167,21 +268,24 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
 		int cmd_mask = MEMBARRIER_CMD_BITMASK;
 
 		if (tick_nohz_full_enabled())
-			cmd_mask &= ~MEMBARRIER_CMD_SHARED;
+			cmd_mask &= ~MEMBARRIER_CMD_GLOBAL;
 		return cmd_mask;
 	}
-	case MEMBARRIER_CMD_SHARED:
-		/* MEMBARRIER_CMD_SHARED is not compatible with nohz_full. */
+	case MEMBARRIER_CMD_GLOBAL:
+		/* MEMBARRIER_CMD_GLOBAL is not compatible with nohz_full. */
 		if (tick_nohz_full_enabled())
 			return -EINVAL;
 		if (num_online_cpus() > 1)
 			synchronize_sched();
 		return 0;
+	case MEMBARRIER_CMD_GLOBAL_EXPEDITED:
+		return membarrier_global_expedited();
+	case MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED:
+		return membarrier_register_global_expedited();
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
