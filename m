From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH for 4.15 5/6] membarrier: x86: Provide core serializing command
Date: Wed,  8 Nov 2017 13:35:13 -0500
Message-ID: <20171108183514.3306-6-mathieu.desnoyers@efficios.com>
References: <20171108183514.3306-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108183514.3306-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, gromer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There are two places where core serialization is needed by membarrier:

1) When returning from the membarrier IPI,
2) After scheduler updates curr to a thread with a different mm, before
   going back to user-space, since the curr->mm is used by membarrier to
   check whether it needs to send an IPI to that CPU.

x86-32 uses only iret both as return from interrupt, and to go back to
user-space. The iret instruction is core serializing.

x86-64 uses iret as return from interrupt, which takes care of the IPI.
However, it can return to user-space through either sysretl (compat
code), sysretq, or iret. Given that sysret{l,q} is not core serializing,
we rely instead on write_cr3() performed by switch_mm() to provide core
serialization after changing the current mm, and deal with the special
case of kthread -> uthread (temporarily keeping current mm into
active_mm) by adding a sync_core() in that specific case.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: gromer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
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
 MAINTAINERS                           |  2 ++
 arch/powerpc/include/asm/membarrier.h |  8 ++++++-
 arch/powerpc/kernel/membarrier.c      |  3 ++-
 arch/x86/Kconfig                      |  2 ++
 arch/x86/entry/entry_32.S             |  5 +++++
 arch/x86/entry/entry_64.S             |  8 +++++++
 arch/x86/include/asm/membarrier.h     | 36 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile              |  1 +
 arch/x86/kernel/membarrier.c          | 39 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/tlb.c                     |  7 ++++---
 include/linux/sched/mm.h              |  9 +++++++-
 kernel/sched/core.c                   |  6 +++++-
 12 files changed, 119 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/membarrier.h
 create mode 100644 arch/x86/kernel/membarrier.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 34687a0ec28c..ff564e5195fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8831,6 +8831,8 @@ F:	kernel/sched/membarrier.c
 F:	include/uapi/linux/membarrier.h
 F:	arch/powerpc/kernel/membarrier.c
 F:	arch/powerpc/include/asm/membarrier.h
+F:	arch/x86/kernel/membarrier.c
+F:	arch/x86/include/asm/membarrier.h
 
 MEMORY MANAGEMENT
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
index 0951646253d9..018cf278dc93 100644
--- a/arch/powerpc/include/asm/membarrier.h
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -21,6 +21,12 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 	 */
 	smp_mb();
 }
-void membarrier_arch_register_private_expedited(struct task_struct *t);
+
+static inline void membarrier_arch_mm_sync_core(void)
+{
+}
+
+void membarrier_arch_register_private_expedited(struct task_struct *t,
+		int flags);
 
 #endif /* _ASM_POWERPC_MEMBARRIER_H */
diff --git a/arch/powerpc/kernel/membarrier.c b/arch/powerpc/kernel/membarrier.c
index 4795ad59b833..0026d740e5a3 100644
--- a/arch/powerpc/kernel/membarrier.c
+++ b/arch/powerpc/kernel/membarrier.c
@@ -21,7 +21,8 @@
 #include <linux/rcupdate.h>
 #include <linux/atomic.h>
 
