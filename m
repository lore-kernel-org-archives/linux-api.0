From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Thu, 11 Feb 2016 14:24:25 -0500
Message-ID: <56BCDFE9.10200@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160130211125.GB7856@lerouge>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/30/2016 04:11 PM, Frederic Weisbecker wrote:
> On Fri, Jan 29, 2016 at 01:18:05PM -0500, Chris Metcalf wrote:
>> On 01/27/2016 07:28 PM, Frederic Weisbecker wrote:
>>> On Tue, Jan 19, 2016 at 03:45:04PM -0500, Chris Metcalf wrote:
>>>> You asked what happens if nohz_full= is given as well, which is a very
>>>> good question.  Perhaps the right answer is to have an early_initcall
>>>> that suppresses task isolation on any cores that lost their nohz_full
>>>> or isolcpus status due to later boot command line arguments (and
>>>> generate a console warning, obviously).
>>> I'd rather imagine that the final nohz full cpumask is "nohz_full=" | "task_isolation="
>>> That's the easiest way to deal with and both nohz and task isolation can call
>>> a common initializer that takes care of the allocation and add the cpus to the mask.
>> I like it!
>>
>> And by the same token, the final isolcpus cpumask is "isolcpus=" |
>> "task_isolation="?
>> That seems like we'd want to do it to keep things parallel.
> We have reverted the patch that made isolcpus |= nohz_full. Too
> many people complained about unusable machines with NO_HZ_FULL_ALL
>
> But the user can still set that parameter manually.

Yes.  What I was suggesting is that if the user specifies task_isolation=X-Y
we should add cpus X-Y to both the nohz_full set and the isolcpus set.
I've changed it to work that way for the v10 patch series.


>>>>>> +bool _task_isolation_ready(void)
>>>>>> +{
>>>>>> +	WARN_ON_ONCE(!irqs_disabled());
>>>>>> +
>>>>>> +	/* If we need to drain the LRU cache, we're not ready. */
>>>>>> +	if (lru_add_drain_needed(smp_processor_id()))
>>>>>> +		return false;
>>>>>> +
>>>>>> +	/* If vmstats need updating, we're not ready. */
>>>>>> +	if (!vmstat_idle())
>>>>>> +		return false;
>>>>>> +
>>>>>> +	/* Request rescheduling unless we are in full dynticks mode. */
>>>>>> +	if (!tick_nohz_tick_stopped()) {
>>>>>> +		set_tsk_need_resched(current);
>>>>> I'm not sure doing this will help getting the tick to get stopped.
>>>> Well, I don't know that there is anything else we CAN do, right?  If there's
>>>> another task that can run, great - it may be that that's why full dynticks
>>>> isn't happening yet.  Or, it might be that we're waiting for an RCU tick and
>>>> there's nothing else we can do, in which case we basically spend our time
>>>> going around through the scheduler code and back out to the
>>>> task_isolation_ready() test, but again, there's really nothing else more
>>>> useful we can be doing at this point.  Once the RCU tick fires (or whatever
>>>> it was that was preventing full dynticks from engaging), we will pass this
>>>> test and return to user space.
>>> There is nothing at all you can do and setting TIF_RESCHED won't help either.
>>> If there is another task that can run, the scheduler takes care of resched
>>> by itself :-)
>> The problem is that the scheduler will only take care of resched at a
>> later time, typically when we get a timer interrupt later.
> When a task is enqueued, the scheduler sets TIF_RESCHED on the target. If the
> target is remote it sends an IPI, if it's local then we wait the next reschedule
> point (preemption points, voluntary reschedule, interrupts). There is just nothing
> you can do to accelerate that.

But that's exactly what I'm saying.  If we're sitting in a loop here waiting
for some short-lived process (maybe kernel thread) to run and get out of
the way, we don't want to just spin sitting in prepare_exit_to_usermode().
We want to call schedule(), get the short-lived process to run, then when
it calls schedule() again, we're back in prepare_exit_to_usermode but now
we can return to userspace.

We don't want to wait for preemption points or interrupts, and there are
no other voluntary reschedules in the prepare_exit_to_usermode() loop.

If the other task had been woken up for some completion, then yes we would
already have had TIF_RESCHED set, but if the other runnable task was (for
example) pre-empted on a timer tick, we wouldn't have TIF_RESCHED set at
this point, and thus we might need to call schedule() explicitly.

Note that the prepare_exit_to_usermode() loop is exactly the point at
which we normally call schedule() if we are in syscall exit, so we are
just encouraging that schedule() to happen if otherwise it might not.

>> By invoking the scheduler here, we allow any tasks that are ready to run to run
>> immediately, rather than waiting for an interrupt to wake the scheduler.
> Well, in this case here we are interested in the current CPU. And if a task
> got awoken and waits for the current CPU, it will have an opportunity to get
> schedule on syscall exit.

That's true if TIF_RESCHED was set because a completion occurred that
the other task was waiting for.  But there might not be any such completion
and the task just got preempted earlier and is still ready to run.

My point is that setting TIF_RESCHED is never harmful, and there are
cases like involuntary preemption where it might help.


>> Plenty of places in the kernel just call schedule() directly when they are
>> waiting.  Since we're waiting here regardless, we might as well
>> immediately get any other runnable tasks dealt with.
>>
>> We could also just return "false" in _task_isolation_ready(), and then
>> check tick_nohz_tick_stopped() in _task_isolation_enter() and if false,
>> call schedule() explicitly there, but that seems a little more roundabout.
>> Admittedly it's more usual to see kernel code call schedule() directly
>> to yield the processor, but in this case I'm not convinced it's cleaner
>> given we're already in a loop where the caller is checking TIF_RESCHED
>> and then calling schedule() when it's set.
> You could call cond_resched(), but really syscall exit is enough for what
> you want. And the problem here if a task prevents the CPU from stopping the
> tick is that task itself, not the fact it doesn't get scheduled.

True, although in that case we just need to wait (e.g. for an RCU tick
to occur to quiesce); we could spin, but spinning through the scheduler
seems no better or worse in that case then just spinning with
interrupts enabled in a loop.  And (as I said above) it could help.

> If we have
> other tasks than the current isolated one on the CPU, it means that the
> environment is not ready for hard isolation.

Right.  But the model is that in that case, the task that wants hard
isolation is just going to have to wait to return to userspace.


> And in general: we shouldn't loop at all there: if something depends on the tick,
> the CPU is not ready for isolation and something needs to be done: setting
> some task affinity, etc... So we should just fail the prctl and let the user
> deal with it.

So there are potentially two cases here:

(1) When we initially do the prctl(), should we check to see if there are
other schedulable tasks, etc., and fail the prctl() if so?  You could make a
case for this, but I think in practice userspace would just end up looping
back to retry the prctl if we created that semantic in the kernel.

(2) What about times when we are leaving the kernel after already
doing the prctl()?  For example a core doing packet forwarding might
want to report some error condition up to the kernel, and remove itself
from the set of cores handling packets, then do some syscall(s) to generate
logging data, and then go back and continue handling packets.  Or, the
process might have created some large anonymous mapping where
every now and then it needs to cross a page boundary for some structure
and touch a new page, and it knows to expect a page fault in that case.
In those cases we are returning from the kernel, not at prctl() time, and
we still want to enforce the semantics that no further interrupts will
occur to disturb the task.  These kinds of use cases are why we have
as general-purpose a mechanism as we do for task isolation.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
