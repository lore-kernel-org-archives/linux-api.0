From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] restartable sequences: x86 ABI
Date: Fri, 26 Jun 2015 18:09:46 +0000 (UTC)
Message-ID: <1050218158.4054.1435342186284.JavaMail.zimbra@efficios.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com> <20150624222609.6116.30992.stgit@kitami.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624222609.6116.30992.stgit-tdHu5vqousHHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 24, 2015, at 6:26 PM, Paul Turner pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:

> Implements the x86 (i386 & x86-64) ABIs for interrupting and restarting
> execution within restartable sequence sections.
> 
> With respect to the x86-specific ABI:
>  On 32-bit:           Upon restart, the interrupted rip is placed in %ecx
>  On 64-bit (or x32):  Upon restart, the interrupted rip is placed in %r10
> 
> While potentially surprising at first glance, this choice is strongly motivated
> by the fact that the available scratch registers under the i386 function call
> ABI overlap with those used as argument registers under x86_64.
> 
> Given that sequences are already personality specific and that we always want
> the arguments to be available for sequence restart, it's much more natural to
> ultimately differentiate the ABI in these two cases.
> 
> Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> arch/x86/include/asm/restartable_sequences.h |   50 +++++++++++++++++++
> arch/x86/kernel/Makefile                     |    2 +
> arch/x86/kernel/restartable_sequences.c      |   69 ++++++++++++++++++++++++++
> arch/x86/kernel/signal.c                     |   12 +++++
> kernel/restartable_sequences.c               |   11 +++-
> 5 files changed, 141 insertions(+), 3 deletions(-)
> create mode 100644 arch/x86/include/asm/restartable_sequences.h
> create mode 100644 arch/x86/kernel/restartable_sequences.c
> 
> diff --git a/arch/x86/include/asm/restartable_sequences.h
> b/arch/x86/include/asm/restartable_sequences.h
> new file mode 100644
> index 0000000..0ceb024
> --- /dev/null
> +++ b/arch/x86/include/asm/restartable_sequences.h
> @@ -0,0 +1,50 @@
> +#ifndef _ASM_X86_RESTARTABLE_SEQUENCES_H
> +#define _ASM_X86_RESTARTABLE_SEQUENCES_H
> +
> +#include <asm/processor.h>
> +#include <asm/ptrace.h>
> +#include <linux/sched.h>
> +
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +
> +static inline bool arch_rseq_in_crit_section(struct task_struct *p,
> +					     struct pt_regs *regs)
> +{
> +	struct task_struct *leader = p->group_leader;
> +	struct restartable_sequence_state *rseq_state = &leader->rseq_state;
> +
> +	unsigned long ip = (unsigned long)regs->ip;
> +	if (unlikely(ip < (unsigned long)rseq_state->crit_end &&
> +		     ip >= (unsigned long)rseq_state->crit_start))
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool arch_rseq_needs_notify_resume(struct task_struct *p)
> +{
> +#ifdef CONFIG_PREEMPT
> +	/*
> +	 * Under CONFIG_PREEMPT it's possible for regs to be incoherent in the
> +	 * case that we took an interrupt during syscall entry.  Avoid this by
> +	 * always deferring to our notify-resume handler.
> +	 */
> +	return true;

I'm a bit puzzled about this. If I look at perf_get_regs_user() in the perf
code, task_pt_regs() seems to return the user-space pt_regs for a task with
a current->mm set (iow, not a kernel thread), even if an interrupt nests on
top of a system call. The only corner-case is NMIs, where an NMI may interrupt
in the middle of setting up the task pt_regs, but scheduling should never happen
there, right ?

Since it's impossible for kernel threads to have a rseq critical section,
we should be able to assume that every time task_pt_regs() returns a
non-userspace (user_mode(regs) != 0) pt_regs implies that scheduling applies
to a kernel thread. Therefore, following this line of thoughts,
arch_rseq_in_crit_section() should work for CONFIG_PREEMPT kernels too.

So what I am missing here ?

Thanks,

Mathieu

> +#else
> +	return arch_rseq_in_crit_section(p, task_pt_regs(p));
> +#endif
> +}
> +
> +void arch_rseq_handle_notify_resume(struct pt_regs *regs);
> +void arch_rseq_check_critical_section(struct task_struct *p,
> +				      struct pt_regs *regs);
> +
> +#else /* !CONFIG_RESTARTABLE_SEQUENCES */
> +
> +static inline void arch_rseq_handle_notify_resume(struct pt_regs *regs) {}
> +static inline void arch_rseq_check_critical_section(struct task_struct *p,
> +						    struct pt_regs *regs) {}
> +
> +#endif
> +
> +#endif /* _ASM_X86_RESTARTABLE_SEQUENCES_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index febaf18..bd7827d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -113,6 +113,8 @@ obj-$(CONFIG_TRACING)			+= tracepoint.o
> obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
> obj-$(CONFIG_PMC_ATOM)			+= pmc_atom.o
> 
> +obj-$(CONFIG_RESTARTABLE_SEQUENCES)	+= restartable_sequences.o
> +
> ###
> # 64 bit specific files
> ifeq ($(CONFIG_X86_64),y)
> diff --git a/arch/x86/kernel/restartable_sequences.c
> b/arch/x86/kernel/restartable_sequences.c
> new file mode 100644
> index 0000000..3b38013
> --- /dev/null
> +++ b/arch/x86/kernel/restartable_sequences.c
> @@ -0,0 +1,69 @@
> +/*
> + * Restartable Sequences: x86 ABI.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + *
> + * Copyright (C) 2015, Google, Inc.,
> + * Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> and Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> + *
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <asm/restartable_sequences.h>
> +
> +void arch_rseq_check_critical_section(struct task_struct *p,
> +				      struct pt_regs *regs)
> +{
> +	if (!arch_rseq_in_crit_section(p, regs))
> +		return;
> +
> +	/* RSEQ only applies to user-mode execution */
> +	BUG_ON(!user_mode(regs));
> +
> +	/*
> +	 * The ABI is slightly different for {32,64}-bit threads on x86
> +	 *
> +	 * Short version:
> +	 *   x86-64 (or x32): interrupted rip => %r10
> +	 *   i386:            interrupted rip => %ecx
> +	 *
> +	 * Longer version:
> +	 * The scratch registers available under the i386 function call ABI
> +	 * overlap with those used by argument registers under the x86_64 ABI.
> +	 *
> +	 * Given that the sequence block is already personality specific in
> +	 * that it must be entered by 'call' and that we always want the
> +	 * arguments available for a sequence restart; it's more natural to
> +	 * differentiate the ABI in these two cases.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(p, TIF_IA32)))
> +		regs->cx = regs->ip; /* i386 */
> +	else
> +		regs->r10 = regs->ip; /* x86-64/x32 */
> +
> +	regs->ip = (unsigned long)p->group_leader->rseq_state.crit_restart;
> +}
> +
> +void arch_rseq_handle_notify_resume(struct pt_regs *regs)
> +{
> +	struct restartable_sequence_state *rseq_state = &current->rseq_state;
> +
> +	/* If this update fails our user-state is incoherent. */
> +	if (put_user(task_cpu(current), rseq_state->cpu_pointer))
> +		force_sig(SIGSEGV, current);
> +
> +	arch_rseq_check_critical_section(current, regs);
> +}
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 206996c..987c50b 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -31,6 +31,7 @@
> #include <asm/vdso.h>
> #include <asm/mce.h>
> #include <asm/sighandling.h>
> +#include <asm/restartable_sequences.h>
> 
> #ifdef CONFIG_X86_64
> #include <asm/proto.h>
> @@ -617,6 +618,15 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
> 	sigset_t *set = sigmask_to_save();
> 	compat_sigset_t *cset = (compat_sigset_t *) set;
> 
> +	/*
> +	 * If we are executing in the critical section of a restartable
> +	 * sequence we need to fix up the user's stack saved ip at this point
> +	 * so that signal handler return does not allow us to jump back into
> +	 * the block across a context switch boundary.
> +	 */
> +	if (rseq_active(current))
> +		arch_rseq_check_critical_section(current, regs);
> +
> 	/* Set up the stack frame */
> 	if (is_ia32_frame()) {
> 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
> @@ -755,6 +765,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32
> thread_info_flags)
> 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
> 		clear_thread_flag(TIF_NOTIFY_RESUME);
> 		tracehook_notify_resume(regs);
> +		if (rseq_active(current))
> +			arch_rseq_handle_notify_resume(regs);
> 	}
> 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
> 		fire_user_return_notifiers();
> diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
> index 72945f2..9102241 100644
> --- a/kernel/restartable_sequences.c
> +++ b/kernel/restartable_sequences.c
> @@ -24,17 +24,22 @@
> 
> #ifdef CONFIG_RESTARTABLE_SEQUENCES
> 
> +#include <asm/restartable_sequences.h>
> #include <linux/uaccess.h>
> #include <linux/preempt.h>
> #include <linux/syscalls.h>
> 
> static void rseq_sched_in_nop(struct preempt_notifier *pn, int cpu) {}
> -static void rseq_sched_out_nop(struct preempt_notifier *pn,
> -			       struct task_struct *next) {}
> +static void rseq_sched_out(struct preempt_notifier *pn,
> +			   struct task_struct *next)
> +{
> +	if (arch_rseq_needs_notify_resume(current))
> +		set_thread_flag(TIF_NOTIFY_RESUME);
> +}
> 
> static __read_mostly struct preempt_ops rseq_preempt_ops = {
> 	.sched_in = rseq_sched_in_nop,
> -	.sched_out = rseq_sched_out_nop,
> +	.sched_out = rseq_sched_out,
> };
> 
>  int rseq_register_cpu_pointer_current(int __user *cpu_pointer)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
