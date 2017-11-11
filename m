From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v2] Fix: x86: Add missing core serializing
 instruction on migration
Date: Sat, 11 Nov 2017 15:14:59 +0000 (UTC)
Message-ID: <641812690.13218.1510413299315.JavaMail.zimbra@efficios.com>
References: <20171111150357.26072-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171111150357.26072-1-mathieu.desnoyers@efficios.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, maged michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Andrea Parri <parri.andrea@gmail.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, x8
List-Id: linux-api@vger.kernel.org

Fixing the stable@kernel.org CC.

----- On Nov 11, 2017, at 10:03 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> x86 has a missing core serializing instruction in migration scenarios.
> 
> Given that x86-32 can return to user-space with sysexit, and x86-64
> through sysretq and sysretl, which are not core serializing, the
> following user-space self-modifiying code (JIT) scenario can occur:
> 
>     CPU 0                      CPU 1
> 
> User-space self-modify code
> Preempted
> migrated              ->
>                                scheduler selects task
>                                Return to user-space (iret or sysexit)
>                                User-space issues sync_core()
>                      <-        migrated
> scheduler selects task
> Return to user-space (sysexit)
> jump to modified code
> Run modified code without sync_core() -> bug.
> 
> This migration pattern can return to user-space through sysexit,
> sysretl, or sysretq, which are not core serializing, and therefore
> breaks sequential consistency expectations from a single-threaded
> process.
> 
> Fix this issue by introducing sync_core_before_usermode(), invoked the
> first time a runqueue finishes a task switch after receiving a migrated
> thread.
> 
> Architectures defining the sync_core_before_usermode() static inline
> need to define ARCH_HAS_SYNC_CORE_BEFORE_USERMODE.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andy Lutomirski <luto@kernel.org>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Andrew Hunter <ahh@google.com>
> CC: Maged Michael <maged.michael@gmail.com>
> CC: Avi Kivity <avi@scylladb.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andrea Parri <parri.andrea@gmail.com>
> CC: Russell King <linux@armlinux.org.uk>
> CC: Greg Hackmann <ghackmann@google.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: David Sehr <sehr@google.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: x86@kernel.org
> CC: linux-arch@vger.kernel.org
> CC: stable@kernel.org
> 
> ---
> Changes since v1:
> - Fold patch introducing sync_core_before_usermode and the fix
>  into a single patch.
> - CC stable@kernel.org
> ---
> arch/x86/Kconfig                 |  1 +
> arch/x86/include/asm/processor.h | 10 ++++++++++
> include/linux/processor.h        |  6 ++++++
> kernel/sched/core.c              |  7 +++++++
> kernel/sched/sched.h             |  1 +
> 5 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2fdb23313dd5..b27456f04cc6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -62,6 +62,7 @@ config X86
> 	select ARCH_HAS_SG_CHAIN
> 	select ARCH_HAS_STRICT_KERNEL_RWX
> 	select ARCH_HAS_STRICT_MODULE_RWX
> +	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
> 	select ARCH_HAS_UBSAN_SANITIZE_ALL
> 	select ARCH_HAS_ZONE_DEVICE		if X86_64
> 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index bdac19ab2488..6daf70a8c81c 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -706,6 +706,16 @@ static inline void sync_core(void)
> #endif
> }
> 
> +/*
> + * Ensure that a core serializing instruction is issued before returning
> + * to user-mode. x86 implements return to user-space through sysexit,
> + * sysretl, and sysretq, which are not core serializing.
> + */
> +static inline void sync_core_before_usermode(void)
> +{
> +	sync_core();
> +}
> +
> extern void select_idle_routine(const struct cpuinfo_x86 *c);
> extern void amd_e400_c1e_apic_setup(void);
> 
> diff --git a/include/linux/processor.h b/include/linux/processor.h
> index dbc952eec869..7d12e6fa050e 100644
> --- a/include/linux/processor.h
> +++ b/include/linux/processor.h
> @@ -68,4 +68,10 @@ do {								\
> 
> #endif
> 
> +#ifndef ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
> +static inline sync_core_before_usermode(void)
> +{
> +}
> +#endif
> +
> #endif /* _LINUX_PROCESSOR_H */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d17c5da523a0..39c0bbe8f259 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -927,6 +927,7 @@ static struct rq *move_queued_task(struct rq *rq, struct
> rq_flags *rf,
> 
> 	rq_lock(rq, rf);
> 	BUG_ON(task_cpu(p) != new_cpu);
> +	rq->need_sync_core = 1;
> 	enqueue_task(rq, p, 0);
> 	p->on_rq = TASK_ON_RQ_QUEUED;
> 	check_preempt_curr(rq, p, 0);
> @@ -2654,6 +2655,12 @@ static struct rq *finish_task_switch(struct task_struct
> *prev)
> 	 * to use.
> 	 */
> 	smp_mb__after_unlock_lock();
> +#ifdef CONFIG_SMP
> +	if (unlikely(rq->need_sync_core)) {
> +		sync_core_before_usermode();
> +		rq->need_sync_core = 0;
> +	}
> +#endif
> 	finish_lock_switch(rq, prev);
> 	finish_arch_post_lock_switch();
> 
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 3b448ba82225..e02cc362637c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -734,6 +734,7 @@ struct rq {
> 	/* For active balancing */
> 	int active_balance;
> 	int push_cpu;
> +	int need_sync_core;
> 	struct cpu_stop_work active_balance_work;
> 	/* cpu of this runqueue: */
> 	int cpu;
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
