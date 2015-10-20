From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v8 00/14] support "task_isolation" mode for nohz_full
Date: Tue, 20 Oct 2015 16:35:58 -0400
Message-ID: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

This email discusses in detail the changes for v8; please see
older versions of the cover letter for details about older versions.

v8: 
  The biggest difference in this version is, at Thomas Gleixner's
  suggestion, I removed the code that busy-waits until there are no
  scheduler-tick timer events queued.  Instead, we now test for
  higher-level properties when attempting to return to userspace.
  We check if the core believes it has stopped the scheduler tick
  (which handles checking for scheduler contention from other tasks,
  RCU usage of the cpu, posix cpu timers, perf, etc), and if it
  hasn't, we request that the current process be rescheduled.  In
  addition, we check if there are per-cpu lru pages to be drained, and
  we check if the vmstat worker has been quiesced.  The structure is
  pretty clean so we can add additional tests as needed there as well.

  One nice aspect of this revised structure is that if the user
  actually requests a signal from a timer (for example), we will
  now return to userspace and let the program run.  Of course it
  may get bombed with incremental timer ticks if the timer can't
  be programmed to the whole time interval in one step, but it still
  feels more correct this way then holding the process in the kernel
  until the user-requested timer expires.

  At Andy Lutomirski's suggestion, we separate out from the previous
  task_isolation_enter() a separate task_isolation_ready() test
  that can be done at the same time as we test the TIF_xxx flags,
  with interrupts disabled, so we can guarantee that the conditions
  we test for are still true when we return to userspace.

  To accomplish this we break out a new vmstat_idle() function
  that checks if the vmstat subsystem is quiesced on this core.
  Similarly, we factor out an lru_add_drain_needed() function from
  where it used to be in lru_add_drain_all().  Both of these
  "check" functions can now be called from task_isolation_ready()
  with interrupts disabled.

  Also at Andy's suggestion (and aligning with how I had done things
  previously in the Tilera private fork), the prctl() to enable task
  isolation will now fail with EINVAL if you attempt to enable
  task-isolation mode when your affinity does not lock you to a
  single core, or if that core is not a nohz_full core.

  We move the "strict" syscall test to just before SECCOMP instead
  of just after.  It's not particularly clear that one is better
  than the other abstractly, and on a couple of the supported
  platforms (x86, tile) it makes the code structure work out better
  because the user_enter() can be done at the same time as the
  test for strict mode.

  The integration with context_tracking has been completely dropped;
  discussing with Andy showed that there are only a few exception
  sites that need strict-mode checking (the typical one is
  page faults that don't raise signals) so just putting the checks
  in the relevant functions feels cleaner than trying to hijack
  the exception_enter/exception_exit paths, which are being
  removed for x86 in any case.

  The task_isolation_exception() hook now takes full printf
  format arguments, so that we can generate a much more useful
  report as to why we are killing the task.  As a result, we also
  remove the dump_stack() call, whose only utility was pointing
  the finger at which exception function had triggered.

  Rather than automatically disabling the 1 Hz maximum scheduler
  deferment for task-isolation tasks, we now require the user to
  specify a boot flag ("debug_1hz_tick") to do this.  The boot
  flag allows us to test the case where all the 1 Hz updating
  subsystems have been fixed before that work actually is finished.

  An architecture-specific fix is included in this patch series for
  the tile architecture; I will push it through the tile tree (along
  with the tile prepare_exit_to_usermode restructuring) if there are
  no concerns.  At issue is that we end up with one gratuitous timer
  tick when we are shutting down the timer; by setting up the
  set_state_oneshot_stopped function pointer callback for the tile
  tick timer we can avoid this problem.  (Thomas, I'd particularly
  appreciate your ack on this fix, which is number 13 out of 14 in
  this patch series.)

  Rebased to v4.3-rc6 to pick up the fix for vmstat to properly
  use schedule_delayed_work_on(), since I was hitting a VM_BUG_ON
  without the fix (which I separately tracked down - oh well).

v7:
  switch to architecture hooks for task_isolation_enter
  add an RCU_LOCKDEP_WARN() (Andy Lutomirski)
  rebased to v4.3-rc1

v6:
  restructured to be a "task_isolation" mode not a "cpu_isolated"
  mode (Frederic)

v5:
  rebased on kernel v4.2-rc3
  converted to use CONFIG_CPU_ISOLATED and separate .c and .h files
  incorporates Christoph Lameter's quiet_vmstat() call

v4:
  rebased on kernel v4.2-rc1
  added support for detecting CPU_ISOLATED_STRICT syscalls on arm64

v3:
  remove dependency on cpu_idle subsystem (Thomas Gleixner)
  use READ_ONCE instead of ACCESS_ONCE in tick_nohz_cpu_isolated_enter
  use seconds for console messages instead of jiffies (Thomas Gleixner)
  updated commit description for patch 5/5

v2:
  rename "dataplane" to "cpu_isolated"
  drop ksoftirqd suppression changes (believed no longer needed)
  merge previous "QUIESCE" functionality into baseline functionality
  explicitly track syscalls and exceptions for "STRICT" functionality
  allow configuring a signal to be delivered for STRICT mode failures
  move debug tracking to irq_enter(), not irq_exit()

General summary:

The existing nohz_full mode does a nice job of suppressing extraneous
kernel interrupts for cores that desire it.  However, there is a need
for a more deterministic mode that rigorously disallows kernel
interrupts, even at a higher cost in user/kernel transition time:
for example, high-speed networking applications running userspace
drivers that will drop packets if they are ever interrupted.

These changes attempt to provide an initial draft of such a framework;
the changes do not add any overhead to the usual non-nohz_full mode,
and only very small overhead to the typical nohz_full mode.  The
kernel must be built with CONFIG_TASK_ISOLATION to take advantage of
this new mode.  A prctl() option (PR_SET_TASK_ISOLATION) is added to
control whether processes have requested this stricter semantics, and
within that prctl() option we provide a number of different bits for
more precise control.  Additionally, we add a new command-line boot
argument to facilitate debugging where unexpected interrupts are being
delivered from.

Code that is conceptually similar has been in use in Tilera's
Multicore Development Environment since 2008, known as Zero-Overhead
Linux, and has seen wide adoption by a range of customers.  This patch
series represents the first serious attempt to upstream that
functionality.  Although the current state of the kernel isn't quite
ready to run with absolutely no kernel interrupts, this
patch series provides a way to make dynamic tradeoffs between avoiding
kernel interrupts on the one hand, and making voluntary calls in and
out of the kernel more expensive, for tasks that want it.

The series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (13):
  vmstat: add vmstat_idle function
  lru_add_drain_all: factor out lru_add_drain_needed
  task_isolation: add initial support
  task_isolation: support PR_TASK_ISOLATION_STRICT mode
  task_isolation: provide strict mode configurable signal
  task_isolation: add debug boot flag
  nohz_full: allow disabling the 1Hz minimum tick at boot
  arch/x86: enable task isolation functionality
  arch/arm64: adopt prepare_exit_to_usermode() model from x86
  arch/arm64: enable task isolation functionality
  arch/tile: adopt prepare_exit_to_usermode() model from x86
  arch/tile: turn off timer tick for oneshot_stopped state
  arch/tile: enable task isolation functionality

Christoph Lameter (1):
  vmstat: provide a function to quiet down the diff processing

 Documentation/kernel-parameters.txt  |   7 ++
 arch/arm64/include/asm/thread_info.h |  18 +++--
 arch/arm64/kernel/entry.S            |   6 +-
 arch/arm64/kernel/ptrace.c           |  12 +++-
 arch/arm64/kernel/signal.c           |  35 +++++++---
 arch/arm64/mm/fault.c                |   4 ++
 arch/tile/include/asm/processor.h    |   2 +-
 arch/tile/include/asm/thread_info.h  |   8 ++-
 arch/tile/kernel/intvec_32.S         |  46 ++++---------
 arch/tile/kernel/intvec_64.S         |  49 +++++---------
 arch/tile/kernel/process.c           |  83 ++++++++++++-----------
 arch/tile/kernel/ptrace.c            |   6 +-
 arch/tile/kernel/single_step.c       |   5 ++
 arch/tile/kernel/time.c              |   1 +
 arch/tile/kernel/unaligned.c         |   3 +
 arch/tile/mm/fault.c                 |   3 +
 arch/tile/mm/homecache.c             |   5 +-
 arch/x86/entry/common.c              |  10 ++-
 arch/x86/kernel/traps.c              |   2 +
 arch/x86/mm/fault.c                  |   2 +
 include/linux/isolation.h            |  61 +++++++++++++++++
 include/linux/sched.h                |   3 +
 include/linux/swap.h                 |   1 +
 include/linux/vmstat.h               |   4 ++
 include/uapi/linux/prctl.h           |   8 +++
 init/Kconfig                         |  20 ++++++
 kernel/Makefile                      |   1 +
 kernel/irq_work.c                    |   5 +-
 kernel/isolation.c                   | 127 +++++++++++++++++++++++++++++++++++
 kernel/sched/core.c                  |  37 ++++++++++
 kernel/signal.c                      |  13 ++++
 kernel/smp.c                         |   4 ++
 kernel/softirq.c                     |   7 ++
 kernel/sys.c                         |   9 +++
 mm/swap.c                            |  13 ++--
 mm/vmstat.c                          |  24 +++++++
 36 files changed, 507 insertions(+), 137 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.1.2

