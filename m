From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/14] y2038: utimes: Rework #ifdef guards for compat syscalls
Date: Mon, 27 Aug 2018 21:45:28 +0200
Message-ID: <20180827194531.3796559-12-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

After changing over to 64-bit time_t syscalls, many architectures will
want compat_sys_utimensat() but not respective handlers for utime(),
utimes() and futimesat(). This adds a new __ARCH_WANT_SYS_UTIME32 to
complement __ARCH_WANT_SYS_UTIME. For now, all 64-bit architectures that
support CONFIG_COMPAT set it, but future 64-bit architectures will not
(tile would not have needed it either, but got removed).

As older 32-bit architectures get converted to using CONFIG_64BIT_TIME,
they will have to use __ARCH_WANT_SYS_UTIME32 instead of
__ARCH_WANT_SYS_UTIME. Architectures using the generic syscall ABI don't
need either of them as they never had a utime syscall.

Since the compat_utimbuf structure is now required outside of
CONFIG_COMPAT, I'm moving it into compat_time.h.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changed from last version:
- renamed __ARCH_WANT_COMPAT_SYS_UTIME to __ARCH_WANT_SYS_UTIME32
---
 arch/arm64/include/asm/unistd.h   | 1 +
 arch/mips/include/asm/unistd.h    | 1 +
 arch/parisc/include/asm/unistd.h  | 1 +
 arch/powerpc/include/asm/unistd.h | 1 +
 arch/s390/include/asm/unistd.h    | 1 +
 arch/sparc/include/asm/unistd.h   | 1 +
 arch/x86/include/asm/unistd.h     | 1 +
 fs/utimes.c                       | 8 ++++++--
 include/linux/compat.h            | 7 +------
 include/linux/time32.h            | 5 +++++
 10 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 2af308f13463..b13ca091f833 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -22,6 +22,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
 
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index c2174b80e50e..c68b8ae3efcb 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -31,6 +31,7 @@
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index a0c38374fff0..bc37a4953eaa 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -152,6 +152,7 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 9326c9133516..b0de85b477e1 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -47,6 +47,7 @@
 #endif
 #ifdef CONFIG_PPC64
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index a2d583ea526d..a1fbf15d53aa 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -34,6 +34,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 # ifdef CONFIG_COMPAT
 #   define __ARCH_WANT_COMPAT_SYS_TIME
+#   define __ARCH_WANT_SYS_UTIME32
 # endif
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index f7514d3eae7b..00f87dbd0b17 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -42,6 +42,7 @@
 #define __ARCH_WANT_SYS_IPC
 #else
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME32
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 153d2a5e6b02..dc4ed8bc2382 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -24,6 +24,7 @@
 #  include <asm/unistd_64.h>
 #  include <asm/unistd_64_x32.h>
 #  define __ARCH_WANT_COMPAT_SYS_TIME
+#  define __ARCH_WANT_SYS_UTIME32
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64
 #  define __ARCH_WANT_COMPAT_SYS_PWRITEV64
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64V2
diff --git a/fs/utimes.c b/fs/utimes.c
index 2f6f08061a26..bdcf2daf39c1 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -218,13 +218,14 @@ SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
 }
 #endif
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 /*
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
  */
+#ifdef __ARCH_WANT_SYS_UTIME32
 COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
-		       struct compat_utimbuf __user *, t)
+		       struct old_utimbuf32 __user *, t)
 {
 	struct timespec64 tv[2];
 
@@ -237,6 +238,7 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 	}
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
+#endif
 
 COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
 {
@@ -253,6 +255,7 @@ COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filena
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
+#ifdef __ARCH_WANT_SYS_UTIME32
 static long do_compat_futimesat(unsigned int dfd, const char __user *filename,
 				struct old_timeval32 __user *t)
 {
@@ -285,3 +288,4 @@ COMPAT_SYSCALL_DEFINE2(utimes, const char __user *, filename, struct old_timeval
 	return do_compat_futimesat(AT_FDCWD, filename, t);
 }
 #endif
+#endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index d376fa8be00d..6fb5abdb87be 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -113,11 +113,6 @@ typedef __compat_gid32_t	compat_gid_t;
 struct compat_sel_arg_struct;
 struct rusage;
 
-struct compat_utimbuf {
-	old_time32_t		actime;
-	old_time32_t		modtime;
-};
-
 struct compat_itimerval {
 	struct old_timeval32	it_interval;
 	struct old_timeval32	it_value;
@@ -942,7 +937,7 @@ asmlinkage long compat_sys_newlstat(const char __user *filename,
 /* __ARCH_WANT_SYSCALL_DEPRECATED */
 asmlinkage long compat_sys_time(old_time32_t __user *tloc);
 asmlinkage long compat_sys_utime(const char __user *filename,
-				 struct compat_utimbuf __user *t);
+				 struct old_utimbuf32 __user *t);
 asmlinkage long compat_sys_futimesat(unsigned int dfd,
 				     const char __user *filename,
 				     struct old_timeval32 __user *t);
diff --git a/include/linux/time32.h b/include/linux/time32.h
index 0e0d7304d1a8..61904a6c098f 100644
--- a/include/linux/time32.h
+++ b/include/linux/time32.h
@@ -30,6 +30,11 @@ struct old_itimerspec32 {
 	struct old_timespec32 it_value;
 };
 
+struct old_utimbuf32 {
+	old_time32_t	actime;
+	old_time32_t	modtime;
+};
+
 extern int get_old_timespec32(struct timespec64 *, const void __user *);
 extern int put_old_timespec32(const struct timespec64 *, void __user *);
 extern int get_old_itimerspec32(struct itimerspec64 *its,
-- 
2.18.0
