From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/5] support "cpu_isolated" mode for nohz_full
Date: Fri, 15 May 2015 17:26:07 -0400
Message-ID: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431107927-13998-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

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

The series (based currently on my arch/tile master tree for 4.2,
in turn based on 4.1-rc1) is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

v2:
  rename "dataplane" to "cpu_isolated"
  drop ksoftirqd suppression changes (believed no longer needed)
  merge previous "QUIESCE" functionality into baseline functionality
  explicitly track syscalls and exceptions for "STRICT" functionality
  allow configuring a signal to be delivered for STRICT mode failures
  move debug tracking to irq_enter(), not irq_exit()

Note: I have not yet removed the hack to disable the 1Hz timer tick
fallback that was nack'ed by PeterZ, pending a decision on that thread
as to what to do (https://lkml.org/lkml/2015/5/8/555).

Chris Metcalf (5):
  nohz_full: add support for "cpu_isolated" mode
  nohz: support PR_CPU_ISOLATED_STRICT mode
  nohz: cpu_isolated strict mode configurable signal
  nohz: add cpu_isolated_debug boot flag
  nohz: cpu_isolated: allow tick to be fully disabled

 Documentation/kernel-parameters.txt |  6 +++
 arch/tile/kernel/ptrace.c           |  6 ++-
 arch/tile/mm/homecache.c            |  5 +-
 arch/x86/kernel/ptrace.c            |  2 +
 include/linux/context_tracking.h    | 11 +++--
 include/linux/sched.h               |  3 ++
 include/linux/tick.h                | 28 +++++++++++
 include/uapi/linux/prctl.h          |  8 +++
 kernel/context_tracking.c           | 12 +++--
 kernel/irq_work.c                   |  4 +-
 kernel/sched/core.c                 | 18 +++++++
 kernel/signal.c                     |  5 ++
 kernel/smp.c                        |  4 ++
 kernel/softirq.c                    |  6 +++
 kernel/sys.c                        |  8 +++
 kernel/time/tick-sched.c            | 98 ++++++++++++++++++++++++++++++++++++-
 16 files changed, 214 insertions(+), 10 deletions(-)

-- 
2.1.2
