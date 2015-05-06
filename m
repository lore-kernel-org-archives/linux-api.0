From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/19] y2038: add compat_sys_rt_sigtimedwait variants
Date: Wed,  6 May 2015 18:30:14 +0200
Message-ID: <1430929826-318934-8-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58712-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

rt_sigtimedwait takes sigevent and sigset arguments that are always
different between 32-bit and 64-bit user space. It also takes a
timespec argument that will be the same in the future between
architectures, and we want to share the compat system call handling.

We need to support all four combinations, and this adds the two new
ones:

- native sys_rt_sigtimedwait: now takes a __kernel_timespec that
  will at some point use 64-bit time_t on all architectures
- compat_sys_rt_sigtimedwait on 64-bit kernels: emulates the
  behavior of the old 32-bit user space
- compat_sys_rt_sigtimedwait on 32-bit kernels: emulates the
  old timespec but uses the native 32-bit sigevent and siginfo
  arguments
- compat_sys_rt_sigtimedwait_time64 on 64-bit kernels: emulates
  the 32-bit sigevent and siginfo structures but uses the native
  __kernel_timespec.

Having separate code for all four variants is a bit ugly, but
I could not come up with a better solution, and the code duplication
is fairly low in the end.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat_time.h |  5 ++++
 kernel/compat.c             | 66 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
index e17375a91f76..789b6415e90e 100644
--- a/include/linux/compat_time.h
+++ b/include/linux/compat_time.h
@@ -8,6 +8,7 @@
  * been converted to 64-bit __kernel_time_t as well as on 64-bit
  * architectures with 32-bit user space.
  */
+#include <linux/signal.h>
 #include <linux/resource.h>
 #include <linux/signal.h>
 
@@ -260,9 +261,13 @@ asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 					   struct compat_timespec __user *rqtp,
 					   struct compat_timespec __user *rmtp);
 struct compat_siginfo;
+struct __kernel_timespec;
 asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
 		struct compat_timespec __user *uts, compat_size_t sigsetsize);
+asmlinkage long compat_sys_rt_sigtimedwait_time64(compat_sigset_t __user *uthese,
+		struct compat_siginfo __user *uinfo,
+		struct __kernel_timespec __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 		struct compat_timespec __user *utime, u32 __user *uaddr2,
 		u32 val3);
diff --git a/kernel/compat.c b/kernel/compat.c
index 115ad84d4048..03bb63995027 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -27,6 +27,8 @@
 #include <linux/times.h>
 #include <linux/ptrace.h>
 #include <linux/gfp.h>
+#include <linux/signal.h>
+#include <asm/signal.h>
 
 #include <asm/uaccess.h>
 
@@ -1043,6 +1045,70 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 #endif
 #endif
 
+#if defined(CONFIG_COMPAT_TIME) && !defined(CONFIG_COMPAT)
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, sigset_t __user *, uthese,
+		struct siginfo __user *, uinfo,
+		struct compat_timespec __user *, uts, size_t, sigsetsize)
+{
+	sigset_t s;
+	struct timespec t;
+	siginfo_t info;
+	long ret;
+
+	if (sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+
+	if (copy_from_user(&s, uthese, sizeof(sigset_t)))
+		return -EFAULT;
+	if (uts) {
+		if (compat_get_timespec(&t, uts))
+			return -EFAULT;
+	}
+
+	ret = do_sigtimedwait(&s, &info, uts ? &t : NULL);
+
+	if (ret > 0 && uinfo) {
+		if (copy_siginfo_to_user(uinfo, &info))
+			ret = -EFAULT;
+	}
+
+	return ret;
+}
+#endif
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time64, compat_sigset_t __user *, uthese,
+		struct compat_siginfo __user *, uinfo,
+		struct __kernel_timespec __user *, uts, compat_size_t, sigsetsize)
+{
+	compat_sigset_t s32;
+	sigset_t s;
+	struct timespec t;
+	siginfo_t info;
+	long ret;
+
+	if (sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+
+	if (copy_from_user(&s32, uthese, sizeof(compat_sigset_t)))
+		return -EFAULT;
+	sigset_from_compat(&s, &s32);
+	if (uts) {
+		if (get_timespec64(&t, uts))
+			return -EFAULT;
+	}
+
+	ret = do_sigtimedwait(&s, &info, uts ? &t : NULL);
+
+	if (ret > 0 && uinfo) {
+		if (copy_siginfo_to_user32(uinfo, &info))
+			ret = -EFAULT;
+	}
+
+	return ret;
+}
+#endif
+
 #ifdef CONFIG_COMPAT_TIME
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
-- 
2.1.0.rc2
