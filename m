From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v7 02/11] task_isolation: add initial support
Date: Thu, 1 Oct 2015 13:02:29 -0400
Message-ID: <560D6725.9000609@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-3-git-send-email-cmetcalf@ezchip.com>
 <20151001121414.GB3432@lerouge> <alpine.DEB.2.11.1510011416160.4500@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1510011416160.4500@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/01/2015 08:18 AM, Thomas Gleixner wrote:
> On Thu, 1 Oct 2015, Frederic Weisbecker wrote:
>> On Mon, Sep 28, 2015 at 11:17:17AM -0400, Chris Metcalf wrote:
>>> +
>>> +	while (READ_ONCE(dev->next_event.tv64) != KTIME_MAX) {
>> You should add a function in tick-sched.c to get the next tick. This
>> is supposed to be a private field.
> Just to make it clear. Neither the above nor a similar check in
> tick-sched.c is going to happen.
>
> This busy waiting is just horrible. Get your act together and solve
> the problems at the root and do not inflict your quick and dirty
> 'solutions' on us.

Thomas,

You've raised a couple of different concerns and I want to
make sure I try to address them individually.

But first I want to address the question of the basic semantics
of the patch series.  I wrote up a description of why it's useful
in my email yesterday:

https://lkml.kernel.org/r/560C4CF4.9090601@ezchip.com

I haven't directly heard from you as to whether you buy the
basic premise of "hard isolation" in terms of protecting tasks
from all kernel interrupts while they execute in userspace.

I will add here that we've heard from multiple customers that
the equivalent Tilera functionality (Zero-Overhead Linux) was
the thing that brought them to buy our hardware rather than a
competitor's.  It's allowed them to write code that runs under
a full-featured Linux environment rather than doing the thing
that they otherwise would have been required to do, which is
to target a minimal bare-metal environment.  So as a feature,
if we can gain consensus on an implementation of it, I think it
will be an important step for that class of users, and potential
users, of Linux.

So I first want to address what is effectively the API concern that
you raised, namely that you're concerned that there is a wait
loop in the implementation.

The nice thing here is that there is in fact no requirement in
the API/ABI that we have a wait loop in the kernel at all.  Let's
say hypothetically that in the future we come up with a way to
guarantee, perhaps in some constrained kind of way, that you
can enter and exit the kernel and are guaranteed no further
timer interrupts, and we are so confident of this property that
we don't have to test for it programmatically on kernel exit.
(In fact, we would likely still use the task_isolation_debug boot
flag to generate a console warning if it ever did happen, but
whatever.)  At this point we could simply remove the timer
interrupt test loop in task_isolation_wait(); the applications would
be none the wiser, and the kernel would be that much cleaner.

However, today, and I think for the future, I see that loop as an
important backstop for whatever timer-elimination coding happens.
In general, the hard task-isolation requirement is something that
is of particular interest only to a subset of the kernel community.
As the kernel grows, adds features, re-implements functionality,
etc., it seems entirely likely that odd bits of deferred functionality
might be added in the same way that RCU, workqueues, etc., have
done in the past.  Or, applications might exercise unusual corners
of the kernel's semantics and come across an existing mechanism
that ends up enabling kernel ticks (maybe only one or two) before
returning to userspace.  The proposed busy-loop just prevents
that from damaging the application.  I'm skeptical that we can
prevent all such possible changes today and in the future, and I
think the loop is a simple way of arranging to avoid breaking applications
with interrupts, that only triggers for applications that have
requested it, on cores that have been configured to support it.

One additional insight that argues in favor of a busy-waiting solution
is that a task that requests task isolation is almost certainly alone
on the core.  If multiple tasks are in fact runnable on that core,
we have already abandoned the ability to use proper task isolation
since we will want to use timer ticks to run the scheduler for
pre-emption.  So we only busy wait when, in fact, no other useful
work is likely to get done on that core anyway.

The other questions you raise have to do with the mechanism for
ensuring that we wait until no timer interrupts are scheduled.

First is the question of how we detect that case.

As I said yesterday, the original approach I chose for the Tilera
implementation was one where we simply wait until the timer interrupt
is masked (as is done via the set_state_shutdown, set_state_oneshot,
and tick_resume callbacks in the tile clock_event_device).  When
unmasked, the timer down-counter just counts down to zero,
fires the interrupt, resets to its start value, and counts down again
until it fires again.  So we use masking of the interrupt to turn off
the timer tick.  Once we have done so, we are guaranteed no
further timer interrupts can occur.  I'm less familiar with the timer
subsystems of other architectures, but there are clearly per-platform
ways to make the same kinds of checks.  If this seems like a better
approach, I'm happy to work to add the necessary checks on
tile, arm64, and x86, though I'd certainly benefit from some
guidance on the timer implementation on the latter two platforms.

One reason this might be necessary is if there is support on some
platforms for multiple timer interrupts any of which can fire, not just
a single timer driven by the clock_event_device.  I'm not sure whether
this is ever in fact a problem, but if it is, that would seem like it would
almost certainly require per-architecture code to determine whether
all the relevant timers were quiesced.

However, I'm not sure whether you don't like the fact of checking
the next_event in tick_cpu_device per se, or if it's the busy-waiting
we do when it indicates a pending timer that bothers you.  If you could
help clarify this piece, that would be good.

The last question is what to do when we detect that there is a timer
interrupt scheduled.  The current code spins, testing for resched
or signal events, and bails out back to the work-pending loop when
that happens.  As an extension, one can add support for spinning in
a lower-power state, as I did for tile, but this isn't required and frankly
isn't that important, since we don't anticipate spending much time in
the busy-loop state anyway.

The suggestion proposed by Frederic and echoed by you is a wake-wait
scheme.  I'm curious to hear a more fully fleshed-out suggestion.
Clearly, we can test for pending timer interrupts and put the task to
sleep (pretty late in the return-to-userspace process, but maybe that's
OK).  The question is, how and when do we wake the task?  We could
add a hook to the platform timer shutdown code that would also wake
any process that was waiting for the no-timer case; that process would
then end up getting scheduled sometime later, and hopefully when it
came time for it to try exiting to userspace again, the timer would still
be shutdown.

This could be problematic if the scheduler code or some other part of
the kernel sets up the timer again before scheduling the waiting task
back in.  Arguably we can work to avoid this if it's really a problem.
And, there is the question of how to handle multiple timer interrupt
sources, since they would all have to quiesce before we would want to
wake the waiting process, but the "multiple timers" isn't handled by
the current code either, and it seems not to be a problem, so perhaps
that's OK.  Lastly, of course, is the question of what the kernel would
end up doing while waiting: and the answer is almost certainly that it
would sit in the cpu idle loop, waiting for the pending timer to fire and
wake the waiting task.  I'm not convinced that the extra complexity here
is worth the gain.

But I am open and willing to being convinced that I am wrong, and to
implement different approaches.  Let me know!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

