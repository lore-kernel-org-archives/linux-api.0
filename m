From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/5] y2038: socket: Add compat_sys_recvmmsg_time64
Date: Fri,  7 Dec 2018 22:18:06 +0100
Message-ID: <20181207211808.328719-4-arnd@arndb.de>
References: <20181207211808.328719-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207211808.328719-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

recvmmsg() takes two arguments to pointers of structures that differ
between 32-bit and 64-bit architectures: mmsghdr and timespec.

For y2038 compatbility, we are changing the native system call from
timespec to __kernel_timespec with a 64-bit time_t (in another patch),
and use the existing compat system call on both 32-bit and 64-bit
architectures for compatibility with traditional 32-bit user space.

As we now have two variants of recvmmsg() for 32-bit tasks that are both
different from the variant that we use on 64-bit tasks, this means we
also require two compat system calls!

The solution I picked is to flip things around: The existing
compat_sys_recvmmsg() call gets moved from net/compat.c into net/socket.c
and now handles the case for old user space on all architectures that
have set CONFIG_COMPAT_32BIT_TIME.  A new compat_sys_recvmmsg_time64()
call gets added in the old place for 64-bit architectures only, this
one handles the case of a compat mmsghdr structure combined with
__kernel_timespec.

In the indirect sys_socketcall(), we now need to call either
do_sys_recvmmsg() or __compat_sys_recvmmsg(), depending on what kind of
architecture we are on. For compat_sys_socketcall(), no such change is
needed, we always call __compat_sys_recvmmsg().

I decided to not add a new SYS_RECVMMSG_TIME64 socketcall: Any libc
implementation for 64-bit time_t will need significant changes including
an updated asm/unistd.h, and it seems better to consistently use the
separate syscalls that configuration, leaving the socketcall only for
backward compatibility with 32-bit time_t based libc.

The naming is asymmetric for the moment, so both existing syscalls
entry points keep their names, while the new ones are recvmmsg_time32
and compat_recvmmsg_time64 respectively. I expect that we will rename
the compat syscalls later as we start using generated syscall tables
everywhere and add these entry points.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h   |  5 +++-
 include/linux/socket.h   |  9 ++++--
 include/linux/syscalls.h |  3 ++
 kernel/sys_ni.c          |  2 ++
 net/compat.c             | 34 ++++++++--------------
 net/socket.c             | 62 +++++++++++++++++++++++++++++-----------
 6 files changed, 73 insertions(+), 42 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 8be8daa38c9a..72969d303434 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -893,7 +893,10 @@ asmlinkage long compat_sys_move_pages(pid_t pid, compat_ulong_t nr_pages,
 asmlinkage long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid,
 					compat_pid_t pid, int sig,
 					struct compat_siginfo __user *uinfo);
-asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+asmlinkage long compat_sys_recvmmsg_time64(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags,
+				    struct __kernel_timespec __user *timeout);
+asmlinkage long compat_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags,
 				    struct old_timespec32 __user *timeout);
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8b571e9b9f76..333b5df8a1b2 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -348,7 +348,8 @@ struct ucred {
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
-struct timespec64;
+struct __kernel_timespec;
+struct old_timespec32;
 
 /* The __sys_...msg variants allow MSG_CMSG_COMPAT iff
  * forbid_cmsg_compat==false
@@ -357,8 +358,10 @@ extern long __sys_recvmsg(int fd, struct user_msghdr __user *msg,
 			  unsigned int flags, bool forbid_cmsg_compat);
 extern long __sys_sendmsg(int fd, struct user_msghdr __user *msg,
 			  unsigned int flags, bool forbid_cmsg_compat);
-extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-			  unsigned int flags, struct timespec64 *timeout);
+extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+			  unsigned int vlen, unsigned int flags,
+			  struct __kernel_timespec __user *timeout,
+			  struct old_timespec32 __user *timeout32);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  bool forbid_cmsg_compat);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 247ad9eca955..03cda6793be3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -843,6 +843,9 @@ asmlinkage long sys_accept4(int, struct sockaddr __user *, int __user *, int);
 asmlinkage long sys_recvmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags,
 			     struct __kernel_timespec __user *timeout);
+asmlinkage long sys_recvmmsg_time32(int fd, struct mmsghdr __user *msg,
+			     unsigned int vlen, unsigned flags,
+			     struct old_timespec32 __user *timeout);
 
 asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
 				int options, struct rusage __user *ru);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index df556175be50..ab9d0e3c6d50 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -284,7 +284,9 @@ COND_SYSCALL_COMPAT(move_pages);
 COND_SYSCALL(perf_event_open);
 COND_SYSCALL(accept4);
 COND_SYSCALL(recvmmsg);
+COND_SYSCALL(recvmmsg_time32);
 COND_SYSCALL_COMPAT(recvmmsg);
+COND_SYSCALL_COMPAT(recvmmsg_time64);
 
 /*
  * Architecture specific syscalls: see further below
diff --git a/net/compat.c b/net/compat.c
index 47a614b370cd..f7084780a8f8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -810,34 +810,23 @@ COMPAT_SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, buf, compat_size_t, len
 	return __compat_sys_recvfrom(fd, buf, len, flags, addr, addrlen);
 }
 
-static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
-				 unsigned int vlen, unsigned int flags,
-				 struct old_timespec32 __user *timeout)
+COMPAT_SYSCALL_DEFINE5(recvmmsg_time64, int, fd, struct compat_mmsghdr __user *, mmsg,
+		       unsigned int, vlen, unsigned int, flags,
+		       struct __kernel_timespec __user *, timeout)
 {
-	int datagrams;
-	struct timespec64 ktspec;
-
-	if (timeout == NULL)
-		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
-				      flags | MSG_CMSG_COMPAT, NULL);
-
-	if (compat_get_timespec64(&ktspec, timeout))
-		return -EFAULT;
-
-	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
-				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 && compat_put_timespec64(&ktspec, timeout))
-		datagrams = -EFAULT;
-
-	return datagrams;
+	return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+			      flags | MSG_CMSG_COMPAT, timeout, NULL);
 }
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE5(recvmmsg, int, fd, struct compat_mmsghdr __user *, mmsg,
 		       unsigned int, vlen, unsigned int, flags,
 		       struct old_timespec32 __user *, timeout)
 {
-	return __compat_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
+	return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+			      flags | MSG_CMSG_COMPAT, NULL, timeout);
 }
+#endif
 
 COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 __user *, args)
 {
@@ -925,8 +914,9 @@ COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 __user *, args)
 		ret = __compat_sys_recvmsg(a0, compat_ptr(a1), a[2]);
 		break;
 	case SYS_RECVMMSG:
-		ret = __compat_sys_recvmmsg(a0, compat_ptr(a1), a[2], a[3],
-					    compat_ptr(a[4]));
+		ret = __sys_recvmmsg(a0, compat_ptr(a1), a[2],
+				     a[3] | MSG_CMSG_COMPAT, NULL,
+				     compat_ptr(a[4]));
 		break;
 	case SYS_ACCEPT4:
 		ret = __sys_accept4(a0, compat_ptr(a1), compat_ptr(a[2]), a[3]);
diff --git a/net/socket.c b/net/socket.c
index 593826e11a53..f6a2d3a7b611 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2341,8 +2341,9 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct user_msghdr __user *, msg,
  *     Linux recvmmsg interface
  */
 
-int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-		   unsigned int flags, struct timespec64 *timeout)
+static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+			  unsigned int vlen, unsigned int flags,
+			  struct timespec64 *timeout)
 {
 	int fput_needed, err, datagrams;
 	struct socket *sock;
@@ -2451,25 +2452,32 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 	return datagrams;
 }
 
