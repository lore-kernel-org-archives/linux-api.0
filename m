From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Tue, 16 Jan 2018 19:41:24 -0500
Message-ID: <x493735b9l7.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-33-hch@lst.de>
	<x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
	<20180115085310.GB32532@lst.de> <20180116120433.GA14579@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180116120433.GA14579@lst.de> (Christoph Hellwig's message of
	"Tue, 16 Jan 2018 13:04:33 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi, Christoph,

Christoph Hellwig <hch@lst.de> writes:

> On Mon, Jan 15, 2018 at 09:53:10AM +0100, Christoph Hellwig wrote:
>> > pselect, as an example, crams the sigmask and size together.  Why not
>> > just do that?  libaio can take care of setting that up.
>> 
>> Yes, I could try that.  It's just another double indirection for no
>> good reason.
>
> I cna't get this to work - for some reason I always end up with a NULL
> sigmask in the kernel.  Nevermind that it leads to really crap code
> generation.  I guess for select the latter doesn't matter too much as
> everyone sane uses ppoll anyway.

I'd be willing to bet the issue is in your io_syscall6 implementation.
You pass in arg5 where arg6 should be used.  Don't feel bad, it took me
the better part of today to figure that out.  :)

Here's an incremental diff on top of what you've posted.  Feel free to
fold it into your patch (and format however you like).  You can find the
libaio changes in my 'aio-poll' branch:
  https://pagure.io/libaio/commits/aio-poll

These changes were run through the libaio test harness, 64 bit and 32
bit, so the compat system call was tested.

Cheers,
Jeff

diff --git a/fs/aio.c b/fs/aio.c
index 57a4e8d..c6d67d0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1991,9 +1991,11 @@ static long do_io_getevents(aio_context_t ctx_id,
 		long, nr,
 		struct io_event __user *, events,
 		struct timespec __user *, timeout,
-		const sigset_t __user *, sigmask)
+		void __user *, sigmask)
 {
 	sigset_t		ksigmask, sigsaved;
+	size_t			sigsetsize = 0;
+	sigset_t __user		*up = NULL;
 	struct timespec64	ts;
 	int ret;
 
@@ -2001,8 +2003,18 @@ static long do_io_getevents(aio_context_t ctx_id,
 		return -EFAULT;
 
 	if (sigmask) {
-		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+		if (!access_ok(VERIFY_READ, sigmask,
+			       sizeof(void *) + sizeof(size_t)) ||
+		    __get_user(up, (sigset_t __user * __user *)sigmask) ||
+		    __get_user(sigsetsize,
+			       (size_t __user *)(sigmask + sizeof(void *))))
 			return -EFAULT;
+
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, up, sizeof(ksigmask)))
+			return -EFAULT;
+
 		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
@@ -2049,8 +2061,11 @@ static long do_io_getevents(aio_context_t ctx_id,
 		compat_long_t, nr,
 		struct io_event __user *, events,
 		struct compat_timespec __user *, timeout,
-		const compat_sigset_t __user *, sigmask)
+		void __user *, sig)
 {
+	compat_size_t sigsetsize = 0;
+	compat_sigset_t __user *sigmask;
+	compat_uptr_t up = 0;
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
 	int ret;
@@ -2058,8 +2073,17 @@ static long do_io_getevents(aio_context_t ctx_id,
 	if (timeout && compat_get_timespec64(&t, timeout))
 		return -EFAULT;
 
-	if (sigmask) {
-		if (get_compat_sigset(&ksigmask, sigmask))
+	if (sig) {
+		if (!access_ok(VERIFY_READ, sig,
+			sizeof(compat_uptr_t) + sizeof(compat_size_t)) ||
+		    __get_user(up, (compat_uptr_t __user *)sig) ||
+		    __get_user(sigsetsize,
+			       (compat_size_t __user *)(sig + sizeof(up))))
+			return -EFAULT;
+
+		if (sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (get_compat_sigset(&ksigmask, compat_ptr(up)))
 			return -EFAULT;
 		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index a4cda98..32412f8 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -541,7 +541,7 @@ asmlinkage long compat_sys_io_pgetevents(compat_aio_context_t ctx_id,
 					compat_long_t nr,
 					struct io_event __user *events,
 					struct compat_timespec __user *timeout,
-					const compat_sigset_t __user *sigmask);
+					void __user *sigmask);
 asmlinkage long compat_sys_io_submit(compat_aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
 asmlinkage long compat_sys_mount(const char __user *dev_name,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3bc9a13..bc79026 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -544,7 +544,7 @@ asmlinkage long sys_io_pgetevents(aio_context_t ctx_id,
 				long nr,
 				struct io_event __user *events,
 				struct timespec __user *timeout,
-				const sigset_t __user *sigmask);
+				void __user *sigmask);
 asmlinkage long sys_io_submit(aio_context_t, long,
 				struct iocb __user * __user *);
 asmlinkage long sys_io_cancel(aio_context_t ctx_id, struct iocb __user *iocb,

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
