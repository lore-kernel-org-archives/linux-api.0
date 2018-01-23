From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 08/11] membarrier: Provide core serializing command (v2)
Date: Tue, 23 Jan 2018 10:57:30 -0500
Message-ID: <20180123155733.3404-9-mathieu.desnoyers@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoy>
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
CC: linux-arch@vger.kernel.org
---
Changes since v1:
- Include linux/sync_core.h
---
 include/linux/sched/mm.h        | 18 ++++++++++++++
 include/uapi/linux/membarrier.h | 32 ++++++++++++++++++++++++-
 init/Kconfig                    |  3 +++
 kernel/sched/core.c             |  6 ++++-
 kernel/sched/membarrier.c       | 53 +++++++++++++++++++++++++++++++----------
 5 files changed, 98 insertions(+), 14 deletions(-)

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
index f38c4c7e256a..041893128f51 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2662,9 +2662,13 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	 * thread, mmdrop()'s implicit full barrier is required by the
 	 * membarrier system call, because the current active_mm can
 	 * become the current mm without going through switch_mm().
+	 * membarrier also requires a core serializing instruction
+	 * before going back to user-space after storing to rq->curr.
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
