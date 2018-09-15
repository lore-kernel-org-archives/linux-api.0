From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v2 4/5] pselect6: use __kernel_timespec
Date: Fri, 14 Sep 2018 22:08:42 -0700
Message-ID: <20180915050843.19183-5-deepa.kernel@gmail.com>
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
Update pselect interfaces to use struct __kernel_timespec.

sigset_t also has different representations on 32 bit and 64 bit
architectures. Hence, we need to support the following different
syscalls:

New y2038 safe syscalls:
(Controlled by CONFIG_64BIT_TIME for 32 bit ABIs)

Native 64 bit(unchanged) and native 32 bit : sys_pselect6
Compat : compat_sys_pselect6_time64

Older y2038 unsafe syscalls:
(Controlled by CONFIG_32BIT_COMPAT_TIME for 32 bit ABIs)

Native 32 bit : pselect6_time32
Compat : compat_sys_pselect6

Note that all other versions of select syscalls will not have
y2038 safe versions.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/select.c              | 98 ++++++++++++++++++++++++++++++++++------
 include/linux/compat.h   |  5 ++
 include/linux/syscalls.h |  5 +-
 3 files changed, 94 insertions(+), 14 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index f3beef5e0eea..b338b40c43e6 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -729,16 +729,27 @@ SYSCALL_DEFINE5(select, int, n, fd_set __user *, inp, fd_set __user *, outp,
 }
 
 static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
-		       fd_set __user *exp, struct timespec __user *tsp,
-		       const sigset_t __user *sigmask, size_t sigsetsize)
+		       fd_set __user *exp, void __user *tsp,
+		       const sigset_t __user *sigmask, size_t sigsetsize,
+		       enum poll_time_type type)
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (get_timespec64(&ts, tsp))
-			return -EFAULT;
+		switch (type) {
+		case PT_TIMESPEC:
+			if (get_timespec64(&ts, tsp))
+				return -EFAULT;
+			break;
+		case PT_OLD_TIMESPEC:
+			if (get_old_timespec32(&ts, tsp))
+				return -EFAULT;
+			break;
+		default:
+			BUG();
+		}
 
 		to = &end_time;
 		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
@@ -750,7 +761,7 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
 	restore_user_sigmask(sigmask, &sigsaved);
 
@@ -764,7 +775,27 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
  * the sigset size.
  */
 SYSCALL_DEFINE6(pselect6, int, n, fd_set __user *, inp, fd_set __user *, outp,
-		fd_set __user *, exp, struct timespec __user *, tsp,
+		fd_set __user *, exp, struct __kernel_timespec __user *, tsp,
+		void __user *, sig)
+{
+	size_t sigsetsize = 0;
+	sigset_t __user *up = NULL;
+
+	if (sig) {
+		if (!access_ok(VERIFY_READ, sig, sizeof(void *)+sizeof(size_t))
+		    || __get_user(up, (sigset_t __user * __user *)sig)
+		    || __get_user(sigsetsize,
+				(size_t __user *)(sig+sizeof(void *))))
+			return -EFAULT;
+	}
+
+	return do_pselect(n, inp, outp, exp, tsp, up, sigsetsize, PT_TIMESPEC);
+}
+
+#if defined(CONFIG_COMPAT_32BIT_TIME) && !defined(CONFIG_64BIT)
+
+SYSCALL_DEFINE6(pselect6_time32, int, n, fd_set __user *, inp, fd_set __user *, outp,
+		fd_set __user *, exp, struct old_timespec32 __user *, tsp,
 		void __user *, sig)
 {
 	size_t sigsetsize = 0;
@@ -778,9 +809,11 @@ SYSCALL_DEFINE6(pselect6, int, n, fd_set __user *, inp, fd_set __user *, outp,
 			return -EFAULT;
 	}
 
-	return do_pselect(n, inp, outp, exp, tsp, up, sigsetsize);
+	return do_pselect(n, inp, outp, exp, tsp, up, sigsetsize, PT_OLD_TIMESPEC);
 }
 
