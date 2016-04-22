From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 22 Apr 2016 15:16:43 +0200
Message-ID: <20160422131642.GA27722@lerouge>
References: <20160119154214.GA2722@lerouge>
 <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge>
 <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge>
 <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge>
 <56E07BF0.3060509@mellanox.com>
 <20160408135622.GD24956@lerouge>
 <5707DDA8.10600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5707DDA8.10600@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 08, 2016 at 12:34:48PM -0400, Chris Metcalf wrote:
> On 4/8/2016 9:56 AM, Frederic Weisbecker wrote:
> >On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
> >>   TL;DR: Let's make an explicit decision about whether task isolation
> >>   should be "persistent" or "one-shot".  Both have some advantages.
> >>   =====
> >>
> >> An important high-level issue is how "sticky" task isolation mode is.
> >> We need to choose one of these two options:
> >>
> >> "Persistent mode": A task switches state to "task isolation" mode
> >> (kind of a level-triggered analogy) and stays there indefinitely.  It
> >> can make a syscall, take a page fault, etc., if it wants to, but the
> >> kernel protects it from incurring any further asynchronous interrupts.
> >> This is the model I've been advocating for.
> >
> >But then in this mode, what happens when an interrupt triggers.
> 
> So here I'm taking "interrupt" to mean an external, asynchronous
> interrupt, from another core or device, or asynchronously triggered
> on the local core, like a timer interrupt.  By contrast I use "exception"
> or "fault" to refer to synchronous, locally-triggered interruptions.

Ok.

> So for interrupts, the short answer is, it's a bug! :-)
> 
> An interrupt could be a kernel bug, in which case we consider it a
> "true" bug.  This could be a timer interrupt occurring even after the
> task isolation code thought there were none pending, or a hardware
> device that incorrectly distributes interrupts to a task-isolation
> cpu, or a global IPI that should be sent to fewer cores, or a kernel
> TLB flush that could be deferred until the task-isolation task
> re-enters the kernel later, etc.  Regardless, I'd consider it a kernel
> bug.  I'm sure there are more such bugs that we can continue to fix
> going forward; it depends on how arbitrary you want to allow code
> running on other cores to be.  For example, can another core unload a
> kernel module without interrupting a task-isolation task?  Not right now.
> 
> Or, it could be an application bug: the standard example is if you
> have an application with task-isolated cores that also does occasional
> unmaps on another thread in the same process, on another core.  This
> causes TLB flush interrupts under application control.  The
> application shouldn't do this, and we tell our customers not to build
> their applications this way.  The typical way we encourage our
> customers to arrange this kind of "multi-threading" is by having a
> pure memory API between the task isolation threads and what are
> typically "control" threads running on non-task-isolated cores.  The
> two types of threads just both mmap some common, shared memory but run
> as different processes.
> 
> So what happens if an interrupt does occur?
> 
> In the "base" task isolation mode, you just take the interrupt, then
> wait to quiesce any further kernel timer ticks, etc., and return to
> the process.  This at least limits the damage to being a single
> interruption rather than potentially additional ones, if the interrupt
> also caused timers to get queued, etc.

So if we take an interrupt that we didn't expect, we want to wait some more
in the end of that interrupt to wait for things to quiesce some more?

That doesn't look right. Things should be quiesced once and for all on
return from the initial prctl() call. We can't even expect to quiesce more
in case of interruptions, the tick can't be forced off anyway.

> 
> If you enable "strict" mode, we disable task isolation mode for that
> core and deliver a signal to it.  This lets the application know that
> an interrupt occurred, and it can take whatever kind of logging or
> debugging action it wants to, re-enable task isolation if it wants to
> and continue, or just exit or abort, etc.

That sounds sensible.

> 
> If you don't enable "strict" mode, but you do have
> task_isolation_debug enabled as a boot flag, you will at least get a
> console dump with a backtrace and whatever other data we have.
> (Sometimes the debug info actually includes a backtrace of the
> interrupting core, if it's an IPI or TLB flush from another core,
> which can be pretty useful.)

Ok.

> 
> >> "One-shot mode": A task requests isolation via prctl(), the kernel
> >> ensures it is isolated on return from the prctl(), but then as soon as
> >> it enters the kernel again, task isolation is switched off until
> >> another prctl is issued.  This is what you recommended in your last
> >> email.
> >
> >No I think we can issue syscalls for exemple. But asynchronous interruptions
> >such as exceptions (actually somewhat synchronous but can be unexpected) and
> >interrupts are what we want to avoid.
> 
> Hmm, so I think I'm not really understanding what you are suggesting.
> 
> We're certainly in agreement that avoiding interrupts and exceptions
> is important.  I'm arguing that the way to deal with them is to
> generate appropriate signals/printks, etc.  I'm not actually sure what
> you're recommending we do to avoid exceptions.  Since they're
> synchronous and deterministic, we can't really avoid them if the
> program wants to issue them.  For example, mmap() some anonymous
> memory and then start running, and you'll take exceptions each time
> you touch a page in that mapped region.  I'd argue it's an application
> bug; one should enable "strict" mode to catch and deal with such bugs.

Ok, that looks right.

> 
> (Typically the recommendation is to do an mlockall() before starting
> task isolation mode, to handle the case of page faults.  But you can
> do that and still be screwed by another thread in your process doing a
> fork() and then your pages end up read-only for COW and you have to
> fault them back in.  But, that's an application bug for a
> task-isolation thread, and should just be treated as such.)

Ok.

> 
> >> There are a number of pros and cons to the two models.  I think on
> >> balance I still like the "persistent mode" approach, but here's all
> >> the pros/cons I can think of:
> >>
> >> PRO for persistent mode: A somewhat easier programming model.  Users
> >> can just imagine "task isolation" as a way for them to still be able
> >> to use the kernel exactly as they always have; it's just slower to get
> >> back out of the kernel so you use it judiciously. For example, a
> >> process is free to call write() on a socket to perform a diagnostic,
> >> but when returning from the write() syscall, the kernel will hold the
> >> task in kernel mode until any timer ticks (perhaps from networking
> >> stuff) are complete, and then let it return to userspace to continue
> >> in task isolation mode.
> >
> >So this is not hard isolation anymore. This is rather soft isolation with
> >best efforts to avoid disturbance.
> 
> No, it's still hard isolation.  The distinction is that we offer a way
> to get in and out of the kernel "safely" if you want to run in that
> mode.  The syscalls can take a long time if the syscall ends up
> requiring some additional timer ticks to finish sorting out whatever
> it was you asked the kernel to do, but once you're back in userspace
> you immediately regain "hard" isolation.  It's under program control.

Yeah indeed, task should be allowed to perform syscalls. So we can assume
that interrupts are fine when they fire in kernel mode.

> 
> Or, you can enable "strict" mode, and then you get hard isolation
> without the ability to get in and out of the kernel at all: the kernel
> just kills you if you try to leave hard isolation other than by an
> explicit prctl().

That would be extreme strict mode yeah. We can still add such mode later
if any user request it.

Thanks.

(I'll reply the rest of the email soonish)
