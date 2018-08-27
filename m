From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/14] y2038: Globally rename compat_time to old_time32
Date: Mon, 27 Aug 2018 21:45:20 +0200
Message-ID: <20180827194531.3796559-4-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Christoph Hellwig suggested a slightly different path for handling
backwards compatibility with the 32-bit time_t based system calls:

Rather than simply reusing the compat_sys_* entry points on 32-bit
architectures unchanged, we get rid of those entry points and the
compat_time types by renaming them to something that makes more sense
on 32-bit architectures (which don't have a compat mode otherwise),
and then share the entry points under the new name with the 64-bit
architectures that use them for implementing the compatibility.

The following types and interfaces are renamed here, and moved
from linux/compat_time.h to linux/time32.h:

old				new
---				---
compat_time_t			old_time32_t
struct compat_timeval		struct old_timeval32
struct compat_timespec		struct old_timespec32
struct compat_itimerspec	struct old_itimerspec32
ns_to_compat_timeval()		ns_to_old_timeval32()
get_compat_itimerspec64()	get_old_itimerspec32()
put_compat_itimerspec64()	put_old_itimerspec32()
compat_get_timespec64()		get_old_timespec32()
compat_put_timespec64()		put_old_timespec32()

As we already have aliases in place, this patch addresses only the
instances that are relevant to the system call interface in particular,
not those that occur in device drivers and other modules. Those
will get handled separately, while providing the 64-bit version
of the respective interfaces.

I'm not renaming the timex, rusage and itimerval structures, as we are
still debating what the new interface will look like, and whether we
will need a replacement at all.

This also doesn't change the names of the syscall entry points, which can
be done more easily when we actually switch over the 32-bit architectures
to use them, at that point we need to change COMPAT_SYSCALL_DEFINEx to
SYSCALL_DEFINEx with a new name, e.g. with a _time32 suffix.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lore.kernel.org/lkml/20180705222110.GA5698@infradead.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/compat.h   |  6 +-
 arch/arm64/include/asm/stat.h     |  2 +-
 arch/mips/include/asm/compat.h    |  6 +-
 arch/mips/kernel/binfmt_elfn32.c  | 14 ++---
 arch/mips/kernel/binfmt_elfo32.c  | 14 ++---
 arch/parisc/include/asm/compat.h  |  6 +-
 arch/powerpc/include/asm/compat.h |  6 +-
 arch/powerpc/kernel/asm-offsets.c |  8 +--
 arch/powerpc/oprofile/backtrace.c |  2 +-
 arch/sparc/include/asm/compat.h   |  6 +-
 fs/aio.c                          |  8 +--
 fs/compat_binfmt_elf.c            |  2 +-
 fs/select.c                       | 20 +++----
 fs/timerfd.c                      | 12 ++--
 fs/utimes.c                       | 12 ++--
 include/linux/compat.h            | 96 +++++++++++++++----------------
 include/linux/compat_time.h       | 32 -----------
 include/linux/elfcore-compat.h    |  8 +--
 include/linux/restart_block.h     |  4 +-
 include/linux/syscalls.h          |  2 +-
 include/linux/time32.h            | 48 ++++++++++++----
 ipc/mqueue.c                      |  8 +--
 ipc/msg.c                         |  6 +-
 ipc/sem.c                         | 10 ++--
 ipc/shm.c                         |  6 +-
 ipc/syscall.c                     |  2 +-
 ipc/util.h                        |  2 +-
 kernel/compat.c                   |  8 +--
 kernel/futex_compat.c             |  2 +-
 kernel/sched/core.c               |  4 +-
 kernel/signal.c                   |  2 +-
 kernel/time/hrtimer.c             |  8 +--
 kernel/time/posix-stubs.c         | 18 +++---
 kernel/time/posix-timers.c        | 30 +++++-----
 kernel/time/time.c                | 58 +++++++++----------
 net/compat.c                      |  4 +-
 36 files changed, 237 insertions(+), 245 deletions(-)
 delete mode 100644 include/linux/compat_time.h

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 1a037b94eba1..4a89007db14a 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -86,11 +86,11 @@ struct compat_stat {
 	compat_off_t	st_size;
 	compat_off_t	st_blksize;
 	compat_off_t	st_blocks;
-	compat_time_t	st_atime;
+	old_time32_t	st_atime;
 	compat_ulong_t	st_atime_nsec;
-	compat_time_t	st_mtime;
+	old_time32_t	st_mtime;
 	compat_ulong_t	st_mtime_nsec;
-	compat_time_t	st_ctime;
+	old_time32_t	st_ctime;
 	compat_ulong_t	st_ctime_nsec;
 	compat_ulong_t	__unused4[2];
 };
diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
index eab738019707..397c6ccd04e7 100644
--- a/arch/arm64/include/asm/stat.h
+++ b/arch/arm64/include/asm/stat.h
@@ -20,7 +20,7 @@
 
 #ifdef CONFIG_COMPAT
 
-#include <linux/compat_time.h>
+#include <linux/time.h>
 #include <asm/compat.h>
 
 /*
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index 78675f19440f..7dcbd855814e 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -59,11 +59,11 @@ struct compat_stat {
 	s32		st_pad2[2];
 	compat_off_t	st_size;
 	s32		st_pad3;
-	compat_time_t	st_atime;
+	old_time32_t	st_atime;
 	s32		st_atime_nsec;
-	compat_time_t	st_mtime;
+	old_time32_t	st_mtime;
 	s32		st_mtime_nsec;
-	compat_time_t	st_ctime;
+	old_time32_t	st_ctime;
 	s32		st_ctime_nsec;
 	s32		st_blksize;
 	s32		st_blocks;
diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 89b234844534..7a12763d553a 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -54,10 +54,10 @@ struct elf_prstatus32
 	pid_t	pr_ppid;
 	pid_t	pr_pgrp;
 	pid_t	pr_sid;
-	struct compat_timeval pr_utime; /* User time */
-	struct compat_timeval pr_stime; /* System time */
-	struct compat_timeval pr_cutime;/* Cumulative user time */
-	struct compat_timeval pr_cstime;/* Cumulative system time */
+	struct old_timeval32 pr_utime; /* User time */
+	struct old_timeval32 pr_stime; /* System time */
+	struct old_timeval32 pr_cutime;/* Cumulative user time */
+	struct old_timeval32 pr_cstime;/* Cumulative system time */
 	elf_gregset_t pr_reg;	/* GP registers */
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
@@ -81,9 +81,9 @@ struct elf_prpsinfo32
 #define elf_caddr_t	u32
 #define init_elf_binfmt init_elfn32_binfmt
 
-#define jiffies_to_timeval jiffies_to_compat_timeval
+#define jiffies_to_timeval jiffies_to_old_timeval32
 static __inline__ void
-jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
+jiffies_to_old_timeval32(unsigned long jiffies, struct old_timeval32 *value)
 {
 	/*
 	 * Convert jiffies to nanoseconds and separate with
@@ -101,6 +101,6 @@ jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 #define TASK_SIZE TASK_SIZE32
 
 #undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#define ns_to_timeval ns_to_old_timeval32
 
 #include "../../../fs/binfmt_elf.c"
diff --git a/arch/mips/kernel/binfmt_elfo32.c b/arch/mips/kernel/binfmt_elfo32.c
index a88c59db3d48..e6db06a1d31a 100644
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -59,10 +59,10 @@ struct elf_prstatus32
 	pid_t	pr_ppid;
 	pid_t	pr_pgrp;
 	pid_t	pr_sid;
-	struct compat_timeval pr_utime; /* User time */
-	struct compat_timeval pr_stime; /* System time */
-	struct compat_timeval pr_cutime;/* Cumulative user time */
-	struct compat_timeval pr_cstime;/* Cumulative system time */
+	struct old_timeval32 pr_utime; /* User time */
+	struct old_timeval32 pr_stime; /* System time */
+	struct old_timeval32 pr_cutime;/* Cumulative user time */
+	struct old_timeval32 pr_cstime;/* Cumulative system time */
 	elf_gregset_t pr_reg;	/* GP registers */
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
@@ -86,9 +86,9 @@ struct elf_prpsinfo32
 #define elf_caddr_t	u32
 #define init_elf_binfmt init_elf32_binfmt
 
-#define jiffies_to_timeval jiffies_to_compat_timeval
+#define jiffies_to_timeval jiffies_to_old_timeval32
 static inline void
-jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
+jiffies_to_old_timeval32(unsigned long jiffies, struct old_timeval32 *value)
 {
 	/*
 	 * Convert jiffies to nanoseconds and separate with
@@ -104,6 +104,6 @@ jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 #define TASK_SIZE TASK_SIZE32
 
 #undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#define ns_to_timeval ns_to_old_timeval32
 
 #include "../../../fs/binfmt_elf.c"
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index ab8a54771507..32dadaf2b534 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -48,11 +48,11 @@ struct compat_stat {
 	u16			st_reserved2;	/* old st_gid */
 	compat_dev_t		st_rdev;
 	compat_off_t		st_size;
-	compat_time_t		st_atime;
+	old_time32_t		st_atime;
 	u32			st_atime_nsec;
-	compat_time_t		st_mtime;
+	old_time32_t		st_mtime;
 	u32			st_mtime_nsec;
-	compat_time_t		st_ctime;
+	old_time32_t		st_ctime;
 	u32			st_ctime_nsec;
 	s32			st_blksize;
 	s32			st_blocks;
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 85c8af2bb272..93f79d1a03c3 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -55,11 +55,11 @@ struct compat_stat {
 	compat_off_t	st_size;
 	compat_off_t	st_blksize;
 	compat_off_t	st_blocks;
-	compat_time_t	st_atime;
+	old_time32_t	st_atime;
 	u32		st_atime_nsec;
-	compat_time_t	st_mtime;
+	old_time32_t	st_mtime;
 	u32		st_mtime_nsec;
-	compat_time_t	st_ctime;
+	old_time32_t	st_ctime;
 	u32		st_ctime_nsec;
 	u32		__unused4[2];
 };
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 89cf15566c4e..041a115789a1 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -387,12 +387,12 @@ int main(void)
 	OFFSET(CFG_SYSCALL_MAP64, vdso_data, syscall_map_64);
 	OFFSET(TVAL64_TV_SEC, timeval, tv_sec);
 	OFFSET(TVAL64_TV_USEC, timeval, tv_usec);
-	OFFSET(TVAL32_TV_SEC, compat_timeval, tv_sec);
-	OFFSET(TVAL32_TV_USEC, compat_timeval, tv_usec);
+	OFFSET(TVAL32_TV_SEC, old_timeval32, tv_sec);
+	OFFSET(TVAL32_TV_USEC, old_timeval32, tv_usec);
 	OFFSET(TSPC64_TV_SEC, timespec, tv_sec);
 	OFFSET(TSPC64_TV_NSEC, timespec, tv_nsec);
-	OFFSET(TSPC32_TV_SEC, compat_timespec, tv_sec);
-	OFFSET(TSPC32_TV_NSEC, compat_timespec, tv_nsec);
+	OFFSET(TSPC32_TV_SEC, old_timespec32, tv_sec);
+	OFFSET(TSPC32_TV_NSEC, old_timespec32, tv_nsec);
 #else
 	OFFSET(TVAL32_TV_SEC, timeval, tv_sec);
 	OFFSET(TVAL32_TV_USEC, timeval, tv_usec);
diff --git a/arch/powerpc/oprofile/backtrace.c b/arch/powerpc/oprofile/backtrace.c
index ad054dd0d666..5df6290d1ccc 100644
--- a/arch/powerpc/oprofile/backtrace.c
+++ b/arch/powerpc/oprofile/backtrace.c
@@ -7,7 +7,7 @@
  * 2 of the License, or (at your option) any later version.
 **/
 
-#include <linux/compat_time.h>
+#include <linux/time.h>
 #include <linux/oprofile.h>
 #include <linux/sched.h>
 #include <asm/processor.h>
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index 4eb51d2dae98..7018cb60beef 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -47,11 +47,11 @@ struct compat_stat {
 	__compat_gid_t	st_gid;
 	compat_dev_t	st_rdev;
 	compat_off_t	st_size;
-	compat_time_t	st_atime;
+	old_time32_t	st_atime;
 	compat_ulong_t	st_atime_nsec;
-	compat_time_t	st_mtime;
+	old_time32_t	st_mtime;
 	compat_ulong_t	st_mtime_nsec;
-	compat_time_t	st_ctime;
+	old_time32_t	st_ctime;
 	compat_ulong_t	st_ctime_nsec;
 	compat_off_t	st_blksize;
 	compat_off_t	st_blocks;
diff --git a/fs/aio.c b/fs/aio.c
index b9350f3360c6..301e6314183b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2135,12 +2135,12 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       compat_long_t, min_nr,
 		       compat_long_t, nr,
 		       struct io_event __user *, events,
-		       struct compat_timespec __user *, timeout)
+		       struct old_timespec32 __user *, timeout)
 {
 	struct timespec64 t;
 	int ret;
 
-	if (timeout && compat_get_timespec64(&t, timeout))
+	if (timeout && get_old_timespec32(&t, timeout))
 		return -EFAULT;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
@@ -2160,7 +2160,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		compat_long_t, min_nr,
 		compat_long_t, nr,
 		struct io_event __user *, events,
-		struct compat_timespec __user *, timeout,
+		struct old_timespec32 __user *, timeout,
 		const struct __compat_aio_sigset __user *, usig)
 {
 	struct __compat_aio_sigset ksig = { NULL, };
@@ -2168,7 +2168,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	struct timespec64 t;
 	int ret;
 
-	if (timeout && compat_get_timespec64(&t, timeout))
+	if (timeout && get_old_timespec32(&t, timeout))
 		return -EFAULT;
 
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 504b3c3539dc..15f6e96b3bd9 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -52,7 +52,7 @@
 #define elf_prpsinfo	compat_elf_prpsinfo
 
 #undef ns_to_timeval
-#define ns_to_timeval ns_to_compat_timeval
+#define ns_to_timeval ns_to_old_timeval32
 
 /*
  * To use this file, asm/elf.h must define compat_elf_check_arch.
diff --git a/fs/select.c b/fs/select.c
index 4a6b6e4b21cb..22b3bf89f051 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -1120,7 +1120,7 @@ int compat_poll_select_copy_remaining(struct timespec64 *end_time, void __user *
 		ts.tv_sec = ts.tv_nsec = 0;
 
 	if (timeval) {
-		struct compat_timeval rtv;
+		struct old_timeval32 rtv;
 
 		rtv.tv_sec = ts.tv_sec;
 		rtv.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
@@ -1128,7 +1128,7 @@ int compat_poll_select_copy_remaining(struct timespec64 *end_time, void __user *
 		if (!copy_to_user(p, &rtv, sizeof(rtv)))
 			return ret;
 	} else {
-		if (!compat_put_timespec64(&ts, p))
+		if (!put_old_timespec32(&ts, p))
 			return ret;
 	}
 	/*
@@ -1257,10 +1257,10 @@ static int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 
 static int do_compat_select(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timeval __user *tvp)
+	struct old_timeval32 __user *tvp)
 {
 	struct timespec64 end_time, *to = NULL;
-	struct compat_timeval tv;
+	struct old_timeval32 tv;
 	int ret;
 
 	if (tvp) {
@@ -1282,7 +1282,7 @@ static int do_compat_select(int n, compat_ulong_t __user *inp,
 
 COMPAT_SYSCALL_DEFINE5(select, int, n, compat_ulong_t __user *, inp,
 	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
-	struct compat_timeval __user *, tvp)
+	struct old_timeval32 __user *, tvp)
 {
 	return do_compat_select(n, inp, outp, exp, tvp);
 }
@@ -1307,7 +1307,7 @@ COMPAT_SYSCALL_DEFINE1(old_select, struct compat_sel_arg_struct __user *, arg)
 
 static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timespec __user *tsp, compat_sigset_t __user *sigmask,
+	struct old_timespec32 __user *tsp, compat_sigset_t __user *sigmask,
 	compat_size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
@@ -1315,7 +1315,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	int ret;
 
 	if (tsp) {
-		if (compat_get_timespec64(&ts, tsp))
+		if (get_old_timespec32(&ts, tsp))
 			return -EFAULT;
 
 		to = &end_time;
@@ -1355,7 +1355,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 
 COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
-	struct compat_timespec __user *, tsp, void __user *, sig)
+	struct old_timespec32 __user *, tsp, void __user *, sig)
 {
 	compat_size_t sigsetsize = 0;
 	compat_uptr_t up = 0;
@@ -1373,7 +1373,7 @@ COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 }
 
 COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
-	unsigned int,  nfds, struct compat_timespec __user *, tsp,
+	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
@@ -1381,7 +1381,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 	int ret;
 
 	if (tsp) {
-		if (compat_get_timespec64(&ts, tsp))
+		if (get_old_timespec32(&ts, tsp))
 			return -EFAULT;
 
 		to = &end_time;
diff --git a/fs/timerfd.c b/fs/timerfd.c
index d69ad801eb80..803ca070d42e 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -561,29 +561,29 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct __kernel_itimerspec __user *,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
-		const struct compat_itimerspec __user *, utmr,
-		struct compat_itimerspec __user *, otmr)
+		const struct old_itimerspec32 __user *, utmr,
+		struct old_itimerspec32 __user *, otmr)
 {
 	struct itimerspec64 new, old;
 	int ret;
 
-	if (get_compat_itimerspec64(&new, utmr))
+	if (get_old_itimerspec32(&new, utmr))
 		return -EFAULT;
 	ret = do_timerfd_settime(ufd, flags, &new, &old);
 	if (ret)
 		return ret;
-	if (otmr && put_compat_itimerspec64(&old, otmr))
+	if (otmr && put_old_itimerspec32(&old, otmr))
 		return -EFAULT;
 	return ret;
 }
 
 COMPAT_SYSCALL_DEFINE2(timerfd_gettime, int, ufd,
-		struct compat_itimerspec __user *, otmr)
+		struct old_itimerspec32 __user *, otmr)
 {
 	struct itimerspec64 kotmr;
 	int ret = do_timerfd_gettime(ufd, &kotmr);
 	if (ret)
 		return ret;
-	return put_compat_itimerspec64(&kotmr, otmr) ? -EFAULT : 0;
+	return put_old_itimerspec32(&kotmr, otmr) ? -EFAULT : 0;
 }
 #endif
diff --git a/fs/utimes.c b/fs/utimes.c
index 69d4b6ba1bfb..79a65c163f40 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -245,13 +245,13 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
 
-COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct compat_timespec __user *, t, int, flags)
+COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
 {
 	struct timespec64 tv[2];
 
 	if  (t) {
-		if (compat_get_timespec64(&tv[0], &t[0]) ||
-		    compat_get_timespec64(&tv[1], &t[1]))
+		if (get_old_timespec32(&tv[0], &t[0]) ||
+		    get_old_timespec32(&tv[1], &t[1]))
 			return -EFAULT;
 
 		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
@@ -261,7 +261,7 @@ COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filena
 }
 
 static long do_compat_futimesat(unsigned int dfd, const char __user *filename,
-				struct compat_timeval __user *t)
+				struct old_timeval32 __user *t)
 {
 	struct timespec64 tv[2];
 
@@ -282,12 +282,12 @@ static long do_compat_futimesat(unsigned int dfd, const char __user *filename,
 
 COMPAT_SYSCALL_DEFINE3(futimesat, unsigned int, dfd,
 		       const char __user *, filename,
-		       struct compat_timeval __user *, t)
+		       struct old_timeval32 __user *, t)
 {
 	return do_compat_futimesat(dfd, filename, t);
 }
 
-COMPAT_SYSCALL_DEFINE2(utimes, const char __user *, filename, struct compat_timeval __user *, t)
+COMPAT_SYSCALL_DEFINE2(utimes, const char __user *, filename, struct old_timeval32 __user *, t)
 {
 	return do_compat_futimesat(AT_FDCWD, filename, t);
 }
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 1a3c4f37e908..0e058792ecf6 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -7,7 +7,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/compat_time.h>
+#include <linux/time.h>
 
 #include <linux/stat.h>
 #include <linux/param.h>	/* for HZ */
@@ -116,13 +116,13 @@ struct compat_sel_arg_struct;
 struct rusage;
 
 struct compat_utimbuf {
-	compat_time_t		actime;
-	compat_time_t		modtime;
+	old_time32_t		actime;
+	old_time32_t		modtime;
 };
 
 struct compat_itimerval {
-	struct compat_timeval	it_interval;
-	struct compat_timeval	it_value;
+	struct old_timeval32	it_interval;
+	struct old_timeval32	it_value;
 };
 
 struct itimerval;
@@ -146,7 +146,7 @@ struct compat_timex {
 	compat_long_t constant;
 	compat_long_t precision;
 	compat_long_t tolerance;
-	struct compat_timeval time;
+	struct old_timeval32 time;
 	compat_long_t tick;
 	compat_long_t ppsfreq;
 	compat_long_t jitter;
@@ -307,8 +307,8 @@ struct compat_rlimit {
 };
 
 struct compat_rusage {
-	struct compat_timeval ru_utime;
-	struct compat_timeval ru_stime;
+	struct old_timeval32 ru_utime;
+	struct old_timeval32 ru_stime;
 	compat_long_t	ru_maxrss;
 	compat_long_t	ru_ixrss;
 	compat_long_t	ru_idrss;
@@ -457,8 +457,8 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *to, const siginfo_t *fr
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
 
-static inline int compat_timeval_compare(struct compat_timeval *lhs,
-					struct compat_timeval *rhs)
+static inline int old_timeval32_compare(struct old_timeval32 *lhs,
+					struct old_timeval32 *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
@@ -467,8 +467,8 @@ static inline int compat_timeval_compare(struct compat_timeval *lhs,
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
-static inline int compat_timespec_compare(struct compat_timespec *lhs,
-					struct compat_timespec *rhs)
+static inline int old_timespec32_compare(struct old_timespec32 *lhs,
+					struct old_timespec32 *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
@@ -552,12 +552,12 @@ asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
 					compat_long_t min_nr,
 					compat_long_t nr,
 					struct io_event __user *events,
-					struct compat_timespec __user *timeout);
+					struct old_timespec32 __user *timeout);
 asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
 					compat_long_t min_nr,
 					compat_long_t nr,
 					struct io_event __user *events,
-					struct compat_timespec __user *timeout,
+					struct old_timespec32 __user *timeout,
 					const struct __compat_aio_sigset __user *usig);
 
 /* fs/cookies.c */
@@ -642,11 +642,11 @@ asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
 asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *outp,
 				    compat_ulong_t __user *exp,
-				    struct compat_timespec __user *tsp,
+				    struct old_timespec32 __user *tsp,
 				    void __user *sig);
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 unsigned int nfds,
-				 struct compat_timespec __user *tsp,
+				 struct old_timespec32 __user *tsp,
 				 const compat_sigset_t __user *sigmask,
 				 compat_size_t sigsetsize);
 
@@ -671,15 +671,15 @@ asmlinkage long compat_sys_newfstat(unsigned int fd,
 
 /* fs/timerfd.c */
 asmlinkage long compat_sys_timerfd_gettime(int ufd,
-				   struct compat_itimerspec __user *otmr);
+				   struct old_itimerspec32 __user *otmr);
 asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
-				   const struct compat_itimerspec __user *utmr,
-				   struct compat_itimerspec __user *otmr);
+				   const struct old_itimerspec32 __user *utmr,
+				   struct old_itimerspec32 __user *otmr);
 
 /* fs/utimes.c */
 asmlinkage long compat_sys_utimensat(unsigned int dfd,
 				     const char __user *filename,
-				     struct compat_timespec __user *t,
+				     struct old_timespec32 __user *t,
 				     int flags);
 
 /* kernel/exit.c */
@@ -691,7 +691,7 @@ asmlinkage long compat_sys_waitid(int, compat_pid_t,
 
 /* kernel/futex.c */
 asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
-		struct compat_timespec __user *utime, u32 __user *uaddr2,
+		struct old_timespec32 __user *utime, u32 __user *uaddr2,
 		u32 val3);
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
@@ -701,8 +701,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
 /* kernel/hrtimer.c */
-asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
-				     struct compat_timespec __user *rmtp);
+asmlinkage long compat_sys_nanosleep(struct old_timespec32 __user *rqtp,
+				     struct old_timespec32 __user *rmtp);
 
 /* kernel/itimer.c */
 asmlinkage long compat_sys_getitimer(int which,
@@ -722,19 +722,19 @@ asmlinkage long compat_sys_timer_create(clockid_t which_clock,
 			struct compat_sigevent __user *timer_event_spec,
 			timer_t __user *created_timer_id);
 asmlinkage long compat_sys_timer_gettime(timer_t timer_id,
-				 struct compat_itimerspec __user *setting);
+				 struct old_itimerspec32 __user *setting);
 asmlinkage long compat_sys_timer_settime(timer_t timer_id, int flags,
-					 struct compat_itimerspec __user *new,
-					 struct compat_itimerspec __user *old);
+					 struct old_itimerspec32 __user *new,
+					 struct old_itimerspec32 __user *old);
 asmlinkage long compat_sys_clock_settime(clockid_t which_clock,
-					 struct compat_timespec __user *tp);
+					 struct old_timespec32 __user *tp);
 asmlinkage long compat_sys_clock_gettime(clockid_t which_clock,
-					 struct compat_timespec __user *tp);
+					 struct old_timespec32 __user *tp);
 asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
