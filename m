From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 13:19:52 +0200
Message-ID: <20180328111952.GS4043@hirez.programming.kicks-ass.net>
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
> +#ifdef CONFIG_RSEQ
> +	struct rseq __user *rseq;
> +	u32 rseq_len;
> +	u32 rseq_sig;
> +	/*
> +	 * RmW on rseq_event_mask must be performed atomically
> +	 * with respect to preemption.
> +	 */
> +	unsigned long rseq_event_mask;
> +#endif

> +static inline void rseq_signal_deliver(struct pt_regs *regs)
> +{
> +	set_bit(RSEQ_EVENT_SIGNAL_BIT, &current->rseq_event_mask);
> +	rseq_handle_notify_resume(regs);
> +}
> +
> +static inline void rseq_preempt(struct task_struct *t)
> +{
> +	set_bit(RSEQ_EVENT_PREEMPT_BIT, &t->rseq_event_mask);
> +	rseq_set_notify_resume(t);
> +}
> +
> +static inline void rseq_migrate(struct task_struct *t)
> +{
> +	set_bit(RSEQ_EVENT_MIGRATE_BIT, &t->rseq_event_mask);
> +	rseq_set_notify_resume(t);
> +}

Given that comment above, do you really need the full atomic set bit?
Isn't __set_bit() sufficient?
