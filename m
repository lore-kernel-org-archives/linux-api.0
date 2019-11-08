From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/23] y2038: uapi: change __kernel_time_t to __kernel_old_time_t
Date: Fri,  8 Nov 2019 22:12:09 +0100
Message-ID: <20191108211323.1806194-1-arnd@arndb.de>
References: <20191108210236.1296047-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is mainly a patch for clarification, and to let us remove
the time_t definition from the kernel to prevent new users from
creeping in that might not be y2038-safe.

All remaining uses of 'time_t' or '__kernel_time_t' are part of
the user API that cannot be changed by that either have a
replacement or that do not suffer from the y2038 overflow.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h        | 4 ++--
 include/linux/time32.h          | 2 +-
 include/linux/types.h           | 2 +-
 include/uapi/linux/cyclades.h   | 6 +++---
 include/uapi/linux/msg.h        | 6 +++---
 include/uapi/linux/ppp_defs.h   | 4 ++--
 include/uapi/linux/sem.h        | 4 ++--
 include/uapi/linux/shm.h        | 6 +++---
 include/uapi/linux/time.h       | 6 +++---
 include/uapi/linux/time_types.h | 4 ++--
 include/uapi/linux/utime.h      | 4 ++--
 kernel/time/time.c              | 6 +++---
 12 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f7c561c4dcdd..2f27bc9d5ef0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1076,7 +1076,7 @@ asmlinkage long sys_fadvise64(int fd, loff_t offset, size_t len, int advice);
 asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpgrp(void);
 asmlinkage long sys_pause(void);
