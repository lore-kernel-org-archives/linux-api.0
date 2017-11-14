From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 20/24] membarrier: Provide core serializing command
Date: Tue, 14 Nov 2017 15:04:10 -0500
Message-ID: <20171114200414.2188-21-mathieu.desnoyers@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andy Lutomirski <luto@kernel.org>, Maged Michael <maged.michael@>
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
 include/linux/sched/mm.h        |  6 +++++
 include/uapi/linux/membarrier.h | 32 +++++++++++++++++++++++++-
 init/Kconfig                    |  3 +++
 kernel/sched/membarrier.c       | 50 +++++++++++++++++++++++++++++++----------
 4 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index c7b0f5970d7c..b7abb7de250f 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -223,6 +223,12 @@ enum {
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED			= (1U << 1),
 	MEMBARRIER_STATE_SHARED_EXPEDITED_READY			= (1U << 2),
 	MEMBARRIER_STATE_SHARED_EXPEDITED			= (1U << 3),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY	= (1U << 4),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE		= (1U << 5),
+};
+
+enum {
+	MEMBARRIER_FLAG_SYNC_CORE	= (1U << 0),
 };
 
 #ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
diff --git a/include/uapi/linux/membarrier.h b/include/uapi/linux/membarrier.h
index 2de01e595d3b..99a66577bd85 100644
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
  *
  * Command to be passed to the membarrier system call. The commands need to
  * be a single bit each, except for MEMBARRIER_CMD_QUERY which is assigned to
@@ -98,6 +126,8 @@ enum membarrier_cmd {
 	MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED		= (1 << 2),
 	MEMBARRIER_CMD_PRIVATE_EXPEDITED			= (1 << 3),
 	MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED		= (1 << 4),
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
index 76534531098f..72f42eac99ab 100644
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
 	(MEMBARRIER_CMD_SHARED | MEMBARRIER_CMD_SHARED_EXPEDITED \
 	| MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED \
 	| MEMBARRIER_CMD_PRIVATE_EXPEDITED	\
-	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED)
+	| MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED	\
+	| MEMBARRIER_PRIVATE_EXPEDITED_SYNC_CORE_BITMASK)
 
 static void ipi_mb(void *info)
 {
@@ -102,15 +111,23 @@ static int membarrier_shared_expedited(void)
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
@@ -201,18 +218,24 @@ static int membarrier_register_shared_expedited(void)
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
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED,
 			&mm->membarrier_state);
@@ -223,8 +246,7 @@ static int membarrier_register_private_expedited(void)
 		 */
 		synchronize_sched();
 	}
-	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
-			&mm->membarrier_state);
+	atomic_or(state, &mm->membarrier_state);
 	return 0;
 }
 
@@ -280,9 +302,13 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
 	case MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED:
 		return membarrier_register_shared_expedited();
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
