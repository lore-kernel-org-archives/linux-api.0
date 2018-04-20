From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 00/17] siginfo bugfixes and cleanups
Date: Thu, 19 Apr 2018 20:01:16 -0500
Message-ID: <878t9ilmhv.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Helge Deller <deller@gmx.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, David Miller <davem@davemloft.net>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Paul Mundt <lethal@linux-sh.org>, Vincent Chen <vincentc@andestech.com>, Greentime Hu <greentime@andestech.com>, Arnd Bergmann <arnd@arndb.de>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Paul Mackerras <paulus@samba.org>, Kumar Gala <kumar.gala@freescale.com>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>
List-Id: linux-api@vger.kernel.org


Mostly this dealing with aliases of SI_USER, that make it impossible for
userspace to tell what kind of siginfo it has received.

Also in this series is the change to ensure we have siginfo initialized
so I can rip out the switch in copy_siginfo_to_user for better
performance, and to ensure better backwards compatibility as siginfo as
generated in the callers is passed to userspace.

There are also fixes for a few other siginfo bugs I have found.

There are cleanups of ifdefs on SEGV_BNDERR and BUS_MCERR_AX that are no
longer necessary.

I plan to merge these bug fixes through my siginfo tree, but if you
object to them or would prefer to have them go through your arch tree
please let me know.

The changes are avaiable as a totality at:
    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-review
    
Dmitry V. Levin (1):
      sparc: fix compat siginfo ABI regression

Eric W. Biederman (16):
      signal/alpha: Document a conflict with SI_USER for SIGFPE
      signal/sh: Use force_sig_fault in hw_breakpoint_handler
      signal/nds32: Use force_sig in unhandled_interruption and unhandled_exceptions
      signal/nds32: Use force_sig(SIGILL) in do_revisn
      signal: Ensure every siginfo we send has all bits initialized
      signal: Reduce copy_siginfo_to_user to just copy_to_user
      signal: Stop special casing TRAP_FIXME and FPE_FIXME in siginfo_layout
      signal: Remove SEGV_BNDERR ifdefs
      signal: Remove ifdefs for BUS_MCEERR_AR and BUS_MCEERR_AO
      signal/alpha: Replace FPE_FIXME with FPE_FLTUNK
      signal/ia64: Replace FPE_FIXME with FPE_FLTUNK
      signal/powerpc: Replace FPE_FIXME with FPE_FLTUNK
      signal/unicore32: Use FPE_FLTUNK instead of 0 in ucf64_raise_sigfpe
      signal: Add TRAP_UNK si_code for undiagnosted trap exceptions
      signal/alpha:  Replace TRAP_FIXME with TRAP_UNK
      signal/powerpc: Replace TRAP_FIXME with TRAP_UNK

 arch/alpha/include/uapi/asm/siginfo.h     |  14 ----
 arch/alpha/kernel/osf_sys.c               |   3 +-
 arch/alpha/kernel/signal.c                |   2 +
 arch/alpha/kernel/traps.c                 |  11 ++-
 arch/alpha/mm/fault.c                     |   2 +
 arch/arc/mm/fault.c                       |   2 +
 arch/arm/kernel/ptrace.c                  |   1 +
 arch/arm/kernel/swp_emulate.c             |   1 +
 arch/arm/kernel/traps.c                   |   5 ++
 arch/arm/mm/alignment.c                   |   1 +
 arch/arm/mm/fault.c                       |   4 +
 arch/arm/vfp/vfpmodule.c                  |   3 +-
 arch/arm64/kernel/fpsimd.c                |   2 +-
 arch/arm64/kernel/sys_compat.c            |   1 +
 arch/arm64/kernel/traps.c                 |   1 +
 arch/arm64/mm/fault.c                     |  18 +++--
 arch/c6x/kernel/traps.c                   |   1 +
 arch/hexagon/kernel/traps.c               |   1 +
 arch/hexagon/mm/vm_fault.c                |   1 +
 arch/ia64/include/uapi/asm/siginfo.h      |   7 --
 arch/ia64/kernel/brl_emu.c                |   1 +
 arch/ia64/kernel/signal.c                 |   2 +
 arch/ia64/kernel/traps.c                  |  31 ++++++--
 arch/ia64/kernel/unaligned.c              |   1 +
 arch/ia64/mm/fault.c                      |   4 +-
 arch/m68k/kernel/traps.c                  |   2 +
 arch/microblaze/kernel/exceptions.c       |   1 +
 arch/microblaze/mm/fault.c                |   4 +-
 arch/mips/mm/fault.c                      |   1 +
 arch/nds32/kernel/traps.c                 |  19 ++---
 arch/nds32/mm/fault.c                     |   1 +
 arch/nios2/kernel/traps.c                 |   1 +
 arch/openrisc/kernel/traps.c              |   5 +-
 arch/openrisc/mm/fault.c                  |   1 +
 arch/parisc/kernel/ptrace.c               |   1 +
 arch/parisc/kernel/traps.c                |   2 +
 arch/parisc/kernel/unaligned.c            |   1 +
 arch/parisc/math-emu/driver.c             |   1 +
 arch/parisc/mm/fault.c                    |   1 +
 arch/powerpc/include/uapi/asm/siginfo.h   |  15 ----
 arch/powerpc/kernel/process.c             |   1 +
 arch/powerpc/kernel/traps.c               |  13 ++--
 arch/powerpc/mm/fault.c                   |   1 +
 arch/powerpc/platforms/cell/spufs/fault.c |   2 +-
 arch/riscv/kernel/traps.c                 |   1 +
 arch/s390/kernel/traps.c                  |   5 +-
 arch/s390/mm/fault.c                      |   2 +
 arch/sh/kernel/hw_breakpoint.c            |   9 +--
 arch/sh/kernel/traps_32.c                 |   2 +
 arch/sh/math-emu/math.c                   |   1 +
 arch/sh/mm/fault.c                        |   1 +
 arch/sparc/include/uapi/asm/siginfo.h     |   7 --
 arch/sparc/kernel/process_64.c            |   1 +
 arch/sparc/kernel/sys_sparc_32.c          |   1 +
 arch/sparc/kernel/traps_32.c              |  12 ++-
 arch/sparc/kernel/traps_64.c              |  16 +++-
 arch/sparc/kernel/unaligned_32.c          |   1 +
 arch/sparc/mm/fault_32.c                  |   1 +
 arch/sparc/mm/fault_64.c                  |   1 +
 arch/um/kernel/trap.c                     |   2 +
 arch/unicore32/kernel/fpu-ucf64.c         |   8 +-
 arch/unicore32/mm/fault.c                 |   3 +
 arch/x86/entry/vsyscall/vsyscall_64.c     |   2 +-
 arch/x86/kernel/ptrace.c                  |   2 +-
 arch/x86/kernel/signal_compat.c           |   2 +-
 arch/x86/kernel/traps.c                   |   3 +
 arch/x86/kernel/umip.c                    |   1 +
 arch/x86/kvm/mmu.c                        |   1 +
 arch/x86/mm/fault.c                       |   1 +
 arch/xtensa/kernel/traps.c                |   1 +
 arch/xtensa/mm/fault.c                    |   1 +
 fs/signalfd.c                             |  15 +---
 include/linux/ptrace.h                    |   1 -
 include/linux/tracehook.h                 |   1 +
 include/uapi/asm-generic/siginfo.h        |   3 +-
 kernel/signal.c                           | 123 +++---------------------------
 virt/kvm/arm/mmu.c                        |   1 +
 77 files changed, 194 insertions(+), 231 deletions(-)
