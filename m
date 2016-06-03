From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 3 Jun 2016 15:32:04 -0400
Message-ID: <4e96ef87-c254-3357-3c7e-cd97ccb6ce56@mellanox.com>
References: <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge> <5707DDA8.10600@mellanox.com>
 <20160526010656.GB17245@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160526010656.GB17245@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5/25/2016 9:07 PM, Frederic Weisbecker wrote:
> I don't remember how much I answered this email, but I need to finish that :-)

Sorry for the slow response - it's been a busy week.

> On Fri, Apr 08, 2016 at 12:34:48PM -0400, Chris Metcalf wrote:
>> On 4/8/2016 9:56 AM, Frederic Weisbecker wrote:
>>> On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
>>>>    TL;DR: Let's make an explicit decision about whether task isolation
>>>>    should be "persistent" or "one-shot".  Both have some advantages.
>>>>    =====
>>>>
>>>> An important high-level issue is how "sticky" task isolation mode is.
>>>> We need to choose one of these two options:
>>>>
>>>> "Persistent mode": A task switches state to "task isolation" mode
>>>> (kind of a level-triggered analogy) and stays there indefinitely.  It
>>>> can make a syscall, take a page fault, etc., if it wants to, but the
>>>> kernel protects it from incurring any further asynchronous interrupts.
>>>> This is the model I've been advocating for.
>>> But then in this mode, what happens when an interrupt triggers.
>> So what happens if an interrupt does occur?
>>
>> In the "base" task isolation mode, you just take the interrupt, then
>> wait to quiesce any further kernel timer ticks, etc., and return to
>> the process.  This at least limits the damage to being a single
>> interruption rather than potentially additional ones, if the interrupt
>> also caused timers to get queued, etc.
> Good, although that quiescing on kernel return must be an option.

Can you spell out why you think turning it off is helpful?  I'll admit
this is the default mode in the commercial version of task isolation
that we ship, and was also the default in the first LKML patch series.
But on consideration I haven't found scenarios where skipping the
quiescing is helpful.  Admittedly you get out of the kernel faster,
but then you're back in userspace and vulnerable to yet more
unexpected interrupts until the timer quiesces.  If you're asking for
task isolation, this is surely not what you want.

>> If you enable "strict" mode, we disable task isolation mode for that
>> core and deliver a signal to it.  This lets the application know that
>> an interrupt occurred, and it can take whatever kind of logging or
>> debugging action it wants to, re-enable task isolation if it wants to
>> and continue, or just exit or abort, etc.
> Good.
>
>> If you don't enable "strict" mode, but you do have
>> task_isolation_debug enabled as a boot flag, you will at least get a
>> console dump with a backtrace and whatever other data we have.
>> (Sometimes the debug info actually includes a backtrace of the
>> interrupting core, if it's an IPI or TLB flush from another core,
>> which can be pretty useful.)
> Right, I suggest we use trace events btw.

This is probably a good idea, although I wonder if it's worth deferring
until after the main patch series goes in - I'm reluctant to expand the scope
of this patch series and add more reasons for it to get delayed :-)
What do you think?

>>>> "One-shot mode": A task requests isolation via prctl(), the kernel
>>>> ensures it is isolated on return from the prctl(), but then as soon as
>>>> it enters the kernel again, task isolation is switched off until
>>>> another prctl is issued.  This is what you recommended in your last
>>>> email.
>>> No I think we can issue syscalls for exemple. But asynchronous interruptions
>>> such as exceptions (actually somewhat synchronous but can be unexpected) and
>>> interrupts are what we want to avoid.
>> Hmm, so I think I'm not really understanding what you are suggesting.
>>
>> We're certainly in agreement that avoiding interrupts and exceptions
>> is important.  I'm arguing that the way to deal with them is to
>> generate appropriate signals/printks, etc.
> Yes.
>
>> I'm not actually sure what
>> you're recommending we do to avoid exceptions.  Since they're
>> synchronous and deterministic, we can't really avoid them if the
>> program wants to issue them.  For example, mmap() some anonymous
>> memory and then start running, and you'll take exceptions each time
>> you touch a page in that mapped region.  I'd argue it's an application
>> bug; one should enable "strict" mode to catch and deal with such bugs.
> They are not all deterministic. For example a breakpoint, a step, a trap
> can be set up by another process. So this is not entirely under the control
> of the user.

That's true, but I'd argue the behavior in that case should be that you can
raise that kind of exception validly (so you can debug), and then you should
quiesce on return to userspace so the application doesn't see additional
exceptions.  There are two ways you could handle debugging:

1. Require the program to set the flag that says it doesn't want a signal
when it is interrupted (so you can interrupt it to debug it, and not kill it);

2. Or have debugging automatically set that flag in the target process.
Similarly, we could just say that if a debugger is attached, we never
generate the kill signal for task isolation.

>> (Typically the recommendation is to do an mlockall() before starting
>> task isolation mode, to handle the case of page faults.  But you can
>> do that and still be screwed by another thread in your process doing a
>> fork() and then your pages end up read-only for COW and you have to
>> fault them back in.  But, that's an application bug for a
>> task-isolation thread, and should just be treated as such.)
> Now how do you determine which exception is a bug and which is expected?
> Strict mode should refuse all of them.

