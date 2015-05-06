From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 00/19] converting system calls to 64-bit time_t, part 1
Date: Wed,  6 May 2015 18:30:07 +0200
Message-ID: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is my second draft of how we could modify the system call interface
in Linux to support user space with 64-bit time_t in addition to the
existing 32-bit time_t based interfaces. In order to avoid spamming people
too much, I've picked the first half of the patches only now, and left
some of the more complex ones for later.

If you are interested in the big picture, see
http://git.kernel.org/cgit/linux/kernel/git/arnd/playground.git/log/?h=y2038-syscalls
with currently 42 patches. That number may go up a bit over time, but
only because I plan to split some of the patches into smaller chunks
for review purposes, as opposed to adding more system calls.

As part 1 of the series only switches over half the system calls,
I've left out the bits that changes the ARM and x86 architectures.
There are 24 additional architectures that need to moved over to
the new system calls once the basic patches get merged.

The main part I'm not sure about is how the header files should be
structured in order to make it easy for every libc implementation
to pick out the right definitions of the data structures I had to
modify. Hopefully, people on libc-alpha can help me out here.

The overall approach I have taken here is as follows:

* Since 64-bit architectures already support two versions of each system
  call that passes a time value in order to run 32-bit user space,
  I'm not adding new system calls for the most part, but instead make
  32-bit architectures use the same compat handlers that 64-bit
  architectures already use.

* The existing syscall numbers are modified to point to the compat_sys_*
  functions, and new numbers are assigned to point to the existing handlers
  that now deal with 64-bit time_t based structures

* This series does not touch any ioctl implementation, but should be
  otherwise complete regarding the system calls. We are still trying
  to find out exactly which ioctls are affected and have not come
  up with a complete list at this point. It's probably a good idea
  though to do at least the essential ioctls before merging the series,
  so we can have a better understanding of how it will be done in the
  end.

* Each data structure we need to modify gets a new definition with a
  __kernel_ prefix, e.g. struct __kernel_timespec to replace struct
  timespec. This keeps the new structures out of the user libc
  namespace, but still allows the structure to be integrated into
  other data structures, e.g. for ioctl.

* There is no #ifdef in the UAPI headers at this point that would
  check for the kind of user space that is in use. Unfortunately,
  I believe we will need to add that in order to do some of the
  particularly tricky ioctls later.

* At first, all system call implementations are modified, but this
  is done in a way that is not supposed to have any ABI-visible
  effect on existing architectures.

* After all system calls are converted, we can change one architecture
  at a time to select ARCH_HAS_COMPAT_TIME, and modify its system
  call table accordingly. In this version, I do it for ARM32, x86-32,
  and x86-64 for demonstration purposes.

* A follow-up series changes over all other architectures.

* The last patch in the series changes the CONFIG_COMPAT_TIME
  Kconfig symbol to be user visible. Disabling this symbol will
  get you a kernel that intentionally breaks support for old tasks
  in order to provide an interface that will survive 2038.
  This is meant mostly as a debugging help for now, to let people
  build a y2038 safe distro, but at some point in the 2030s, we
  should remove that option and all the compat handling.

