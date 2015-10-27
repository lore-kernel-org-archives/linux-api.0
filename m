From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Tue, 27 Oct 2015 12:40:29 -0400
Message-ID: <562FA8FD.8080502@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
 <20151021161247.GA19764@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021161247.GA19764@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/21/2015 12:12 PM, Frederic Weisbecker wrote:
> On Tue, Oct 20, 2015 at 04:36:02PM -0400, Chris Metcalf wrote:
>> +/*
>> + * This routine controls whether we can enable task-isolation mode.
>> + * The task must be affinitized to a single nohz_full core or we will
>> + * return EINVAL.  Although the application could later re-affinitize
>> + * to a housekeeping core and lose task isolation semantics, this
>> + * initial test should catch 99% of bugs with task placement prior to
>> + * enabling task isolation.
>> + */
>> +int task_isolation_set(unsigned int flags)
>> +{
>> +	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
> I think you'll have to make sure the task can not be concurrently reaffined
> to more CPUs. This may involve setting task_isolation_flags under the runqueue
> lock and thus move that tiny part to the scheduler code. And then we must forbid
> changing the affinity while the task has the isolation flag, or deactivate the flag.
>
> In any case this needs some synchronization.

Well, as the comment says, this is not intended as a hard guarantee.
As written, it might race with a concurrent sched_setaffinity(), but
then again, it also is totally OK as written for sched_setaffinity() to
change it away after the prctl() is complete, so it's not necessary to
do any explicit synchronization.

This harks back again to the whole "polite vs aggressive" issue with
how we envision task isolation.

The "polite" model basically allows you to set up the conditions for
task isolation to be useful, and then if they are useful, great! What
you're suggesting here is a bit more of the "aggressive" model, where
we actually fail sched_setaffinity() either for any cpumask after
task isolation is set, or perhaps just for resetting it to housekeeping
cores.  (Note that we could in principle use PF_NO_SETAFFINITY to
just hard fail all attempts to call sched_setaffinity once we enable
task isolation, so we don't have to add more mechanism on that path.)

I'm a little reluctant to ever fail sched_setaffinity() based on the
task isolation status with the current "polite" model, since an
unprivileged application can set up for task isolation, and then
presumably no one can override it via sched_setaffinity() from another
task.  (I suppose you could do some kind of permissions-based thing
where root can always override it, or some suitable capability, etc.,
but I feel like that gets complicated quickly, for little benefit.)

The alternative you mention is that if the task is re-affinitized, it
loses its task-isolation status, and that also seems like an unfortunate
API, since if you are setting it with prctl(), it's really cleanest just to
only be able to unset it with prctl() as well.

I think given the current "polite" API, the only question is whether in
fact *no* initial test is the best thing, or if an initial test (as 
introduced
in the v8 version) is defensible just as a help for catching an obvious
mistake in setting up your task isolation.  I decided the advantage
of catching the mistake were more important than the "API purity"
of being 100% consistent in how we handled the interactions between
affinity and isolation, but I am certainly open to argument on that one.

Meanwhile I think it still feels like the v8 code is the best compromise.

>> +	/* If the tick is running, request rescheduling; we're not ready. */
>> +	if (!tick_nohz_tick_stopped()) {
> Note that this function tells whether the tick is in dynticks mode, which means
> the tick currently only run on-demand. But it's not necessarily completely stopped.

I think in fact this is the semantics we want (and that people requested),
e.g. if the user requests an alarm(), we may still be ticking even though
tick_nohz_tick_stopped() is true, but that test is still the right condition
to use to return to user space, since the user explicitly requested the 
alarm.

> I think we should rename that function and the field it refers to.

Sounds like a good idea.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
