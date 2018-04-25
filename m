From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/17] y2038: socket: Convert recvmmsg to __kernel_timespec
Date: Wed, 25 Apr 2018 18:03:07 +0200
Message-ID: <20180425160311.2718314-14-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
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
index ea50f4a65816..d36a6c1bdbaf 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -345,7 +345,7 @@ struct ucred {
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
-struct timespec;
+struct timespec64;
 
 /* The __sys_...msg variants allow MSG_CMSG_COMPAT iff
  * forbid_cmsg_compat==false
@@ -355,7 +355,7 @@ extern long __sys_recvmsg(int fd, struct user_msghdr __user *msg,
 extern long __sys_sendmsg(int fd, struct user_msghdr __user *msg,
 			  unsigned int flags, bool forbid_cmsg_compat);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-			  unsigned int flags, struct timespec *timeout);
+			  unsigned int flags, struct timespec64 *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  bool forbid_cmsg_compat);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ffd8674e9df7..eaa32317f573 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -817,7 +817,7 @@ asmlinkage long sys_perf_event_open(
 asmlinkage long sys_accept4(int, struct sockaddr __user *, int __user *, int);
 asmlinkage long sys_recvmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags,
-			     struct timespec __user *timeout);
+			     struct __kernel_timespec __user *timeout);
 
 asmlinkage long sys_wait4(pid_t pid, int __user *stat_addr,
 				int options, struct rusage __user *ru);
diff --git a/net/compat.c b/net/compat.c
index 5ae7437d3853..93b80a3d967c 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -815,18 +815,18 @@ static int __compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				 struct compat_timespec __user *timeout)
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
index f10f1d947c78..4510e6269764 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2343,7 +2343,7 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct user_msghdr __user *, msg,
  */
 
 int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
-		   unsigned int flags, struct timespec *timeout)
+		   unsigned int flags, struct timespec64 *timeout)
 {
 	int fput_needed, err, datagrams;
 	struct socket *sock;
@@ -2408,8 +2408,7 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 		if (timeout) {
 			ktime_get_ts64(&timeout64);
-			*timeout = timespec64_to_timespec(
-					timespec64_sub(end_time, timeout64));
+			*timeout = timespec64_sub(end_time, timeout64);
 			if (timeout->tv_sec < 0) {
 				timeout->tv_sec = timeout->tv_nsec = 0;
 				break;
@@ -2455,10 +2454,10 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
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
@@ -2466,13 +2465,12 @@ static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
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
@@ -2480,7 +2478,7 @@ static int do_sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 
 SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags,
-		struct timespec __user *, timeout)
+		struct __kernel_timespec __user *, timeout)
 {
 	return do_sys_recvmmsg(fd, mmsg, vlen, flags, timeout);
 }
@@ -2603,7 +2601,7 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 		break;
 	case SYS_RECVMMSG:
 		err = do_sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2],
-				      a[3], (struct timespec __user *)a[4]);
+				      a[3], (struct __kernel_timespec __user *)a[4]);
 		break;
 	case SYS_ACCEPT4:
 		err = __sys_accept4(a0, (struct sockaddr __user *)a1,
-- 
2.9.0