Yes, exactly.  Task isolation will complain about everything. :-)

>>>> There are a number of pros and cons to the two models.  I think on
>>>> balance I still like the "persistent mode" approach, but here's all
>>>> the pros/cons I can think of:
>>>>
>>>> PRO for persistent mode: A somewhat easier programming model.  Users
>>>> can just imagine "task isolation" as a way for them to still be able
>>>> to use the kernel exactly as they always have; it's just slower to get
>>>> back out of the kernel so you use it judiciously. For example, a
>>>> process is free to call write() on a socket to perform a diagnostic,
>>>> but when returning from the write() syscall, the kernel will hold the
>>>> task in kernel mode until any timer ticks (perhaps from networking
>>>> stuff) are complete, and then let it return to userspace to continue
>>>> in task isolation mode.
>>> So this is not hard isolation anymore. This is rather soft isolation with
>>> best efforts to avoid disturbance.
>> No, it's still hard isolation.  The distinction is that we offer a way
>> to get in and out of the kernel "safely" if you want to run in that
>> mode.  The syscalls can take a long time if the syscall ends up
>> requiring some additional timer ticks to finish sorting out whatever
>> it was you asked the kernel to do, but once you're back in userspace
>> you immediately regain "hard" isolation.  It's under program control.
>>
>> Or, you can enable "strict" mode, and then you get hard isolation
>> without the ability to get in and out of the kernel at all: the kernel
>> just kills you if you try to leave hard isolation other than by an
>> explicit prctl().
> Well, hard isolation is what I would call strict mode.

Here's what I am inclined towards:

  - Default mode (hard isolation / "strict") - leave userspace, get a signal, no exceptions.

  - "No signal" mode - leave userspace synchronously (syscall/exception), get quiesced on
    return, no signals.  But asynchronous interrupts still cause a signal since they are
    not expected to occur.

  - Soft mode (I don't think we want this) - like "no signal" except you don't even quiesce
    on return to userspace, and asynchronous interrupts don't even cause a signal.
    It's basically "best effort", just nohz_full plus the code that tries to get things
    like LRU or vmstat to run before returning to userspace.  I think there isn't enough
    "value add" to make this a separate mode, though.

>>> Surely we can have different levels of isolation.
>> Well, we have nohz_full now, and by adding task-isolation, we have
>> two.  Or three if you count "base" and "strict" mode task isolation as
>> two separate levels.
> Right.
>
>>> I'm still wondering what to do if the task migrates to another CPU. In fact,
>>> perhaps what you're trying to do is rather a CPU property than a
>>> process property?
>> Well, we did go around on this issue once already (last August) and at
>> the time you were encouraging isolation to be a "task" property, not a
>> "cpu" property:
>>
>> https://lkml.kernel.org/r/20150812160020.GG21542@lerouge
>>
>> You convinced me at the time :-)
> Indeed :-) Well if it's a task property, we need to handle its affinity properly then.
>> You're right that migration conflicts with task isolation.  But
>> certainly, if a task has enabled "strict" semantics, it can't migrate;
>> it will lose task isolation entirely and get a signal instead,
>> regardless of whether it calls sched_setaffinity() on itself, or if
>> someone else changes its affinity and it gets a kick.
> Yes.
>
>> However, if a task doesn't have strict mode enabled, it can call
>> sched_setaffinity() and force itself onto a non-task_isolation cpu and
>> it won't get any isolation until it schedules itself back onto a
>> task_isolation cpu, at which point it wakes up on the new cpu with
>> hard isolation still in effect.  I can make up reasons why this sort
>> of thing might be useful, but it's probably a corner case.
> That doesn't look sane. The user asks the kernel to get away as much
> as it can but if we are in a non-nohz-full CPU we know we can't provide that
> service (or rather that non-service).
>
> So we would refuse to enter in task isolation mode if it doesn't run in a
> full dynticks CPUs whereas we accept that it migrates later to a periodic
> CPU?. This isn't consistent.

Yes, and originally I made that consistent by not checking when it started
up, either, but I was subsequently convinced that the checks were good for
sanity.

Another answer is just to say that the full strict mode is the only mode, and
that if the task leaves userspace, it leaves task isolation mode until it the mode
is re-enabled.  In the context of receiving a signal each time, this is more plausible.
You can always re-enable task isolation in the signal handler if you want.

I still suspect that the "hybrid" mode where you can leave userspace for things
like syscalls, but quiesce on return, is useful.  I agree that it leaves some question
about task migration.  We can refuse to honor a task's request to migrate itself
in that case, perhaps.  I don't know what to think about when someone else tries
to migrate the task - perhaps it only succeeds if the caller is root, and otherwise
fails, when the task is in task isolation mode?  It gets tricky and that's why I
was inclined to go with a simple "it always works, but it produces results
that you have to read the documentation to understand" (i.e. task isolation
mode goes dormant until you schedule back to a task isolation cpu).
On balance this is still the approach that I like best.

