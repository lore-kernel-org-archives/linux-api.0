From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] restartable sequences: x86 ABI
Date: Fri, 11 Dec 2015 13:30:15 +0000 (UTC)
Message-ID: <72792257.232485.1449840615047.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <20151027235705.16059.63268.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027235705.16059.63268.stgit-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Oct 27, 2015, at 7:57 PM, Paul Turner commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Recall the general ABI is:
>   The kernel ABI generally consists of:
>     a) A shared TLS word which exports the current cpu and event-count
>     b) A shared TLS word which, when non-zero, stores the first post-commit
>        instruction if a sequence is active.  (The kernel observing rips greater
>        than this takes no action and concludes user-space has completed its
>        critical section, but not yet cleared this state).
>     c) An architecture specific way to publish the state read from (a) which
>        user-space believes to be current.
> 
> This patch defines (c) for x86, both x86_64 and i386.

It seems to also take care of signal handler restarts (should be
documented in the changelog).

> 
> The exact sequence is:
>  *0. Userspace stores current event+cpu counter values
>   1. Userspace loads the rip to move to at failure into cx
>   2. Userspace loads the rip of the instruction following
>      the critical section into a registered TLS address.
>   3. Userspace loads the values read at [0] into a known
>      location.
>   4. Userspace tests to see whether the current event and
>      cpu counter values match those stored at 0.  Manually
>      jumping to the address from [1] in the case of a
>      mismatch.
> 
>      Note that if we are preempted or otherwise interrupted
>      then the kernel can also now perform this comparison
>      and conditionally jump us to [1].
>   4. Our final instruction bfeore [2] is then our commit.

bfeore -> before

>      The critical section is self-terminating.  [2] must
>      also be cleared at this point.

^ see comments for patch 0/3 for this repeated description.

> 
> For x86_64:
>   [3] uses rdx to represent cpu and event counter as a
>       single 64-bit value.
> 
> For i386:
>   [3] uses ax for cpu and dx for the event_counter.

^ again, see comments for patch 0/3.

> 
>  Both:
>   Instruction after commit: rseq_state->post_commit_instr
>   Current event and cpu state: rseq_state->event_and_cpu
> 
> An example user-space x86_64 implementation:
>    __asm__ __volatile__ goto (
>                    "movq $%l[failed], %%rcx\n"
>                    "movq $1f, %[commit_instr]\n"
>                    "cmpq %[start_value], %[current_value]\n"
>                    "jnz %l[failed]\n"
>                    "movq %[to_write], (%[target])\n"
>                    "1: movq $0, %[commit_instr]\n"
>      : /* no outputs */
>      : [start_value]"d"(start_value.storage),
>        [current_value]"m"(__rseq_state),
>        [to_write]"r"(to_write),
>        [target]"r"(p),
>        [commit_instr]"m"(__rseq_state.post_commit_instr)
>      : "rcx", "memory"
>      : failed
> 
> Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> arch/x86/entry/common.c                      |    3 +
> arch/x86/include/asm/restartable_sequences.h |   18 +++
> arch/x86/kernel/Makefile                     |    2
> arch/x86/kernel/restartable_sequences.c      |  136 ++++++++++++++++++++++++++
> arch/x86/kernel/signal.c                     |    7 +
> kernel/restartable_sequences.c               |   10 +-
> 6 files changed, 173 insertions(+), 3 deletions(-)
> create mode 100644 arch/x86/include/asm/restartable_sequences.h
> create mode 100644 arch/x86/kernel/restartable_sequences.c
> 
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index a89fdbc..e382487 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -23,6 +23,7 @@
> #include <linux/uprobes.h>
> 
> #include <asm/desc.h>
> +#include <asm/restartable_sequences.h>
> #include <asm/traps.h>
> #include <asm/vdso.h>
> #include <asm/uaccess.h>
> @@ -249,6 +250,8 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32
> cached_flags)
> 		if (cached_flags & _TIF_NOTIFY_RESUME) {
> 			clear_thread_flag(TIF_NOTIFY_RESUME);
> 			tracehook_notify_resume(regs);
> +			if (rseq_active(current))
> +				arch_rseq_update_event_counter(regs);
> 		}
> 
> 		if (cached_flags & _TIF_USER_RETURN_NOTIFY)
> diff --git a/arch/x86/include/asm/restartable_sequences.h
> b/arch/x86/include/asm/restartable_sequences.h
> new file mode 100644
> index 0000000..75864a7
> --- /dev/null
> +++ b/arch/x86/include/asm/restartable_sequences.h
> @@ -0,0 +1,18 @@
> +#ifndef _ASM_X86_RESTARTABLE_SEQUENCES_H
> +#define _ASM_X86_RESTARTABLE_SEQUENCES_H
> +
> +#include <asm/processor.h>
> +#include <asm/ptrace.h>
> +#include <linux/sched.h>
> +
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +
> +void arch_rseq_update_event_counter(struct pt_regs *regs);
> +
> +#else /* !CONFIG_RESTARTABLE_SEQUENCES */
> +
> +static inline void arch_rseq_update_event_counter(struct pt_regs *regs) {}
> +
> +#endif

