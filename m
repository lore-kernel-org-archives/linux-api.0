From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 2/6] membarrier: powerpc: Skip memory barrier in switch_mm() (v6)
Date: Wed,  8 Nov 2017 13:35:10 -0500
Message-ID: <20171108183514.3306-3-mathieu.desnoyers@efficios.com>
References: <20171108183514.3306-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108183514.3306-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, gromer@google.com, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Alan Stern <stern@rowland.harvard.edu>, Will Deacon <will.deacon@arm.com>Alexander Viro <v>
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
MEMBARRIER_STATE_SWITCH_MM flag, issue synchronize_sched(), and only
then set MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY which allows private
expedited membarrier commands to succeed. membarrier_arch_switch_mm()
now tests for the MEMBARRIER_STATE_SWITCH_MM flag.

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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Andrew Hunter <ahh@google.com>
CC: Maged Michael <maged.michael@gmail.com>
CC: gromer@google.com
CC: Avi Kivity <avi@scylladb.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Dave Watson <davejwatson@fb.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Will Deacon <will.deacon@arm.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Nicholas Piggin <npiggin@gmail.com>
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-arch@vger.kernel.org
---
 MAINTAINERS                           |  2 ++
 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/membarrier.h | 26 +++++++++++++++++++++++++
 arch/powerpc/kernel/Makefile          |  2 ++
 arch/powerpc/kernel/membarrier.c      | 36 +++++++++++++++++++++++++++++++++++
 arch/powerpc/mm/mmu_context.c         |  7 +++++++
 include/linux/sched/mm.h              | 15 +++++++++++++++
 init/Kconfig                          |  3 +++
 kernel/sched/core.c                   | 10 ----------
 kernel/sched/membarrier.c             |  1 +
 10 files changed, 93 insertions(+), 10 deletions(-)
 create mode 100644 arch/powerpc/include/asm/membarrier.h
 create mode 100644 arch/powerpc/kernel/membarrier.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f4e462aa4a2..34687a0ec28c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8829,6 +8829,8 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	kernel/sched/membarrier.c
 F:	include/uapi/linux/membarrier.h
+F:	arch/powerpc/kernel/membarrier.c
+F:	arch/powerpc/include/asm/membarrier.h
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index cb782ac1c35d..86077c4cd0a4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_MEMBARRIER_HOOKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
new file mode 100644
index 000000000000..0951646253d9
--- /dev/null
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_POWERPC_MEMBARRIER_H
+#define _ASM_POWERPC_MEMBARRIER_H
+
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+		struct mm_struct *next, struct task_struct *tsk)
+{
+	/*
+	 * Only need the full barrier when switching between processes.
+	 * Barrier when switching from kernel to userspace is not
+	 * required here, given that it is implied by mmdrop(). Barrier
+	 * when switching from userspace to kernel is not needed after
+	 * store to rq->curr.
+	 */
+	if (likely(!(atomic_read(&next->membarrier_state)
+			& MEMBARRIER_STATE_SWITCH_MM) || !prev))
+		return;
+
+	/*
+	 * The membarrier system call requires a full memory barrier
+	 * after storing to rq->curr, before going back to user-space.
+	 */
+	smp_mb();
+}
+void membarrier_arch_register_private_expedited(struct task_struct *t);
+
+#endif /* _ASM_POWERPC_MEMBARRIER_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 6c6cce937dd8..2ad3b55fa2b6 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -136,6 +136,8 @@ endif
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
 
+obj-$(CONFIG_MEMBARRIER)	+= membarrier.o
+
 # Disable GCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
 UBSAN_SANITIZE_prom_init.o := n
diff --git a/arch/powerpc/kernel/membarrier.c b/arch/powerpc/kernel/membarrier.c
new file mode 100644
index 000000000000..4795ad59b833
--- /dev/null
+++ b/arch/powerpc/kernel/membarrier.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2010-2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * membarrier system call - PowerPC architecture code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
+#include <linux/thread_info.h>
+#include <linux/spinlock.h>
+#include <linux/rcupdate.h>
+#include <linux/atomic.h>
+
+void membarrier_arch_register_private_expedited(struct task_struct *p)
+{
+	struct mm_struct *mm = p->mm;
+
+	atomic_or(MEMBARRIER_STATE_SWITCH_MM, &mm->membarrier_state);
+	if (atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)
+		return;
+	/*
+	 * Ensure all future scheduler executions will observe the new
+	 * thread flag state for this process.
+	 */
+	synchronize_sched();
+}
diff --git a/arch/powerpc/mm/mmu_context.c b/arch/powerpc/mm/mmu_context.c
index 0f613bc63c50..22f5c91cdc38 100644
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -12,6 +12,7 @@
 
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/sched/mm.h>
 
 #include <asm/mmu_context.h>
 
@@ -67,6 +68,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		 *
 		 * On the read side the barrier is in pte_xchg(), which orders
 		 * the store to the PTE vs the load of mm_cpumask.
+		 *
+		 * This full barrier is needed by membarrier when switching
+		 * between processes after store to rq->curr, before user-space
+		 * memory accesses.
 		 */
 		smp_mb();
 
@@ -89,6 +94,8 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 
 	if (new_on_cpu)
 		radix_kvm_prefetch_workaround(next);
+	else
+		membarrier_arch_switch_mm(prev, next, tsk);
 
 	/*
 	 * The actual HW switching method differs between the various
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 3d49b91b674d..bbc3861d14c8 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -218,11 +218,26 @@ enum {
 	MEMBARRIER_STATE_SWITCH_MM			= (1U << 1),
 };
 
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+#include <asm/membarrier.h>
+#else
+static inline void membarrier_arch_register_private_expedited(
+		struct task_struct *p)
+{
+}
+#endif
+
 static inline void membarrier_execve(struct task_struct *t)
 {
 	atomic_set(&t->mm->membarrier_state, 0);
 }
 #else
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_HOOKS
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+		struct mm_struct *next, struct task_struct *tsk)
+{
+}
+#endif
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
diff --git a/init/Kconfig b/init/Kconfig
index 3c1faaa2af4a..ba7f17971554 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1400,6 +1400,9 @@ config MEMBARRIER
 
 	  If unsure, say Y.
 
+config ARCH_HAS_MEMBARRIER_HOOKS
+	bool
+
 config EMBEDDED
 	bool "Embedded system"
 	option allnoconfig_y
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d17c5da523a0..f29525e453c4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2644,16 +2644,6 @@ static struct rq *finish_task_switch(struct task_struct *prev)
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
index dd7908743dab..23bd256f8458 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -116,6 +116,7 @@ static void membarrier_register_private_expedited(void)
 	if (atomic_read(&mm->membarrier_state)
 			& MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY)
 		return;
+	membarrier_arch_register_private_expedited(p);
 	atomic_or(MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY,
 			&mm->membarrier_state);
 }
-- 
2.11.0
