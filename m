From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Fri, 8 Apr 2016 15:56:24 +0200
Message-ID: <20160408135622.GD24956@lerouge>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <1451936091-29247-5-git-send-email-cmetcalf@ezchip.com>
 <20160119154214.GA2722@lerouge>
 <569EA050.5030106@ezchip.com>
 <20160128002801.GA14313@lerouge>
 <56ABACDD.5090500@ezchip.com>
 <20160130211125.GB7856@lerouge>
 <56BCDFE9.10200@ezchip.com>
 <20160304125603.GA23906@lerouge>
 <56E07BF0.3060509@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E07BF0.3060509@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 09, 2016 at 02:39:28PM -0500, Chris Metcalf wrote:
> Frederic,
> 
> Thanks for the detailed feedback on the task isolation stuff.
> 
> This reply kind of turned into an essay, so I've added a little "TL;DR"
> sentence before each section.

I think I'm going to cut my reply into several threads, because really
I can't get myself to make a giant reply in once :-)

> 
> 
>   TL;DR: Let's make an explicit decision about whether task isolation
>   should be "persistent" or "one-shot".  Both have some advantages.
>   =====
> 
> An important high-level issue is how "sticky" task isolation mode is.
> We need to choose one of these two options:
> 
> "Persistent mode": A task switches state to "task isolation" mode
> (kind of a level-triggered analogy) and stays there indefinitely.  It
> can make a syscall, take a page fault, etc., if it wants to, but the
> kernel protects it from incurring any further asynchronous interrupts.
> This is the model I've been advocating for.

But then in this mode, what happens when an interrupt triggers.

> 
> "One-shot mode": A task requests isolation via prctl(), the kernel
> ensures it is isolated on return from the prctl(), but then as soon as
> it enters the kernel again, task isolation is switched off until
> another prctl is issued.  This is what you recommended in your last
> email.

No I think we can issue syscalls for exemple. But asynchronous interruptions
such as exceptions (actually somewhat synchronous but can be unexpected) and
interrupts are what we want to avoid.

> 
> There are a number of pros and cons to the two models.  I think on
> balance I still like the "persistent mode" approach, but here's all
> the pros/cons I can think of:
> 
> PRO for persistent mode: A somewhat easier programming model.  Users
> can just imagine "task isolation" as a way for them to still be able
> to use the kernel exactly as they always have; it's just slower to get
> back out of the kernel so you use it judiciously. For example, a
> process is free to call write() on a socket to perform a diagnostic,
> but when returning from the write() syscall, the kernel will hold the
> task in kernel mode until any timer ticks (perhaps from networking
> stuff) are complete, and then let it return to userspace to continue
> in task isolation mode.

So this is not hard isolation anymore. This is rather soft isolation with
best efforts to avoid disturbance.

Surely we can have different levels of isolation.

I'm still wondering what to do if the task migrates to another CPU. In fact,
perhaps what you're trying to do is rather a CPU property than a process property?

> This is convenient to the user since they
> don't have to fret about re-enabling task isolation after that
> syscall, page fault, or whatever; they can just continue running.
> With your suggestion, the user pretty much has to leave STRICT mode
> enabled so he gets notified of any unexpected return to kernel space
> (in fact we might make it required so you always get a signal when
> leaving task isolation unless it's via a prctl or exit syscall).

Right. Although we can allow all syscalls in this mode actually.

> 
> PRO for one-shot mode: A somewhat crisper interaction with
> sched_setaffinity() etc.  With a persistent mode approach, a task can
> start up task isolation, then later another task can be placed on its
> cpu and break it (it won't return to userspace until killed or the new
> process affinitizes itself away or stops running).  By contrast, in
> one-shot mode, any return to kernel spaces turns off task isolation
> anyway, so it's very clear what the interaction looks like.  I suspect
> this is more a theoretical advantage to one-shot mode than a practical
> one, though.

I think I heard about workloads that need such strict hard isolation.
Workloads that really can not afford any disturbance. They even
use userspace network stack. Maybe HFT?

> CON for one-shot mode: It's actually hard to catch every kernel entry
> so we can turn the task-isolation flag off again - and we really do
> need to have a flag, just so that we can suitably debug any bad
> actions that bring us into the kernel when we're not expecting it.
> Right now there are things that bring us into the kernel that we don't
> bother annotating for task isolation STRICT mode, just because they're
> visible to the user anyway: e.g., a bus fault or segmentation
> violation.
> 
> I think we can actually make both modes available to users with just
> another flag bit, so maybe we can look at what that looks like in v11:
> adding a PR_TASK_ISOLATION_ONESHOT flag would turn off task
> isolation at the next syscall entry, page fault, etc.  Then we can
> think more specifically about whether we want to remove the flag or
> not, and if we remove it, whether we want to make the code that was
> controlled by it unconditionally true or unconditionally false
> (i.e. remove it again).

I think we shouldn't bother with strict hard isolation if we don't need
it yet. The implementation may well be invasive. Lets wait for someone
who really needs it.

> 
> 
>   TL;DR: We should be more willing to return -EINVAL from prctl().
>   =====
> 
> One thing you've argued is that we should be more aggressive about
> failing the prctl() call.  I think, in any case, that this is probably
> reasonable.  We already check that the task's affinity is limited to
> the current core and that that core is a task_isolation cpu; I think we
> can also require that can_stop_full_tick() return true (or the moral
> equivalent given your recent patch series).  This will mean you can't
> even try to go into task isolation mode if another task is
> schedulable, among other things, which seems like a good thing.
> 
> However, it is important to note that the current task_isolation_ready
> and task_isolation_enter calls that are in the prepare_exit_to_userspace
> routine are still required even with your proposed one-shot mode.  We
> have to be sure that no interrupts occur on the way back to userspace
> that might then in principle lead to timer interrupts being scheduled,
> and the way to do that is make sure task_isolation_ready returns true
> with interrupts disabled, and interrupts are not then re-enabled before
> return to userspace.  Anything else is just keeping your fingers
> crossed and guessing.

So your requirements are actually hard isolation but in userspace?

And what happens if you get interrupted in userspace? What about page
faults and other exceptions?

Thanks.
