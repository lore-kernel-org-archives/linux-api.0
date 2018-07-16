From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 12/17] y2038: aio: Prepare sys_io_{p,}getevents for __kernel_timespec
Date: Mon, 16 Jul 2018 18:10:58 +0200
Message-ID: <20180716161103.16239-13-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is a preparation patch for converting sys_io_pgetevents to
work with 64-bit time_t on 32-bit architectures. The 'timeout' argument
is changed to struct __kernel_timespec, which will be redefined using
64-bit time_t in the future. The compat version of the system call in
turn is enabled for compilation with CONFIG_COMPAT_32BIT_TIME so
the individual 32-bit architectures can share the handling of the
traditional argument with 64-bit architectures providing it for their
compat mode.

We now have five entry points into do_io_getevents(). Until we set
CONFIG_64BIT_TIME, the arguments are

sys_io_getevents():	    native aio_context_t, old-style timespec
sys_io_pgetevents():	    like sys_io_getevents(), but with added
			    aio_sigset argument
compat_sys_io_getevents():  32-bit aio_context_t, 32-bit timespec
compat_sys_io_pgetevents(): like compat_sys_io_getevents(), but with
			    added aio_sigset argument
compat_sys_io_pgetevents_time64(): like compat_sys_io_pgetevents(),
			    but with 64-bit timespec

Once a 32-bit architecture sets CONFIG_64BIT_TIME, sys_io_getevents()
is no longer available, and sys_io_pgetevents() takes a 64-bit timespec
argument, whiel compat_sys_io_getevents() and compat_sys_io_pgetevents()
implement the traditional behavior. compat_sys_io_pgetevents_time64()
is only used on 64-bit architectures, to provide compatibility with
the new 32-bit version of sys_io_pgetevents() taking a 64-bit timespec
combined with a __compat_aio_sigset.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/aio.c                 | 77 +++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/syscalls.h |  4 +--
 2 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 76def7523ece..f306a48b0a9f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1869,7 +1869,7 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
 		long, nr,
 		struct io_event __user *, events,
-		struct timespec __user *, timeout)
+		struct __kernel_timespec __user *, timeout)
 {
 	struct timespec64	ts;
 	int			ret;
@@ -1888,7 +1888,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 		long, min_nr,
 		long, nr,
 		struct io_event __user *, events,
-		struct timespec __user *, timeout,
+		struct __kernel_timespec __user *, timeout,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
@@ -1929,6 +1929,73 @@ SYSCALL_DEFINE6(io_pgetevents,
 }
 
 #ifdef CONFIG_COMPAT
+struct __compat_aio_sigset {
+	compat_sigset_t __user	*sigmask;
+	compat_size_t		sigsetsize;
+};
+
+COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
+		compat_aio_context_t, ctx_id,
+		compat_long_t, min_nr,
+		compat_long_t, nr,
+		struct io_event __user *, events,
+		struct __kernel_timespec __user *, timeout,
+		const struct __compat_aio_sigset __user *, usig)
+{
+	struct __compat_aio_sigset ksig = { NULL, };
+	sigset_t ksigmask, sigsaved;
+	struct timespec64 t;
+	int ret;
+
+	if (timeout && get_timespec64(&t, timeout))
+		return -EFAULT;
+
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
+	if (ksig.sigmask) {
+		if (ksig.sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (get_compat_sigset(&ksigmask, ksig.sigmask))
+			return -EFAULT;
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
+	if (signal_pending(current)) {
+		if (ksig.sigmask) {
+			current->saved_sigmask = sigsaved;
+			set_restore_sigmask();
+		}
+		if (!ret)
+			ret = -ERESTARTNOHAND;
+	} else {
+		if (ksig.sigmask)
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+	}
+
+	return ret;
+}
+#endif
+
+#ifdef CONFIG_COMPAT_32BIT_TIME
+#ifndef CONFIG_COMPAT
+#define compat_sigset_t sigset_t
+struct __compat_aio_sigset {
+	compat_sigset_t __user	*sigmask;
+	compat_size_t		sigsetsize;
+};
+
+static inline int get_compat_sigset(sigset_t *set, const sigset_t __user *compat)
+{
+        if (copy_from_user(set, compat, sizeof *set))
+                return -EFAULT;
+
+        return 0;
+}
+#endif
+
 COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       compat_long_t, min_nr,
 		       compat_long_t, nr,
@@ -1947,12 +2014,6 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 	return ret;
 }
 
-
-struct __compat_aio_sigset {
-	compat_sigset_t __user	*sigmask;
-	compat_size_t		sigsetsize;
-};
-
 COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		compat_aio_context_t, ctx_id,
 		compat_long_t, min_nr,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1a22bb4285bf..4fc93fbc0d00 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -296,12 +296,12 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 				long min_nr,
 				long nr,
 				struct io_event __user *events,
-				struct timespec __user *timeout);
+				struct __kernel_timespec __user *timeout);
 asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
 				long min_nr,
 				long nr,
 				struct io_event __user *events,
-				struct timespec __user *timeout,
+				struct __kernel_timespec __user *timeout,
 				const struct __aio_sigset *sig);
 
 /* fs/xattr.c */
-- 
2.9.0