+#endif
+
 #ifdef __ARCH_WANT_SYS_OLD_SELECT
 struct sel_arg_struct {
 	unsigned long n;
@@ -1289,16 +1322,26 @@ COMPAT_SYSCALL_DEFINE1(old_select, struct compat_sel_arg_struct __user *, arg)
 
 static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct old_timespec32 __user *tsp, compat_sigset_t __user *sigmask,
-	compat_size_t sigsetsize)
+	void __user *tsp, compat_sigset_t __user *sigmask,
+	compat_size_t sigsetsize, enum poll_time_type type)
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (get_old_timespec32(&ts, tsp))
-			return -EFAULT;
+		switch (type) {
+		case PT_OLD_TIMESPEC:
+			if (get_old_timespec32(&ts, tsp))
+				return -EFAULT;
+			break;
+		case PT_TIMESPEC:
+			if (get_old_timespec32(&ts, tsp))
+				return -EFAULT;
+			break;
+		default:
+			BUG();
+		}
 
 		to = &end_time;
 		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
@@ -1310,13 +1353,39 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
+	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
 	restore_user_sigmask(sigmask, &sigsaved);
 
 	return ret;
 }
 
+#if defined(CONFIG_64BIT_TIME)
+
+COMPAT_SYSCALL_DEFINE6(pselect6_time64, int, n, compat_ulong_t __user *, inp,
+	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+	struct __kernel_timespec __user *, tsp, void __user *, sig)
+{
+	compat_size_t sigsetsize = 0;
+	compat_uptr_t up = 0;
+
+	if (sig) {
+		if (!access_ok(VERIFY_READ, sig,
+				sizeof(compat_uptr_t)+sizeof(compat_size_t)) ||
+				__get_user(up, (compat_uptr_t __user *)sig) ||
+				__get_user(sigsetsize,
+				(compat_size_t __user *)(sig+sizeof(up))))
+			return -EFAULT;
+	}
+
+	return do_compat_pselect(n, inp, outp, exp, tsp, compat_ptr(up),
+				 sigsetsize, PT_TIMESPEC);
+}
+
+#endif
+
+#if defined(CONFIG_COMPAT_32BIT_TIME)
+
 COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
 	struct old_timespec32 __user *, tsp, void __user *, sig)
@@ -1332,10 +1401,13 @@ COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
 				(compat_size_t __user *)(sig+sizeof(up))))
 			return -EFAULT;
 	}
+
 	return do_compat_pselect(n, inp, outp, exp, tsp, compat_ptr(up),
-				 sigsetsize);
+				 sigsetsize, PT_OLD_TIMESPEC);
 }
 
+#endif
+
 #if defined(CONFIG_COMPAT_32BIT_TIME)
 COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
 	unsigned int,  nfds, struct old_timespec32 __user *, tsp,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 349a2d98e450..6896e6e51c00 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -641,6 +641,11 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				    compat_ulong_t __user *exp,
 				    struct old_timespec32 __user *tsp,
 				    void __user *sig);
+asmlinkage long compat_sys_pselect6_time64(int n, compat_ulong_t __user *inp,
+				    compat_ulong_t __user *outp,
+				    compat_ulong_t __user *exp,
+				    struct __kernel_timespec __user *tsp,
+				    void __user *sig);
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 unsigned int nfds,
 				 struct old_timespec32 __user *tsp,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 9755e70cfbb0..e9cd0409c3fe 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -467,7 +467,10 @@ asmlinkage long sys_sendfile64(int out_fd, int in_fd,
 
 /* fs/select.c */
 asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
-			     fd_set __user *, struct timespec __user *,
+			     fd_set __user *, struct __kernel_timespec __user *,
+			     void __user *);
+asmlinkage long sys_pselect6_time32(int, fd_set __user *, fd_set __user *,
+			     fd_set __user *, struct old_timespec32 __user *,
 			     void __user *);
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct __kernel_timespec __user *, const sigset_t __user *,
-- 
2.17.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
