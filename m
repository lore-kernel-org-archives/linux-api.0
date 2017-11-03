From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v16 00/13] support "task_isolation" mode
Date: Fri,  3 Nov 2017 13:04:39 -0400
Message-ID: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-mm@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

Here, finally, is a new spin of the task isolation work (v16), with
changes based on the issues that were raised at last year's Linux
Plumbers Conference and in the email discussion that followed.

This version of the patch series cleans up a number of areas that were
a little dodgy in the previous patch series.

- It no longer loops in the final code that prepares to return to
  userspace; instead, it sets things up in the prctl() and then
  validates when preparing to return to userspace, adjusting the
  syscall return value to -EAGAIN at that point if something doesn't
  line up quite correctly.

- We no longer support the NOSIG mode that let you freely call into
  the kernel multiple times while in task isolation.  This was always
  a little odd, since you really should be in sufficient control of
  task isolation code that you can explicitly stop isolation with a
  "prctl(PR_TASK_ISOLATION, 0)" before using the kernel for anything
  else.  It also made the semantics of migrating the task confusing.
  More importantly, removing that support means that the only path
  that sets up task isolation is the return from prctl(), which allows
  us to make the simplification above.

- We no longer try to signal the task isolation process from a remote
  core when we detect that we are about to violate its isolation.
  Instead, we just print a message there (and optionally dump stack),
  and rely on the eventual interrupt on the core itself to trigger the
  signal.  We are always in a safe context to generate a signal when
  we enter the kernel, unlike when we are deep in a call stack sending
  an SMP IPI or whatever.

- We notice the case of an unstable scheduler clock and return
  EINVAL rather than spinning forever with EAGAIN (suggestion from
  Francis Giraldeau).

- The prctl() call requires zeros for arg3/4/5 (suggestion from
  Eugene Syromiatnikov).

The kernel internal isolation API is also now cleaner, and I have
included kerneldoc APIs for all the interfaces so that it should be
easier to port it to additional architectures; in fact looking at
include/linux/isolation.h is a good place to start understanding the
overall patch set.

I removed Catalin's Reviewed-by for arm64, and Christoph's Tested-by
for x86, since this version is sufficiently different to merit
re-review and re-testing.

Note that this is not rebased on top of Frederic's recent housekeeping
patch series, although it is largely orthogonal right now.  After
Frederic's patch series lands, task isolation is enabled with
"isolcpus=nohz,domain,CPUS".  We could add some shorthand for that
("isolcpus=full,CPUS"?) or just use it as-is.

The previous (v15) patch series is here:

https://lkml.kernel.org/r/1471382376-5443-1-git-send-email-cmetcalf@mellanox.com

This patch series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Some folks raised some good points at the LPC discussion and then in
email discussions that followed.  Rather than trying to respond to
everyone in a flurry of emails, I'll answer some questions here:


Why not just instrument user_exit() to raise the isolation-lost signal?

Andy pointed me in this direction.  The advantage is that you catch
*everything*, by definition.  There is a hook that can do this in the
current patch set, but you have to #define DEBUG_TASK_ISOLATION
manually to take advantage of it, because as written it has two issues:

1. You can't actually exit the kernel with prctl(PR_TASK_ISOLATION,0)
   because the user_exit hook kills you first.
2. You lose the ability to get much better diagnostics by waiting
   until you are further into kernel entry and know what you're doing.

You could work around #2 in several ways, but #1 is harder.  I looked
at x86 for a while, and although you could imagine this, you really
want to generate a lost-isolation signal on any syscall that isn't
that exact prctl(), and it's awkward to try to do all of that checking
before user_exit().  Since in any case we do want to have the more
specific probes at the various kernel entry points where we generate
the diagnostics, I felt like it wasn't the right approach to enable
as a compilation-time default.  I'm open to discussion on this though!


Can't we do all the exit-to-userspace work with irqs disabled?

In fact, it turns out that you can do lru_add_drain() with irqs
disabled, so that's what we're doing in the patch series now.

However, it doesn't seem possible to do the synchronous cancellation of
the vmstat deferred work with irqs disabled, though if there's a way,
it would be a little cleaner to do that; Christoph?  We can certainly
update the statistics with interrupts disabled via
refresh_cpu_vm_stats(false), but that's not sufficient.  For now, I
just issue the cancellation during sys_prctl() call, and then if it
isn't synchronized by the time we are exiting to userspace, we just
jam in an EAGAIN and let userspace retry.  In practice, this doesn't
seem to ever happen.


What about using a per-cpu flag to stop doing new deferred work?

Andy also suggested we could structure the code to have the prctl()
set a per-cpu flag to stop adding new future work (e.g. vmstat per-cpu
data, or lru page cache).  Then, we could flush those structures right
from the sys_prctl() call, and when we were returning to user space,
we'd be confident that there wasn't going to be any new work added.

With the current set of things that we are disabling for task
isolation, though, it didn't seem necessary.  Quiescing the vmstat
shepherd seems like it is generally pretty safe since we will likely
be able to sync up the per-cpu cache and kill the deferred work with
high probability, with no expectation that additional work will show
up.  And since we can flush the LRU page cache with interrupts
disabled, that turns out not to be an issue either.

I could imagine that if we have to deal with some new kind of deferred
work, we might find the per-cpu flag becomes a good solution, but for
now we don't have a good use case for that approach.


