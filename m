From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v4 0/5] support "cpu_isolated" mode for nohz_full
Date: Mon, 13 Jul 2015 15:57:56 -0400
Message-ID: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
References: <1433345365-29506-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433345365-29506-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

This posting of the series is basically a "ping" since there were
no comments to the v3 version.  I have rebased it to 4.2-rc1, added
support for arm64 syscall tracking for "strict" mode, and retested it;
are there any remaining concerns?  Thomas, I haven't heard from you
whether my removal of the cpu_idle calls sufficiently addresses your
concerns about that aspect.  Are there other concerns with this patch
series at this point?

Original patch series cover letter follows:

The existing nohz_full mode does a nice job of suppressing extraneous
kernel interrupts for cores that desire it.  However, there is a need
for a more deterministic mode that rigorously disallows kernel
interrupts, even at a higher cost in user/kernel transition time:
for example, high-speed networking applications running userspace
drivers that will drop packets if they are ever interrupted.

These changes attempt to provide an initial draft of such a framework;
the changes do not add any overhead to the usual non-nohz_full mode,
and only very small overhead to the typical nohz_full mode.  A prctl()
option (PR_SET_CPU_ISOLATED) is added to control whether processes have
requested this stricter semantics, and within that prctl() option we
provide a number of different bits for more precise control.
Additionally, we add a new command-line boot argument to facilitate
debugging where unexpected interrupts are being delivered from.

Code that is conceptually similar has been in use in Tilera's
Multicore Development Environment since 2008, known as Zero-Overhead
Linux, and has seen wide adoption by a range of customers.  This patch
series represents the first serious attempt to upstream that
functionality.  Although the current state of the kernel isn't quite
ready to run with absolutely no kernel interrupts (for example,
workqueues on cpu_isolated cores still remain to be dealt with), this
patch series provides a way to make dynamic tradeoffs between avoiding
kernel interrupts on the one hand, and making voluntary calls in and
out of the kernel more expensive, for tasks that want it.

The series (based currently on v4.2-rc1) is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

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

Note: I have not removed the commit to disable the 1Hz timer tick
fallback that was nack'ed by PeterZ, pending a decision on that thread
as to what to do (https://lkml.org/lkml/2015/5/8/555); also since if
we remove the 1Hz tick, cpu_isolated threads will never re-enter
userspace since a tick will always be pending.

Chris Metcalf (5):
  nohz_full: add support for "cpu_isolated" mode
  nohz: support PR_CPU_ISOLATED_STRICT mode
  nohz: cpu_isolated strict mode configurable signal
  nohz: add cpu_isolated_debug boot flag
  nohz: cpu_isolated: allow tick to be fully disabled

 Documentation/kernel-parameters.txt |   6 +++
 arch/tile/kernel/process.c          |   9 ++++
 arch/tile/kernel/ptrace.c           |   6 ++-
 arch/tile/mm/homecache.c            |   5 +-
 arch/x86/kernel/ptrace.c            |   2 +
 include/linux/context_tracking.h    |  11 ++--
 include/linux/sched.h               |   3 ++
 include/linux/tick.h                |  28 ++++++++++
 include/uapi/linux/prctl.h          |   8 +++
 kernel/context_tracking.c           |  12 +++--
 kernel/irq_work.c                   |   4 +-
 kernel/sched/core.c                 |  18 +++++++
 kernel/signal.c                     |   5 ++
 kernel/smp.c                        |   4 ++
 kernel/softirq.c                    |   6 +++
 kernel/sys.c                        |   8 +++
 kernel/time/tick-sched.c            | 104 +++++++++++++++++++++++++++++++++++-
 17 files changed, 229 insertions(+), 10 deletions(-)

-- 
2.1.2