Arnd Bergmann (19):
  compat: remove compat_printk
  initramfs: use vfs_stat/lstat directly
  y2038: introduce linux/compat_time.h header
  y2038: introduce CONFIG_COMPAT_TIME
  y2038: make linux/compat_time.h usable on 32-bit
  y2038: compile compat time code even when CONFIG_COMPAT is not set
  y2038: add compat_sys_rt_sigtimedwait variants
  y2038: introduce struct __kernel_timespec
  y2038: introduce struct __kernel_stat
  y2038: use __kernel_stat for sys_newstat syscalls
  y2038: introduce and use struct __kernel_rusage
  y2038: add compat_{get,put}_timespec64
  y2038: add compat handling for sys_semtimedop
  y2038: use __kernel_timespec for sys_mq_timed{send,receive}
  y2038: introduce timespec64_to_jiffies
  y2038: use __kernel_timespec in sys_rt_sigtimedwait
  y2038: use __kernel_timespec in sys_futex
  y2038: introduce jiffies_to_timespec64
  y2038: use __kernel_timespec in sys_sched_rr_get_interval

 arch/Kconfig                           |  11 ++
 arch/alpha/include/uapi/asm/stat.h     |   4 +
 arch/alpha/kernel/osf_sys.c            |   4 +-
 arch/arm/include/uapi/asm/stat.h       |   2 +
 arch/arm64/include/asm/compat.h        |  11 --
 arch/avr32/include/uapi/asm/stat.h     |   2 +
 arch/blackfin/include/uapi/asm/stat.h  |   2 +
 arch/cris/include/uapi/asm/stat.h      |   2 +
 arch/frv/include/uapi/asm/stat.h       |   2 +
 arch/ia64/include/uapi/asm/stat.h      |   4 +
 arch/m32r/include/uapi/asm/stat.h      |   1 +
 arch/m68k/include/uapi/asm/stat.h      |   2 +
 arch/mips/include/asm/compat.h         |  11 --
 arch/mips/include/uapi/asm/stat.h      |   1 +
 arch/mn10300/include/uapi/asm/stat.h   |   2 +
 arch/parisc/include/asm/compat.h       |  11 --
 arch/parisc/include/uapi/asm/stat.h    |   1 +
 arch/powerpc/include/asm/compat.h      |  11 --
 arch/powerpc/include/uapi/asm/stat.h   |  25 +++
 arch/s390/include/asm/compat.h         |  11 --
 arch/s390/include/uapi/asm/stat.h      |  24 +++
 arch/sh/include/uapi/asm/stat.h        |   2 +
 arch/sparc/include/asm/compat.h        |  11 --
 arch/sparc/include/uapi/asm/stat.h     |  28 ++++
 arch/tile/include/asm/compat.h         |  11 --
 arch/x86/include/asm/compat.h          |  12 +-
 arch/x86/include/asm/ftrace.h          |   2 +-
 arch/x86/include/asm/sys_ia32.h        |   2 +-
 arch/x86/include/uapi/asm/stat.h       |  49 ++++--
 arch/x86/kernel/cpu/perf_event.c       |   2 +-
 arch/xtensa/include/uapi/asm/stat.h    |   2 +
 fs/Makefile                            |   1 +
 fs/compat.c                            |  26 ++-
 fs/stat.c                              |  12 +-
 include/linux/audit.h                  |   4 +-
 include/linux/compat.h                 | 232 +--------------------------
 include/linux/compat_time.h            | 285 +++++++++++++++++++++++++++++++++
 include/linux/jiffies.h                |  23 ++-
 include/linux/resource.h               |   8 +-
 include/linux/signal.h                 |   3 +-
 include/linux/stat.h                   |   3 +
 include/linux/syscalls.h               |  32 ++--
 include/linux/thread_info.h            |   2 +-
 include/linux/time64.h                 |  17 +-
 include/uapi/asm-generic/kernel_stat.h |  36 +++++
 include/uapi/asm-generic/stat.h        |  12 +-
 include/uapi/linux/resource.h          |  32 ++++
 include/uapi/linux/time.h              |  17 ++
 init/do_mounts.h                       |  22 +--
 init/initramfs.c                       |  12 +-
 ipc/compat.c                           |  10 --
 ipc/mqueue.c                           |  16 +-
 ipc/sem.c                              |  60 +++++--
 ipc/syscall.c                          |   7 +
 kernel/Makefile                        |   1 +
 kernel/audit.h                         |   2 +-
 kernel/auditsc.c                       |  14 +-
 kernel/compat.c                        | 184 ++++++++++++++++++---
 kernel/exit.c                          |   6 +-
 kernel/futex.c                         |  10 +-
 kernel/sched/core.c                    |  35 +++-
 kernel/signal.c                        |  13 +-
 kernel/sys.c                           |  23 +--
 kernel/sysctl.c                        |  10 --
 kernel/time/time.c                     |  45 ++++--
 65 files changed, 950 insertions(+), 530 deletions(-)
 create mode 100644 include/linux/compat_time.h
 create mode 100644 include/uapi/asm-generic/kernel_stat.h

-- 
2.1.0.rc2
