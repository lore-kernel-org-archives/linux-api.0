From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 17/17] y2038: signal: Add compat_sys_rt_sigtimedwait_time64
Date: Mon, 16 Jul 2018 18:11:03 +0200
Message-ID: <20180716161103.16239-18-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Now that 32-bit architectures have two variants of
sys_rt_sigtimedwaid() for 32-bit and 64-bit time_t, we also
need to have a second compat system call entry point on the
corresponding 64-bit architectures.

The traditional system call keeps getting handled
by compat_sys_rt_sigtimedwait(), and this adds a new
compat_sys_rt_sigtimedwait_time64() that differs only in
the timeout argument type.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/signal.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8d4382d5182f..332f019dc421 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3172,6 +3172,38 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 }
 #endif
 
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait_time64, compat_sigset_t __user *, uthese,
+		struct compat_siginfo __user *, uinfo,
+		struct __kernel_timespec __user *, uts, compat_size_t, sigsetsize)
+{
+	sigset_t s;
+	struct timespec64 t;
+	siginfo_t info;
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
+#endif
+
 /**
  *  sys_kill - send a signal to a process
  *  @pid: the PID of the process
-- 
2.9.0
