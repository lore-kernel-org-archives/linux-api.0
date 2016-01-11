From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 00/13] support "task_isolation" mode for nohz_full
Date: Mon, 11 Jan 2016 16:15:50 -0500
Message-ID: <56941B86.9090009@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451936091-29247-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Ping!  There has been no substantive feedback to this version of
the patch in the week since I posted it, which optimistically suggests
to me that people may be satisfied with it.  If that's true, Frederic,
I assume this would be pulled into your tree?

I have slightly updated the v9 patch series since this posting:

- Incorporated a fix to initialize cpu_isolation_mask early if no
   cpu_isolation= boot argument was given, to avoid crashing on
   CPUMASK_OFFSTACK platforms.

- Incorporated Mark Rutland's changes to convert arm64
   assembly to C code instead of using my own version.

The updated patch series is available in the branch at

git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git 
dataplane

I will post a v10 with those couple of small changes if I don't hear
any other feedback, or of course feel free to pull from the git repo.

On 01/04/2016 02:34 PM, Chris Metcalf wrote:
> It has been a couple of months since the v8 version of this patch,
> since various other priorities came up at work.  Since it's been
> a while I will try to summarize where I think we got to on the
> various issues that were raised with v8.
>
> 1. Andy Lutomirski raised the issue of whether it really made sense to
>     only attempt to set up the conditions for task isolation, ask the kernel
>     nicely for it, and then wait until it happened.  He wondered if a
>     SCHED_ISOLATED class might be a helpful abstraction.  Steven Rostedt
>     also suggested having an interface that would force everything else
>     off a core to enable SCHED_ISOLATED to succeed.  Frederick added
>     some concerns about enforcing the test that the process was in a
>     good state to enter task isolation.
>
>     I tried to address the different design philosphies for what I called
>     the original "polite" mode and the reviewers' suggestions for an
>     "aggressive" mode in this email:
>
>     https://lkml.org/lkml/2015/10/26/625
>
>     As I said there, on balance I think the "polite" option is still
>     better.  Obviously folks are welcome to disagree and I'm happy to
>     continue that conversation (or perhaps I convinced everyone).
>
> 2. Andy didn't like the idea of having a "STRICT" mode which
>     delivered a signal to a process for violating the contract that it
>     will promise to stay out of the kernel.  Gilad Ben Yossef argued that
>     it made sense to have a way for the kernel to enforce the requested
>     correctness guarantee of never being interrupted.  Andy pointed out
>     that we should then really deliver such a signal when the kernel
>     delivers an asynchronous interrupt to the core as well.  In particular
>     this is a concern for the application-error case of a process that
>     calls unmap() on one core while a thread on another core is running
>     STRICT, and thus gets an unexpected TLB flush.
>
>     This patch series addresses that concern by including support for
>     IRQs, IPIs, and similar asynchronous interrupts to also send the
>     STRICT signal to the process.  We don't try to send the signal if
>     we are in an NMI, and instead just force a console backtrace like
>     you would get in task_isolation_debug mode.
>
> 3. Frederick nack'ed my patch for a boot flag to disable the 1Hz
>     periodic scheduler tick.
>
>     I'm still hoping he's open to changing his mind about that, but in
>     this patch series I have removed that boot flag.
>
> Various other changes have been introduced since v8:
>
> https://lkml.kernel.org/r/1445373372-6567-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org
>
> - Rebased to Linux 4.4-rc5.
>
> - Since nohz_full and isolnodes have been separated back out again in
>    4.4, I introduced a new task_isolation=MASK boot argument that sets
>    both of them.  The task isolation support now requires that this
>    boot flag have been used; it intentionally doesn't work if you've
>    just enabled nohz_full and isolcpus separately.  I could be
>    convinced that doing it the other way around makes sense, though.
>
> - I folded the two STRICT mode patches together since there didn't
>    seem to be much value in having the second patch that just enabled
>    having a settable signal.  I also refactored the various routines
>    that report on interrupts/exceptions/etc to make it easier to hook
>    in from the case where we are interrupted asynchronously.
>
> - For the debug support, I moved most of the functionality into
>    kernel/isolation.c and out of kernel/sched/core.c, leaving only a
>    small hook to handle mapping a remote cpu to a task struct safely.
>    In addition to implementing Andy's suggestion of signalling a task
>    when it is interrupted asynchronously, I also added a ratelimit
>    hook so we won't spam the console if (for example) a timer interrupt
>    runs amok - particularly since when this happens without ratelimit,
>    it can end up self-perpetuating the timer interrupt.
>
> - I added a task_isolation_debug_cpumask() helper function to check
>    all the cpus in a mask to see if they are being interrupted
>    inappropriately.
>
> - I made the check for irq_enter() robust to architectures that
>    have already entered user mode context_tracking before calling
>    irq_enter() by testing user_mode(get_irq_regs()) instead of
>    context_tracking_in_user(), and split out the code to a separate
>    inlined function so I could comment it better.
>
> - For arm64, I added a task_isolation_debug_cpumask() hook for
>    smp_cross_call(), which I had missed in the earlier versions.
>
> - I generalized the fix for tile to set up a clockevents hook for
>    set_state_oneshot_stopped() to also apply to the arm_arch_timer,
>    which I realized was showing the same problem.  For both cases,
>    this seems to be what Viresh had in mind with commit 8fff52fd509345
>    ("clockevents: Introduce CLOCK_EVT_STATE_ONESHOT_STOPPED state").
>
> - For tile, I adopted the arm model of doing user_exit() calls in the
>    early assembly code (a new patch in this series).  I also added a
>    missing task_isolation_debug hook for tile's IPI and remote cache
>    flush code.
>
> Chris Metcalf (12):
>    vmstat: add vmstat_idle function
>    lru_add_drain_all: factor out lru_add_drain_needed
>    task_isolation: add initial support
>    task_isolation: support PR_TASK_ISOLATION_STRICT mode
>    task_isolation: add debug boot flag
>    arch/x86: enable task isolation functionality
>    arch/arm64: adopt prepare_exit_to_usermode() model from x86
>    arch/arm64: enable task isolation functionality
>    arch/tile: adopt prepare_exit_to_usermode() model from x86
>    arch/tile: move user_exit() to early kernel entry sequence
>    arch/tile: enable task isolation functionality
>    arm, tile: turn off timer tick for oneshot_stopped state
>
> Christoph Lameter (1):
>    vmstat: provide a function to quiet down the diff processing
>
>   Documentation/kernel-parameters.txt  |  16 +++
>   arch/arm64/include/asm/thread_info.h |  18 ++-
>   arch/arm64/kernel/entry.S            |   6 +-
>   arch/arm64/kernel/ptrace.c           |  12 +-
>   arch/arm64/kernel/signal.c           |  35 ++++--
>   arch/arm64/kernel/smp.c              |   2 +
>   arch/arm64/mm/fault.c                |   4 +
>   arch/tile/include/asm/processor.h    |   2 +-
>   arch/tile/include/asm/thread_info.h  |   8 +-
>   arch/tile/kernel/intvec_32.S         |  51 +++-----
>   arch/tile/kernel/intvec_64.S         |  54 +++------
>   arch/tile/kernel/process.c           |  83 +++++++------
>   arch/tile/kernel/ptrace.c            |  19 +--
>   arch/tile/kernel/single_step.c       |   8 +-
>   arch/tile/kernel/smp.c               |  26 ++--
>   arch/tile/kernel/time.c              |   1 +
>   arch/tile/kernel/traps.c             |  13 +-
>   arch/tile/kernel/unaligned.c         |  16 ++-
>   arch/tile/mm/fault.c                 |   6 +-
>   arch/tile/mm/homecache.c             |   2 +
>   arch/x86/entry/common.c              |  10 +-
>   arch/x86/kernel/traps.c              |   2 +
>   arch/x86/mm/fault.c                  |   2 +
>   drivers/clocksource/arm_arch_timer.c |   2 +
>   include/linux/isolation.h            |  80 +++++++++++++
>   include/linux/sched.h                |   3 +
>   include/linux/swap.h                 |   1 +
>   include/linux/vmstat.h               |   4 +
>   include/uapi/linux/prctl.h           |   8 ++
>   init/Kconfig                         |  20 ++++
>   kernel/Makefile                      |   1 +
>   kernel/irq_work.c                    |   5 +-
>   kernel/isolation.c                   | 225 +++++++++++++++++++++++++++++++++++
>   kernel/sched/core.c                  |  18 +++
>   kernel/signal.c                      |   5 +
>   kernel/smp.c                         |   6 +-
>   kernel/softirq.c                     |  33 +++++
>   kernel/sys.c                         |   9 ++
>   mm/swap.c                            |  13 +-
>   mm/vmstat.c                          |  24 ++++
>   40 files changed, 665 insertions(+), 188 deletions(-)
>   create mode 100644 include/linux/isolation.h
>   create mode 100644 kernel/isolation.c
>

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
