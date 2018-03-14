From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v5 09/10] change time types to new y2038 safe __kernel_* types
Date: Tue, 13 Mar 2018 21:03:32 -0700
Message-ID: <20180314040333.3291-10-deepa.kernel@gmail.com>
References: <20180314040333.3291-1-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180314040333.3291-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Change over clock_settime, clock_gettime and clock_getres
syscalls to use __kernel_timespec times. This will enable
changing over of these syscalls to use new y2038 safe syscalls
when the architectures define the CONFIG_64BIT_TIME.

Cc: linux-api@vger.kernel.org
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 include/linux/syscalls.h   | 6 +++---
 kernel/time/posix-stubs.c  | 6 +++---
 kernel/time/posix-timers.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a78186d826d7..7ac1bb9ea7da 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -309,13 +309,13 @@ asmlinkage long sys_timer_settime(timer_t timer_id, int flags,
 				struct itimerspec __user *old_setting);
 asmlinkage long sys_timer_delete(timer_t timer_id);
 asmlinkage long sys_clock_settime(clockid_t which_clock,
-				const struct timespec __user *tp);
+				const struct __kernel_timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
-				struct timespec __user *tp);
+				struct __kernel_timespec __user *tp);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
-				struct timespec __user *tp);
+				struct __kernel_timespec __user *tp);
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
 				const struct timespec __user *rqtp,
 				struct timespec __user *rmtp);
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 0645cfa93609..28c22f54d0f2 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -49,7 +49,7 @@ SYS_NI(alarm);
  */
 
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-		const struct timespec __user *, tp)
+		const struct __kernel_timespec __user *, tp)
 {
 	struct timespec64 new_tp;
 
@@ -80,7 +80,7 @@ int do_clock_gettime(clockid_t which_clock, struct timespec64 *tp)
 	return 0;
 }
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
-		struct timespec __user *, tp)
+		struct __kernel_timespec __user *, tp)
 {
 	int ret;
 	struct timespec64 kernel_tp;
@@ -94,7 +94,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return 0;
 }
 
-SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct timespec __user *, tp)
+SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct __kernel_timespec __user *, tp)
 {
 	struct timespec64 rtn_tp = {
 		.tv_sec = 0,
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 35b7b08f79f5..78e50b26a283 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1039,7 +1039,7 @@ void exit_itimers(struct signal_struct *sig)
 }
 
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-		const struct timespec __user *, tp)
+		const struct __kernel_timespec __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 new_tp;
@@ -1054,7 +1054,7 @@ SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
-		struct timespec __user *,tp)
+		struct __kernel_timespec __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 kernel_tp;
@@ -1095,7 +1095,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
 }
 
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
-		struct timespec __user *, tp)
+		struct __kernel_timespec __user *, tp)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec64 rtn_tp;
-- 
2.14.1
