From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 17/17] y2038: signal: Add compat_sys_rt_sigtimedwait_time64
Date: Wed, 25 Apr 2018 18:03:11 +0200
Message-ID: <20180425160311.2718314-18-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
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
index 72609c6835fd..1927fcfa7077 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3249,6 +3249,38 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
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
