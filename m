From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/11] powerpc: membarrier: Skip memory barrier in switch_mm() (v7)
Date: Tue, 23 Jan 2018 10:57:24 -0500
Message-ID: <20180123155733.3404-3-mathieu.desnoyers@efficios.com>
References: <20180123155733.3404-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123155733.3404-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Sehr <sehr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoy>
List-Id: linux-api@vger.kernel.org

Allow PowerPC to skip the full memory barrier in switch_mm(), and
only issue the barrier when scheduling into a task belonging to a
process that has registered to use expedited private.

Threads targeting the same VM but which belong to different thread
groups is a tricky case. It has a few consequences:

It turns out that we cannot rely on get_nr_threads(p) to count the
number of threads using a VM. We can use
(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)
instead to skip the synchronize_sched() for cases where the VM only has
a single user, and that user only has a single thread.

It also turns out that we cannot use for_each_thread() to set
thread flags in all threads using a VM, as it only iterates on the
thread group.

Therefore, test the membarrier state variable directly rather than
relying on thread flags. This means
membarrier_register_private_expedited() needs to set the
MEMBARRIER_STATE_PRIVATE_EXPEDITED flag, issue synchronize_sched(), and
only then set MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY which allows
private expedited membarrier commands to succeed.
membarrier_arch_switch_mm() now tests for the
MEMBARRIER_STATE_PRIVATE_EXPEDITED flag.

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
CC: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
CC: Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Changes since v1:
- Use test_ti_thread_flag(next, ...) instead of test_thread_flag() in
  powerpc membarrier_arch_sched_in(), given that we want to specifically
  check the next thread state.
- Add missing ARCH_HAS_MEMBARRIER_HOOKS in Kconfig.
- Use task_thread_info() to pass thread_info from task to
  *_ti_thread_flag().

Changes since v2:
- Move membarrier_arch_sched_in() call to finish_task_switch().
- Check for NULL t->mm in membarrier_arch_fork().
- Use membarrier_sched_in() in generic code, which invokes the
  arch-specific membarrier_arch_sched_in(). This fixes allnoconfig
  build on PowerPC.
- Move asm/membarrier.h include under CONFIG_MEMBARRIER, fixing
  allnoconfig build on PowerPC.
- Build and runtime tested on PowerPC.

Changes since v3:
- Simply rely on copy_mm() to copy the membarrier_private_expedited mm
  field on fork.
- powerpc: test thread flag instead of reading
  membarrier_private_expedited in membarrier_arch_fork().
- powerpc: skip memory barrier in membarrier_arch_sched_in() if coming
  from kernel thread, since mmdrop() implies a full barrier.
- Set membarrier_private_expedited to 1 only after arch registration
  code, thus eliminating a race where concurrent commands could succeed
  when they should fail if issued concurrently with process
  registration.
- Use READ_ONCE() for membarrier_private_expedited field access in
  membarrier_private_expedited. Matches WRITE_ONCE() performed in
  process registration.

Changes since v4:
- Move powerpc hook from sched_in() to switch_mm(), based on feedback
  from Nicholas Piggin.

Changes since v5:
- Rebase on v4.14-rc6.
- Fold "Fix: membarrier: Handle CLONE_VM + !CLONE_THREAD correctly on
  powerpc (v2)"

Changes since v6:
- Rename MEMBARRIER_STATE_SWITCH_MM to MEMBARRIER_STATE_PRIVATE_EXPEDITED.
---
 MAINTAINERS                           |  1 +
 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/membarrier.h | 26 ++++++++++++++++++++++++++
 arch/powerpc/mm/mmu_context.c         |  7 +++++++
 include/linux/sched/mm.h              | 13 ++++++++++++-
 init/Kconfig                          |  3 +++
 kernel/sched/core.c                   | 10 ----------
 kernel/sched/membarrier.c             |  8 ++++++++
 8 files changed, 58 insertions(+), 11 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e3581413420c..11ff47c28b12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8931,6 +8931,7 @@ L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Supported
 F:	kernel/sched/membarrier.c
 F:	include/uapi/linux/membarrier.h
