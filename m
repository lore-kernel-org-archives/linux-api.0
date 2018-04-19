From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 00/17] y2038: Convert IPC syscalls
Date: Thu, 19 Apr 2018 16:37:20 +0200
Message-ID: <20180419143737.606138-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, albert.aribaud@3adev.fr, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, x86@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-mips@linux-mips.org, jhogan@kernel.org, ralf@linux-mips.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an update of a series I posted a long time ago [1], updating
the IPC subsystem to pass down 64-bit time stamps to user space.

In particular, for sys_msgctl, sys_semctl and sys_shmctl, I do not
introduce a completely new set of replacement system calls, but instead
extend the existing ones to return data in the reserved fields of the
normal data structure.

This should be completely transparent to any existing user space, and
only after the 32-bit time_t wraps, it will make a difference in the
returned data.

libc implementations will consequently have to provide their own data
structures when they move to 64-bit time_t, and convert the structures
in user space from the ones returned by the kernel.

In contrast, mq_timedsend, mq_timedreceive and and semtimedop all do
need to change because having a libc redefine the timespec type
breaks the ABI, so with this series, there will be two separate entry
points for 32-bit architectures.

There are three cases here:

- little-endian architectures (except powerpc and mips) can use
  the normal layout and just cast the data structure to the user space
  type that contains 64-bit numbers.

- parisc and sparc can do the same thing with big-endian user space

- little-endian powerpc and most big-endian architectures have
  to flip the upper and lower 32-bit halves of the time_t value in memory,
  but can otherwise keep using the normal layout

- mips and big-endian xtensa need to be more careful because
  they are not consistent in their definitions, and they have to provide
  custom libc implementations for the system calls to use 64-bit time_t.

Changes to v2 [2]:
- added patches for mq_timedsend, mq_timedreceive and and semtimedop
  system calls
- add asm-generic/compat.h changes to prepare for actually using those
  on 32-bit.
- fix 'make headers_install' as reported by Heiko Carstens
- fix MIPS build as reported by build bot
- Cc everyone on all patches as originally intended, not just on the
  cover letter.

Changes to v1 [1]:
- Rebased to the latest kernel (4.17-rc)
- Dropped changes for removed architectures
- Simplified the IPC code changes, based on prior work from
  both Deepa and Eric
- Fixed a few bugs that I found during rebasing, in parcular the
  sparc version was incorrect.

I haven't seen any objections to v1 and will send a pull request
to Thomas Gleixner after Deepa's first patches are all merged there.
There are a few more patches in my tree [3] now, I'm still testing
those and should be able to send the next batch next week.

    Arnd

[1] https://lkml.org/lkml/2015/5/20/605
[2] https://lwn.net/Articles/751676/
[3] git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git y2038-next