Which approach seems best to you?

>> However, this makes me wonder if "strict" mode should be the default
>> for task isolation??  That way task isolation really doesn't conflict
>> semantically with migration.  And we could provide a "weak" mode, or a
>> "kernel-friendly" mode, or some such nomenclature, and define the
>> migration semantics just for that case, where it makes it clear it's a
>> bit unusual.
> Well we can't really implement that strict mode until we fix the 1Hz issue, right?
> Besides, is this something that anyone needs now?

Certainly all of this is assuming that we have "solved" the 1Hz tick problem,
either by commenting out the max_deferment call, or at such time as we have
really fixed the underlying issues and remove the max deferment entirely.

At that point, I'm not sure it's a question of people needing strict mode per se;
I think it's more about picking the mode that is the best from both a user experience
and a quality of implementation perspective.

>>> I think I heard about workloads that need such strict hard isolation.
>>> Workloads that really can not afford any disturbance. They even
>>> use userspace network stack. Maybe HFT?
>> Certainly HFT is one case.
>>
>> A lot of TILE-Gx customers using task isolation (which we call
>> "dataplane" or "Zero-Overhead Linux") are doing high-speed network
>> applications with user-space networking stacks.  It can be DPDK, or it
>> can be another TCP/IP stack (we ship one called tStack) or it
>> could just be an application directly messing with the network
>> hardware from userspace.  These are exactly the applications that led
>> me into this part of kernel development in the first place.
>> Googling "Zero-Overhead Linux" does take you to some discussions
>> of customers that have used this functionality.
> So those workloads couldn't stand an interrupt? Like they would like a signal
> and exit the strict mode if it happens?

Correct, they couldn't tolerate interrupts.  If one happened, it would cause packets to
be dropped and some kind of logging would fire to report the problem.

> I think that we need to wait for somebody who explicitly request that feature
> before we work on it, so we get sure the semantics really agree with someone's
> real load case.

This is really the scenario that Tilera's customers use, so I'm pretty familiar with
what they expect.

>>>> I think we can actually make both modes available to users with just
>>>> another flag bit, so maybe we can look at what that looks like in v11:
>>>> adding a PR_TASK_ISOLATION_ONESHOT flag would turn off task
>>>> isolation at the next syscall entry, page fault, etc.  Then we can
>>>> think more specifically about whether we want to remove the flag or
>>>> not, and if we remove it, whether we want to make the code that was
>>>> controlled by it unconditionally true or unconditionally false
>>>> (i.e. remove it again).
>>> I think we shouldn't bother with strict hard isolation if we don't need
>>> it yet. The implementation may well be invasive. Lets wait for someone
>>> who really needs it.
>> I'm not sure what part of the patch series you're saying you don't
>> think we need yet.  I'd argue the whole patch series is "hard
>> isolation", and that the "strict" mode introduced in patch 06/13 isn't
>> particularly invasive.
> It's not in the patch series, I'm talking about the strict mode :-)
>
>>> So your requirements are actually hard isolation but in userspace?
>> Yes, exactly.  Were you thinking about a kernel-level hard isolation?
>> That would have some similarities, I guess, but in some ways might
>> actually be a harder problem.
>>
>>> And what happens if you get interrupted in userspace? What about page
>>> faults and other exceptions?
>> See above :-)
>>
>> I hope we're converging here.  If you want to talk live or chat online
>> to help finish converging, perhaps that would make sense?  I'd be
>> happy to take notes and publish a summary of wherever we get to.
>>
>> Thanks for taking the time to review this!
> Ok, so thinking about that talk, I'm wondering if we need some flags
> such as:
>
>           ISOLATION_SIGNAL_SYSCALL
>           ISOLATION_SIGNAL_EXCEPTIONS
>           ISOLATION_SIGNAL_INTERRUPTS
>
> Strict mode would be the three above OR'ed. It's just some random thoughts
> but that would help define which level of kernel intrusion the user is ready
> to tolerate.
>
> I'm just not sure how granular we want that interface to be.

Yes, you could certainly imagine being more granular.  For example, if you expected
to make syscalls but not receive exceptions or interrupts, that might be a useful
mode.  Or, you were willing to make syscalls and take exceptions, but not receive
interrupts.  (I think you should never be willing to receive asynchronous interrupts,
since that kind of defeats the purpose of task isolation in the first place.)

So maybe something like this:

PR_TASK_ISOLATION_ENABLE - turn on basic strict/signaling mode
PR_TASK_ISOLATION_ALLOW_SYSCALLS - for syscalls, no signal, just quiesce before return
PR_TASK_ISOLATION_ALLOW_EXCEPTIONS - for all exceptions, no signal, quiesce before return

It might make sense to say you would allow page faults, for example, but not general
exceptions.  But my guess is that the exception-related stuff really does need an
application use case to account for it.  I would say for the initial support of task
isolation, we have a clearly-understood model for allowing syscalls (e.g. stuff
like generating diagnostics on error or slow paths), but not really a model for
understanding why users would want to take exceptions, so I'd say let's omit
that initially, and maybe just add the _ALLOW_SYSCALLS flag.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

