From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for 4.16 04/10] membarrier: provide SHARED_EXPEDITED
 command (v2)
Date: Tue, 16 Jan 2018 19:02:25 +0000 (UTC)
Message-ID: <1577189631.3966.1516129345161.JavaMail.zimbra@efficios.com>
References: <20180115191104.12437-1-mathieu.desnoyers@efficios.com> <20180115191104.12437-5-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1801161915090.2366@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1801161915090.2366@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David
List-Id: linux-api@vger.kernel.org

----- On Jan 16, 2018, at 1:20 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Mon, 15 Jan 2018, Mathieu Desnoyers wrote:
>> +static int membarrier_shared_expedited(void)
>> +{
>> +	int cpu;
>> +	bool fallback = false;
>> +	cpumask_var_t tmpmask;
>> +
>> +	if (num_online_cpus() == 1)
>> +		return 0;
>> +
>> +	/*
>> +	 * Matches memory barriers around rq->curr modification in
>> +	 * scheduler.
>> +	 */
>> +	smp_mb();	/* system call entry is not a mb. */
>> +
>> +	/*
>> +	 * Expedited membarrier commands guarantee that they won't
>> +	 * block, hence the GFP_NOWAIT allocation flag and fallback
>> +	 * implementation.
>> +	 */
>> +	if (!zalloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
>> +		/* Fallback for OOM. */
>> +		fallback = true;
>> +	}
>> +
>> +	cpus_read_lock();
>> +	for_each_online_cpu(cpu) {
>> +		struct task_struct *p;
>> +
>> +		/*
>> +		 * Skipping the current CPU is OK even through we can be
>> +		 * migrated at any point. The current CPU, at the point
>> +		 * where we read raw_smp_processor_id(), is ensured to
>> +		 * be in program order with respect to the caller
>> +		 * thread. Therefore, we can skip this CPU from the
>> +		 * iteration.
>> +		 */
>> +		if (cpu == raw_smp_processor_id())
>> +			continue;
>> +		rcu_read_lock();
>> +		p = task_rcu_dereference(&cpu_rq(cpu)->curr);
>> +		if (p && p->mm && (atomic_read(&p->mm->membarrier_state) &
>> +				   MEMBARRIER_STATE_SHARED_EXPEDITED)) {
> 
> This does not make sense vs. the documentation:
> 
>> + * @MEMBARRIER_CMD_SHARED_EXPEDITED:
>> + *                          Execute a memory barrier on all running threads
>> + *                          part of a process which previously registered
>> + *                          with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.
> 
> This should say:
> 
>> + *                          Execute a memory barrier on all running threads
>> + *                          of all processes which previously registered
>> + *                          with MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED.

Good point, will fix.

> 
> And I really have to ask whether this should be named _GLOBAL_ instead of
> _SHARED_.
> 
> Hmm?

I agree with you that this behavior fits better a "global" definition
than a "shared" one, especially given that it does not target a specific
shared memory mapping. The main issue I have is due to the pre-existing
MEMBARRIER_CMD_SHARED introduced in Linux 4.3. That one should also have
been called "MEMBARRIER_CMD_GLOBAL" based on the current line of thoughts.

Do you envision a way to transition forward to a new "MEMBARRIER_CMD_GLOBAL" for
the currently existing MEMBARRIER_CMD_SHARED ?

Perhaps with a duplicated enum entry ?

enum membarrier_cmd {
        MEMBARRIER_CMD_QUERY                                    = 0,
        MEMBARRIER_CMD_SHARED                                   = (1 << 0), /* use MEMBARRIER_CMD_GLOBAL instead */
        MEMBARRIER_CMD_GLOBAL                                   = (1 << 0),
[...]
};

Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
