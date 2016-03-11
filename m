From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v11 00/13] support "task_isolation" mode
Date: Fri, 11 Mar 2016 17:10:10 -0500
Message-ID: <1457734223-26209-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

Here is a respin of the task-isolation patch set, folding in
comments from Frederic Weisbecker, Will Deacon, Andy Lutomirski,
Kees Cook and others.

Changes since v10:

- In the API, I added a new PR_TASK_ISOLATION_ONE_SHOT flag to
  implement the semantics that Frederic had requested.  It remains to
  be seen whether it makes sense to: leave this as a dynamic flag; back
  out the change and remove the flag and leave the semantics always
  "persistent" (as before); or remove the flag and make the semantics
  always one-shot.  I tend to favor removing the flag and keeping the
  semantics persistent, but having it as a flag provides a specific
  implementation to let us think about the tradeoffs.

- I added a TIF_TASK_ISOLATION flag to clarify and simplify the tests for
  whether task isolation is currently enabled.  We remove the previous
  inline wrappers for task_isolation_ready/enter() and just call the
  real functions unconditionally if TIF_TASK_ISOLATION is set, and
  similarly simplify the task_isolation_syscall/exception() helpers.

- I added a task_isolation_set_flags() helper to set or clear
  TIF_TASK_ISOLATION as needed; it also allows me to get rid of the
  #ifdefs in signal.c and fork.c, which is a nice plus.

- The initial prctl() to enable task isolation now also checks
  can_stop_full_tick() to look for additional potential problems when
  starting up task isolation (other schedulable tasks or POSIX cpu
  timers being the two most obvious examples).  The function is now no
  longer static in kernel/time/tick-sched.c.

- I expanded the existing comment justifying calling
  set_tsk_need_resched() if dynticks are still running when a task
  isolation task wants to enter userspace.  As mentioned in my reply
  to Frederic, I still consider it an open question whether we should
  do some form of struct notification type work here, but on balance I
  think it's overcomplicated to do so.

- We now make sure to clear task isolation when delivering a signal,
  since by definition signals pretty much mean you've lost task
  isolation, it's a well-defined semantic to provide to userspace, and
  it means we can always deliver the signal for STRICT mode saying we
  were interrupted.  Also, doing this is necessary to catch more of the
  cases where we clear task isolation mode for the new ONE_SHOT mode.

- For STRICT mode, I moved the setting of the attempted syscall's return
  value to the generic code via the syscall_set_return_value()
  function.  I also restructured the code slightly to make it
  easier to add ONE_SHOT support in a following patch.  On Kees Cook's
  advice I continue to just support the simple TIF_TASK_ISOLATION check
  in syscall entry that calls out to a few lines of C code, but there is
  an ongoing conversation with Andy Lutomirski about using a proposed
  seccomp() extension to guard syscall entry instead.

- The arch/arm64 patch to factor the work_pending state machine into C was
  updated to include the arch/arm call to trace_hardirqs_off() at the
  top.  Will Deacon noticed that we were missing this support.  I also
  restructured the loop as a do/while at his suggestion, rather than
  copying the x86 while(true)/break idiom.

- Changed the S-O-B lines from ezchip.com to mellanox.com.

The previous (v10) patch series is here:

https://lkml.kernel.org/r/1456949376-4910-1-git-send-email-cmetcalf@ezchip.com

This version of the patch series has been tested on arm64 and tile,
and build-tested on x86.

It remains true that the 1 Hz tick needs to be disabled for this
patch series to be able to achieve its primary goal of enabling
truly tick-free operation, but that is ongoing orthogonal work.

The series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (13):
  vmstat: add quiet_vmstat_sync function
  vmstat: add vmstat_idle function
  lru_add_drain_all: factor out lru_add_drain_needed
  task_isolation: add initial support
  task_isolation: support CONFIG_TASK_ISOLATION_ALL
  task_isolation: support PR_TASK_ISOLATION_STRICT mode
  task_isolation: add debug boot flag
  task_isolation: add PR_TASK_ISOLATION_ONE_SHOT flag
  arm, tile: turn off timer tick for oneshot_stopped state
  arch/x86: enable task isolation functionality
  arch/tile: enable task isolation functionality
  arm64: factor work_pending state machine to C
  arch/arm64: enable task isolation functionality

 Documentation/kernel-parameters.txt    |  16 ++
 arch/arm64/include/asm/thread_info.h   |   5 +-
 arch/arm64/kernel/entry.S              |  12 +-
 arch/arm64/kernel/ptrace.c             |  15 +-
 arch/arm64/kernel/signal.c             |  42 ++++-
 arch/arm64/kernel/smp.c                |   2 +
 arch/arm64/mm/fault.c                  |   4 +
 arch/tile/include/asm/thread_info.h    |   4 +-
 arch/tile/kernel/process.c             |   9 +
 arch/tile/kernel/ptrace.c              |   7 +
 arch/tile/kernel/single_step.c         |   5 +
 arch/tile/kernel/smp.c                 |  28 +--
 arch/tile/kernel/time.c                |   1 +
 arch/tile/kernel/unaligned.c           |   3 +
 arch/tile/mm/fault.c                   |   3 +
 arch/tile/mm/homecache.c               |   2 +
 arch/x86/entry/common.c                |  18 +-
 arch/x86/include/asm/thread_info.h     |   2 +
 arch/x86/kernel/traps.c                |   2 +
 arch/x86/mm/fault.c                    |   2 +
 drivers/base/cpu.c                     |  18 ++
 drivers/clocksource/arm_arch_timer.c   |   2 +
 include/linux/context_tracking_state.h |   6 +
 include/linux/isolation.h              |  63 +++++++
 include/linux/sched.h                  |   3 +
 include/linux/swap.h                   |   1 +
 include/linux/tick.h                   |   2 +
 include/linux/vmstat.h                 |   4 +
 include/uapi/linux/prctl.h             |   9 +
 init/Kconfig                           |  30 ++++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   3 +
 kernel/irq_work.c                      |   5 +-
 kernel/isolation.c                     | 313 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c                    |  18 ++
 kernel/signal.c                        |   8 +
 kernel/smp.c                           |   6 +-
 kernel/softirq.c                       |  33 ++++
 kernel/sys.c                           |   9 +
 kernel/time/tick-sched.c               |  33 ++--
 mm/swap.c                              |  15 +-
 mm/vmstat.c                            |  21 +++
 42 files changed, 730 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.7.2
