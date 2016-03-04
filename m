From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 4 Mar 2016 13:56:05 +0100
Message-ID: <20160304125603.GA23906@lerouge>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge>
 <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge>
 <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge>
 <56BCDFE9.10200@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56BCDFE9.10200@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 11, 2016 at 02:24:25PM -0500, Chris Metcalf wrote:
> On 01/30/2016 04:11 PM, Frederic Weisbecker wrote:
> >We have reverted the patch that made isolcpus |= nohz_full. Too
> >many people complained about unusable machines with NO_HZ_FULL_ALL
> >
> >But the user can still set that parameter manually.
> 
> Yes.  What I was suggesting is that if the user specifies task_isolation=X-Y
> we should add cpus X-Y to both the nohz_full set and the isolcpus set.
> I've changed it to work that way for the v10 patch series.

Ok.

> 
> 
> >>>>>>+bool _task_isolation_ready(void)
> >>>>>>+{
> >>>>>>+	WARN_ON_ONCE(!irqs_disabled());
> >>>>>>+
> >>>>>>+	/* If we need to drain the LRU cache, we're not ready. */
> >>>>>>+	if (lru_add_drain_needed(smp_processor_id()))
> >>>>>>+		return false;
> >>>>>>+
> >>>>>>+	/* If vmstats need updating, we're not ready. */
> >>>>>>+	if (!vmstat_idle())
> >>>>>>+		return false;
> >>>>>>+
> >>>>>>+	/* Request rescheduling unless we are in full dynticks mode. */
> >>>>>>+	if (!tick_nohz_tick_stopped()) {
> >>>>>>+		set_tsk_need_resched(current);
> >>>>>I'm not sure doing this will help getting the tick to get stopped.
> >>>>Well, I don't know that there is anything else we CAN do, right?  If there's
> >>>>another task that can run, great - it may be that that's why full dynticks
> >>>>isn't happening yet.  Or, it might be that we're waiting for an RCU tick and
> >>>>there's nothing else we can do, in which case we basically spend our time
> >>>>going around through the scheduler code and back out to the
> >>>>task_isolation_ready() test, but again, there's really nothing else more
> >>>>useful we can be doing at this point.  Once the RCU tick fires (or whatever
> >>>>it was that was preventing full dynticks from engaging), we will pass this
> >>>>test and return to user space.
> >>>There is nothing at all you can do and setting TIF_RESCHED won't help either.
> >>>If there is another task that can run, the scheduler takes care of resched
> >>>by itself :-)
> >>The problem is that the scheduler will only take care of resched at a
> >>later time, typically when we get a timer interrupt later.
> >When a task is enqueued, the scheduler sets TIF_RESCHED on the target. If the
> >target is remote it sends an IPI, if it's local then we wait the next reschedule
> >point (preemption points, voluntary reschedule, interrupts). There is just nothing
> >you can do to accelerate that.
> 
> But that's exactly what I'm saying.  If we're sitting in a loop here waiting
> for some short-lived process (maybe kernel thread) to run and get out of
> the way, we don't want to just spin sitting in prepare_exit_to_usermode().
> We want to call schedule(), get the short-lived process to run, then when
> it calls schedule() again, we're back in prepare_exit_to_usermode but now
> we can return to userspace.

Maybe, although I think returning to userspace with -EAGAIN or -EBUSY, something like
that would be better so that userspace retries a bit later with prctl. Otherwise we may
well be waiting for ever in kernelmode.

> 
> We don't want to wait for preemption points or interrupts, and there are
> no other voluntary reschedules in the prepare_exit_to_usermode() loop.
> 
> If the other task had been woken up for some completion, then yes we would
> already have had TIF_RESCHED set, but if the other runnable task was (for
> example) pre-empted on a timer tick, we wouldn't have TIF_RESCHED set at
> this point, and thus we might need to call schedule() explicitly.

There can't be another task in the runqueue waiting to be preempted since
we (the current task) are running on the CPU.

Besides, if we aren't alone in the runqueue, this breaks the task isolation
mode.

> 
> Note that the prepare_exit_to_usermode() loop is exactly the point at
> which we normally call schedule() if we are in syscall exit, so we are
> just encouraging that schedule() to happen if otherwise it might not.
> 
> >>By invoking the scheduler here, we allow any tasks that are ready to run to run
> >>immediately, rather than waiting for an interrupt to wake the scheduler.
> >Well, in this case here we are interested in the current CPU. And if a task
> >got awoken and waits for the current CPU, it will have an opportunity to get
> >schedule on syscall exit.
> 
> That's true if TIF_RESCHED was set because a completion occurred that
> the other task was waiting for.  But there might not be any such completion
> and the task just got preempted earlier and is still ready to run.

But if another task waits for the CPU, this break task isolation mode. Now
assuming we want a pending task to resume such that we get the CPU for ourself,
we have no idea if the scheduler is going to schedule that task, it depends on
vruntime and other things. TIF_RESCHED only make entering the scheduler, it doesn't
guarantee any context switch.

> My point is that setting TIF_RESCHED is never harmful, and there are
> cases like involuntary preemption where it might help.

Sure but we don't write code just because it doesn't harm. Strange code hurts
the brain of reviewers.

Now concerning involuntary preemption, it's a matter of a millisecond, userspace
needs to wait a few millisecond before retrying anyway. Sleeping at that point is
what can be useful as we leave the CPU for the resuming task.

Also if we have any task on the runqueue anyway, whether we hope that it resumes quickly
or not, it's a very bad sign for a task isolation session. Either we did not affine tasks
correctly or there is a kernel thread that might run again at some time ahead.

> 
> >>Plenty of places in the kernel just call schedule() directly when they are
> >>waiting.  Since we're waiting here regardless, we might as well
> >>immediately get any other runnable tasks dealt with.
> >>
> >>We could also just return "false" in _task_isolation_ready(), and then
> >>check tick_nohz_tick_stopped() in _task_isolation_enter() and if false,
> >>call schedule() explicitly there, but that seems a little more roundabout.
> >>Admittedly it's more usual to see kernel code call schedule() directly
> >>to yield the processor, but in this case I'm not convinced it's cleaner
> >>given we're already in a loop where the caller is checking TIF_RESCHED
> >>and then calling schedule() when it's set.
> >You could call cond_resched(), but really syscall exit is enough for what
> >you want. And the problem here if a task prevents the CPU from stopping the
> >tick is that task itself, not the fact it doesn't get scheduled.
> 
> True, although in that case we just need to wait (e.g. for an RCU tick
> to occur to quiesce); we could spin, but spinning through the scheduler
> seems no better or worse in that case then just spinning with
> interrupts enabled in a loop.  And (as I said above) it could help.

Lets just leave that waiting to userspace. Just sleep a few milliseconds.

> 
> >If we have
> >other tasks than the current isolated one on the CPU, it means that the
> >environment is not ready for hard isolation.
> 
> Right.  But the model is that in that case, the task that wants hard
> isolation is just going to have to wait to return to userspace.

I think we shouldn't do that wait for isolation on the kernel.

> 
> 
> >And in general: we shouldn't loop at all there: if something depends on the tick,
> >the CPU is not ready for isolation and something needs to be done: setting
> >some task affinity, etc... So we should just fail the prctl and let the user
> >deal with it.
> 
> So there are potentially two cases here:
> 
> (1) When we initially do the prctl(), should we check to see if there are
> other schedulable tasks, etc., and fail the prctl() if so?  You could make a
> case for this, but I think in practice userspace would just end up looping
> back to retry the prctl if we created that semantic in the kernel.

That sounds saner to me. And if we still fail after one second, then just give up.
In fact if it doesn't work on the first time, that's a bad sign like I said above.
The task that is running on the CPU may well come again later. Some pre-conditons
are not met.

> 
> (2) What about times when we are leaving the kernel after already
> doing the prctl()?  For example a core doing packet forwarding might
> want to report some error condition up to the kernel, and remove itself
> from the set of cores handling packets, then do some syscall(s) to generate
> logging data, and then go back and continue handling packets.  Or, the
> process might have created some large anonymous mapping where
> every now and then it needs to cross a page boundary for some structure
> and touch a new page, and it knows to expect a page fault in that case.
> In those cases we are returning from the kernel, not at prctl() time, and
> we still want to enforce the semantics that no further interrupts will
> occur to disturb the task.  These kinds of use cases are why we have
> as general-purpose a mechanism as we do for task isolation.

If any interrupt or any kind of disturbance happens, we should leave that
task isolation mode and warn the isolated task about that. SIGTERM?

Thanks.
