From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/19] y2038: introduce linux/compat_time.h header
Date: Wed,  6 May 2015 18:30:10 +0200
Message-ID: <1430929826-318934-4-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

We want to reuse all the compat syscall handling for native syscalls
on 32-bit architectures when dealing with 32-bit time_t types.

This moves all time-related system call declarations from
include/linux/compat.h to include/linux/compat_time.h, along
with the associated data structures and typedefs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/compat.h   |  11 --
 arch/mips/include/asm/compat.h    |  11 --
 arch/parisc/include/asm/compat.h  |  11 --
 arch/powerpc/include/asm/compat.h |  11 --
 arch/s390/include/asm/compat.h    |  11 --
 arch/sparc/include/asm/compat.h   |  11 --
 arch/tile/include/asm/compat.h    |  11 --
 arch/x86/include/asm/compat.h     |  12 +-
 arch/x86/include/asm/ftrace.h     |   2 +-
 arch/x86/include/asm/sys_ia32.h   |   2 +-
 arch/x86/kernel/cpu/perf_event.c  |   2 +-
 include/linux/compat.h            | 225 +--------------------------------
 include/linux/compat_time.h       | 255 ++++++++++++++++++++++++++++++++++++++
 13 files changed, 262 insertions(+), 313 deletions(-)
 create mode 100644 include/linux/compat_time.h

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 7fbed6919b54..4d0786a73a93 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -34,7 +34,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
@@ -66,16 +65,6 @@ typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
 typedef u32		compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 #ifdef __AARCH64EB__
 	short		st_dev;
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index c4bd54a7f5ce..6495b37a6fbc 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -13,7 +13,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_suseconds_t;
 
@@ -45,16 +44,6 @@ typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
 typedef u32		compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	s32		st_pad1[3];
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index 94710cfc1ce8..cc20c7b203f4 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -12,7 +12,6 @@
 
 typedef u32	compat_size_t;
 typedef s32	compat_ssize_t;
-typedef s32	compat_time_t;
 typedef s32	compat_clock_t;
 typedef s32	compat_pid_t;
 typedef u32	__compat_uid_t;
@@ -39,16 +38,6 @@ typedef u32	compat_ulong_t;
 typedef u64	compat_u64;
 typedef u32	compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t		tv_sec;
-	s32			tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t		tv_sec;
-	s32			tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t		st_dev;	/* dev_t is 32 bits on parisc */
 	compat_ino_t		st_ino;	/* 32 bits */
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index b142b8e0ed9e..4f8901448eba 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -16,7 +16,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
 typedef u32		__compat_uid_t;
@@ -44,16 +43,6 @@ typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
 typedef u32		compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	compat_ino_t	st_ino;
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index d350ed9d0fbb..91398bb0695c 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -50,7 +50,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
@@ -94,16 +93,6 @@ typedef struct {
 	u32 gprs_high[NUM_GPRS];
 } s390_compat_regs_high;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	u16		__pad1;
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 830502fe62b4..c7e71a6d7232 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -10,7 +10,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
@@ -38,16 +37,6 @@ typedef u32		compat_ulong_t;
 typedef u64		compat_u64;
 typedef u32		compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	compat_ino_t	st_ino;
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index c14e36f008c8..c3a326c9ae75 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -29,7 +29,6 @@ typedef u32		compat_ulong_t;
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
 typedef s32		compat_off_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef u32		compat_ino_t;
 typedef u32		compat_caddr_t;
@@ -59,16 +58,6 @@ typedef unsigned long compat_elf_greg_t;
 #define COMPAT_ELF_NGREG (sizeof(struct pt_regs) / sizeof(compat_elf_greg_t))
 typedef compat_elf_greg_t compat_elf_gregset_t[COMPAT_ELF_NGREG];
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 #define compat_stat stat
 #define compat_statfs statfs
 
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index acdee09228b3..b8ce4e15b511 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -15,7 +15,6 @@
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
-typedef s32		compat_time_t;
 typedef s32		compat_clock_t;
 typedef s32		compat_pid_t;
 typedef u16		__compat_uid_t;
