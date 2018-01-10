From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for 4.16 07/11] membarrier: Provide core serializing command
Date: Wed, 10 Jan 2018 10:46:21 -0500
Message-ID: <20180110154625.4319-8-mathieu.desnoyers@efficios.com>
References: <20180110154625.4319-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110154625.4319-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86@kernel.
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
 include/linux/sched/mm.h        |  6 +++++
 include/uapi/linux/membarrier.h | 32 +++++++++++++++++++++++++-
 init/Kconfig                    |  3 +++
 kernel/sched/membarrier.c       | 50 +++++++++++++++++++++++++++++++----------
 4 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index cbeecd287589..3ff217a071ca 100644
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
index e963c49e28fa..a6918da8d1ad 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1407,6 +1407,9 @@ config USERFAULTFD
 config ARCH_HAS_MEMBARRIER_HOOKS
 	bool
 
+config ARCH_HAS_MEMBARRIER_SYNC_CORE
+	bool
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 14bc8bf9e736..fcd2306c2367 100644
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
@@ -104,15 +113,23 @@ static int membarrier_shared_expedited(void)
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
@@ -205,18 +222,24 @@ static int membarrier_register_shared_expedited(void)
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
 	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
@@ -226,8 +249,7 @@ static int membarrier_register_private_expedited(void)
 		 */
 		synchronize_sched();
 	}
-	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
-			&mm->membarrier_state);
+	atomic_or(state, &mm->membarrier_state);
 	return 0;
 }
 
@@ -283,9 +305,13 @@ SYSCALL_DEFINE2(membarrier, int, cmd, int, flags)
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
