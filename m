From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v2 3/5] ppoll: use __kernel_timespec
Date: Fri, 14 Sep 2018 22:08:41 -0700
Message-ID: <20180915050843.19183-4-deepa.kernel@gmail.com>
References: <20180915050843.19183-1-deepa.kernel@gmail.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180915050843.19183-1-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

struct timespec is not y2038 safe.
struct __kernel_timespec is the new y2038 safe structure for all
syscalls that are using struct timespec.
Update ppoll interfaces to use struct __kernel_timespec.

sigset_t also has different representations on 32 bit and 64 bit
architectures. Hence, we need to support the following different
syscalls:

New y2038 safe syscalls:
(Controlled by CONFIG_64BIT_TIME for 32 bit ABIs)

Native 64 bit(unchanged) and native 32 bit : sys_ppoll
Compat : compat_sys_ppoll_time64

Older y2038 unsafe syscalls:
(Controlled by CONFIG_32BIT_COMPAT_TIME for 32 bit ABIs)

Native 32 bit : ppoll_time32
Compat : compat_sys_ppoll

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/select.c              | 169 ++++++++++++++++++++++++++-------------
 include/linux/compat.h   |   5 ++
 include/linux/syscalls.h |   5 +-
 3 files changed, 123 insertions(+), 56 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index eb9132520197..f3beef5e0eea 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -287,12 +287,18 @@ int poll_select_set_timeout(struct timespec64 *to, time64_t sec, long nsec)
 	return 0;
 }
 
