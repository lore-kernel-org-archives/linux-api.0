From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/19] converting system calls to 64-bit time_t, part 1
Date: Thu, 07 May 2015 10:52:08 +0200
Message-ID: <2330671.lQAl76KQcx@wuerfel>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430983678.8171.23.camel@x220> <1430984358.8171.28.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430984358.8171.28.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Thursday 07 May 2015 09:39:18 Paul Bolle wrote:
> On Thu, 2015-05-07 at 09:27 +0200, Paul Bolle wrote:
> > On Wed, 2015-05-06 at 18:30 +0200, Arnd Bergmann wrote:
> > > * After all system calls are converted, we can change one architecture
> > >   at a time to select ARCH_HAS_COMPAT_TIME, and modify its system
> > >   call table accordingly. In this version, I do it for ARM32, x86-32,
> > >   and x86-64 for demonstration purposes.
> > 
> > Perhaps this was correct for your first draft. Because this series adds
> > ARCH_HAS_COMPAT_TIME in 04/19, but it doesn't add any selects of that
> > symbol, does it? As far as I can see ARCH_HAS_COMPAT_TIME simply
> > functions as an alias for COMPAT in this series.

It is still the intention of the patch to add the selects in the later
patches that are required to see any benefit of the earlier patches.

ARCH_HAS_COMPAT_TIME is in the "x86: use COMPAT_SYS_TIME" and
"ARM: use CONFIG_COMPAT_TIME" patches of the full series available
on my git tree.

I realize the downsides of not posting the entire series at once
here, but it seemed better to avoid spamming everyone too much,
while I try to find out if we have agreement on the overall
strategy.

For reference, see below for the ARM patch.

> > > * A follow-up series changes over all other architectures.
> > > 
> > > * The last patch in the series changes the CONFIG_COMPAT_TIME
> > >   Kconfig symbol to be user visible. Disabling this symbol will
> > >   get you a kernel that intentionally breaks support for old tasks
> > >   in order to provide an interface that will survive 2038.
> > 
> > This doesn't happen in 19/19, or in any other patch in this series.
> > Maybe also something that has changed since the first draft.
> > 
> > >   This is meant mostly as a debugging help for now, to let people
> > >   build a y2038 safe distro, but at some point in the 2030s, we
> > >   should remove that option and all the compat handling.
> 
> And then it occurred to me to check the y2038-syscalls git branch you
> referenced. After which the above made much more sense. (Though my
> remark that ARCH_HAS_COMPAT_TIME simply functions as an alias for COMPAT
> also seems to hold for that branch.)

Right, in fact both of these happen at the end of the git tree.

	Arnd

8<-------
commit 93a8526e02b6e29888df516e5750cd6483ee4472
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Apr 24 17:12:08 2015 +0200

    ARM: use CONFIG_COMPAT_TIME
    
    This changes the ARM architecture to use the new compat system call
    definitions that were added in previous patches. All system calls
    that use 32-bit time_t now go through the COMPAT framework, while
    a set of 25 new system calls gets added to replace them using 64-bit
    data structures __kernel_timespec, __kernel_itimerspec,
    __kernel_rusage, __kernel_msqid_ds, __kernel_semid_ds, __kernel_shmid_ds
    and __kernel_stat.
    
    Similarly, we add all the new system calls to the arm64 compat syscall
    table.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
--
 arch/arm/Kconfig                   |   1 +
 arch/arm/include/asm/unistd.h      |  11 ++--
 arch/arm/include/uapi/asm/unistd.h |  22 ++++++++
 arch/arm/kernel/calls.S            | 101 +++++++++++++++++++++++--------------
 arch/arm/kernel/sys_oabi-compat.c  |   9 ++--
 arch/arm64/include/asm/unistd32.h  |  44 ++++++++++++++++
 6 files changed, 142 insertions(+), 46 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 45df48ba0b12..491896833c76 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2,6 +2,7 @@ config ARM
 	bool
 	default y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_COMPAT_TIME
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 32640c431a08..ad7588eb9d58 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -19,7 +19,7 @@
  * This may need to be greater than __NR_last_syscall+1 in order to
  * account for the padding in the syscall table
  */
