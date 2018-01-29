From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for 4.16 v3 08/11] membarrier: Provide core serializing command
Date: Mon, 29 Jan 2018 15:20:17 -0500
Message-ID: <20180129202020.8515-9-mathieu.desnoyers@efficios.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180129202020.8515-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Provide core serializing membarrier command to support memory reclaim
by JIT.

Each architecture needs to explicitly opt into that support by
documenting in their architecture code how they provide the core
serializing instructions required when returning from the membarrier
IPI, and after the scheduler has updated the curr->mm pointer (before
going back to user-space). They should then select
ARCH_HAS_MEMBARRIER_SYNC_CORE to enable support for that command on
their architecture.

Architectures selecting this feature need to either document that
they issue core serializing instructions when returning to user-space,
or implement their architecture-specific sync_core_before_usermode().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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
Changes since v1:
- Include linux/sync_core.h

Changes since v2:
- Rework a comment and changelog based on Peter Zijlstra's feedback.
---
 include/linux/sched/mm.h        | 18 ++++++++++++++
 include/uapi/linux/membarrier.h | 32 ++++++++++++++++++++++++-
 init/Kconfig                    |  3 +++
 kernel/sched/core.c             | 18 ++++++++++----
 kernel/sched/membarrier.c       | 53 +++++++++++++++++++++++++++++++----------
 5 files changed, 106 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index c7ad7a70cfef..a7840f0f8832 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/gfp.h>
+#include <linux/sync_core.h>
 
 /*
  * Routines for handling mm_structs
@@ -223,12 +224,26 @@ enum {
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
 	MEMBARRIER_STATE_GLOBAL_EXPEDITED_READY			= (1U << 2),
 	MEMBARRIER_STATE_GLOBAL_EXPEDITED			= (1U << 3),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY	= (1U << 4),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE		= (1U << 5),
+};
+
+enum {
+	MEMBARRIER_FLAG_SYNC_CORE	= (1U << 0),
 };
 
 #ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
 #include <asm/membarrier.h>
 #endif
 
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+	if (likely(!(atomic_read(&mm->membarrier_state) &
+		     MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE)))
+		return;
+	sync_core_before_usermode();
+}
+
 static inline void membarrier_execve(struct task_struct *t)
 {
 	atomic_set(&t->mm->membarrier_state, 0);
@@ -244,6 +259,9 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
+static inline void membarrier_mm_sync_core_before_usermode(struct mm_struct *mm)
+{
+}
 #endif
 
 #endif /* _LINUX_SCHED_MM_H */
diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membarrier.h
index d252506e1b5e..5891d7614c8c 100644
--- a/include/uapi/linux/membarrier.h
+++ b/include/uapi/linux/membarrier.h
@@ -73,7 +73,7 @@
  *                          to and return from the system call
  *                          (non-running threads are de facto in such a
  *                          state). This only covers threads from the
- *                          same processes as the caller thread. This
+ *                          same process as the caller thread. This
  *                          command returns 0 on success. The
  *                          "expedited" commands complete faster than
  *                          the non-expedited ones, they never block,
@@ -86,6 +86,34 @@
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
  * @MEMBARRIER_CMD_SHARED:
  *                          Alias to MEMBARRIER_CMD_GLOBAL. Provided for
  *                          header backward compatibility.
@@ -101,6 +129,8 @@ enum membarrier_cmd {
 	MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED		= (1 << 2),
 	MEMBARRIER_CMD_PRIVATE_EXPEDITED			= (1 << 3),
 	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED		= (1 << 4),
+	MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE		= (1 << 5),
+	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE	= (1 << 6),
 
 	/* Alias for header backward compatibility. */
 	MEMBARRIER_CMD_SHARED			= MEMBARRIER_CMD_GLOBAL,
diff --git a/init/Kconfig b/init/Kconfig
index 30208da2221f..30b65febeb23 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1415,6 +1415,9 @@ config USERFAULTFD
 config ARCH_HAS_MEMBARRIER_HOOKS
 	bool
 
+config ARCH_HAS_MEMBARRIER_SYNC_CORE
+	bool
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f38c4c7e256a..48c3c1b83354 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2658,13 +2658,21 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 
 	fire_sched_in_preempt_notifiers(current);
 	/*
-	 * When transitioning from a kernel thread to a userspace
-	 * thread, mmdrop()'s implicit full barrier is required by the
-	 * membarrier system call, because the current active_mm can
-	 * become the current mm without going through switch_mm().
+	 * When switching through a kernel thread, the loop in
+	 * membarrier_{private,global}_expedited() may have observed that
+	 * kernel thread and not issued an IPI. It is therefore possible to
+	 * schedule between user->kernel->user threads without passing though
+	 * switch_mm(). Membarrier requires a barrier after storing to
+	 * rq->curr, before returning to userspace, so provide them here:
+	 *
+	 * - a full memory barrier for {PRIVATE,GLOBAL}_EXPEDITED, implicitly
+	 *   provided by mmdrop(),
+	 * - a sync_core for SYNC_CORE.
 	 */
-	if (mm)
+	if (mm) {
+		membarrier_mm_sync_core_before_usermode(mm);
 		mmdrop(mm);
+	}
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index d2087d5f9837..5d0762633639 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -26,11 +26,20 @@
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
 	(MEMBARRIER_CMD_GLOBAL | MEMBARRIER_CMD_GLOBAL_EXPEDITED \
 	| MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED \
 	| MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
-	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED)
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED	\
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
 
 static void ipi_mb(void *info)
 {
@@ -104,15 +113,23 @@ static int membarrier_global_expedited(void)
 	return 0;
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
+		if (!(atomic_read(&current->mm->membarrier_state) &
+		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
+			return -EPERM;
+	} else {
+		if (!(atomic_read(&current->mm->membarrier_state) &
+		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY))
+			return -EPERM;
+	}
 
 	if (num_online_cpus() == 1)
 		return 0;
@@ -205,20 +222,29 @@ static int membarrier_register_global_expedited(void)
 	return 0;
 }
 
-static int membarrier_register_private_expedited(void)
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
+	if (atomic_read(&mm->membarrier_state) & state)
 		return 0;
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED, &mm->membarrier_state);
+	if (flags & MEMBARRIER_FLAG_SYNC_CORE)
+		atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE,
+			  &mm->membarrier_state);
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
 		/*
 		 * Ensure all future scheduler executions will observe the
@@ -226,8 +252,7 @@ static int membarrier_register_private_expedited(void)
 		 */
 		synchronize_sched();
 	}
-	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
-			&mm->membarrier_state);
+	atomic_or(state, &mm->membarrier_state);
 	return 0;
 }
 
@@ -283,9 +308,13 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
 	case MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED:
 		return membarrier_register_global_expedited();
 	case MEMBARRIER_CMD_PRIVATE_EXPEDITED:
-		return membarrier_private_expedited();
+		return membarrier_private_expedited(0);
 	case MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED:
-		return membarrier_register_private_expedited();
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
