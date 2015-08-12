From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/6] cpu_isolated: add initial support
Date: Wed, 12 Aug 2015 14:22:09 -0400
Message-ID: <55CB8ED1.6030806@ezchip.com>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
 <1438112980-9981-3-git-send-email-cmetcalf@ezchip.com>
 <20150812160020.GG21542@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150812160020.GG21542@lerouge>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/12/2015 12:00 PM, Frederic Weisbecker wrote:
> On Tue, Jul 28, 2015 at 03:49:36PM -0400, Chris Metcalf wrote:
>> The existing nohz_full mode is designed as a "soft" isolation mode
>> that makes tradeoffs to minimize userspace interruptions while
>> still attempting to avoid overheads in the kernel entry/exit path,
>> to provide 100% kernel semantics, etc.
>>
>> However, some applications require a "hard" commitment from the
>> kernel to avoid interruptions, in particular userspace device
>> driver style applications, such as high-speed networking code.
>>
>> This change introduces a framework to allow applications
>> to elect to have the "hard" semantics as needed, specifying
>> prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
>> Subsequent commits will add additional flags and additional
>> semantics.
> We are doing this at the process level but the isolation works on
> the CPU scope... Now I wonder if prctl is the right interface.
>
> That said the user is rather interested in isolating a task. The CPU
> being the backend eventually.
>
> For example if the task is migrated by accident, we want it to be
> warned about that. And if the isolation is done on the CPU level
> instead of the task level, this won't happen.
>
> I'm also afraid that the naming clashes with cpu_isolated_map,
> although it could be a subset of it.
>
> So probably in this case we should consider talking about task rather
> than CPU isolation and change naming accordingly (sorry, I know I
> suggested cpu_isolation.c, I guess I had to see the result to realize).
>
> We must sort that out first. Either we consider isolation on the task
> level (and thus the underlying CPU by backend effect) and we use prctl().
> Or we do this on the CPU level and we use a specific syscall or sysfs
> which takes effect on any task in the relevant isolated CPUs.
>
> What do you think?

Yes, definitely task-centric is the right model.

With the original tilegx version of this code, we also checked that
the process had only a single core in its affinity mask, and that the
single core in question was a nohz_full core, before allowing the
"task isolated" mode to take effect.  I didn't do that in this round
of patches because it seemed a little silly in that the user could
then immediately reset their affinity to another core and lose the
effect, and it wasn't clear how to handle that: do we return EINVAL
from sched_setaffinity() after enabling the "task isolated" mode?
That seems potentially ugly, maybe standards-violating, etc.  So I
didn't bother.

But you could certainly argue for failing prctl() in that case anyway,
as a way to make sure users aren't doing something stupid like calling
the prctl() from a task that's running on a housekeeping core.  And
you could even argue for doing some kind of console spew if you try to
migrate a task that is in "task isolation" state - though I suppose if
you migrate it to another isolcpus and nohz_full core, maybe that's
kind of reasonable and doesn't deserve a warning?  I'm not sure.

