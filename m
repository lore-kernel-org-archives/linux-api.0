From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 10:19:33 -0400 (EDT)
Message-ID: <1602066458.2029.1522246773927.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328111952.GS4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328111952.GS4043@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 7:19 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
>> +#ifdef CONFIG_RSEQ
>> +	struct rseq __user *rseq;
>> +	u32 rseq_len;
>> +	u32 rseq_sig;
>> +	/*
>> +	 * RmW on rseq_event_mask must be performed atomically
>> +	 * with respect to preemption.
>> +	 */
>> +	unsigned long rseq_event_mask;
>> +#endif
> 
>> +static inline void rseq_signal_deliver(struct pt_regs *regs)
>> +{
>> +	set_bit(RSEQ_EVENT_SIGNAL_BIT, &current->rseq_event_mask);
>> +	rseq_handle_notify_resume(regs);
>> +}
>> +
>> +static inline void rseq_preempt(struct task_struct *t)
>> +{
>> +	set_bit(RSEQ_EVENT_PREEMPT_BIT, &t->rseq_event_mask);
>> +	rseq_set_notify_resume(t);
>> +}
>> +
>> +static inline void rseq_migrate(struct task_struct *t)
>> +{
>> +	set_bit(RSEQ_EVENT_MIGRATE_BIT, &t->rseq_event_mask);
>> +	rseq_set_notify_resume(t);
>> +}
> 
> Given that comment above, do you really need the full atomic set bit?
> Isn't __set_bit() sufficient?

For each of rseq_signal_deliver, rseq_preempt, and rseq_migrate, we should
confirm that their callers guarantee preemption is disabled before
we can use __set_bit() in each of those functions.

Is that the case ? If so, we should also document the requirement
about preemption for each function.

AFAIU, rseq_migrate is only invoked from __set_task_cpu, which I *think*
always has preemption disabled. rseq_preempt() is called by the scheduler,
so this one is fine. On x86, rseq_signal_deliver is called from setup_rt_frame,
with preemption enabled.

So one approach would be to use __set_bit in both rseq_preempt and rseq_migrate,
but keep the atomic set_bit() in rseq_signal_deliver.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
