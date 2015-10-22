From: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Subject: [RFC PATCH 1/3] restartable sequences: user-space per-cpu critical
 sections
Date: Thu, 22 Oct 2015 11:06:40 -0700
Message-ID: <581c0b6403285219724961a3d250c6d95dfacea7.1445464158.git.davejwatson@fb.com>
References: <cover.1445464158.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1445464158.git.davejwatson-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davejwatson-b10kYP2dOMg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Introduce the notion of 'restartable sequence'.  This is a user-defined range
within which we guarantee user-execution will occur serially with respect
to scheduling events such as migration or competition with other threads.

Preemption, or other interruption within this region, results in control being
transferred to a user-defined restart handler when rescheduled.  This handler
may arrange for the original operation to be retried, including potentially
resynchronizing with dependent state that may have been updated in the interim.

This may be used in combination with an in-memory cpu-id to allow user programs
to implement cpu-local data-structures and primitives, without the use/overhead
of any atomics.

The kernel ABI generally consists of:
- A critical region, with start, end and restart addresses
- A (per-thread) memory location which will be kept current with its cpu

The definition of the above is performed via a new syscall,
  SYSCALL_DEFINE5(restartable_sequences,
                  int, op, int, flags, long, val1, long, val2, long, val3)

There are currently 2 possible operations,
  1) Configure the critical region(s)
  2) Configure the per-thread cpu pointer

[ See kernel/restartable_sequences.c for full documentation ]

A thread that has not configured (2) will not be restarted when executing in
(1).

This patch introduces the general framework for configuration, as well as
exposing the syscall.  We minimally expose x86 as having support (even though
the actual ABI is added by a subsequent patch) so that this can be compile
tested in isolation.

Ptrace is modified to avoid setting a breakpoint in the critical region,
since doing so would always restart the critical section, and may
not work correctly if the breakpoint is also the restart address.
---
 arch/Kconfig                      |   7 ++
 arch/x86/Kconfig                  |   1 +
 fs/exec.c                         |   3 +-
 include/linux/sched.h             |  39 ++++++
 include/uapi/asm-generic/unistd.h |   4 +-
 init/Kconfig                      |   9 ++
 kernel/Makefile                   |   2 +-
 kernel/fork.c                     |   1 +
 kernel/ptrace.c                   |  15 ++-
 kernel/restartable_sequences.c    | 250 ++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c               |   5 +
 kernel/sched/sched.h              |   3 +
 kernel/sys_ni.c                   |   3 +
 13 files changed, 335 insertions(+), 7 deletions(-)
 create mode 100644 kernel/restartable_sequences.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 4e949e5..93c18fa 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -241,6 +241,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
 	  declared in asm/ptrace.h
 	  For example the kprobes-based event tracer needs this API.
 
+config HAVE_RESTARTABLE_SEQUENCE_SUPPORT
+	bool
+	depends on HAVE_REGS_AND_STACK_ACCESS_API
+	help
+	  This symbol should be selected by an architecture if it supports an
+	  implementation of restartable sequences.
+
 config HAVE_CLK
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 96d058a..865e795 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,6 +112,7 @@ config X86
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK	if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_RESTARTABLE_SEQUENCE_SUPPORT
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
diff --git a/fs/exec.c b/fs/exec.c
index b06623a..aa94834 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -19,7 +19,7 @@
  * current->executable is only used by the procfs.  This allows a dispatch
  * table to check for several different types  of binary formats.  We keep
  * trying until we recognize the file or we run out of supported binary
- * formats. 
+ * formats.
  */
 
 #include <linux/slab.h>
@@ -1596,6 +1596,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	current->in_execve = 0;
 	acct_update_integrals(current);
 	task_numa_free(current);
