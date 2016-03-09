From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Wed, 9 Mar 2016 14:39:28 -0500
Message-ID: <56E07BF0.3060509@mellanox.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160304125603.GA23906@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Frederic,

Thanks for the detailed feedback on the task isolation stuff.

This reply kind of turned into an essay, so I've added a little "TL;DR"
sentence before each section.


   TL;DR: Let's make an explicit decision about whether task isolation
   should be "persistent" or "one-shot".  Both have some advantages.
   =====

An important high-level issue is how "sticky" task isolation mode is.
We need to choose one of these two options:

"Persistent mode": A task switches state to "task isolation" mode
(kind of a level-triggered analogy) and stays there indefinitely.  It
can make a syscall, take a page fault, etc., if it wants to, but the
kernel protects it from incurring any further asynchronous interrupts.
This is the model I've been advocating for.

"One-shot mode": A task requests isolation via prctl(), the kernel
ensures it is isolated on return from the prctl(), but then as soon as
it enters the kernel again, task isolation is switched off until
another prctl is issued.  This is what you recommended in your last
email.

There are a number of pros and cons to the two models.  I think on
balance I still like the "persistent mode" approach, but here's all
the pros/cons I can think of:

PRO for persistent mode: A somewhat easier programming model.  Users
can just imagine "task isolation" as a way for them to still be able
to use the kernel exactly as they always have; it's just slower to get
back out of the kernel so you use it judiciously.  For example, a
process is free to call write() on a socket to perform a diagnostic,
but when returning from the write() syscall, the kernel will hold the
task in kernel mode until any timer ticks (perhaps from networking
stuff) are complete, and then let it return to userspace to continue
in task isolation mode.  This is convenient to the user since they
don't have to fret about re-enabling task isolation after that
syscall, page fault, or whatever; they can just continue running.
With your suggestion, the user pretty much has to leave STRICT mode
enabled so he gets notified of any unexpected return to kernel space
(in fact we might make it required so you always get a signal when
leaving task isolation unless it's via a prctl or exit syscall).

PRO for one-shot mode: A somewhat crisper interaction with
sched_setaffinity() etc.  With a persistent mode approach, a task can
start up task isolation, then later another task can be placed on its
cpu and break it (it won't return to userspace until killed or the new
process affinitizes itself away or stops running).  By contrast, in
one-shot mode, any return to kernel spaces turns off task isolation
anyway, so it's very clear what the interaction looks like.  I suspect
this is more a theoretical advantage to one-shot mode than a practical
one, though.

CON for one-shot mode: It's actually hard to catch every kernel entry
so we can turn the task-isolation flag off again - and we really do
need to have a flag, just so that we can suitably debug any bad
actions that bring us into the kernel when we're not expecting it.
Right now there are things that bring us into the kernel that we don't
bother annotating for task isolation STRICT mode, just because they're
visible to the user anyway: e.g., a bus fault or segmentation
violation.

I think we can actually make both modes available to users with just
another flag bit, so maybe we can look at what that looks like in v11:
adding a PR_TASK_ISOLATION_ONESHOT flag would turn off task
isolation at the next syscall entry, page fault, etc.  Then we can
think more specifically about whether we want to remove the flag or
not, and if we remove it, whether we want to make the code that was
controlled by it unconditionally true or unconditionally false
(i.e. remove it again).


   TL;DR: We should be more willing to return -EINVAL from prctl().
   =====

One thing you've argued is that we should be more aggressive about
failing the prctl() call.  I think, in any case, that this is probably
reasonable.  We already check that the task's affinity is limited to
the current core and that that core is a task_isolation cpu; I think we
can also require that can_stop_full_tick() return true (or the moral
equivalent given your recent patch series).  This will mean you can't
even try to go into task isolation mode if another task is
schedulable, among other things, which seems like a good thing.

However, it is important to note that the current task_isolation_ready
and task_isolation_enter calls that are in the prepare_exit_to_userspace
routine are still required even with your proposed one-shot mode.  We
have to be sure that no interrupts occur on the way back to userspace
that might then in principle lead to timer interrupts being scheduled,
and the way to do that is make sure task_isolation_ready returns true
with interrupts disabled, and interrupts are not then re-enabled before
return to userspace.  Anything else is just keeping your fingers
crossed and guessing.


   TL;DR: Returning -EBUSY from prctl() isn't really that helpful.
   =====

Frederic wonders if we can test for various things not being ready
(dynticks not off yet, etc) and just return -EBUSY and let userspace
do the spinning.

First, note that this is only possible for one-shot mode.  For
persistent mode, we have the potential to run up against this on
return from any syscall, and we obviously can't add new error returns
to other syscalls.  So it doesn't really make sense to add EBUSY
semantics to prctl if nothing else can use it.

But even in one-shot mode, I'm not really sure what the advantage is
here.  We still need to do something like task_isolation_ready() in
the prepare_exit_to_usermode() loop, since that's where we have
interrupts disabled and can do a final assessment of the state of the
kernel for this core.  So, while you could imagine having that code
just hook in and call syscall_set_return_value() there instead of
causing things to loop back, that doesn't really save us much
complexity in the kernel, and instead pushes complexity back to
userspace, which may well handle it just by busywaiting on the prctl()
anyway.  You might argue that if we just return to userspace, userspace
can sleep briefly and retry, thus avoiding spinning in the scheduler.
But it's relatively easy to do that (or better) in the kernel, so I'm
not sure that's more than a straw man.  See the next point.


   TL;DR: Should we arrange to actually use a completion in
   task_isolation_enter when dynticks are ticking, and call complete()
   in tick-sched.c when we shut down dynticks, or, just spin in
   schedule() and not worry about burning a little cpu?
   =====

One question that keeps getting asked is how useful it is to just call
schedule() while we're waiting for dynticks to shut off, since it
could just be a busy spin going into schedule() over and over.  Even
if another task is ready to run we might not switch to it right away.
So one thing we could think about is arranging so that whenever we
turn off dynticks, we also notify any tasks that were waiting for it
to be turned off; that way we can just sleep in task_isolation_enter()
and wait to be notified, thus guaranteeing any other task that wants
to run can run, or even just waiting in cpu idle for a little while.
Does this seem like it's worth coding up?  My impression has always
been that we wait pretty briefly for dynticks to shut down, so it
doesn't really matter if we spin - and even if we do spin, in
principle we already arranged for this cpu to be dedicated to this
task anyway, so it doesn't really do anything bad except maybe burn a
little bit of extra cpu power.  But I'm willing to be convinced...


   TL;DR: We should turn off task isolation mode for signals.
   =====

One thing that occurs to me is that we should arrange so that
any signal delivery turns off task isolation mode.  This is
easily documented semantics even in persistent mode, and it
allows the userspace program to run and discover that something bad
has happened, rather than potentially hanging in the kernel trying to
wait for isolation to be possible before calling the signal handler.
I'll make this change for v11 in any case.

Also, doing this is something of a requirement for the proposed
one-shot mode, since if we have STRICT mode enabled, then any entry
into the kernel is either a syscall, or else ends up causing a signal,
and by hooking the signal mechanism we have a place to catch all the
non-syscall entrypoints, more or less.


   TL;DR: Maybe we should use seccomp for STRICT mode syscall detection.
   =====

This is being investigated in a separate email thread with Andy
Lutomirski.  Whether it gets included in v11 is still TBD.


   TL;DR: Various minor issues in answer to Frederic's comments :-)
   =====

On 03/04/2016 07:56 AM, Frederic Weisbecker wrote:
> On Thu, Feb 11, 2016 at 02:24:25PM -0500, Chris Metcalf wrote:
>> We don't want to wait for preemption points or interrupts, and there are
>> no other voluntary reschedules in the prepare_exit_to_usermode() loop.
>>
>> If the other task had been woken up for some completion, then yes we would
>> already have had TIF_RESCHED set, but if the other runnable task was (for
>> example) pre-empted on a timer tick, we wouldn't have TIF_RESCHED set at
>> this point, and thus we might need to call schedule() explicitly.
>
> There can't be another task in the runqueue waiting to be preempted since
> we (the current task) are running on the CPU.

My earlier sentence may not have been clear.  By saying "if the other
runnable task was pre-empted on a timer tick", I meant that
TIF_RESCHED wasn't set on our task, and we'd only eventually schedule
to that other task once a timer interrupt fired and ended our
scheduler slice.  I know you can't have a different task in the
runqueue waiting to be preempted, since that doesn't make sense :-)

> Besides, if we aren't alone in the runqueue, this breaks the task isolation
> mode.

Indeed.  We can and will do better catching that at prctl() time.
So the question is, if we adopt the "persistent mode", how do we
handle this case on some other return from kernel space?

>>>> By invoking the scheduler here, we allow any tasks that are ready to run to run
>>>> immediately, rather than waiting for an interrupt to wake the scheduler.
>>> Well, in this case here we are interested in the current CPU. And if a task
>>> got awoken and waits for the current CPU, it will have an opportunity to get
>>> schedule on syscall exit.
>>
>> That's true if TIF_RESCHED was set because a completion occurred that
>> the other task was waiting for.  But there might not be any such completion
>> and the task just got preempted earlier and is still ready to run.
>
> But if another task waits for the CPU, this break task isolation mode. Now
> assuming we want a pending task to resume such that we get the CPU for ourself,
> we have no idea if the scheduler is going to schedule that task, it depends on
> vruntime and other things. TIF_RESCHED only make entering the scheduler, it doesn't
> guarantee any context switch.

Yes, true.  So we have to decide if we feel spinning into the
scheduler is so harmful that we should set up a new completion driven
by entering dynticks fullmode, and handle it that way instead.

>> My point is that setting TIF_RESCHED is never harmful, and there are
>> cases like involuntary preemption where it might help.
>
> Sure but we don't write code just because it doesn't harm. Strange code hurts
> the brain of reviewers.

Fair enough, and certainly means at a minimum we need a good comment there!

> Now concerning involuntary preemption, it's a matter of a millisecond, userspace
> needs to wait a few millisecond before retrying anyway. Sleeping at that point is
> what can be useful as we leave the CPU for the resuming task.
>
> Also if we have any task on the runqueue anyway, whether we hope that it resumes quickly
> or not, it's a very bad sign for a task isolation session. Either we did not affine tasks
> correctly or there is a kernel thread that might run again at some time ahead.

Note that it might also be a one-time kernel task or kworker that is
queued by some random syscall in "persistent mode" and we need to let
it run until it quiesces again.  Then we can context switch back to
our task isolation task, and safely return from it to userspace.

>> (2) What about times when we are leaving the kernel after already
>> doing the prctl()?  For example a core doing packet forwarding might
>> want to report some error condition up to the kernel, and remove itself
>> from the set of cores handling packets, then do some syscall(s) to generate
>> logging data, and then go back and continue handling packets.  Or, the
>> process might have created some large anonymous mapping where
>> every now and then it needs to cross a page boundary for some structure
>> and touch a new page, and it knows to expect a page fault in that case.
>> In those cases we are returning from the kernel, not at prctl() time, and
>> we still want to enforce the semantics that no further interrupts will
>> occur to disturb the task.  These kinds of use cases are why we have
>> as general-purpose a mechanism as we do for task isolation.
>
> If any interrupt or any kind of disturbance happens, we should leave that
> task isolation mode and warn the isolated task about that. SIGTERM?

That's the goal of STRICT mode.  By default it uses SIGTERM.  You can
also choose a different signal via the prctl() API.

Thanks again, Frederic!  I'll work to put together a new version of
the patch incorporating a selectable one-shot mode, plus the other
things mentioned in this patch.  I think I will still not add the
suggested "dynticks full enabled completion" thing for now, and just
add a big comment on the code that makes us call schedule(), unless folks
really agree it's a necessary thing to have there.
-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

