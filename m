From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/19] y2038: use __kernel_stat for sys_newstat syscalls
Date: Wed,  6 May 2015 18:30:17 +0200
Message-ID: <1430929826-318934-11-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-58713-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This moves over the sys_new{stat,lstat,fstat,fstatat} system calls
to use the newly introduced __kernel_stat. On all 64-bit architectures,
the layout is the same as 'struct stat', so nothing changes.

On 32-bit architectures, we use a trick to '#define __kernel_stat stat'
as long as CONFIG_COMPAT_TIME is not set, and hide the new definitions
from the kernel as long as this is the case, so the behavior does not
change until we change over the architectures individually to use
compat_sys_stat() in place of sys_stat() so we can reuse the sys_stat()
implementation for the new structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/stat.c            | 12 ++++++------
 include/linux/stat.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index cccc1aab9a8b..12efbdd258fc 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -226,9 +226,9 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, stat
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
 
-static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
+static int cp_new_stat(struct kstat *stat, struct __kernel_stat __user *statbuf)
 {
-	struct stat tmp;
+	struct __kernel_stat tmp;
 
 	if (!valid_dev(stat->dev) || !valid_dev(stat->rdev))
 		return -EOVERFLOW;
@@ -264,7 +264,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 }
 
 SYSCALL_DEFINE2(newstat, const char __user *, filename,
-		struct stat __user *, statbuf)
+		struct __kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_stat(filename, &stat);
@@ -275,7 +275,7 @@ SYSCALL_DEFINE2(newstat, const char __user *, filename,
 }
 
 SYSCALL_DEFINE2(newlstat, const char __user *, filename,
-		struct stat __user *, statbuf)
+		struct __kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error;
@@ -289,7 +289,7 @@ SYSCALL_DEFINE2(newlstat, const char __user *, filename,
 
 #if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
 SYSCALL_DEFINE4(newfstatat, int, dfd, const char __user *, filename,
-		struct stat __user *, statbuf, int, flag)
+		struct __kernel_stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -301,7 +301,7 @@ SYSCALL_DEFINE4(newfstatat, int, dfd, const char __user *, filename,
 }
 #endif
 
-SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
+SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct __kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 075cb0c7eb2a..9efc32774e98 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -1,6 +1,9 @@
 #ifndef _LINUX_STAT_H
 #define _LINUX_STAT_H
 
+#ifndef CONFIG_COMPAT_TIME
+#define __kernel_stat stat
+#endif
 
 #include <asm/stat.h>
 #include <uapi/linux/stat.h>
-- 
2.1.0.rc2
