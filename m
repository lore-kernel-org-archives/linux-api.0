From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 04/10] membarrier: Provide core serializing command
Date: Fri, 10 Nov 2017 16:37:11 -0500
Message-ID: <20171110213717.12457-5-mathieu.desnoyers@efficios.com>
References: <20171110213717.12457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110213717.12457-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/fQFizaE/u3fw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Provide core serializing membarrier command to support memory reclaim
by JIT.

Each architecture needs to explicitly opt into that support by
documenting in their architecture code how they provide the core
serializing instructions required when returning from the membarrier
IPI, and after the scheduler has updated the curr->mm pointer (before
going back to user-space). They should then define
ARCH_HAS_MEMBARRIER_SYNC_CORE to enable support for that command on
their architecture.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
CC: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
CC: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/sched/mm.h        |  9 +++++--
 include/uapi/linux/membarrier.h | 40 ++++++++++++++++++++++++++----
 init/Kconfig                    |  3 +++
 kernel/sched/membarrier.c       | 54 ++++++++++++++++++++++++++++++-----------
 4 files changed, 85 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0f9e1a96b890..49a5b37a215a 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -219,8 +219,13 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 
 #ifdef CONFIG_MEMBARRIER
 enum {
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY	= (1U << 0),
-	MEMBARRIER_STATE_PRIVATE_EXPEDITED		= (1U << 1),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY		= (1U << 0),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY	= (1U << 2),
+};
+
+enum {
+	MEMBARRIER_FLAG_SYNC_CORE	= (1U << 0),
 };
 
 #ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membarrier.h
index 4e01ad7ffe98..dbb5016e93e8 100644
--- a/include/uapi/linux/membarrier.h
+++ b/include/uapi/linux/membarrier.h
@@ -51,7 +51,7 @@
  *                          to and return from the system call
  *                          (non-running threads are de facto in such a
  *                          state). This only covers threads from the
- *                          same processes as the caller thread. This
+ *                          same process as the caller thread. This
  *                          command returns 0 on success. The
  *                          "expedited" commands complete faster than
  *                          the non-expedited ones, they never block,
@@ -64,18 +64,48 @@
  *                          Register the process intent to use
  *                          MEMBARRIER_CMD_PRIVATE_EXPEDITED. Always
  *                          returns 0.
+ * @MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE:
+ *                          In addition to provide memory ordering
+ *                          guarantees described in
+ *                          MEMBARRIER_CMD_PRIVATE_EXPEDITED, ensure
+ *                          the caller thread, upon return from system
+ *                          call, that all its running threads siblings
+ *                          have executed a core serializing
+ *                          instruction. (architectures are required to
+ *                          guarantee that non-running threads issue
+ *                          core serializing instructions before they
+ *                          resume user-space execution). This only
+ *                          covers threads from the same process as the
+ *                          caller thread. This command returns 0 on
+ *                          success. The "expedited" commands complete
+ *                          faster than the non-expedited ones, they
+ *                          never block, but have the downside of
+ *                          causing extra overhead. If this command is
+ *                          not implemented by an architecture, -EINVAL
+ *                          is returned. A process needs to register its
+ *                          intent to use the private expedited sync
+ *                          core command prior to using it, otherwise
+ *                          this command returns -EPERM.
+ * @MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE:
+ *                          Register the process intent to use
+ *                          MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE.
+ *                          If this command is not implemented by an
+ *                          architecture, -EINVAL is returned.
+ *                          Returns 0 on success.
  *
  * Command to be passed to the membarrier system call. The commands need to
  * be a single bit each, except for MEMBARRIER_CMD_QUERY which is assigned to
  * the value 0.
  */
 enum membarrier_cmd {
-	MEMBARRIER_CMD_QUERY				= 0,
-	MEMBARRIER_CMD_SHARED				= (1 << 0),
+	MEMBARRIER_CMD_QUERY					= 0,
+	MEMBARRIER_CMD_SHARED					= (1 << 0),
 	/* reserved for MEMBARRIER_CMD_SHARED_EXPEDITED (1 << 1) */
 	/* reserved for MEMBARRIER_CMD_PRIVATE (1 << 2) */
-	MEMBARRIER_CMD_PRIVATE_EXPEDITED		= (1 << 3),
-	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED	= (1 << 4),
+	MEMBARRIER_CMD_PRIVATE_EXPEDITED			= (1 << 3),
+	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED		= (1 << 4),
+	MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE		= (1 << 5),
+	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE	= (1 << 6),
 };
 
 #endif /* _UAPI_LINUX_MEMBARRIER_H */
