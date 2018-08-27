From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/14] y2038: socket: Change recvmmsg to use __kernel_timespec
Date: Mon, 27 Aug 2018 21:45:30 +0200
Message-ID: <20180827194531.3796559-14-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This converts the recvmmsg() system call in all its variations to use
'timespec64' internally for its timeout, and have a __kernel_timespec64
argument in the native entry point. This lets us change the type to use
64-bit time_t at a later point while using the 32-bit compat system call
emulation for existing user space.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/socket.h   |  4 ++--
 include/linux/syscalls.h |  2 +-
 net/compat.c             |  6 +++---
 net/socket.c             | 18 ++++++++----------
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 7ed4713d5337..8b571e9b9f76 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -348,7 +348,7 @@ struct ucred {
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
-struct timespec;
+struct timespec64;
 
 /* The __sys_...msg variants allow MSG_CMSG_COMPAT iff
  * forbid_cmsg_compat==false
@@ -358,7 +358,7 @@ extern long __sys_recvmsg(int fd, struct user_msghdr __user *msg,
 extern long __sys_sendmsg(int fd, struct user_msghdr __user *msg,
 			  unsigned int flags, bool forbid_cmsg_compat);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-			  unsigned int flags, struct timespec *timeout);
+			  unsigned int flags, struct timespec64 *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  bool forbid_cmsg_compat);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5642016a312d..fb3a05fab8aa 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -830,7 +830,7 @@ asmlinkage long sys_perf_event_open(
 asmlinkage long sys_accept4(int, struct sockaddr __user *, int __user *, int);
 asmlinkage long sys_recvmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags,
-			     struct timespec __user *timeout);
+			     struct __kernel_timespec __user *timeout);
 
 asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
 				int options, struct rusage __user *ru);
diff --git a/net/compat.c b/net/compat.c
index 2ef160876bc1..47a614b370cd 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -815,18 +815,18 @@ static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				 struct old_timespec32 __user *timeout)
 {
 	int datagrams;
-	struct timespec ktspec;
+	struct timespec64 ktspec;
 
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
 
-	if (compat_get_timespec(&ktspec, timeout))
+	if (compat_get_timespec64(&ktspec, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 && compat_put_timespec(&ktspec, timeout))
+	if (datagrams > 0 && compat_put_timespec64(&ktspec, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
diff --git a/net/socket.c b/net/socket.c
index e6945e318f02..b9d71b503720 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2340,7 +2340,7 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct user_msghdr __user *, msg,
  */
 
 int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-		   unsigned int flags, struct timespec *timeout)
+		   unsigned int flags, struct timespec64 *timeout)
 {
 	int fput_needed, err, datagrams;
 	struct socket *sock;
@@ -2405,8 +2405,7 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 		if (timeout) {
 			ktime_get_ts64(&timeout64);
-			*timeout = timespec64_to_timespec(
-					timespec64_sub(end_time, timeout64));
+			*timeout = timespec64_sub(end_time, timeout64);
 			if (timeout->tv_sec < 0) {
 				timeout->tv_sec = timeout->tv_nsec = 0;
 				break;
@@ -2452,10 +2451,10 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 			   unsigned int vlen, unsigned int flags,
-			   struct timespec __user *timeout)
+			   struct __kernel_timespec __user *timeout)
 {
 	int datagrams;
-	struct timespec timeout_sys;
+	struct timespec64 timeout_sys;
 
 	if (flags & MSG_CMSG_COMPAT)
 		return -EINVAL;
@@ -2463,13 +2462,12 @@ static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
-	if (copy_from_user(&timeout_sys, timeout, sizeof(timeout_sys)))
+	if (get_timespec64(&timeout_sys, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, mmsg, vlen, flags, &timeout_sys);
 
-	if (datagrams > 0 &&
-	    copy_to_user(timeout, &timeout_sys, sizeof(timeout_sys)))
+	if (datagrams > 0 && put_timespec64(&timeout_sys, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
@@ -2477,7 +2475,7 @@ static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 
 SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags,
-		struct timespec __user *, timeout)
+		struct __kernel_timespec __user *, timeout)
 {
 	return do_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
 }
@@ -2601,7 +2599,7 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 		break;
 	case SYS_RECVMMSG:
 		err = do_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
-				      a[3], (struct timespec __user *)a[4]);
+				      a[3], (struct __kernel_timespec __user *)a[4]);
 		break;
 	case SYS_ACCEPT4:
 		err = __sys_accept4(a0, (struct sockaddr __user *)a1,
-- 
2.18.0
