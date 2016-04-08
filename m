From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 8 Apr 2016 12:34:48 -0400
Message-ID: <5707DDA8.10600@mellanox.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge> <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge> <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160408135622.GD24956@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 4/8/2016 9:56 AM, Frederic Weisbecker wrote:
> On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
> >   TL;DR: Let's make an explicit decision about whether task isolation
> >   should be "persistent" or "one-shot".  Both have some advantages.
> >   =====
> >
> > An important high-level issue is how "sticky" task isolation mode is.
> > We need to choose one of these two options:
> >
> > "Persistent mode": A task switches state to "task isolation" mode
> > (kind of a level-triggered analogy) and stays there indefinitely.  It
> > can make a syscall, take a page fault, etc., if it wants to, but the
> > kernel protects it from incurring any further asynchronous interrupts.
> > This is the model I've been advocating for.
>
> But then in this mode, what happens when an interrupt triggers.

So here I'm taking "interrupt" to mean an external, asynchronous
interrupt, from another core or device, or asynchronously triggered
on the local core, like a timer interrupt.  By contrast I use "exception"
or "fault" to refer to synchronous, locally-triggered interruptions.

So for interrupts, the short answer is, it's a bug! :-)

An interrupt could be a kernel bug, in which case we consider it a
"true" bug.  This could be a timer interrupt occurring even after the
task isolation code thought there were none pending, or a hardware
device that incorrectly distributes interrupts to a task-isolation
cpu, or a global IPI that should be sent to fewer cores, or a kernel
TLB flush that could be deferred until the task-isolation task
re-enters the kernel later, etc.  Regardless, I'd consider it a kernel
bug.  I'm sure there are more such bugs that we can continue to fix
going forward; it depends on how arbitrary you want to allow code
running on other cores to be.  For example, can another core unload a
kernel module without interrupting a task-isolation task?  Not right now.

Or, it could be an application bug: the standard example is if you
have an application with task-isolated cores that also does occasional
unmaps on another thread in the same process, on another core.  This
causes TLB flush interrupts under application control.  The
application shouldn't do this, and we tell our customers not to build
their applications this way.  The typical way we encourage our
customers to arrange this kind of "multi-threading" is by having a
pure memory API between the task isolation threads and what are
typically "control" threads running on non-task-isolated cores.  The
two types of threads just both mmap some common, shared memory but run
as different processes.

So what happens if an interrupt does occur?

In the "base" task isolation mode, you just take the interrupt, then
wait to quiesce any further kernel timer ticks, etc., and return to
the process.  This at least limits the damage to being a single
interruption rather than potentially additional ones, if the interrupt
also caused timers to get queued, etc.

If you enable "strict" mode, we disable task isolation mode for that
core and deliver a signal to it.  This lets the application know that
an interrupt occurred, and it can take whatever kind of logging or
debugging action it wants to, re-enable task isolation if it wants to
and continue, or just exit or abort, etc.

If you don't enable "strict" mode, but you do have
task_isolation_debug enabled as a boot flag, you will at least get a
console dump with a backtrace and whatever other data we have.
(Sometimes the debug info actually includes a backtrace of the
interrupting core, if it's an IPI or TLB flush from another core,
which can be pretty useful.)

> > "One-shot mode": A task requests isolation via prctl(), the kernel
> > ensures it is isolated on return from the prctl(), but then as soon as
> > it enters the kernel again, task isolation is switched off until
> > another prctl is issued.  This is what you recommended in your last
> > email.
>
> No I think we can issue syscalls for exemple. But asynchronous interruptions
> such as exceptions (actually somewhat synchronous but can be unexpected) and
> interrupts are what we want to avoid.

Hmm, so I think I'm not really understanding what you are suggesting.

We're certainly in agreement that avoiding interrupts and exceptions
is important.  I'm arguing that the way to deal with them is to
generate appropriate signals/printks, etc.  I'm not actually sure what
you're recommending we do to avoid exceptions.  Since they're
synchronous and deterministic, we can't really avoid them if the
program wants to issue them.  For example, mmap() some anonymous
memory and then start running, and you'll take exceptions each time
you touch a page in that mapped region.  I'd argue it's an application
bug; one should enable "strict" mode to catch and deal with such bugs.

(Typically the recommendation is to do an mlockall() before starting
task isolation mode, to handle the case of page faults.  But you can
do that and still be screwed by another thread in your process doing a
fork() and then your pages end up read-only for COW and you have to
fault them back in.  But, that's an application bug for a
task-isolation thread, and should just be treated as such.)

