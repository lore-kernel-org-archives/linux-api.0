From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/15] arch: synchronize syscall tables in preparation for y2038
Date: Thu, 10 Jan 2019 17:24:20 +0100
Message-ID: <20190110162435.309262-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, firoz.khan@linaro.org, ebiederm@xmission.com, deepa.kernel@gmail.com, linux@dominikbrodowski.net, akpm@linux-foundation.org, dave@stgolabs.net, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-paris
List-Id: linux-api@vger.kernel.org

The system call tables have diverged a bit over the years, and a number
of the recent additions never made it into all architectures, for one
reason or another.

This is an attempt to clean it up as far as we can without breaking
compatibility, doing a number of steps:

- Add system calls that have not yet been integrated into all
  architectures but that we definitely want there.

- Add the separate ipc syscalls on all architectures that
  traditionally only had sys_ipc(). This version is done without
  support for IPC_OLD that is we have in sys_ipc. The
  new semtimedop_time64 syscall will only be added here, not
  in sys_ipc

- Add syscall numbers for a couple of syscalls that we probably
  don't need everywhere, in particular pkey_* and rseq,
  for the purpose of symmetry: if it's in asm-generic/unistd.h,
  it makes sense to have it everywhere.

- Prepare for having the same system call numbers for any future
  calls. In combination with the generated tables, this hopefully
  makes it easier to add new calls across all architectures
  together.

Most of the contents of this series are unrelated to the actual
y2038 work, but for the moment, that second series is based on
this one. If there are any concerns about changes here, I
can drop or rewrite any individual patch in this series.

My plan is to merge any patches in this series that are found
to be good together with the y2038 patches for linux-5.1, so
please review and provide Acks for merging through my tree,
or pick them up for 5.0 if they seem urgent enough.

      Arnd

Arnd Bergmann (15):
  ia64: add __NR_umount2 definition
  ia64: add statx and io_pgetevents syscalls
  ia64: assign syscall numbers for perf and seccomp
  alpha: wire up io_pgetevents system call
  alpha: update syscall macro definitions
  ARM: add migrate_pages() system call
  ARM: add kexec_file_load system call number
  m68k: assign syscall number for seccomp
  sh: remove duplicate unistd_32.h file
  sh: add statx system call
  mips: fix n32 compat_ipc_parse_version
  sparc64: fix sparc_ipc type conversion
  ipc: rename old-style shmctl/semctl/msgctl syscalls
  arch: add split IPC system calls where needed
  arch: add pkey and rseq syscall numbers everywhere

 arch/alpha/include/asm/unistd.h             |  10 -
 arch/alpha/include/uapi/asm/unistd.h        |   5 +
 arch/alpha/kernel/syscalls/syscall.tbl      |  15 +-
 arch/arm/include/asm/unistd.h               |   1 -
 arch/arm/tools/syscall.tbl                  |   8 +-
 arch/arm64/include/asm/unistd.h             |   2 +-
 arch/arm64/include/asm/unistd32.h           |  10 +-
 arch/ia64/include/asm/unistd.h              |  14 -
 arch/ia64/include/uapi/asm/unistd.h         |   2 +
 arch/ia64/kernel/syscalls/syscall.tbl       |  10 +-
 arch/m68k/kernel/syscalls/syscall.tbl       |  16 +
 arch/microblaze/kernel/syscalls/syscall.tbl |   6 +-
 arch/mips/Kconfig                           |   1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |   6 +-
 arch/mips/kernel/syscalls/syscall_n64.tbl   |   6 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  11 +
 arch/parisc/include/asm/unistd.h            |   3 -
 arch/parisc/kernel/syscalls/syscall.tbl     |   4 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |  12 +
 arch/s390/include/asm/unistd.h              |   3 -
 arch/s390/kernel/syscalls/syscall.tbl       |  15 +
 arch/sh/include/uapi/asm/unistd_32.h        | 403 --------------------
 arch/sh/kernel/syscalls/syscall.tbl         |  16 +
 arch/sparc/include/asm/unistd.h             |   5 -
 arch/sparc/kernel/sys_sparc_64.c            |   2 +-
 arch/sparc/kernel/syscalls/syscall.tbl      |  16 +
 arch/x86/entry/syscalls/syscall_32.tbl      |  11 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |   7 +-
 include/linux/syscalls.h                    |   3 +
 ipc/msg.c                                   |  39 +-
 ipc/sem.c                                   |  39 +-
 ipc/shm.c                                   |  40 +-
 ipc/syscall.c                               |  12 +-
 ipc/util.h                                  |  21 +-
 kernel/sys_ni.c                             |   3 +
 35 files changed, 271 insertions(+), 506 deletions(-)
 delete mode 100644 arch/sh/include/uapi/asm/unistd_32.h

-- 
2.20.0
Cc: ink@jurassic.park.msu.ru
Cc: mattst88@gmail.com
Cc: linux@armlinux.org.uk
Cc: catalin.marinas@arm.com
Cc: will.deacon@arm.com
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: geert@linux-m68k.org
Cc: monstr@monstr.eu
Cc: paul.burton@mips.com
Cc: deller@gmx.de
Cc: mpe@ellerman.id.au
Cc: schwidefsky@de.ibm.com
Cc: heiko.carstens@de.ibm.com
Cc: dalias@libc.org
Cc: davem@davemloft.net
Cc: luto@kernel.org
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: x86@kernel.org
Cc: jcmvbkbc@gmail.com
Cc: arnd@arndb.de
Cc: firoz.khan@linaro.org
Cc: ebiederm@xmission.com
Cc: deepa.kernel@gmail.com
Cc: linux@dominikbrodowski.net
Cc: akpm@linux-foundation.org
Cc: dave@stgolabs.net
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-ia64@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-api@vger.kernel.org
CC: y2038@lists.linaro.org