How about stopping the dyn tick?

Right now we try to stop it on return to userspace, but if we can't,
we just return EAGAIN to userspace.  In practice, what I see is that
usually the tick stops immediately, but occasionally it doesn't; in
this case I've always seen that nr_running is >1, presumably with some
temporary kernel worker threads, and the user code just needs to call
prctl() until those threads are done.  We could structure things with
a completion that we wait for, which is set by the timer code when it
finally does stop the tick, but this may be overkill, particularly
since we'll only be running this prctl() loop from userspace on cores
where we have no other useful work that we're trying to run anyway.


What about TLB flushing?

We talked about this at Plumbers and some of the email discussion also
was about TLB flushing.  I haven't tried to add it to this patch set,
because I really want to avoid scope creep; in any case, I think I
managed to convince Andy that he was going to work on it himself. :)
Paul McKenney already contributed some framework for such a patch, in
commit b8c17e6664c4 ("rcu: Maintain special bits at bottom of
->dynticks counter").

What about that d*mn 1 Hz clock?

It's still there, so this code still requires some further work before
it can actually get a process into long-term task isolation (without
the obvious one-line kernel hack).  Frederic suggested a while ago
forcing updates on cpustats was required as the last gating factor; do
we think that is still true?  Christoph was working on this at one
point - any progress from your point of view?


Chris Metcalf (12):
  vmstat: add quiet_vmstat_sync function
  vmstat: add vmstat_idle function
  Revert "sched/core: Drop the unused try_get_task_struct() helper
    function"
  Add try_get_task_struct_on_cpu() to scheduler for task isolation
  Add try_stop_full_tick() API for NO_HZ_FULL
  task_isolation: userspace hard isolation from kernel
  Add task isolation hooks to arch-independent code
  arch/x86: enable task isolation functionality
  arch/arm64: enable task isolation functionality
  arch/tile: enable task isolation functionality
  arm, tile: turn off timer tick for oneshot_stopped state
  task_isolation self test

Francis Giraldeau (1):
  arch/arm: enable task isolation functionality

 Documentation/admin-guide/kernel-parameters.txt    |   6 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/include/asm/thread_info.h                 |  10 +-
 arch/arm/kernel/entry-common.S                     |  12 +-
 arch/arm/kernel/ptrace.c                           |  10 +
 arch/arm/kernel/signal.c                           |  10 +-
 arch/arm/kernel/smp.c                              |   4 +
 arch/arm/mm/fault.c                                |   8 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/thread_info.h               |   5 +-
 arch/arm64/kernel/ptrace.c                         |  18 +-
 arch/arm64/kernel/signal.c                         |  10 +-
 arch/arm64/kernel/smp.c                            |   7 +
 arch/arm64/mm/fault.c                              |   5 +
 arch/tile/Kconfig                                  |   1 +
 arch/tile/include/asm/thread_info.h                |   2 +
 arch/tile/kernel/hardwall.c                        |   2 +
 arch/tile/kernel/irq.c                             |   3 +
 arch/tile/kernel/messaging.c                       |   4 +
 arch/tile/kernel/process.c                         |   4 +
 arch/tile/kernel/ptrace.c                          |  10 +
 arch/tile/kernel/single_step.c                     |   7 +
 arch/tile/kernel/smp.c                             |  21 +-
 arch/tile/kernel/time.c                            |   3 +
 arch/tile/kernel/unaligned.c                       |   4 +
 arch/tile/mm/fault.c                               |  13 +-
 arch/tile/mm/homecache.c                           |  11 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/common.c                            |  14 +
 arch/x86/include/asm/apic.h                        |   3 +
 arch/x86/include/asm/thread_info.h                 |   8 +-
 arch/x86/kernel/smp.c                              |   2 +
 arch/x86/kernel/traps.c                            |   3 +
 arch/x86/mm/fault.c                                |   5 +
 drivers/clocksource/arm_arch_timer.c               |   2 +
 include/linux/isolation.h                          | 175 ++++++
 include/linux/sched.h                              |   4 +
 include/linux/sched/task.h                         |   3 +
 include/linux/tick.h                               |   1 +
 include/linux/vmstat.h                             |   4 +
 include/uapi/linux/prctl.h                         |   6 +
 init/Kconfig                                       |  28 +
 kernel/Makefile                                    |   1 +
 kernel/context_tracking.c                          |   2 +
 kernel/exit.c                                      |  13 +
 kernel/irq/irqdesc.c                               |   5 +
 kernel/irq_work.c                                  |   5 +-
 kernel/isolation.c                                 | 401 +++++++++++++
 kernel/sched/core.c                                |  11 +
 kernel/signal.c                                    |   2 +
 kernel/smp.c                                       |   6 +-
 kernel/sys.c                                       |   6 +
 kernel/time/tick-sched.c                           |  18 +
 mm/vmstat.c                                        |  19 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/task_isolation/Makefile    |   6 +
 tools/testing/selftests/task_isolation/config      |   1 +
 tools/testing/selftests/task_isolation/isolation.c | 643 +++++++++++++++++++++
 58 files changed, 1561 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c
 create mode 100644 tools/testing/selftests/task_isolation/Makefile
 create mode 100644 tools/testing/selftests/task_isolation/config
 create mode 100644 tools/testing/selftests/task_isolation/isolation.c

-- 
2.1.2

