From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 00/17] y2038: system calls, part 3
Date: Mon, 16 Jul 2018 18:10:46 +0200
Message-ID: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is a mostly unchanged copy of a series I sent back in April for
an initial review. All the earlier syscall patches that Deepa or I sent
got merged now, and this is the largest chunk of remaining patches.

Changes this time are:

- This is actually tested with the LTP syscalls test suite,
  both before and after the CONFIG_64BIT_TIME change (which is not
  included here). I have created a patch series for musl libc to use
  64-bit time_t and change all the system calls over to the new entry
  points for this. The only bugs I found during that testing were in
  later parts of the conversion that I have not posted yet.

- I rewrote the sys_io_getevents conversion after the
  introduction of sys_sys_io_getevents. We obviously don't need to have
  two of each, so we will only provide sys_io_pgetevents() with 64-bit
  time_t but not sys_io_getevents(), which the libc can implement on
  top of the former.

- While we have Deepa's POSIX timer conversion merged now, we
  still need to decide on how we want to do the replacement
  ABI for getitimer()/setitimer(). Like getrusage()/waitid() and
  clock_adjtime() and unlike the system calls I'm posting here,
  there is no one obvious ABI.

- For ppoll()/pselect6(), the ABI is fairly clear, but the
  implementation still needs to be done. I tested with a simple
  prototype based on the existing compat code, but we can
  probably improve that. This is something that Deepa still
  wants to work on.

- Finally, Christoph Hellwig objected to the idea of reusing the
  compat_ namespace for the 32-bit native case. Changing that
  would be a departure from our plans so far[2], and would make
  some things end up differently. Until we have decided on how this
  is to be done, I've decided to not change the code for this
  post. We can clearly rename all the symbols and I've implemented
  that in [3] for the current linux-next (not including the
  series here). This is something we can definitely do, but I'd
  need to know soon whether we can merge this series unchanged
  for 4.19 or if I should rebase it on top of that patch with the
  alternative naming.

      Arnd

---
Previous cover letter announcement below, see [4] for the full
series:

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
require changes is available in a spreadsheet[5] and I have made
another experimental patch that changes over x86[6] and arm[7] to
actually use them.

Link [1] https://lore.kernel.org/lkml/20180712082034.GA8802@infradead.org/
Link [2] https://lwn.net/Articles/643234/
Link [3] https://lore.kernel.org/lkml/20180713133204.3123939-1-arnd@arndb.de/
Link [4] https://lore.kernel.org/lkml/20180425160311.2718314-1-arnd@arndb.de/
Link [5] https://docs.google.com/spreadsheets/d/1HCYwHXxs48TsTb6IGUduNjQnmfRvMPzCN6T_0YiQwis
Link [6] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=y2038-4.18-rc5-next&id=2c995de3bdd5
Link [7] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=y2038-4.18-rc5-next&id=e73061da2f80



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
  y2038: aio: Prepare sys_io_{p,}getevents for __kernel_timespec
  y2038: socket: Convert recvmmsg to __kernel_timespec
  y2038: socket: Add compat_sys_recvmmsg_time64
  y2038: signal: Change rt_sigtimedwait to use __kernel_timespec
  y2038: Make compat_sys_rt_sigtimedwait usable on 32-bit
  y2038: signal: Add compat_sys_rt_sigtimedwait_time64

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
 fs/aio.c                                 |  77 ++++++++++--
 fs/read_write.c                          |   2 +-
 fs/stat.c                                |   3 +
 fs/utimes.c                              |  59 +++++----
 include/asm-generic/compat.h             |  24 +++-
 include/asm-generic/unistd.h             |  13 --
 include/linux/compat.h                   |  12 +-
 include/linux/compat_time.h              |   5 +
 include/linux/futex.h                    |   8 --
 include/linux/socket.h                   |  19 ++-
 include/linux/syscalls.h                 |  25 ++--
 include/uapi/asm-generic/unistd.h        |   2 +
 kernel/Makefile                          |   3 -
 kernel/futex.c                           | 207 +++++++++++++++++++++++++++++--
 kernel/futex_compat.c                    | 202 ------------------------------
 kernel/sched/core.c                      |   4 +-
 kernel/signal.c                          |  68 ++++++++--
 kernel/sys_ni.c                          |   1 +
 net/compat.c                             |  16 +--
 net/socket.c                             |  55 ++++++--
 50 files changed, 524 insertions(+), 461 deletions(-)
 delete mode 100644 include/asm-generic/unistd.h
 delete mode 100644 kernel/futex_compat.c

-- 
2.9.0
