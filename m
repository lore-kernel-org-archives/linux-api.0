From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] aio: implement io_pgetevents
Date: Wed, 21 Mar 2018 08:32:31 +0100
Message-ID: <20180321073232.13366-9-hch@lst.de>
References: <20180321073232.13366-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180321073232.13366-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is the io_getevents equivalent of ppoll/pselect and allows to
properly mix signals and aio completions (especially with IOCB_CMD_POLL)
and atomically executes the following sequence:

	sigset_t origmask;

	pthread_sigmask(SIG_SETMASK, &sigmask, &origmask);
	ret = io_getevents(ctx, min_nr, nr, events, timeout);
	pthread_sigmask(SIG_SETMASK, &origmask, NULL);

Note that unlike many other signal related calls we do not pass a sigmask
size, as that would get us to 7 arguments, which aren't easily supported
by the syscall infrastructure.  It seems a lot less painful to just add a
new syscall variant in the unlikely case we're going to increase the
sigset size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/aio.c                               | 114 ++++++++++++++++++++++++++++++---
 include/linux/compat.h                 |   7 ++
 include/linux/syscalls.h               |   6 ++
 include/uapi/asm-generic/unistd.h      |   4 +-
 include/uapi/linux/aio_abi.h           |   6 ++
 kernel/sys_ni.c                        |   2 +
 8 files changed, 130 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2a5e99cff859..c1018580ddaa 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -391,3 +391,4 @@
 382	i386	pkey_free		sys_pkey_free
 383	i386	statx			sys_statx
 384	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
+385	i386	io_pgetevents		sys_io_pgetevents		compat_sys_io_pgetevents
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 5aef183e2f85..e995cd2b4e65 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -339,6 +339,7 @@
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
 332	common	statx			sys_statx
+333	common	io_pgetevents		sys_io_pgetevents
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/aio.c b/fs/aio.c
index 9d7d6e4cde87..da87cbf7c67a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1291,10 +1291,6 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
 		wait_event_interruptible_hrtimeout(ctx->wait,
 				aio_read_events(ctx, min_nr, nr, event, &ret),
 				until);
-
-	if (!ret && signal_pending(current))
-		ret = -EINTR;
-
 	return ret;
 }
 
