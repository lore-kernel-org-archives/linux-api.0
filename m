From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/17] y2038: system calls, part 3
Date: Wed, 25 Apr 2018 18:02:54 +0200
Message-ID: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

After the first timekeeping series from Deepa (merged into -tip now)
and my follow-up for IPC system calls, this is a third set of system
call conversions following the same principle.

Most of the changes are straightforward, so I'm grouping them into a
larger series even though the system calls are mostly unrelated to one
another. After this series, the remaining calls that need to be changed
are getrusage()/waitid(), pselect6/ppoll(), timer{,fd}_{get,set}time()
and getitimer()/setitimer(). Those will be sent separately, once they
are matured enough.

To put the changes into perspective, a list of all system calls that
require changes is available in a spreadsheet[1] and I have made
another experimental patch that changes over x86[2] and arm[3] to
actually use them.

Please review!

      Arnd

[1] https://docs.google.com/spreadsheets/d/1HCYwHXxs48TsTb6IGUduNjQnmfRvMPzCN6T_0YiQwis
[2] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=y2038-next&id=2174e03cd47384f30dc522f173f36c0d72cfedd7
[3] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=y2038-next&id=ba9a341eff2b13a8e25b5d42b3035b1c1dbfeacf

Arnd Bergmann (17):
  y2038: compat: Move common compat types to asm-generic/compat.h
  y2038: Remove newstat family from default syscall set
  y2038: Remove stat64 family from default syscall set
  asm-generic: Remove unneeded __ARCH_WANT_SYS_LLSEEK macro
  asm-generic: Remove empty asm/unistd.h
  y2038: Change sys_utimensat() to use __kernel_timespec
  y2038: Compile utimes()/futimesat() conditionally
  y2038: utimes: Rework #ifdef guards for compat syscalls
  y2038: futex: Move compat implementation into futex.c
  y2038: futex: Add support for __kernel_timespec
  y2038: Prepare sched_rr_get_interval for __kernel_timespec
  y2038: aio: Prepare sys_io_getevents for __kernel_timespec
  y2038: socket: Convert recvmmsg to __kernel_timespec
  y2038: socket: Add compat_sys_recvmmsg_time64
  y2038: signal: Change rt_sigtimedwait to use __kernel_timespec
  y2038: Make compat_sys_rt_sigtimedwait usable on 32-bit
  y2038: signal: Add compat_sys_rt_sigtimedwait_time64

Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: libc-alpha@sourceware.org
Cc: tglx@linutronix.de
Cc: netdev@vger.kernel.org
Cc: deepa.kernel@gmail.com
Cc: viro@zeniv.linux.org.uk
Cc: albert.aribaud@3adev.fr
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>

 arch/alpha/include/asm/unistd.h          |   2 +
 arch/arc/include/uapi/asm/unistd.h       |   1 +
 arch/arm/include/asm/unistd.h            |   4 +-
 arch/arm64/include/asm/compat.h          |  20 +--
 arch/arm64/include/asm/unistd.h          |   2 +-
 arch/arm64/include/uapi/asm/unistd.h     |   1 +
 arch/c6x/include/uapi/asm/unistd.h       |   1 +
 arch/h8300/include/uapi/asm/unistd.h     |   1 +
 arch/hexagon/include/uapi/asm/unistd.h   |   1 +
 arch/ia64/include/asm/unistd.h           |   3 +
 arch/m68k/include/asm/unistd.h           |   2 +-
 arch/microblaze/include/asm/unistd.h     |   2 +-
 arch/mips/include/asm/compat.h           |  22 +---
 arch/mips/include/asm/unistd.h           |   3 +-
 arch/nds32/include/uapi/asm/unistd.h     |   1 +
 arch/nios2/include/uapi/asm/unistd.h     |   1 +
 arch/openrisc/include/uapi/asm/unistd.h  |   1 +
 arch/parisc/include/asm/compat.h         |  18 +--
 arch/parisc/include/asm/unistd.h         |   3 +-
 arch/powerpc/include/asm/compat.h        |  18 +--
 arch/powerpc/include/asm/unistd.h        |   3 +-
 arch/s390/include/asm/compat.h           |  18 +--
 arch/s390/include/asm/unistd.h           |   3 +-
 arch/sh/include/asm/unistd.h             |   2 +-
 arch/sparc/include/asm/compat.h          |  19 +--
 arch/sparc/include/asm/unistd.h          |   3 +-
 arch/unicore32/include/uapi/asm/unistd.h |   1 +
 arch/x86/include/asm/compat.h            |  19 +--
 arch/x86/include/asm/unistd.h            |   3 +-
 arch/xtensa/include/asm/unistd.h         |   2 +-
 fs/aio.c                                 |   4 +-
 fs/read_write.c                          |   2 +-
 fs/stat.c                                |   3 +
 fs/utimes.c                              |  59 +++++----
 include/asm-generic/compat.h             |  24 +++-
 include/asm-generic/unistd.h             |  13 --
 include/linux/compat.h                   |  12 +-
 include/linux/compat_time.h              |   5 +
 include/linux/futex.h                    |   8 --
 include/linux/socket.h                   |  19 ++-
 include/linux/syscalls.h                 |  23 ++--
 include/uapi/asm-generic/unistd.h        |   2 +
 kernel/Makefile                          |   3 -
 kernel/futex.c                           | 207 +++++++++++++++++++++++++++++--
 kernel/futex_compat.c                    | 202 ------------------------------
 kernel/sched/core.c                      |   4 +-
 kernel/signal.c                          |  68 ++++++++--
 kernel/sys_ni.c                          |   1 +
 net/compat.c                             |  16 +--
 net/socket.c                             |  55 ++++++--
 50 files changed, 456 insertions(+), 454 deletions(-)
 delete mode 100644 include/asm-generic/unistd.h
 delete mode 100644 kernel/futex_compat.c

-- 
2.9.0
