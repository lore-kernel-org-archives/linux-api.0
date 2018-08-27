From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/14] y2038 syscall changes for 4.20
Date: Mon, 27 Aug 2018 21:45:17 +0200
Message-ID: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

I've rebased the syscall changes on top of 4.19-rc1, and the old_time32
rename. This is the first set of those patches, the ones that I hope
are all uncontroversial and obvious now. I'm still in the process of
reorganizing and testing the next set batch top, and plan to send them
after you've merged these.

The first three patches are new here, the other ones have been posted
before a few times.

      Arnd

Arnd Bergmann (14):
  y2038: remove unused time interfaces
  y2038: make do_gettimeofday() and get_seconds() inline
  y2038: globally rename compat_time to old_time32
  y2038: Remove newstat family from default syscall set
  y2038: Remove stat64 family from default syscall set
  asm-generic: Move common compat types to asm-generic/compat.h
  asm-generic: Remove unneeded __ARCH_WANT_SYS_LLSEEK macro
  asm-generic: Remove empty asm/unistd.h
  y2038: Change sys_utimensat() to use __kernel_timespec
  y2038: Compile utimes()/futimesat() conditionally
  y2038: utimes: Rework #ifdef guards for compat syscalls
  y2038: sched: Change sched_rr_get_interval to use __kernel_timespec
  y2038: socket: Change recvmmsg to use __kernel_timespec
  y2038: signal: Change rt_sigtimedwait to use __kernel_timespec

 arch/alpha/include/asm/unistd.h          |   2 +
 arch/arc/include/uapi/asm/unistd.h       |   1 +
 arch/arm/include/asm/unistd.h            |   4 +-
 arch/arm64/include/asm/compat.h          |  26 ++----
 arch/arm64/include/asm/stat.h            |   2 +-
 arch/arm64/include/asm/unistd.h          |   2 +-
 arch/arm64/include/uapi/asm/unistd.h     |   1 +
 arch/c6x/include/uapi/asm/unistd.h       |   1 +
 arch/h8300/include/uapi/asm/unistd.h     |   1 +
 arch/hexagon/include/uapi/asm/unistd.h   |   1 +
 arch/ia64/include/asm/unistd.h           |   3 +
 arch/m68k/include/asm/unistd.h           |   2 +-
 arch/microblaze/include/asm/unistd.h     |   2 +-
 arch/mips/include/asm/compat.h           |  28 ++-----
 arch/mips/include/asm/unistd.h           |   3 +-
 arch/mips/kernel/binfmt_elfn32.c         |  14 ++--
 arch/mips/kernel/binfmt_elfo32.c         |  14 ++--
 arch/nds32/include/uapi/asm/unistd.h     |   1 +
 arch/nios2/include/uapi/asm/unistd.h     |   1 +
 arch/openrisc/include/uapi/asm/unistd.h  |   1 +
 arch/parisc/include/asm/compat.h         |  24 ++----
 arch/parisc/include/asm/unistd.h         |   3 +-
 arch/powerpc/include/asm/compat.h        |  24 ++----
 arch/powerpc/include/asm/unistd.h        |   3 +-
 arch/powerpc/kernel/asm-offsets.c        |   8 +-
 arch/powerpc/oprofile/backtrace.c        |   2 +-
 arch/s390/include/asm/compat.h           |  18 +---
 arch/s390/include/asm/unistd.h           |   3 +-
 arch/sh/include/asm/unistd.h             |   2 +-
 arch/sparc/include/asm/compat.h          |  25 ++----
 arch/sparc/include/asm/unistd.h          |   3 +-
 arch/unicore32/include/uapi/asm/unistd.h |   1 +
 arch/x86/include/asm/compat.h            |  19 +----
 arch/x86/include/asm/unistd.h            |   3 +-
 arch/xtensa/include/asm/unistd.h         |   2 +-
 fs/aio.c                                 |   8 +-
 fs/compat_binfmt_elf.c                   |   2 +-
 fs/read_write.c                          |   2 +-
 fs/select.c                              |  20 ++---
 fs/stat.c                                |   3 +
 fs/timerfd.c                             |  12 +--
 fs/utimes.c                              |  73 ++++++++--------
 include/asm-generic/compat.h             |  24 +++++-
 include/asm-generic/unistd.h             |  13 ---
 include/linux/compat.h                   | 101 +++++++++++------------
 include/linux/compat_time.h              |  32 -------
 include/linux/elfcore-compat.h           |   8 +-
 include/linux/restart_block.h            |   4 +-
 include/linux/socket.h                   |   4 +-
 include/linux/syscalls.h                 |  21 +++--
 include/linux/time32.h                   |  78 ++++++++---------
 include/linux/timekeeping.h              |  12 ---
 include/linux/timekeeping32.h            |  53 ++----------
 include/uapi/asm-generic/unistd.h        |   2 +
 ipc/mqueue.c                             |   8 +-
 ipc/msg.c                                |   6 +-
 ipc/sem.c                                |  10 +--
 ipc/shm.c                                |   6 +-
 ipc/syscall.c                            |   2 +-
 ipc/util.h                               |   2 +-
 kernel/compat.c                          |   8 +-
 kernel/futex_compat.c                    |   2 +-
 kernel/sched/core.c                      |   8 +-
 kernel/signal.c                          |  19 +++--
 kernel/time/hrtimer.c                    |   8 +-
 kernel/time/posix-stubs.c                |  18 ++--
 kernel/time/posix-timers.c               |  30 +++----
 kernel/time/time.c                       |  97 +++++++++-------------
 kernel/time/timekeeping.c                |  24 ------
 net/compat.c                             |  10 +--
 net/socket.c                             |  18 ++--
 71 files changed, 397 insertions(+), 601 deletions(-)
 delete mode 100644 include/asm-generic/unistd.h
 delete mode 100644 include/linux/compat_time.h

-- 
2.18.0
