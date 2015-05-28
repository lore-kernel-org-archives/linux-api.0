From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Thu, 28 May 2015 16:38:45 -0400
Message-ID: <55677CD5.7050408@ezchip.com>
References: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com> <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com> <alpine.DEB.2.11.1505152337170.4225@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1505152337170.4225@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Thomas, thanks for the feedback.  My reply was delayed by being in meetings
all last week and then catching up this week - sorry about that.

On 05/15/2015 06:17 PM, Thomas Gleixner wrote:
> On Fri, 15 May 2015, Chris Metcalf wrote:
>> +/*
>> + * We normally return immediately to userspace.
>> + *
>> + * In "cpu_isolated" mode we wait until no more interrupts are
>> + * pending.  Otherwise we nap with interrupts enabled and wait for the
>> + * next interrupt to fire, then loop back and retry.
>> + *
>> + * Note that if you schedule two "cpu_isolated" processes on the same
>> + * core, neither will ever leave the kernel, and one will have to be
>> + * killed manually.
> And why are we not preventing that situation in the first place? The
> scheduler should be able to figure that out easily..

This is an interesting observation.  My instinct is that adding tests in the
scheduler costs time on a hot path for all processes, and I'm trying to
avoid adding cost where we don't need it.  It's pretty much a straight-up
application bug if two threads or processes explicitly request the
cpu_isolated semantics, and then explicitly schedule themselves onto
the same core, so my preference was to let the application writer
identify and fix the problem if it comes up.

However, I'm certainly open to thinking about checking for this failure
mode in the scheduler, though I don't know enough about the
scheduler to immediately identify where such a change might go.
Would it be appropriate to think about this as a follow-on patch, if it's
determined that the cost of testing for this condition is worth it?

>> +  Otherwise in situations where another process is
>> + * in the runqueue on this cpu, this task will just wait for that
>> + * other task to go idle before returning to user space.
>> + */
>> +void tick_nohz_cpu_isolated_enter(void)
>> +{
>> +	struct clock_event_device *dev =
>> +		__this_cpu_read(tick_cpu_device.evtdev);
>> +	struct task_struct *task = current;
>> +	unsigned long start = jiffies;
>> +	bool warned = false;
>> +
>> +	/* Drain the pagevecs to avoid unnecessary IPI flushes later. */
>> +	lru_add_drain();
>> +
>> +	while (ACCESS_ONCE(dev->next_event.tv64) != KTIME_MAX) {
> What's the ACCESS_ONCE for?

We are technically in a loop here where we are waiting for an
interrupt handler to update dev->next_event.tv64, so I felt it was
appropriate to flag it as such.  If we didn't have function calls inside
the loop, the compiler would eliminate the loop.

But it's just a style thing, and we can certainly drop it if it seems
confusing.  In any case I've changed it to READ_ONCE() since
that's preferred now anyway; this code was originally written
a while ago.

>> +		if (!warned && (jiffies - start) >= (5 * HZ)) {
>> +			pr_warn("%s/%d: cpu %d: cpu_isolated task blocked for %ld jiffies\n",
>> +				task->comm, task->pid, smp_processor_id(),
>> +				(jiffies - start));
> What additional value has the jiffies delta over a plain human
> readable '5sec' ?

Good point.  I've changed it to emit a value in seconds.

>> +			warned = true;
>> +		}
>> +		if (should_resched())
>> +			schedule();
>> +		if (test_thread_flag(TIF_SIGPENDING))
>> +			break;
>> +
>> +		/* Idle with interrupts enabled and wait for the tick. */
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		arch_cpu_idle();
> Oh NO! Not another variant of fake idle task. The idle implementations
> can call into code which rightfully expects that the CPU is actually
> IDLE.
>
> I wasted enough time already debugging the resulting wreckage. Feel
> free to use it for experimental purposes, but this is not going
> anywhere near to a mainline kernel.
>
> I completely understand WHY you want to do that, but we need proper
> mechanisms for that and not some duct tape engineering band aids which
> will create hard to debug side effects.

Yes, I worried about that a little when I put it in.  In particular it's
certainly true that arch_cpu_idle() isn't necessarily designed to
behave properly in this context, even if it may do the right thing
somewhat by accident.

In fact, we don't need the cpu-idling semantics in this loop;
the loop can spin quite happily waiting for next_event in the
tick_cpu_device to stop being defined (or a signal or scheduling
request to occur).  I've changed the code to make it opt-in, so
that a weak no-op function that just calls cpu_relax() can be
replaced by an architecture-defined function that safely waits
until an interrupt is delivered, reducing the number of times we
spin around in the outer loop.

> Hint: It's a scheduler job to make sure that the machine has quiesced
>        _BEFORE_ letting the magic task off to user land.

This is not so clear to me.  There may, for example, be RCU events
that occur after the scheduler is done with its part, that still require
another timer tick on the cpu to finish quiescing RCU.  I think we
need to check for the timer-quiesced state as late as possible to
handle things like this.

Arguably the scheduler could also try to do the right thing with
a cpu_isolated task, but again, this feels like time spent in the
scheduler hot path that affects the non-cpu_isolated tasks.  For
cpu_isolated tasks they should be the only thing that's runnable
on the core 99.999% of the time, or you've done something quite
wrong anyway.

>> +		set_current_state(TASK_RUNNING);
>> +	}
>> +	if (warned) {
>> +		pr_warn("%s/%d: cpu %d: cpu_isolated task unblocked after %ld jiffies\n",
>> +			task->comm, task->pid, smp_processor_id(),
>> +			(jiffies - start));
>> +		dump_stack();
> And that dump_stack() tells us which important information?
>
>      	 tick_nohz_cpu_isolated_enter
> 	 context_tracking_enter
> 	 context_tracking_user_enter
> 	 arch_return_to_user_code

For tile, the dump_stack() includes the register state, which includes
the interrupt type that took us into the kernel, which might be helpful.
That said, I'm certainly willing to remove it, or make it call a weak
no-op function where architectures can add more info if they have it.

Thanks again!  I'll put out v3 of the patch series shortly, with changes
from your comments incorporated.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
