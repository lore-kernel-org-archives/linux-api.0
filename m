From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 17/19] y2038: use __kernel_timespec in sys_futex
Date: Wed,  6 May 2015 18:30:24 +0200
Message-ID: <1430929826-318934-18-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Conversion for sys_futex is particularly easy, we can use the unmodified
compat_sys_futex on 32-bit systems to provide compatibility for 32-bit
time_t, and change sys_futex to pass a __kernel_timespec, which matches
what future libc implementations will use as their struct timespec.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  4 ++--
 kernel/futex.c           | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 017aa1c970e6..90c3cd889387 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -331,8 +331,8 @@ asmlinkage long sys_waitid(int which, pid_t pid,
 asmlinkage long sys_waitpid(pid_t pid, int __user *stat_addr, int options);
 asmlinkage long sys_set_tid_address(int __user *tidptr);
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
-			struct timespec __user *utime, u32 __user *uaddr2,
-			u32 val3);
+			struct __kernel_timespec __user *utime,
+			u32 __user *uaddr2, u32 val3);
 
 asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 				const char __user *uargs);
diff --git a/kernel/futex.c b/kernel/futex.c
index 2579e407ff67..199e4f94a80c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2970,10 +2970,10 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 
 
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
@@ -2981,12 +2981,12 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
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
-- 
2.1.0.rc2
