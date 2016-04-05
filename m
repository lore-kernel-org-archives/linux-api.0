From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v12 00/13] support "task_isolation" mode
Date: Tue, 5 Apr 2016 13:38:29 -0400
Message-ID: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Here is a respin of the task-isolation patch set.  The previous one
came out just before the merge window for 4.6 opened, so I suspect
folks may have been busy merging, since it got few comments.

Frederic, how are you feeling about taking this all via your tree?
And what is your take on the new PR_TASK_ISOLATION_ONE_SHOT mode?
I'm not sure what the right path to upstream for this series is.

Changes since v11:

- Rebased on v4.6-rc1.  This required me to create a
  can_stop_my_full_tick() helper in tick-sched.c, since the underlying
  can_stop_full_tick() now takes a struct tick_sched.

- Added a HAVE_ARCH_TASK_ISOLATION Kconfig flag so that you can't
  try to build with TASK_ISOLATION enabled for an architecture until
  it is explicitly configured to work.  This avoids possible
  allyesconfig build failures for unsupported architectures, or even
  for supported ones when bisecting to the middle of this series.

- Return EAGAIN instead of EINVAL for the enabling prctl() if the task
  is affinitized to a task-isolation core, but things just aren't yet
  right for it (e.g. another task running).  This lets the caller
  differentiate a potentially transient failure from a permanent
  failure, for which we still return EINVAL.

The previous (v11) patch series is here:

https://lkml.kernel.org/r/1457734223-26209-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org

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
 arch/arm64/Kconfig                     |   1 +
 arch/arm64/include/asm/thread_info.h   |   5 +-
 arch/arm64/kernel/entry.S              |  12 +-
 arch/arm64/kernel/ptrace.c             |  15 +-
 arch/arm64/kernel/signal.c             |  42 ++++-
 arch/arm64/kernel/smp.c                |   2 +
 arch/arm64/mm/fault.c                  |   4 +
 arch/tile/Kconfig                      |   1 +
 arch/tile/include/asm/thread_info.h    |   4 +-
 arch/tile/kernel/process.c             |   9 +
 arch/tile/kernel/ptrace.c              |   7 +
 arch/tile/kernel/single_step.c         |   5 +
 arch/tile/kernel/smp.c                 |  28 +--
 arch/tile/kernel/time.c                |   1 +
 arch/tile/kernel/unaligned.c           |   3 +
 arch/tile/mm/fault.c                   |   3 +
 arch/tile/mm/homecache.c               |   2 +
 arch/x86/Kconfig                       |   1 +
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
 init/Kconfig                           |  33 ++++
 kernel/Makefile                        |   1 +
 kernel/fork.c                          |   3 +
 kernel/irq_work.c                      |   5 +-
 kernel/isolation.c                     | 316 +++++++++++++++++++++++++++++++++
 kernel/sched/core.c                    |  18 ++
 kernel/signal.c                        |   8 +
 kernel/smp.c                           |   6 +-
 kernel/softirq.c                       |  33 ++++
 kernel/sys.c                           |   9 +
 kernel/time/tick-sched.c               |  36 ++--
 mm/swap.c                              |  15 +-
 mm/vmstat.c                            |  21 +++
 45 files changed, 743 insertions(+), 54 deletions(-)
 create mode 100644 include/linux/isolation.h
 create mode 100644 kernel/isolation.c

-- 
2.7.2
