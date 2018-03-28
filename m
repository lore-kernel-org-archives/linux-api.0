From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 12:19:05 -0400 (EDT)
Message-ID: <1976612894.96.1522253945890.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328122946.GU4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328122946.GU4043@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 8:29 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:

[...]

>> +	/* Ensure that abort_ip is not in the critical section. */
>> +	if (rseq_cs.abort_ip - rseq_cs.start_ip < rseq_cs.post_commit_offset)
>> +		return -EINVAL;
> 
> The kernel will not crash if userspace messes that up right? So why do
> we care to check?

That's because the kernel clears the TLS @rseq_cs pointer whenever it restarts
a rseq critical section. Therefore, if the abort_ip points somewhere within
the rseq critical section, the kernel will clear the @rseq_cs pointer, move the
instruction pointer to the abort_ip, and return to user-space. At that stage,
user-space will still be running within a rseq critical section, but the
@rseq_cs pointer is NULL. So if the kernel preempts again before that critical
section completes, it will completely miss it.

So having the kernel segfault userspace when this pattern is encountered
is an extra safety net ensuring that if user-space ever implement such
construct, at least it will segfault quickly, and will therefore be easier
to debug, because easier to reproduce.

>> +
>> +	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));
>> +	ret = get_user(sig, usig);
>> +	if (ret)
>> +		return ret;
>> +
> 
>> +	if (current->rseq_sig != sig) {
>> +		printk_ratelimited(KERN_WARNING
>> +			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x
>> (pid=%d, addr=%p).\n",
>> +			sig, current->rseq_sig, current->pid, usig);
>> +		return -EPERM;
>> +	}
> 
> Is there any text that explains the thread model and possible attack
> that this signature prevents? I failed to find any, which raises the
> question, why is it there..

The threat model is an attacker partly controlling a user-space process, trying
to execute his own code by abusing the rseq restart mechanism to make the kernel
jump to a user-space address of his choice, which contains either an injected shell
code or specific library functions, thus escalating to full control of the process
execution.

Where should I document this ?

> 
>> +	int ret;
>> +
>> +	/* Get thread flags. */
>> +	ret = __get_user(flags, &t->rseq->flags);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Take critical section flags into account. */
>> +	flags |= cs_flags;
>> +
>> +	/*
>> +	 * Restart on signal can only be inhibited when restart on
>> +	 * preempt and restart on migrate are inhibited too. Otherwise,
>> +	 * a preempted signal handler could fail to restart the prior
>> +	 * execution context on sigreturn.
>> +	 */
>> +	if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
>> +		if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
>> +		    | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
>> +		    (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
>> +		     | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
>> +			return -EINVAL;
> 
> Please put operators at the end of the previous line, not at the start
> of the new line when you have to break statements.
> 
> Also, that's unreadable.
> 
> #define RSEQ_CS_FLAGS (RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT |	\
>		       RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL  |	\
>		       RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE)
> 
>	if (unlikely((flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) &&
>	             (flags & RSEQ_CS_FLAGS) != RSEQ_CS_FLAGS))
>		return -EINVAL;
> 

Based on your suggestion:

#define RSEQ_CS_PREEMPT_MIGRATE_FLAGS (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE |     \
                                       RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)

        if (unlikely((flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) &&
                     (flags & RSEQ_CS_PREEMPT_MIGRATE_FLAGS) !=
                     RSEQ_CS_PREEMPT_MIGRATE_FLAGS))
                return -EINVAL;


>> +}
>> +
>> +static int clear_rseq_cs(struct task_struct *t)
>> +{
>> +	unsigned long ptr = 0;
>> +
>> +	/*
>> +	 * The rseq_cs field is set to NULL on preemption or signal
>> +	 * delivery on top of rseq assembly block, as well as on top
>> +	 * of code outside of the rseq assembly block. This performs
>> +	 * a lazy clear of the rseq_cs field.
>> +	 *
>> +	 * Set rseq_cs to NULL with single-copy atomicity.
>> +	 */
>> +	return __put_user(ptr, &t->rseq->rseq_cs);
> 
>	__put_user(0UL, &t->rseq->rseq_cs); ?

Yes.

> 
>> +}
>> +
>> +static int rseq_ip_fixup(struct pt_regs *regs)
>> +{
>> +	unsigned long ip = instruction_pointer(regs), start_ip = 0,
>> +		post_commit_offset = 0, abort_ip = 0;
> 
> valid C, but yuck. Just have two 'unsigned long' lines.
> 
> Also, why the =0, the below call to rseq_get_rseq_cs() will either
> initialize of fail.

rseq_get_rseq_cs() can return 0 (success) if __get_user finds a
NULL pointer in the @rseq_cs TLS field. I'll use a
struct rseq_cs * parameter instead, and memset to 0 only in that
specific success case within rseq_get_rseq_cs() rather than always
initialize to 0 in its caller.

> 
> 
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
> 
> That all seems needlessly complicated; isn't:
> 
>	if (ip - start_ip >= post_commit_offset)
>		return clear_rseq_cs();
> 
> equivalent? Nothing seems to use that variable after this.

Yep, Boqun already pointed it out. Fixed.

Thanks!

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
