From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v13 00/12] support "task_isolation" mode
Date: Thu, 14 Jul 2016 16:48:07 -0400
Message-ID: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

Here is a respin of the task-isolation patch set.  This primarily
reflects feedback from Frederic and Peter Z.

Changes since v12:

- Rebased on v4.7-rc7.

- New default "strict" model for task isolation - tasks exit the
  kernel from the initial prctl() to userspace, and can only legally
  exit by calling prctl() again to turn off isolation.  Any other
  kernel entry results in a SIGKILL by default.

- New optional "relaxed" mode, where the application can receive some
  signal other than SIGKILL, or no signal at all, when it re-enters
  the kernel.  Since by default task isolation is now strict, there is
  no longer an additional "STRICT" mode, but rather a new "NOSIG" mode
  that builds on top of the "USERSIG" support for setting a signal
  other than SIGKILL to be delivered to the process.  The "NOSIG" mode
  also relaxes the required criteria for entering task isolation mode;
  we just issue a warning if the affinity isn't set right, and we
  don't fail with EAGAIN if the kernel isn't ready to stop the tick.

  Running your task-isolation application in this "NOSIG" mode is also
  necessary when debugging, since otherwise hitting breakpoints, etc.,
  will cause a fatal signal to be sent to the process.

  Frederic has suggested we might want to defer this functionality
  until later, but (in addition to the debuggability aspect) there is
  some thought that it might be useful for e.g. HPC, so I have just
  broken out the additional semantics into a single separate patch at
  the end of the series.

- Function naming has been changed and comments have been added to try
  to clarify the role of the task-isolation reporting on kernel
  entries that do NOT cause signals.  This hopefully clarifies why we
  only invoke the renamed task_isolation_quiet_exception() in a few
  places, since all the other places generate signals anyway. [PeterZ]

- The task_isolation_debug() call now has an inline piece that checks
  to see if the target is a task_isolation cpu before actually
  calling. [PeterZ]

- In _task_isolation_debug(), we use the new task_struct_trylock()
  call that is in linux-next now; for now I just have a static copy of
  the function, which I will switch to using the version from
  linux-next in the next rebasing. [PeterZ]

- We now pass a string describing the interrupt up from
  task_isolation_debug() so there is more information on where the
  interrupt came from beyond just the stack backtrace. [PeterZ]

- I added task_isolation_debug() hooks to smp_sched_reschedule() on
  x86, which was missing before, and removed the hooks in the tile
  send_IPI_*() routines, since there were already hooks in the
  callers.  Likewise I moved the hook for arm64 from the generic
  smp_cross_call() routine to the only caller that wasn't already
  hooked, smp_send_reschedule().  The commit message clarifies the
  rationale for where hooks are placed.

- I moved the page fault reporting so that it only reports in the case
  that we are not also sending a SIGSEGV/SIGBUS, for consistency with
  other uses of task_isolation_quiet_exception().

The previous (v12) patch series is here:

https://lkml.kernel.org/g/1459877922-15512-1-git-send-email-cmetcalf@mellanox.com

This version of the patch series has been tested on arm64 and tilegx,
and build-tested on x86.

It remains true that the 1 Hz tick needs to be disabled for this
patch series to be able to achieve its primary goal of enabling
truly tick-free operation, but that is ongoing orthogonal work.
Frederick, do you have a sense of what is left to be done there?
I can certainly try to contribute to that effort as well.

The series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (12):
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

 Documentation/kernel-parameters.txt    |  16 ++
 arch/arm64/Kconfig                     |   1 +
 arch/arm64/include/asm/thread_info.h   |   5 +-
 arch/arm64/kernel/entry.S              |  12 +-
 arch/arm64/kernel/ptrace.c             |  15 +-
 arch/arm64/kernel/signal.c             |  42 +++-
 arch/arm64/kernel/smp.c                |   2 +
 arch/arm64/mm/fault.c                  |   8 +-
 arch/tile/Kconfig                      |   1 +
 arch/tile/include/asm/thread_info.h    |   4 +-
 arch/tile/kernel/process.c             |   9 +
 arch/tile/kernel/ptrace.c              |   7 +
 arch/tile/kernel/single_step.c         |   7 +
 arch/tile/kernel/smp.c                 |  26 +--
 arch/tile/kernel/time.c                |   1 +
 arch/tile/kernel/unaligned.c           |   4 +
 arch/tile/mm/fault.c                   |  13 +-
 arch/tile/mm/homecache.c               |   2 +
 arch/x86/Kconfig                       |   1 +
 arch/x86/entry/common.c                |  18 +-
 arch/x86/include/asm/thread_info.h     |   2 +
 arch/x86/kernel/smp.c                  |   2 +
 arch/x86/kernel/traps.c                |   3 +
 arch/x86/mm/fault.c                    |   5 +
 drivers/base/cpu.c                     |  18 ++
 drivers/clocksource/arm_arch_timer.c   |   2 +
 include/linux/context_tracking_state.h |   6 +
 include/linux/isolation.h              |  73 +++++++
 include/linux/sched.h                  |   3 +
 include/linux/swap.h                   |   1 +
 include/linux/tick.h                   |   2 +
 include/linux/vmstat.h                 |   4 +
 include/uapi/linux/prctl.h             |  10 +
 init/Kconfig                           |  37 ++++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   3 +
 kernel/irq_work.c                      |   5 +-
 kernel/isolation.c                     | 337 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c                    |  42 ++++
 kernel/signal.c                        |  15 ++
 kernel/smp.c                           |   6 +-
 kernel/softirq.c                       |  33 ++++
 kernel/sys.c                           |   9 +
 kernel/time/tick-sched.c               |  36 ++--
 mm/swap.c                              |  15 +-
 mm/vmstat.c                            |  19 ++
 46 files changed, 827 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.7.2
