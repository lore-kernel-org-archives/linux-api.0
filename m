From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Sat, 30 Jan 2016 22:11:27 +0100
Message-ID: <20160130211125.GB7856@lerouge>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge>
 <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge>
 <56ABACDD.5090500@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56ABACDD.5090500-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 29, 2016 at 01:18:05PM -0500, Chris Metcalf wrote:
> On 01/27/2016 07:28 PM, Frederic Weisbecker wrote:
> >On Tue, Jan 19, 2016 at 03:45:04PM -0500, Chris Metcalf wrote:
> >>You asked what happens if nohz_full= is given as well, which is a very
> >>good question.  Perhaps the right answer is to have an early_initcall
> >>that suppresses task isolation on any cores that lost their nohz_full
> >>or isolcpus status due to later boot command line arguments (and
> >>generate a console warning, obviously).
> >I'd rather imagine that the final nohz full cpumask is "nohz_full=" | "task_isolation="
> >That's the easiest way to deal with and both nohz and task isolation can call
> >a common initializer that takes care of the allocation and add the cpus to the mask.
> 
> I like it!
> 
> And by the same token, the final isolcpus cpumask is "isolcpus=" |
> "task_isolation="?
> That seems like we'd want to do it to keep things parallel.

We have reverted the patch that made isolcpus |= nohz_full. Too
many people complained about unusable machines with NO_HZ_FULL_ALL

But the user can still set that parameter manually.

> 
> >>>>+bool _task_isolation_ready(void)
> >>>>+{
> >>>>+	WARN_ON_ONCE(!irqs_disabled());
> >>>>+
> >>>>+	/* If we need to drain the LRU cache, we're not ready. */
> >>>>+	if (lru_add_drain_needed(smp_processor_id()))
> >>>>+		return false;
> >>>>+
> >>>>+	/* If vmstats need updating, we're not ready. */
> >>>>+	if (!vmstat_idle())
> >>>>+		return false;
> >>>>+
> >>>>+	/* Request rescheduling unless we are in full dynticks mode. */
> >>>>+	if (!tick_nohz_tick_stopped()) {
> >>>>+		set_tsk_need_resched(current);
> >>>I'm not sure doing this will help getting the tick to get stopped.
> >>Well, I don't know that there is anything else we CAN do, right?  If there's
> >>another task that can run, great - it may be that that's why full dynticks
> >>isn't happening yet.  Or, it might be that we're waiting for an RCU tick and
> >>there's nothing else we can do, in which case we basically spend our time
> >>going around through the scheduler code and back out to the
> >>task_isolation_ready() test, but again, there's really nothing else more
> >>useful we can be doing at this point.  Once the RCU tick fires (or whatever
> >>it was that was preventing full dynticks from engaging), we will pass this
> >>test and return to user space.
> >There is nothing at all you can do and setting TIF_RESCHED won't help either.
> >If there is another task that can run, the scheduler takes care of resched
> >by itself :-)
> 
> The problem is that the scheduler will only take care of resched at a
> later time, typically when we get a timer interrupt later.

When a task is enqueued, the scheduler sets TIF_RESCHED on the target. If the
target is remote it sends an IPI, if it's local then we wait the next reschedule
point (preemption points, voluntary reschedule, interrupts). There is just nothing
you can do to accelerate that.


> By invoking the scheduler here, we allow any tasks that are ready to run to run
> immediately, rather than waiting for an interrupt to wake the scheduler.

Well, in this case here we are interested in the current CPU. And if a task
got awoken and waits for the current CPU, it will have an opportunity to get
schedule on syscall exit.

> Plenty of places in the kernel just call schedule() directly when they are
> waiting.  Since we're waiting here regardless, we might as well
> immediately get any other runnable tasks dealt with.
> 
> We could also just return "false" in _task_isolation_ready(), and then
> check tick_nohz_tick_stopped() in _task_isolation_enter() and if false,
> call schedule() explicitly there, but that seems a little more roundabout.
> Admittedly it's more usual to see kernel code call schedule() directly
> to yield the processor, but in this case I'm not convinced it's cleaner
> given we're already in a loop where the caller is checking TIF_RESCHED
> and then calling schedule() when it's set.

You could call cond_resched(), but really syscall exit is enough for what
you want. And the problem here if a task prevents the CPU from stopping the
tick is that task itself, not the fact it doesn't get scheduled. If we have
other tasks than the current isolated one on the CPU, it means that the
environment is not ready for hard isolation.

And in general: we shouldn't loop at all there: if something depends on the tick,
the CPU is not ready for isolation and something needs to be done: setting
some task affinity, etc... So we should just fail the prctl and let the user
deal with it.

> 
> -- 
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
> 