for ifdef consistency, I would recommend Paul McKenney's approach:

#ifdef CONFIG_RESTARTABLE_SEQUENCES

#else /* #ifdef CONFIG_RESTARTABLE_SEQUENCES */

#endif /* #else #ifdef CONFIG_RESTARTABLE_SEQUENCES */


> +
> +#endif /* _ASM_X86_RESTARTABLE_SEQUENCES_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index b1b78ff..ee98fb6 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -110,6 +110,8 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
> obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
> obj-$(CONFIG_TRACING)			+= tracepoint.o
> 
> +obj-$(CONFIG_RESTARTABLE_SEQUENCES)	+= restartable_sequences.o
> +
> ###
> # 64 bit specific files
> ifeq ($(CONFIG_X86_64),y)
> diff --git a/arch/x86/kernel/restartable_sequences.c
> b/arch/x86/kernel/restartable_sequences.c
> new file mode 100644
> index 0000000..9f43efd
> --- /dev/null
> +++ b/arch/x86/kernel/restartable_sequences.c
> @@ -0,0 +1,136 @@
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

Not sure why this empty line here ?

> + */
> +
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <asm/ptrace.h>
> +#include <asm/processor-flags.h>
> +#include <asm/restartable_sequences.h>
> +
> +static inline u64 rseq_encode_cpu_and_event_count(int cpu, int event_count)
> +{
> +	return (u64)(event_count) << 32 | cpu;
> +}

Still wondering why those need to be combined.

