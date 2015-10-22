From: Dave Watson <davejwatson@fb.com>
Subject: [RFC PATCH 2/3] restartable sequences: x86 ABI
Date: Thu, 22 Oct 2015 11:06:54 -0700
Message-ID: <b61f16b6a758f10c0e69677e77c5db328fc9c9ab.1445464158.git.davejwatson@fb.com>
References: <cover.1445464158.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1445464158.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davejwatson@fb.com, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, pjt@google.com, mathieu.desnoyers@efficios.com
List-Id: linux-api@vger.kernel.org

Implements the x86 (i386 & x86-64) ABIs for interrupting and restarting
execution within restartable sequence sections.

Ptrace is modified to single step over the entire critical region.
---
 arch/x86/entry/common.c                      |  3 ++
 arch/x86/entry/syscalls/syscall_64.tbl       |  1 +
 arch/x86/include/asm/restartable_sequences.h | 44 ++++++++++++++++++++++++++
 arch/x86/kernel/Makefile                     |  2 ++
 arch/x86/kernel/ptrace.c                     |  6 ++--
 arch/x86/kernel/restartable_sequences.c      | 47 ++++++++++++++++++++++++++++
 arch/x86/kernel/signal.c                     | 12 ++++++-
 kernel/restartable_sequences.c               | 11 +++++--
 8 files changed, 120 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/include/asm/restartable_sequences.h
 create mode 100644 arch/x86/kernel/restartable_sequences.c

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 80dcc92..e817f04 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -24,6 +24,7 @@
 
 #include <asm/desc.h>
 #include <asm/traps.h>
+#include <asm/restartable_sequences.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
@@ -253,6 +254,8 @@ __visible void prepare_exit_to_usermode(struct pt_regs *regs)
 		if (cached_flags & _TIF_NOTIFY_RESUME) {
 			clear_thread_flag(TIF_NOTIFY_RESUME);
 			tracehook_notify_resume(regs);
+			if (rseq_active(current))
+				arch_rseq_handle_notify_resume(regs);
 		}
 
 		if (cached_flags & _TIF_USER_RETURN_NOTIFY)
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 278842f..0fd4243 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -331,6 +331,7 @@
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
+325	common	restartable_sequences	sys_restartable_sequences
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/arch/x86/include/asm/restartable_sequences.h b/arch/x86/include/asm/restartable_sequences.h
new file mode 100644
index 0000000..c0bcab2
--- /dev/null
+++ b/arch/x86/include/asm/restartable_sequences.h
@@ -0,0 +1,44 @@
+#ifndef _ASM_X86_RESTARTABLE_SEQUENCES_H
+#define _ASM_X86_RESTARTABLE_SEQUENCES_H
+
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_RESTARTABLE_SEQUENCES
+
+static inline unsigned long arch_rseq_in_crit_section(struct task_struct *p,
+						struct pt_regs *regs)
+{
+	unsigned long ip = (unsigned long)regs->ip;
+
+	return rseq_lookup(p, ip);
+}
+
+static inline bool arch_rseq_needs_notify_resume(struct task_struct *p)
+{
+#ifdef CONFIG_PREEMPT
+	/*
+	 * Under CONFIG_PREEMPT it's possible for regs to be incoherent in the
+	 * case that we took an interrupt during syscall entry.  Avoid this by
+	 * always deferring to our notify-resume handler.
+	 */
+	return true;
+#else
+	return arch_rseq_in_crit_section(p, task_pt_regs(p));
+#endif
+}
+
+void arch_rseq_handle_notify_resume(struct pt_regs *regs);
+void arch_rseq_check_critical_section(struct task_struct *p,
+				      struct pt_regs *regs);
+
+#else /* !CONFIG_RESTARTABLE_SEQUENCES */
+
+static inline void arch_rseq_handle_notify_resume(struct pt_regs *regs) {}
+static inline void arch_rseq_check_critical_section(struct task_struct *p,
+						    struct pt_regs *regs) {}
+
+#endif
+
+#endif /* _ASM_X86_RESTARTABLE_SEQUENCES_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b1b78ff..ee98fb6 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -110,6 +110,8 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 
+obj-$(CONFIG_RESTARTABLE_SEQUENCES)	+= restartable_sequences.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 558f50e..934aeaf 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1439,6 +1439,8 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	struct siginfo info;
 
 	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