>> The kernel must be built with the new CPU_ISOLATED Kconfig flag
>> to enable this mode, and the kernel booted with an appropriate
>> nohz_full=CPULIST boot argument.  The "cpu_isolated" state is then
>> indicated by setting a new task struct field, cpu_isolated_flags,
>> to the value passed by prctl().  When the _ENABLE bit is set for a
>> task, and it is returning to userspace on a nohz_full core, it calls
>> the new cpu_isolated_enter() routine to take additional actions
>> to help the task avoid being interrupted in the future.
>>
>> Initially, there are only three actions taken.  First, the
>> task calls lru_add_drain() to prevent being interrupted by a
>> subsequent lru_add_drain_all() call on another core.  Then, it calls
>> quiet_vmstat() to quieten the vmstat worker to avoid a follow-on
>> interrupt.  Finally, the code checks for pending timer interrupts
>> and quiesces until they are no longer pending.  As a result, sys
>> calls (and page faults, etc.) can be inordinately slow.  However,
>> this quiescing guarantees that no unexpected interrupts will occur,
>> even if the application intentionally calls into the kernel.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>> ---
>>   arch/tile/kernel/process.c   |  9 ++++++
>>   include/linux/cpu_isolated.h | 24 +++++++++++++++
>>   include/linux/sched.h        |  3 ++
>>   include/uapi/linux/prctl.h   |  5 ++++
>>   kernel/context_tracking.c    |  3 ++
>>   kernel/sys.c                 |  8 +++++
>>   kernel/time/Kconfig          | 20 +++++++++++++
>>   kernel/time/Makefile         |  1 +
>>   kernel/time/cpu_isolated.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++
> It's not about time :-)
>
> The timer is only a part of the isolation.
>
> Moreover "isolatED" is a state. The filename should reflect the process. "isolatION" would
> better fit.
>
> kernel/task_isolation.c maybe or just kernel/isolation.c
>
> I think I prefer the latter because I'm not only interested in that task
> hard isolation feature, I would like to also drive all the general isolation
> operations from there (workqueue affinity, rcu nocb, ...).

That's reasonable, but I think the "task isolation" naming is probably
better for all the stuff that we're doing in this patch.  In other words,
we probably should use "task_isolation" as the prefix for symbols
names and API names, even if we put the code in kernel/isolation.c
for now in anticipation of non-task isolation being added later.

I think my instinct would still be to call it kernel/task_isolation.c
until we actually add some non-task isolation, and at that point we
can decide if it makes sense to rename the file, or put the new
code somewhere else, but I'm OK with doing it the way I described
in the previous paragraph if you think it's better.

>> +#ifdef CONFIG_CPU_ISOLATED
>> +void cpu_isolated_wait(void)
>> +{
>> +	set_current_state(TASK_INTERRUPTIBLE);
>> +	_cpu_idle();
>> +	set_current_state(TASK_RUNNING);
>> +}
> I'm still uncomfortable with that. A wake up model could work?

I don't know exactly what you have in mind.  The theory is that
at this point we're ready to return to user space and we're just
waiting for a timer tick that is guaranteed to arrive, since there
is something pending for the timer.

And, this is an arch-specific method anyway; the generic method
is actually checking to see if a signal has been delivered,
scheduling is needed, etc., each time around the loop, so if
you're not sure your architecture will do the right thing, just
don't provide a method that idles while waiting.  For tilegx I'm
sure it works correctly, so I'm OK providing that method.

>> +extern void cpu_isolated_enter(void);
>> +extern void cpu_isolated_wait(void);
>> +#else
>> +static inline bool is_cpu_isolated(void) { return false; }
>> +static inline void cpu_isolated_enter(void) { }
>> +#endif
> And all the naming should be about task as well, if we take that task direction.

As discussed above, probably task_isolation_enter(), etc.

>> +
>> +#endif
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 04b5ada460b4..0bb248385d88 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1776,6 +1776,9 @@ struct task_struct {
>>   	unsigned long	task_state_change;
>>   #endif
>>   	int pagefault_disabled;
>> +#ifdef CONFIG_CPU_ISOLATED
>> +	unsigned int	cpu_isolated_flags;
>> +#endif
> Can't we add a new flag to tsk->flags? There seem to be some values remaining.

Yeah, I thought of that, but it seems like a pretty scarce resource,
and I wasn't sure it was the right thing to do.  Also, I'm not actually
sure why the lowest two bits aren't apparently being used; looks
like PF_EXITING (0x4) is the first bit used.  And there are only three
more bits higher up in the word that are not assigned.

Also, right now we are allowing users to customize the signal delivered
for STRICT violation, and that signal value is stored in the
cpu_isolated_flags word as well, so we really don't have room in
tsk->flags for all of that anyway.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
