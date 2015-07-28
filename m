From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/6] support "cpu_isolated" mode for nohz_full
Date: Tue, 28 Jul 2015 15:49:34 -0400
Message-ID: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436817481-8732-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This version of the patch series incorporates Christoph Lameter's
change to add a quiet_vmstat() call, and restructures cpu_isolated as
a "hard" isolation mode in contrast to nohz_full's "soft" isolation,
breaking it out as a separate CONFIG_CPU_ISOLATED with its own
include/linux/cpu_isolated.h and kernel/time/cpu_isolated.c.
It is rebased to 4.2-rc3.

Thomas: as I mentioned in v4, I haven't heard from you whether my
removal of the cpu_idle calls sufficiently addresses your concerns
about that aspect.

Andy: as I said in email, I've left in the support where cpu_isolated
relies on the context_tracking stuff currently in 4.2-rc3.  I'm not
sure what the cleanest way is for me to pick up the new
context_tracking stuff; if that's all that ends up standing between
this patch series and having it be pulled, perhaps I can rebase it
onto whatever branch it is that has the new context_tracking?

Original patch series cover letter follows:

The existing nohz_full mode does a nice job of suppressing extraneous
kernel interrupts for cores that desire it.  However, there is a need
for a more deterministic mode that rigorously disallows kernel
interrupts, even at a higher cost in user/kernel transition time:
for example, high-speed networking applications running userspace
drivers that will drop packets if they are ever interrupted.

These changes attempt to provide an initial draft of such a framework;
the changes do not add any overhead to the usual non-nohz_full mode,
and only very small overhead to the typical nohz_full mode.  The
kernel must be built with CONFIG_CPU_ISOLATED to take advantage of
this new mode.  A prctl() option (PR_SET_CPU_ISOLATED) is added to
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
workqueues on cpu_isolated cores still remain to be dealt with), this
patch series provides a way to make dynamic tradeoffs between avoiding
kernel interrupts on the one hand, and making voluntary calls in and
out of the kernel more expensive, for tasks that want it.

The series (based currently on v4.2-rc3) is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

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

Note: I have not removed the commit to disable the 1Hz timer tick
fallback that was nack'ed by PeterZ, pending a decision on that thread
as to what to do (https://lkml.org/lkml/2015/5/8/555); also since if
we remove the 1Hz tick, cpu_isolated threads will never re-enter
userspace since a tick will always be pending.

Chris Metcalf (5):
  cpu_isolated: add initial support
  cpu_isolated: support PR_CPU_ISOLATED_STRICT mode
  cpu_isolated: provide strict mode configurable signal
  cpu_isolated: add debug boot flag
  nohz: cpu_isolated: allow tick to be fully disabled

Christoph Lameter (1):
  vmstat: provide a function to quiet down the diff processing

 Documentation/kernel-parameters.txt |   7 +++
 arch/arm64/kernel/ptrace.c          |   5 ++
 arch/tile/kernel/process.c          |   9 +++
 arch/tile/kernel/ptrace.c           |   5 +-
 arch/tile/mm/homecache.c            |   5 +-
 arch/x86/kernel/ptrace.c            |   2 +
 include/linux/context_tracking.h    |  11 +++-
 include/linux/cpu_isolated.h        |  42 +++++++++++++
 include/linux/sched.h               |   3 +
 include/linux/vmstat.h              |   2 +
 include/uapi/linux/prctl.h          |   8 +++
 kernel/context_tracking.c           |  12 +++-
 kernel/irq_work.c                   |   5 +-
 kernel/sched/core.c                 |  21 +++++++
 kernel/signal.c                     |   5 ++
 kernel/smp.c                        |   4 ++
 kernel/softirq.c                    |   7 +++
 kernel/sys.c                        |   8 +++
 kernel/time/Kconfig                 |  20 +++++++
 kernel/time/Makefile                |   1 +
 kernel/time/cpu_isolated.c          | 116 ++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c            |   3 +-
 mm/vmstat.c                         |  14 +++++
 23 files changed, 305 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/cpu_isolated.h
 create mode 100644 kernel/time/cpu_isolated.c

-- 
2.1.2
