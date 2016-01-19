From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Tue, 19 Jan 2016 15:45:04 -0500
Message-ID: <569EA050.5030106@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160119154214.GA2722@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/19/2016 10:42 AM, Frederic Weisbecker wrote:
> On Mon, Jan 04, 2016 at 02:34:42PM -0500, Chris Metcalf wrote:
>> diff --git a/kernel/isolation.c b/kernel/isolation.c
>> new file mode 100644
>> index 000000000000..68a9f7457bc0
>> --- /dev/null
>> +++ b/kernel/isolation.c
>> @@ -0,0 +1,105 @@
>> +/*
>> + *  linux/kernel/isolation.c
>> + *
>> + *  Implementation for task isolation.
>> + *
>> + *  Distributed under GPLv2.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/swap.h>
>> +#include <linux/vmstat.h>
>> +#include <linux/isolation.h>
>> +#include <linux/syscalls.h>
>> +#include "time/tick-sched.h"
>> +
>> +cpumask_var_t task_isolation_map;
>> +
>> +/*
>> + * Isolation requires both nohz and isolcpus support from the scheduler.
>> + * We provide a boot flag that enables both for now, and which we can
>> + * add other functionality to over time if needed.  Note that just
>> + * specifying "nohz_full=... isolcpus=..." does not enable task isolation.
>> + */
>> +static int __init task_isolation_setup(char *str)
>> +{
>> +	alloc_bootmem_cpumask_var(&task_isolation_map);
>> +	if (cpulist_parse(str, task_isolation_map) < 0) {
>> +		pr_warn("task_isolation: Incorrect cpumask '%s'\n", str);
>> +		return 1;
>> +	}
>> +
>> +	alloc_bootmem_cpumask_var(&cpu_isolated_map);
>> +	cpumask_copy(cpu_isolated_map, task_isolation_map);
>> +
>> +	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
>> +	cpumask_copy(tick_nohz_full_mask, task_isolation_map);
>> +	tick_nohz_full_running = true;
> How about calling tick_nohz_full_setup() instead? I'd rather prefer
> that nohz full implementation details stay in tick-sched.c
>
> Also what happens if nohz_full= is given as well as task_isolation= ?
> Don't we risk a memory leak and maybe breaking the fact that
> (nohz_full & task_isolation != task_isolation) which is really a requirement?

Yeah, this is a good point.  I'm not sure what the best way is to make
this happen.  It's already true that we will leak memory if you
specify "nohz_full=" more than once on the command line, but it's
awkward to fix (assuming we want the last value to win) so maybe
we can just ignore this problem - it's a pretty small amount of memory
after all.  If so, then making tick_nohz_full_setup() and 
isolated_cpu_setup()
both non-static and calling them from task_isolation_setup() might
be the cleanest approach.  What do you think?

You asked what happens if nohz_full= is given as well, which is a very
good question.  Perhaps the right answer is to have an early_initcall
that suppresses task isolation on any cores that lost their nohz_full
or isolcpus status due to later boot command line arguments (and
generate a console warning, obviously).

>> +
>> +	return 1;
>> +}
>> +__setup("task_isolation=", task_isolation_setup);
>> +
>> +/*
>> + * This routine controls whether we can enable task-isolation mode.
>> + * The task must be affinitized to a single task_isolation core or we will
>> + * return EINVAL.  Although the application could later re-affinitize
>> + * to a housekeeping core and lose task isolation semantics, this
>> + * initial test should catch 99% of bugs with task placement prior to
>> + * enabling task isolation.
>> + */
>> +int task_isolation_set(unsigned int flags)
>> +{
>> +	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
>> +	    !task_isolation_possible(smp_processor_id()))
>> +		return -EINVAL;
>> +
>> +	current->task_isolation_flags = flags;
>> +	return 0;
>> +}
> What if we concurrently change the task's affinity? Also it seems that preemption
> isn't disabled, so we can also migrate concurrently. I'm surprised you haven't
> seen warnings with smp_processor_id().
>
> Also we should protect against task's affinity change when task_isolation_flags
> is set.

I talked about this a bit when you raised it for the v8 patch series:

   http://lkml.kernel.org/r/562FA8FD.8080502@ezchip.com

I'd be curious to hear your take on the arguments I made there.

You're absolutely right about the preemption warnings, which I only fixed
a few days ago.  In this case I use raw_smp_processor_id() since with a
fixed single-core cpu affinity, we're not going anywhere, so the warning
from smp_processor_id() would be bogus.  And although technically it is
still correct (racing with another task resetting the task affinity on this
one), it is in any case equivalent to having that other task reset the 
affinity
on return from the prctl(), which I've already claimed isn't an interesting
use case to try to handle.  But let me know what you think!

>> +
>> +/*
>> + * In task isolation mode we try to return to userspace only after
>> + * attempting to make sure we won't be interrupted again.  To handle
>> + * the periodic scheduler tick, we test to make sure that the tick is
>> + * stopped, and if it isn't yet, we request a reschedule so that if
>> + * another task needs to run to completion first, it can do so.
>> + * Similarly, if any other subsystems require quiescing, we will need
>> + * to do that before we return to userspace.
>> + */
>> +bool _task_isolation_ready(void)
>> +{
>> +	WARN_ON_ONCE(!irqs_disabled());
>> +
>> +	/* If we need to drain the LRU cache, we're not ready. */
>> +	if (lru_add_drain_needed(smp_processor_id()))
>> +		return false;
>> +
>> +	/* If vmstats need updating, we're not ready. */
>> +	if (!vmstat_idle())
>> +		return false;
>> +
>> +	/* Request rescheduling unless we are in full dynticks mode. */
>> +	if (!tick_nohz_tick_stopped()) {
>> +		set_tsk_need_resched(current);
> I'm not sure doing this will help getting the tick to get stopped.

Well, I don't know that there is anything else we CAN do, right?  If there's
another task that can run, great - it may be that that's why full dynticks
isn't happening yet.  Or, it might be that we're waiting for an RCU tick and
there's nothing else we can do, in which case we basically spend our time
going around through the scheduler code and back out to the
task_isolation_ready() test, but again, there's really nothing else more
useful we can be doing at this point.  Once the RCU tick fires (or whatever
it was that was preventing full dynticks from engaging), we will pass this
test and return to user space.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