+enum poll_time_type {
+	PT_TIMEVAL = 0,
+	PT_OLD_TIMEVAL = 1,
+	PT_TIMESPEC = 2,
+	PT_OLD_TIMESPEC = 3,
+};
+
 static int poll_select_copy_remaining(struct timespec64 *end_time,
 				      void __user *p,
-				      int timeval, int ret)
+				      enum poll_time_type pt_type, int ret)
 {
 	struct timespec64 rts;
-	struct timeval rtv;
 
 	if (!p)
 		return ret;
@@ -310,18 +316,40 @@ static int poll_select_copy_remaining(struct timespec64 *end_time,
 		rts.tv_sec = rts.tv_nsec = 0;
 
 
-	if (timeval) {
-		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
-			memset(&rtv, 0, sizeof(rtv));
-		rtv.tv_sec = rts.tv_sec;
-		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+	switch (pt_type) {
+	case PT_TIMEVAL:
+		{
+			struct timeval rtv;
 
-		if (!copy_to_user(p, &rtv, sizeof(rtv)))
+			if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
+				memset(&rtv, 0, sizeof(rtv));
+			rtv.tv_sec = rts.tv_sec;
+			rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+			if (!copy_to_user(p, &rtv, sizeof(rtv)))
+				return ret;
+		}
+		break;
+	case PT_OLD_TIMEVAL:
+		{
+			struct old_timeval32 rtv;
+
+			rtv.tv_sec = rts.tv_sec;
+			rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+			if (!copy_to_user(p, &rtv, sizeof(rtv)))
+				return ret;
+		}
+		break;
+	case PT_TIMESPEC:
+		if (!put_timespec64(&rts, p))
 			return ret;
-
-	} else if (!put_timespec64(&rts, p))
-		return ret;
-
+		break;
+	case PT_OLD_TIMESPEC:
+		if (!put_old_timespec32(&rts, p))
+			return ret;
+		break;
+	default:
+		BUG();
+	}
 	/*
 	 * If an application puts its timeval in read-only memory, we
 	 * don't want the Linux-specific update to the timeval to
@@ -689,7 +717,7 @@ static int kern_select(int n, fd_set __user *inp, fd_set __user *outp,
 	}
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tvp, 1, ret);
+	ret = poll_select_copy_remaining(&end_time, tvp, PT_TIMEVAL, ret);
 
 	return ret;
 }
@@ -722,7 +750,7 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	restore_user_sigmask(sigmask, &sigsaved);
 
@@ -1026,7 +1054,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 }
 
 SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
-		struct timespec __user *, tsp, const sigset_t __user *, sigmask,
+		struct __kernel_timespec __user *, tsp, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
@@ -1054,60 +1082,50 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
 
-	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
-#define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
+#if defined(CONFIG_COMPAT_32BIT_TIME) && !defined(CONFIG_64BIT)
 
-static
-int compat_poll_select_copy_remaining(struct timespec64 *end_time, void __user *p,
-				      int timeval, int ret)
+SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
+		struct old_timespec32 __user *, tsp, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
 {
-	struct timespec64 ts;
+	sigset_t ksigmask, sigsaved;
+	struct timespec64 ts, end_time, *to = NULL;
+	int ret;
 
-	if (!p)
-		return ret;
+	if (tsp) {
+		if (get_old_timespec32(&ts, tsp))
+			return -EFAULT;
 
-	if (current->personality & STICKY_TIMEOUTS)
-		goto sticky;
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
+	}
 
-	/* No update for zero timeout */
-	if (!end_time->tv_sec && !end_time->tv_nsec)
+	ret = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	if (ret)
 		return ret;
 
-	ktime_get_ts64(&ts);
-	ts = timespec64_sub(*end_time, ts);
-	if (ts.tv_sec < 0)
-		ts.tv_sec = ts.tv_nsec = 0;
+	ret = do_sys_poll(ufds, nfds, to);
 
-	if (timeval) {
-		struct old_timeval32 rtv;
+	restore_user_sigmask(sigmask, &sigsaved);
 
-		rtv.tv_sec = ts.tv_sec;
-		rtv.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	/* We can restart this syscall, usually */
+	if (ret == -EINTR)
+		ret = -ERESTARTNOHAND;
 
-		if (!copy_to_user(p, &rtv, sizeof(rtv)))
-			return ret;
-	} else {
-		if (!put_old_timespec32(&ts, p))
-			return ret;
-	}
-	/*
-	 * If an application puts its timeval in read-only memory, we
-	 * don't want the Linux-specific update to the timeval to
-	 * cause a fault after the select has completed
-	 * successfully. However, because we're not updating the
-	 * timeval, we can't restart the system call.
-	 */
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
-sticky:
-	if (ret == -ERESTARTNOHAND)
-		ret = -EINTR;
 	return ret;
 }
+#endif
+
+#ifdef CONFIG_COMPAT
+#define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
 /*
  * Ooo, nasty.  We need here to frob 32-bit unsigned longs to
@@ -1239,7 +1257,7 @@ static int do_compat_select(int n, compat_ulong_t __user *inp,
 	}
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = compat_poll_select_copy_remaining(&end_time, tvp, 1, ret);
+	ret = poll_select_copy_remaining(&end_time, tvp, PT_OLD_TIMEVAL, ret);
 
 	return ret;
 }
@@ -1292,7 +1310,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = compat_poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
 
 	restore_user_sigmask(sigmask, &sigsaved);
 
@@ -1318,6 +1336,7 @@ COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 				 sigsetsize);
 }
 
+#if defined(CONFIG_COMPAT_32BIT_TIME)
 COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
 	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
@@ -1347,8 +1366,48 @@ COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
 
-	ret = compat_poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
+
+	return ret;
+}
+#endif
+
+/* New compat syscall for 64 bit time_t*/
+#if defined(CONFIG_64BIT_TIME)
+
+COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
+	unsigned int,  nfds, struct __kernel_timespec __user *, tsp,
+	const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
+{
+	sigset_t ksigmask, sigsaved;
+	struct timespec64 ts, end_time, *to = NULL;
+	int ret;
+
+	if (tsp) {
+		if (get_timespec64(&ts, tsp))
+			return -EFAULT;
+
+		to = &end_time;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
+	}
+
+	ret = set_compat_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
+	if (ret)
+		return ret;
+
+	ret = do_sys_poll(ufds, nfds, to);
+
+	restore_user_sigmask(sigmask, &sigsaved);
+
+	/* We can restart this syscall, usually */
+	if (ret == -EINTR)
+		ret = -ERESTARTNOHAND;
+
+	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
 
 	return ret;
 }
+
+#endif
 #endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 03d65c509eeb..349a2d98e450 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -646,6 +646,11 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 struct old_timespec32 __user *tsp,
 				 const compat_sigset_t __user *sigmask,
 				 compat_size_t sigsetsize);
+asmlinkage long compat_sys_ppoll_time64(struct pollfd __user *ufds,
+				 unsigned int nfds,
+				 struct __kernel_timespec __user *tsp,
+				 const compat_sigset_t __user *sigmask,
+				 compat_size_t sigsetsize);
 
 /* fs/signalfd.c */
 asmlinkage long compat_sys_signalfd4(int ufd,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 82682b69435e..9755e70cfbb0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -470,7 +470,10 @@ asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
 			     fd_set __user *, struct timespec __user *,
 			     void __user *);
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
-			  struct timespec __user *, const sigset_t __user *,
+			  struct __kernel_timespec __user *, const sigset_t __user *,
+			  size_t);
+asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
+			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 
 /* fs/signalfd.c */
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
