From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH for 4.16 04/10] membarrier: provide SHARED_EXPEDITED
 command (v2)
Date: Tue, 16 Jan 2018 19:20:33 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1801161915090.2366@nanos>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-5-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115191104.12437-5-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David Sehr <sehr@google.com>Linus Torvalds <to>
List-Id: linux-api@vger.kernel.org

On Mon, 15 Jan 2018, Mathieu Desnoyers wrote:
> +static int membarrier_shared_expedited(void)
> +{
> +	int cpu;
> +	bool fallback = false;
> +	cpumask_var_t tmpmask;
> +
> +	if (num_online_cpus() == 1)
> +		return 0;
> +
> +	/*
> +	 * Matches memory barriers around rq->curr modification in
> +	 * scheduler.
> +	 */
> +	smp_mb();	/* system call entry is not a mb. */
> +
> +	/*
> +	 * Expedited membarrier commands guarantee that they won't
> +	 * block, hence the GFP_NOWAIT allocation flag and fallback
> +	 * implementation.
> +	 */
> +	if (!zalloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
> +		/* Fallback for OOM. */
> +		fallback = true;
> +	}
> +
> +	cpus_read_lock();
> +	for_each_online_cpu(cpu) {
> +		struct task_struct *p;
> +
> +		/*
> +		 * Skipping the current CPU is OK even through we can be
> +		 * migrated at any point. The current CPU, at the point
> +		 * where we read raw_smp_processor_id(), is ensured to
> +		 * be in program order with respect to the caller
> +		 * thread. Therefore, we can skip this CPU from the
> +		 * iteration.
> +		 */
> +		if (cpu == raw_smp_processor_id())
> +			continue;
> +		rcu_read_lock();
> +		p = task_rcu_dereference(&cpu_rq(cpu)->curr);
> +		if (p && p->mm && (atomic_read(&p->mm->membarrier_state) &
> +				   MEMBARRIER_STATE_SHARED_EXPEDITED)) {

This does not make sense vs. the documentation:

> + * @MEMBARRIER_CMD_SHARED_EXPEDITED:
> + *                          Execute a memory barrier on all running threads
> + *                          part of a process which previously registered
> + *                          with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.

This should say:

> + *                          Execute a memory barrier on all running threads
> + *                          of all processes which previously registered
> + *                          with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.

And I really have to ask whether this should be named _GLOBAL_ instead of
_SHARED_.

Hmm?

Thanks,

	tglx