@@ -1874,13 +1870,60 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		struct timespec __user *, timeout)
 {
 	struct timespec64	ts;
+	int			ret;
+
+	if (timeout && unlikely(get_timespec64(&ts, timeout)))
+		return -EFAULT;
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
+	if (!ret && signal_pending(current))
+		ret = -EINTR;
+	return ret;
+}
+
+SYSCALL_DEFINE6(io_pgetevents,
+		aio_context_t, ctx_id,
+		long, min_nr,
+		long, nr,
+		struct io_event __user *, events,
+		struct timespec __user *, timeout,
+		const struct __aio_sigset __user *, usig)
+{
+	struct __aio_sigset	ksig = { NULL, };
+	sigset_t		ksigmask, sigsaved;
+	struct timespec64	ts;
+	int ret;
+
+	if (timeout && unlikely(get_timespec64(&ts, timeout)))
+		return -EFAULT;
 
-	if (timeout) {
-		if (unlikely(get_timespec64(&ts, timeout)))
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
+	if (ksig.sigmask) {
+		if (ksig.sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, ksig.sigmask, sizeof(ksigmask)))
 			return -EFAULT;
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
+	if (signal_pending(current)) {
+		if (ksig.sigmask) {
+			current->saved_sigmask = sigsaved;
+			set_restore_sigmask();
+		}
+
+		if (!ret)
+			ret = -ERESTARTNOHAND;
+	} else {
+		if (ksig.sigmask)
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
 
-	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1891,13 +1934,64 @@ COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       struct compat_timespec __user *, timeout)
 {
 	struct timespec64 t;
+	int ret;
+
+	if (timeout && compat_get_timespec64(&t, timeout))
+		return -EFAULT;
+
+	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
+	if (!ret && signal_pending(current))
+		ret = -EINTR;
+	return ret;
+}
+
+
+struct __compat_aio_sigset {
+	compat_sigset_t __user	*sigmask;
+	compat_size_t		sigsetsize;
+};
+
+COMPAT_SYSCALL_DEFINE6(io_pgetevents,
+		compat_aio_context_t, ctx_id,
+		compat_long_t, min_nr,
+		compat_long_t, nr,
+		struct io_event __user *, events,
+		struct compat_timespec __user *, timeout,
+		const struct __compat_aio_sigset __user *, usig)
+{
+	struct __compat_aio_sigset ksig = { NULL, };
+	sigset_t ksigmask, sigsaved;
+	struct timespec64 t;
+	int ret;
+
+	if (timeout && compat_get_timespec64(&t, timeout))
+		return -EFAULT;
 
-	if (timeout) {
-		if (compat_get_timespec64(&t, timeout))
+	if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
+		return -EFAULT;
+
+	if (ksig.sigmask) {
+		if (ksig.sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (get_compat_sigset(&ksigmask, ksig.sigmask))
 			return -EFAULT;
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+	}
 
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
 	}
 
-	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
+	return ret;
 }
 #endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 16c3027074a2..d80cda61eafd 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -304,6 +304,7 @@ extern int put_compat_rusage(const struct rusage *,
 			     struct compat_rusage __user *);
 
 struct compat_siginfo;
+struct __compat_aio_sigset;
 
 extern asmlinkage long compat_sys_waitid(int, compat_pid_t,
 		struct compat_siginfo __user *, int,
@@ -656,6 +657,12 @@ asmlinkage long compat_sys_io_getevents(compat_aio_context_t ctx_id,
 					compat_long_t nr,
 					struct io_event __user *events,
 					struct compat_timespec __user *timeout);
+asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
+					compat_long_t min_nr,
+					compat_long_t nr,
+					struct io_event __user *events,
+					struct compat_timespec __user *timeout,
+					const struct __compat_aio_sigset __user *usig);
 asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
 asmlinkage long compat_sys_mount(const char __user *dev_name,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a78186d826d7..8515ec53c81b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -539,6 +539,12 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 				long nr,
 				struct io_event __user *events,
 				struct timespec __user *timeout);
+asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
+				long min_nr,
+				long nr,
+				struct io_event __user *events,
+				struct timespec __user *timeout,
+				const struct __aio_sigset *sig);
 asmlinkage long sys_io_submit(aio_context_t, long,
 				struct iocb __user * __user *);
 asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 8b87de067bc7..ce2ebbeece10 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -732,9 +732,11 @@ __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
 __SYSCALL(__NR_pkey_free,     sys_pkey_free)
 #define __NR_statx 291
 __SYSCALL(__NR_statx,     sys_statx)
+#define __NR_io_pgetevents 292
+__SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
 
 #undef __NR_syscalls
-#define __NR_syscalls 292
+#define __NR_syscalls 293
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index a04adbc70ddf..2c0a3415beee 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -29,6 +29,7 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/signal.h>
 #include <asm/byteorder.h>
 
 typedef __kernel_ulong_t aio_context_t;
@@ -108,5 +109,10 @@ struct iocb {
 #undef IFBIG
 #undef IFLITTLE
 
+struct __aio_sigset {
+	sigset_t __user	*sigmask;
+	size_t		sigsetsize;
+};
+
 #endif /* __LINUX__AIO_ABI_H */
 
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index b5189762d275..8f7705559b38 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -151,9 +151,11 @@ cond_syscall(sys_io_destroy);
 cond_syscall(sys_io_submit);
 cond_syscall(sys_io_cancel);
 cond_syscall(sys_io_getevents);
+cond_syscall(sys_io_pgetevents);
 cond_syscall(compat_sys_io_setup);
 cond_syscall(compat_sys_io_submit);
 cond_syscall(compat_sys_io_getevents);
+cond_syscall(compat_sys_io_pgetevents);
 cond_syscall(sys_sysfs);
 cond_syscall(sys_syslog);
 cond_syscall(sys_process_vm_readv);
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
