From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v10 00/12] support "task_isolation" mode
Date: Wed, 2 Mar 2016 15:09:24 -0500
Message-ID: <1456949376-4910-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

Here is the latest version of the task-isolation patch set, adopting
various suggestions made about the v9 patch series, including some
feedback from testing on the new EZchip NPS ARC platform (although the
new arch/arc support is not included in this patch series).  All of the
suggestions were relatively non-controversial.

Perhaps we are getting close to being able to merge this. :-)

Changes since v9:

- task_isolation is now set up by adding its required cpus to both the
  nohz_full and isolcpus cpumasks.  This allows users to separately
  specify all three flags, if so desired, and still get reasonably
  sane semantics.  This is done with a new tick_nohz_full_add_cpus()
  method for nohz, and just directly updating the isolcpus cpumask.

- We add a /sys/devices/system/cpu/task_isolation file to parallel
  the equivalent nohz_full file.  (This should have been in v8 since
  once task_isolation isn't equivalent to nohz_full, it needs its
  own way to let userspace know where to run.)

- We add a new Kconfig option, TASK_ISOLATION_ALL, which sets all but
  the boot processor to run in task isolation mode.  This parallels
  the existing NO_HZ_FULL_ALL and works around the fact that you can't
  easily specify a boot argument with the desired semantics.

- For task_isolation_debug, we add a check of the context_tracking
  state of the remote cpu before issuing a warning; if the remote cpu
  is actually in the kernel, we don't need to warn.

- A cloned child of a task_isolation task is not enabled for
  task_isolation, since otherwise they would both fight over who could
  safely return to userspace without requiring scheduling interrupts.

- The quiet_vmstat() function's semantics was changed since the v9
  patch series, so I introduce a quiet_vmstat_sync() for isolation.

- The lru_add_drain_needed() function is updated to know about the new
  lru_deactivate_pvecs variable.

- The arm64 patch factoring assembly into C has been modified based
  on an earlier patch by Mark Rutland.

- I simplified the enabling patch for arm64 by realizing we could just
  test TIF_NOHZ as the only bit for TIF_WORK_MASK for task isolation,
  so I didn't have to renumber all the TIF_xxx bits.

- Small fixes to avoid preemption warnings.

- Rebased on v4.5-rc5

For changes in earlier versions of the patch series, please see:

http://lkml.kernel.org/r/1451936091-29247-1-git-send-email-cmetcalf@ezchip.com

A couple of the tile patches that refactored the context tracking
code were taken into 4.5 so are no longer present in this series.

This version of the patch series has been tested on arm64 and tile,
and build-tested on x86.

It remains true that the 1 Hz tick needs to be disabled for this
patch series to be able to achieve its primary goal of enabling
truly tick-free operation, but that is ongoing orthogonal work.

The series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (12):
  vmstat: add quiet_vmstat_sync function
  vmstat: add vmstat_idle function
  lru_add_drain_all: factor out lru_add_drain_needed
  task_isolation: add initial support
  task_isolation: support CONFIG_TASK_ISOLATION_ALL
  task_isolation: support PR_TASK_ISOLATION_STRICT mode
  task_isolation: add debug boot flag
  arm, tile: turn off timer tick for oneshot_stopped state
  arch/x86: enable task isolation functionality
  arch/tile: enable task isolation functionality
  arm64: factor work_pending state machine to C
  arch/arm64: enable task isolation functionality

 Documentation/kernel-parameters.txt    |  16 ++
 arch/arm64/include/asm/thread_info.h   |   8 +-
 arch/arm64/kernel/entry.S              |  12 +-
 arch/arm64/kernel/ptrace.c             |  12 +-
 arch/arm64/kernel/signal.c             |  34 ++++-
 arch/arm64/kernel/smp.c                |   2 +
 arch/arm64/mm/fault.c                  |   4 +
 arch/tile/kernel/process.c             |   6 +-
 arch/tile/kernel/ptrace.c              |   6 +
 arch/tile/kernel/single_step.c         |   5 +
 arch/tile/kernel/smp.c                 |  28 ++--
 arch/tile/kernel/time.c                |   1 +
 arch/tile/kernel/unaligned.c           |   3 +
 arch/tile/mm/fault.c                   |   3 +
 arch/tile/mm/homecache.c               |   2 +
 arch/x86/entry/common.c                |  18 ++-
 arch/x86/kernel/traps.c                |   2 +
 arch/x86/mm/fault.c                    |   2 +
 drivers/base/cpu.c                     |  18 +++
 drivers/clocksource/arm_arch_timer.c   |   2 +
 include/linux/context_tracking_state.h |   6 +
 include/linux/isolation.h              |  83 +++++++++++
 include/linux/sched.h                  |   3 +
 include/linux/swap.h                   |   1 +
 include/linux/tick.h                   |   1 +
 include/linux/vmstat.h                 |   4 +
 include/uapi/linux/prctl.h             |   8 +
 init/Kconfig                           |  30 ++++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   3 +
 kernel/irq_work.c                      |   5 +-
 kernel/isolation.c                     | 261 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c                    |  18 +++
 kernel/signal.c                        |   5 +
 kernel/smp.c                           |   6 +-
 kernel/softirq.c                       |  33 +++++
 kernel/sys.c                           |   9 ++
 kernel/time/tick-sched.c               |  31 ++--
 mm/swap.c                              |  15 +-
 mm/vmstat.c                            |  24 +++
 40 files changed, 676 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.1.2
