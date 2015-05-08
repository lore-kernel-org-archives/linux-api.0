From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Fri, 8 May 2015 13:58:41 -0400
Message-ID: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
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
option (PR_SET_DATAPLANE) is added to control whether processes have
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
workqueues on dataplane cores still remain to be dealt with), this
patch series provides a way to make dynamic tradeoffs between avoiding
kernel interrupts on the one hand, and making voluntary calls in and
out of the kernel more expensive, for tasks that want it.

The series (based currently on my arch/tile master tree for 4.2,
in turn based on 4.1-rc1) is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane

Chris Metcalf (6):
  nohz_full: add support for "dataplane" mode
  nohz: dataplane: allow tick to be fully disabled for dataplane
  dataplane nohz: run softirqs synchronously on user entry
  nohz: support PR_DATAPLANE_QUIESCE
  nohz: support PR_DATAPLANE_STRICT mode
  nohz: add dataplane_debug boot flag

 Documentation/kernel-parameters.txt |   6 ++
 arch/tile/mm/homecache.c            |   5 +-
 include/linux/sched.h               |   3 +
 include/linux/tick.h                |  12 ++++
 include/uapi/linux/prctl.h          |   8 +++
 kernel/context_tracking.c           |   3 +
 kernel/irq_work.c                   |   4 +-
 kernel/sched/core.c                 |  18 ++++++
 kernel/signal.c                     |   5 ++
 kernel/smp.c                        |   4 ++
 kernel/softirq.c                    |  15 ++++-
 kernel/sys.c                        |   8 +++
 kernel/time/tick-sched.c            | 112 +++++++++++++++++++++++++++++++++++-
 13 files changed, 198 insertions(+), 5 deletions(-)

-- 
2.1.2