-#define __NR_syscalls  (388)
+#define __NR_syscalls  (412)
 
 /*
  * *NOTE*: This is a ghost syscall private to the kernel.  Only the
@@ -28,7 +28,9 @@
  */
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
+#ifdef CONFIG_COMPAT_TIME
 #define __ARCH_WANT_STAT64
+#endif
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_GETPGRP
@@ -40,11 +42,13 @@
 #define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
-#define __ARCH_WANT_SYS_TIME
+#ifdef CONFIG_COMPAT_TIME
+#define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_SYS_IPC
+#define __ARCH_WANT_SYS_UTIME
+#endif
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_SOCKETCALL
@@ -52,6 +56,7 @@
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_NEWFSTATAT
 
 /*
  * Unimplemented (or alternatively implemented) syscalls
diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index 0c3f5a0dafd3..4ea2d7312f15 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -414,6 +414,28 @@
 #define __NR_memfd_create		(__NR_SYSCALL_BASE+385)
 #define __NR_bpf			(__NR_SYSCALL_BASE+386)
 #define __NR_execveat			(__NR_SYSCALL_BASE+387)
+#define __NR_clock_gettime64		(__NR_SYSCALL_BASE+388)
+#define __NR_clock_settime64		(__NR_SYSCALL_BASE+389)
+#define __NR_clock_adjtime64		(__NR_SYSCALL_BASE+390)
+#define __NR_clock_getres64		(__NR_SYSCALL_BASE+391)
+#define __NR_clock_nanosleep64		(__NR_SYSCALL_BASE+392)
+#define __NR_timer_gettime64		(__NR_SYSCALL_BASE+393)
+#define __NR_timer_settime64		(__NR_SYSCALL_BASE+394)
+#define __NR_timerfd_gettime64		(__NR_SYSCALL_BASE+395)
+#define __NR_timerfd_settime64		(__NR_SYSCALL_BASE+396)
+#define __NR_pselect64			(__NR_SYSCALL_BASE+397)
+#define __NR_ppoll64			(__NR_SYSCALL_BASE+398)
+#define __NR_io_getevents64		(__NR_SYSCALL_BASE+399)
+#define __NR_recvmmsg64			(__NR_SYSCALL_BASE+400)
+#define __NR_semtimedop64		(__NR_SYSCALL_BASE+401)
+#define __NR_mq_timedsend64		(__NR_SYSCALL_BASE+402)
+#define __NR_mq_timedreceive64		(__NR_SYSCALL_BASE+403)
+#define __NR_utimensat64		(__NR_SYSCALL_BASE+404)
+#define __NR_newfstat64			(__NR_SYSCALL_BASE+405)
+#define __NR_newfstatat64		(__NR_SYSCALL_BASE+406)
+#define __NR_rt_sigtimedwait64		(__NR_SYSCALL_BASE+407)
+#define __NR_getrusage64		(__NR_SYSCALL_BASE+408)
+#define __NR_waitid64			(__NR_SYSCALL_BASE+409)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 05745eb838c5..092a2e1d979c 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -22,7 +22,7 @@
 /* 10 */	CALL(sys_unlink)
 		CALL(sys_execve)
 		CALL(sys_chdir)
-		CALL(OBSOLETE(sys_time))	/* used by libc4 */
+		CALL(OBSOLETE(compat_sys_time))	/* used by libc4 */
 		CALL(sys_mknod)
 /* 15 */	CALL(sys_chmod)
 		CALL(sys_lchown16)
@@ -34,12 +34,12 @@
 		CALL(OBSOLETE(sys_oldumount))	/* used by libc4 */
 		CALL(sys_setuid16)
 		CALL(sys_getuid16)