diff --git a/init/Kconfig b/init/Kconfig
index 609296e764d6..d3e5440051b8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1403,6 +1403,9 @@ config MEMBARRIER
 config ARCH_HAS_MEMBARRIER_HOOKS
 	bool
 
+config ARCH_HAS_MEMBARRIER_SYNC_CORE
+	bool
+
 config RSEQ
 	bool "Enable rseq() system call" if EXPERT
 	default y
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index b045974346d0..82efa7c64902 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -26,24 +26,41 @@
  * Bitmask made from a "or" of all commands within enum membarrier_cmd,
  * except MEMBARRIER_CMD_QUERY.
  */
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
+#define MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK	\
+	(MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE \
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE)
+#else
+#define MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK	0
+#endif
+
 #define MEMBARRIER_CMD_BITMASK	\
 	(MEMBARRIER_CMD_SHARED | MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
-	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED)
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED	\
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
 
 static void ipi_mb(void *info)
 {
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
-static int membarrier_private_expedited(void)
+static int membarrier_private_expedited(int flags)
 {
 	int cpu;
 	bool fallback = false;
 	cpumask_var_t tmpmask;
 
-	if (!(atomic_read(&current->mm->membarrier_state)
-			& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY))
-		return -EPERM;
+	if (flags & MEMBARRIER_FLAG_SYNC_CORE) {
+		if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
+			return -EINVAL;
+		if (!(atomic_read(&current->mm->membarrier_state)
+				& MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
+			return -EPERM;
+	} else {
+		if (!(atomic_read(&current->mm->membarrier_state)
+				& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY))
+			return -EPERM;
+	}
 
 	if (num_online_cpus() == 1)
 		return 0;
@@ -103,19 +120,25 @@ static int membarrier_private_expedited(void)
 	return 0;
 }
 
-static void membarrier_register_private_expedited(void)
+static int membarrier_register_private_expedited(int flags)
 {
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
+	int state = MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY;
+
+	if (flags & MEMBARRIER_FLAG_SYNC_CORE) {
+		if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
+			return -EINVAL;
+		state = MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY;
+	}
 
 	/*
 	 * We need to consider threads belonging to different thread
 	 * groups, which use the same mm. (CLONE_VM but not
 	 * CLONE_THREAD).
 	 */
-	if (atomic_read(&mm->membarrier_state)
-			& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY)
-		return;
+	if (atomic_read(&mm->membarrier_state) & state)
+		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED,
 			&mm->membarrier_state);
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
@@ -125,8 +148,8 @@ static void membarrier_register_private_expedited(void)
 		 */
 		synchronize_sched();
 	}
-	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
-			&mm->membarrier_state);
+	atomic_or(state, &mm->membarrier_state);
+	return 0;
 }
 
 /**
@@ -177,10 +200,13 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
 			synchronize_sched();
 		return 0;
 	case MEMBARRIER_CMD_PRIVATE_EXPEDITED:
-		return membarrier_private_expedited();
+		return membarrier_private_expedited(0);
 	case MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED:
-		membarrier_register_private_expedited();
-		return 0;
+		return membarrier_register_private_expedited(0);
+	case MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE:
+		return membarrier_private_expedited(MEMBARRIER_FLAG_SYNC_CORE);
+	case MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE:
+		return membarrier_register_private_expedited(MEMBARRIER_FLAG_SYNC_CORE);
 	default:
 		return -EINVAL;
 	}
-- 
2.11.0
