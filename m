From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 0/6] signal: Shrinking the kernel's siginfo structure
Date: Tue, 25 Sep 2018 19:16:51 +0200
Message-ID: <87h8idv6nw.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org


I am posting these patches for review in the hopes that if I have missed
something someone else might catch it.  If no issues turn up I intend to
merge these patches through my siginfo branch.

This set of patches make a few small ABI changes to areas of the linux
ABI where as far as I can determine no one cares.

- sigqueueinfo in all it's variants now fails if si_signo != sig
  instead of quietly changing si_signo.

  The deep issue is that the change happens after the code has already
  verified in copy_siginfom_from_user that the si_signo and si_code
  combination is meaningful.

- copy_siginfo_from_user now fails if the trailing bytes of siginfo
  are not 0, when the signal number and si_code combination is not
  recognized.

  If the si_signo and si_code combination is recognized we know any
  trailing bytes are meaningless as the meaningful bytes are in siginfo.

  This check is to allow people to define new siginfo union members and
  that will fail on older kernels.  The check makes it as safe as
  possible to have a kernel_siginfo that is smaller than the ABI defined
  siginfo that the kernel reads from and writes to userspace.

The net effect of this change is a kernel that only uses 48 bytes for
siginfo internally when the ABI defines siginfo to be 128 bytes.

The first EMT_TAGOVF change is not necesssary to strinking siginfo.

Eric W. Biederman (6):
      signal/sparc: Move EMT_TAGOVF into the generic siginfo.h
      signal: Fail sigqueueinfo if si_signo != sig
      signal: Remove the need for __ARCH_SI_PREABLE_SIZE and SI_PAD_SIZE
      signal: Introduce copy_siginfo_from_user and use it's return value
      signal: Distinguish between kernel_siginfo and siginfo
      signal: Use a smaller struct siginfo in the kernel

 arch/alpha/include/uapi/asm/siginfo.h   |   1 -
 arch/arm64/include/uapi/asm/Kbuild      |   1 +
 arch/arm64/include/uapi/asm/siginfo.h   |  24 ---
 arch/ia64/include/uapi/asm/siginfo.h    |   2 -
 arch/mips/include/uapi/asm/siginfo.h    |  11 --
 arch/parisc/include/uapi/asm/Kbuild     |   1 +
 arch/parisc/include/uapi/asm/siginfo.h  |  11 --
 arch/powerpc/include/uapi/asm/Kbuild    |   1 +
 arch/powerpc/include/uapi/asm/siginfo.h |  18 ---
 arch/riscv/include/uapi/asm/Kbuild      |   1 +
 arch/riscv/include/uapi/asm/siginfo.h   |  24 ---
 arch/s390/include/uapi/asm/Kbuild       |   1 +
 arch/s390/include/uapi/asm/siginfo.h    |  17 ---
 arch/sparc/include/uapi/asm/siginfo.h   |   7 -
 arch/x86/include/asm/compat.h           |   2 +-
 arch/x86/include/uapi/asm/siginfo.h     |   2 -
 drivers/usb/core/devio.c                |   4 +-
 fs/binfmt_elf.c                         |   6 +-
 fs/coredump.c                           |   2 +-
 fs/fcntl.c                              |   2 +-
 fs/signalfd.c                           |   6 +-
 include/linux/binfmts.h                 |   2 +-
 include/linux/compat.h                  |   4 +-
 include/linux/coredump.h                |   4 +-
 include/linux/lsm_hooks.h               |   4 +-
 include/linux/posix-timers.h            |   2 +-
 include/linux/ptrace.h                  |   2 +-
 include/linux/sched.h                   |   2 +-
 include/linux/sched/signal.h            |  18 +--
 include/linux/security.h                |   6 +-
 include/linux/signal.h                  |  16 +-
 include/linux/signal_types.h            |   8 +-
 include/trace/events/signal.h           |   4 +-
 include/uapi/asm-generic/siginfo.h      | 193 ++++++++++++-----------
 ipc/mqueue.c                            |   2 +-
 kernel/ptrace.c                         |  22 ++-
 kernel/seccomp.c                        |   6 +-
 kernel/signal.c                         | 263 ++++++++++++++++++++++----------
 kernel/time/posix-timers.c              |   2 +-
 security/apparmor/lsm.c                 |   2 +-
 security/security.c                     |   2 +-
 security/selinux/hooks.c                |   2 +-
 security/smack/smack_lsm.c              |   2 +-
 43 files changed, 356 insertions(+), 356 deletions(-)

Eric