-/* 25 */	CALL(OBSOLETE(sys_stime))
+/* 25 */	CALL(OBSOLETE(compat_sys_stime))
 		CALL(sys_ptrace)
 		CALL(OBSOLETE(sys_alarm))	/* used by libc4 */
 		CALL(sys_ni_syscall)		/* was sys_fstat */
 		CALL(sys_pause)
-/* 30 */	CALL(OBSOLETE(sys_utime))	/* used by libc4 */
+/* 30 */	CALL(OBSOLETE(compat_sys_utime))/* used by libc4 */
 		CALL(sys_ni_syscall)		/* was sys_stty */
 		CALL(sys_ni_syscall)		/* was sys_getty */
 		CALL(sys_access)
@@ -86,12 +86,12 @@
 		CALL(sys_sethostname)
 /* 75 */	CALL(sys_setrlimit)
 		CALL(OBSOLETE(sys_old_getrlimit)) /* used by libc4 */
-		CALL(sys_getrusage)
-		CALL(sys_gettimeofday)
-		CALL(sys_settimeofday)
+		CALL(compat_sys_getrusage)
+		CALL(compat_sys_gettimeofday)
+		CALL(compat_sys_settimeofday)
 /* 80 */	CALL(sys_getgroups16)
 		CALL(sys_setgroups16)
-		CALL(OBSOLETE(sys_old_select))	/* used by libc4 */
+		CALL(OBSOLETE(compat_sys_old_select))	/* used by libc4 */
 		CALL(sys_symlink)
 		CALL(sys_ni_syscall)		/* was sys_lstat */
 /* 85 */	CALL(sys_readlink)
@@ -113,17 +113,17 @@
 		CALL(sys_ni_syscall)		/* sys_ioperm */
 		CALL(OBSOLETE(ABI(sys_socketcall, sys_oabi_socketcall)))
 		CALL(sys_syslog)
-		CALL(sys_setitimer)
-/* 105 */	CALL(sys_getitimer)
-		CALL(sys_newstat)
-		CALL(sys_newlstat)
-		CALL(sys_newfstat)
+		CALL(compat_sys_setitimer)
+/* 105 */	CALL(compat_sys_getitimer)
+		CALL(compat_sys_newstat)
+		CALL(compat_sys_newlstat)
+		CALL(compat_sys_newfstat)
 		CALL(sys_ni_syscall)		/* was sys_uname */
 /* 110 */	CALL(sys_ni_syscall)		/* was sys_iopl */
 		CALL(sys_vhangup)
 		CALL(sys_ni_syscall)
 		CALL(OBSOLETE(sys_syscall))	/* call a syscall */
-		CALL(sys_wait4)
+		CALL(compat_sys_wait4)
 /* 115 */	CALL(sys_swapoff)
 		CALL(sys_sysinfo)
 		CALL(OBSOLETE(ABI(sys_ipc, sys_oabi_ipc)))
@@ -133,7 +133,7 @@
 		CALL(sys_setdomainname)
 		CALL(sys_newuname)
 		CALL(sys_ni_syscall)		/* modify_ldt */
-		CALL(sys_adjtimex)
+		CALL(compat_sys_adjtimex)
 /* 125 */	CALL(sys_mprotect)
 		CALL(sys_sigprocmask)
 		CALL(sys_ni_syscall)		/* was sys_create_module */
@@ -151,7 +151,7 @@
 		CALL(sys_setfsgid16)
 /* 140 */	CALL(sys_llseek)
 		CALL(sys_getdents)
-		CALL(sys_select)
+		CALL(compat_sys_select)
 		CALL(sys_flock)
 		CALL(sys_msync)
 /* 145 */	CALL(sys_readv)
@@ -170,8 +170,8 @@
 		CALL(sys_sched_yield)
 		CALL(sys_sched_get_priority_max)
 /* 160 */	CALL(sys_sched_get_priority_min)
