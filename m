From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] restartable sequences: user-space per-cpu
 critical sections
Date: Fri, 11 Dec 2015 12:56:46 +0000 (UTC)
Message-ID: <2103282529.232385.1449838606844.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <20151027235653.16059.8933.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027235653.16059.8933.stgit-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Oct 27, 2015, at 7:56 PM, Paul Turner commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Introduce the notion of a restartable sequence.  This is a piece of user code
> that can be described in 3 components:
> 
> 1) Establish where [e.g. which cpu] the thread is running
> 2) Preparatory work that is dependent on the state in [1].
> 3) A committing instruction that proceeds only if [2] and [1] have proceeded
>    in a coherent state (i.e. not thread from the same address state has run
>    on the same cpu).

About (3), we'd have to figure out if we want to support shared memory maps
between processes.

> 
> Preemption, or other interruption beyond [1] guarantees that [3] will not
> execute.  With support for control being transferred to a user-defined restart
> handler.  This handler may arrange for the original operation to be retried,
> including potentially resynchronizing with dependent state that may
> have been updated in the interim.
> 
> This may be used in combination with an in-memory cpu-id to allow user programs
> to implement cpu-local data-structures and primitives, without the use/overhead
> of any atomics.

I was thinking perhaps my "thread_local_abi" system call patch could take care
of implementing the thread-local cpu ID cache in userspace ?

ref. https://lkml.org/lkml/2015/12/10/410

This thread_local_abi structure can be extended to add the extra fields
required for this restartable critical section implementation. The main
question here is whether we need to support many rseq per thread or just
a single one ?

> 
> The kernel ABI generally consists of:
> a) A shared TLS word which exports the current cpu and associated event-count

Do the current CPU and event-count need to share the same word ? AFAIU
those could be two different fields, and proper restart behavior could be
ensured by reading the event count before the current CPU (in userspace),
and then afterward re-validating the event count. This would allow using
64/32-bit seqcount on respective architectures.

> b) A shared TLS word which, when non-zero, stores the first post-commit
>    instruction if a sequence is active.  (The kernel observing rips greater
>    than this takes no action and concludes user-space has completed its
>    critical section, but not yet cleared this state).

Ah! Interesting. So we could use this TLS word for various critical sections,
as long as there is no nesting (e.g. no c.s. within c.s., and no c.s. within
signal handler). This limitation is a bit unfortunate for tracing though,
since we'd ideally like to be able to do a c.s. within a signal handler.

Or am I missing some elegant solution to the c.s. within signal handler
problem ? Is the restart ip of a c.s. interrupted by a signal handler
fetched before or after the signal handler execution ? If before, then
c.s. within signal handler would be OK, and this characteristic should
be documented.

> c) An architecture specific way to publish the state read from (a) which
>    user-space believes to be current.

It might be good to state a bit more clearly "publish to whom". I
understand here that it's userspace publishing that state for the
sake of the kernel. Is there any reason why this is typically a
register, or it could be on stack, or in TLS ?