@@ -43,16 +42,6 @@ typedef u32		compat_ulong_t;
 typedef u64 __attribute__((aligned(4))) compat_u64;
 typedef u32		compat_uptr_t;
 
-struct compat_timespec {
-	compat_time_t	tv_sec;
-	s32		tv_nsec;
-};
-
-struct compat_timeval {
-	compat_time_t	tv_sec;
-	s32		tv_usec;
-};
-
 struct compat_stat {
 	compat_dev_t	st_dev;
 	u16		__pad1;
@@ -270,6 +259,7 @@ typedef struct user_regs_struct compat_elf_gregset_t;
   do { *(int *) (((void *) &((S)->pr_reg)) + PR_REG_SIZE(0)) = (V); } \
   while (0)
 
+#undef COMPAT_USE_64BIT_TIME
 #define COMPAT_USE_64BIT_TIME \
 	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
 #else
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index f45acad3c4b6..2c2a23cb716c 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -45,7 +45,7 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #if !defined(__ASSEMBLY__) && !defined(COMPILE_OFFSETS)
 
 #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
-#include <asm/compat.h>
+#include <linux/compat.h>
 
 /*
  * Because ia32 syscalls do not map to x86_64 syscall numbers
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index 82c34ee25a65..8527b26ad36f 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -16,7 +16,7 @@
 #include <linux/linkage.h>
 #include <linux/types.h>
 #include <linux/signal.h>
-#include <asm/compat.h>
+#include <linux/compat.h>
 #include <asm/ia32.h>
 
 /* ia32/sys_ia32.c */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 87848ebe2bb7..6649e07bfe66 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2134,7 +2134,7 @@ static unsigned long get_segment_base(unsigned int segment)
 
 #ifdef CONFIG_COMPAT
 
-#include <asm/compat.h>
+#include <linux/compat.h>
 
 static inline int
 perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index d533d06146a8..41b0dae6203b 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -15,15 +15,12 @@
 #include <linux/fs.h>
 #include <linux/aio_abi.h>	/* for aio_context_t */
 #include <linux/unistd.h>
+#include <linux/compat_time.h>
 
 #include <asm/compat.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
-#ifndef COMPAT_USE_64BIT_TIME
-#define COMPAT_USE_64BIT_TIME 0
-#endif
-
 #ifndef __SC_DELOUSE
 #define __SC_DELOUSE(t,v) ((t)(unsigned long)(v))
 #endif
@@ -72,26 +69,9 @@ typedef struct compat_sigaltstack {
 typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
-typedef	compat_ulong_t		compat_aio_context_t;
-
 struct compat_sel_arg_struct;
 struct rusage;
 
-struct compat_itimerspec {
-	struct compat_timespec it_interval;
-	struct compat_timespec it_value;
-};
-
-struct compat_utimbuf {
-	compat_time_t		actime;
-	compat_time_t		modtime;
-};
-
-struct compat_itimerval {
-	struct compat_timeval	it_interval;
-	struct compat_timeval	it_value;
-};
-
 struct compat_tms {
 	compat_clock_t		tms_utime;
 	compat_clock_t		tms_stime;
@@ -99,39 +79,6 @@ struct compat_tms {
 	compat_clock_t		tms_cstime;
 };
 
-struct compat_timex {
-	compat_uint_t modes;
-	compat_long_t offset;
-	compat_long_t freq;
-	compat_long_t maxerror;
-	compat_long_t esterror;
-	compat_int_t status;
-	compat_long_t constant;
-	compat_long_t precision;
-	compat_long_t tolerance;
-	struct compat_timeval time;
-	compat_long_t tick;
-	compat_long_t ppsfreq;
-	compat_long_t jitter;
-	compat_int_t shift;
-	compat_long_t stabil;
-	compat_long_t jitcnt;
-	compat_long_t calcnt;
-	compat_long_t errcnt;
-	compat_long_t stbcnt;
-	compat_int_t tai;
-
-	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
-	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
-	compat_int_t:32; compat_int_t:32; compat_int_t:32;
-};
-
-#define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
-
-typedef struct {
-	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
-} compat_sigset_t;
-
 struct compat_sigaction {
 #ifndef __ARCH_HAS_IRIX_SIGACTION
 	compat_uptr_t			sa_handler;
@@ -146,24 +93,6 @@ struct compat_sigaction {
 	compat_sigset_t			sa_mask __packed;
 };
 
-/*
- * These functions operate on 32- or 64-bit specs depending on
- * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments.
- */
-extern int compat_get_timespec(struct timespec *, const void __user *);
-extern int compat_put_timespec(const struct timespec *, void __user *);
-extern int compat_get_timeval(struct timeval *, const void __user *);
-extern int compat_put_timeval(const struct timeval *, void __user *);
-
-/*
- * This function convert a timespec if necessary and returns a *user
- * space* pointer.  If no conversion is necessary, it returns the
- * initial pointer.  NULL is a legitimate argument and will always
- * output NULL.
- */
-extern int compat_convert_timespec(struct timespec __user **,
-				   const void __user *);
-
 struct compat_iovec {
 	compat_uptr_t	iov_base;
 	compat_size_t	iov_len;
@@ -174,28 +103,6 @@ struct compat_rlimit {
 	compat_ulong_t	rlim_max;
 };
 
-struct compat_rusage {
-	struct compat_timeval ru_utime;
-	struct compat_timeval ru_stime;
-	compat_long_t	ru_maxrss;
-	compat_long_t	ru_ixrss;
-	compat_long_t	ru_idrss;
-	compat_long_t	ru_isrss;
-	compat_long_t	ru_minflt;
-	compat_long_t	ru_majflt;
-	compat_long_t	ru_nswap;
-	compat_long_t	ru_inblock;
-	compat_long_t	ru_oublock;
-	compat_long_t	ru_msgsnd;
-	compat_long_t	ru_msgrcv;
-	compat_long_t	ru_nsignals;
-	compat_long_t	ru_nvcsw;
-	compat_long_t	ru_nivcsw;
-};
-
-extern int put_compat_rusage(const struct rusage *,
-			     struct compat_rusage __user *);
-
 struct compat_siginfo;
 
 extern asmlinkage long compat_sys_waitid(int, compat_pid_t,
@@ -324,8 +231,6 @@ asmlinkage long compat_sys_msgrcv(int msqid, compat_uptr_t msgp,
 		compat_ssize_t msgsz, compat_long_t msgtyp, int msgflg);
 long compat_sys_msgctl(int first, int second, void __user *uptr);
 long compat_sys_shmctl(int first, int second, void __user *uptr);
-long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
-		unsigned nsems, const struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_keyctl(u32 option,
 			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
@@ -361,12 +266,6 @@ asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
 		     const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp, int flags);
 
-asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
-		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-		struct compat_timeval __user *tvp);
-
-asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg);
-
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
@@ -392,38 +291,6 @@ asmlinkage long compat_sys_sigaction(int sig,
                                    struct compat_old_sigaction __user *oact);
 #endif
 
-static inline int compat_timeval_compare(struct compat_timeval *lhs,
-					struct compat_timeval *rhs)
-{
-	if (lhs->tv_sec < rhs->tv_sec)
-		return -1;
-	if (lhs->tv_sec > rhs->tv_sec)
-		return 1;
-	return lhs->tv_usec - rhs->tv_usec;
-}
-
-static inline int compat_timespec_compare(struct compat_timespec *lhs,
-					struct compat_timespec *rhs)
-{
-	if (lhs->tv_sec < rhs->tv_sec)
-		return -1;
-	if (lhs->tv_sec > rhs->tv_sec)
-		return 1;
-	return lhs->tv_nsec - rhs->tv_nsec;
-}
-
-extern int get_compat_itimerspec(struct itimerspec *dst,
-				 const struct compat_itimerspec __user *src);
-extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
-				 const struct itimerspec *src);
-
-asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
-		struct timezone __user *tz);
-asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
-		struct timezone __user *tz);
-
-asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
-
 extern void sigset_from_compat(sigset_t *set, const compat_sigset_t *compat);
 extern void sigset_to_compat(compat_sigset_t *compat, const sigset_t *set);
 
@@ -451,48 +318,20 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
-asmlinkage long compat_sys_utime(const char __user *filename,
-				 struct compat_utimbuf __user *t);
-asmlinkage long compat_sys_utimensat(unsigned int dfd,
-				     const char __user *filename,
-				     struct compat_timespec __user *t,
-				     int flags);
-
-asmlinkage long compat_sys_time(compat_time_t __user *tloc);
-asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
 asmlinkage long compat_sys_signalfd(int ufd,
 				    const compat_sigset_t __user *sigmask,
 				    compat_size_t sigsetsize);
-asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
-				   const struct compat_itimerspec __user *utmr,
-				   struct compat_itimerspec __user *otmr);
-asmlinkage long compat_sys_timerfd_gettime(int ufd,
-				   struct compat_itimerspec __user *otmr);
-
 asmlinkage long compat_sys_move_pages(pid_t pid, compat_ulong_t nr_pages,
 				      __u32 __user *pages,
 				      const int __user *nodes,
 				      int __user *status,
 				      int flags);
