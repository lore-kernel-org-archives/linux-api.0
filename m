From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 14/17] y2038: socket: Add compat_sys_recvmmsg_time64
Date: Mon, 16 Jul 2018 18:11:00 +0200
Message-ID: <20180716161103.16239-15-arnd@arndb.de>
References: <20180716161103.16239-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716161103.16239-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net, Arnd Bergmann <arnd@arndb.de>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h |  5 ++++-
 include/linux/socket.h | 15 ++++++++++++++-
 kernel/sys_ni.c        |  1 +
 net/compat.c           | 14 +++++++-------
 net/socket.c           | 39 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ab0b1f48dc5b..0ede0543b84f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -867,7 +867,10 @@ asmlinkage long compat_sys_move_pages(pid_t pid, compat_ulong_t nr_pages,
 asmlinkage long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid,
 					compat_pid_t pid, int sig,
 					struct compat_siginfo __user *uinfo);
-asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+asmlinkage long compat_sys_recvmmsg_time64(int fd, struct compat_mmsghdr __user *mmsg,
+				    unsigned vlen, unsigned int flags,
+				    struct __kernel_timespec __user *timeout);
+asmlinkage long compat_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags,
 				    struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8b571e9b9f76..65b8db095f1d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -2,8 +2,8 @@
 #ifndef _LINUX_SOCKET_H
 #define _LINUX_SOCKET_H
 
-
 #include <asm/socket.h>			/* arch-dependent defines	*/
+#include <linux/errno.h>
 #include <linux/sockios.h>		/* the SIOCxxx I/O controls	*/
 #include <linux/uio.h>			/* iovec support		*/
 #include <linux/types.h>		/* pid_t			*/
@@ -349,6 +349,7 @@ extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_sto
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
+struct compat_timespec;
 
 /* The __sys_...msg variants allow MSG_CMSG_COMPAT iff
  * forbid_cmsg_compat==false
@@ -359,6 +360,18 @@ extern long __sys_sendmsg(int fd, struct user_msghdr __user *msg,
 			  unsigned int flags, bool forbid_cmsg_compat);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec64 *timeout);
+#ifdef CONFIG_COMPAT_32BIT_TIME
+extern int __compat_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+				 unsigned int vlen, unsigned int flags,
+				 struct compat_timespec __user *timeout);
+#else
+static inline int __compat_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+					unsigned int vlen, unsigned int flags,
+					struct compat_timespec __user *timeout)
+{
+	return -EINVAL;
+}
+#endif
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  bool forbid_cmsg_compat);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index df556175be50..c3fdba58565a 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -285,6 +285,7 @@ COND_SYSCALL(perf_event_open);
 COND_SYSCALL(accept4);
 COND_SYSCALL(recvmmsg);
 COND_SYSCALL_COMPAT(recvmmsg);
+COND_SYSCALL_COMPAT(recvmmsg_time64);
 
 /*
  * Architecture specific syscalls: see further below
diff --git a/net/compat.c b/net/compat.c
index 0380fbb9a321..5af2af1b9723 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -812,9 +812,9 @@ COMPAT_SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, buf, compat_size_t, len
 	return __compat_sys_recvfrom(fd, buf, len, flags, addr, addrlen);
 }
 
-static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
+static int __compat_sys_recvmmsg_time64(int fd, struct compat_mmsghdr __user *mmsg,
 				 unsigned int vlen, unsigned int flags,
-				 struct compat_timespec __user *timeout)
+				 struct __kernel_timespec __user *timeout)
 {
 	int datagrams;
 	struct timespec64 ktspec;
@@ -823,22 +823,22 @@ static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
 
-	if (compat_get_timespec64(&ktspec, timeout))
+	if (get_timespec64(&ktspec, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 && compat_put_timespec64(&ktspec, timeout))
+	if (datagrams > 0 && put_timespec64(&ktspec, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
 }
 
-COMPAT_SYSCALL_DEFINE5(recvmmsg, int, fd, struct compat_mmsghdr __user *, mmsg,
+COMPAT_SYSCALL_DEFINE5(recvmmsg_time64, int, fd, struct compat_mmsghdr __user *, mmsg,
 		       unsigned int, vlen, unsigned int, flags,
-		       struct compat_timespec __user *, timeout)
+		       struct __kernel_timespec __user *, timeout)
 {
-	return __compat_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
+	return __compat_sys_recvmmsg_time64(fd, mmsg, vlen, flags, timeout);
 }
 
 COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 __user *, args)
diff --git a/net/socket.c b/net/socket.c
index c0838a278cfd..f4b6be81c6af 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2473,6 +2473,37 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return do_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
 }
 
+#ifdef CONFIG_COMPAT_32BIT_TIME
+int __compat_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
+			  unsigned int vlen, unsigned int flags,
+			  struct compat_timespec __user *timeout)
+{
+	int datagrams;
+	struct timespec64 ktspec;
+
+	if (timeout == NULL)
+		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+				      flags | MSG_CMSG_COMPAT, NULL);
+
+	if (compat_get_timespec64(&ktspec, timeout))
+		return -EFAULT;
+
+	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
+				   flags | MSG_CMSG_COMPAT, &ktspec);
+	if (datagrams > 0 && compat_put_timespec64(&ktspec, timeout))
+		datagrams = -EFAULT;
+
+	return datagrams;
+}
+
+COMPAT_SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
+		       unsigned int, vlen, unsigned int, flags,
+		       struct compat_timespec __user *, timeout)
+{
+	return __compat_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
+}
+#endif
+
 #ifdef __ARCH_WANT_SYS_SOCKETCALL
 /* Argument list sizes for sys_socketcall */
 #define AL(x) ((x) * sizeof(unsigned long))
@@ -2590,8 +2621,12 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 				    a[2], true);
 		break;
 	case SYS_RECVMMSG:
-		err = do_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
-				      a[3], (struct __kernel_timespec __user *)a[4]);
+		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+			err = do_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
+					      a[3], (struct __kernel_timespec __user *)a[4]);
+		else
+			err = __compat_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
+					      a[3], (struct compat_timespec __user *)a[4]);
 		break;
 	case SYS_ACCEPT4:
 		err = __sys_accept4(a0, (struct sockaddr __user *)a1,
-- 
2.9.0
