From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 16/16] y2038: ipc: Redirect ipc(SEMTIMEDOP, ...) to compat_ksys_semtimedop
Date: Wed, 25 Apr 2018 17:06:06 +0200
Message-ID: <20180425150606.954771-16-arnd@arndb.de>
References: <20180425132242.1500539-1-arnd@arndb.de>
Return-path: <libc-alpha-return-91830-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20180425132242.1500539-1-arnd@arndb.de>
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, albert.aribaud@3adev.fr, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, x86@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-mips@linux-mips.org, jhogan@kernel.org, ralf@linux-mips.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, zackw@panix.com, noloader@gmail.com, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

32-bit architectures implementing 64BIT_TIME and COMPAT_32BIT_TIME
need to have the traditional semtimedop() behavior with 32-bit timestamps
for sys_ipc() by calling compat_ksys_semtimedop(), while those that
are not yet converted need to keep using ksys_semtimedop() like
64-bit architectures do.

Note that I chose to not implement a new SEMTIMEDOP64 function that
corresponds to the new sys_semtimedop() with 64-bit timeouts. The reason
here is that sys_ipc() should no longer be used for new system calls,
and libc should just call the semtimedop syscall directly.

One open question remain to whether we want to completely avoid the
sys_ipc() system call for architectures that do not yet have all the
individual calls as they get converted to 64-bit time_t. Doing that
would require adding several extra system calls on m68k, mips, powerpc,
s390, sh, sparc, and x86-32.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 ipc/syscall.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/ipc/syscall.c b/ipc/syscall.c
index 77a883ef2eca..65d405f1ba0c 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -30,9 +30,14 @@ SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
 		return ksys_semtimedop(first, (struct sembuf __user *)ptr,
 				       second, NULL);
 	case SEMTIMEDOP:
-		return ksys_semtimedop(first, (struct sembuf __user *)ptr,
-				       second,
-				       (const struct timespec __user *)fifth);
+		if (IS_ENABLED(CONFIG_64BIT) || !IS_ENABLED(CONFIG_64BIT_TIME))
+			return ksys_semtimedop(first, ptr, second,
+			        (const struct __kernel_timespec __user *)fifth);
+		else if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
+			return compat_ksys_semtimedop(first, ptr, second,
+			        (const struct compat_timespec __user *)fifth);
+		else
+			return -ENOSYS;
 
 	case SEMGET:
 		return ksys_semget(first, second, third);
@@ -130,6 +135,8 @@ COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
 		/* struct sembuf is the same on 32 and 64bit :)) */
 		return ksys_semtimedop(first, compat_ptr(ptr), second, NULL);
 	case SEMTIMEDOP:
+		if (!IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
+			return -ENOSYS;
 		return compat_ksys_semtimedop(first, compat_ptr(ptr), second,
 						compat_ptr(fifth));
 	case SEMGET:
-- 
2.9.0
