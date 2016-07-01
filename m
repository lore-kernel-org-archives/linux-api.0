From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 1 Jul 2016 16:59:26 -0400
Message-ID: <25c4ace1-6903-abb3-59e9-aedc11ac32fc@mellanox.com>
References: <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge> <5707DDA8.10600@mellanox.com>
 <20160526010656.GB17245@lerouge>
 <4e96ef87-c254-3357-3c7e-cd97ccb6ce56@mellanox.com>
 <20160629151810.GA28724@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160629151810.GA28724@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 6/29/2016 11:18 AM, Frederic Weisbecker wrote:
> On Fri, Jun 03, 2016 at 03:32:04PM -0400, Chris Metcalf wrote:
>> On 5/25/2016 9:07 PM, Frederic Weisbecker wrote:
>>> On Fri, Apr 08, 2016 at 12:34:48PM -0400, Chris Metcalf wrote:
>>>> On 4/8/2016 9:56 AM, Frederic Weisbecker wrote:
>>>>> On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
>>>>>>   TL;DR: Let's make an explicit decision about whether task isolation
>>>>>>   should be "persistent" or "one-shot".  Both have some advantages.
>>>>>>   =====
>>>>>>
>>>>>> An important high-level issue is how "sticky" task isolation mode is.
>>>>>> We need to choose one of these two options:
>>>>>>
>>>>>> "Persistent mode": A task switches state to "task isolation" mode
>>>>>> (kind of a level-triggered analogy) and stays there indefinitely.  It
>>>>>> can make a syscall, take a page fault, etc., if it wants to, but the
>>>>>> kernel protects it from incurring any further asynchronous interrupts.
>>>>>> This is the model I've been advocating for.
>>>>> But then in this mode, what happens when an interrupt triggers.
>>>> So what happens if an interrupt does occur?
>>>>
>>>> In the "base" task isolation mode, you just take the interrupt, then
>>>> wait to quiesce any further kernel timer ticks, etc., and return to
>>>> the process.  This at least limits the damage to being a single
>>>> interruption rather than potentially additional ones, if the interrupt
>>>> also caused timers to get queued, etc.
>>> Good, although that quiescing on kernel return must be an option.
>>
>> Can you spell out why you think turning it off is helpful?  I'll admit
>> this is the default mode in the commercial version of task isolation
>> that we ship, and was also the default in the first LKML patch series.
>> But on consideration I haven't found scenarios where skipping the
>> quiescing is helpful.  Admittedly you get out of the kernel faster,
>> but then you're back in userspace and vulnerable to yet more
>> unexpected interrupts until the timer quiesces.  If you're asking for
>> task isolation, this is surely not what you want.
>
> I just feel that quiescing, on the way back to user after an unwanted
> interruption, is awkward. The quiescing should work once and for all
> on return back from the prctl. If we still get disturbed afterward,
> either the quiescing is buggy or incomplete, or something is on the
> way that can not be quiesced.

If we are thinking of an initial implementation that doesn't allow any
subsequent kernel entry to be valid, then this all gets much easier,
since any subsequent kernel entry except for a prctl() syscall will
result in a signal, which will turn off task isolation, and we will
never have to worry about additional quiescing.  I think that's where
we got from the discussion at the bottom of this email.

So for your question here, we're really just thinking about future
directions as far as how to handle interrupts, and if in the future we
add support for allowing syscalls and/or exceptions without leaving
task isolation mode, then we have to think about how that interacts
with interrupts.  The problem is that it's hard to tell, as you're
returning to userspace, whether you're returning from an exception or
an interrupt; you typically don't have that information available.  So
from a purely ease-of-implementation perspective, we'd likely want to
handle exceptions and interrupts the same way, and quiesce both.

In general, I think it would also be a better explanation to users of
task isolation to say "every enter/exit to the kernel is either an
error that causes a signal, or it quiesces on return".  It's a simpler
semantic, and I think it also is better for interrupts anyway, since
it potentially avoids multiple interrupts to the application (whatever
interrupted to begin with, plus potential timer interrupts later).

