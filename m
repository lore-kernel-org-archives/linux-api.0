From: Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] y2038: more syscalls and cleanups
Date: Fri, 21 Dec 2018 00:09:43 +0100
Message-ID: <CAK8P3a1t0RiYcHtpwk3jwma0SvsS3NE5PAvTbb2zR4n+wkh69A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-sh list <linux-sh@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Linus and Thomas,

I realized that the merge window is now imminent, but I had not sent a
pull request to Thomas for the current y2038 stuff. These patches have
been around for a while though, and were in linux-next through my tree.

I got one bug report on Monday and incorporated a simple fix, which
changed the commit date for the second half of the series, in case you
are wondering.

Thomas, is it ok for you to just provide an Ack for this branch and
have Linus merge it directly?

      Arnd

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the Git repository at:

  https://git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git
tags/y2038-for-4.21

for you to fetch changes up to e4b92b108c6cd6b311e4b6e85d6a87a34599a6e3:

  timekeeping: remove obsolete time accessors (2018-12-18 16:13:05 +0100)

----------------------------------------------------------------
y2038: more syscalls and cleanups

This concludes the main part of the system call rework for 64-bit time_t,
which has spread over most of year 2018, the last six system calls being

 - ppoll
 - pselect6
 - io_pgetevents
 - recvmmsg
 - futex
 - rt_sigtimedwait

As before, nothing changes for 64-bit architectures, while 32-bit
architectures gain another entry point that differs only in the layout
of the timespec structure. Hopefully in the next release we can wire up
all 22 of those system calls on all 32-bit architectures, which gives
us a baseline version for glibc to start using them.

This does not include the clock_adjtime, getrusage/waitid, and
getitimer/setitimer system calls. I still plan to have new versions
of those as well, but they are not required for correct operation of
the C library since they can be emulated using the old 32-bit time_t
based system calls.

Aside from the system calls, there are also a few cleanups here,
removing old kernel internal interfaces that have become unused after
all references got removed. The arch/sh cleanups are part of this,
there were posted several times over the past year without a reaction
from the maintainers, while the corresponding changes made it into all
other architectures.

----------------------------------------------------------------
Arnd Bergmann (13):
      y2038: futex: Move compat implementation into futex.c
      y2038: futex: Add support for __kernel_timespec
      y2038: socket: Add compat_sys_recvmmsg_time64
      y2038: signal: Add sys_rt_sigtimedwait_time32
      y2038: signal: Add compat_sys_rt_sigtimedwait_time64
      sh: dreamcast: rtc: push down rtc class ops into driver
      sh: sh03: rtc: push down rtc class ops into driver
      sh: remove unused rtc_sh_get/set_time infrastructure
      sh: remove board_time_init() callback
      timekeeping: remove unused {read,update}_persistent_clock
      timekeeping: remove timespec_add/timespec_del
      vfs: replace current_kernel_time64 with ktime equivalent
      timekeeping: remove obsolete time accessors

Deepa Dinamani (5):
      signal: Add set_user_sigmask()
      signal: Add restore_user_sigmask()
      ppoll: use __kernel_timespec
      pselect6: use __kernel_timespec
      io_pgetevents: use __kernel_timespec

 Documentation/sh/new-machine.txt              |   8 --
 arch/sh/boards/mach-dreamcast/Makefile        |   4 +-
 arch/sh/boards/mach-dreamcast/rtc.c           |  45 +++++++---
 arch/sh/boards/mach-dreamcast/setup.c         |   1 -
 arch/sh/boards/mach-sh03/Makefile             |   3 +-
 arch/sh/boards/mach-sh03/rtc.c                |  51 ++++++-----
 arch/sh/boards/mach-sh03/setup.c              |   9 --
 arch/sh/boards/of-generic.c                   |   8 --
 arch/sh/configs/dreamcast_defconfig           |   2 +
 arch/sh/configs/sh03_defconfig                |   2 +
 arch/sh/include/asm/rtc.h                     |   3 -
 arch/sh/include/mach-dreamcast/mach/sysasic.h |   1 -
 arch/sh/kernel/time.c                         |  74 +---------------
 fs/aio.c                                      | 134
++++++++++++++++++++---------
 fs/eventpoll.c                                |  52 ++----------
 fs/inode.c                                    |   4 +-
 fs/select.c                                   | 360
+++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 include/linux/compat.h                        |  26 ++++++
 include/linux/futex.h                         |   8 --
 include/linux/signal.h                        |   4 +
 include/linux/socket.h                        |   9 +-
 include/linux/syscalls.h                      |  29 +++++--
 include/linux/time32.h                        |  25 ------
 include/linux/timekeeping.h                   |  14 ---
 include/linux/timekeeping32.h                 |  15 ----
 kernel/Makefile                               |   3 -
 kernel/futex.c                                | 207
+++++++++++++++++++++++++++++++++++++++++++--
 kernel/futex_compat.c                         | 202
--------------------------------------------
 kernel/signal.c                               | 143
+++++++++++++++++++++++++++++++
 kernel/sys_ni.c                               |   2 +
 kernel/time/ntp.c                             |  10 +--
 kernel/time/time.c                            |  36 --------
 kernel/time/timekeeping.c                     |  12 +--
 net/compat.c                                  |  34 +++-----
 net/socket.c                                  |  62 ++++++++++----
 35 files changed, 847 insertions(+), 755 deletions(-)
 delete mode 100644 kernel/futex_compat.c
