From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 00/29] y2038: add time64 syscalls
Date: Fri, 18 Jan 2019 17:18:06 +0100
Message-ID: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

This is a minor update of the patches I posted last week, I
would like to add this into linux-next now, but would still do
changes if there are concerns about the contents. The first
version did not see a lot of replies, which could mean that
either everyone is happy with it, or that it was largely ignored.

See also the article at https://lwn.net/Articles/776435/.

Changes since v1:

- posting as a combined series for simplicity
- dropped one mips patch that was merged as a 5.0 fix
- reworked s390 compat syscall handling (posted separately)
  and rebased on top of that series
- minor fixes for arm64 and powerpc
- added alpha statfs64 interfaces
- added alpha get{eg,eu,g,p,u,pp}id()

     Arnd

----
v1 description for cleanup:
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

v1 description for y2038 patches:

This series finally gets us to the point of having system calls with
64-bit time_t on all architectures, after a long time of incremental
preparation patches.

There was actually one conversion that I missed during the summer,
i.e. Deepa's timex series, which I now updated based the 5.0-rc1 changes
and review comments.

I hope that the actual conversion should be uncontroversial by now,
even if some of the patches are rather large.

The one area that may need a little discussion is for the system call
numbers assigned in the final patch: Can we get consensus on whether
the idea of using the same numbers on all architectures, as well as my
choice of numbers makes sense here?

So far, I have done a lot of build testing across most architectures,
which has found a number of bugs. I have also done an LTP run on arm32
with existing user space, but not on the other architectures. I did LTP
tests with a modified musl libc[2] last summer on an older version of
this series to make sure that the new 64-bit time_t interfaces work.
The version there will need updates for testing with this new kernel
patch series; I plan to do that next.

For testing, the series plus the preparatory patches is available at
[3].  Once there is a general agreement on this series and I have done
more tests for the new system calls, I plan to add this to linux-next
through my asm-generic tree or Thomas' timers tree.

Please review and test!

      Arnd

[1] https://lore.kernel.org/lkml/20190110162435.309262-1-arnd@arndb.de/T/
[2] https://git.linaro.org/people/arnd/musl-y2038.git/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git y2038-5.0-rc1

Arnd Bergmann (26):
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
  sparc64: fix sparc_ipc type conversion
  ipc: rename old-style shmctl/semctl/msgctl syscalls
  arch: add split IPC system calls where needed
  arch: add pkey and rseq syscall numbers everywhere
  alpha: add standard statfs64/fstatfs64 syscalls
  alpha: add generic get{eg,eu,g,p,u,pp}id() syscalls
  syscalls: remove obsolete __IGNORE_ macros
  time: make adjtime compat handling available for 32 bit
  time: fix sys_timer_settime prototype
  sparc64: add custom adjtimex/clock_adjtime functions
  x86/x32: use time64 versions of sigtimedwait and recvmmsg
  y2038: syscalls: rename y2038 compat syscalls
  y2038: use time32 syscall names on 32-bit
  y2038: remove struct definition redirects
  y2038: rename old time and utime syscalls
  y2038: add 64-bit time_t syscalls to all 32-bit architectures