-					struct compat_timespec __user *tp);
+					struct old_timespec32 __user *tp);
 asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
-					   struct compat_timespec __user *rqtp,
-					   struct compat_timespec __user *rmtp);
+					   struct old_timespec32 __user *rqtp,
+					   struct old_timespec32 __user *rmtp);
 
 /* kernel/ptrace.c */
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
@@ -748,7 +748,7 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid,
 				     unsigned int len,
 				     compat_ulong_t __user *user_mask_ptr);
 asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-						 struct compat_timespec __user *interval);
+						 struct old_timespec32 __user *interval);
 
 /* kernel/signal.c */
 asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
@@ -768,7 +768,7 @@ asmlinkage long compat_sys_rt_sigpending(compat_sigset_t __user *uset,
 					 compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
-		struct compat_timespec __user *uts, compat_size_t sigsetsize);
+		struct old_timespec32 __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigqueueinfo(compat_pid_t pid, int sig,
 				struct compat_siginfo __user *uinfo);
 /* No generic prototype for rt_sigreturn */
@@ -782,9 +782,9 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru);
 
 /* kernel/time.c */
-asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
+asmlinkage long compat_sys_gettimeofday(struct old_timeval32 __user *tv,
 		struct timezone __user *tz);
-asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
+asmlinkage long compat_sys_settimeofday(struct old_timeval32 __user *tv,
 		struct timezone __user *tz);
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
@@ -798,11 +798,11 @@ asmlinkage long compat_sys_mq_open(const char __user *u_name,
 asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
 			const char __user *u_msg_ptr,
 			compat_size_t msg_len, unsigned int msg_prio,
-			const struct compat_timespec __user *u_abs_timeout);
+			const struct old_timespec32 __user *u_abs_timeout);
 asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
 			char __user *u_msg_ptr,
 			compat_size_t msg_len, unsigned int __user *u_msg_prio,
