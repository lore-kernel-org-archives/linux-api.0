From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 3/3] time: Change types to new y2038 safe __kernel_itimerspec
Date: Sat, 16 Jun 2018 22:11:44 -0700
Message-ID: <20180617051144.29756-4-deepa.kernel@gmail.com>
References: <20180617051144.29756-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180617051144.29756-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-api@vger.kernel.org

timer_set/gettime and timerfd_set/get apis use struct itimerspec at the
user interface layer.  struct itimerspec is not y2038-safe.
Change these interfaces to use y2038-safe struct __kernel_itimerspec
instead.  This will help define new syscalls when architectures select
CONFIG_64BIT_TIME.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/timerfd.c               |  8 ++++----
 include/linux/syscalls.h   | 10 +++++-----
 kernel/time/posix-timers.c | 12 +++++++-----
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index d84a2bee4f82..8bb926253f88 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -533,8 +533,8 @@ static int do_timerfd_gettime(int ufd, struct itimerspec64 *t)
 }
 
 SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
-		const struct itimerspec __user *, utmr,
-		struct itimerspec __user *, otmr)
+		const struct __kernel_itimerspec __user *, utmr,
+		struct __kernel_itimerspec __user *, otmr)
 {
 	struct itimerspec64 new, old;
 	int ret;
@@ -550,7 +550,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	return ret;
 }
 
-SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
+SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct __kernel_itimerspec __user *, otmr)
 {
 	struct itimerspec64 kotmr;
 	int ret = do_timerfd_gettime(ufd, &kotmr);
@@ -559,7 +559,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 	return put_itimerspec64(&kotmr, otmr) ? -EFAULT : 0;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 		const struct compat_itimerspec __user *, utmr,
 		struct compat_itimerspec __user *, otmr)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 73810808cdf2..38b9ec152024 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -501,9 +501,9 @@ asmlinkage long sys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 /* fs/timerfd.c */
 asmlinkage long sys_timerfd_create(int clockid, int flags);
 asmlinkage long sys_timerfd_settime(int ufd, int flags,
-				    const struct itimerspec __user *utmr,
-				    struct itimerspec __user *otmr);
-asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
+				    const struct __kernel_itimerspec __user *utmr,
+				    struct __kernel_itimerspec __user *otmr);
+asmlinkage long sys_timerfd_gettime(int ufd, struct __kernel_itimerspec __user *otmr);
 
 /* fs/utimes.c */
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
@@ -568,10 +568,10 @@ asmlinkage long sys_timer_create(clockid_t which_clock,
 				 struct sigevent __user *timer_event_spec,
 				 timer_t __user * created_timer_id);
 asmlinkage long sys_timer_gettime(timer_t timer_id,
-				struct itimerspec __user *setting);
+				struct __kernel_itimerspec __user *setting);
 asmlinkage long sys_timer_getoverrun(timer_t timer_id);
 asmlinkage long sys_timer_settime(timer_t timer_id, int flags,
-				const struct itimerspec __user *new_setting,
+				const struct __kernel_itimerspec __user *new_setting,
 				struct itimerspec __user *old_setting);
 asmlinkage long sys_timer_delete(timer_t timer_id);
 asmlinkage long sys_clock_settime(clockid_t which_clock,
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index e08ce3f27447..bc35603cf2a9 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -743,7 +743,7 @@ static int do_timer_gettime(timer_t timer_id,  struct itimerspec64 *setting)
 
 /* Get the time remaining on a POSIX.1b interval timer. */
 SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
-		struct itimerspec __user *, setting)
+		struct __kernel_itimerspec __user *, setting)
 {
 	struct itimerspec64 cur_setting;
 
@@ -755,7 +755,8 @@ SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
+
 COMPAT_SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 		       struct compat_itimerspec __user *, setting)
 {
@@ -768,6 +769,7 @@ COMPAT_SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 	}
 	return ret;
 }
+
 #endif
 
 /*
@@ -906,8 +908,8 @@ static int do_timer_settime(timer_t timer_id, int flags,
 
 /* Set a POSIX.1b interval timer */
 SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
-		const struct itimerspec __user *, new_setting,
-		struct itimerspec __user *, old_setting)
+		const struct __kernel_itimerspec __user *, new_setting,
+		struct __kernel_itimerspec __user *, old_setting)
 {
 	struct itimerspec64 new_spec, old_spec;
 	struct itimerspec64 *rtn = old_setting ? &old_spec : NULL;
@@ -927,7 +929,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 	return error;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 		       struct compat_itimerspec __user *, new,
 		       struct compat_itimerspec __user *, old)
-- 
2.17.1
