From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/17] y2038: futex: Add support for __kernel_timespec
Date: Wed, 25 Apr 2018 18:03:04 +0200
Message-ID: <20180425160311.2718314-11-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
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
index d2b19e814218..c3d504dbba9c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -528,7 +528,7 @@ asmlinkage long sys_unshare(unsigned long unshare_flags);
 
 /* kernel/futex.c */
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
-			struct timespec __user *utime, u32 __user *uaddr2,
+			struct __kernel_timespec __user *utime, u32 __user *uaddr2,
 			u32 val3);
 asmlinkage long sys_get_robust_list(int pid,
 				    struct robust_list_head __user * __user *head_ptr,
diff --git a/kernel/futex.c b/kernel/futex.c
index e9013d1e65a1..129555a3b64d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3556,10 +3556,10 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 
 
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
@@ -3569,12 +3569,12 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
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
@@ -3745,12 +3745,14 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 
 	return ret;
 }
+#endif /* CONFIG_COMPAT */
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
 		u32, val3)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	ktime_t t, *tp = NULL;
 	int val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
@@ -3758,12 +3760,12 @@ COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
-		if (compat_get_timespec(&ts, utime))
+		if (compat_get_timespec64(&ts, utime))
 			return -EFAULT;
-		if (!timespec_valid(&ts))
+		if (!timespec64_valid(&ts))
 			return -EINVAL;
 
-		t = timespec_to_ktime(ts);
+		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
@@ -3774,7 +3776,7 @@ COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
-#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_COMPAT_32BIT_TIME */
 
 static void __init futex_detect_cmpxchg(void)
 {
-- 
2.9.0
