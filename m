From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v15 00/13] support "task_isolation" mode
Date: Tue, 16 Aug 2016 17:19:23 -0400
Message-ID: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

Here is a respin of the task-isolation patch set.

Again, I have been getting email asking me when and where this patch
will be upstreamed so folks can start using it.  I had been thinking
the obvious path was via Frederic Weisbecker to Ingo as a NOHZ kind of
thing.  But perhaps it touches enough other subsystems that that
doesn't really make sense?  Andrew, would it make sense to take it
directly via your tree?  Frederic, Ingo, what do you think?

Changes since v14:

- Rebased on v4.8-rc2 (so incorporates my NOHZ bugfix vs v4.8-rc1)

- Dropped Christoph Lameter's patch to avoid scheduling the
  clocksource watchdog on nohz cores; the recommendation is to just
  boot with tsc=reliable for NOHZ in any case, if necessary.

- Optimize task_isolation_enter() by checking vmstat_idle() before
  calling quiet_vmstat_sync() [Frederic, Christoph]

- Correct buggy x86 syscall_trace_enter() support [Andy]

- Add _TIF_TASK_ISOLATION to x86 _TIF_ALLWORK_MASK; not technically
  necessary but good for self-documentation [Andy]

- Improve comment for task_isolation_syscall() callsites to clarify
  that we are delivering a signal if we bail out of the syscall [Andy]

- Ran the selftest through checkpatch and cleaned up style issues

The previous (v14) patch series is here:

https://lkml.kernel.org/r/1470774596-17341-1-git-send-email-cmetcalf@mellanox.com

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

 Documentation/kernel-parameters.txt                |  16 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/thread_info.h               |   5 +-
 arch/arm64/kernel/entry.S                          |  12 +-
 arch/arm64/kernel/ptrace.c                         |  18 +-
 arch/arm64/kernel/signal.c                         |  42 +-
 arch/arm64/kernel/smp.c                            |   2 +
 arch/arm64/mm/fault.c                              |   8 +-
 arch/tile/Kconfig                                  |   1 +
 arch/tile/include/asm/thread_info.h                |   4 +-
 arch/tile/kernel/process.c                         |   9 +
 arch/tile/kernel/ptrace.c                          |  10 +
 arch/tile/kernel/single_step.c                     |   7 +
 arch/tile/kernel/smp.c                             |  26 +-
 arch/tile/kernel/time.c                            |   1 +
 arch/tile/kernel/unaligned.c                       |   4 +
 arch/tile/mm/fault.c                               |  13 +-
 arch/tile/mm/homecache.c                           |   2 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/common.c                            |  21 +-
 arch/x86/include/asm/thread_info.h                 |   4 +-
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
 kernel/isolation.c                                 | 338 +++++++++++
 kernel/sched/core.c                                |  14 +
 kernel/signal.c                                    |  15 +
 kernel/smp.c                                       |   6 +-
 kernel/softirq.c                                   |  33 ++
 kernel/sys.c                                       |   9 +
 kernel/time/tick-sched.c                           |  36 +-
 mm/swap.c                                          |  15 +-
 mm/vmstat.c                                        |  19 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/task_isolation/Makefile    |  11 +
 tools/testing/selftests/task_isolation/config      |   2 +
 tools/testing/selftests/task_isolation/isolation.c | 646 +++++++++++++++++++++
 50 files changed, 1470 insertions(+), 57 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c
 create mode 100644 tools/testing/selftests/task_isolation/Makefile
 create mode 100644 tools/testing/selftests/task_isolation/config
 create mode 100644 tools/testing/selftests/task_isolation/isolation.c

-- 
2.7.2

