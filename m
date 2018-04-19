From: Arnd Bergmann <arnd@arndb.de>
Subject: [tip GIT PULL v2] y2038: timekeeping syscall changes
Date: Thu, 19 Apr 2018 13:45:07 +0200
Message-ID: <CAK8P3a0-n-Qabdr+5hwjq8wa9nZHtFwcE32WsW8ZTbKjtpiBUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the git repository at:

  git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
tags/y2038-timekeeping

for you to fetch changes up to 01909974b41036a6a8d3907c66cc7b41c9a73da9:

  time: Change nanosleep to safe __kernel_* types (2018-04-19 13:32:03 +0200)

----------------------------------------------------------------
y2038: timekeeping syscall changes

This is the first set of system call entry point changes to enable 32-bit
architectures to have variants on both 32-bit and 64-bit time_t. Typically
these system calls take a 'struct timespec' argument, but that structure
is defined in user space by the C library and its layout will change.

The kernel already supports handling the 32-bit time_t on 64-bit
architectures through the CONFIG_COMPAT mechanism. As there are a total
of 51 system calls suffering from this problem, reusing that mechanism
on 32-bit architectures.

We already have patches for most of the remaining system calls, but this
set contains most of the complexity and is best tested.  There was one
last-minute regression that prevented it from going into 4.17, but that
is fixed now.

More details from Deepa's patch series description:

   Big picture is as per the lwn article:
   https://lwn.net/Articles/643234/ [2]

   The series is directed at converting posix clock syscalls:
   clock_gettime, clock_settime, clock_getres and clock_nanosleep
   to use a new data structure __kernel_timespec at syscall boundaries.
   __kernel_timespec maintains 64 bit time_t across all execution modes.

   vdso will be handled as part of each architecture when they enable
   support for 64 bit time_t.

   The compat syscalls are repurposed to provide backward compatibility
   by using them as native syscalls as well for 32 bit architectures.
   They will continue to use timespec at syscall boundaries.

   CONFIG_64_BIT_TIME controls whether the syscalls use __kernel_timespec
   or timespec at syscall boundaries.

   The series does the following:
   1. Enable compat syscalls on 32 bit architectures.
   2. Add a new __kernel_timespec type to be used as the data structure
      for all the new syscalls.
   3. Add new config CONFIG_64BIT_TIME(intead of the CONFIG_COMPAT_TIME in
      [1] and [2] to switch to new definition of __kernel_timespec. It is
      the same as struct timespec otherwise.
   4. Add new CONFIG_32BIT_TIME to conditionally compile compat syscalls.

----------------------------------------------------------------
v2: rewrote subject lines as suggested by Thomas, the contents
      are unchanged. I Hope I understood all the requests right.

Arnd Bergmann (2):
      time: Add an asm-generic/compat.h file
      sparc: compat: Allow including asm/compat.h for 32-bit

Deepa Dinamani (10):
      compat: Make compat helpers independent of CONFIG_COMPAT
      compat: Move compat_timespec/ timeval to compat_time.h
      compat: Enable compat_get/put_timespec64 always
      time: Introduce CONFIG_64BIT_TIME in architectures
      time: Introduce CONFIG_COMPAT_32BIT_TIME
      posix-timers: Make compat syscalls depend on CONFIG_COMPAT_32BIT_TIME
      time: Add new y2038 safe __kernel_timespec
      time: Fix get_timespec64() for y2038 safe compat interfaces
      time: Change types to new y2038 safe __kernel_* types
      time: Change nanosleep to safe __kernel_* types

 arch/Kconfig                           | 15 +++++++++
 arch/alpha/include/asm/Kbuild          |  1 +
 arch/arc/include/asm/Kbuild            |  1 +
 arch/arm/include/asm/Kbuild            |  1 +
 arch/arm64/include/asm/compat.h        | 11 -------
 arch/arm64/include/asm/stat.h          |  1 +
 arch/arm64/kernel/hw_breakpoint.c      |  1 -
 arch/arm64/kernel/perf_regs.c          |  2 +-
 arch/c6x/include/asm/Kbuild            |  1 +
 arch/h8300/include/asm/Kbuild          |  1 +
 arch/hexagon/include/asm/Kbuild        |  1 +
 arch/ia64/include/asm/Kbuild           |  1 +
 arch/m68k/include/asm/Kbuild           |  1 +
 arch/microblaze/include/asm/Kbuild     |  1 +
 arch/mips/include/asm/compat.h         | 11 -------
 arch/mips/kernel/signal32.c            |  2 +-
 arch/nds32/include/asm/Kbuild          |  1 +
 arch/nios2/include/asm/Kbuild          |  1 +
 arch/openrisc/include/asm/Kbuild       |  1 +
 arch/parisc/include/asm/compat.h       | 11 -------
 arch/powerpc/include/asm/compat.h      | 11 -------
 arch/powerpc/kernel/asm-offsets.c      |  2 +-
 arch/powerpc/oprofile/backtrace.c      |  1 +
 arch/s390/hypfs/hypfs_sprp.c           |  1 -
 arch/s390/include/asm/compat.h         | 11 -------
 arch/s390/include/asm/elf.h            |  4 +--
 arch/s390/kvm/priv.c                   |  1 -
 arch/s390/pci/pci_clp.c                |  1 -
 arch/sh/include/asm/Kbuild             |  1 +
 arch/sparc/include/asm/compat.h        | 15 +++------
 arch/um/include/asm/Kbuild             |  1 +
 arch/unicore32/include/asm/Kbuild      |  1 +
 arch/x86/events/core.c                 |  2 +-
 arch/x86/include/asm/compat.h          | 11 -------
 arch/x86/include/asm/ftrace.h          |  2 +-
 arch/x86/kernel/sys_x86_64.c           |  2 +-
 arch/xtensa/include/asm/Kbuild         |  1 +
 drivers/s390/block/dasd_ioctl.c        |  1 -
 drivers/s390/char/fs3270.c             |  1 -
 drivers/s390/char/sclp_ctl.c           |  1 -
 drivers/s390/char/vmcp.c               |  1 -
 drivers/s390/cio/chsc_sch.c            |  1 -
 drivers/s390/net/qeth_core_main.c      |  2 +-
 include/asm-generic/compat.h           |  3 ++
 include/linux/compat.h                 | 12 ++++---
 include/linux/compat_time.h            | 23 ++++++++++++++
 include/linux/restart_block.h          |  7 ++--
 include/linux/syscalls.h               | 13 ++++----
 include/linux/time.h                   |  4 +--
 include/linux/time64.h                 | 10 +++++-
 include/uapi/asm-generic/posix_types.h |  1 +
 include/uapi/linux/time.h              |  7 ++++
 kernel/compat.c                        | 52 +++++-------------------------
 kernel/time/hrtimer.c                  | 10 ++++--
 kernel/time/posix-stubs.c              | 12 ++++---
 kernel/time/posix-timers.c             | 24 ++++++++++----
 kernel/time/time.c                     | 58 +++++++++++++++++++++++++++++++---
 57 files changed, 201 insertions(+), 176 deletions(-)
 create mode 100644 include/asm-generic/compat.h
 create mode 100644 include/linux/compat_time.h