-asmlinkage long sys_time(time_t __user *tloc);
+asmlinkage long sys_time(__kernel_old_time_t __user *tloc);
 asmlinkage long sys_time32(old_time32_t __user *tloc);
 #ifdef __ARCH_WANT_SYS_UTIME
 asmlinkage long sys_utime(char __user *filename,
@@ -1116,7 +1116,7 @@ asmlinkage long sys_sysfs(int option,
 asmlinkage long sys_fork(void);
 
 /* obsolete: kernel/time/time.c */
-asmlinkage long sys_stime(time_t __user *tptr);
+asmlinkage long sys_stime(__kernel_old_time_t __user *tptr);
 asmlinkage long sys_stime32(old_time32_t __user *tptr);
 
 /* obsolete: kernel/signal.c */
diff --git a/include/linux/time32.h b/include/linux/time32.h
index 0a1f302a1753..cad4c3186002 100644
--- a/include/linux/time32.h
+++ b/include/linux/time32.h
@@ -12,7 +12,7 @@
 #include <linux/time64.h>
 #include <linux/timex.h>
 
-#define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
+#define TIME_T_MAX	(__kernel_old_time_t)((1UL << ((sizeof(__kernel_old_time_t) << 3) - 1)) - 1)
 
 typedef s32		old_time32_t;
 
diff --git a/include/linux/types.h b/include/linux/types.h
index 05030f608be3..e32c1180b742 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -67,7 +67,7 @@ typedef __kernel_ptrdiff_t	ptrdiff_t;
 
 #ifndef _TIME_T
 #define _TIME_T
-typedef __kernel_time_t		time_t;
+typedef __kernel_old_time_t	time_t;
 #endif
 
 #ifndef _CLOCK_T
diff --git a/include/uapi/linux/cyclades.h b/include/uapi/linux/cyclades.h
index 8279bc3d60ca..fc0add2194a9 100644
--- a/include/uapi/linux/cyclades.h
+++ b/include/uapi/linux/cyclades.h
@@ -83,9 +83,9 @@ struct cyclades_monitor {
  * open)
  */
 struct cyclades_idle_stats {
-    __kernel_time_t in_use;	/* Time device has been in use (secs) */
-    __kernel_time_t recv_idle;	/* Time since last char received (secs) */
-    __kernel_time_t xmit_idle;	/* Time since last char transmitted (secs) */
+    __kernel_old_time_t in_use;	/* Time device has been in use (secs) */
+    __kernel_old_time_t recv_idle; /* Time since last char received (secs) */
+    __kernel_old_time_t xmit_idle; /* Time since last char transmitted (secs) */
     unsigned long  recv_bytes;	/* Bytes received */
     unsigned long  xmit_bytes;	/* Bytes transmitted */
     unsigned long  overruns;	/* Input overruns */
diff --git a/include/uapi/linux/msg.h b/include/uapi/linux/msg.h
index e4a0d9a9a9e8..01ee8d54c1c8 100644
--- a/include/uapi/linux/msg.h
+++ b/include/uapi/linux/msg.h
@@ -19,9 +19,9 @@ struct msqid_ds {
 	struct ipc_perm msg_perm;
 	struct msg *msg_first;		/* first message on queue,unused  */
 	struct msg *msg_last;		/* last message in queue,unused */
-	__kernel_time_t msg_stime;	/* last msgsnd time */
-	__kernel_time_t msg_rtime;	/* last msgrcv time */
-	__kernel_time_t msg_ctime;	/* last change time */
+	__kernel_old_time_t msg_stime;	/* last msgsnd time */
+	__kernel_old_time_t msg_rtime;	/* last msgrcv time */
+	__kernel_old_time_t msg_ctime;	/* last change time */
 	unsigned long  msg_lcbytes;	/* Reuse junk fields for 32 bit */
 	unsigned long  msg_lqbytes;	/* ditto */
 	unsigned short msg_cbytes;	/* current number of bytes on queue */
diff --git a/include/uapi/linux/ppp_defs.h b/include/uapi/linux/ppp_defs.h
index 0039fa39a358..20286bd90ab5 100644
--- a/include/uapi/linux/ppp_defs.h
+++ b/include/uapi/linux/ppp_defs.h
@@ -148,8 +148,8 @@ struct ppp_comp_stats {
  * based on the libc time_t.
  */
 struct ppp_idle {
-    __kernel_time_t xmit_idle;	/* time since last NP packet sent */
-    __kernel_time_t recv_idle;	/* time since last NP packet received */
+    __kernel_old_time_t xmit_idle;	/* time since last NP packet sent */
+    __kernel_old_time_t recv_idle;	/* time since last NP packet received */
 };
 
 struct ppp_idle32 {
diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
index 39a1876f039e..75aa3b273cd9 100644
--- a/include/uapi/linux/sem.h
+++ b/include/uapi/linux/sem.h
@@ -24,8 +24,8 @@
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
 	struct ipc_perm	sem_perm;		/* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime;		/* last semop time */
-	__kernel_time_t	sem_ctime;		/* create/last semctl() time */
+	__kernel_old_time_t sem_otime;		/* last semop time */
+	__kernel_old_time_t sem_ctime;		/* create/last semctl() time */
 	struct sem	*sem_base;		/* ptr to first semaphore in array */
 	struct sem_queue *sem_pending;		/* pending operations to be processed */
 	struct sem_queue **sem_pending_last;	/* last pending operation */
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 6507ad0afc81..8d1f17a4e08e 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -28,9 +28,9 @@
 struct shmid_ds {
 	struct ipc_perm		shm_perm;	/* operation perms */
 	int			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-	__kernel_time_t		shm_dtime;	/* last detach time */
-	__kernel_time_t		shm_ctime;	/* last change time */
+	__kernel_old_time_t	shm_atime;	/* last attach time */
+	__kernel_old_time_t	shm_dtime;	/* last detach time */
+	__kernel_old_time_t	shm_ctime;	/* last change time */
 	__kernel_ipc_pid_t	shm_cpid;	/* pid of creator */
 	__kernel_ipc_pid_t	shm_lpid;	/* pid of last operator */
 	unsigned short		shm_nattch;	/* no. of current attaches */
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index 958932effc5e..a655aa28dc6e 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -8,13 +8,13 @@
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
-	__kernel_time_t	tv_sec;			/* seconds */
-	long		tv_nsec;		/* nanoseconds */
+	__kernel_old_time_t	tv_sec;		/* seconds */
+	long			tv_nsec;	/* nanoseconds */
 };
 #endif
 
 struct timeval {
-	__kernel_time_t		tv_sec;		/* seconds */
+	__kernel_old_time_t	tv_sec;		/* seconds */
 	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
diff --git a/include/uapi/linux/time_types.h b/include/uapi/linux/time_types.h
index 60b37f29842d..074e391d73a1 100644
--- a/include/uapi/linux/time_types.h
+++ b/include/uapi/linux/time_types.h
@@ -29,8 +29,8 @@ struct __kernel_old_timeval {
 #endif
 
 struct __kernel_old_timespec {
-	__kernel_time_t	tv_sec;			/* seconds */
-	long		tv_nsec;		/* nanoseconds */
+	__kernel_old_time_t	tv_sec;		/* seconds */
+	long			tv_nsec;	/* nanoseconds */
 };
 
 struct __kernel_sock_timeval {
diff --git a/include/uapi/linux/utime.h b/include/uapi/linux/utime.h
index fd9aa26b6860..bc8f13e81d6e 100644
--- a/include/uapi/linux/utime.h
+++ b/include/uapi/linux/utime.h
@@ -5,8 +5,8 @@
 #include <linux/types.h>
 
 struct utimbuf {
-	__kernel_time_t actime;
-	__kernel_time_t modtime;
+	__kernel_old_time_t actime;
+	__kernel_old_time_t modtime;
 };
 
 #endif
diff --git a/kernel/time/time.c b/kernel/time/time.c
index ddbddf504c23..7eba7c9a7e3e 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -59,9 +59,9 @@ EXPORT_SYMBOL(sys_tz);
  * why not move it into the appropriate arch directory (for those
  * architectures that need it).
  */
-SYSCALL_DEFINE1(time, time_t __user *, tloc)
+SYSCALL_DEFINE1(time, __kernel_old_time_t __user *, tloc)
 {
-	time_t i = (time_t)ktime_get_real_seconds();
+	__kernel_old_time_t i = (__kernel_old_time_t)ktime_get_real_seconds();
 
 	if (tloc) {
 		if (put_user(i,tloc))
@@ -78,7 +78,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
  * architectures that need it).
  */
 
-SYSCALL_DEFINE1(stime, time_t __user *, tptr)
+SYSCALL_DEFINE1(stime, __kernel_old_time_t __user *, tptr)
 {
 	struct timespec64 tv;
 	int err;
-- 
2.20.0