-void membarrier_arch_register_private_expedited(struct task_struct *p)
+void membarrier_arch_register_private_expedited(struct task_struct *p,
+		int flags)
 {
 	struct mm_struct *mm = p->mm;
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2fdb23313dd5..6ac32fe768a8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,8 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
+	select ARCH_HAS_MEMBARRIER_HOOKS
+	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_PMEM_API		if X86_64
 	# Causing hangs/crashes, see the commit that added this change for details.
 	select ARCH_HAS_REFCOUNT		if BROKEN
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 4838037f97f6..04e5daba8456 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -553,6 +553,11 @@ restore_all:
 .Lrestore_nocheck:
 	RESTORE_REGS 4				# skip orig_eax/error_code
 .Lirq_return:
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler and when returning from
+	 * scheduler to user-space.
+	 */
 	INTERRUPT_RETURN
 
 .section .fixup, "ax"
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index bcfc5668dcb2..4859f04e1695 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -642,6 +642,10 @@ GLOBAL(restore_regs_and_iret)
 restore_c_regs_and_iret:
 	RESTORE_C_REGS
 	REMOVE_PT_GPREGS_FROM_STACK 8
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler.
+	 */
 	INTERRUPT_RETURN
 
 ENTRY(native_iret)
@@ -1122,6 +1126,10 @@ paranoid_exit_restore:
 	RESTORE_EXTRA_REGS
 	RESTORE_C_REGS
 	REMOVE_PT_GPREGS_FROM_STACK 8
+	/*
+	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on iret core serialization
+	 * when returning from IPI handler.
+	 */
 	INTERRUPT_RETURN
 END(paranoid_exit)
 
diff --git a/arch/x86/include/asm/membarrier.h b/arch/x86/include/asm/membarrier.h
new file mode 100644
index 000000000000..d22aac77047c
--- /dev/null
+++ b/arch/x86/include/asm/membarrier.h
@@ -0,0 +1,36 @@
+#ifndef _ASM_X86_MEMBARRIER_H
+#define _ASM_X86_MEMBARRIER_H
+
+#include <asm/processor.h>
+
+static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
+		struct mm_struct *next, struct task_struct *tsk)
+{
+}
+
+#ifdef CONFIG_X86_32
+static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
+{
+}
+static inline
+void membarrier_arch_register_private_expedited(struct task_struct *t,
+		int flags);
+#else
+/*
+ * x86-64 implements return to user-space through sysret, which is not a
+ * core-serializing instruction. Therefore, we need an explicit core
+ * serializing instruction after going from kernel thread back to
+ * user-space thread (active_mm moved back to current mm).
+ */
+static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
+{
+	if (likely(!(atomic_read(&mm->membarrier_state) &
+			MEMBARRIER_STATE_SYNC_CORE)))
+		return;
+	sync_core();
+}
+void membarrier_arch_register_private_expedited(struct task_struct *t,
+		int flags);
+#endif
+
+#endif /* _ASM_X86_MEMBARRIER_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5f70044340ff..13d6738b26c5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 obj-$(CONFIG_X86_PMEM_LEGACY_DEVICE) += pmem.o
+obj-$(CONFIG_X86_64)		+= membarrier.o
 
 obj-$(CONFIG_EISA)		+= eisa.o
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/membarrier.c b/arch/x86/kernel/membarrier.c
new file mode 100644
index 000000000000..978698d7da3d
--- /dev/null
+++ b/arch/x86/kernel/membarrier.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2010-2017 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+ *
+ * membarrier system call - x86 architecture code
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
+void membarrier_arch_register_private_expedited(struct task_struct *p,
+		int flags)
+{
+	struct mm_struct *mm = p->mm;
+
+	if (!(flags & MEMBARRIER_FLAG_SYNC_CORE))
+		return;
+	atomic_or(MEMBARRIER_STATE_SYNC_CORE, &mm->membarrier_state);
+	if (atomic_read(&mm->mm_users) == 1 && get_nr_threads(p) == 1)
+		return;
+	/*
+	 * Ensure all future scheduler executions will observe the new
+	 * thread flag state for this process.
+	 */
+	synchronize_sched();
+}
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5abf9bfcca1f..3b13d6735fa5 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -147,9 +147,10 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 	this_cpu_write(cpu_tlbstate.is_lazy, false);
 
 	/*
-	 * The membarrier system call requires a full memory barrier
-	 * before returning to user-space, after storing to rq->curr.
-	 * Writing to CR3 provides that full memory barrier.
+	 * The membarrier system call requires a full memory barrier and
+	 * core serialization before returning to user-space, after
+	 * storing to rq->curr. Writing to CR3 provides that full
+	 * memory barrier and core serializing instruction.
 	 */
 	if (real_prev == next) {
 		VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[prev_asid].ctx_id) !=
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index a888da398517..5561b92b597a 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -222,6 +222,7 @@ enum {
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY		= (1U << 0),
 	MEMBARRIER_STATE_SWITCH_MM				= (1U << 1),
 	MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY	= (1U << 2),
+	MEMBARRIER_STATE_SYNC_CORE				= (1U << 3),
 };
 
 enum {
@@ -232,7 +233,10 @@ enum {
 #include <asm/membarrier.h>
 #else
 static inline void membarrier_arch_register_private_expedited(
-		struct task_struct *p)
+		struct task_struct *p, int flags)
+{
+}
+static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
 {
 }
 #endif
@@ -251,6 +255,9 @@ static inline void membarrier_arch_switch_mm(struct mm_struct *prev,
 static inline void membarrier_execve(struct task_struct *t)
 {
 }
+static inline void membarrier_arch_mm_sync_core(struct mm_struct *mm)
+{
+}
 #endif
 
 #endif /* _LINUX_SCHED_MM_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8a176892b4f0..b5194cfc2199 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2653,9 +2653,13 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	 * thread, mmdrop()'s implicit full barrier is required by the
 	 * membarrier system call, because the current active_mm can
 	 * become the current mm without going through switch_mm().
+	 * membarrier also requires a core serializing instruction
+	 * before going back to user-space after storing to rq->curr.
 	 */
-	if (mm)
+	if (mm) {
 		mmdrop(mm);
+		membarrier_arch_mm_sync_core(mm);
+	}
 	if (unlikely(prev_state == TASK_DEAD)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
-- 
2.11.0