-			const struct compat_timespec __user *u_abs_timeout);
+			const struct old_timespec32 __user *u_abs_timeout);
 asmlinkage long compat_sys_mq_notify(mqd_t mqdes,
 			const struct compat_sigevent __user *u_notification);
 asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
@@ -819,7 +819,7 @@ asmlinkage long compat_sys_msgsnd(int msqid, compat_uptr_t msgp,
 /* ipc/sem.c */
 asmlinkage long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
 asmlinkage long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
-		unsigned nsems, const struct compat_timespec __user *timeout);
+		unsigned nsems, const struct old_timespec32 __user *timeout);
 
 /* ipc/shm.c */
 asmlinkage long compat_sys_shmctl(int first, int second, void __user *uptr);
@@ -876,7 +876,7 @@ asmlinkage long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid,
 					struct compat_siginfo __user *uinfo);
 asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags,
-				    struct compat_timespec __user *timeout);
+				    struct old_timespec32 __user *timeout);
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
@@ -928,7 +928,7 @@ asmlinkage long compat_sys_pwritev64v2(unsigned long fd,
 asmlinkage long compat_sys_open(const char __user *filename, int flags,
 				umode_t mode);
 asmlinkage long compat_sys_utimes(const char __user *filename,
-				  struct compat_timeval __user *t);
+				  struct old_timeval32 __user *t);
 
 /* __ARCH_WANT_SYSCALL_NO_FLAGS */
 asmlinkage long compat_sys_signalfd(int ufd,
@@ -942,15 +942,15 @@ asmlinkage long compat_sys_newlstat(const char __user *filename,
 				    struct compat_stat __user *statbuf);
 
 /* __ARCH_WANT_SYSCALL_DEPRECATED */
-asmlinkage long compat_sys_time(compat_time_t __user *tloc);
+asmlinkage long compat_sys_time(old_time32_t __user *tloc);
 asmlinkage long compat_sys_utime(const char __user *filename,
 				 struct compat_utimbuf __user *t);
 asmlinkage long compat_sys_futimesat(unsigned int dfd,
 				     const char __user *filename,
-				     struct compat_timeval __user *t);
+				     struct old_timeval32 __user *t);
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-		struct compat_timeval __user *tvp);
+		struct old_timeval32 __user *tvp);
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
 asmlinkage long compat_sys_recv(int fd, void __user *buf, compat_size_t len,
 				unsigned flags);
