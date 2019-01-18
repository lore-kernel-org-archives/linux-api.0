From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 17/29] syscalls: remove obsolete __IGNORE_ macros
Date: Fri, 18 Jan 2019 17:18:23 +0100
Message-ID: <20190118161835.2259170-18-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

These are all for ignoring the lack of obsolete system calls,
which have been marked the same way in scripts/checksyscall.sh,
so these can be removed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/include/asm/unistd.h   | 16 ----------------
 arch/parisc/include/asm/unistd.h |  3 ---
 arch/s390/include/asm/unistd.h   |  2 --
 arch/xtensa/include/asm/unistd.h | 12 ------------
 4 files changed, 33 deletions(-)

diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index b23d74a601b3..5e9eeb83d8d4 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -53,22 +53,6 @@
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
 
-/* whitelists for checksyscalls */
-#define __IGNORE_select
-#define __IGNORE_vfork
-#define __IGNORE_time
-#define __IGNORE_uselib
-#define __IGNORE_fadvise64_64
-#define __IGNORE_getdents64
-#if _MIPS_SIM == _MIPS_SIM_NABI32
-#define __IGNORE_truncate64
-#define __IGNORE_ftruncate64
-#define __IGNORE_stat64
-#define __IGNORE_lstat64
-#define __IGNORE_fstat64
-#define __IGNORE_fstatat64
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_UNISTD_H */
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index 9ec1026af877..385eae49ed02 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -10,9 +10,6 @@
 
 #define SYS_ify(syscall_name)   __NR_##syscall_name
 
-#define __IGNORE_select			/* newselect */
-#define __IGNORE_fadvise64		/* fadvise64_64 */
-
 #ifndef ASM_LINE_SEP
 # define ASM_LINE_SEP ;
 #endif
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index ed08f114ee91..59202ceea1f6 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -10,8 +10,6 @@
 #include <uapi/asm/unistd.h>
 #include <asm/unistd_nr.h>
 
-#define __IGNORE_time
-
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index 0d34629dafc5..81cc52ea1bd5 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -10,18 +10,6 @@
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_GETPGRP
 
-/* 
- * Ignore legacy system calls in the checksyscalls.sh script
- */
-
-#define __IGNORE_fork				/* use clone */
-#define __IGNORE_time
-#define __IGNORE_alarm				/* use setitimer */
-#define __IGNORE_pause
-#define __IGNORE_mmap				/* use mmap2 */
-#define __IGNORE_vfork				/* use clone */
-#define __IGNORE_fadvise64			/* use fadvise64_64 */
-
 #define NR_syscalls				__NR_syscalls
 
 #endif /* _XTENSA_UNISTD_H */
-- 
2.20.0
