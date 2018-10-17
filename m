From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 03/16] sched: Implement push_task_to_cpu
 (v2)
Date: Wed, 17 Oct 2018 11:09:49 -0400 (EDT)
Message-ID: <704369944.814.1539788989963.JavaMail.zimbra@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com> <20181010191936.7495-4-mathieu.desnoyers@efficios.com> <20181017065145.GA7111@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017065145.GA7111@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Oct 17, 2018, at 2:51 AM, Srikar Dronamraju srikar@linux.vnet.ibm.com wrote:

> Hi Mathieu,
> 
>> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
>> +{
> 
> In your use case, is the task going to be current?
> If yes, we should simply be using migrate_task_to.
> 
>> +	struct rq_flags rf;
>> +	struct rq *rq;
>> +	int ret = 0;
>> +
>> +	rq = task_rq_lock(p, &rf);
>> +	update_rq_clock(rq);
>> +
>> +	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
> 
> Ideally we should have checked cpus_allowed/cpu_active_mask before taking
> the lock. This would help reduce the contention on the rqlock when the
> passed parameter is not correct.
> 
>> +
>> +	if (!cpumask_test_cpu(dest_cpu, cpu_active_mask)) {
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	if (task_cpu(p) == dest_cpu)
>> +		goto out;
> 
> Same as above.
> 
>> +
>> +	if (task_running(rq, p) || p->state == TASK_WAKING) {
> 
> Why are we using migration thread to move a task in TASK_WAKING state?
> 
>> +		struct migration_arg arg = { p, dest_cpu };
>> +		/* Need help from migration thread: drop lock and wait. */
>> +		task_rq_unlock(rq, p, &rf);
>> +		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>> +		tlb_migrate_finish(p->mm);
>> +		return 0;
> 
> Why cant we use migrate_task_to instead?

I could do that be moving migrate_task_to outside of NUMA-specific #ifdef,
but I think we can do much, much simpler than that, see below.

> 
>> +	} else if (task_on_rq_queued(p)) {
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 455fa330de04..27ad25780204 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -1340,6 +1340,15 @@ static inline void __set_task_cpu(struct task_struct *p,
>> unsigned int cpu)
>>  #endif
>>  }
>>  
>> +#ifdef CONFIG_SMP
>> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu);
>> +#else
>> +static inline int push_task_to_cpu(struct task_struct *p, unsigned int
>> dest_cpu)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
> 
> Your usecase is outside kernel/sched. So I am not sure if this is the right
> place for the declaration.

Actually, now that I think of it, we may not need to migrate the task at all.
Now that cpu_opv implementation takes a temporary vmap() of the user-space pages,
we can touch that virtual address range from interrupt context from another CPU.

So cpu_opv can simply execute the vector of operations in IPI context rather than
do all this silly dance with migration.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
