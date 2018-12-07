From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/5] y2038: futex: Add support for __kernel_timespec
Date: Fri,  7 Dec 2018 22:18:05 +0100
Message-ID: <20181207211808.328719-3-arnd@arndb.de>
References: <20181207211808.328719-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207211808.328719-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This prepares sys_futex for y2038 safe calling: the native
syscall is changed to receive a __kernel_timespec argument, which
will be switched to 64-bit time_t in the future. All the internal
time handling gets changed to timespec64, and the compat_sys_futex
entry point is moved under the CONFIG_COMPAT_32BIT_TIME check
to provide compatibility for existing 32-bit architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  2 +-
 kernel/futex.c           | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a27cf407de92..247ad9eca955 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -553,7 +553,7 @@ asmlinkage long sys_unshare(unsigned long unshare_flags);
 
 /* kernel/futex.c */
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
-			struct timespec __user *utime, u32 __user *uaddr2,
+			struct __kernel_timespec __user *utime, u32 __user *uaddr2,
 			u32 val3);
 asmlinkage long sys_get_robust_list(int pid,
 				    struct robust_list_head __user * __user *head_ptr,
diff --git a/kernel/futex.c b/kernel/futex.c
index 5cc7c3b098e9..b305beaab739 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3558,10 +3558,10 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 
 
 SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
-		struct timespec __user *, utime, u32 __user *, uaddr2,
+		struct __kernel_timespec __user *, utime, u32 __user *, uaddr2,
 		u32, val3)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	ktime_t t, *tp = NULL;
 	u32 val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
@@ -3571,12 +3571,12 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (unlikely(should_fail_futex(!(op & FUTEX_PRIVATE_FLAG))))
 			return -EFAULT;
-		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
+		if (get_timespec64(&ts, utime))
 			return -EFAULT;
-		if (!timespec_valid(&ts))
+		if (!timespec64_valid(&ts))
 			return -EINVAL;
 
-		t = timespec_to_ktime(ts);
+		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
@@ -3747,12 +3747,14 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 
 	return ret;
 }
+#endif /* CONFIG_COMPAT */
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		struct old_timespec32 __user *, utime, u32 __user *, uaddr2,
 		u32, val3)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	ktime_t t, *tp = NULL;
 	int val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
@@ -3760,12 +3762,12 @@ COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
-		if (compat_get_timespec(&ts, utime))
+		if (get_old_timespec32(&ts, utime))
 			return -EFAULT;
-		if (!timespec_valid(&ts))
+		if (!timespec64_valid(&ts))
 			return -EINVAL;
 
-		t = timespec_to_ktime(ts);
+		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
@@ -3776,7 +3778,7 @@ COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_COMPAT_32BIT_TIME */
 
 static void __init futex_detect_cmpxchg(void)
 {
-- 
2.18.0