-	/* Send us the fake SIGTRAP */
-	force_sig_info(SIGTRAP, &info, tsk);
+	/* Don't single step in to a restartable sequence */
+	if (!rseq_lookup(tsk, (unsigned long)regs->ip))
+		/* Send us the fake SIGTRAP */
+		force_sig_info(SIGTRAP, &info, tsk);
 }
diff --git a/arch/x86/kernel/restartable_sequences.c b/arch/x86/kernel/restartable_sequences.c
new file mode 100644
index 0000000..330568a
--- /dev/null
+++ b/arch/x86/kernel/restartable_sequences.c
@@ -0,0 +1,47 @@
+/*
+ * Restartable Sequences: x86 ABI.
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
+ * Paul Turner <pjt@google.com> and Andrew Hunter <ahh@google.com>
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <asm/restartable_sequences.h>
+#include <asm/restartable_sequences.h>
+
+void arch_rseq_check_critical_section(struct task_struct *p,
+				      struct pt_regs *regs)
+{
+	unsigned long ip = arch_rseq_in_crit_section(p, regs);
+
+	if (!ip)
+		return;
+
+	/* RSEQ only applies to user-mode execution */
+	BUG_ON(!user_mode(regs));
+
+	regs->ip = ip;
+}
+
+void arch_rseq_handle_notify_resume(struct pt_regs *regs)
+{
+	struct restartable_sequence_state *rseq_state = &current->rseq_state;
+
+	/* If this update fails our user-state is incoherent. */
+	if (put_user(task_cpu(current), rseq_state->cpu_pointer))
+		force_sig(SIGSEGV, current);
+
+	arch_rseq_check_critical_section(current, regs);
+}
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index da52e6b..1516e5d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -30,6 +30,7 @@
 #include <asm/fpu/signal.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
+#include <asm/restartable_sequences.h>
 #include <asm/sighandling.h>
 #include <asm/vm86.h>
 
@@ -377,7 +378,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		 */
 		put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 	} put_user_catch(err);
-	
+
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
@@ -613,6 +614,15 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 	sigset_t *set = sigmask_to_save();
 	compat_sigset_t *cset = (compat_sigset_t *) set;
 
+	/*
+	 * If we are executing in the critical section of a restartable
+	 * sequence we need to fix up the user's stack saved ip at this point
+	 * so that signal handler return does not allow us to jump back into
+	 * the block across a context switch boundary.
+	 */
+	if (rseq_active(current))
+		arch_rseq_check_critical_section(current, regs);
+
 	/* Set up the stack frame */
 	if (is_ia32_frame()) {
 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
index 72cfa9b..87e63e2 100644
--- a/kernel/restartable_sequences.c
+++ b/kernel/restartable_sequences.c
@@ -20,18 +20,23 @@
 
 #ifdef CONFIG_RESTARTABLE_SEQUENCES
 
+#include <asm/restartable_sequences.h>
 #include <linux/uaccess.h>
 #include <linux/preempt.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
 static void rseq_sched_in_nop(struct preempt_notifier *pn, int cpu) {}
-static void rseq_sched_out_nop(struct preempt_notifier *pn,
-			       struct task_struct *next) {}
+static void rseq_sched_out(struct preempt_notifier *pn,
+			   struct task_struct *next)
+{
+	if (arch_rseq_needs_notify_resume(current))
+		set_thread_flag(TIF_NOTIFY_RESUME);
+}
 
 static __read_mostly struct preempt_ops rseq_preempt_ops = {
 	.sched_in = rseq_sched_in_nop,
-	.sched_out = rseq_sched_out_nop,
+	.sched_out = rseq_sched_out,
 };
 
 unsigned long rseq_lookup(struct task_struct *p, unsigned long ip)
-- 
2.4.6
