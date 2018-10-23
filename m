From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [GIT PULL] siginfo updates for 4.20-rc1
Date: Mon, 22 Oct 2018 21:01:06 -0500
Message-ID: <87h8hdzajh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Linus,

Please pull the siginfo-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-linus

   HEAD: a36700589b85443e28170be59fa11c8a104130a5 signal: Guard against negative signal numbers in copy_siginfo_from_user32

I have been slowly sorting out siginfo and this is the culmination of that work.

The primary result is in several ways the signal infrastructure has been made
less error prone.  The code has been updated so that manually specifying
SEND_SIG_FORCED is never necessary.  The conversion to the new siginfo sending
functions is now complete, which makes it difficult to send a signal without
filling in the proper siginfo fields.

At the tail end of the patchset comes the optimization of decreasing the size of
struct siginfo in the kernel from 128 bytes to about 48 bytes on 64bit.  The
fundamental observation that enables this is by definition none of the known
ways to use struct siginfo uses the extra bytes.

This comes at the cost of a small user space observable difference.  For the
rare case of siginfo being injected into the kernel only what can be copied
into kernel_siginfo is delivered to the destination, the rest of the bytes are
set to 0.  For cases where the signal and the si_code are known this is safe,
because we know thos bytes are not used.  For cases where the signal and si_code
combination is unknown the bits that won't fit into struct kernel_siginfo are
tested to verify they are zero, and the send fails if they are not.

I made an extensive search through userspace code and I could not find anything
that would break because of the above change.  If it turns out I did break
something it will take just the revert of a single change to restore
kernel_siginfo to the same size as userspace siginfo.

Testing did reveal dependencies on preferring the signo passed to sigqueueinfo
over si->signo, so bit the bullet and added the complexity necessary to handle
that case.

Testing also revealed bad things can happen if a negative signal number is
passed into the system calls.  Something no sane application will do but
something a malicious program or a fuzzer might do.  So I have fixed the code
that performs the bounds checks to ensure negative signal numbers are handled.


There are minor conflicts between this tree and several other trees.
- The x86 tree
- The y2038 tree
- The arm64 tree
- The x86 tip tree

I think only the resolution of the x86 tip tree is at all difficult.  None of
the conflicts are fundamental.  They are all from changes to other parts of the
code that are just close enough to have context conflicts.  The x86 tip tree
conflict actually involves a conflict from removing a unnecessary pkey parameter
on the siginfo side and a some small refactoring on the x86 side.

