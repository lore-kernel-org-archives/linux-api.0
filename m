From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system call
Date: Thu, 16 Nov 2017 20:14:48 +0100
Message-ID: <20171116191448.rmds347hwsyibipm@hirez.programming.kicks-ass.net>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171114200414.2188-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 03:03:51PM -0500, Mathieu Desnoyers wrote:
> +static bool rseq_update_cpu_id(struct task_struct *t)
> +{
> +	uint32_t cpu_id = raw_smp_processor_id();
> +
> +	if (__put_user(cpu_id, &t->rseq->cpu_id_start))
> +		return false;
> +	if (__put_user(cpu_id, &t->rseq->cpu_id))
> +		return false;

For LP64 this _could_ be a single 64bit store, right? It would save some
stac/clac noise on x86_64.

> +	trace_rseq_update(t);
> +	return true;
> +}

> +static bool rseq_get_rseq_cs(struct task_struct *t,

bool return value, but is used as a C int error value later (it works,
but is inconsistent).

> +		void __user **start_ip,
> +		unsigned long *post_commit_offset,
> +		void __user **abort_ip,
> +		uint32_t *cs_flags)

That's a fair amount of arguments, and I suppose that isn't a problem
because there's only the one callsite and it all gets inlined anyway.

> +{
> +	unsigned long ptr;
> +	struct rseq_cs __user *urseq_cs;
> +	struct rseq_cs rseq_cs;
> +	u32 __user *usig;
> +	u32 sig;
> +
> +	if (__get_user(ptr, &t->rseq->rseq_cs))
> +		return false;
> +	if (!ptr)
> +		return true;
> +	urseq_cs = (struct rseq_cs __user *)ptr;
> +	if (copy_from_user(&rseq_cs, urseq_cs, sizeof(rseq_cs)))
> +		return false;
> +	/*
> +	 * We need to clear rseq_cs upon entry into a signal handler
> +	 * nested on top of a rseq assembly block, so the signal handler
> +	 * will not be fixed up if itself interrupted by a nested signal
> +	 * handler or preempted.  We also need to clear rseq_cs if we
> +	 * preempt or deliver a signal on top of code outside of the
> +	 * rseq assembly block, to ensure that a following preemption or
> +	 * signal delivery will not try to perform a fixup needlessly.
> +	 */
> +	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
> +		return false;
> +	if (rseq_cs.version > 0)
> +		return false;

> +	*cs_flags = rseq_cs.flags;
> +	*start_ip = (void __user *)rseq_cs.start_ip;
> +	*post_commit_offset = (unsigned long)rseq_cs.post_commit_offset;
> +	*abort_ip = (void __user *)rseq_cs.abort_ip;

> +	usig = (u32 __user *)(rseq_cs.abort_ip - sizeof(u32));
> +	if (get_user(sig, usig))
> +		return false;

> +	if (current->rseq_sig != sig) {
> +		printk_ratelimited(KERN_WARNING
> +			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
> +			sig, current->rseq_sig, current->pid, usig);
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static int rseq_need_restart(struct task_struct *t, uint32_t cs_flags)
> +{
> +	bool need_restart = false;
> +	uint32_t flags;
> +
> +	/* Get thread flags. */
> +	if (__get_user(flags, &t->rseq->flags))
> +		return -EFAULT;
> +
> +	/* Take into account critical section flags. */
> +	flags |= cs_flags;
> +
> +	/*
> +	 * Restart on signal can only be inhibited when restart on
> +	 * preempt and restart on migrate are inhibited too. Otherwise,
> +	 * a preempted signal handler could fail to restart the prior
> +	 * execution context on sigreturn.
> +	 */
> +	if (flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL) {
> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))
> +			return -EINVAL;
> +		if (!(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +			return -EINVAL;
> +	}
> +	if (t->rseq_migrate
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))

That's a horrible code form, please put the && at the end of the
previous line and begin the next line aligned with the (, like:

	if (t->rseq_migrate &&
	    !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE))

Luckily you've already killed this code, but try and remember for a next
time ;-)

> +		need_restart = true;
> +	else if (t->rseq_preempt
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT))
> +		need_restart = true;
> +	else if (t->rseq_signal
> +			&& !(flags & RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL))
> +		need_restart = true;
> +
> +	t->rseq_preempt = false;
> +	t->rseq_signal = false;
> +	t->rseq_migrate = false;
> +	if (need_restart)
> +		return 1;
> +	return 0;
> +}
> +
> +static int rseq_ip_fixup(struct pt_regs *regs)
> +{
> +	struct task_struct *t = current;
> +	void __user *start_ip = NULL;
> +	unsigned long post_commit_offset = 0;
> +	void __user *abort_ip = NULL;
> +	uint32_t cs_flags = 0;
> +	int ret;

	unsigned long ip = instruction_pointer(regs);

> +
> +	ret = rseq_get_rseq_cs(t, &start_ip, &post_commit_offset, &abort_ip,
> +			&cs_flags);
	trace_rseq_ip_fixup((void __user *)ip,
> +		start_ip, post_commit_offset, abort_ip, ret);

Why trace here and not right before/after instruction_pointer_set()?

> +	if (!ret)
> +		return -EFAULT;
> +
> +	ret = rseq_need_restart(t, cs_flags);
> +	if (ret < 0)
> +		return -EFAULT;
> +	if (!ret)
> +		return 0;
> +	/*
> +	 * Handle potentially not being within a critical section.
> +	 * Unsigned comparison will be true when
> +	 * ip < start_ip (wrap-around to large values), and when
> +	 * ip >= start_ip + post_commit_offset.
> +	 */
> +	if ((unsigned long)instruction_pointer(regs) - (unsigned long)start_ip
> +			>= post_commit_offset)

	if ((unsigned long)(ip - start_ip) >= post_commit_offset)

> +		return 1;
> +
> +	instruction_pointer_set(regs, (unsigned long)abort_ip);

Since you only ever use abort_ip as unsigned long, why propagate this
"void __user *" all the way from rseq_get_rseq_cs() ? Save yourself some
typing and casts :-)

> +	return 1;
> +}
