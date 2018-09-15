From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] y2038: convert more syscalls
Date: Sat, 15 Sep 2018 22:35:53 +0200
Message-ID: <CAK8P3a0=Ufw7AvwLnwH2tbOWc6rnKuE3DZ9W6TqcOo33xZj=TQ@mail.gmail.com>
References: <CAK8P3a3dYscBOj-v+OJK6QJk_ruuhKO0GaXW1ZjXfjCqGAfJFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3dYscBOj-v+OJK6QJk_ruuhKO0GaXW1ZjXfjCqGAfJFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Resent due to missing subject

On Sat, Sep 15, 2018 at 5:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Hi Thomas,
>
> Please pull the system call changes into a branch of the tip tree.
> These are the ones I posted right after rc1, with the addition of
> two bug fixes that were contributed by Guenther and the kbuild test
> robot.
>
> I've had the changes in linux-next since then and not received
> any other bug reports or feedback.
>
> I panicked a little at one point when I realized that there is
> a sparc64 specific bug in some of my patches, but I then
> found that at least this series is not affected at all.
>
>         Arnd
>
> The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:
>
>   Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)
>
> are available in the Git repository at:
>
>   git+ssh://git@ra.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git
> tags/y2038
>
> for you to fetch changes up to 67314ec7b0250290cc85eaa7a2f88a8ddb9e8547:
>
>   RISC-V: Request newstat syscalls (2018-09-05 22:44:21 +0200)
>
> ----------------------------------------------------------------
> y2038: convert more syscalls
>
> Here is another set of system call changes to prepare the change over to
> 64-bit time_t. As before, the strategy is to change system calls that
> take a 'struct timespec' argument over to 'struct __kernel_timespec',
> which for now is defined to be the same but will get redefined to use a
> 64-bit time_t argument once we are ready to modify the system call tables.
>
> The major change from previous patches is that the plan is no longer
> to directly use the 'compat' system calls for providing compatibility
> with the existing 32-bit time_t based entry points. Instead, we rename
> the compat code to something that makes more sense on 32-bit architectures,
> e.g. compat_timespec becomes old_timespec32.
>
> With the renamed types in place, we change over the 'stat' and 'utimes'
> families of system calls, sched_rr_get_interval, recvmmsg and
> rt_sigtimedwait. Another series for poll, select and io_pgetevents is
> currently being tested.
>
> ----------------------------------------------------------------
> Arnd Bergmann (14):
>       y2038: remove unused time interfaces
>       y2038: make do_gettimeofday() and get_seconds() inline
>       y2038: globally rename compat_time to old_time32
>       y2038: Remove newstat family from default syscall set
>       y2038: Remove stat64 family from default syscall set
>       asm-generic: Move common compat types to asm-generic/compat.h
>       asm-generic: Remove unneeded __ARCH_WANT_SYS_LLSEEK macro
>       asm-generic: Remove empty asm/unistd.h
>       y2038: Change sys_utimensat() to use __kernel_timespec
>       y2038: Compile utimes()/futimesat() conditionally
>       y2038: utimes: Rework #ifdef guards for compat syscalls
>       y2038: sched: Change sched_rr_get_interval to use __kernel_timespec
>       y2038: socket: Change recvmmsg to use __kernel_timespec
>       y2038: signal: Change rt_sigtimedwait to use __kernel_timespec
>
> Guenter Roeck (1):
>       RISC-V: Request newstat syscalls
>
> kbuild test robot (1):
>       y2038: __get_old_timespec32() can be static
>
>  arch/alpha/include/asm/unistd.h          |   2 ++
>  arch/arc/include/uapi/asm/unistd.h       |   1 +
>  arch/arm/include/asm/unistd.h            |   4 ++--
>  arch/arm64/include/asm/compat.h          |  26 +++++---------------------
>  arch/arm64/include/asm/stat.h            |   2 +-
>  arch/arm64/include/asm/unistd.h          |   2 +-
>  arch/arm64/include/uapi/asm/unistd.h     |   1 +
>  arch/c6x/include/uapi/asm/unistd.h       |   1 +
>  arch/h8300/include/uapi/asm/unistd.h     |   1 +
>  arch/hexagon/include/uapi/asm/unistd.h   |   1 +
>  arch/ia64/include/asm/unistd.h           |   3 +++
>  arch/m68k/include/asm/unistd.h           |   2 +-
>  arch/microblaze/include/asm/unistd.h     |   2 +-
>  arch/mips/include/asm/compat.h           |  28 +++++-----------------------
>  arch/mips/include/asm/unistd.h           |   3 ++-
>  arch/mips/kernel/binfmt_elfn32.c         |  14 +++++++-------
>  arch/mips/kernel/binfmt_elfo32.c         |  14 +++++++-------
>  arch/nds32/include/uapi/asm/unistd.h     |   1 +
>  arch/nios2/include/uapi/asm/unistd.h     |   1 +
>  arch/openrisc/include/uapi/asm/unistd.h  |   1 +
>  arch/parisc/include/asm/compat.h         |  24 +++++-------------------
>  arch/parisc/include/asm/unistd.h         |   3 ++-
>  arch/powerpc/include/asm/compat.h        |  24 +++++-------------------
>  arch/powerpc/include/asm/unistd.h        |   3 ++-
>  arch/powerpc/kernel/asm-offsets.c        |   8 ++++----
>  arch/powerpc/oprofile/backtrace.c        |   2 +-
>  arch/riscv/include/asm/unistd.h          |   1 +
>  arch/s390/include/asm/compat.h           |  18 ++----------------
>  arch/s390/include/asm/unistd.h           |   3 ++-
>  arch/sh/include/asm/unistd.h             |   2 +-
>  arch/sparc/include/asm/compat.h          |  25 +++++--------------------
>  arch/sparc/include/asm/unistd.h          |   3 ++-
>  arch/unicore32/include/uapi/asm/unistd.h |   1 +
>  arch/x86/include/asm/compat.h            |  19 ++-----------------
>  arch/x86/include/asm/unistd.h            |   3 ++-
>  arch/xtensa/include/asm/unistd.h         |   2 +-
>  fs/aio.c                                 |   8 ++++----
>  fs/compat_binfmt_elf.c                   |   2 +-
>  fs/read_write.c                          |   2 +-
>  fs/select.c                              |  20 ++++++++++----------
>  fs/stat.c                                |   3 +++
>  fs/timerfd.c                             |  12 ++++++------
>  fs/utimes.c                              |  73
> +++++++++++++++++++++++++++++++++++--------------------------------------
>  include/asm-generic/compat.h             |  24 +++++++++++++++++++++++-
>  include/asm-generic/unistd.h             |  13 -------------
>  include/linux/compat.h                   | 101
> +++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------
>  include/linux/compat_time.h              |  32 --------------------------------
>  include/linux/elfcore-compat.h           |   8 ++++----
>  include/linux/restart_block.h            |   4 ++--
>  include/linux/socket.h                   |   4 ++--
>  include/linux/syscalls.h                 |  21 ++++++++++++---------
>  include/linux/time32.h                   |  78
> +++++++++++++++++++++++++++++++++++++++++-------------------------------------
>  include/linux/timekeeping.h              |  12 ------------
>  include/linux/timekeeping32.h            |  53
> +++++++----------------------------------------------
>  include/uapi/asm-generic/unistd.h        |   2 ++
>  ipc/mqueue.c                             |   8 ++++----
>  ipc/msg.c                                |   6 +++---
>  ipc/sem.c                                |  10 +++++-----
>  ipc/shm.c                                |   6 +++---
>  ipc/syscall.c                            |   2 +-
>  ipc/util.h                               |   2 +-
>  kernel/compat.c                          |   8 ++++----
>  kernel/futex_compat.c                    |   2 +-
>  kernel/sched/core.c                      |   8 ++++----
>  kernel/signal.c                          |  19 ++++++++++---------
>  kernel/time/hrtimer.c                    |   8 ++++----
>  kernel/time/posix-stubs.c                |  18 +++++++++---------
>  kernel/time/posix-timers.c               |  30 +++++++++++++++---------------
>  kernel/time/time.c                       |  97
> ++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------
>  kernel/time/timekeeping.c                |  24 ------------------------
>  net/compat.c                             |  10 +++++-----
>  net/socket.c                             |  18 ++++++++----------
>  72 files changed, 398 insertions(+), 601 deletions(-)
>  delete mode 100644 include/asm-generic/unistd.h
>  delete mode 100644 include/linux/compat_time.h
>
> Reply
> Forward
> _______________________________________________
> Y2038 mailing list
> Y2038@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/y2038