-		CALL(sys_sched_rr_get_interval)
-		CALL(sys_nanosleep)
+		CALL(compat_sys_sched_rr_get_interval)
+		CALL(compat_sys_nanosleep)
 		CALL(sys_mremap)
 		CALL(sys_setresuid16)
 /* 165 */	CALL(sys_getresuid16)
@@ -186,7 +186,7 @@
 		CALL(sys_rt_sigaction)
 /* 175 */	CALL(sys_rt_sigprocmask)
 		CALL(sys_rt_sigpending)
-		CALL(sys_rt_sigtimedwait)
+		CALL(compat_sys_rt_sigtimedwait)
 		CALL(sys_rt_sigqueueinfo)
 		CALL(sys_rt_sigsuspend)
 /* 180 */	CALL(ABI(sys_pread64, sys_oabi_pread64))
@@ -249,12 +249,12 @@
 		CALL(sys_fremovexattr)
 		CALL(sys_tkill)
 		CALL(sys_sendfile64)
-/* 240 */	CALL(sys_futex)
+/* 240 */	CALL(compat_sys_futex)
 		CALL(sys_sched_setaffinity)
 		CALL(sys_sched_getaffinity)
 		CALL(sys_io_setup)
 		CALL(sys_io_destroy)
-/* 245 */	CALL(sys_io_getevents)
+/* 245 */	CALL(compat_sys_io_getevents)
 		CALL(sys_io_submit)
 		CALL(sys_io_cancel)
 		CALL(sys_exit_group)
@@ -267,29 +267,29 @@
 /* 255 */	CALL(sys_ni_syscall)	/* sys_get_thread_area */
 		CALL(sys_set_tid_address)
 		CALL(sys_timer_create)
-		CALL(sys_timer_settime)
-		CALL(sys_timer_gettime)
+		CALL(compat_sys_timer_settime)
+		CALL(compat_sys_timer_gettime)
 /* 260 */	CALL(sys_timer_getoverrun)
 		CALL(sys_timer_delete)
-		CALL(sys_clock_settime)
-		CALL(sys_clock_gettime)
-		CALL(sys_clock_getres)
-/* 265 */	CALL(sys_clock_nanosleep)
+		CALL(compat_sys_clock_settime)
+		CALL(compat_sys_clock_gettime)
+		CALL(compat_sys_clock_getres)
+/* 265 */	CALL(compat_sys_clock_nanosleep)
 		CALL(sys_statfs64_wrapper)
 		CALL(sys_fstatfs64_wrapper)
 		CALL(sys_tgkill)
-		CALL(sys_utimes)
+		CALL(compat_sys_utimes)
 /* 270 */	CALL(sys_arm_fadvise64_64)
 		CALL(sys_pciconfig_iobase)
 		CALL(sys_pciconfig_read)
 		CALL(sys_pciconfig_write)
 		CALL(sys_mq_open)
 /* 275 */	CALL(sys_mq_unlink)
-		CALL(sys_mq_timedsend)
-		CALL(sys_mq_timedreceive)
+		CALL(compat_sys_mq_timedsend)
+		CALL(compat_sys_mq_timedreceive)
 		CALL(sys_mq_notify)
 		CALL(sys_mq_getsetattr)
-/* 280 */	CALL(sys_waitid)
+/* 280 */	CALL(compat_sys_waitid)
 		CALL(sys_socket)
 		CALL(ABI(sys_bind, sys_oabi_bind))
 		CALL(ABI(sys_connect, sys_oabi_connect))
@@ -321,7 +321,7 @@
 		CALL(sys_add_key)
 /* 310 */	CALL(sys_request_key)
 		CALL(sys_keyctl)
-		CALL(ABI(sys_semtimedop, sys_oabi_semtimedop))
+		CALL(ABI(compat_sys_semtimedop, sys_oabi_semtimedop))
 /* vserver */	CALL(sys_ni_syscall)
 		CALL(sys_ioprio_set)
 /* 315 */	CALL(sys_ioprio_get)
