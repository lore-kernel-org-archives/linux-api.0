From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH v9 00/24] ILP32 for ARM64
Date: Wed, 16 May 2018 11:18:45 +0300
Message-ID: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

This series enables AARCH64 with ILP32 mode.

As supporting work, it introduces ARCH_32BIT_OFF_T configuration
option that is enabled for existing 32-bit architectures but disabled
for new arches (so 64-bit off_t userspace type is used by new userspace).
Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.

Based on kernel v4.16. Tested with LTP, glibc testsuite, trinity, lmbench,
CPUSpec.

This series on github: 
https://github.com/norov/linux/tree/ilp32-4.16
Linaro toolchain:
http://snapshots.linaro.org/components/toolchain/binaries/7.3-2018.04-rc1/aarch64-linux-gnu_ilp32/
Debian repo:
http://people.linaro.org/~wookey/ilp32/
OpenSUSE repo:
https://build.opensuse.org/project/show/devel:ARM:Factory:Contrib:ILP32

Changes:
v3: https://lkml.org/lkml/2014/9/3/704
v4: https://lkml.org/lkml/2015/4/13/691
v5: https://lkml.org/lkml/2015/9/29/911
v6: https://lkml.org/lkml/2016/5/23/661
v7: https://lkml.org/lkml/2017/1/9/213
v8: https://lkml.org/lkml/2017/6/19/624
v9: - rebased on top of v4.16;
    - signal subsystem reworked to avoid code duplication, as requested
      by Dave Martin (patches 18 and 20);
    - new files introduced in series use SPDX notation for license;
    - linux-api and linux-arch CCed as the series changes kernel ABI;
    - checkpatch and other minor fixes.
    - Zhou Chengming's reported-by for patch 2 and signed-off-by for
      patch 21 removed because his email became invalid. Zhou, please
      share your new email.

Andrew Pinski (4):
  arm64: rename COMPAT to AARCH32_EL0 in Kconfig
  arm64:uapi: set __BITS_PER_LONG correctly for ILP32 and LP64
  arm64: ilp32: add sys_ilp32.c and a separate table (in entry.S) to use
    it
  arm64:ilp32: add ARM64_ILP32 to Kconfig

Catalin Marinas (1):
  arm64: ilp32: Make the Kconfig option default y

Dave Martin (1):
  arm64: signal: Make parse_user_sigframe() independent of rt_sigframe
    layout

James Morse (1):
  ptrace: Add compat PTRACE_{G,S}ETSIGMASK handlers

Philipp Tomsich (1):
  arm64:ilp32: add vdso-ilp32 and use for signal return