Eric W. Biederman (80):
      signal: Always ignore SIGKILL and SIGSTOP sent to the global init
      signal: Properly deliver SIGILL from uprobes
      signal: Properly deliver SIGSEGV from x86 uprobes
      signal: Always deliver the kernel's SIGKILL and SIGSTOP to a pid namespace init
      signal: send_sig_all no longer needs SEND_SIG_FORCED
      signal: Remove the siginfo paramater from kernel_dqueue_signal
      signal: Don't send siginfo to kthreads.
      signal: Never allocate siginfo for SIGKILL or SIGSTOP
      signal: Use SEND_SIG_PRIV not SEND_SIG_FORCED with SIGKILL and SIGSTOP
      signal: Remove SEND_SIG_FORCED
      signal/GenWQE: Fix sending of SIGKILL
      tty_io: Use group_send_sig_info in __do_SACK to note it is a session being killed
      signal: Use group_send_sig_info to kill all processes in a pid namespace
      signal: Remove specific_send_sig_info
      signal: Pair exports with their functions
      signal: Simplify tracehook_report_syscall_exit
      signal/x86: Inline fill_sigtrap_info in it's only caller send_sigtrap
      signal/x86: Move MCE error reporting out of force_sig_info_fault
      signal/x86: Use send_sig_mceerr as apropriate
      signal/x86: In trace_mpx_bounds_register_exception add __user annotations
      signal/x86: Move mpx siginfo generation into do_bounds
      signal/x86/traps: Factor out show_signal
      signal/x86/traps: Move more code into do_trap_no_signal so it can be reused
      signal/x86/traps: Use force_sig_bnderr
      signal/x86/traps: Use force_sig instead of open coding it.
      signal/x86/traps: Simplify trap generation
      signal/x86: Remove pkey parameter from bad_area_nosemaphore
      signal/x86: Remove the pkey parameter from do_sigbus
      signal/x86: Remove pkey parameter from mm_fault_error
      signal/x86: Don't compute pkey in __do_page_fault
      signal/x86: Pass pkey not vma into __bad_area
      signal/x86: Call force_sig_pkuerr from __bad_area_nosemaphore
      signal/x86: Replace force_sig_info_fault with force_sig_fault
      signal/x86: Pass pkey by value
      signal/x86: Use force_sig_fault where appropriate
      signal/powerpc: Use force_sig_mceerr as appropriate
      signal/powerpc: Remove pkey parameter from __bad_area
      signal/powerpc: Call _exception_pkey directly from bad_key_fault_exception
      signal/powerpc: Remove pkey parameter from __bad_area_nosemaphore
      signal/powerpc: Factor the common exception code into exception_common
      signal/powerpc: Call force_sig_fault from _exception
      signal/powerpc: Specialize _exception_pkey for handling pkey exceptions
      signal/powerpc: Simplify _exception_pkey by using force_sig_pkuerr
      signal/powerpc: Use force_sig_fault where appropriate
      signal/arm64: Push siginfo generation into arm64_notify_die
      signal/arm64: Remove unneeded tsk parameter from arm64_force_sig_info
      signal/arm64: Factor out arm64_show_signal from arm64_force_sig_info
      signal/arm64: Factor set_thread_esr out of __do_user_fault
      signal/arm64: Consolidate the two hwpoison cases in do_page_fault
      signal/arm64: For clarity separate the 3 signal sending cases in do_page_fault
      signal/arm64: Expand __do_user_fault and remove it
      signal/arm64: Only perform one esr_to_fault_info call in do_page_fault
      signal/arm64: Only call set_thread_esr once in do_page_fault
      signal/arm64: Add and use arm64_force_sig_fault where appropriate
      signal/arm64: Add and use arm64_force_sig_mceerr as appropriate
      signal/arm64: Remove arm64_force_sig_info
      signal/arm64: In ptrace_hbptriggered name the signal description string
      signal/arm64: Add and use arm64_force_sig_ptrace_errno_trap
      signal/arm64: Use send_sig_fault where appropriate
      signal/arm: Push siginfo generation into arm_notify_die
      signal/arm: Use force_sig_fault where appropriate
      signal/arm: Use send_sig_fault where appropriate
      signal/arm/kvm: Use send_sig_mceerr
      signal/ia64: Use the generic force_sigsegv in setup_frame
      signal/ia64: Use the force_sig(SIGSEGV,...) in ia64_rt_sigreturn
      signal/ia64: Use force_sig_fault where appropriate
      signal/arc: Push siginfo generation into unhandled_exception
      signal/arc: Use force_sig_fault where appropriate
      signal/unicore32: Use send_sig_fault where appropriate
      signal/unicore32: Generate siginfo in ucs32_notify_die
      signal/unicore32: Use force_sig_fault where appropriate
      signal/sparc: Move EMT_TAGOVF into the generic siginfo.h
      signal: Fail sigqueueinfo if si_signo != sig
      signal: Remove the need for __ARCH_SI_PREABLE_SIZE and SI_PAD_SIZE
      signal: Introduce copy_siginfo_from_user and use it's return value
      signal: Distinguish between kernel_siginfo and siginfo
      signal: Use a smaller struct siginfo in the kernel
      signal: In sigqueueinfo prefer sig not si_signo
      signal: Guard against negative signal numbers in copy_siginfo_from_user
      signal: Guard against negative signal numbers in copy_siginfo_from_user32

 arch/alpha/include/uapi/asm/siginfo.h        |   1 -
 arch/arc/kernel/traps.c                      |  22 +-
 arch/arc/mm/fault.c                          |  20 +-
 arch/arm/include/asm/bug.h                   |   4 +-
 arch/arm/kernel/ptrace.c                     |  11 +-
 arch/arm/kernel/swp_emulate.c                |  16 +-
 arch/arm/kernel/traps.c                      |  63 ++--
 arch/arm/mm/alignment.c                      |  10 +-
 arch/arm/mm/fault.c                          |  28 +-
 arch/arm/vfp/vfpmodule.c                     |  11 +-
 arch/arm64/include/asm/system_misc.h         |   3 +-
 arch/arm64/include/asm/traps.h               |   5 +-
 arch/arm64/include/uapi/asm/Kbuild           |   1 +
 arch/arm64/include/uapi/asm/siginfo.h        |  24 --
 arch/arm64/kernel/debug-monitors.c           |  11 +-
 arch/arm64/kernel/fpsimd.c                   |  10 +-
 arch/arm64/kernel/ptrace.c                   |  16 +-
 arch/arm64/kernel/sys_compat.c               |  13 +-
 arch/arm64/kernel/traps.c                    |  67 ++---
 arch/arm64/mm/fault.c                        |  94 +++---
 arch/ia64/include/uapi/asm/siginfo.h         |   2 -
 arch/ia64/kernel/brl_emu.c                   |  31 +-
 arch/ia64/kernel/signal.c                    |  60 +---
 arch/ia64/kernel/traps.c                     | 144 +++------
 arch/ia64/kernel/unaligned.c                 |  12 +-
 arch/ia64/mm/fault.c                         |  12 +-
 arch/mips/include/uapi/asm/siginfo.h         |  11 -
 arch/parisc/include/uapi/asm/Kbuild          |   1 +
 arch/parisc/include/uapi/asm/siginfo.h       |  11 -
 arch/powerpc/include/asm/bug.h               |   2 +-
 arch/powerpc/include/asm/ptrace.h            |   2 +-
 arch/powerpc/include/uapi/asm/Kbuild         |   1 +
 arch/powerpc/include/uapi/asm/siginfo.h      |  18 --
 arch/powerpc/kernel/process.c                |   9 +-
 arch/powerpc/kernel/traps.c                  |  34 +--
 arch/powerpc/mm/fault.c                      |  55 ++--
 arch/powerpc/platforms/cell/spu_base.c       |   4 +-
 arch/powerpc/platforms/cell/spufs/fault.c    |  26 +-
 arch/riscv/include/uapi/asm/Kbuild           |   1 +
 arch/riscv/include/uapi/asm/siginfo.h        |  24 --
 arch/s390/include/uapi/asm/Kbuild            |   1 +
 arch/s390/include/uapi/asm/siginfo.h         |  17 --
 arch/sparc/include/uapi/asm/siginfo.h        |   7 -
 arch/unicore32/include/asm/bug.h             |   3 +-
 arch/unicore32/kernel/fpu-ucf64.c            |  12 +-
 arch/unicore32/kernel/traps.c                |   5 +-
 arch/unicore32/mm/fault.c                    |  27 +-
 arch/x86/entry/vsyscall/vsyscall_64.c        |   9 +-
 arch/x86/include/asm/compat.h                |   2 +-
 arch/x86/include/asm/mpx.h                   |  12 +-
 arch/x86/include/asm/ptrace.h                |   2 +-
 arch/x86/include/asm/trace/mpx.h             |   4 +-
 arch/x86/include/uapi/asm/siginfo.h          |   2 -
 arch/x86/kernel/ptrace.c                     |  29 +-
 arch/x86/kernel/traps.c                      | 176 +++++------
 arch/x86/kernel/umip.c                       |   8 +-
 arch/x86/kernel/uprobes.c                    |   2 +-
 arch/x86/kvm/mmu.c                           |  11 +-
 arch/x86/mm/fault.c                          | 167 ++++-------
 arch/x86/mm/mpx.c                            |  30 +-
 drivers/misc/genwqe/card_base.h              |   2 +-
 drivers/misc/genwqe/card_dev.c               |   9 +-
 drivers/tty/sysrq.c                          |   2 +-
 drivers/tty/tty_io.c                         |   6 +-
 drivers/usb/core/devio.c                     |   4 +-
 drivers/usb/gadget/function/f_mass_storage.c |   4 +-
 fs/binfmt_elf.c                              |   6 +-
 fs/coredump.c                                |   2 +-
 fs/fcntl.c                                   |   2 +-
 fs/jffs2/background.c                        |   2 +-
 fs/signalfd.c                                |   6 +-
 include/linux/binfmts.h                      |   2 +-
 include/linux/compat.h                       |   4 +-
 include/linux/coredump.h                     |   4 +-
 include/linux/lsm_hooks.h                    |   4 +-
 include/linux/posix-timers.h                 |   2 +-
 include/linux/ptrace.h                       |  17 +-
 include/linux/sched.h                        |   2 +-
 include/linux/sched/signal.h                 |  23 +-
 include/linux/security.h                     |   6 +-
 include/linux/signal.h                       |  18 +-
 include/linux/signal_types.h                 |   8 +-
 include/linux/tracehook.h                    |  13 +-
 include/trace/events/signal.h                |   7 +-
 include/uapi/asm-generic/siginfo.h           | 193 ++++++------
 ipc/mqueue.c                                 |   2 +-
 kernel/events/uprobes.c                      |   4 +-
 kernel/pid_namespace.c                       |   2 +-
 kernel/ptrace.c                              |  26 +-
 kernel/seccomp.c                             |   6 +-
 kernel/signal.c                              | 421 +++++++++++++++++----------
 kernel/time/posix-timers.c                   |   2 +-
 mm/oom_kill.c                                |   4 +-
 security/apparmor/lsm.c                      |   2 +-
 security/security.c                          |   2 +-
 security/selinux/hooks.c                     |   2 +-
 security/smack/smack_lsm.c                   |   2 +-
 virt/kvm/arm/mmu.c                           |  14 +-
 98 files changed, 925 insertions(+), 1328 deletions(-)