@@ -983,7 +983,7 @@ asmlinkage long compat_sys_sigaction(int sig,
 #endif
 
 /* obsolete: kernel/time/time.c */
-asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
+asmlinkage long compat_sys_stime(old_time32_t __user *tptr);
 
 /* obsolete: net/socket.c */
 asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
@@ -1002,15 +1002,15 @@ static inline bool in_compat_syscall(void) { return is_compat_task(); }
 #endif
 
 /**
- * ns_to_compat_timeval - Compat version of ns_to_timeval
+ * ns_to_old_timeval32 - Compat version of ns_to_timeval
  * @nsec:	the nanoseconds value to be converted
  *
- * Returns the compat_timeval representation of the nsec parameter.
+ * Returns the old_timeval32 representation of the nsec parameter.
  */
-static inline struct compat_timeval ns_to_compat_timeval(s64 nsec)
+static inline struct old_timeval32 ns_to_old_timeval32(s64 nsec)
 {
 	struct timeval tv;
-	struct compat_timeval ctv;
+	struct old_timeval32 ctv;
 
 	tv = ns_to_timeval(nsec);
 	ctv.tv_sec = tv.tv_sec;
diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
deleted file mode 100644
index e70bfd1d2c3f..000000000000
--- a/include/linux/compat_time.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_COMPAT_TIME_H
-#define _LINUX_COMPAT_TIME_H
-
-#include <linux/types.h>
-#include <linux/time64.h>
-
-typedef s32		compat_time_t;
-
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
-struct compat_itimerspec {
-	struct compat_timespec it_interval;
-	struct compat_timespec it_value;
-};
-
-extern int compat_get_timespec64(struct timespec64 *, const void __user *);
-extern int compat_put_timespec64(const struct timespec64 *, void __user *);
-extern int get_compat_itimerspec64(struct itimerspec64 *its,
-			const struct compat_itimerspec __user *uits);
-extern int put_compat_itimerspec64(const struct itimerspec64 *its,
-			struct compat_itimerspec __user *uits);
-
-#endif /* _LINUX_COMPAT_TIME_H */
diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
index b5f2efdd05e0..7a37f4ce9fd2 100644
--- a/include/linux/elfcore-compat.h
+++ b/include/linux/elfcore-compat.h
@@ -27,10 +27,10 @@ struct compat_elf_prstatus
 	compat_pid_t			pr_ppid;
 	compat_pid_t			pr_pgrp;
 	compat_pid_t			pr_sid;
-	struct compat_timeval		pr_utime;
-	struct compat_timeval		pr_stime;
-	struct compat_timeval		pr_cutime;
-	struct compat_timeval		pr_cstime;
+	struct old_timeval32		pr_utime;
+	struct old_timeval32		pr_stime;
+	struct old_timeval32		pr_cutime;
+	struct old_timeval32		pr_cstime;
 	compat_elf_gregset_t		pr_reg;
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 	compat_ulong_t			pr_exec_fdpic_loadmap;
diff --git a/include/linux/restart_block.h b/include/linux/restart_block.h
index 5d83d0c1d06c..bba2920e9c05 100644
--- a/include/linux/restart_block.h
+++ b/include/linux/restart_block.h
@@ -10,7 +10,7 @@
 #include <linux/time64.h>
 
 struct timespec;
-struct compat_timespec;
+struct old_timespec32;
 struct pollfd;
 
 enum timespec_type {
@@ -40,7 +40,7 @@ struct restart_block {
 			enum timespec_type type;
 			union {
 				struct __kernel_timespec __user *rmtp;
-				struct compat_timespec __user *compat_rmtp;
+				struct old_timespec32 __user *compat_rmtp;
 			};
 			u64 expires;
 		} nanosleep;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2ff814c92f7f..b3e27e5ee322 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -60,7 +60,7 @@ struct tms;
 struct utimbuf;
 struct mq_attr;
 struct compat_stat;
-struct compat_timeval;
+struct old_timeval32;
 struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
diff --git a/include/linux/time32.h b/include/linux/time32.h
index 92c0ca092d93..0e0d7304d1a8 100644
--- a/include/linux/time32.h
+++ b/include/linux/time32.h
@@ -13,6 +13,31 @@
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
+typedef s32		old_time32_t;
+
+struct old_timespec32 {
+	old_time32_t	tv_sec;
+	s32		tv_nsec;
+};
+
+struct old_timeval32 {
+	old_time32_t	tv_sec;
+	s32		tv_usec;
+};
+
+struct old_itimerspec32 {
+	struct old_timespec32 it_interval;
+	struct old_timespec32 it_value;
+};
+
+extern int get_old_timespec32(struct timespec64 *, const void __user *);
+extern int put_old_timespec32(const struct timespec64 *, void __user *);
+extern int get_old_itimerspec32(struct itimerspec64 *its,
+			const struct old_itimerspec32 __user *uits);
+extern int put_old_itimerspec32(const struct itimerspec64 *its,
+			struct old_itimerspec32 __user *uits);
+
+
 #if __BITS_PER_LONG == 64
 
 /* timespec64 is defined as timespec here */
@@ -183,18 +208,17 @@ extern struct timeval ns_to_timeval(const s64 nsec);
 extern struct __kernel_old_timeval ns_to_kernel_old_timeval(s64 nsec);
 
 /*
- * New aliases for compat time functions. These will be used to replace
- * the compat code so it can be shared between 32-bit and 64-bit builds
- * both of which provide compatibility with old 32-bit tasks.
+ * Old names for the 32-bit time_t interfaces, these will be removed
+ * when everything uses the new names.
  */
-#define old_time32_t		compat_time_t
-#define old_timeval32		compat_timeval
-#define old_timespec32		compat_timespec
-#define old_itimerspec32	compat_itimerspec
-#define ns_to_old_timeval32	ns_to_compat_timeval
-#define get_old_itimerspec32	get_compat_itimerspec64
-#define put_old_itimerspec32	put_compat_itimerspec64
-#define get_old_timespec32	compat_get_timespec64
-#define put_old_timespec32	compat_put_timespec64
+#define compat_time_t		old_time32_t
+#define compat_timeval		old_timeval32
+#define compat_timespec		old_timespec32
+#define compat_itimerspec	old_itimerspec32
+#define ns_to_compat_timeval	ns_to_old_timeval32
+#define get_compat_itimerspec64	get_old_itimerspec32
+#define put_compat_itimerspec64	put_old_itimerspec32
+#define compat_get_timespec64	get_old_timespec32
+#define compat_put_timespec64	put_old_timespec32
 
 #endif
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c0d58f390c3b..db7833370351 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1461,10 +1461,10 @@ COMPAT_SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
 #endif
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
-static int compat_prepare_timeout(const struct compat_timespec __user *p,
+static int compat_prepare_timeout(const struct old_timespec32 __user *p,
 				   struct timespec64 *ts)
 {
-	if (compat_get_timespec64(ts, p))
+	if (get_old_timespec32(ts, p))
 		return -EFAULT;
 	if (!timespec64_valid(ts))
 		return -EINVAL;
@@ -1474,7 +1474,7 @@ static int compat_prepare_timeout(const struct compat_timespec __user *p,
 COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
 		       const char __user *, u_msg_ptr,
 		       compat_size_t, msg_len, unsigned int, msg_prio,
-		       const struct compat_timespec __user *, u_abs_timeout)
+		       const struct old_timespec32 __user *, u_abs_timeout)
 {
 	struct timespec64 ts, *p = NULL;
 	if (u_abs_timeout) {
@@ -1489,7 +1489,7 @@ COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
 COMPAT_SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes,
 		       char __user *, u_msg_ptr,
 		       compat_size_t, msg_len, unsigned int __user *, u_msg_prio,
-		       const struct compat_timespec __user *, u_abs_timeout)
+		       const struct old_timespec32 __user *, u_abs_timeout)
 {
 	struct timespec64 ts, *p = NULL;
 	if (u_abs_timeout) {
diff --git a/ipc/msg.c b/ipc/msg.c
index 883642cf2b27..0833c6405915 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -622,9 +622,9 @@ struct compat_msqid_ds {
 	struct compat_ipc_perm msg_perm;
 	compat_uptr_t msg_first;
 	compat_uptr_t msg_last;
-	compat_time_t msg_stime;
-	compat_time_t msg_rtime;
-	compat_time_t msg_ctime;
+	old_time32_t msg_stime;
+	old_time32_t msg_rtime;
+	old_time32_t msg_ctime;
 	compat_ulong_t msg_lcbytes;
 	compat_ulong_t msg_lqbytes;
 	unsigned short msg_cbytes;
diff --git a/ipc/sem.c b/ipc/sem.c
index 26f8e37fcdcb..745dc6187e84 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1698,8 +1698,8 @@ SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
 
 struct compat_semid_ds {
 	struct compat_ipc_perm sem_perm;
-	compat_time_t sem_otime;
-	compat_time_t sem_ctime;
+	old_time32_t sem_otime;
+	old_time32_t sem_ctime;
 	compat_uptr_t sem_base;
 	compat_uptr_t sem_pending;
 	compat_uptr_t sem_pending_last;
@@ -2214,11 +2214,11 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 #ifdef CONFIG_COMPAT_32BIT_TIME
 long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 			    unsigned int nsops,
-			    const struct compat_timespec __user *timeout)
+			    const struct old_timespec32 __user *timeout)
 {
 	if (timeout) {
 		struct timespec64 ts;
-		if (compat_get_timespec64(&ts, timeout))
+		if (get_old_timespec32(&ts, timeout))
 			return -EFAULT;
 		return do_semtimedop(semid, tsems, nsops, &ts);
 	}
@@ -2227,7 +2227,7 @@ long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 
 COMPAT_SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsems,
 		       unsigned int, nsops,
-		       const struct compat_timespec __user *, timeout)
+		       const struct old_timespec32 __user *, timeout)
 {
 	return compat_ksys_semtimedop(semid, tsems, nsops, timeout);
 }
diff --git a/ipc/shm.c b/ipc/shm.c
index b0eb3757ab89..2657692199eb 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1201,9 +1201,9 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 struct compat_shmid_ds {
 	struct compat_ipc_perm shm_perm;
 	int shm_segsz;
-	compat_time_t shm_atime;
-	compat_time_t shm_dtime;
-	compat_time_t shm_ctime;
+	old_time32_t shm_atime;
+	old_time32_t shm_dtime;
+	old_time32_t shm_ctime;
 	compat_ipc_pid_t shm_cpid;
 	compat_ipc_pid_t shm_lpid;
 	unsigned short shm_nattch;
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 65d405f1ba0c..1ac06e3983c0 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -35,7 +35,7 @@ SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
 			        (const struct __kernel_timespec __user *)fifth);
 		else if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
 			return compat_ksys_semtimedop(first, ptr, second,
-			        (const struct compat_timespec __user *)fifth);
+			        (const struct old_timespec32 __user *)fifth);
 		else
 			return -ENOSYS;
 
diff --git a/ipc/util.h b/ipc/util.h
index 0a159f69b3bb..1ee81bce25e9 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -266,7 +266,7 @@ long ksys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
 /* for CONFIG_ARCH_WANT_OLD_COMPAT_IPC */
 long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 			    unsigned int nsops,
-			    const struct compat_timespec __user *timeout);
+			    const struct old_timespec32 __user *timeout);
 #ifdef CONFIG_COMPAT
 long compat_ksys_semctl(int semid, int semnum, int cmd, int arg);
 long compat_ksys_msgctl(int msqid, int cmd, void __user *uptr);
diff --git a/kernel/compat.c b/kernel/compat.c
index 8e40efc2928a..089d00d0da9c 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -93,28 +93,28 @@ int compat_put_timex(struct compat_timex __user *utp, const struct timex *txc)
 	return 0;
 }
 
-static int __compat_get_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
+static int __compat_get_timeval(struct timeval *tv, const struct old_timeval32 __user *ctv)
 {
 	return (!access_ok(VERIFY_READ, ctv, sizeof(*ctv)) ||
 			__get_user(tv->tv_sec, &ctv->tv_sec) ||
 			__get_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
 }
 
-static int __compat_put_timeval(const struct timeval *tv, struct compat_timeval __user *ctv)
+static int __compat_put_timeval(const struct timeval *tv, struct old_timeval32 __user *ctv)
 {
 	return (!access_ok(VERIFY_WRITE, ctv, sizeof(*ctv)) ||
 			__put_user(tv->tv_sec, &ctv->tv_sec) ||
 			__put_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
 }
 
-static int __compat_get_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
+static int __compat_get_timespec(struct timespec *ts, const struct old_timespec32 __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
 			__get_user(ts->tv_sec, &cts->tv_sec) ||
 			__get_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
-static int __compat_put_timespec(const struct timespec *ts, struct compat_timespec __user *cts)
+static int __compat_put_timespec(const struct timespec *ts, struct old_timespec32 __user *cts)
 {
 	return (!access_ok(VERIFY_WRITE, cts, sizeof(*cts)) ||
 			__put_user(ts->tv_sec, &cts->tv_sec) ||
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83f830acbb5f..410a77a8f6e2 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -173,7 +173,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 }
 
 COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
-		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
+		struct old_timespec32 __user *, utime, u32 __user *, uaddr2,
 		u32, val3)
 {
 	struct timespec ts;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 625bc9897f62..8287b75ed961 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5257,13 +5257,13 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
-		       struct compat_timespec __user *, interval)
+		       struct old_timespec32 __user *, interval)
 {
 	struct timespec64 t;
 	int retval = sched_rr_get_interval(pid, &t);
 
 	if (retval == 0)
-		retval = compat_put_timespec64(&t, interval);
+		retval = put_old_timespec32(&t, interval);
 	return retval;
 }
 #endif
diff --git a/kernel/signal.c b/kernel/signal.c
index 5843c541fda9..a4db724e14c1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3173,7 +3173,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
-		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
+		struct old_timespec32 __user *, uts, compat_size_t, sigsetsize)
 {
 	sigset_t s;
 	struct timespec t;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index e1a549c9e399..9cdd74bd2d27 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1660,7 +1660,7 @@ int nanosleep_copyout(struct restart_block *restart, struct timespec64 *ts)
 	switch(restart->nanosleep.type) {
 #ifdef CONFIG_COMPAT_32BIT_TIME
 	case TT_COMPAT:
-		if (compat_put_timespec64(ts, restart->nanosleep.compat_rmtp))
+		if (put_old_timespec32(ts, restart->nanosleep.compat_rmtp))
 			return -EFAULT;
 		break;
 #endif
@@ -1780,12 +1780,12 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
-COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
-		       struct compat_timespec __user *, rmtp)
+COMPAT_SYSCALL_DEFINE2(nanosleep, struct old_timespec32 __user *, rqtp,
+		       struct old_timespec32 __user *, rmtp)
 {
 	struct timespec64 tu;
 
-	if (compat_get_timespec64(&tu, rqtp))
+	if (get_old_timespec32(&tu, rqtp))
 		return -EFAULT;
 
 	if (!timespec64_valid(&tu))
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 2c6847d5d69b..989ccf028bde 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -162,20 +162,20 @@ COMPAT_SYS_NI(setitimer);
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	struct timespec64 new_tp;
 
 	if (which_clock != CLOCK_REALTIME)
 		return -EINVAL;
-	if (compat_get_timespec64(&new_tp, tp))
+	if (get_old_timespec32(&new_tp, tp))
 		return -EFAULT;
 
 	return do_sys_settimeofday64(&new_tp, NULL);
 }
 
 COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	int ret;
 	struct timespec64 kernel_tp;
@@ -184,13 +184,13 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 	if (ret)
 		return ret;
 
-	if (compat_put_timespec64(&kernel_tp, tp))
+	if (put_old_timespec32(&kernel_tp, tp))
 		return -EFAULT;
 	return 0;
 }
 
 COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	struct timespec64 rtn_tp = {
 		.tv_sec = 0,
@@ -201,7 +201,7 @@ COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
-		if (compat_put_timespec64(&rtn_tp, tp))
+		if (put_old_timespec32(&rtn_tp, tp))
 			return -EFAULT;
 		return 0;
 	default:
@@ -210,8 +210,8 @@ COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
 }
 
 COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
-		       struct compat_timespec __user *, rqtp,
-		       struct compat_timespec __user *, rmtp)
+		       struct old_timespec32 __user *, rqtp,
+		       struct old_timespec32 __user *, rmtp)
 {
 	struct timespec64 t;
 
@@ -224,7 +224,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	}
 