@@ -335,7 +335,7 @@
 		CALL(sys_mkdirat)
 		CALL(sys_mknodat)
 /* 325 */	CALL(sys_fchownat)
-		CALL(sys_futimesat)
+		CALL(compat_sys_futimesat)
 		CALL(ABI(sys_fstatat64,  sys_oabi_fstatat64))
 		CALL(sys_unlinkat)
 		CALL(sys_renameat)
@@ -344,8 +344,8 @@
 		CALL(sys_readlinkat)
 		CALL(sys_fchmodat)
 		CALL(sys_faccessat)
-/* 335 */	CALL(sys_pselect6)
-		CALL(sys_ppoll)
+/* 335 */	CALL(compat_sys_pselect6)
+		CALL(compat_sys_ppoll)
 		CALL(sys_unshare)
 		CALL(sys_set_robust_list)
 		CALL(sys_get_robust_list)
@@ -357,13 +357,13 @@
 /* 345 */	CALL(sys_getcpu)
 		CALL(sys_epoll_pwait)
 		CALL(sys_kexec_load)
-		CALL(sys_utimensat)
+		CALL(compat_sys_utimensat)
 		CALL(sys_signalfd)
 /* 350 */	CALL(sys_timerfd_create)
 		CALL(sys_eventfd)
 		CALL(sys_fallocate)
-		CALL(sys_timerfd_settime)
-		CALL(sys_timerfd_gettime)
+		CALL(compat_sys_timerfd_settime)
+		CALL(compat_sys_timerfd_gettime)
 /* 355 */	CALL(sys_signalfd4)
 		CALL(sys_eventfd2)
 		CALL(sys_epoll_create1)
@@ -374,14 +374,14 @@
 		CALL(sys_pwritev)
 		CALL(sys_rt_tgsigqueueinfo)
 		CALL(sys_perf_event_open)
-/* 365 */	CALL(sys_recvmmsg)
+/* 365 */	CALL(compat_sys_recvmmsg)
 		CALL(sys_accept4)
 		CALL(sys_fanotify_init)
 		CALL(sys_fanotify_mark)
 		CALL(sys_prlimit64)
 /* 370 */	CALL(sys_name_to_handle_at)
 		CALL(sys_open_by_handle_at)
-		CALL(sys_clock_adjtime)
+		CALL(compat_sys_clock_adjtime)
 		CALL(sys_syncfs)
 		CALL(sys_sendmmsg)
 /* 375 */	CALL(sys_setns)
@@ -397,6 +397,29 @@
 /* 385 */	CALL(sys_memfd_create)
 		CALL(sys_bpf)
 		CALL(sys_execveat)
+		CALL(sys_clock_gettime)
+		CALL(sys_clock_settime)
+/* 390 */	CALL(sys_clock_adjtime)
+		CALL(sys_clock_getres)
+		CALL(sys_clock_nanosleep)
+		CALL(sys_timer_gettime)
+		CALL(sys_timer_settime)
+/* 395 */	CALL(sys_timerfd_gettime)
+		CALL(sys_timerfd_settime)
+		CALL(sys_pselect6)
+		CALL(sys_ppoll)
+		CALL(sys_io_getevents)
+/* 400 */	CALL(sys_recvmmsg)
+		CALL(sys_semtimedop)
+		CALL(sys_mq_timedsend)
+		CALL(sys_mq_timedreceive)
+		CALL(sys_utimensat)
+/* 405 */	CALL(sys_newfstat)
+		CALL(sys_newfstatat)
+		CALL(sys_rt_sigtimedwait)
+		CALL(sys_getrusage)
+		CALL(sys_waitid)
+
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index b83f3b7737fb..2e990b564371 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -73,6 +73,7 @@
  *   wrappers provided below.
  */
 
