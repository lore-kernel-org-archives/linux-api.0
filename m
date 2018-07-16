From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 16/17] y2038: Make compat_sys_rt_sigtimedwait usable on 32-bit
Date: Mon, 16 Jul 2018 18:11:02 +0200
Message-ID: <20180716161103.16239-17-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
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
index 0418a499b9f3..8d4382d5182f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3027,7 +3027,22 @@ int copy_siginfo_from_user32(struct siginfo *to,
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
@@ -3125,7 +3140,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 		struct compat_siginfo __user *, uinfo,
 		struct compat_timespec __user *, uts, compat_size_t, sigsetsize)
-- 
2.9.0
