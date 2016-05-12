From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v12 00/13] support "task_isolation" mode
Date: Thu, 12 May 2016 14:26:34 -0400
Message-ID: <8219b947-5613-2507-15bc-29c4f31a3078@mellanox.com>
References: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Ping, since the 4.7 merge window is opening soon and I haven't received
too much feedback on this version of the patch series based on 4.6-rc1.

1. Patch 09/13 for timer ticks was acked by Daniel Lezcano and is standalone,
    so could be taken into the relevant trees.  I'm not sure if it should go in
    as two separate patches through the tile and arm architecture trees,
    or through the timer tree as a combined patch.  Catalin/Will, any ideas?

    http://lkml.kernel.org/g/1459877922-15512-10-git-send-email-cmetcalf@mellanox.com

2. Patch 12/13, factoring the work_pending state machine for ARM64 into C,
    should go via the arm64 tree.  Mark Rutland should probably Ack it but then
    it should go via the ARM64 tree:

    http://lkml.kernel.org/g/1459877922-15512-13-git-send-email-cmetcalf@mellanox.com

3. Frederick provided some more feedback and I think we are still waiting
    to close the loop on the notion of how strict we should be by default:

    http://lkml.kernel.org/g/571E7FC9.60405@mellanox.com

We have been flogging this patch series along for just over a year now;
v1 of the patch series was sent on May 8, 2015.  Phew!

On 4/5/2016 1:38 PM, Chris Metcalf wrote:
> Here is a respin of the task-isolation patch set.  The previous one
> came out just before the merge window for 4.6 opened, so I suspect
> folks may have been busy merging, since it got few comments.
>
> Frederic, how are you feeling about taking this all via your tree?
> And what is your take on the new PR_TASK_ISOLATION_ONE_SHOT mode?
> I'm not sure what the right path to upstream for this series is.
>
> Changes since v11:
>
> - Rebased on v4.6-rc1.  This required me to create a
>    can_stop_my_full_tick() helper in tick-sched.c, since the underlying
>    can_stop_full_tick() now takes a struct tick_sched.
>
> - Added a HAVE_ARCH_TASK_ISOLATION Kconfig flag so that you can't
>    try to build with TASK_ISOLATION enabled for an architecture until
>    it is explicitly configured to work.  This avoids possible
>    allyesconfig build failures for unsupported architectures, or even
>    for supported ones when bisecting to the middle of this series.
>
> - Return EAGAIN instead of EINVAL for the enabling prctl() if the task
>    is affinitized to a task-isolation core, but things just aren't yet
>    right for it (e.g. another task running).  This lets the caller
>    differentiate a potentially transient failure from a permanent
>    failure, for which we still return EINVAL.
>
> The previous (v11) patch series is here:
>
> https://lkml.kernel.org/r/1457734223-26209-1-git-send-email-cmetcalf@mellanox.com
>
> This version of the patch series has been tested on arm64 and tile,
> and build-tested on x86.
>
> It remains true that the 1 Hz tick needs to be disabled for this
> patch series to be able to achieve its primary goal of enabling
> truly tick-free operation, but that is ongoing orthogonal work.
>
> The series is available at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git dataplane
>
> Chris Metcalf (13):
>    vmstat: add quiet_vmstat_sync function
>    vmstat: add vmstat_idle function
>    lru_add_drain_all: factor out lru_add_drain_needed
>    task_isolation: add initial support
>    task_isolation: support CONFIG_TASK_ISOLATION_ALL
>    task_isolation: support PR_TASK_ISOLATION_STRICT mode
>    task_isolation: add debug boot flag
>    task_isolation: add PR_TASK_ISOLATION_ONE_SHOT flag
>    arm, tile: turn off timer tick for oneshot_stopped state
>    arch/x86: enable task isolation functionality
>    arch/tile: enable task isolation functionality
>    arm64: factor work_pending state machine to C
>    arch/arm64: enable task isolation functionality
>
>   Documentation/kernel-parameters.txt    |  16 ++
>   arch/arm64/Kconfig                     |   1 +
>   arch/arm64/include/asm/thread_info.h   |   5 +-
>   arch/arm64/kernel/entry.S              |  12 +-
>   arch/arm64/kernel/ptrace.c             |  15 +-
>   arch/arm64/kernel/signal.c             |  42 ++++-
>   arch/arm64/kernel/smp.c                |   2 +
>   arch/arm64/mm/fault.c                  |   4 +
>   arch/tile/Kconfig                      |   1 +
>   arch/tile/include/asm/thread_info.h    |   4 +-
>   arch/tile/kernel/process.c             |   9 +
>   arch/tile/kernel/ptrace.c              |   7 +
>   arch/tile/kernel/single_step.c         |   5 +
>   arch/tile/kernel/smp.c                 |  28 +--
>   arch/tile/kernel/time.c                |   1 +
>   arch/tile/kernel/unaligned.c           |   3 +
>   arch/tile/mm/fault.c                   |   3 +
>   arch/tile/mm/homecache.c               |   2 +
>   arch/x86/Kconfig                       |   1 +
>   arch/x86/entry/common.c                |  18 +-
>   arch/x86/include/asm/thread_info.h     |   2 +
>   arch/x86/kernel/traps.c                |   2 +
>   arch/x86/mm/fault.c                    |   2 +
>   drivers/base/cpu.c                     |  18 ++
>   drivers/clocksource/arm_arch_timer.c   |   2 +
>   include/linux/context_tracking_state.h |   6 +
>   include/linux/isolation.h              |  63 +++++++
>   include/linux/sched.h                  |   3 +
>   include/linux/swap.h                   |   1 +
>   include/linux/tick.h                   |   2 +
>   include/linux/vmstat.h                 |   4 +
>   include/uapi/linux/prctl.h             |   9 +
>   init/Kconfig                           |  33 ++++
>   kernel/Makefile                        |   1 +
>   kernel/fork.c                          |   3 +
>   kernel/irq_work.c                      |   5 +-
>   kernel/isolation.c                     | 316 +++++++++++++++++++++++++++++++++
>   kernel/sched/core.c                    |  18 ++
>   kernel/signal.c                        |   8 +
>   kernel/smp.c                           |   6 +-
>   kernel/softirq.c                       |  33 ++++
>   kernel/sys.c                           |   9 +
>   kernel/time/tick-sched.c               |  36 ++--
>   mm/swap.c                              |  15 +-
>   mm/vmstat.c                            |  21 +++
>   45 files changed, 743 insertions(+), 54 deletions(-)
>   create mode 100644 include/linux/isolation.h
>   create mode 100644 kernel/isolation.c
>

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