Yury Norov (16):
  compat ABI: use non-compat openat and open_by_handle_at variants
  32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
  asm-generic: Drop getrlimit and setrlimit syscalls from default list
  thread: move thread bits accessors to separated file
  arm64: ilp32: add documentation on the ILP32 ABI for ARM64
  arm64: rename functions that reference compat term
  arm64: introduce is_a32_task and is_a32_thread (for AArch32 compat)
  arm64: ilp32: add is_ilp32_compat_{task,thread} and TIF_32BIT_AARCH64
  arm64: introduce binfmt_elf32.c
  arm64: change compat_elf_hwcap and compat_elf_hwcap2 prefix to a32
  arm64: ilp32: introduce binfmt_ilp32.c
  arm64: ilp32: share aarch32 syscall handlers
  arm64: signal: share lp64 signal structures and routines to ilp32
  arm64: signal32: move ilp32 and aarch32 common code to separated file
  arm64: ilp32: introduce ilp32-specific sigframe and ucontext
  arm64: ptrace: handle ptrace_request differently for aarch32 and ilp32

 Documentation/arm64/ilp32.txt                 |  45 +++
 arch/Kconfig                                  |  15 +
 arch/arc/Kconfig                              |   1 +
 arch/arc/include/uapi/asm/unistd.h            |   1 +
 arch/arm/Kconfig                              |   1 +
 arch/arm64/Kconfig                            |  18 +-
 arch/arm64/Makefile                           |   3 +
 arch/arm64/include/asm/compat.h               |  19 +-
 arch/arm64/include/asm/elf.h                  |  36 +-
 arch/arm64/include/asm/fpsimd.h               |   2 +-
 arch/arm64/include/asm/ftrace.h               |   2 +-
 arch/arm64/include/asm/hwcap.h                |   8 +-
 arch/arm64/include/asm/is_compat.h            |  78 ++++
 arch/arm64/include/asm/processor.h            |  15 +-
 arch/arm64/include/asm/ptrace.h               |  12 +-
 arch/arm64/include/asm/seccomp.h              |   2 +-
 arch/arm64/include/asm/signal32.h             |  19 +-
 arch/arm64/include/asm/signal32_common.h      |  13 +
 arch/arm64/include/asm/signal_common.h        | 306 +++++++++++++++
 arch/arm64/include/asm/signal_ilp32.h         |  23 ++
 arch/arm64/include/asm/syscall.h              |   2 +-
 arch/arm64/include/asm/thread_info.h          |   4 +-
 arch/arm64/include/asm/unistd.h               |   6 +-
 arch/arm64/include/asm/vdso.h                 |   6 +
 arch/arm64/include/uapi/asm/bitsperlong.h     |   9 +-
 arch/arm64/include/uapi/asm/unistd.h          |  13 +
 arch/arm64/kernel/Makefile                    |   8 +-
 arch/arm64/kernel/armv8_deprecated.c          |   6 +-
 arch/arm64/kernel/asm-offsets.c               |   9 +-
 arch/arm64/kernel/binfmt_elf32.c              |  35 ++
 arch/arm64/kernel/binfmt_ilp32.c              |  87 +++++
 arch/arm64/kernel/cpufeature.c                |  28 +-
 arch/arm64/kernel/cpuinfo.c                   |  18 +-
 arch/arm64/kernel/debug-monitors.c            |   4 +-
 arch/arm64/kernel/entry.S                     |  37 +-
 arch/arm64/kernel/entry32.S                   |  80 ----
 arch/arm64/kernel/entry32_common.S            |  97 +++++
 arch/arm64/kernel/entry_ilp32.S               |  12 +
 arch/arm64/kernel/head.S                      |   2 +-
 arch/arm64/kernel/hw_breakpoint.c             |   8 +-
 arch/arm64/kernel/perf_callchain.c            |  28 +-
 arch/arm64/kernel/perf_regs.c                 |   4 +-
 arch/arm64/kernel/process.c                   |  11 +-
 arch/arm64/kernel/ptrace.c                    |  36 +-
 arch/arm64/kernel/signal.c                    | 352 +++---------------
 arch/arm64/kernel/signal32.c                  | 111 +++---
 arch/arm64/kernel/signal32_common.c           |  37 ++
 arch/arm64/kernel/signal_ilp32.c              |  65 ++++
 arch/arm64/kernel/sys_compat.c                |  10 +-
 arch/arm64/kernel/sys_ilp32.c                 |  90 +++++
 arch/arm64/kernel/traps.c                     |  11 +-
 arch/arm64/kernel/vdso-ilp32/.gitignore       |   2 +
 arch/arm64/kernel/vdso-ilp32/Makefile         |  82 ++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     |  22 ++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S |  84 +++++
 arch/arm64/kernel/vdso.c                      |  65 +++-
 arch/arm64/kernel/vdso/gettimeofday.S         |  20 +-
 arch/arm64/kernel/vdso/vdso.S                 |   6 +-
 arch/arm64/mm/mmap.c                          |   2 +-
 arch/blackfin/Kconfig                         |   1 +
 arch/c6x/include/uapi/asm/unistd.h            |   1 +
 arch/cris/Kconfig                             |   1 +
 arch/frv/Kconfig                              |   1 +
 arch/h8300/Kconfig                            |   1 +
 arch/h8300/include/uapi/asm/unistd.h          |   1 +
 arch/hexagon/Kconfig                          |   1 +
 arch/hexagon/include/uapi/asm/unistd.h        |   1 +
 arch/m32r/Kconfig                             |   1 +
 arch/m68k/Kconfig                             |   1 +
 arch/metag/Kconfig                            |   1 +
 arch/metag/include/uapi/asm/unistd.h          |   1 +
 arch/microblaze/Kconfig                       |   1 +
 arch/mips/Kconfig                             |   1 +
 arch/mn10300/Kconfig                          |   1 +
 arch/nios2/Kconfig                            |   1 +
 arch/nios2/include/uapi/asm/unistd.h          |   1 +
 arch/openrisc/Kconfig                         |   1 +
 arch/openrisc/include/uapi/asm/unistd.h       |   1 +
 arch/parisc/Kconfig                           |   1 +
 arch/powerpc/Kconfig                          |   1 +
 arch/score/Kconfig                            |   1 +
 arch/score/include/uapi/asm/unistd.h          |   1 +
 arch/sh/Kconfig                               |   1 +
 arch/sparc/Kconfig                            |   1 +
 arch/tile/Kconfig                             |   1 +
 arch/tile/include/uapi/asm/unistd.h           |   1 +
 arch/tile/kernel/compat.c                     |   3 +
 arch/unicore32/Kconfig                        |   1 +
 arch/unicore32/include/uapi/asm/unistd.h      |   1 +
 arch/x86/Kconfig                              |   1 +
 arch/x86/um/Kconfig                           |   1 +
 arch/xtensa/Kconfig                           |   1 +
 drivers/clocksource/arm_arch_timer.c          |   4 +-
 include/linux/fcntl.h                         |   2 +-
 include/linux/sched.h                         |   1 +
 include/linux/thread_bits.h                   |  76 ++++
 include/linux/thread_info.h                   |  64 +---
 include/uapi/asm-generic/unistd.h             |  10 +-
 kernel/ptrace.c                               |  48 ++-
 scripts/checksyscalls.sh                      |   5 +
 100 files changed, 1675 insertions(+), 698 deletions(-)
 create mode 100644 Documentation/arm64/ilp32.txt
 create mode 100644 arch/arm64/include/asm/is_compat.h
 create mode 100644 arch/arm64/include/asm/signal32_common.h
 create mode 100644 arch/arm64/include/asm/signal_common.h
 create mode 100644 arch/arm64/include/asm/signal_ilp32.h
 create mode 100644 arch/arm64/kernel/binfmt_elf32.c
 create mode 100644 arch/arm64/kernel/binfmt_ilp32.c
 create mode 100644 arch/arm64/kernel/entry32_common.S
 create mode 100644 arch/arm64/kernel/entry_ilp32.S
 create mode 100644 arch/arm64/kernel/signal32_common.c
 create mode 100644 arch/arm64/kernel/signal_ilp32.c
 create mode 100644 arch/arm64/kernel/sys_ilp32.c
 create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
 create mode 100644 include/linux/thread_bits.h

-- 
2.17.0
