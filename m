From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/17] y2038: Change sys_utimensat() to use __kernel_timespec
Date: Wed, 25 Apr 2018 18:03:00 +0200
Message-ID: <20180425160311.2718314-7-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <libc-alpha-return-91845-glibc-alpha=m.gmane.org@sourceware.org>
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
index 69d4b6ba1bfb..ca2c02a7985c 100644
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
index b92cb79d38c3..3d7dd665cdeb 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -500,7 +500,8 @@ asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 
 /* fs/utimes.c */
 asmlinkage long sys_utimensat(int dfd, const char __user *filename,
-				struct timespec __user *utimes, int flags);
+				struct __kernel_timespec __user *utimes,
+				int flags);
 
 /* kernel/acct.c */
 asmlinkage long sys_acct(const char __user *name);
-- 
2.9.0