Deepa Dinamani (3):
  time: Add struct __kernel_timex
  timex: use __kernel_timex internally
  timex: change syscalls to use struct __kernel_timex

 arch/Kconfig                                |   2 +-
 arch/alpha/include/asm/unistd.h             |  21 -
 arch/alpha/include/uapi/asm/unistd.h        |  10 +
 arch/alpha/kernel/osf_sys.c                 |   5 +-
 arch/alpha/kernel/syscalls/syscall.tbl      |  22 +-
 arch/arm/include/asm/unistd.h               |   5 +-
 arch/arm/kernel/sys_oabi-compat.c           |   8 +-
 arch/arm/tools/syscall.tbl                  |  85 +++--
 arch/arm64/include/asm/unistd.h             |   2 +-
 arch/arm64/include/asm/unistd32.h           |  99 +++--
 arch/ia64/include/asm/unistd.h              |  14 -
 arch/ia64/include/uapi/asm/unistd.h         |   2 +
 arch/ia64/kernel/syscalls/syscall.tbl       |  11 +-
 arch/m68k/include/asm/unistd.h              |   4 +-
 arch/m68k/kernel/syscalls/syscall.tbl       |  88 +++--
 arch/microblaze/include/asm/unistd.h        |   4 +-
 arch/microblaze/kernel/syscalls/syscall.tbl |  83 ++--
 arch/mips/include/asm/unistd.h              |  20 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  77 ++--
 arch/mips/kernel/syscalls/syscall_n64.tbl   |   7 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  85 +++--
 arch/parisc/include/asm/unistd.h            |  15 +-
 arch/parisc/kernel/syscalls/syscall.tbl     | 109 ++++--
 arch/powerpc/include/asm/unistd.h           |   8 +-
 arch/powerpc/kernel/syscalls/syscall.tbl    | 134 +++++--
 arch/s390/include/asm/unistd.h              |   7 +-
 arch/s390/kernel/syscalls/syscall.tbl       |  87 +++--
 arch/sh/include/asm/unistd.h                |   4 +-
 arch/sh/include/uapi/asm/unistd_32.h        | 403 --------------------
 arch/sh/kernel/syscalls/syscall.tbl         |  88 +++--
 arch/sparc/include/asm/unistd.h             |  13 +-
 arch/sparc/kernel/sys_sparc_64.c            |  61 ++-
 arch/sparc/kernel/syscalls/syscall.tbl      | 116 ++++--
 arch/x86/entry/syscalls/syscall_32.tbl      |  85 +++--
 arch/x86/entry/syscalls/syscall_64.tbl      |   4 +-
 arch/x86/include/asm/unistd.h               |   8 +-
 arch/xtensa/include/asm/unistd.h            |  14 +-
 arch/xtensa/kernel/syscalls/syscall.tbl     |  78 ++--
 drivers/ptp/ptp_clock.c                     |   2 +-
 fs/aio.c                                    |  10 +-
 fs/select.c                                 |   4 +-
 fs/timerfd.c                                |   4 +-
 fs/utimes.c                                 |  10 +-
 include/linux/compat.h                      | 104 +----
 include/linux/posix-clock.h                 |   2 +-
 include/linux/syscalls.h                    |  68 +++-
 include/linux/time32.h                      |  32 +-
 include/linux/time64.h                      |   8 -
 include/linux/timex.h                       |   4 +-
 include/uapi/asm-generic/unistd.h           | 103 +++--
 include/uapi/linux/time.h                   |   4 -
 include/uapi/linux/timex.h                  |  39 ++
 ipc/mqueue.c                                |  16 +-
 ipc/msg.c                                   |  39 +-
 ipc/sem.c                                   |  41 +-
 ipc/shm.c                                   |  40 +-
 ipc/syscall.c                               |  12 +-
 ipc/util.h                                  |  21 +-
 kernel/compat.c                             |  64 ----
 kernel/futex.c                              |   2 +-
 kernel/sched/core.c                         |   5 +-
 kernel/signal.c                             |   2 +-
 kernel/sys_ni.c                             |  21 +-
 kernel/time/hrtimer.c                       |   2 +-
 kernel/time/ntp.c                           |  18 +-
 kernel/time/ntp_internal.h                  |   2 +-
 kernel/time/posix-clock.c                   |   2 +-
 kernel/time/posix-stubs.c                   |  25 +-
 kernel/time/posix-timers.c                  |  72 ++--
 kernel/time/posix-timers.h                  |   2 +-
 kernel/time/time.c                          |  92 ++++-
 kernel/time/timekeeping.c                   |   4 +-
 net/compat.c                                |   2 +-
 scripts/checksyscalls.sh                    |  40 ++
 74 files changed, 1544 insertions(+), 1262 deletions(-)
 delete mode 100644 arch/sh/include/uapi/asm/unistd_32.h

-- 
2.20.0
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
Cc: benh@kernel.crashing.org
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
Cc: akpm@linux-foundation.org
Cc: deepa.kernel@gmail.com
Cc: ebiederm@xmission.com
Cc: firoz.khan@linaro.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-alpha@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-ia64@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-mips@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
