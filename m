From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/17] y2038: utimes: Rework #ifdef guards for compat syscalls
Date: Wed, 25 Apr 2018 18:03:02 +0200
Message-ID: <20180425160311.2718314-9-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

After changing over to 64-bit time_t syscalls, many architectures will
want compat_sys_utimensat() but not respective handlers for utime(),
utimes() and futimesat(). This adds a new __ARCH_WANT_COMPAT_SYS_UTIME
to complement __ARCH_WANT_SYS_UTIME. For now, all 64-bit architectures
that support CONFIG_COMPAT set it, but future 64-bit architectures will
not (tile would not have needed it either, but got removed).

As older 32-bit architectures get converted to using CONFIG_64BIT_TIME,
they will have to use __ARCH_WANT_COMPAT_SYS_UTIME instead of
__ARCH_WANT_SYS_UTIME. Architectures using the generic syscall ABI
don't need either of them.

Since the compat_utimbuf structure is now required outside of
CONFIG_COMPAT, I'm moving it into compat_time.h.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/unistd.h   | 1 +
 arch/mips/include/asm/unistd.h    | 1 +
 arch/parisc/include/asm/unistd.h  | 1 +
 arch/powerpc/include/asm/unistd.h | 1 +
 arch/s390/include/asm/unistd.h    | 1 +
 arch/sparc/include/asm/unistd.h   | 1 +
 arch/x86/include/asm/unistd.h     | 1 +
 fs/utimes.c                       | 6 +++++-
 include/linux/compat.h            | 5 -----
 include/linux/compat_time.h       | 5 +++++
 10 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 5c3c1398c62e..c4df478039f3 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -22,6 +22,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_UTIME
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
 
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index c2174b80e50e..f47058485f7f 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -31,6 +31,7 @@
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_COMPAT_SYS_UTIME
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_GETPGRP
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index a0c38374fff0..62ffafda0d50 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -152,6 +152,7 @@ type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_COMPAT_SYS_UTIME
 #define __ARCH_WANT_SYS_WAITPID
 #define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index fb8fb304ceaf..3190c86e03ba 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -47,6 +47,7 @@
 #endif
 #ifdef CONFIG_PPC64
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_COMPAT_SYS_UTIME
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index a2d583ea526d..b4ba7781d396 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -34,6 +34,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 # ifdef CONFIG_COMPAT
 #   define __ARCH_WANT_COMPAT_SYS_TIME
+#   define __ARCH_WANT_COMPAT_SYS_UTIME
 # endif
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index f7514d3eae7b..610f6a8a14de 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -42,6 +42,7 @@
 #define __ARCH_WANT_SYS_IPC
 #else
 #define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_COMPAT_SYS_UTIME
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 153d2a5e6b02..7d784b8bceb4 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -24,6 +24,7 @@
 #  include <asm/unistd_64.h>
 #  include <asm/unistd_64_x32.h>
 #  define __ARCH_WANT_COMPAT_SYS_TIME
+#  define __ARCH_WANT_COMPAT_SYS_UTIME
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64
 #  define __ARCH_WANT_COMPAT_SYS_PWRITEV64
 #  define __ARCH_WANT_COMPAT_SYS_PREADV64V2
diff --git a/fs/utimes.c b/fs/utimes.c
index ebc7fb713d91..6318443de15d 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -218,11 +218,12 @@ SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
 }
 #endif
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 /*
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
  */
+#ifdef __ARCH_WANT_COMPAT_SYS_UTIME
 COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 		       struct compat_utimbuf __user *, t)
 {
@@ -237,6 +238,7 @@ COMPAT_SYSCALL_DEFINE2(utime, const char __user *, filename,
 	}
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
+#endif
 
 COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filename, struct compat_timespec __user *, t, int, flags)
 {
@@ -253,6 +255,7 @@ COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, const char __user *, filena
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
+#ifdef __ARCH_WANT_COMPAT_SYS_UTIME
 static long do_compat_futimesat(unsigned int dfd, const char __user *filename,
 				struct compat_timeval __user *t)
 {
@@ -285,3 +288,4 @@ COMPAT_SYSCALL_DEFINE2(utimes, const char __user *, filename, struct compat_time
 	return do_compat_futimesat(AT_FDCWD, filename, t);
 }
 #endif
+#endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index af5ac9de4bdf..7887b0a54c1e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -112,11 +112,6 @@ struct compat_itimerspec {
 	struct compat_timespec it_value;
 };
 
-struct compat_utimbuf {
-	compat_time_t		actime;
-	compat_time_t		modtime;
-};
-
 struct compat_itimerval {
 	struct compat_timeval	it_interval;
 	struct compat_timeval	it_value;
diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
index 31f2774f1994..d1a787821168 100644
--- a/include/linux/compat_time.h
+++ b/include/linux/compat_time.h
@@ -17,6 +17,11 @@ struct compat_timeval {
 	s32		tv_usec;
 };
 
+struct compat_utimbuf {
+	compat_time_t		actime;
+	compat_time_t		modtime;
+};
+
 extern int compat_get_timespec64(struct timespec64 *, const void __user *);
 extern int compat_put_timespec64(const struct timespec64 *, void __user *);
 
-- 
2.9.0
