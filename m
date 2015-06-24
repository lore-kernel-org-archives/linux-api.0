From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/3] restartable sequences: user-space per-cpu critical
 sections
Date: Wed, 24 Jun 2015 15:26:09 -0700
Message-ID: <20150624222609.6116.33938.stgit@kitami.mtv.corp.google.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624222609.6116.86035.stgit-tdHu5vqousHHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
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
- A single (per-address space) critical region
- A restart handler which pairs with the region above
- A (per-thread) memory location which will be kept current with its cpu

The definition of the above is performed via a new syscall,
  SYSCALL_DEFINE5(restartable_sequences,
                  int, op, int, flags, long, val1, long, val2, long, val3)

There are currently 2 possible operations,
  1) Configure the critical region (and restart handler)
  2) Configure the per-thread cpu pointer

[ See kernel/restartable_sequences.c for full documentation ]

A thread that has not configured (2) will not be restarted when executing in
(1).

Note that while the kernel only sees a single critical region, arbitrarily many
sequences can be composed via multiplexing of the user-space restart handler.

This patch introduces the general framework for configuration, as well as
exposing the syscall.  We minimally expose x86 as having support (even though
the actual ABI is added by a subsequent patch) so that this can be compile
tested in isolation.

Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/Kconfig                      |    7 +
 arch/x86/Kconfig                  |    1 
 arch/x86/syscalls/syscall_64.tbl  |    1 
 fs/exec.c                         |    1 
 include/linux/sched.h             |   28 ++++++
 include/uapi/asm-generic/unistd.h |    5 +
 init/Kconfig                      |    9 ++
 kernel/Makefile                   |    1 
 kernel/restartable_sequences.c    |  185 +++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c               |    4 +
 kernel/sched/sched.h              |    3 +
 kernel/sys_ni.c                   |    3 +
 12 files changed, 246 insertions(+), 2 deletions(-)
 create mode 100644 kernel/restartable_sequences.c

diff --git a/arch/Kconfig b/arch/Kconfig
index a65eafb..fb31981 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -229,6 +229,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
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
index 8fec044..9c9c92f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -67,6 +67,7 @@ config X86
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RESTARTABLE_SEQUENCE_SUPPORT
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 9ef32d5..1de5cbc 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	restartable_sequences	sys_restartable_sequences
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/exec.c b/fs/exec.c
index 1977c2a..acd38f6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1590,6 +1590,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	current->in_execve = 0;
 	acct_update_integrals(current);
 	task_numa_free(current);
+	rseq_clear_state_exec();
 	free_bprm(bprm);
 	kfree(pathbuf);
 	putname(filename);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index af0eeba..0540735 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1178,6 +1178,22 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+struct restartable_sequence_state {
+	/* Start and end of an address space's critical section. */
+	void __user *crit_start, __user *crit_end;
+	/* Where preempted threads will be restarted. */
+	void __user *crit_restart;
+	/* Thread's current CPU, typically in TLS. */
+	int __user *cpu_pointer;
+	struct preempt_notifier notifier;
+};
+
+void rseq_clear_state_exec(void);
+#else
+static inline void rseq_clear_state_exec(void) {}
+#endif
+
 struct load_weight {
 	unsigned long weight;
 	u32 inv_weight;
@@ -1793,6 +1809,9 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+	struct restartable_sequence_state rseq_state;
+#endif
 	int pagefault_disabled;
 };
 
