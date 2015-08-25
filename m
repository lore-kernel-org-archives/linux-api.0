From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v6 0/6] support "task_isolated" mode for nohz_full
Date: Tue, 25 Aug 2015 15:55:49 -0400
Message-ID: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

The cover email for the patch series is getting a little unwieldy
so I will provide a terser summary here, and just update the
list of changes from version to version.  Please see the previous
versions linked by the In-Reply-To for more detailed comments
about changes in earlier versions of the patch series.

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
ready to run with absolutely no kernel interrupts (for example,
workqueues on task_isolation cores still remain to be dealt with), this
patch series provides a way to make dynamic tradeoffs between avoiding
kernel interrupts on the one hand, and making voluntary calls in and
out of the kernel more expensive, for tasks that want it.

The series (based currently on v4.2-rc3) is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Note: I have not removed the commit to disable the 1Hz timer tick
fallback that was nack'ed by PeterZ, pending a decision on that thread
as to what to do (https://lkml.org/lkml/2015/5/8/555); also since if
we remove the 1Hz tick, task_isolation threads will never re-enter
userspace since a tick will always be pending.

Chris Metcalf (5):
  task_isolation: add initial support
  task_isolation: support PR_TASK_ISOLATION_STRICT mode
  task_isolation: provide strict mode configurable signal
  task_isolation: add debug boot flag
  nohz: task_isolation: allow tick to be fully disabled

Christoph Lameter (1):
  vmstat: provide a function to quiet down the diff processing

 Documentation/kernel-parameters.txt |   7 +++
 arch/arm64/kernel/ptrace.c          |   5 ++
 arch/tile/kernel/process.c          |   9 +++
 arch/tile/kernel/ptrace.c           |   5 +-
 arch/tile/mm/homecache.c            |   5 +-
 arch/x86/kernel/ptrace.c            |   2 +
 include/linux/context_tracking.h    |  11 +++-
 include/linux/isolation.h           |  42 +++++++++++++
 include/linux/sched.h               |   3 +
 include/linux/vmstat.h              |   2 +
 include/uapi/linux/prctl.h          |   8 +++
 init/Kconfig                        |  20 ++++++
 kernel/Makefile                     |   1 +
 kernel/context_tracking.c           |  12 +++-
 kernel/irq_work.c                   |   5 +-
 kernel/isolation.c                  | 122 ++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c                 |  21 +++++++
 kernel/signal.c                     |   5 ++
 kernel/smp.c                        |   4 ++
 kernel/softirq.c                    |   7 +++
 kernel/sys.c                        |   8 +++
 kernel/time/tick-sched.c            |   3 +-
 mm/vmstat.c                         |  14 +++++
 23 files changed, 311 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.1.2