Arnd Bergmann (17):
  y2038: asm-generic: Extend sysvipc data structures
  y2038: alpha: Remove unneeded ipc uapi header files
  y2038: ia64: Remove unneeded ipc uapi header files
  y2038: s390: Remove unneeded ipc uapi header files
  y2038: arm64: Extend sysvipc compat data structures
  y2038: mips: Extend sysvipc data structures
  y2038: x86: Extend sysvipc data structures
  y2038: parisc: Extend sysvipc data structures
  y2038: sparc: Extend sysvipc data structures
  y2038: powerpc: Extend sysvipc data structures
  y2038: xtensa: Extend sysvipc data structures
  y2038: ipc: Use ktime_get_real_seconds consistently
  y2038: ipc: Report long times to user space
  y2038: ipc: Use __kernel_timespec
  y2038: ipc: Enable COMPAT_32BIT_TIME
  y2038: ipc: Redirect ipc(SEMTIMEDOP, ...) to compat_ksys_semtimedop
  y2038: compat: Move common compat types to asm-generic/compat.h

Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: libc-alpha@sourceware.org
Cc: tglx@linutronix.de
Cc: deepa.kernel@gmail.com
Cc: viro@zeniv.linux.org.uk
Cc: ebiederm@xmission.com
Cc: albert.aribaud@3adev.fr
Cc: linux-s390@vger.kernel.org
Cc: schwidefsky@de.ibm.com
Cc: x86@kernel.org
Cc: catalin.marinas@arm.com
Cc: will.deacon@arm.com
Cc: linux-mips@linux-mips.org
Cc: jhogan@kernel.org
Cc: ralf@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org

 arch/alpha/include/uapi/asm/Kbuild     |  4 ++
 arch/alpha/include/uapi/asm/ipcbuf.h   |  2 -
 arch/alpha/include/uapi/asm/msgbuf.h   | 28 -----------
 arch/alpha/include/uapi/asm/sembuf.h   | 23 ---------
 arch/alpha/include/uapi/asm/shmbuf.h   | 39 ---------------
 arch/arm64/include/asm/compat.h        | 52 +++++++-------------
 arch/ia64/include/uapi/asm/Kbuild      |  4 ++
 arch/ia64/include/uapi/asm/ipcbuf.h    |  2 -
 arch/ia64/include/uapi/asm/msgbuf.h    | 28 -----------
 arch/ia64/include/uapi/asm/sembuf.h    | 23 ---------
 arch/ia64/include/uapi/asm/shmbuf.h    | 39 ---------------
 arch/mips/include/asm/compat.h         | 58 +++++++++--------------
 arch/mips/include/uapi/asm/msgbuf.h    | 57 ++++++++++++++--------
 arch/mips/include/uapi/asm/sembuf.h    | 15 +++++-
 arch/mips/include/uapi/asm/shmbuf.h    | 23 ++++++++-
 arch/parisc/include/asm/compat.h       | 50 +++++++-------------
 arch/parisc/include/uapi/asm/msgbuf.h  | 33 +++++++------
 arch/parisc/include/uapi/asm/sembuf.h  | 16 +++----
 arch/parisc/include/uapi/asm/shmbuf.h  | 19 ++++----
 arch/powerpc/include/asm/compat.h      | 50 +++++++-------------
 arch/powerpc/include/uapi/asm/msgbuf.h | 18 +++----
 arch/powerpc/include/uapi/asm/sembuf.h | 14 +++---
 arch/powerpc/include/uapi/asm/shmbuf.h | 19 ++++----
 arch/s390/include/asm/compat.h         | 50 +++++++-------------
 arch/s390/include/uapi/asm/Kbuild      |  3 ++
 arch/s390/include/uapi/asm/msgbuf.h    | 38 ---------------
 arch/s390/include/uapi/asm/sembuf.h    | 30 ------------
 arch/s390/include/uapi/asm/shmbuf.h    | 49 -------------------
 arch/sparc/include/asm/compat.h        | 51 +++++++-------------
 arch/sparc/include/uapi/asm/msgbuf.h   | 22 ++++-----
 arch/sparc/include/uapi/asm/sembuf.h   | 16 +++----
 arch/sparc/include/uapi/asm/shmbuf.h   | 21 ++++-----
 arch/x86/include/asm/compat.h          | 51 +++++++-------------
 arch/x86/include/uapi/asm/Kbuild       |  5 +-
 arch/x86/include/uapi/asm/msgbuf.h     |  1 -
 arch/x86/include/uapi/asm/sembuf.h     | 11 ++++-
 arch/x86/include/uapi/asm/shmbuf.h     |  1 -
 arch/xtensa/include/uapi/asm/msgbuf.h  | 25 +++++-----
 arch/xtensa/include/uapi/asm/sembuf.h  | 17 ++++---
 arch/xtensa/include/uapi/asm/shmbuf.h  | 37 ++++-----------
 include/asm-generic/compat.h           | 24 +++++++++-
 include/linux/compat.h                 |  2 -
 include/linux/syscalls.h               |  6 +--
 include/uapi/asm-generic/msgbuf.h      | 17 ++++---
 include/uapi/asm-generic/sembuf.h      | 26 ++++++----
 include/uapi/asm-generic/shmbuf.h      | 17 ++++---
 ipc/mqueue.c                           | 86 +++++++++++++++++-----------------
 ipc/msg.c                              | 20 +++++---
 ipc/sem.c                              | 27 +++++++----
 ipc/shm.c                              | 14 ++++--
 ipc/syscall.c                          | 13 +++--
 ipc/util.h                             |  4 +-
 52 files changed, 493 insertions(+), 807 deletions(-)
 delete mode 100644 arch/alpha/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/alpha/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/alpha/include/uapi/asm/sembuf.h
 delete mode 100644 arch/alpha/include/uapi/asm/shmbuf.h
 delete mode 100644 arch/ia64/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/ia64/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/ia64/include/uapi/asm/sembuf.h
 delete mode 100644 arch/ia64/include/uapi/asm/shmbuf.h
 delete mode 100644 arch/s390/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/s390/include/uapi/asm/sembuf.h
 delete mode 100644 arch/s390/include/uapi/asm/shmbuf.h
 delete mode 100644 arch/x86/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/x86/include/uapi/asm/shmbuf.h

-- 
2.9.0
