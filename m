From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 16/17] y2038: Make compat_sys_rt_sigtimedwait usable on 32-bit
Date: Wed, 25 Apr 2018 18:03:10 +0200
Message-ID: <20180425160311.2718314-17-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

Once sys_rt_sigtimedwait() gets changed to a 64-bit time_t, we have
to provide compatibility support for existing binaries.  Using the
compat_sys_rt_sigtimedwait() entry point is convenient because it allows
to share the implementation with 64-bit architectures.

Unfortunately, the get_compat_sigset() and copy_siginfo_to_user32()
functions are used in that function, but we can replace them with
trivial helpers that do the same thing as before.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/signal.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d8d68a9556ae..72609c6835fd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3104,7 +3104,22 @@ int copy_siginfo_from_user32(struct siginfo *to,
 	}
 	return 0;
 }
-#endif /* CONFIG_COMPAT */
+
+#else /* !CONFIG_COMPAT */
+
+/* 32-bit architectures only need to convert compat_time_t, not siginfo or sigset_t */
+
+#define compat_siginfo siginfo
+#define compat_sigset_t sigset_t
+#define copy_siginfo_to_user32 copy_siginfo_to_user
+static inline int get_compat_sigset(sigset_t *set, const sigset_t __user *compat)
+{
+	if (copy_from_user(set, compat, sizeof *set))
+		return -EFAULT;
+
+	return 0;
+}
+#endif /* !CONFIG_COMPAT */
 
 /**
  *  do_sigtimedwait - wait for queued signals specified in @which
@@ -3202,7 +3217,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
 		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
-- 
2.9.0
