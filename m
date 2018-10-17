From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH for 4.21 06/16] cpu_opv: Provide cpu_opv system call
 (v8)
Date: Wed, 17 Oct 2018 12:49:31 +0530
Message-ID: <20181017071931.GA18379@linux.vnet.ibm.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com>
 <20181010191936.7495-7-mathieu.desnoyers@efficios.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010191936.7495-7-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org


Hi Mathieu,

> +static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt,
> +		      struct cpu_opv_vaddr *vaddr_ptrs, int cpu)
> +{
> +	struct mm_struct *mm = current->mm;
> +	int ret;
> +
> +retry:
> +	if (cpu != raw_smp_processor_id()) {
> +		ret = push_task_to_cpu(current, cpu);
> +		if (ret)
> +			goto check_online;
> +	}
> +	down_read(&mm->mmap_sem);
> +	ret = vaddr_ptrs_check(vaddr_ptrs);
> +	if (ret)
> +		goto end;
> +	preempt_disable();
> +	if (cpu != smp_processor_id()) {
> +		preempt_enable();
> +		up_read(&mm->mmap_sem);
> +		goto retry;
> +	}

If we have a higher priority task/s either pinned to the cpu, dont we end up
in busy-looping till the task exits/sleeps?

> +	ret = __do_cpu_opv(cpuop, cpuopcnt);
> +	preempt_enable();
> +end:
> +	up_read(&mm->mmap_sem);
> +	return ret;
> +
> +check_online:
> +	/*
> +	 * push_task_to_cpu() returns -EINVAL if the requested cpu is not part
> +	 * of the current thread's cpus_allowed mask.
> +	 */
> +	if (ret == -EINVAL)
> +		return ret;
> +	get_online_cpus();
> +	if (cpu_online(cpu)) {
> +		put_online_cpus();
> +		goto retry;
> +	}
