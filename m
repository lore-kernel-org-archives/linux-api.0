From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH for 4.21 03/16] sched: Implement push_task_to_cpu (v2)
Date: Wed, 17 Oct 2018 12:21:45 +0530
Message-ID: <20181017065145.GA7111@linux.vnet.ibm.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-4-mathieu.desnoyers@efficios.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010191936.7495-4-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
> +{

In your use case, is the task going to be current?
If yes, we should simply be using migrate_task_to.

> +	struct rq_flags rf;
> +	struct rq *rq;
> +	int ret = 0;
> +
> +	rq = task_rq_lock(p, &rf);
> +	update_rq_clock(rq);
> +
> +	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Ideally we should have checked cpus_allowed/cpu_active_mask before taking
the lock. This would help reduce the contention on the rqlock when the
passed parameter is not correct.

> +
> +	if (!cpumask_test_cpu(dest_cpu, cpu_active_mask)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (task_cpu(p) == dest_cpu)
> +		goto out;

Same as above.

> +
> +	if (task_running(rq, p) || p->state == TASK_WAKING) {

Why are we using migration thread to move a task in TASK_WAKING state?

> +		struct migration_arg arg = { p, dest_cpu };
> +		/* Need help from migration thread: drop lock and wait. */
> +		task_rq_unlock(rq, p, &rf);
> +		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
> +		tlb_migrate_finish(p->mm);
> +		return 0;

Why cant we use migrate_task_to instead?

> +	} else if (task_on_rq_queued(p)) {
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 455fa330de04..27ad25780204 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1340,6 +1340,15 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
>  #endif
>  }
>  
> +#ifdef CONFIG_SMP
> +int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu);
> +#else
> +static inline int push_task_to_cpu(struct task_struct *p, unsigned int dest_cpu)
> +{
> +	return 0;
> +}
> +#endif
> +

Your usecase is outside kernel/sched. So I am not sure if this is the right
place for the declaration.