But that said, if we start with "pure strict" mode only, all of this
becomes hypothetical, and we may in fact choose never to allow "safe"
modes of entering the kernel.

>>>> I'm not actually sure what
>>>> you're recommending we do to avoid exceptions.  Since they're
>>>> synchronous and deterministic, we can't really avoid them if the
>>>> program wants to issue them.  For example, mmap() some anonymous
>>>> memory and then start running, and you'll take exceptions each time
>>>> you touch a page in that mapped region.  I'd argue it's an application
>>>> bug; one should enable "strict" mode to catch and deal with such bugs.
>>> They are not all deterministic. For example a breakpoint, a step, a trap
>>> can be set up by another process. So this is not entirely under the control
>>> of the user.
>>
>> That's true, but I'd argue the behavior in that case should be that you can
>> raise that kind of exception validly (so you can debug), and then you should
>> quiesce on return to userspace so the application doesn't see additional
>> exceptions.
>
> I don't see how we can quiesce such things.

I'm imagining task A is in dataplane mode, and task B wants to debug
it by writing a breakpoint into its text.  When task A hits the
breakpoint, it will enter the kernel, and hold there while task B
pokes at it with ptrace.  When task A finally is allowed to return to
userspace, it should quiesce before entering userspace in case any
timer interrupts got scheduled (again, maybe due to softirqs or
whatever, or random other kernel activity targeting that core while it
was in the kernel, or whatever).  This is just the same kind of
quiescing we do on return from the initial prctl().

With a "pure strict" mode it does get a little tricky, since we will
end up killing task A as it comes back from its breakpoint.  We might
just choose to say that task A should not enable task isolation if it
is going to be debugged (some runtime switch).  This isn't really a
great solution; I do kind of feel that the nicest thing to do is
quiesce the task again at this point.  This feels like the biggest
argument in favor of supporting a mode where a task-isolated task can
safely enter the kernel for exceptions.  What do you think?

>> There are two ways you could handle debugging:
>>
>> 1. Require the program to set the flag that says it doesn't want a signal
>> when it is interrupted (so you can interrupt it to debug it, and not kill it);
>
> That's rather about exceptions, right?

Yes, with the task A/task B example above, you're right.  I was
thinking there was a kick given by task B to task A.  I think that
might even be true in some circumstances, but anyway, it's a detail.

>> Here's what I am inclined towards:
>>
>>  - Default mode (hard isolation / "strict") - leave userspace, get a signal, no exceptions.
>
> Ok.
>
>>
>>  - "No signal" mode - leave userspace synchronously (syscall/exception), get quiesced on
>>    return, no signals.  But asynchronous interrupts still cause a signal since they are
>>    not expected to occur.
>
> So only interrupt cause a signal in this mode? Exceptions and syscalls are permitted, right?

Yes, correct.

