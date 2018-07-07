From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v3 7/7] timex: change syscalls to use struct __kernel_timex
Date: Fri,  6 Jul 2018 22:42:47 -0700
Message-ID: <20180707054247.19802-8-deepa.kernel@gmail.com>
References: <20180707054247.19802-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180707054247.19802-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

struct timex is not y2038 safe.
Switch all the syscall apis to use y2038 safe __kernel_timex.

Note that sys_adjtimex() does not have a y2038 safe solution.
The api is meant to be deprecated on 32 bit machines after y2038.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-api@vger.kernel.org
---
 include/linux/syscalls.h   |  5 ++---
 kernel/time/posix-timers.c | 10 +---------
 kernel/time/time.c         |  9 +++++++--
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3ee3b3f1302f..54688c7b4dae 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,7 +54,6 @@ struct __sysctl_args;
 struct sysinfo;
 struct timespec;
 struct timeval;
-struct timex;
 struct timezone;
 struct tms;
 struct utimbuf;
@@ -677,7 +676,7 @@ asmlinkage long sys_gettimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
 asmlinkage long sys_settimeofday(struct timeval __user *tv,
 				struct timezone __user *tz);
-asmlinkage long sys_adjtimex(struct timex __user *txc_p);
+asmlinkage long sys_adjtimex(struct __kernel_timex __user *txc_p);
 
 /* kernel/timer.c */
 asmlinkage long sys_getpid(void);
@@ -846,7 +845,7 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
 				      struct file_handle __user *handle,
 				      int flags);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
-				struct timex __user *tx);
+				struct __kernel_timex __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index a2595cb0cb16..1b485422f9f3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1084,7 +1084,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 }
 
 SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
-		struct timex __user *, utx)
+		struct __kernel_timex __user *, utx)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct __kernel_timex ktx;
@@ -1159,10 +1159,6 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 	return err;
 }
 
-#endif
-
-#ifdef CONFIG_COMPAT
-
 COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
 		       struct compat_timex __user *, utp)
 {
@@ -1187,10 +1183,6 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
 	return err;
 }
 
-#endif
-
-#ifdef CONFIG_COMPAT_32BIT_TIME
-
 COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
 		       struct compat_timespec __user *, tp)
 {
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 2c5afb008b14..a374fdbb368b 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -263,7 +263,10 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct compat_timeval __user *, tv,
 }
 #endif
 
-SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
+
+#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+
+SYSCALL_DEFINE1(adjtimex, struct __kernel_timex __user *, txc_p)
 {
 	struct __kernel_timex txc;		/* Local copy of parameter */
 	int ret;
@@ -278,7 +281,9 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	return copy_to_user(txc_p, &txc, sizeof(struct __kernel_timex)) ? -EFAULT : ret;
 }
 
-#ifdef CONFIG_COMPAT
+#endif
+
+#ifdef CONFIG_COMPAT_32BIT_TIME
 
 COMPAT_SYSCALL_DEFINE1(adjtimex, struct compat_timex __user *, utp)
 {
-- 
2.17.1
