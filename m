From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 29 Jan 2016 13:18:05 -0500
Message-ID: <56ABACDD.5090500@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128002801.GA14313@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/27/2016 07:28 PM, Frederic Weisbecker wrote:
> On Tue, Jan 19, 2016 at 03:45:04PM -0500, Chris Metcalf wrote:
>> You asked what happens if nohz_full= is given as well, which is a very
>> good question.  Perhaps the right answer is to have an early_initcall
>> that suppresses task isolation on any cores that lost their nohz_full
>> or isolcpus status due to later boot command line arguments (and
>> generate a console warning, obviously).
> I'd rather imagine that the final nohz full cpumask is "nohz_full=" | "task_isolation="
> That's the easiest way to deal with and both nohz and task isolation can call
> a common initializer that takes care of the allocation and add the cpus to the mask.

I like it!

And by the same token, the final isolcpus cpumask is "isolcpus=" | 
"task_isolation="?
That seems like we'd want to do it to keep things parallel.

>>>> +bool _task_isolation_ready(void)
>>>> +{
>>>> +	WARN_ON_ONCE(!irqs_disabled());
>>>> +
>>>> +	/* If we need to drain the LRU cache, we're not ready. */
>>>> +	if (lru_add_drain_needed(smp_processor_id()))
>>>> +		return false;
>>>> +
>>>> +	/* If vmstats need updating, we're not ready. */
>>>> +	if (!vmstat_idle())
>>>> +		return false;
>>>> +
>>>> +	/* Request rescheduling unless we are in full dynticks mode. */
>>>> +	if (!tick_nohz_tick_stopped()) {
>>>> +		set_tsk_need_resched(current);
>>> I'm not sure doing this will help getting the tick to get stopped.
>> Well, I don't know that there is anything else we CAN do, right?  If there's
>> another task that can run, great - it may be that that's why full dynticks
>> isn't happening yet.  Or, it might be that we're waiting for an RCU tick and
>> there's nothing else we can do, in which case we basically spend our time
>> going around through the scheduler code and back out to the
>> task_isolation_ready() test, but again, there's really nothing else more
>> useful we can be doing at this point.  Once the RCU tick fires (or whatever
>> it was that was preventing full dynticks from engaging), we will pass this
>> test and return to user space.
> There is nothing at all you can do and setting TIF_RESCHED won't help either.
> If there is another task that can run, the scheduler takes care of resched
> by itself :-)

The problem is that the scheduler will only take care of resched at a
later time, typically when we get a timer interrupt later.  By invoking the
scheduler here, we allow any tasks that are ready to run to run
immediately, rather than waiting for an interrupt to wake the scheduler.
Plenty of places in the kernel just call schedule() directly when they are
waiting.  Since we're waiting here regardless, we might as well
immediately get any other runnable tasks dealt with.

We could also just return "false" in _task_isolation_ready(), and then
check tick_nohz_tick_stopped() in _task_isolation_enter() and if false,
call schedule() explicitly there, but that seems a little more roundabout.
Admittedly it's more usual to see kernel code call schedule() directly
to yield the processor, but in this case I'm not convinced it's cleaner
given we're already in a loop where the caller is checking TIF_RESCHED
and then calling schedule() when it's set.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
