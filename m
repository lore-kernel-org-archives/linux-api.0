From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Mon, 26 Oct 2015 16:19:48 -0400
Message-ID: <562E8AE4.2030303@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
 <5626B00E.3010309@ezchip.com>
 <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
 <20151020202929.485a1ef0@grimm.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151020202929.485a1ef0@grimm.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy wrote:
> Your patches more or less implement "don't run me unless I'm
> isolated".  A scheduler class would be more like "isolate me (and
> maybe make me super high priority so it actually happens)".

Steven wrote:
> Since it only makes sense to run one isolated task per cpu (not more
> than one on the same CPU), I wonder if we should add a new interface
> for this, that would force everything else off the CPU that it
> requests. That is, you bind a task to a CPU, and then change it to
> SCHED_ISOLATED (or what not), and the kernel will force all other tasks
> off that CPU.

Frederic wrote:
> I think you'll have to make sure the task can not be concurrently
> reaffined to more CPUs. This may involve setting task_isolation_flags
> under the runqueue lock and thus move that tiny part to the scheduler
> code. And then we must forbid changing the affinity while the task has
> the isolation flag, or deactivate the flag.

These comments are all about the same high-level question, so I
want to address it in this reply.

The question is, should TASK_ISOLATION be "polite" or "aggressive"?
The original design was "polite": it worked as long as no other thing
on the system tried to mess with it.  The suggestions above are for an
"aggressive" design.

The "polite" design basically tags a task as being interested in
having the kernel help it out by staying away from it.  It relies on
running on a nohz_full cpu to keep scheduler ticks away from it.  It
relies on running on an isolcpus cpu to keep other processes from
getting dynamically load-balanced onto it and messing it up.  And, of
course, it relies on the other applications and users running on the
machine not to affinitize themselves onto its core and mess it up that
way.  But, as long as all those things are true, the kernel will try
to help it out by never interrupting it.  (And, it allows for the
kernel to report when those expectations are violated.)

The "aggressive" design would have an API that said "This is my core!".
The kernel would enforce keeping other processes off the core.  It
would require nohz_full semantics on that core.  It would lock the
task to that core in some way that would override attempts to reset
its sched_affinity.  It would do whatever else was necessary to make
that core unavailable to the rest of the system.

Advantages of the "polite" design:

- No special privileges required
- As a result, no security issues to sort through (capabilities, etc.)
- Therefore easy to use when running as an unprivileged user
- Won't screw up the occasional kernel task that needs to run

Advantages of the "aggressive" design:

- Clearer that the application will get the task isolation it wants
- More reasonable that it is enforcing kernel performance tweaks
   on the local core (e.g. flushing the per-cpu LRU cache)

The "aggressive" design is certainly tempting, but there may be other
negative consequences of this design: for example, if we need to run a
usermode helper process as a result of some system call, we do want to
ensure that it can run, and we need to allow it to be scheduled, even
if it's just a regular scheduler class thing.  The "polite" design
allows the usermode helper to run and just waits until it's safe for
the isolated task to return to userspace.  Possibly we could arrange
for a SCHED_ISOLATED class to allow that kind of behavior, though I'm
not familiar enough with the scheduler code to say for sure.

I think it's important that we're explicit about which of these two
approaches feels like the more appropriate one.  Possibly my Tilera
background is part of which pushes me towards the "polite" design; we
have a lot of cores, so they're a kind of trivial resource that we
don't need to aggressively defend, and it's a more conservative design
to enable task isolation only when all the relevant criteria have been
met, rather than enforcing those criteria up front.

I think if we adopt the "aggressive" model, it might likely make sense
to express it as a scheduling policy, since it would include core
scheduler changes such as denying other tasks the right to call
sched_setaffinity() with an affinity that includes cores currently in
use by SCHED_ISOLATED tasks.  This would be something pretty deeply
hooked into the scheduler and therefore might require some more
substantial changes.  In addition, of course, there's the cost of
documenting yet another scheduler policy.

In the "polite" model, we certainly could use a SCHED_ISOLATED
scheduling policy (with static priority zero) to indicate
task-isolation mode, rather than using prctl() to set a task_struct
bit.  I'm not sure how much it gains, though.  It could allow the
scheduler to detect that the only "runnable" task actually didn't want
to be run, and switch briefly to the idle task, but since this would
likely only be for a scheduler tick or two, the power advantages are
pretty minimal, for a pretty reasonable additional piece of complexity
both in the API (documenting a new scheduler class) and in the
implementation (putting new requirements into the scheduler
implementations).  So I'm somewhat dubious, although willing to be
pushed in that direction if that's the consensus.

On balance I think it still feels to me like the original proposed
direction (a "polite" task isolation mode with a prctl bit) feels
better than the scheduler-based alternatives that have been proposed.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
