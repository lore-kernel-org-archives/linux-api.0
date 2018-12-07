From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/5] y2038: signal: Add sys_rt_sigtimedwait_time32
Date: Fri,  7 Dec 2018 22:18:07 +0100
Message-ID: <20181207211808.328719-5-arnd@arndb.de>
References: <20181207211808.328719-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207211808.328719-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Once sys_rt_sigtimedwait() gets changed to a 64-bit time_t, we have
to provide compatibility support for existing binaries.

An earlier version of this patch reused the compat_sys_rt_sigtimedwait
entry point to avoid code duplication, but this newer approach
duplicates the existing native entry point instead, which seems
a bit cleaner.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |  4 ++++
 kernel/signal.c          | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 03cda6793be3..251979d2e709 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -649,6 +649,10 @@ asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct __kernel_timespec __user *uts,
 				size_t sigsetsize);
+asmlinkage long sys_rt_sigtimedwait_time32(const sigset_t __user *uthese,
+				siginfo_t __user *uinfo,
+				const struct old_timespec32 __user *uts,
+				size_t sigsetsize);
 asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo);
 
 /* kernel/sys.c */
diff --git a/kernel/signal.c b/kernel/signal.c
index 3c8ea7a328e0..be6744cd0a11 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3332,6 +3332,39 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
+SYSCALL_DEFINE4(rt_sigtimedwait_time32, const sigset_t __user *, uthese,
+		siginfo_t __user *, uinfo,
+		const struct old_timespec32 __user *, uts,
+		size_t, sigsetsize)
+{
+	sigset_t these;
+	struct timespec64 ts;
+	kernel_siginfo_t info;
+	int ret;
+
+	if (sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+
+	if (copy_from_user(&these, uthese, sizeof(these)))
+		return -EFAULT;
+
+	if (uts) {
+		if (get_old_timespec32(&ts, uts))
+			return -EFAULT;
+	}
+
+	ret = do_sigtimedwait(&these, &info, uts ? &ts : NULL);
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
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
-- 
2.18.0
