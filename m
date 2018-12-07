From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] y2038: signal: Add compat_sys_rt_sigtimedwait_time64
Date: Fri,  7 Dec 2018 22:18:08 +0100
Message-ID: <20181207211808.328719-6-arnd@arndb.de>
References: <20181207211808.328719-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207211808.328719-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Now that 32-bit architectures have two variants of sys_rt_sigtimedwaid()
for 32-bit and 64-bit time_t, we also need to have a second compat system
call entry point on the corresponding 64-bit architectures.

The traditional system call keeps getting handled
by compat_sys_rt_sigtimedwait(), and this adds a new
compat_sys_rt_sigtimedwait_time64() that differs only in the timeout
argument type.

The naming remains a bit asymmetric for the moment. Ideally we would
want to have compat_sys_rt_sigtimedwait_time32() for the old version
and compat_sys_rt_sigtimedwait() for the new one to mirror the names
of the native entry points, but renaming the existing system call
tables causes unnecessary churn. I would suggest renaming all such
system calls together at a later point.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h |  3 +++
 kernel/signal.c        | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 72969d303434..3bc5f218efd8 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -788,6 +788,9 @@ asmlinkage long compat_sys_rt_sigpending(compat_sigset_t __user *uset,
 asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
 		struct old_timespec32 __user *uts, compat_size_t sigsetsize);
+asmlinkage long compat_sys_rt_sigtimedwait_time64(compat_sigset_t __user *uthese,
+		struct compat_siginfo __user *uinfo,
+		struct __kernel_timespec __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigqueueinfo(compat_pid_t pid, int sig,
 				struct compat_siginfo __user *uinfo);
 /* No generic prototype for rt_sigreturn */
diff --git a/kernel/signal.c b/kernel/signal.c
index be6744cd0a11..53e07d97ffe0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3366,6 +3366,37 @@ SYSCALL_DEFINE4(rt_sigtimedwait_time32, const sigset_t __user *, uthese,
 #endif
 
 #ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time64, compat_sigset_t __user *, uthese,
+		struct compat_siginfo __user *, uinfo,
+		struct __kernel_timespec __user *, uts, compat_size_t, sigsetsize)
+{
+	sigset_t s;
+	struct timespec64 t;
+	kernel_siginfo_t info;
+	long ret;
+
+	if (sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+
+	if (get_compat_sigset(&s, uthese))
+		return -EFAULT;
+
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
+
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
 		struct old_timespec32 __user *, uts, compat_size_t, sigsetsize)
@@ -3396,6 +3427,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 	return ret;
 }
 #endif
+#endif
 
 /**
  *  sys_kill - send a signal to a process
-- 
2.18.0
