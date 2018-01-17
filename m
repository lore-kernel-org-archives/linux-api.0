From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Wed, 17 Jan 2018 08:36:52 +0100
Message-ID: <20180117073652.GA27389@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-33-hch@lst.de> <x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com> <20180115085310.GB32532@lst.de> <20180116120433.GA14579@lst.de> <x493735b9l7.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x493735b9l7.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 07:41:24PM -0500, Jeff Moyer wrote:
> I'd be willing to bet the issue is in your io_syscall6 implementation.
> You pass in arg5 where arg6 should be used.  Don't feel bad, it took me
> the better part of today to figure that out.  :)
> 
> Here's an incremental diff on top of what you've posted.  Feel free to
> fold it into your patch (and format however you like).  You can find the
> libaio changes in my 'aio-poll' branch:
>   https://pagure.io/libaio/commits/aio-poll
> 
> These changes were run through the libaio test harness, 64 bit and 32
> bit, so the compat system call was tested.

Oops, yes.  Although I prefer the copy_from_user version, this is what
I had:


diff --git a/fs/aio.c b/fs/aio.c
index 9fe0a5539596..6c1bbfa9b06a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1984,8 +1984,9 @@ SYSCALL_DEFINE6(io_pgetevents,
 		long, nr,
 		struct io_event __user *, events,
 		struct timespec __user *, timeout,
-		const sigset_t __user *, sigmask)
+		const struct __aio_sigset __user *, usig)
 {
+	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
 	int ret;
@@ -1993,8 +1994,13 @@ SYSCALL_DEFINE6(io_pgetevents,
 	if (timeout && unlikely(get_timespec64(&ts, timeout)))
 		return -EFAULT;
 
-	if (sigmask) {
-		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
+	if (ksig.sigmask) {
+		if (ksig.sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, ksig.sigmask, sizeof(ksigmask)))
 			return -EFAULT;
 		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
@@ -2002,7 +2008,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
 	if (signal_pending(current)) {
-		if (sigmask) {
+		if (ksig.sigmask) {
 			current->saved_sigmask = sigsaved;
 			set_restore_sigmask();
 		}
@@ -2010,7 +2016,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 		if (!ret)
 			ret = -ERESTARTNOHAND;
 	} else {
-		if (sigmask)
+		if (ksig.sigmask)
 			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
 
@@ -2036,14 +2042,21 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 	return ret;
 }
 
+
+struct __compat_aio_sigset {
+	compat_sigset_t __user	*sigmask;
+	compat_size_t		sigsetsize;
+};
+
 COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		compat_aio_context_t, ctx_id,
 		compat_long_t, min_nr,
 		compat_long_t, nr,
 		struct io_event __user *, events,
 		struct compat_timespec __user *, timeout,
-		const compat_sigset_t __user *, sigmask)
+		const struct __compat_aio_sigset __user *, usig)
 {
+	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
 	int ret;
@@ -2051,8 +2064,13 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	if (timeout && compat_get_timespec64(&t, timeout))
 		return -EFAULT;
 
-	if (sigmask) {
-		if (get_compat_sigset(&ksigmask, sigmask))
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
+	if (ksig.sigmask) {
+		if (ksig.sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (get_compat_sigset(&ksigmask, ksig.sigmask))
 			return -EFAULT;
 		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
@@ -2060,14 +2078,14 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
 	if (signal_pending(current)) {
-		if (sigmask) {
+		if (ksig.sigmask) {
 			current->saved_sigmask = sigsaved;
 			set_restore_sigmask();
 		}
 		if (!ret)
 			ret = -ERESTARTNOHAND;
 	} else {
-		if (sigmask)
+		if (ksig.sigmask)
 			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index a4cda98073f1..6c04450e961f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -205,6 +205,7 @@ extern int put_compat_rusage(const struct rusage *,
 			     struct compat_rusage __user *);
 
 struct compat_siginfo;
+struct __compat_aio_sigset;
 
 extern asmlinkage long compat_sys_waitid(int, compat_pid_t,
 		struct compat_siginfo __user *, int,
@@ -541,7 +542,7 @@ asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
 					compat_long_t nr,
 					struct io_event __user *events,
 					struct compat_timespec __user *timeout,
-					const compat_sigset_t __user *sigmask);
+					const struct __compat_aio_sigset __user *usig);
 asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
 asmlinkage long compat_sys_mount(const char __user *dev_name,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3bc9a130f4a9..8515ec53c81b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -544,7 +544,7 @@ asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
 				long nr,
 				struct io_event __user *events,
 				struct timespec __user *timeout,
-				const sigset_t __user *sigmask);
+				const struct __aio_sigset *sig);
 asmlinkage long sys_io_submit(aio_context_t, long,
 				struct iocb __user * __user *);
 asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 28330105a4b6..ed0185945bb2 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -29,6 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/signal.h>
 #include <asm/byteorder.h>
 
 typedef __kernel_ulong_t aio_context_t;
@@ -106,5 +107,10 @@ struct iocb {
 #undef IFBIG
 #undef IFLITTLE
 
+struct __aio_sigset {
+	sigset_t __user	*sigmask;
+	size_t		sigsetsize;
+};
+
 #endif /* __LINUX__AIO_ABI_H */
 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
