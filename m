From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v5 10/10] nanosleep: change time types to safe __kernel_* types
Date: Tue, 13 Mar 2018 21:03:33 -0700
Message-ID: <20180314040333.3291-11-deepa.kernel@gmail.com>
References: <20180314040333.3291-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180314040333.3291-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change over clock_nanosleep syscalls to use y2038 safe
__kernel_timespec times. This will enable changing over
of these syscalls to use new y2038 safe syscalls when
the architectures define the CONFIG_64BIT_TIME.

Note that nanosleep syscall is deprecated and does not have a
plan for making it y2038 safe. But, the syscall should work as
before on 64 bit machines and on 32 bit machines, the syscall
works correctly until y2038 as before using the existing compat
syscall version. There is no new syscall for supporting 64 bit
time_t on 32 bit architectures.

Cc: linux-api@vger.kernel.org
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 include/linux/restart_block.h | 7 ++-----
 include/linux/syscalls.h      | 6 +++---
 kernel/time/hrtimer.c         | 8 ++++++--
 kernel/time/posix-stubs.c     | 4 ++--
 kernel/time/posix-timers.c    | 4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/restart_block.h b/include/linux/restart_block.h
index bcfdb918cd81..5d83d0c1d06c 100644
--- a/include/linux/restart_block.h
+++ b/include/linux/restart_block.h
@@ -7,6 +7,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/time64.h>
 
 struct timespec;
 struct compat_timespec;
@@ -15,9 +16,7 @@ struct pollfd;
 enum timespec_type {
 	TT_NONE		= 0,
 	TT_NATIVE	= 1,
-#ifdef CONFIG_COMPAT
 	TT_COMPAT	= 2,
-#endif
 };
 
 /*
@@ -40,10 +39,8 @@ struct restart_block {
 			clockid_t clockid;
 			enum timespec_type type;
 			union {
-				struct timespec __user *rmtp;
-#ifdef CONFIG_COMPAT
+				struct __kernel_timespec __user *rmtp;
 				struct compat_timespec __user *compat_rmtp;
-#endif
 			};
 			u64 expires;
 		} nanosleep;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7ac1bb9ea7da..4df16a70b0d7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -254,7 +254,7 @@ asmlinkage long sys_adjtimex(struct timex __user *txc_p);
 asmlinkage long sys_times(struct tms __user *tbuf);
 
 asmlinkage long sys_gettid(void);
-asmlinkage long sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp);
+asmlinkage long sys_nanosleep(struct __kernel_timespec __user *rqtp, struct __kernel_timespec __user *rmtp);
 asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpid(void);
 asmlinkage long sys_getppid(void);
@@ -317,8 +317,8 @@ asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 asmlinkage long sys_clock_getres(clockid_t which_clock,
 				struct __kernel_timespec __user *tp);
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
-				const struct timespec __user *rqtp,
-				struct timespec __user *rmtp);
+				const struct __kernel_timespec __user *rqtp,
+				struct __kernel_timespec __user *rmtp);
 
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 6528dec955b8..10190de38be3 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1710,8 +1710,10 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
 	return ret;
 }
 
-SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
-		struct timespec __user *, rmtp)
+#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+
+SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
+		struct __kernel_timespec __user *, rmtp)
 {
 	struct timespec64 tu;
 
@@ -1726,6 +1728,8 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
+#endif
+
 #ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 28c22f54d0f2..f7e7a05e651d 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -114,8 +114,8 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct __kernel_time
 }
 
 SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
-		const struct timespec __user *, rqtp,
-		struct timespec __user *, rmtp)
+		const struct __kernel_timespec __user *, rqtp,
+		struct __kernel_timespec __user *, rmtp)
 {
 	struct timespec64 t;
 
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 78e50b26a283..851886b38da6 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1210,8 +1210,8 @@ static int common_nsleep(const clockid_t which_clock, int flags,
 }
 
 SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
-		const struct timespec __user *, rqtp,
-		struct timespec __user *, rmtp)
+		const struct __kernel_timespec __user *, rqtp,
+		struct __kernel_timespec __user *, rmtp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 t;
-- 
2.14.1
