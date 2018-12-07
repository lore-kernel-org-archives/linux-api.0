From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/5] y2038: further system call conversion
Date: Fri,  7 Dec 2018 22:18:03 +0100
Message-ID: <20181207211808.328719-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is another set of system call changes that were intended to get
merged much earlier. I've rebased the patches on top of the latest kernel
and Deepa's poll/select/io_pgetevents series now, and applied it to the
same y2038 branch for inclusion in 4.21.

This is just a continuation of the earlier system call changes, so I
expect no surprises here, unless I made a mistake in the rebase.

After this series, the only remaining system calls that need to be
modified are:

- setsockopt/getsockopt, they do not need a new entry in the system
  call table, only new numbers assigned for their socket options.
  Deepa is finalizing her series to passing 64-bit timestamps in cmsg
  correctly for SO_TIMESTAMP{,NS,ING}.
  Further, we need a new SO_RCVTIMEO/SO_SNDTIMEO implementation
  here, which has not been implemented yet.

- waitid/getrusage, this needs a rewrite now from earlier versions
  based on recent feedback. The plan now is to incorporate nanosecond
  timestamps in a new revision of the 'rusage' structure. Possibly also
  include BSD wait6() semantics of passing back the child resource
  usage in waitid(), and/or a method to pass a signal mask as in
  io_pgetevents().  waitid/getrusage() are not required for correct
  behavior with 64-bit time_t and can be safely emulated on top of
  the existing syscalls by the C library beyond 2038.  This needs more
  discussion.

- clock_adjtime, this is also optional and can be implemented
  by the C library if necessary. The plan is to do the same as x32
  and use the 64-bit structure natively on both 32-bit and 64-bit
  architectures. The timex structure contains a 'timeval' at the
  moment, but also supports nanoseconds passed in it. 

- getitimer/setitimer, these again can be trivially emulated
  by the C library.

	Arnd

Arnd Bergmann (5):
  y2038: futex: Move compat implementation into futex.c
  y2038: futex: Add support for __kernel_timespec
  y2038: socket: Add compat_sys_recvmmsg_time64
  y2038: signal: Add sys_rt_sigtimedwait_time32
  y2038: signal: Add compat_sys_rt_sigtimedwait_time64

 include/linux/compat.h   |   8 +-
 include/linux/futex.h    |   8 --
 include/linux/socket.h   |   9 +-
 include/linux/syscalls.h |   9 +-
 kernel/Makefile          |   3 -
 kernel/futex.c           | 207 +++++++++++++++++++++++++++++++++++++--
 kernel/futex_compat.c    | 202 --------------------------------------
 kernel/signal.c          |  65 ++++++++++++
 kernel/sys_ni.c          |   2 +
 net/compat.c             |  34 +++----
 net/socket.c             |  62 +++++++++---
 11 files changed, 345 insertions(+), 264 deletions(-)
 delete mode 100644 kernel/futex_compat.c

-- 
2.18.0