> 
> [ (a) is only read by userspace, it is published by the kernel.
>  (b) is only ready by the kernel, it is published by userspace. ]
> 
> Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> arch/Kconfig                           |    7 ++
> arch/x86/Kconfig                       |    1
> arch/x86/entry/syscalls/syscall_64.tbl |    1
> fs/exec.c                              |    1
> include/linux/sched.h                  |   27 ++++++++
> include/uapi/asm-generic/unistd.h      |    4 +
> init/Kconfig                           |   11 +++
> kernel/Makefile                        |    2 -
> kernel/restartable_sequences.c         |  112 ++++++++++++++++++++++++++++++++
> kernel/sched/core.c                    |    4 +
> kernel/sched/sched.h                   |    3 +
> kernel/sys_ni.c                        |    2 +
> 12 files changed, 172 insertions(+), 3 deletions(-)
> create mode 100644 kernel/restartable_sequences.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 671810c..336880c 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -241,6 +241,13 @@ config HAVE_REGS_AND_STACK_ACCESS_API
> 	  declared in asm/ptrace.h
> 	  For example the kprobes-based event tracer needs this API.
> 
> +config HAVE_RESTARTABLE_SEQUENCE_SUPPORT
> +	bool
> +	depends on HAVE_REGS_AND_STACK_ACCESS_API
> +	help
> +	  This symbol should be selected by an architecture if it supports an
> +	  implementation of restartable sequences.
> +
> config HAVE_CLK
> 	bool
> 	help
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 262b79c..25a0a60 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -135,6 +135,7 @@ config X86
> 	select HAVE_PERF_REGS
> 	select HAVE_PERF_USER_STACK_DUMP
> 	select HAVE_REGS_AND_STACK_ACCESS_API
> +	select HAVE_RESTARTABLE_SEQUENCE_SUPPORT
> 	select HAVE_SYSCALL_TRACEPOINTS
> 	select HAVE_UID16			if X86_32 || IA32_EMULATION
> 	select HAVE_UNSTABLE_SCHED_CLOCK
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
> b/arch/x86/entry/syscalls/syscall_64.tbl
> index 278842f..0fd4243 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -331,6 +331,7 @@
> 322	64	execveat		stub_execveat
> 323	common	userfaultfd		sys_userfaultfd
> 324	common	membarrier		sys_membarrier
> +325	common	restartable_sequences	sys_restartable_sequences
> 
> #
> # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/exec.c b/fs/exec.c
> index 0a77a69..120ef19 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1599,6 +1599,7 @@ static int do_execveat_common(int fd, struct filename
> *filename,
> 	current->in_execve = 0;
> 	acct_update_integrals(current);
> 	task_numa_free(current);
> +	rseq_clear_state_exec();

> 	free_bprm(bprm);
> 	kfree(pathbuf);
> 	putname(filename);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 9e1e06c..03ab1f0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1189,6 +1189,21 @@ struct mempolicy;
> struct pipe_inode_info;
> struct uts_namespace;
> 
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +struct restartable_sequence_state {
> +	__user void *post_commit_instr_addr;
> +	__user u64 *event_and_cpu;
> +
> +	u32 last_switch_count;
> +	u32 event_counter;
> +	struct preempt_notifier notifier;
> +};
> +
> +void rseq_clear_state_exec(void);
> +#else
> +static inline void rseq_clear_state_exec(void) {}
> +#endif
> +
> struct load_weight {
> 	unsigned long weight;
> 	u32 inv_weight;
> @@ -1820,6 +1835,9 @@ struct task_struct {
> #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 	unsigned long	task_state_change;
> #endif
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +	struct restartable_sequence_state rseq_state;
> +#endif
> 	int pagefault_disabled;
> /* CPU-specific state of this task */
> 	struct thread_struct thread;
> @@ -3189,4 +3207,13 @@ static inline unsigned long rlimit_max(unsigned int
> limit)
> 	return task_rlimit_max(current, limit);
> }
> 
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +static inline int rseq_active(struct task_struct *p)
> +{
> +	return p->rseq_state.event_and_cpu != NULL;
> +}
> +#else
> +static inline int rseq_active(struct task_struct *p) { return 0; }
> +#endif
> +
> #endif
> diff --git a/include/uapi/asm-generic/unistd.h
> b/include/uapi/asm-generic/unistd.h
> index ee12400..9659f31 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -713,9 +713,11 @@ __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
> __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
> #define __NR_membarrier 283
> __SYSCALL(__NR_membarrier, sys_membarrier)
> +#define __NR_restartable_sequences 284
> +__SYSCALL(__NR_restartable_sequences, sys_restartable_sequences)
> 
> #undef __NR_syscalls
> -#define __NR_syscalls 284
> +#define __NR_syscalls 285
> 
> /*
>  * All syscalls below here should go away really,
> diff --git a/init/Kconfig b/init/Kconfig
> index c24b6f7..98c02f2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2040,7 +2040,16 @@ config STOP_MACHINE
> source "block/Kconfig"
> 
> config PREEMPT_NOTIFIERS
> -	bool
> +	bool n

Why bool -> bool n  here ?

> +
> +config RESTARTABLE_SEQUENCES
> +	bool "Userspace Restartable Sequences (RSEQ)"
> +	default n
> +	depends on HAVE_RESTARTABLE_SEQUENCE_SUPPORT && PREEMPT_NOTIFIERS
> +	help
> +	  Allows binaries to define a region of user-text within which
> +	  execution will be restarted in the event of signal delivery or
> +	  preemption.
> 
> config PADATA
> 	depends on SMP
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 53abf00..dbe6963 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -101,8 +101,8 @@ obj-$(CONFIG_JUMP_LABEL) += jump_label.o
> obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
> obj-$(CONFIG_TORTURE_TEST) += torture.o
> obj-$(CONFIG_MEMBARRIER) += membarrier.o
> -
> obj-$(CONFIG_HAS_IOMEM) += memremap.o
> +obj-$(CONFIG_RESTARTABLE_SEQUENCES) += restartable_sequences.o
> 
> $(obj)/configs.o: $(obj)/config_data.h
> 
> diff --git a/kernel/restartable_sequences.c b/kernel/restartable_sequences.c
> new file mode 100644
> index 0000000..c99a574
> --- /dev/null
> +++ b/kernel/restartable_sequences.c
> @@ -0,0 +1,112 @@
> +/*
> + * Restartable Sequences are a lightweight interface that allows user-level
> + * code to be executed atomically relative to scheduler preemption.  Typically
> + * used for implementing per-cpu operations.

Should state that it is atomic wrt signal delivery too.

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
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES

This ifdef is already in the Makefile, so it's useless here.

> +
> +#include <linux/uaccess.h>
> +#include <linux/preempt.h>
> +#include <linux/syscalls.h>
> +
> +static void rseq_sched_in_nop(struct preempt_notifier *pn, int cpu) {}
> +static void rseq_sched_out_nop(struct preempt_notifier *pn,
> +			       struct task_struct *next) {}
> +
> +static __read_mostly struct preempt_ops rseq_preempt_ops = {
> +	.sched_in = rseq_sched_in_nop,
> +	.sched_out = rseq_sched_out_nop,
> +};

My guess is that Peter Zijlstra might prefer those to be implemented
as calls from the scheduler rather than preempt notifiers, similarly
to the comments I got for the membarrier system call.

> +
> +int rseq_configure_current(__user u64 *event_and_cpu,
> +			   __user void *post_commit_instr_addr)

__user usually goes after the type, e.g.:

u64 __user *event_and_cpu, void __user *post_commit_instr_addr

> +{
> +	struct restartable_sequence_state *rseq_state = &current->rseq_state;
> +	int addr_size = test_tsk_thread_flag(current, TIF_IA32) ? 4 : 8;

May I suggest:

size_t addr_size = is_compat_task() ? sizeof(compat_uptr_t) : sizeof(void __user *);


> +	int registered = 0;
> +
> +	/* Disable */
> +	if (!event_and_cpu && !post_commit_instr_addr)
> +		goto valid;
> +
> +	if (!event_and_cpu || !post_commit_instr_addr)
> +		return -EINVAL;
> +
> +	if (!access_ok(VERIFY_WRITE, event_and_cpu, sizeof(*event_and_cpu)) ||
> +	    !access_ok(VERIFY_READ, post_commit_instr_addr, addr_size))
> +		return -EINVAL;
> +
> +valid:
> +	preempt_disable();
> +
> +	if (rseq_state->event_and_cpu)
> +		registered = 1;
> +

Let's suppose we have 2 libraries fighting for having "their"
data be registered for rseq. Here the second library would just
override the first one. Is it on purpose ? Should the second lib
just fail ?

> +	rseq_state->event_counter = 1;
> +	rseq_state->event_and_cpu = event_and_cpu;
> +	rseq_state->post_commit_instr_addr = post_commit_instr_addr;
> +
> +	if (event_and_cpu && !registered) {
> +		preempt_notifier_init(&rseq_state->notifier,
> +				      &rseq_preempt_ops);
> +		preempt_notifier_inc();
> +		preempt_notifier_register(&rseq_state->notifier);
> +	} else if (!event_and_cpu && registered) {
> +		preempt_notifier_unregister(&rseq_state->notifier);
> +		preempt_notifier_dec();
> +	}
> +
> +	preempt_enable();
> +
> +	/* Will update *event_and_cpu on return. */
> +	if (event_and_cpu)
> +		set_thread_flag(TIF_NOTIFY_RESUME);

Do we need to set the resume notifier in case we're unregistering ?

> +
> +	return 0;
> +}
> +
> +void rseq_clear_state_exec()

() -> (void)

(unlike C++, () really means (...) in C)

> +{
> +	rseq_configure_current(NULL, NULL);
> +}
> +
> +/*
> + * RSEQ syscall interface.
> + *
> + * Usage:
> + *   sys_restartable_sequences(flags, &event_and_cpu, &post_commit_instr_addr)
> +
> + *  flags is currently unused.
> + */
> +SYSCALL_DEFINE3(restartable_sequences,
> +		int, flags, long, event_and_cpu, long, post_commit_instr_addr)

I would be tempted to put "flags" as last argument (based on other syscalls
I've seen).

> +{
> +	return rseq_configure_current((__user u64 *)event_and_cpu,
> +				      (__user void *)post_commit_instr_addr);
> +}
> +#else
> +SYSCALL_DEFINE0(restartable_sequences)
> +{
> +	return -ENOSYS;
> +}

AFAIK, you don't need this: sys_ni.c does exactly this.

> +#endif
> +
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index aa59732..84e0641 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2120,6 +2120,10 @@ static void __sched_fork(unsigned long clone_flags,
> struct task_struct *p)
> 
> 	p->numa_group = NULL;
> #endif /* CONFIG_NUMA_BALANCING */
> +
> +#ifdef CONFIG_RESTARTABLE_SEQUENCES
> +	memset(&p->rseq_state, 0, sizeof(p->rseq_state));
> +#endif

Is it really what we want on fork ? Let's take this example: we
have a single-threaded process, which registers a rseq, and it forks.
I would expect the child process' thread to keep the same state as
its parent, and have the rseq registered. Copying the parent thread
state seems less surprising here. This could be implemented by a
rseq_copy_state_fork() or such.

Thanks,

Mathieu

> }
> 
> DEFINE_STATIC_KEY_FALSE(sched_numa_balancing);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index efd3bfc..e8de833 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -957,6 +957,9 @@ static inline void __set_task_cpu(struct task_struct *p,
> unsigned int cpu)
> {
> 	set_task_rq(p, cpu);
> #ifdef CONFIG_SMP
> +	if (rseq_active(p))
> +		set_tsk_thread_flag(p, TIF_NOTIFY_RESUME);
> +
> 	/*
> 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
> 	 * successfuly executed on another CPU. We must ensure that updates of
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index a02decf..0bdf060 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -248,3 +248,5 @@ cond_syscall(sys_execveat);
> 
> /* membarrier */
> cond_syscall(sys_membarrier);
> +/* restartable sequences */
> +cond_syscall(sys_restartable_sequences);

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
