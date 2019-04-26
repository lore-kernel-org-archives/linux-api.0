From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] y2038: remove CONFIG_64BIT_TIME
Date: Fri, 26 Apr 2019 16:25:05 +0200
Message-ID: <20190426142531.1378357-2-arnd@arndb.de>
References: <20190426142531.1378357-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190426142531.1378357-1-arnd@arndb.de>
Sender: owner-linux-aio@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Joseph Myers <joseph@codesourcery.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, John Stultz <john.stultz@linaro.org>, Stephen Boyd <sboyd@kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The CONFIG_64BIT_TIME option is defined on all architectures, and can
be removed for simplicity now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This would make sense for 5.2, or could be part of a later
cleanup series when I have more patches for the remaining
y2038 bits
---
 arch/Kconfig          | 8 --------
 fs/aio.c              | 2 +-
 ipc/syscall.c         | 2 +-
 kernel/time/hrtimer.c | 2 +-
 kernel/time/time.c    | 4 ++--
 net/socket.c          | 2 +-
 6 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9092e0ffe4d3..23ee740182aa 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -763,14 +763,6 @@ config OLD_SIGACTION
 config COMPAT_OLD_SIGACTION
 	bool
 
-config 64BIT_TIME
-	def_bool y
-	help
-	  This should be selected by all architectures that need to support
-	  new system calls with a 64-bit time_t. This is relevant on all 32-bit
-	  architectures, and 64-bit architectures as part of compat syscall
-	  handling.
-
 config COMPAT_32BIT_TIME
 	def_bool !64BIT || COMPAT
 	help
diff --git a/fs/aio.c b/fs/aio.c
index 3490d1fa0e16..b1b949ae1a93 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2057,7 +2057,7 @@ static long do_io_getevents(aio_context_t ctx_id,
  *	specifies an infinite timeout. Note that the timeout pointed to by
  *	timeout is relative.  Will fail with -ENOSYS if not implemented.
  */
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 
 SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 581bdff4e7c5..dfb0e988d542 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -30,7 +30,7 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 		return ksys_semtimedop(first, (struct sembuf __user *)ptr,
 				       second, NULL);
 	case SEMTIMEDOP:
-		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+		if (IS_ENABLED(CONFIG_64BIT))
 			return ksys_semtimedop(first, ptr, second,
 			        (const struct __kernel_timespec __user *)fifth);
 		else if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 41dfff23c1f9..61f03faf783a 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1749,7 +1749,7 @@ long hrtimer_nanosleep(const struct timespec64 *rqtp,
 	return ret;
 }
 
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 
 SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 		struct __kernel_timespec __user *, rmtp)
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 74105fa3ce80..a4c72577aa92 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -264,7 +264,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
 }
 #endif
 
-#if !defined(CONFIG_64BIT_TIME) || defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 SYSCALL_DEFINE1(adjtimex, struct __kernel_timex __user *, txc_p)
 {
 	struct __kernel_timex txc;		/* Local copy of parameter */
@@ -871,7 +871,7 @@ int get_timespec64(struct timespec64 *ts,
 	ts->tv_sec = kts.tv_sec;
 
 	/* Zero out the padding for 32 bit systems or in compat mode */
-	if (IS_ENABLED(CONFIG_64BIT_TIME) && in_compat_syscall())
+	if (in_compat_syscall())
 		kts.tv_nsec &= 0xFFFFFFFFUL;
 
 	ts->tv_nsec = kts.tv_nsec;
diff --git a/net/socket.c b/net/socket.c
index a180e1a9ff23..2ff80e03d97b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2787,7 +2787,7 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 				    a[2], true);
 		break;
 	case SYS_RECVMMSG:
-		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+		if (IS_ENABLED(CONFIG_64BIT))
 			err = __sys_recvmmsg(a0, (struct mmsghdr __user *)a1,
 					     a[2], a[3],
 					     (struct __kernel_timespec __user *)a[4],
-- 
2.20.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
