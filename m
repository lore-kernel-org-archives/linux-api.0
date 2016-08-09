From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v14 00/14] support "task_isolation" mode
Date: Tue,  9 Aug 2016 16:29:42 -0400
Message-ID: <1470774596-17341-1-git-send-email-cmetcalf@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is a respin of the task-isolation patch set.  This primarily
reflects some testing on x86, and a rebase to 4.8.

I have been getting email asking me when and where this patch will be
upstreamed so folks can start using it.  I had been thinking the
obvious path was via Frederic Weisbecker to Ingo as a NOHZ kind of
thing.  But perhaps it touches enough other subsystems that that
doesn't really make sense?  Andrew, would it make sense to take it
directly via your tree?  Frederic, Ingo, what do you think?

Changes since v13:

- Rebased on v4.8-rc1 (and thus uses the standard try_get_task_struct).

- Fixes a bug when using the clocksource watchdog; it is now scheduled
  to run only on the housekeeping cpus [by Christoph Lameter].

- Fixes a bug in x86 syscall_trace_enter() [seen by Francis Giraldeau].

- Includes a selftest.

The previous (v13) patch series is here:

https://lkml.kernel.org/r/1468529299-27929-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

This version of the patch series has been tested on arm64 and tilegx,
and build-tested on x86 (plus some volunteer testing on x86 by
Christoph and Francis).

It remains true that the 1 Hz tick needs to be disabled for this
patch series to be able to achieve its primary goal of enabling
truly tick-free operation, but that is ongoing orthogonal work.
Frederic, do you have a sense of what is left to be done there?
I can certainly try to contribute to that effort as well.

The series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (13):
  vmstat: add quiet_vmstat_sync function
  vmstat: add vmstat_idle function
  lru_add_drain_all: factor out lru_add_drain_needed
  task_isolation: add initial support
  task_isolation: track asynchronous interrupts
  arch/x86: enable task isolation functionality
  arm64: factor work_pending state machine to C
  arch/arm64: enable task isolation functionality
  arch/tile: enable task isolation functionality
  arm, tile: turn off timer tick for oneshot_stopped state
  task_isolation: support CONFIG_TASK_ISOLATION_ALL
  task_isolation: add user-settable notification signal
  task_isolation self test

Christoph Lameter (1):
  clocksource: Do not schedule watchdog on isolated or NOHZ cpus

 Documentation/kernel-parameters.txt                |  16 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/thread_info.h               |   5 +-
 arch/arm64/kernel/entry.S                          |  12 +-
 arch/arm64/kernel/ptrace.c                         |  15 +-
 arch/arm64/kernel/signal.c                         |  42 +-
 arch/arm64/kernel/smp.c                            |   2 +
 arch/arm64/mm/fault.c                              |   8 +-
 arch/tile/Kconfig                                  |   1 +
 arch/tile/include/asm/thread_info.h                |   4 +-
 arch/tile/kernel/process.c                         |   9 +
 arch/tile/kernel/ptrace.c                          |   7 +
 arch/tile/kernel/single_step.c                     |   7 +
 arch/tile/kernel/smp.c                             |  26 +-
 arch/tile/kernel/time.c                            |   1 +
 arch/tile/kernel/unaligned.c                       |   4 +
 arch/tile/mm/fault.c                               |  13 +-
 arch/tile/mm/homecache.c                           |   2 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/common.c                            |  20 +-
 arch/x86/include/asm/thread_info.h                 |   2 +
 arch/x86/kernel/smp.c                              |   2 +
 arch/x86/kernel/traps.c                            |   3 +
 arch/x86/mm/fault.c                                |   5 +
 drivers/base/cpu.c                                 |  18 +
 drivers/clocksource/arm_arch_timer.c               |   2 +
 include/linux/context_tracking_state.h             |   6 +
 include/linux/isolation.h                          |  73 +++
 include/linux/sched.h                              |   3 +
 include/linux/swap.h                               |   1 +
 include/linux/tick.h                               |   2 +
 include/linux/vmstat.h                             |   4 +
 include/uapi/linux/prctl.h                         |  10 +
 init/Kconfig                                       |  37 ++
 kernel/Makefile                                    |   1 +
 kernel/fork.c                                      |   3 +
 kernel/irq_work.c                                  |   5 +-
 kernel/isolation.c                                 | 337 +++++++++++
 kernel/sched/core.c                                |  14 +
 kernel/signal.c                                    |  15 +
 kernel/smp.c                                       |   6 +-
 kernel/softirq.c                                   |  33 ++
 kernel/sys.c                                       |   9 +
 kernel/time/clocksource.c                          |  10 +-
 kernel/time/tick-sched.c                           |  36 +-
 mm/swap.c                                          |  15 +-
 mm/vmstat.c                                        |  19 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/task_isolation/Makefile    |  11 +
 tools/testing/selftests/task_isolation/config      |   2 +
 tools/testing/selftests/task_isolation/isolation.c | 618 +++++++++++++++++++++
 51 files changed, 1440 insertions(+), 59 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c
 create mode 100644 tools/testing/selftests/task_isolation/Makefile
 create mode 100644 tools/testing/selftests/task_isolation/config
 create mode 100644 tools/testing/selftests/task_isolation/isolation.c

-- 
2.7.2