> > There are a number of pros and cons to the two models.  I think on
> > balance I still like the "persistent mode" approach, but here's all
> > the pros/cons I can think of:
> >
> > PRO for persistent mode: A somewhat easier programming model.  Users
> > can just imagine "task isolation" as a way for them to still be able
> > to use the kernel exactly as they always have; it's just slower to get
> > back out of the kernel so you use it judiciously. For example, a
> > process is free to call write() on a socket to perform a diagnostic,
> > but when returning from the write() syscall, the kernel will hold the
> > task in kernel mode until any timer ticks (perhaps from networking
> > stuff) are complete, and then let it return to userspace to continue
> > in task isolation mode.
>
> So this is not hard isolation anymore. This is rather soft isolation with
> best efforts to avoid disturbance.

No, it's still hard isolation.  The distinction is that we offer a way
to get in and out of the kernel "safely" if you want to run in that
mode.  The syscalls can take a long time if the syscall ends up
requiring some additional timer ticks to finish sorting out whatever
it was you asked the kernel to do, but once you're back in userspace
you immediately regain "hard" isolation.  It's under program control.

Or, you can enable "strict" mode, and then you get hard isolation
without the ability to get in and out of the kernel at all: the kernel
just kills you if you try to leave hard isolation other than by an
explicit prctl().

> Surely we can have different levels of isolation.

Well, we have nohz_full now, and by adding task-isolation, we have
two.  Or three if you count "base" and "strict" mode task isolation as
two separate levels.

> I'm still wondering what to do if the task migrates to another CPU. In fact,
> perhaps what you're trying to do is rather a CPU property than a
> process property?

Well, we did go around on this issue once already (last August) and at
the time you were encouraging isolation to be a "task" property, not a
"cpu" property:

https://lkml.kernel.org/r/20150812160020.GG21542@lerouge

You convinced me at the time :-)

You're right that migration conflicts with task isolation.  But
certainly, if a task has enabled "strict" semantics, it can't migrate;
it will lose task isolation entirely and get a signal instead,
regardless of whether it calls sched_setaffinity() on itself, or if
someone else changes its affinity and it gets a kick.

However, if a task doesn't have strict mode enabled, it can call
sched_setaffinity() and force itself onto a non-task_isolation cpu and
it won't get any isolation until it schedules itself back onto a
task_isolation cpu, at which point it wakes up on the new cpu with
hard isolation still in effect.  I can make up reasons why this sort
of thing might be useful, but it's probably a corner case.

However, this makes me wonder if "strict" mode should be the default
for task isolation??  That way task isolation really doesn't conflict
semantically with migration.  And we could provide a "weak" mode, or a
"kernel-friendly" mode, or some such nomenclature, and define the
migration semantics just for that case, where it makes it clear it's a
bit unusual.

> I think I heard about workloads that need such strict hard isolation.
> Workloads that really can not afford any disturbance. They even
> use userspace network stack. Maybe HFT?

Certainly HFT is one case.

A lot of TILE-Gx customers using task isolation (which we call
"dataplane" or "Zero-Overhead Linux") are doing high-speed network
applications with user-space networking stacks.  It can be DPDK, or it
can be another TCP/IP stack (we ship one called tStack) or it
could just be an application directly messing with the network
hardware from userspace.  These are exactly the applications that led
me into this part of kernel development in the first place.
Googling "Zero-Overhead Linux" does take you to some discussions
of customers that have used this functionality.

> > I think we can actually make both modes available to users with just
> > another flag bit, so maybe we can look at what that looks like in v11:
> > adding a PR_TASK_ISOLATION_ONESHOT flag would turn off task
> > isolation at the next syscall entry, page fault, etc.  Then we can
> > think more specifically about whether we want to remove the flag or
> > not, and if we remove it, whether we want to make the code that was
> > controlled by it unconditionally true or unconditionally false
> > (i.e. remove it again).
>
> I think we shouldn't bother with strict hard isolation if we don't need
> it yet. The implementation may well be invasive. Lets wait for someone
> who really needs it.

I'm not sure what part of the patch series you're saying you don't
think we need yet.  I'd argue the whole patch series is "hard
isolation", and that the "strict" mode introduced in patch 06/13 isn't
particularly invasive.

> So your requirements are actually hard isolation but in userspace?

Yes, exactly.  Were you thinking about a kernel-level hard isolation?
That would have some similarities, I guess, but in some ways might
actually be a harder problem.

> And what happens if you get interrupted in userspace? What about page
> faults and other exceptions?

See above :-)

I hope we're converging here.  If you want to talk live or chat online
to help finish converging, perhaps that would make sense?  I'd be
happy to take notes and publish a summary of wherever we get to.

Thanks for taking the time to review this!

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

