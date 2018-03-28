From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 14:29:46 +0200
Message-ID: <20180328122946.GU4043@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
> +static int rseq_update_cpu_id(struct task_struct *t)
> +{
> +	uint32_t cpu_id = raw_smp_processor_id();

u32

> +
> +	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
> +		return -EFAULT;
> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +		return -EFAULT;
> +	trace_rseq_update(t);
> +	return 0;
> +}
> +
> +static int rseq_reset_rseq_cpu_id(struct task_struct *t)
> +{
> +	uint32_t cpu_id_start = 0, cpu_id = RSEQ_CPU_ID_UNINITIALIZED;

u32

> +
> +	/*
> +	 * Reset cpu_id_start to its initial state (0).
> +	 */
> +	if (__put_user(cpu_id_start, &t->rseq->cpu_id_start))
> +		return -EFAULT;
> +	/*
> +	 * Reset cpu_id to RSEQ_CPU_ID_UNINITIALIZED, so any user coming
> +	 * in after unregistration can figure out that rseq needs to be
> +	 * registered again.
> +	 */
> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int rseq_get_rseq_cs(struct task_struct *t,
> +			    unsigned long *start_ip,
> +			    unsigned long *post_commit_offset,
> +			    unsigned long *abort_ip,
> +			    uint32_t *cs_flags)
> +{
> +	struct rseq_cs __user *urseq_cs;
> +	struct rseq_cs rseq_cs;
> +	unsigned long ptr;
> +	u32 __user *usig;
> +	u32 sig;
> +	int ret;
> +
> +	ret = __get_user(ptr, &t->rseq->rseq_cs);
> +	if (ret)
> +		return ret;
> +	if (!ptr)
> +		return 0;
> +	urseq_cs = (struct rseq_cs __user *)ptr;
> +	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
> +		return -EFAULT;
> +	if (rseq_cs.version > 0)
> +		return -EINVAL;
> +
> +	/* Ensure that abort_ip is not in the critical section. */
> +	if (rseq_cs.abort_ip - rseq_cs.start_ip < rseq_cs.post_commit_offset)
> +		return -EINVAL;

The kernel will not crash if userspace messes that up right? So why do
we care to check?

> +
> +	*cs_flags = rseq_cs.flags;
> +	*start_ip = rseq_cs.start_ip;
> +	*post_commit_offset = rseq_cs.post_commit_offset;
> +	*abort_ip = rseq_cs.abort_ip;

Then this becomes a straight struct assignment.

> +
> +	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));
> +	ret = get_user(sig, usig);
> +	if (ret)
> +		return ret;
> +

> +	if (current->rseq_sig != sig) {
> +		printk_ratelimited(KERN_WARNING
> +			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
> +			sig, current->rseq_sig, current->pid, usig);
> +		return -EPERM;
> +	}

Is there any text that explains the thread model and possible attack
that this signature prevents? I failed to find any, which raises the
question, why is it there..

> +	return 0;
> +}
> +
> +static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)

u32

> +{
> +	uint32_t flags, event_mask;

u32

> +	int ret;
> +
> +	/* Get thread flags. */
> +	ret = __get_user(flags, &t->rseq->flags);
> +	if (ret)
> +		return ret;
> +
> +	/* Take critical section flags into account. */
> +	flags |= cs_flags;
> +
> +	/*
> +	 * Restart on signal can only be inhibited when restart on
> +	 * preempt and restart on migrate are inhibited too. Otherwise,
> +	 * a preempted signal handler could fail to restart the prior
> +	 * execution context on sigreturn.
> +	 */
> +	if (unlikely(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL)) {
> +		if ((flags & (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
> +		    | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT)) !=
> +		    (RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
> +		     | RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +			return -EINVAL;

Please put operators at the end of the previous line, not at the start
of the new line when you have to break statements.

Also, that's unreadable.

#define RSEQ_CS_FLAGS (RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT |	\
		       RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL  |	\
		       RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE)

	if (unlikely((flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) &&
	             (flags & RSEQ_CS_FLAGS) != RSEQ_CS_FLAGS))
		return -EINVAL;


> +	}
> +
> +	/*
> +	 * Load and clear event mask atomically with respect to
> +	 * scheduler preemption.
> +	 */
> +	preempt_disable();
> +	event_mask = t->rseq_event_mask;
> +	t->rseq_event_mask = 0;
> +	preempt_enable();
> +
> +	event_mask &= ~flags;
> +	if (event_mask)
> +		return 1;
> +	return 0;

	return !!(event_mask & ~flags);

> +}
> +
> +static int clear_rseq_cs(struct task_struct *t)
> +{
> +	unsigned long ptr = 0;
> +
> +	/*
> +	 * The rseq_cs field is set to NULL on preemption or signal
> +	 * delivery on top of rseq assembly block, as well as on top
> +	 * of code outside of the rseq assembly block. This performs
> +	 * a lazy clear of the rseq_cs field.
> +	 *
> +	 * Set rseq_cs to NULL with single-copy atomicity.
> +	 */
> +	return __put_user(ptr, &t->rseq->rseq_cs);

	__put_user(0UL, &t->rseq->rseq_cs); ?

> +}
> +
> +static int rseq_ip_fixup(struct pt_regs *regs)
> +{
> +	unsigned long ip = instruction_pointer(regs), start_ip = 0,
> +		post_commit_offset = 0, abort_ip = 0;

valid C, but yuck. Just have two 'unsigned long' lines.

Also, why the =0, the below call to rseq_get_rseq_cs() will either
initialize of fail.

> +	struct task_struct *t = current;
> +	uint32_t cs_flags = 0;

u32

> +	bool in_rseq_cs = false;
> +	int ret;
> +
> +	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
> +			&cs_flags);

	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset,
			       &abort_ip, &cs_flags);


> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Handle potentially not being within a critical section.
> +	 * Unsigned comparison will be true when
> +	 * ip >= start_ip, and when ip < start_ip + post_commit_offset.
> +	 */
> +	if (ip - start_ip < post_commit_offset)
> +		in_rseq_cs = true;
> +
> +	/*
> +	 * If not nested over a rseq critical section, restart is
> +	 * useless. Clear the rseq_cs pointer and return.
> +	 */
> +	if (!in_rseq_cs)
> +		return clear_rseq_cs(t);


That all seems needlessly complicated; isn't:

	if (ip - start_ip >= post_commit_offset)
		return clear_rseq_cs();

equivalent? Nothing seems to use that variable after this.

> +	ret = rseq_need_restart(t, cs_flags);
> +	if (ret <= 0)
> +		return ret;
> +	ret = clear_rseq_cs(t);
> +	if (ret)
> +		return ret;
> +	trace_rseq_ip_fixup(ip, start_ip, post_commit_offset, abort_ip);
> +	instruction_pointer_set(regs, (unsigned long)abort_ip);
> +	return 0;
> +}
