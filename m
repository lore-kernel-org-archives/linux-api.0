From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v4 5/5] io_pgetevents: use __kernel_timespec
Date: Wed, 19 Sep 2018 21:41:08 -0700
Message-ID: <20180920044108.6606-6-deepa.kernel@gmail.com>
References: <20180920044108.6606-1-deepa.kernel@gmail.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180920044108.6606-1-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

struct timespec is not y2038 safe.
struct __kernel_timespec is the new y2038 safe structure for all
syscalls that are using struct timespec.
Update io_pgetevents interfaces to use struct __kernel_timespec.

sigset_t also has different representations on 32 bit and 64 bit
architectures. Hence, we need to support the following different
syscalls:

New y2038 safe syscalls:
(Controlled by CONFIG_64BIT_TIME for 32 bit ABIs)

Native 64 bit(unchanged) and native 32 bit : sys_io_pgetevents
Compat : compat_sys_io_pgetevents_time64

Older y2038 unsafe syscalls:
(Controlled by CONFIG_32BIT_COMPAT_TIME for 32 bit ABIs)

Native 32 bit : sys_io_pgetevents_time32
Compat : compat_sys_io_pgetevents

Note that io_getevents syscalls do not have a y2038 safe solution.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/aio.c                 | 84 ++++++++++++++++++++++++++++++++++++++--
 include/linux/compat.h   |  6 +++
 include/linux/syscalls.h | 10 ++++-
 3 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b81c216534d6..5caf31455f90 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2063,11 +2063,13 @@ static long do_io_getevents(aio_context_t ctx_id,
  *	specifies an infinite timeout. Note that the timeout pointed to by
  *	timeout is relative.  Will fail with -ENOSYS if not implemented.
  */
+#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+
 SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
 		long, nr,
 		struct io_event __user *, events,
-		struct timespec __user *, timeout)
+		struct __kernel_timespec __user *, timeout)
 {
 	struct timespec64	ts;
 	int			ret;
@@ -2081,6 +2083,8 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	return ret;
 }
 
+#endif
+
 struct __aio_sigset {
 	const sigset_t __user	*sigmask;
 	size_t		sigsetsize;
@@ -2091,7 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 		long, min_nr,
 		long, nr,
 		struct io_event __user *, events,
-		struct timespec __user *, timeout,
+		struct __kernel_timespec __user *, timeout,
 		const struct __aio_sigset __user *, usig)
 {
 	struct __aio_sigset	ksig = { NULL, };
@@ -2105,6 +2109,39 @@ SYSCALL_DEFINE6(io_pgetevents,
 	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
 		return -EFAULT;
 
+	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	if (ret)
+		return ret;
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
+	restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_pending(current) && !ret)
+		ret = -ERESTARTNOHAND;
+
+	return ret;
+}
+
+#if defined(CONFIG_COMPAT_32BIT_TIME) && !defined(CONFIG_64BIT)
+
+SYSCALL_DEFINE6(io_pgetevents_time32,
+		aio_context_t, ctx_id,
+		long, min_nr,
+		long, nr,
+		struct io_event __user *, events,
+		struct old_timespec32 __user *, timeout,
+		const struct __aio_sigset __user *, usig)
+{
+	struct __aio_sigset	ksig = { NULL, };
+	sigset_t		ksigmask, sigsaved;
+	struct timespec64	ts;
+	int ret;
+
+	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
+		return -EFAULT;
+
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
 
 	ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
 	if (ret)
@@ -2118,7 +2155,10 @@ SYSCALL_DEFINE6(io_pgetevents,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
+#endif
+
+#if defined(CONFIG_COMPAT_32BIT_TIME)
+
 COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       compat_long_t, min_nr,
 		       compat_long_t, nr,
@@ -2137,12 +2177,17 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 	return ret;
 }
 
+#endif
+
+#ifdef CONFIG_COMPAT
 
 struct __compat_aio_sigset {
 	compat_sigset_t __user	*sigmask;
 	compat_size_t		sigsetsize;
 };
 
+#if defined(CONFIG_COMPAT_32BIT_TIME)
+
 COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		compat_aio_context_t, ctx_id,
 		compat_long_t, min_nr,
@@ -2173,4 +2218,37 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 
 	return ret;
 }
+
+#endif
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
+	ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
+	if (ret)
+		return ret;
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
+	restore_user_sigmask(ksig.sigmask, &sigsaved);
+	if (signal_pending(current) && !ret)
+		ret = -ERESTARTNOHAND;
+
+	return ret;
+}
 #endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 6896e6e51c00..50cd0329c8bf 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -556,6 +556,12 @@ asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
 					struct io_event __user *events,
 					struct old_timespec32 __user *timeout,
 					const struct __compat_aio_sigset __user *usig);
+asmlinkage long compat_sys_io_pgetevents_time64(compat_aio_context_t ctx_id,
+					compat_long_t min_nr,
+					compat_long_t nr,
+					struct io_event __user *events,
+					struct __kernel_timespec __user *timeout,
+					const struct __compat_aio_sigset __user *usig);
 
 /* fs/cookies.c */
 asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, compat_size_t);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e9cd0409c3fe..3ff0e29c082c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -297,12 +297,18 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
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
+				const struct __aio_sigset *sig);
+asmlinkage long sys_io_pgetevents_time32(aio_context_t ctx_id,
+				long min_nr,
+				long nr,
+				struct io_event __user *events,
+				struct old_timespec32 __user *timeout,
 				const struct __aio_sigset *sig);
 
 /* fs/xattr.c */
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