-	if (compat_get_timespec64(&t, rqtp))
+	if (get_old_timespec32(&t, rqtp))
 		return -EFAULT;
 	if (!timespec64_valid(&t))
 		return -EINVAL;
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 4b9127e95430..3e71921668ba 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -755,13 +755,13 @@ SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
-		       struct compat_itimerspec __user *, setting)
+		       struct old_itimerspec32 __user *, setting)
 {
 	struct itimerspec64 cur_setting;
 
 	int ret = do_timer_gettime(timer_id, &cur_setting);
 	if (!ret) {
-		if (put_compat_itimerspec64(&cur_setting, setting))
+		if (put_old_itimerspec32(&cur_setting, setting))
 			ret = -EFAULT;
 	}
 	return ret;
@@ -928,8 +928,8 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 
 #ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
-		       struct compat_itimerspec __user *, new,
-		       struct compat_itimerspec __user *, old)
+		       struct old_itimerspec32 __user *, new,
+		       struct old_itimerspec32 __user *, old)
 {
 	struct itimerspec64 new_spec, old_spec;
 	struct itimerspec64 *rtn = old ? &old_spec : NULL;
@@ -937,12 +937,12 @@ COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 
 	if (!new)
 		return -EINVAL;
-	if (get_compat_itimerspec64(&new_spec, new))
+	if (get_old_itimerspec32(&new_spec, new))
 		return -EFAULT;
 
 	error = do_timer_settime(timer_id, flags, &new_spec, rtn);
 	if (!error && old) {
-		if (put_compat_itimerspec64(&old_spec, old))
+		if (put_old_itimerspec32(&old_spec, old))
 			error = -EFAULT;
 	}
 	return error;
@@ -1115,7 +1115,7 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE2(clock_settime, clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1123,14 +1123,14 @@ COMPAT_SYSCALL_DEFINE2(clock_settime, clockid_t, which_clock,
 	if (!kc || !kc->clock_set)
 		return -EINVAL;
 
-	if (compat_get_timespec64(&ts, tp))
+	if (get_old_timespec32(&ts, tp))
 		return -EFAULT;
 
 	return kc->clock_set(which_clock, &ts);
 }
 
 COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1141,7 +1141,7 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 
 	err = kc->clock_get(which_clock, &ts);
 
-	if (!err && compat_put_timespec64(&ts, tp))
+	if (!err && put_old_timespec32(&ts, tp))
 		err = -EFAULT;
 
 	return err;
@@ -1180,7 +1180,7 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
-		       struct compat_timespec __user *, tp)
+		       struct old_timespec32 __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 ts;
@@ -1190,7 +1190,7 @@ COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
 		return -EINVAL;
 
 	err = kc->clock_getres(which_clock, &ts);
-	if (!err && tp && compat_put_timespec64(&ts, tp))
+	if (!err && tp && put_old_timespec32(&ts, tp))
 		return -EFAULT;
 
 	return err;
@@ -1237,8 +1237,8 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
-		       struct compat_timespec __user *, rqtp,
-		       struct compat_timespec __user *, rmtp)
+		       struct old_timespec32 __user *, rqtp,
+		       struct old_timespec32 __user *, rmtp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 t;
@@ -1248,7 +1248,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 	if (!kc->nsleep)
 		return -EOPNOTSUPP;
 