-asmlinkage long compat_sys_futimesat(unsigned int dfd,
-				     const char __user *filename,
-				     struct compat_timeval __user *t);
-asmlinkage long compat_sys_utimes(const char __user *filename,
-				  struct compat_timeval __user *t);
-asmlinkage long compat_sys_newstat(const char __user *filename,
-				   struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newlstat(const char __user *filename,
-				    struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newfstatat(unsigned int dfd,
-				      const char __user *filename,
-				      struct compat_stat __user *statbuf,
-				      int flag);
-asmlinkage long compat_sys_newfstat(unsigned int fd,
-				    struct compat_stat __user *statbuf);
+struct compat_statfs;
 asmlinkage long compat_sys_statfs(const char __user *pathname,
 				  struct compat_statfs __user *buf);
 asmlinkage long compat_sys_fstatfs(unsigned int fd,
 				   struct compat_statfs __user *buf);
+struct compat_statfs64;
 asmlinkage long compat_sys_statfs64(const char __user *pathname,
 				    compat_size_t sz,
 				    struct compat_statfs64 __user *buf);
@@ -503,11 +342,6 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
 				 compat_ulong_t arg);
 asmlinkage long compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p);
-asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
-					compat_long_t min_nr,
-					compat_long_t nr,
-					struct io_event __user *events,
-					struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
 asmlinkage long compat_sys_mount(const char __user *dev_name,
@@ -536,16 +370,6 @@ asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
 					     int flags);
 asmlinkage long compat_sys_truncate(const char __user *, compat_off_t);
 asmlinkage long compat_sys_ftruncate(unsigned int, compat_ulong_t);
-asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
-				    compat_ulong_t __user *outp,
-				    compat_ulong_t __user *exp,
-				    struct compat_timespec __user *tsp,
-				    void __user *sig);
-asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
-				 unsigned int nfds,
-				 struct compat_timespec __user *tsp,
-				 const compat_sigset_t __user *sigmask,
-				 compat_size_t sigsetsize);
 asmlinkage long compat_sys_signalfd4(int ufd,
 				     const compat_sigset_t __user *sigmask,
 				     compat_size_t sigsetsize, int flags);
@@ -574,16 +398,6 @@ asmlinkage long compat_sys_recv(int fd, void __user *buf, compat_size_t len,
 asmlinkage long compat_sys_recvfrom(int fd, void __user *buf, compat_size_t len,
 			    unsigned flags, struct sockaddr __user *addr,
 			    int __user *addrlen);
-asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
-				    unsigned vlen, unsigned int flags,
-				    struct compat_timespec __user *timeout);
-asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
-				     struct compat_timespec __user *rmtp);
-asmlinkage long compat_sys_getitimer(int which,
-				     struct compat_itimerval __user *it);
-asmlinkage long compat_sys_setitimer(int which,
-				     struct compat_itimerval __user *in,
-				     struct compat_itimerval __user *out);
 asmlinkage long compat_sys_times(struct compat_tms __user *tbuf);
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 				     struct compat_rlimit __user *rlim);
@@ -599,25 +413,6 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid,
 asmlinkage long compat_sys_timer_create(clockid_t which_clock,
 			struct compat_sigevent __user *timer_event_spec,
 			timer_t __user *created_timer_id);
-asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
-					 struct compat_itimerspec __user *new,
-					 struct compat_itimerspec __user *old);
-asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
-				 struct compat_itimerspec __user *setting);
-asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
-					 struct compat_timespec __user *tp);
-asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
-					 struct compat_timespec __user *tp);
-asmlinkage long compat_sys_clock_adjtime(clockid_t which_clock,
-					 struct compat_timex __user *tp);
-asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
-					struct compat_timespec __user *tp);
-asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
-					   struct compat_timespec __user *rqtp,
-					   struct compat_timespec __user *rmtp);
-asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
-		struct compat_siginfo __user *uinfo,
-		struct compat_timespec __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset,
 					 compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigprocmask(int how, compat_sigset_t __user *set,
@@ -636,9 +431,6 @@ asmlinkage long compat_sys_rt_sigqueueinfo(compat_pid_t pid, int sig,
 asmlinkage long compat_sys_sysinfo(struct compat_sysinfo __user *info);
 asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 				 compat_ulong_t arg);
-asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
-		struct compat_timespec __user *utime, u32 __user *uaddr2,
-		u32 val3);
 asmlinkage long compat_sys_getsockopt(int fd, int level, int optname,
 				      char __user *optval, int __user *optlen);
 asmlinkage long compat_sys_kexec_load(compat_ulong_t entry,
@@ -653,14 +445,6 @@ asmlinkage long compat_sys_mq_notify(mqd_t mqdes,
 asmlinkage long compat_sys_mq_open(const char __user *u_name,
 			int oflag, compat_mode_t mode,
 			struct compat_mq_attr __user *u_attr);
-asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
-			const char __user *u_msg_ptr,
-			compat_size_t msg_len, unsigned int msg_prio,
-			const struct compat_timespec __user *u_abs_timeout);
-asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
-			char __user *u_msg_ptr,
-			compat_size_t msg_len, unsigned int __user *u_msg_prio,
-			const struct compat_timespec __user *u_abs_timeout);
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
@@ -707,9 +491,6 @@ int __compat_save_altstack(compat_stack_t __user *, unsigned long);
 	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
 } while (0);
 
-asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-						 struct compat_timespec __user *interval);
-
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
 #else
diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
new file mode 100644
index 000000000000..37564582f6a5
--- /dev/null
+++ b/include/linux/compat_time.h
@@ -0,0 +1,255 @@
+#ifndef _LINUX_COMPAT_TIME_H
+#define _LINUX_COMPAT_TIME_H
+/*
+ * These are the type definitions for the architecture specific
+ * syscall compatibility layer for 32-bit time_t.
+ *
+ * The emulation is used both on 32-bit architectures that have
+ * been converted to 64-bit __kernel_time_t as well as on 64-bit
+ * architectures with 32-bit user space.
+ */
+#include <linux/resource.h>
+#include <linux/signal.h>
+
+#ifndef COMPAT_USE_64BIT_TIME
+#define COMPAT_USE_64BIT_TIME 0
+#endif
+
+typedef s32	compat_int_t;
+typedef u32	compat_uint_t;
+typedef s32	compat_long_t;
+typedef u32	compat_ulong_t;
+typedef u32	compat_size_t;
+typedef s32	compat_ssize_t;
+typedef s32	compat_time_t;
+typedef	u32	compat_aio_context_t;
+typedef u32	compat_uptr_t;
+typedef __kernel_pid_t compat_pid_t;
+
+struct compat_timespec {
+	compat_time_t	tv_sec;
+	s32		tv_nsec;
+};
+
+struct compat_timeval {
+	compat_time_t	tv_sec;
+	s32		tv_usec;
+};
+
+struct compat_itimerspec {
+	struct compat_timespec it_interval;
+	struct compat_timespec it_value;
+};
+
+struct compat_utimbuf {
+	compat_time_t		actime;
+	compat_time_t		modtime;
+};
+
+struct compat_itimerval {
+	struct compat_timeval	it_interval;
+	struct compat_timeval	it_value;
+};
+
+struct compat_timex {
+	compat_uint_t modes;
+	compat_long_t offset;
+	compat_long_t freq;
+	compat_long_t maxerror;
+	compat_long_t esterror;
+	compat_int_t status;
+	compat_long_t constant;
+	compat_long_t precision;
+	compat_long_t tolerance;
+	struct compat_timeval time;
+	compat_long_t tick;
+	compat_long_t ppsfreq;
+	compat_long_t jitter;
+	compat_int_t shift;
+	compat_long_t stabil;
+	compat_long_t jitcnt;
+	compat_long_t calcnt;
+	compat_long_t errcnt;
+	compat_long_t stbcnt;
+	compat_int_t tai;
+
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32;
+};
+
+
+/*
+ * These functions operate on 32- or 64-bit specs depending on
+ * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments.
+ */
+extern int compat_get_timespec(struct timespec *, const void __user *);
+extern int compat_put_timespec(const struct timespec *, void __user *);
+extern int compat_get_timeval(struct timeval *, const void __user *);
+extern int compat_put_timeval(const struct timeval *, void __user *);
+
+/*
+ * This function convert a timespec if necessary and returns a *user
+ * space* pointer.  If no conversion is necessary, it returns the
+ * initial pointer.  NULL is a legitimate argument and will always
+ * output NULL.
+ */
+extern int compat_convert_timespec(struct timespec __user **,
+				   const void __user *);
+
+struct compat_rusage {
+	struct compat_timeval ru_utime;
+	struct compat_timeval ru_stime;
+	compat_long_t	ru_maxrss;
+	compat_long_t	ru_ixrss;
+	compat_long_t	ru_idrss;
+	compat_long_t	ru_isrss;
+	compat_long_t	ru_minflt;
+	compat_long_t	ru_majflt;
+	compat_long_t	ru_nswap;
+	compat_long_t	ru_inblock;
+	compat_long_t	ru_oublock;
+	compat_long_t	ru_msgsnd;
+	compat_long_t	ru_msgrcv;
+	compat_long_t	ru_nsignals;
+	compat_long_t	ru_nvcsw;
+	compat_long_t	ru_nivcsw;
+};
+
+struct rusage;
+extern int put_compat_rusage(const struct rusage *,
+			     struct compat_rusage __user *);
+
+static inline int compat_timeval_compare(struct compat_timeval *lhs,
+					struct compat_timeval *rhs)
+{
+	if (lhs->tv_sec < rhs->tv_sec)
+		return -1;
+	if (lhs->tv_sec > rhs->tv_sec)
+		return 1;
+	return lhs->tv_usec - rhs->tv_usec;
+}
+
+static inline int compat_timespec_compare(struct compat_timespec *lhs,
+					struct compat_timespec *rhs)
+{
+	if (lhs->tv_sec < rhs->tv_sec)
+		return -1;
+	if (lhs->tv_sec > rhs->tv_sec)
+		return 1;
+	return lhs->tv_nsec - rhs->tv_nsec;
+}
+
+extern int get_compat_itimerspec(struct itimerspec *dst,
+				 const struct compat_itimerspec __user *src);
+extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
+				 const struct itimerspec *src);
+
+struct sembuf;
+asmlinkage long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
+		unsigned nsems, const struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
+		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
+		struct compat_timeval __user *tvp);
+struct compat_sel_arg_struct;
+asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg);
+asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
+				    compat_ulong_t __user *outp,
+				    compat_ulong_t __user *exp,
+				    struct compat_timespec __user *tsp,
+				    void __user *sig);
+asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+		struct timezone __user *tz);
+
+asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
+
+asmlinkage long compat_sys_utime(const char __user *filename,
+				 struct compat_utimbuf __user *t);
+asmlinkage long compat_sys_utimensat(unsigned int dfd,
+				     const char __user *filename,
+				     struct compat_timespec __user *t,
+				     int flags);
+
+asmlinkage long compat_sys_time(compat_time_t __user *tloc);
+asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
+
+asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
+				   const struct compat_itimerspec __user *utmr,
+				   struct compat_itimerspec __user *otmr);
+asmlinkage long compat_sys_timerfd_gettime(int ufd,
+				   struct compat_itimerspec __user *otmr);
+
+asmlinkage long compat_sys_futimesat(unsigned int dfd,
+				     const char __user *filename,
+				     struct compat_timeval __user *t);
+asmlinkage long compat_sys_utimes(const char __user *filename,
+				  struct compat_timeval __user *t);
+struct compat_stat;
+asmlinkage long compat_sys_newstat(const char __user *filename,
+				   struct compat_stat __user *statbuf);
+asmlinkage long compat_sys_newlstat(const char __user *filename,
+				    struct compat_stat __user *statbuf);
+asmlinkage long compat_sys_newfstatat(unsigned int dfd,
+				      const char __user *filename,
+				      struct compat_stat __user *statbuf,
+				      int flag);
+asmlinkage long compat_sys_newfstat(unsigned int fd,
+				    struct compat_stat __user *statbuf);
+struct io_event;
+asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
+					compat_long_t min_nr,
+					compat_long_t nr,
+					struct io_event __user *events,
+					struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
+				 unsigned int nfds,
+				 struct compat_timespec __user *tsp,
+				 const compat_sigset_t __user *sigmask,
+				 compat_size_t sigsetsize);
+struct compat_mmsghdr;
+asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags,
+				    struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
+				     struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_getitimer(int which,
+				     struct compat_itimerval __user *it);
+asmlinkage long compat_sys_setitimer(int which,
+				     struct compat_itimerval __user *in,
+				     struct compat_itimerval __user *out);
+asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
+					 struct compat_itimerspec __user *new,
+					 struct compat_itimerspec __user *old);
+asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
+				 struct compat_itimerspec __user *setting);
+asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
+					 struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_adjtime(clockid_t which_clock,
+					 struct compat_timex __user *tp);
+asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
+					struct compat_timespec __user *tp);
+asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
+					   struct compat_timespec __user *rqtp,
+					   struct compat_timespec __user *rmtp);
+struct compat_siginfo;
+asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
+		struct compat_siginfo __user *uinfo,
+		struct compat_timespec __user *uts, compat_size_t sigsetsize);
+asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
+		struct compat_timespec __user *utime, u32 __user *uaddr2,
+		u32 val3);
+asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
+			const char __user *u_msg_ptr,
+			compat_size_t msg_len, unsigned int msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
+			char __user *u_msg_ptr,
+			compat_size_t msg_len, unsigned int __user *u_msg_prio,
+			const struct compat_timespec __user *u_abs_timeout);
+asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						 struct compat_timespec __user *interval);
+#endif
-- 
2.1.0.rc2