+F:	arch/powerpc/include/asm/membarrier.h
 
 MEMORY MANAGEMENT
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2ed525a44734..09b02180b8a0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PMEM_API                if PPC64
+	select ARCH_HAS_MEMBARRIER_HOOKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
new file mode 100644
index 000000000000..98ff4f1fcf2b
--- /dev/null
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_POWERPC_MEMBARRIER_H
+#define _ASM_POWERPC_MEMBARRIER_H
+
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+					     struct mm_struct *next,
+					     struct task_struct *tsk)
+{
+	/*
+	 * Only need the full barrier when switching between processes.
+	 * Barrier when switching from kernel to userspace is not
+	 * required here, given that it is implied by mmdrop(). Barrier
+	 * when switching from userspace to kernel is not needed after
+	 * store to rq->curr.
+	 */
+	if (likely(!(atomic_read(&next->membarrier_state) &
+		     MEMBARRIER_STATE_PRIVATE_EXPEDITED) || !prev))
+		return;
+
+	/*
+	 * The membarrier system call requires a full memory barrier
+	 * after storing to rq->curr, before going back to user-space.
+	 */
+	smp_mb();
+}
+
+#endif /* _ASM_POWERPC_MEMBARRIER_H */
diff --git a/arch/powerpc/mm/mmu_context.c b/arch/powerpc/mm/mmu_context.c
index d60a62bf4fc7..0ab297c4cfad 100644
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -12,6 +12,7 @@
 
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/sched/mm.h>
 
 #include <asm/mmu_context.h>
 
@@ -58,6 +59,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		 *
 		 * On the read side the barrier is in pte_xchg(), which orders
 		 * the store to the PTE vs the load of mm_cpumask.
+		 *
+		 * This full barrier is needed by membarrier when switching
+		 * between processes after store to rq->curr, before user-space
+		 * memory accesses.
 		 */
 		smp_mb();
 
@@ -80,6 +85,8 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 
 	if (new_on_cpu)
 		radix_kvm_prefetch_workaround(next);
+	else
+		membarrier_arch_switch_mm(prev, next, tsk);
 
 	/*
 	 * The actual HW switching method differs between the various
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 3d49b91b674d..1754396795f6 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -215,14 +215,25 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
 #ifdef CONFIG_MEMBARRIER
 enum {
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY	= (1U << 0),
-	MEMBARRIER_STATE_SWITCH_MM			= (1U << 1),
+	MEMBARRIER_STATE_PRIVATE_EXPEDITED		= (1U << 1),
 };
 
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+#include <asm/membarrier.h>
+#endif
+
 static inline void membarrier_execve(struct task_struct *t)
 {
 	atomic_set(&t->mm->membarrier_state, 0);
 }
 #else
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+					     struct mm_struct *next,
+					     struct task_struct *tsk)
+{
+}
+#endif
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
diff --git a/init/Kconfig b/init/Kconfig
index a9a2e2c86671..2d118b6adee2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1412,6 +1412,9 @@ config USERFAULTFD
 	  Enable the userfaultfd() system call that allows to intercept and
 	  handle page faults in userland.
 
+config ARCH_HAS_MEMBARRIER_HOOKS
+	bool
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a7bf32aabfda..c7e06dfa804b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2653,16 +2653,6 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	prev_state = prev->state;
 	vtime_task_switch(prev);
 	perf_event_task_sched_in(prev, current);
-	/*
-	 * The membarrier system call requires a full memory barrier
-	 * after storing to rq->curr, before going back to user-space.
-	 *
-	 * TODO: This smp_mb__after_unlock_lock can go away if PPC end
-	 * up adding a full barrier to switch_mm(), or we should figure
-	 * out if a smp_mb__after_unlock_lock is really the proper API
-	 * to use.
-	 */
-	smp_mb__after_unlock_lock();
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 9bcbacba82a8..678577267a9a 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -118,6 +118,14 @@ static void membarrier_register_private_expedited(void)
 	if (atomic_read(&mm->membarrier_state)
 			& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY)
 		return;
+	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED, &mm->membarrier_state);
+	if (!(atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)) {
+		/*
+		 * Ensure all future scheduler executions will observe the
+		 * new thread flag state for this process.
+		 */
+		synchronize_sched();
+	}
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
 			&mm->membarrier_state);
 }
-- 
2.11.0
