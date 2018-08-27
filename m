From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/14] y2038: Change sys_utimensat() to use __kernel_timespec
Date: Mon, 27 Aug 2018 21:45:26 +0200
Message-ID: <20180827194531.3796559-10-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

When 32-bit architectures get changed to support 64-bit time_t,
utimensat() needs to use the new __kernel_timespec structure as its
argument.

The older utime(), utimes() and futimesat() system calls don't need a
corresponding change as they are no longer used on C libraries that have
64-bit time support.

As we do for the other syscalls that have timespec arguments, we reuse
the 'compat' syscall entry points to implement the traditional four
interfaces, and only leave the new utimensat() as a native handler,
so that the same code gets used on both 32-bit and 64-bit kernels
on each syscall.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/utimes.c              | 2 +-
 include/linux/syscalls.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index 79a65c163f40..d30f409ecc1a 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -166,7 +166,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 }
 
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
-		struct timespec __user *, utimes, int, flags)
+		struct __kernel_timespec __user *, utimes, int, flags)
 {
 	struct timespec64 tstimes[2];
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b3e27e5ee322..420ac881a610 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -513,7 +513,8 @@ asmlinkage long sys_timerfd_gettime(int ufd, struct __kernel_itimerspec __user *
 
 /* fs/utimes.c */
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
-				struct timespec __user *utimes, int flags);
+				struct __kernel_timespec __user *utimes,
+				int flags);
 
 /* kernel/acct.c */
 asmlinkage long sys_acct(const char __user *name);
-- 
2.18.0
