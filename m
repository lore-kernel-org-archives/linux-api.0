From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v4 00/10] posix_clocks: Prepare syscalls for 64 bit time_t
 conversion
Date: Mon, 12 Mar 2018 10:52:57 -0700
Message-ID: <20180312175307.11032-1-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: arnd@arndb.de, tglx@linutronix.de, john.stultz@linaro.org
Cc: mark.rutland@arm.com, linux-mips@linux-mips.org, peterz@infradead.org, benh@kernel.crashing.org, sth@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, paulus@samba.org, hpa@zytor.com, sparclinux@vger.kernel.org, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, y2038@lists.linaro.org, mpe@ellerman.id.au, deller@gmx.de, x86@kernel.org, sebott@linux.vnet.ibm.com, jejb@parisc-linux.org, will.deacon@arm.com, borntraeger@de.ibm.com, mingo@redhat.com, oprofile-list@lists.sf.net, catalin.marinas@arm.com, linux-arch@vger.kernel.org, rric@kernel.org, cmetcalf@mellanox.com, oberpar@linux.vnet.ibm.com, acme@kernel.org, jwi@linux.vnet.ibm.com, rostedt@goodmis.org, ubraun@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, cohuck@redhat.com, linux-kernel@vger.kernel.org, ralf@linux-mips.org, hoeppner@linux.vnet.ibm.com, linux-ap
List-Id: linux-api@vger.kernel.org

The series is a preparation series for individual architectures
to use 64 bit time_t syscalls in compat and 32 bit emulation modes.

This is a follow up to the series Arnd Bergmann posted:
https://sourceware.org/ml/libc-alpha/2015-05/msg00070.html [1]

Thomas, Arnd, this seems ready to be merged now.
Can you help get this merged?

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

* Changes since v3:
 * Updated include file ordering
* Changes since v2:
 * Dropped the ARCH_HAS_64BIT_TIME config.
 * Fixed zeroing out of higher order bits of tv_nsec for real.
 * Addressed minor review comments from v1.
* Changes since v1:
 * Introduce CONFIG_32BIT_TIME
 * Fixed zeroing out of higher order bits of tv_nsec
 * Included Arnd's changes to fix up use of compat headers

I decided against using LEGACY_TIME_SYSCALLS to conditionally compile
legacy time syscalls such as sys_nanosleep because this will need to
enclose compat_sys_nanosleep as well. So, defining it as 

config LEGACY_TIME_SYSCALLS
     def_bool 64BIT || !64BIT_TIME

will not include compat_sys_nanosleep. We will instead need a new config to
exclusively mark legacy syscalls.

Deepa Dinamani (10):
  compat: Make compat helpers independent of CONFIG_COMPAT
  include: Move compat_timespec/ timeval to compat_time.h
  compat: enable compat_get/put_timespec64 always
  arch: introduce CONFIG_64BIT_TIME
  arch: Introduce CONFIG_COMPAT_32BIT_TIME
  posix-clocks: Make compat syscalls depend on CONFIG_COMPAT_32BIT_TIME
  include: Add new y2038 safe __kernel_timespec
  fix get_timespec64() for y2038 safe compat interfaces
  change time types to new y2038 safe __kernel_* types
  nanosleep: change time types to safe __kernel_* types

 arch/Kconfig                           | 15 +++++++++
 arch/arm64/include/asm/compat.h        | 11 -------
 arch/arm64/include/asm/stat.h          |  1 +
 arch/arm64/kernel/hw_breakpoint.c      |  1 -
 arch/arm64/kernel/perf_regs.c          |  2 +-
 arch/arm64/kernel/process.c            |  1 -
 arch/mips/include/asm/compat.h         | 11 -------
 arch/mips/kernel/signal32.c            |  2 +-
 arch/parisc/include/asm/compat.h       | 11 -------
 arch/powerpc/include/asm/compat.h      | 11 -------
 arch/powerpc/kernel/asm-offsets.c      |  2 +-
 arch/powerpc/oprofile/backtrace.c      |  2 +-
 arch/s390/hypfs/hypfs_sprp.c           |  1 -
 arch/s390/include/asm/compat.h         | 11 -------
 arch/s390/include/asm/elf.h            |  4 +--
 arch/s390/kvm/priv.c                   |  1 -
 arch/s390/pci/pci_clp.c                |  1 -
 arch/sparc/include/asm/compat.h        | 11 -------
 arch/tile/include/asm/compat.h         | 11 -------
 arch/x86/events/core.c                 |  2 +-
 arch/x86/include/asm/compat.h          | 11 -------
 arch/x86/include/asm/ftrace.h          |  2 +-
 arch/x86/include/asm/sys_ia32.h        |  2 +-
 arch/x86/kernel/sys_x86_64.c           |  2 +-
 drivers/s390/block/dasd_ioctl.c        |  1 -
 drivers/s390/char/fs3270.c             |  1 -
 drivers/s390/char/sclp_ctl.c           |  1 -
 drivers/s390/char/vmcp.c               |  1 -
 drivers/s390/cio/chsc_sch.c            |  1 -
 drivers/s390/net/qeth_core_main.c      |  2 +-
 include/linux/compat.h                 | 11 ++++---
 include/linux/compat_time.h            | 23 ++++++++++++++
 include/linux/restart_block.h          |  7 ++--
 include/linux/syscalls.h               | 12 +++----
 include/linux/time.h                   |  4 +--
 include/linux/time64.h                 | 10 +++++-
 include/uapi/asm-generic/posix_types.h |  1 +
 include/uapi/linux/time.h              |  7 ++++
 kernel/compat.c                        | 52 +++++-------------------------
 kernel/time/hrtimer.c                  | 10 ++++--
 kernel/time/posix-stubs.c              | 12 ++++---
 kernel/time/posix-timers.c             | 24 ++++++++++----
 kernel/time/time.c                     | 58 +++++++++++++++++++++++++++++++---
 43 files changed, 177 insertions(+), 190 deletions(-)
 create mode 100644 include/linux/compat_time.h


base-commit: 61530b14b059d4838dcc2186e9de9d57e195ce55
-- 
2.14.1

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