-	if (compat_get_timespec64(&t, rqtp))
+	if (get_old_timespec32(&t, rqtp))
 		return -EFAULT;
 
 	if (!timespec64_valid(&t))
diff --git a/kernel/time/time.c b/kernel/time/time.c
index de332250d6fa..f1983f468fe3 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -104,12 +104,12 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 #ifdef CONFIG_COMPAT
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
-/* compat_time_t is a 32 bit "long" and needs to get converted. */
-COMPAT_SYSCALL_DEFINE1(time, compat_time_t __user *, tloc)
+/* old_time32_t is a 32 bit "long" and needs to get converted. */
+COMPAT_SYSCALL_DEFINE1(time, old_time32_t __user *, tloc)
 {
-	compat_time_t i;
+	old_time32_t i;
 
-	i = (compat_time_t)ktime_get_real_seconds();
+	i = (old_time32_t)ktime_get_real_seconds();
 
 	if (tloc) {
 		if (put_user(i,tloc))
@@ -119,7 +119,7 @@ COMPAT_SYSCALL_DEFINE1(time, compat_time_t __user *, tloc)
 	return i;
 }
 
-COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
+COMPAT_SYSCALL_DEFINE1(stime, old_time32_t __user *, tptr)
 {
 	struct timespec64 tv;
 	int err;
@@ -225,7 +225,7 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(gettimeofday, struct compat_timeval __user *, tv,
+COMPAT_SYSCALL_DEFINE2(gettimeofday, struct old_timeval32 __user *, tv,
 		       struct timezone __user *, tz)
 {
 	if (tv) {
@@ -244,7 +244,7 @@ COMPAT_SYSCALL_DEFINE2(gettimeofday, struct compat_timeval __user *, tv,
 	return 0;
 }
 
-COMPAT_SYSCALL_DEFINE2(settimeofday, struct compat_timeval __user *, tv,
+COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
 		       struct timezone __user *, tz)
 {
 	struct timespec64 new_ts;
@@ -863,10 +863,10 @@ int put_timespec64(const struct timespec64 *ts,
 }
 EXPORT_SYMBOL_GPL(put_timespec64);
 
-int __compat_get_timespec64(struct timespec64 *ts64,
-				   const struct compat_timespec __user *cts)
+int __get_old_timespec32(struct timespec64 *ts64,
+				   const struct old_timespec32 __user *cts)
 {
-	struct compat_timespec ts;
+	struct old_timespec32 ts;
 	int ret;
 
 	ret = copy_from_user(&ts, cts, sizeof(ts));
@@ -879,33 +879,33 @@ int __compat_get_timespec64(struct timespec64 *ts64,
 	return 0;
 }
 
-int __compat_put_timespec64(const struct timespec64 *ts64,
-				   struct compat_timespec __user *cts)
+int __put_old_timespec32(const struct timespec64 *ts64,
+				   struct old_timespec32 __user *cts)
 {
-	struct compat_timespec ts = {
+	struct old_timespec32 ts = {
 		.tv_sec = ts64->tv_sec,
 		.tv_nsec = ts64->tv_nsec
 	};
 	return copy_to_user(cts, &ts, sizeof(ts)) ? -EFAULT : 0;
 }
 
-int compat_get_timespec64(struct timespec64 *ts, const void __user *uts)
+int get_old_timespec32(struct timespec64 *ts, const void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_from_user(ts, uts, sizeof(*ts)) ? -EFAULT : 0;
 	else
-		return __compat_get_timespec64(ts, uts);
+		return __get_old_timespec32(ts, uts);
 }
-EXPORT_SYMBOL_GPL(compat_get_timespec64);
+EXPORT_SYMBOL_GPL(get_old_timespec32);
 
-int compat_put_timespec64(const struct timespec64 *ts, void __user *uts)
+int put_old_timespec32(const struct timespec64 *ts, void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_to_user(uts, ts, sizeof(*ts)) ? -EFAULT : 0;
 	else
-		return __compat_put_timespec64(ts, uts);
+		return __put_old_timespec32(ts, uts);
 }
-EXPORT_SYMBOL_GPL(compat_put_timespec64);
+EXPORT_SYMBOL_GPL(put_old_timespec32);
 
 int get_itimerspec64(struct itimerspec64 *it,
 			const struct __kernel_itimerspec __user *uit)
@@ -937,23 +937,23 @@ int put_itimerspec64(const struct itimerspec64 *it,
 }
 EXPORT_SYMBOL_GPL(put_itimerspec64);
 
-int get_compat_itimerspec64(struct itimerspec64 *its,
-			const struct compat_itimerspec __user *uits)
+int get_old_itimerspec32(struct itimerspec64 *its,
+			const struct old_itimerspec32 __user *uits)
 {
 
-	if (__compat_get_timespec64(&its->it_interval, &uits->it_interval) ||
-	    __compat_get_timespec64(&its->it_value, &uits->it_value))
+	if (__get_old_timespec32(&its->it_interval, &uits->it_interval) ||
+	    __get_old_timespec32(&its->it_value, &uits->it_value))
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(get_compat_itimerspec64);
+EXPORT_SYMBOL_GPL(get_old_itimerspec32);
 
-int put_compat_itimerspec64(const struct itimerspec64 *its,
-			struct compat_itimerspec __user *uits)
+int put_old_itimerspec32(const struct itimerspec64 *its,
+			struct old_itimerspec32 __user *uits)
 {
-	if (__compat_put_timespec64(&its->it_interval, &uits->it_interval) ||
-	    __compat_put_timespec64(&its->it_value, &uits->it_value))
+	if (__put_old_timespec32(&its->it_interval, &uits->it_interval) ||
+	    __put_old_timespec32(&its->it_value, &uits->it_value))
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(put_compat_itimerspec64);
+EXPORT_SYMBOL_GPL(put_old_itimerspec32);
diff --git a/net/compat.c b/net/compat.c
index 3b2105f6549d..2ef160876bc1 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -812,7 +812,7 @@ COMPAT_SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, buf, compat_size_t, len
 
 static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				 unsigned int vlen, unsigned int flags,
-				 struct compat_timespec __user *timeout)
+				 struct old_timespec32 __user *timeout)
 {
 	int datagrams;
 	struct timespec ktspec;
@@ -834,7 +834,7 @@ static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 
 COMPAT_SYSCALL_DEFINE5(recvmmsg, int, fd, struct compat_mmsghdr __user *, mmsg,
 		       unsigned int, vlen, unsigned int, flags,
-		       struct compat_timespec __user *, timeout)
+		       struct old_timespec32 __user *, timeout)
 {
 	return __compat_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
 }
-- 
2.18.0
