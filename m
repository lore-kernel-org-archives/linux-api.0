From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit time_t conversion
Date: Fri, 10 Nov 2017 14:42:50 -0800
Message-ID: <20171110224259.15930-1-deepa.kernel@gmail.com>
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, acme@kernel.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, cmetcalf@mellanox.com, cohuck@redhat.com, davem@davemloft.net, deller@gmx.de, devel@driverdev.osuosl.org, gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, heiko.carstens@de.ibm.com, hoeppner@linux.vnet.ibm.com, hpa@zytor.com, jejb@parisc-linux.org, jwi@linux.vnet.ibm.com, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, mark.rutland@arm.com, mingo@redhat.com, mpe@ellerman.id.au, oberpar@linux.vnet.ibm.com, oprofile-list@lists.sf.net, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org
List-Id: linux-api@vger.kernel.org

The series is a preparation series for individual architectures
to use 64 bit time_t syscalls in compat and 32 bit emulation modes.

This is a follow up to the series Arnd Bergmann posted:
https://sourceware.org/ml/libc-alpha/2015-05/msg00070.html

Big picture is as per the lwn article:
https://lwn.net/Articles/643234/

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
1. Enable compat syscalls unconditionally.
2. Add a new __kernel_timespec type to be used as the data structure
   for all the new syscalls.
3. Add new config CONFIG_64BIT_TIME(intead of the CONFIG_COMPAT_TIME in
   [1] and [2] to switch to new definition of __kernel_timespec. It is
   the same as struct timespec otherwise.

Arnd Bergmann (1):
  y2038: introduce CONFIG_64BIT_TIME

Deepa Dinamani (8):
  include: Move compat_timespec/ timeval to compat_time.h
  compat: Make compat helpers independent of CONFIG_COMPAT
  compat: enable compat_get/put_timespec64 always
  posix-clocks: Enable compat syscalls always
  include: Add new y2038 safe __kernel_timespec
  fix get_timespec64() for y2038 safe compat interfaces
  change time types to new y2038 safe __kernel_* types
  nanosleep: change time types to safe __kernel_* types

 arch/Kconfig                           | 11 ++++
 arch/arm64/include/asm/compat.h        | 11 ----
 arch/arm64/include/asm/stat.h          |  1 +
 arch/arm64/kernel/hw_breakpoint.c      |  1 -
 arch/arm64/kernel/perf_regs.c          |  2 +-
 arch/arm64/kernel/process.c            |  1 -
 arch/mips/include/asm/compat.h         | 11 ----
 arch/mips/kernel/signal32.c            |  2 +-
 arch/parisc/include/asm/compat.h       | 11 ----
 arch/powerpc/include/asm/compat.h      | 11 ----
 arch/powerpc/kernel/asm-offsets.c      |  2 +-
 arch/powerpc/oprofile/backtrace.c      |  2 +-
 arch/s390/hypfs/hypfs_sprp.c           |  1 -
 arch/s390/include/asm/compat.h         | 11 ----
 arch/s390/include/asm/elf.h            |  3 +-
 arch/s390/kvm/priv.c                   |  1 -
 arch/s390/pci/pci_clp.c                |  1 -
 arch/sparc/include/asm/compat.h        | 11 ----
 arch/tile/include/asm/compat.h         | 11 ----
 arch/x86/events/core.c                 |  2 +-
 arch/x86/include/asm/compat.h          | 11 ----
 arch/x86/include/asm/ftrace.h          |  2 +-
 arch/x86/include/asm/sys_ia32.h        |  2 +-
 arch/x86/kernel/sys_x86_64.c           |  2 +-
 drivers/s390/block/dasd_ioctl.c        |  1 -
 drivers/s390/char/fs3270.c             |  1 -
 drivers/s390/char/sclp_ctl.c           |  1 -
 drivers/s390/char/vmcp.c               |  1 -
 drivers/s390/cio/chsc_sch.c            |  1 -
 drivers/s390/net/qeth_core_main.c      |  2 +-
 drivers/staging/pi433/pi433_if.c       |  2 +-
 include/linux/compat.h                 |  7 ++-
 include/linux/compat_time.h            | 23 +++++++++
 include/linux/restart_block.h          |  7 +--
 include/linux/syscalls.h               | 12 ++---
 include/linux/time.h                   |  4 +-
 include/linux/time64.h                 | 10 +++-
 include/uapi/asm-generic/posix_types.h |  1 +
 include/uapi/linux/time.h              |  7 +++
 kernel/Makefile                        |  2 +-
 kernel/compat.c                        | 92 ++++++++++++++++++----------------
 kernel/time/hrtimer.c                  |  7 +--
 kernel/time/posix-stubs.c              | 12 ++---
 kernel/time/posix-timers.c             | 20 ++++----
 kernel/time/time.c                     | 10 +++-
 45 files changed, 152 insertions(+), 195 deletions(-)
 create mode 100644 include/linux/compat_time.h


base-commit: d9e0e63d9a6f88440eb201e1491fcf730272c706
-- 
2.11.0

Cc: acme@kernel.org
Cc: benh@kernel.crashing.org
Cc: borntraeger@de.ibm.com
Cc: catalin.marinas@arm.com
Cc: cmetcalf@mellanox.com
Cc: cohuck@redhat.com
Cc: davem@davemloft.net
Cc: deller@gmx.de
Cc: devel@driverdev.osuosl.org
Cc: gerald.schaefer@de.ibm.com
Cc: gregkh@linuxfoundation.org
Cc: heiko.carstens@de.ibm.com
Cc: hoeppner@linux.vnet.ibm.com
Cc: hpa@zytor.com
Cc: jejb@parisc-linux.org
Cc: jwi@linux.vnet.ibm.com
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: mark.rutland@arm.com
Cc: mingo@redhat.com
Cc: mpe@ellerman.id.au
Cc: oberpar@linux.vnet.ibm.com
Cc: oprofile-list@lists.sf.net
Cc: paulus@samba.org
Cc: peterz@infradead.org
Cc: ralf@linux-mips.org
Cc: rostedt@goodmis.org
Cc: rric@kernel.org
Cc: schwidefsky@de.ibm.com
Cc: sebott@linux.vnet.ibm.com
Cc: sparclinux@vger.kernel.org
Cc: sth@linux.vnet.ibm.com
Cc: ubraun@linux.vnet.ibm.com
Cc: will.deacon@arm.com
Cc: x86@kernel.org
