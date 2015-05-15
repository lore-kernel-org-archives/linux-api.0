From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Sat, 16 May 2015 00:17:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505152337170.4225@nanos>
References: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com> <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431725251-20943-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 15 May 2015, Chris Metcalf wrote:
> +/*
> + * We normally return immediately to userspace.
> + *
> + * In "cpu_isolated" mode we wait until no more interrupts are
> + * pending.  Otherwise we nap with interrupts enabled and wait for the
> + * next interrupt to fire, then loop back and retry.
> + *
> + * Note that if you schedule two "cpu_isolated" processes on the same
> + * core, neither will ever leave the kernel, and one will have to be
> + * killed manually.

And why are we not preventing that situation in the first place? The
scheduler should be able to figure that out easily..

> +  Otherwise in situations where another process is
> + * in the runqueue on this cpu, this task will just wait for that
> + * other task to go idle before returning to user space.
> + */
> +void tick_nohz_cpu_isolated_enter(void)
> +{
> +	struct clock_event_device *dev =
> +		__this_cpu_read(tick_cpu_device.evtdev);
> +	struct task_struct *task = current;
> +	unsigned long start = jiffies;
> +	bool warned = false;
> +
> +	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
> +	lru_add_drain();
> +
> +	while (ACCESS_ONCE(dev->next_event.tv64) != KTIME_MAX) {

What's the ACCESS_ONCE for?

> +		if (!warned && (jiffies - start) >= (5 * HZ)) {
> +			pr_warn("%s/%d: cpu %d: cpu_isolated task blocked for %ld jiffies\n",
> +				task->comm, task->pid, smp_processor_id(),
> +				(jiffies - start));

What additional value has the jiffies delta over a plain human
readable '5sec' ?

> +			warned = true;
> +		}
> +		if (should_resched())
> +			schedule();
> +		if (test_thread_flag(TIF_SIGPENDING))
> +			break;
> +
> +		/* Idle with interrupts enabled and wait for the tick. */
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		arch_cpu_idle();

Oh NO! Not another variant of fake idle task. The idle implementations
can call into code which rightfully expects that the CPU is actually
IDLE.

I wasted enough time already debugging the resulting wreckage. Feel
free to use it for experimental purposes, but this is not going
anywhere near to a mainline kernel.

I completely understand WHY you want to do that, but we need proper
mechanisms for that and not some duct tape engineering band aids which
will create hard to debug side effects.

Hint: It's a scheduler job to make sure that the machine has quiesced
      _BEFORE_ letting the magic task off to user land.

> +		set_current_state(TASK_RUNNING);
> +	}
> +	if (warned) {
> +		pr_warn("%s/%d: cpu %d: cpu_isolated task unblocked after %ld jiffies\n",
> +			task->comm, task->pid, smp_processor_id(),
> +			(jiffies - start));
> +		dump_stack();

And that dump_stack() tells us which important information?

    	 tick_nohz_cpu_isolated_enter
	 context_tracking_enter
	 context_tracking_user_enter
	 arch_return_to_user_code

Thanks,

	tglx