> +
> +static inline int rseq_regs_cpu(struct pt_regs *regs, int is_i386)
> +{
> +#ifdef CONFIG_64BIT
> +	return is_i386 ? regs->ax : regs->dx & 0xFFFF;

Should it rather be ?

return is_i386 ? regs->ax : regs->dx & 0xFFFFFFFF;

> +#else
> +	return regs->ax;
> +#endif
> +}
> +
> +static inline int rseq_regs_event_count(struct pt_regs *regs, int is_i386)
> +{
> +#ifdef CONFIG_64BIT
> +	return is_i386 ? regs->dx : regs->dx >> 32;
> +#else
> +	return regs->dx;
> +#endif
> +}
> +
> +void arch_rseq_update_event_counter(struct pt_regs *regs)
> +{
> +	struct restartable_sequence_state *rseq_state = &current->rseq_state;
> +	int cpu = task_cpu(current);

Could we change task_cpu(current) for smp_processor_id() ?

> +	int is_i386 = test_tsk_thread_flag(current, TIF_IA32);

How should we consider x32 (is_x32_task()) ?

> +	int addr_size = is_i386 ? 4 : 8;

See other patch comment about using is_compat_task() and sizeof().

> +	long post_commit_instr = 0;
> +	u64 state_value;
> +
> +	/*
> +	 * Note: post_commit_instr must be zero-initialized above for the case
> +	 * of a 32-bit thread on a 64-bit system.
> +	 */
> +	if (copy_from_user(&post_commit_instr,
> +			   rseq_state->post_commit_instr_addr, addr_size)) {

Hrm, that's a little endian hack. Could this be cleaned up so
it won't break horribly when ported to big endian architectures ?

> +		goto fail;
> +	}
> +
> +	/* Handle potentially being within a critical section. */
> +	if (regs->ip < post_commit_instr) {

It appears that this mechanism is not responsible for handling
rseq that contain a call to sub-functions, given that those sub-functions
could be above post_commit_instr, and given that it would be incorrect
to move the instruction pointer outside of the scope of the inline assembly.
Are function calls supported within the rseq c.s. ?

> +		/*
> +		 * The ABI is relatively compact, with some differences for 32
> +		 * and 64-bit threads.
> +		 *
> +		 * Progress is ordered as follows:
> +		 *  *0. USerspace stores current event+cpu counter values

USerspace -> Userspace

> +		 *   1. Userspace loads the rip to move to at failure into cx
> +		 *   2. Userspace loads the rip of the instruction following
> +		 *      the critical section into a registered TLS address.
> +		 *   3. Userspace loads the values read at [0] into a known
> +		 *      location.
> +		 *   4. Userspace tests to see whether the current event and
> +		 *      cpu counter values match those stored at 0.  Manually
> +		 *      jumping to the address from [1] in the case of a
> +		 *      mismatch.
> +		 *
> +		 *      Note that if we are preempted or otherwise interrupted
> +		 *      then the kernel can also now perform this comparison
> +		 *      and conditionally jump us to [1].
> +		 *   4. Our final instruction bfeore [2] is then our commit.

bfeore -> before

> +		 *      The critical section is self-terminating.  [2] must
> +		 *      also be cleared at this point.
> +		 *
> +		 * For x86_64:
> +		 *   [3] uses rdx to represent cpu and event counter as a
> +		 *       single 64-bit value.
> +		 *
> +		 * For i386:
> +		 *   [3] uses ax for cpu and dx for the event_counter.
> +		 *
> +		 *  Both:
> +		 *   Instruction after commit: rseq_state->post_commit_instr
> +		 *   Current event and cpu state: rseq_state->event_and_cpu

^ see comments on patch 0/3 changelog.

> +		 *

Empty line to remove.

Thanks,

Mathieu

> +		 */
> +		if (rseq_regs_cpu(regs, is_i386) != cpu ||
> +		    rseq_regs_event_count(regs, is_i386) !=
> +				rseq_state->event_counter) {
> +			if (clear_user(rseq_state->post_commit_instr_addr,
> +						addr_size))
> +				goto fail;
> +
> +			/*
> +			 * We set this after potentially failing in clear_user
> +			 * so that the signal arrives at the faulting rip.
> +			 */
> +			regs->ip = regs->cx;
> +		}
> +	}
> +
> +	/* Update state. Compute the next expected state value. */
> +	state_value = rseq_encode_cpu_and_event_count(cpu,
> +			++rseq_state->event_counter);
> +
> +	if (put_user(state_value, rseq_state->event_and_cpu))
> +		goto fail;
> +
> +	return;
> +fail:
> +	/*
> +	 * User space has made some (invalid) protection change that does not
> +	 * allow us to safely continue execution.  SEGV is the result.
> +	 */
> +	force_sig(SIGSEGV, current);
> +}
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index b7ffb7c..58f8813 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -30,6 +30,7 @@
> #include <asm/fpu/signal.h>
> #include <asm/vdso.h>
> #include <asm/mce.h>
> +#include <asm/restartable_sequences.h>
> #include <asm/sighandling.h>
> #include <asm/vm86.h>
> 
> @@ -615,6 +616,12 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
> 	sigset_t *set = sigmask_to_save();
> 	compat_sigset_t *cset = (compat_sigset_t *) set;
> 
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +	/* Increment the event counter for the, present, pre-signal frame. */

There appears to be a lot of, commas, here. ;-)

> +	if (rseq_active(current))
> +		arch_rseq_update_event_counter(regs);
> +#endif
> +
> 	/* Set up the stack frame */
> 	if (is_ia32_frame()) {
> 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
> diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
> index c99a574..5449561 100644
> --- a/kernel/restartable_sequences.c
> +++ b/kernel/restartable_sequences.c
> @@ -24,17 +24,21 @@
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
> +	set_thread_flag(TIF_NOTIFY_RESUME);
> +}
> 
> static __read_mostly struct preempt_ops rseq_preempt_ops = {
> 	.sched_in = rseq_sched_in_nop,
> -	.sched_out = rseq_sched_out_nop,
> +	.sched_out = rseq_sched_out,
> };
> 
>  int rseq_configure_current(__user u64 *event_and_cpu,

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