+#include <linux/compat_time.h>
 #include <linux/syscalls.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -307,10 +308,10 @@ struct oabi_sembuf {
 asmlinkage long sys_oabi_semtimedop(int semid,
 				    struct oabi_sembuf __user *tsops,
 				    unsigned nsops,
-				    const struct timespec __user *timeout)
+				    const struct compat_timespec __user *timeout)
 {
 	struct sembuf *sops;
-	struct timespec local_timeout;
+	struct compat_timespec local_timeout;
 	long err;
 	int i;
 
@@ -336,7 +337,7 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 	} else {
 		mm_segment_t fs = get_fs();
 		set_fs(KERNEL_DS);
-		err = sys_semtimedop(semid, sops, nsops, timeout);
+		err = compat_sys_semtimedop(semid, sops, nsops, timeout);
 		set_fs(fs);
 	}
 	kfree(sops);
@@ -361,7 +362,7 @@ asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 		return  sys_oabi_semtimedop(first,
 					    (struct oabi_sembuf __user *)ptr,
 					    second,
-					    (const struct timespec __user *)fifth);
+					    (const struct compat_timespec __user *)fifth);
 	default:
 		return sys_ipc(call, first, second, third, ptr, fifth);
 	}
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index cef934a90f17..1659a0c68ea3 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -797,3 +797,47 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 387
 __SYSCALL(__NR_execveat, compat_sys_execveat)
+#define __NR_clock_gettime64 388
+_SYSCALL(__NR_clock_gettime64, sys_clock_gettime)
+#define __NR_clock_settime64 389
+_SYSCALL(__NR_clock_settime64, sys_clock_settime)
+#define __NR_clock_adjtime64 390
+_SYSCALL(__NR_clock_adjtime64, sys_clock_adjtime)
+#define __NR_clock_getres64 391
+_SYSCALL(__NR_clock_getres64, sys_clock_getres)
+#define __NR_clock_nanosleep64 392
+_SYSCALL(__NR_clock_nanosleep64, sys_clock_nanosleep)
+#define __NR_timer_gettime64 393
+_SYSCALL(__NR_timer_gettime64, sys_timer_gettime)
+#define __NR_timer_settime64 394
+_SYSCALL(__NR_timer_settime64, sys_timer_settime)
+#define __NR_timerfd_gettime64 395
+_SYSCALL(__NR_timerfd_gettime64, sys_timerfd_gettime)
+#define __NR_timerfd_settime64 396
+_SYSCALL(__NR_timerfd_settime64, sys_timerfd_settime)
+#define __NR_pselect64 397
+_SYSCALL(__NR_pselect64, compat_sys_pselect6_time64)
+#define __NR_ppoll64 398
+_SYSCALL(__NR_ppoll64, compat_sys_ppoll_time64)
+#define __NR_io_getevents64 399
+_SYSCALL(__NR_io_getevents64, sys_io_getevents)
+#define __NR_recvmmsg64 400
+_SYSCALL(__NR_recvmmsg64, compat_sys_recvmmsg64)
+#define __NR_semtimedop64 401
+_SYSCALL(__NR_semtimedop64, sys_semtimedop)
+#define __NR_mq_timedsend64 402
+_SYSCALL(__NR_mq_timedsend64, sys_mq_timedsend)
+#define __NR_mq_timedreceive64 403
+_SYSCALL(__NR_mq_timedreceive64, sys_mq_timedreceive)
+#define __NR_utimensat64 404
+_SYSCALL(__NR_utimensat64, sys_utimensat)
+#define __NR_newfstat64 405
+_SYSCALL(__NR_newfstat64, sys_newfstat)
+#define __NR_newfstatat64 406
+_SYSCALL(__NR_newfstatat64, sys_newfstatat)
+#define __NR_rt_sigtimedwait64 407
+_SYSCALL(__NR_rt_sigtimedwait64, compat_sys_rt_sigtimedwait_time64)
+#define __NR_getrusage64 408
+_SYSCALL(__NR_getrusage64, sys_getrusage)
+#define __NR_waitid64 409
+_SYSCALL(__NR_waitid64, compat_sys_waitid_time64)