@@ -3167,4 +3186,13 @@ static inline unsigned long rlimit_max(unsigned int limit)
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
index e016bd9..6173f56 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,10 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
-
+#define __NR_restartable_sequences 282
+__SYSCALL(__NR_restartable_sequences, sys_restartable_sequences)
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff --git a/init/Kconfig b/init/Kconfig
index 81050e4..a597e30 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2010,6 +2010,15 @@ source "block/Kconfig"
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
index 60c302c..01eea12 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
+obj-$(CONFIG_RESTARTABLE_SEQUENCES) += restartable_sequences.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
new file mode 100644
index 0000000..72945f2
--- /dev/null
+++ b/kernel/restartable_sequences.c
@@ -0,0 +1,185 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
+int rseq_register_cpu_pointer_current(int __user *cpu_pointer)
+{
+	struct restartable_sequence_state *rseq_state =
+		&current->rseq_state;
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
+	if (cpu_pointer && !current->group_leader->rseq_state.crit_restart) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+	smp_rmb();  /* Pairs with setting crit_restart. */
+
+	if (rseq_state->cpu_pointer)
+		registered = 1;
+	rseq_state->cpu_pointer = cpu_pointer;
+
+	if (cpu_pointer && !registered) {
+		preempt_notifier_init(&rseq_state->notifier,
+				      &rseq_preempt_ops);
+		preempt_notifier_register(&rseq_state->notifier);
+	} else if (!cpu_pointer && registered) {
+		preempt_notifier_unregister(&rseq_state->notifier);
+	}
+
+	/* Will update *cpu_pointer on return. */
+	if (cpu_pointer)
+		set_thread_flag(TIF_NOTIFY_RESUME);
+out_unlock:
+	rcu_read_unlock();
+
+	return 0;
+}
+
+void rseq_clear_state_exec()
+{
+	/* Ensure notifier is disabled. */
+	rseq_register_cpu_pointer_current(NULL);
+	memset(&current->rseq_state, 0, sizeof(current->rseq_state));
+}
+
+static DEFINE_MUTEX(rseq_state_mutex);
+
+int rseq_register_critical_current(__user void *start, __user void *end,
+				   __user void *restart)
+{
+	struct restartable_sequence_state *rseq_state;
+	int rc = 0;
+
+	rcu_read_lock();
+	/* The critical section is shared by all threads in a process. */
+	rseq_state = &current->group_leader->rseq_state;
+
+	/* [start,end) must not overlap with the restart handler. */
+	if (start >= end || (restart >= start && restart < end)) {
+		rc = -EINVAL;
+		goto out_rcu;
+	}
+
+	if (!access_ok(VERIFY_READ, start, end - start) ||
+	    !access_ok(VERIFY_READ, restart, 1)) {
+		rc = -EINVAL;
+		goto out_rcu;
+	}
+
+	mutex_lock(&rseq_state_mutex);
+	/*
+	 * We (currently) only allow RSEQ to be configured once.  This
+	 * simplifies synchronization with updates and reduces the risk of
+	 * colliding critical sections.
+	 */
+	if (rseq_state->crit_restart) {
+		rc = -EBUSY;
+	} else {
+		rseq_state->crit_start = start;
+		rseq_state->crit_end = end;
+		smp_wmb();  /* synchronize on visibility of crit_restart. */
+		rseq_state->crit_restart = restart;
+	}
+	mutex_unlock(&rseq_state_mutex);
+out_rcu:
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
+ *
+ * Note:  RSEQ_SET_CRITICAL may currently only be called once within an address
+ * space.  This more general (e.g. by using RCU to synchronize region updates).
+ * However, that also introduces the risk of corruption in the case that more
+ * than one caller compete for control of the critical section.
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
+		rc = rseq_register_critical_current(
+			crit_start, crit_end, crit_restart);
+	} else if (op == SYS_RSEQ_SET_CPU_POINTER) {
+		/*
+		 * Enables RSEQ for this thread; sets location for CPU update
+		 * to val1.
+		 */
+		int __user *cpu = (int __user *)val1;
+		rc = rseq_register_cpu_pointer_current(cpu);
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
+
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 921a754..1113565 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1868,6 +1868,10 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+	memset(&p->rseq_state, 0, sizeof(p->rseq_state));
+#endif
 }
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f10a445..24d4fac 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -947,6 +947,9 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
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
index 7995ef5..4b109d9 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -243,3 +243,6 @@ cond_syscall(sys_bpf);
 
 /* execveat */
 cond_syscall(sys_execveat);
+
+/* restartable sequences */
+cond_syscall(sys_restartable_sequences);
