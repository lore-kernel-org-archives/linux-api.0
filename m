From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/17] y2038: Compile utimes()/futimesat() conditionally
Date: Wed, 25 Apr 2018 18:03:01 +0200
Message-ID: <20180425160311.2718314-8-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <libc-alpha-return-91849-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

There are four generations of utimes() syscalls: utime(), utimes(),
futimesat() and utimensat(), each one being a superset of the previous
one. For y2038 support, we have to add another one, which is the same
as the existing utimensat() but always passes 64-bit times_t based
timespec values.

There are currently 10 architectures that only use utimensat(), two
that use utimes(), futimesat() and utimensat() but not utime(), and 11
architectures that have all four, and those define __ARCH_WANT_SYS_UTIME
in order to get a sys_utime implementation. Since all the new
architectures only want utimensat(), moving all the legacy entry points
into a common __ARCH_WANT_SYS_UTIME guard simplifies the logic. Only alpha
and ia64 grow a tiny bit as they now also get an unused sys_utime(),
but it didn't seem worth the extra complexity of adding yet another
ifdef for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/unistd.h |  1 +
 arch/arm/include/asm/unistd.h   |  2 +-
 arch/ia64/include/asm/unistd.h  |  1 +
 fs/utimes.c                     | 51 ++++++++++++++++++-----------------------
 include/linux/syscalls.h        | 10 ++++----
 5 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index edc090470023..9ff37aa1165f 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -14,6 +14,7 @@
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 8f1159c26f20..88ef2ce1f69a 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -26,13 +26,13 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
+#define __ARCH_WANT_SYS_UTIME
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_SOCKETCALL
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index c5b2620c4a4c..49e34db2529c 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -29,6 +29,7 @@
 #define __IGNORE_umount2	/* umount() */
 
 #define __ARCH_WANT_NEW_STAT
+#define __ARCH_WANT_SYS_UTIME
 
 #if !defined(__ASSEMBLY__) && !defined(ASSEMBLER)
 
diff --git a/fs/utimes.c b/fs/utimes.c
index ca2c02a7985c..ebc7fb713d91 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,35 +8,6 @@
 #include <linux/compat.h>
 #include <asm/unistd.h>
 
-#ifdef __ARCH_WANT_SYS_UTIME
-
-/*
- * sys_utime() can be implemented in user-level using sys_utimes().
- * Is this for backwards compatibility?  If so, why not move it
- * into the appropriate arch directory (for those architectures that
- * need it).
- */
-
-/* If times==NULL, set access and modification to current time,
- * must be owner or have write permission.
- * Else, update from *times, must be owner or super user.
- */
-SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
-{
-	struct timespec64 tv[2];
-
-	if (times) {
-		if (get_user(tv[0].tv_sec, &times->actime) ||
-		    get_user(tv[1].tv_sec, &times->modtime))
-			return -EFAULT;
-		tv[0].tv_nsec = 0;
-		tv[1].tv_nsec = 0;
-	}
-	return do_utimes(AT_FDCWD, filename, times ? tv : NULL, 0);
-}
-
-#endif
-
 static bool nsec_valid(long nsec)
 {
 	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
@@ -184,6 +155,13 @@ SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
 	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
 }
 
+#ifdef __ARCH_WANT_SYS_UTIME
+/*
+ * futimesat(), utimes() and utime() are older versions of utimensat()
+ * that are provided for compatibility with traditional C libraries.
+ * On modern architectures, we always use libc wrappers around
+ * utimensat() instead.
+ */
 static long do_futimesat(int dfd, const char __user *filename,
 			 struct timeval __user *utimes)
 {
@@ -225,6 +203,21 @@ SYSCALL_DEFINE2(utimes, char __user *, filename,
 	return do_futimesat(AT_FDCWD, filename, utimes);
 }
 
+SYSCALL_DEFINE2(utime, char __user *, filename, struct utimbuf __user *, times)
+{
+	struct timespec64 tv[2];
+
+	if (times) {
+		if (get_user(tv[0].tv_sec, &times->actime) ||
+		    get_user(tv[1].tv_sec, &times->modtime))
+			return -EFAULT;
+		tv[0].tv_nsec = 0;
+		tv[1].tv_nsec = 0;
+	}
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL, 0);
+}
+#endif
+
 #ifdef CONFIG_COMPAT
 /*
  * Not all architectures have sys_utime, so implement this in terms
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3d7dd665cdeb..d2b19e814218 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -941,8 +941,6 @@ asmlinkage long sys_access(const char __user *filename, int mode);
 asmlinkage long sys_rename(const char __user *oldname,
 				const char __user *newname);
 asmlinkage long sys_symlink(const char __user *old, const char __user *new);
-asmlinkage long sys_utimes(char __user *filename,
-				struct timeval __user *utimes);
 #if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
 asmlinkage long sys_stat64(const char __user *filename,
 				struct stat64 __user *statbuf);
@@ -972,14 +970,18 @@ asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpgrp(void);
 asmlinkage long sys_pause(void);
 asmlinkage long sys_time(time_t __user *tloc);
+#ifdef __ARCH_WANT_SYS_UTIME
 asmlinkage long sys_utime(char __user *filename,
 				struct utimbuf __user *times);
+asmlinkage long sys_utimes(char __user *filename,
+				struct timeval __user *utimes);
+asmlinkage long sys_futimesat(int dfd, const char __user *filename,
+			      struct timeval __user *utimes);
+#endif
 asmlinkage long sys_creat(const char __user *pathname, umode_t mode);
 asmlinkage long sys_getdents(unsigned int fd,
 				struct linux_dirent __user *dirent,
 				unsigned int count);
-asmlinkage long sys_futimesat(int dfd, const char __user *filename,
-			      struct timeval __user *utimes);
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-- 
2.9.0