>>  - Soft mode (I don't think we want this) - like "no signal" except you don't even quiesce
>>    on return to userspace, and asynchronous interrupts don't even cause a signal.
>>    It's basically "best effort", just nohz_full plus the code that tries to get things
>>    like LRU or vmstat to run before returning to userspace.  I think there isn't enough
>>    "value add" to make this a separate mode, though.
>
> I can imagine HPC to be willing this mode.

Yes, perhaps.  I'm not convinced we want to target HPC without a much
clearer sense of why this is better than nohz_full, though.  I fear
people might think "task isolation" is better by definition and not
think too much about it, but I'm really not sure it is better for the
HPC use case, necessarily.

>>>> You're right that migration conflicts with task isolation.  But
>>>> certainly, if a task has enabled "strict" semantics, it can't migrate;
>>>> it will lose task isolation entirely and get a signal instead,
>>>> regardless of whether it calls sched_setaffinity() on itself, or if
>>>> someone else changes its affinity and it gets a kick.
>>> Yes.
>>>
>>>> However, if a task doesn't have strict mode enabled, it can call
>>>> sched_setaffinity() and force itself onto a non-task_isolation cpu and
>>>> it won't get any isolation until it schedules itself back onto a
>>>> task_isolation cpu, at which point it wakes up on the new cpu with
>>>> hard isolation still in effect.  I can make up reasons why this sort
>>>> of thing might be useful, but it's probably a corner case.
>>> That doesn't look sane. The user asks the kernel to get away as much
>>> as it can but if we are in a non-nohz-full CPU we know we can't provide that
>>> service (or rather that non-service).
>>>
>>> So we would refuse to enter in task isolation mode if it doesn't run in a
>>> full dynticks CPUs whereas we accept that it migrates later to a periodic
>>> CPU?. This isn't consistent.
>>
>> Yes, and originally I made that consistent by not checking when it started
>> up, either, but I was subsequently convinced that the checks were good for
>> sanity.
>
> Sure sanity checks are good but if you refuse the prctl with returning an error
> on the basis of this sanity condition, the task shouldn't be able to later reach
> that insanity state without being properly kicked out of the feature provided by
> the prctl().
>
> Otherwise perhaps just drop a warning.

Are you saying that we should printk a warning in the prctl() rather
than returning an error in the case where it's not on a full dynticks
cpu?  I could be convinced by that just to keep things consistent.

How about doing it this way?  If you invoke prctl() with the default
"strict" mode where any kernel entry results in a signal, the prctl()
will be strict, and require you to be affinitized to a single, full
dynticks cpu.

But, if you enable the "allow syscalls" mode, then the prctl isn't
strict either, since you can use syscalls to get into a state where
you're not on a full dynticks cpu, and you just get a console warning
if you enter task isolation on the wrong cpu.  (Of course, we may end
up not doing the "allow syscalls" mode for the first version of this
patch anyway, as we discuss below.)

>>>> Googling "Zero-Overhead Linux" does take you to some discussions
>>>> of customers that have used this functionality.
>>> So those workloads couldn't stand an interrupt? Like they would like a signal
>>> and exit the strict mode if it happens?
>>
>> Correct, they couldn't tolerate interrupts.  If one happened, it would cause packets to
>> be dropped and some kind of logging would fire to report the problem.
>
> Ok. And is it this mode you're interested in? Isn't quiescing an issue in this mode?

In this mode we don't worry about quiescing for interrupts, since we
are generating a signal, and when you send a signal, you first have to
disable task isolation mode to avoid getting into various bad states
(sending too many signals, or worse, getting deadlocked because you
are signalling the task BECAUSE it was about to receive a signal).  So
we only quiesce after syscalls/exceptions.

>> So maybe something like this:
>>
>> PR_TASK_ISOLATION_ENABLE - turn on basic strict/signaling mode
>> PR_TASK_ISOLATION_ALLOW_SYSCALLS - for syscalls, no signal, just quiesce before return
>> PR_TASK_ISOLATION_ALLOW_EXCEPTIONS - for all exceptions, no signal, quiesce before return
>>
>> It might make sense to say you would allow page faults, for example, but not general
>> exceptions.  But my guess is that the exception-related stuff really does need an
>> application use case to account for it.  I would say for the initial support of task
>> isolation, we have a clearly-understood model for allowing syscalls (e.g. stuff
>> like generating diagnostics on error or slow paths), but not really a model for
>> understanding why users would want to take exceptions, so I'd say let's omit
>> that initially, and maybe just add the _ALLOW_SYSCALLS flag.
>
> Ok. That interface looks better. At least we can start with just PR_TASK_ISOLATION_ENABLE which
> does strict pure isolation mode and have future flags for more granularity.

I think just implementing the basic _ENABLE mode with pure strict task
isolation makes sense for now.  We can wait to enable syscalls or
exceptions until we have a better use case.  Meanwhile, even without
support for allowing syscalls, you can always use prctl() to turn off
task isolation, and then you can do your syscalls, and prctl() it back
on again.  prctl() to disable task isolation always has to work :-)

Or, if we want to make it easy to do debugging, and as a result maybe
also support the plausible mode where task-isolation tasks make
occasional syscalls, we could say that the _ALLOW_EXCEPTIONS flag
above implies syscalls as well, and support that mode.  Perhaps that
makes the most sense...

I'll spin it as a new patch series and you can take a look.

Thanks!
-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