-static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
-			   unsigned int vlen, unsigned int flags,
-			   struct __kernel_timespec __user *timeout)
+int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+		   unsigned int vlen, unsigned int flags,
+		   struct __kernel_timespec __user *timeout,
+		   struct old_timespec32 __user *timeout32)
 {
 	int datagrams;
 	struct timespec64 timeout_sys;
 
-	if (flags & MSG_CMSG_COMPAT)
-		return -EINVAL;
-
-	if (!timeout)
-		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
+	if (timeout && get_timespec64(&timeout_sys, timeout))
+		return -EFAULT;
 
-	if (get_timespec64(&timeout_sys, timeout))
+	if (timeout32 && get_old_timespec32(&timeout_sys, timeout32))
 		return -EFAULT;
 
-	datagrams = __sys_recvmmsg(fd, mmsg, vlen, flags, &timeout_sys);
+	if (!timeout && !timeout32)
+		do_recvmmsg(fd, mmsg, vlen, flags, NULL);
+
+	datagrams = do_recvmmsg(fd, mmsg, vlen, flags, &timeout_sys);
 
-	if (datagrams > 0 && put_timespec64(&timeout_sys, timeout))
+	if (!datagrams)
+		return 0;
+
+	if (timeout && put_timespec64(&timeout_sys, timeout))
+		datagrams = -EFAULT;
+
+	if (timeout32 && put_old_timespec32(&timeout_sys, timeout32))
 		datagrams = -EFAULT;
 
 	return datagrams;
@@ -2479,8 +2487,23 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags,
 		struct __kernel_timespec __user *, timeout)
 {
-	return do_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
+	return __sys_recvmmsg(fd, mmsg, vlen, flags, timeout, NULL);
+}
+
+#ifdef CONFIG_COMPAT_32BIT_TIME
+SYSCALL_DEFINE5(recvmmsg_time32, int, fd, struct mmsghdr __user *, mmsg,
+		unsigned int, vlen, unsigned int, flags,
+		struct old_timespec32 __user *, timeout)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
+	return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL, timeout);
 }
+#endif
 
 #ifdef __ARCH_WANT_SYS_SOCKETCALL
 /* Argument list sizes for sys_socketcall */
@@ -2600,8 +2623,15 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 				    a[2], true);
 		break;
 	case SYS_RECVMMSG:
-		err = do_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
-				      a[3], (struct __kernel_timespec __user *)a[4]);
+		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+			err = __sys_recvmmsg(a0, (struct mmsghdr __user *)a1,
+					     a[2], a[3],
+					     (struct __kernel_timespec __user *)a[4],
+					     NULL);
+		else
+			err = __sys_recvmmsg(a0, (struct mmsghdr __user *)a1,
+					     a[2], a[3], NULL,
+					     (struct old_timespec32 __user *)a[4]);
 		break;
 	case SYS_ACCEPT4:
 		err = __sys_accept4(a0, (struct sockaddr __user *)a1,
-- 
2.18.0