+	rseq_clear_state_exec(current);
 	free_bprm(bprm);
 	kfree(pathbuf);
 	putname(filename);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b7b9501..a7b6e24 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1182,6 +1182,31 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+struct restartable_sequence_section {
+	/* Start and end of an address space's critical section. */
+	struct rb_node node;
+	void __user *crit_start, __user *crit_end, __user *crit_restart;
+};
+struct restartable_sequence_state {
+	struct rb_root sections;
+	/* Thread's current CPU, typically in TLS. */
+	int __user *cpu_pointer;
+	struct preempt_notifier notifier;
+};
+
+void rseq_clear_state_exec(struct task_struct *p);
+unsigned long rseq_lookup(struct task_struct *p, unsigned long ip);
+#else
+static inline void rseq_clear_state_exec(struct task_struct *p) {}
+static inline void rseq_fork(struct task_struct *p) {}
+static inline unsigned long
+rseq_lookup(struct task_struct *p, unsigned long ip)
+{
+	return 0;
+}
+#endif
+
 struct load_weight {
 	unsigned long weight;
 	u32 inv_weight;
@@ -1811,6 +1836,11 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+	struct restartable_sequence_state rseq_state;
+#endif
+
 	int pagefault_disabled;
 /* CPU-specific state of this task */
 	struct thread_struct thread;
@@ -3180,4 +3210,13 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+static inline int rseq_active(struct task_struct *p)
+{
+	return p->rseq_state.cpu_pointer != NULL;
+}
+#else
+static inline int rseq_active(struct task_struct *p) { return 0; }
+#endif
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index ee12400..9659f31 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -713,9 +713,11 @@ __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
 #define __NR_membarrier 283
 __SYSCALL(__NR_membarrier, sys_membarrier)
+#define __NR_restartable_sequences 284
+__SYSCALL(__NR_restartable_sequences, sys_restartable_sequences)
 
 #undef __NR_syscalls
-#define __NR_syscalls 284
+#define __NR_syscalls 285
 
 /*
  * All syscalls below here should go away really,
diff --git a/init/Kconfig b/init/Kconfig
index c24b6f7..9b4a180 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2042,6 +2042,15 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+config RESTARTABLE_SEQUENCES
+	bool "Userspace Restartable Sequences (RSEQ)"
+	default n
+	depends on HAVE_RESTARTABLE_SEQUENCE_SUPPORT && PREEMPT_NOTIFIERS
+	help
+	  Allows binaries to define a region of user-text within which
+	  execution will be restarted in the event of signal delivery or
+	  preemption.
+
 config PADATA
 	depends on SMP
 	bool
diff --git a/kernel/Makefile b/kernel/Makefile
index 53abf00..dbe6963 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -101,8 +101,8 @@ obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
 obj-$(CONFIG_MEMBARRIER) += membarrier.o
-
 obj-$(CONFIG_HAS_IOMEM) += memremap.o
+obj-$(CONFIG_RESTARTABLE_SEQUENCES) += restartable_sequences.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2845623..aa3ba1e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -252,6 +252,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(tsk == current);
 
 	task_numa_free(tsk);
+	rseq_clear_state_exec(tsk);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 787320d..63935bc 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -825,7 +825,10 @@ int ptrace_request(struct task_struct *child, long request,
 		return generic_ptrace_peekdata(child, addr, data);
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		return generic_ptrace_pokedata(child, addr, data);
+		/* Don't breakpoint restartable sequences */
+		if (!rseq_lookup(child, addr))
+			return generic_ptrace_pokedata(child, addr, data);
+		break;
 
 #ifdef PTRACE_OLDSETOPTIONS
 	case PTRACE_OLDSETOPTIONS:
@@ -1116,7 +1119,7 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 	compat_ulong_t __user *datap = compat_ptr(data);
 	compat_ulong_t word;
 	siginfo_t siginfo;
-	int ret;
+	int ret = -EIO;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -1130,8 +1133,12 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 
 	case PTRACE_POKETEXT:
 	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		ret = (ret != sizeof(data) ? -EIO : 0);
+		/* Don't breakpoint restartable sequences */
+		if (!rseq_lookup(child, addr)) {
+			ret = access_process_vm(
+				child, addr, &data, sizeof(data), 1);
+			ret = (ret != sizeof(data) ? -EIO : 0);
+		}
 		break;
 
 	case PTRACE_GETEVENTMSG:
diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
new file mode 100644
index 0000000..72cfa9b
--- /dev/null
+++ b/kernel/restartable_sequences.c
@@ -0,0 +1,250 @@
+/*
+ * Restartable Sequences are a lightweight interface that allows user-level
+ * code to be executed atomically relative to scheduler preemption.  Typically
+ * used for implementing per-cpu operations.
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
+ *
+ * Copyright (C) 2015, Google, Inc.,
+ * Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> and Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ *
+ */
+
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+
+#include <linux/uaccess.h>
+#include <linux/preempt.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+
+static void rseq_sched_in_nop(struct preempt_notifier *pn, int cpu) {}
+static void rseq_sched_out_nop(struct preempt_notifier *pn,
+			       struct task_struct *next) {}
+
+static __read_mostly struct preempt_ops rseq_preempt_ops = {
+	.sched_in = rseq_sched_in_nop,
+	.sched_out = rseq_sched_out_nop,
+};
+
+unsigned long rseq_lookup(struct task_struct *p, unsigned long ip)
+{
+	struct task_struct *leader = p->group_leader;
+	struct restartable_sequence_state *rseq_state = &leader->rseq_state;
+	struct restartable_sequence_section *item;
+
+	struct rb_node *node = rseq_state->sections.rb_node;
+
+	while (node) {
+		item = container_of(
+			node, struct restartable_sequence_section, node);
+		if (ip < (unsigned long)item->crit_start)
+			node = node->rb_left;
+		else if (ip >= (unsigned long)item->crit_end)
+			node = node->rb_right;
+		else
+			return (unsigned long)item->crit_restart;
+	}
+
+	return 0;
+}
+
+int rseq_register_cpu_pointer(struct task_struct *p, int __user *cpu_pointer)
+{
+	struct restartable_sequence_state *rseq_state =
+		&p->rseq_state;
+	int registered = 0, rc = 0;
+
+	if (cpu_pointer == rseq_state->cpu_pointer)
+		return 0;
+
+	if (cpu_pointer && !access_ok(VERIFY_WRITE, cpu_pointer, sizeof(int)))
+		return -EINVAL;
+
+	rcu_read_lock();
+	/* Group leader always holds critical section definition. */
+	if (cpu_pointer && !current->group_leader->rseq_state.cpu_pointer &&
+		current->group_leader != p) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+	smp_rmb();  /* Pairs with setting group_leaders cpu_pointer */
+
+	if (rseq_state->cpu_pointer)
+		registered = 1;
+	rseq_state->cpu_pointer = cpu_pointer;
+
+	if (cpu_pointer && !registered) {
+		preempt_notifier_inc();
+
+		preempt_notifier_init(&rseq_state->notifier,
+				      &rseq_preempt_ops);
+		preempt_notifier_register(&rseq_state->notifier);
+	} else if (!cpu_pointer && registered) {
+		preempt_notifier_unregister(&rseq_state->notifier);
+
+		preempt_notifier_dec();
+	}
+
+	/* Will update *cpu_pointer on return. */
+	if (cpu_pointer)
+		set_thread_flag(TIF_NOTIFY_RESUME);
+
+out_unlock:
+	rcu_read_unlock();
+
+	return 0;
+}
+
+void rseq_clear_state_exec(struct task_struct *task)
+{
+	struct restartable_sequence_section *section;
+	struct rb_node *node;
+
+	/* Ensure notifier is disabled. */
+	rseq_register_cpu_pointer(task, NULL);
+
+	/* Free and reinit */
+	while ((node = rb_first(&task->rseq_state.sections))) {
+		section = rb_entry(node,
+				struct restartable_sequence_section, node);
+		rb_erase(&section->node, &task->rseq_state.sections);
+		kfree(section);
+	}
+
+	memset(&task->rseq_state, 0, sizeof(task->rseq_state));
+	task->rseq_state.sections = RB_ROOT;
+}
+
+static DEFINE_MUTEX(rseq_state_mutex);
+
+int rseq_register_critical_current(__user void *start, __user void *end,
+				__user void *restart)
+{
+	struct restartable_sequence_state *rseq_state;
+	struct restartable_sequence_section *section;
+	struct rb_node **new, *parent = NULL;
+	int rc = 0;
+
+	rcu_read_lock();
+	/* The critical section is shared by all threads in a process. */
+	rseq_state = &current->group_leader->rseq_state;
+
+	/* Verify section */
+	if (start >= end) {
+		rc = -EINVAL;
+		goto out_rcu;
+	}
+
+	if (!access_ok(VERIFY_READ, start, end - start) ||
+		!access_ok(VERIFY_READ, restart, 1)) {
+		rc = -EINVAL;
+		goto out_rcu;
+	}
+
+	if (rseq_state->cpu_pointer) {
+		rc = -EBUSY;
+		goto out_rcu;
+	}
+
+	new = &(rseq_state->sections.rb_node);
+
+	section = kmalloc(
+		sizeof(struct restartable_sequence_section), GFP_KERNEL);
+	if (!section) {
+		rc = -ENOMEM;
+		goto out_rcu;
+	}
+	section->crit_end = end;
+	section->crit_start = start;
+	section->crit_restart = restart;
+
+	mutex_lock(&rseq_state_mutex);
+
+	while (*new) {
+		struct restartable_sequence_section *this = container_of(
+			*new, struct restartable_sequence_section, node);
+
+		parent = *new;
+		if (section->crit_end <= this->crit_start)
+			new = &((*new)->rb_left);
+		else if (section->crit_start >= this->crit_end)
+			new = &((*new)->rb_right);
+		else {
+			/* Prevent overlapping regions */
+			kfree(section);
+			rc = -EBUSY;
+			goto out_lock;
+		}
+	}
+
+	rb_link_node(&section->node, parent, new);
+	rb_insert_color(&section->node, &rseq_state->sections);
+
+out_lock:
+	mutex_unlock(&rseq_state_mutex);
+out_rcu:
+
+	smp_wmb();  /* synchronize visibility of new section */
+
+	rcu_read_unlock();
+	return rc;
+}
+
+#define SYS_RSEQ_SET_CRITICAL		0
+#define SYS_RSEQ_SET_CPU_POINTER	1
+
+/*
+ * RSEQ syscall interface.
+ *
+ * Usage:
+ *   SYS_RSEQ_SET_CRITICAL, flags, crit_start, crit_end, crit_restart)
+ *    A thread with user rip in (crit_start, crit_end] that has called
+ *    RSEQ_SET_CPU_POINTER will have its execution resumed at crit_restart
+ *    when interrupted by preemption or signal.
+ *
+ *   SYS_RSEQ_SET_CPU_POINTER, flags, cpu_pointer_address
+ *    Configures a (typically per-thread) value, containing the cpu which that
+ *    thread is currently executing on.
+ *    REQUIRES: SYS_RSEQ_SET_CRITICAL must have previously been called.
+ *
+ *  flags is currently unused.
+ */
+SYSCALL_DEFINE5(restartable_sequences,
+		int, op, int, flags, long, val1, long, val2, long, val3)
+{
+	int rc = -EINVAL;
+
+	if (op == SYS_RSEQ_SET_CRITICAL) {
+		/* Defines (process-wide) critical section. */
+		__user void *crit_start = (__user void *)val1;
+		__user void *crit_end = (__user void *)val2;
+		__user void *crit_restart = (__user void *)val3;
+
+		rc = rseq_register_critical_current(
+			crit_start, crit_end, crit_restart);
+	} else if (op == SYS_RSEQ_SET_CPU_POINTER) {
+		/*
+		 * Enables RSEQ for this thread; sets location for CPU update
+		 * to val1.
+		 */
+		int __user *cpu = (int __user *)val1;
+
+		rc = rseq_register_cpu_pointer(current, cpu);
+	}
+
+	return rc;
+}
+#else
+SYSCALL_DEFINE0(restartable_sequences)
+{
+	return -ENOSYS;
+}
+#endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 10a8faa..1e192f5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2112,6 +2112,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+	memset(&p->rseq_state, 0, sizeof(p->rseq_state));
+	p->rseq_state.sections = RB_ROOT;
+#endif
 }
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6d2a119..c7fb1a6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -953,6 +953,9 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
+	if (rseq_active(p))
+		set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
+
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
 	 * successfuly executed on another CPU. We must ensure that updates of
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index a02decf..d396884 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -248,3 +248,6 @@ cond_syscall(sys_execveat);
 
 /* membarrier */
 cond_syscall(sys_membarrier);
+
+/* restartable sequences */
+cond_syscall(sys_restartable_sequences);
-- 
2.4.6
