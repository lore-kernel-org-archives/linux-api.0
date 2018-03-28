From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 10:06:00 -0400 (EDT)
Message-ID: <777590253.2016.1522245960189.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328064703.56hsuicmikejg7np@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328064703.56hsuicmikejg7np@tardis>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 2:47 AM, Boqun Feng boqun.feng@gmail.com wrote:

> On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
> [...]
>> Changes since v11:
>> 
>> - Replace task struct rseq_preempt, rseq_signal, and rseq_migrate
>>   bool by u32 rseq_event_mask.
> [...]
>> @@ -979,6 +980,17 @@ struct task_struct {
>>  	unsigned long			numa_pages_migrated;
>>  #endif /* CONFIG_NUMA_BALANCING */
>>  
>> +#ifdef CONFIG_RSEQ
>> +	struct rseq __user *rseq;
>> +	u32 rseq_len;
>> +	u32 rseq_sig;
>> +	/*
>> +	 * RmW on rseq_event_mask must be performed atomically
>> +	 * with respect to preemption.
>> +	 */
>> +	unsigned long rseq_event_mask;
> 
> s/unsigned long/u32

good point, fixed.

> 
>> +#endif
>> +
>>  	struct tlbflush_unmap_batch	tlb_ubc;
>>  
>>  	struct rcu_head			rcu;
>> @@ -1688,4 +1700,110 @@ extern long sched_getaffinity(pid_t pid, struct cpumask
>> *mask);
>>  #define TASK_SIZE_OF(tsk)	TASK_SIZE
>>  #endif
>>  
> 
> [...]
> 
>> +
>> +static int rseq_ip_fixup(struct pt_regs *regs)
>> +{
>> +	unsigned long ip = instruction_pointer(regs), start_ip = 0,
>> +		post_commit_offset = 0, abort_ip = 0;
>> +	struct task_struct *t = current;
>> +	uint32_t cs_flags = 0;
>> +	bool in_rseq_cs = false;
> 
> This seems unnecessary? Because..
> 
>> +	int ret;
>> +
>> +	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
>> +			&cs_flags);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * Handle potentially not being within a critical section.
>> +	 * Unsigned comparison will be true when
>> +	 * ip >= start_ip, and when ip < start_ip + post_commit_offset.
>> +	 */
>> +	if (ip - start_ip < post_commit_offset)
>> +		in_rseq_cs = true;
>> +
>> +	/*
>> +	 * If not nested over a rseq critical section, restart is
>> +	 * useless. Clear the rseq_cs pointer and return.
>> +	 */
>> +	if (!in_rseq_cs)
>> +		return clear_rseq_cs(t);
> 
> we can write
> 
>	if (ip - start_ip >= post_commit_offset)
>		return clear_rseq_cs(t);

Good point. In a previous version, rseq_get_rseq_cs() had to conditionally
update in_rseq_cs, but it's not the case anymore, so your approach
indeed cleans up the code.

Thanks!

Mathieu

> 
> Regards,
> Boqun
> 
>> +	ret = rseq_need_restart(t, cs_flags);
>> +	if (ret <= 0)
>> +		return ret;
>> +	ret = clear_rseq_cs(t);
>> +	if (ret)
>> +		return ret;
>> +	trace_rseq_ip_fixup(ip, start_ip, post_commit_offset, abort_ip);
>> +	instruction_pointer_set(regs, (unsigned long)abort_ip);
>> +	return 0;
>> +}
>> +
> [...]

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
