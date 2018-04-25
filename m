From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/17] y2038: Remove stat64 family from default syscall set
Date: Wed, 25 Apr 2018 18:02:57 +0200
Message-ID: <20180425160311.2718314-4-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <libc-alpha-return-91840-glibc-alpha=m.gmane.org@sourceware.org>
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

New architectures should no longer need stat64, which is not y2038
safe and has been replaced by statx(). This removes the 'select
__ARCH_WANT_STAT64' statement from asm-generic/unistd.h and instead
moves it into the respective asm/unistd.h UAPI header files for each
architecture that uses it today.

In the generic file, the system call number and entry points are now
made conditional, so newly added architectures (e.g. riscv32 or csky)
will never need to carry backwards compatiblity for it.

arm64 is the only 64-bit architecture using the asm-generic/unistd.h
file, and it already sets __ARCH_WANT_NEW_STAT in its headers, and I
use the same #ifdef here: future 64-bit architectures therefore won't
see newstat or stat64 any more. They don't suffer from the y2038 time_t
overflow, but for consistency it seems best to also let them use statx().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/uapi/asm/unistd.h       | 1 +
 arch/c6x/include/uapi/asm/unistd.h       | 1 +
 arch/h8300/include/uapi/asm/unistd.h     | 1 +
 arch/hexagon/include/uapi/asm/unistd.h   | 1 +
 arch/nds32/include/uapi/asm/unistd.h     | 1 +
 arch/nios2/include/uapi/asm/unistd.h     | 1 +
 arch/openrisc/include/uapi/asm/unistd.h  | 1 +
 arch/unicore32/include/uapi/asm/unistd.h | 1 +
 include/asm-generic/unistd.h             | 1 -
 include/uapi/asm-generic/unistd.h        | 2 ++
 10 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 517178b1daef..3b3543fd151c 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -17,6 +17,7 @@
 #define _UAPI_ASM_ARC_UNISTD_H
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/c6x/include/uapi/asm/unistd.h b/arch/c6x/include/uapi/asm/unistd.h
index 0d2daf7f9809..6b2fe792de9d 100644
--- a/arch/c6x/include/uapi/asm/unistd.h
+++ b/arch/c6x/include/uapi/asm/unistd.h
@@ -16,6 +16,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_CLONE
 
 /* Use the standard ABI for syscalls. */
diff --git a/arch/h8300/include/uapi/asm/unistd.h b/arch/h8300/include/uapi/asm/unistd.h
index 7dd20ef7625a..628195823816 100644
--- a/arch/h8300/include/uapi/asm/unistd.h
+++ b/arch/h8300/include/uapi/asm/unistd.h
@@ -1,5 +1,6 @@
 #define __ARCH_NOMMU
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 
 #include <asm-generic/unistd.h>
diff --git a/arch/hexagon/include/uapi/asm/unistd.h b/arch/hexagon/include/uapi/asm/unistd.h
index ea181e79162e..c91ca7d02461 100644
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -29,6 +29,7 @@
 
 #define sys_mmap2 sys_mmap_pgoff
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/nds32/include/uapi/asm/unistd.h b/arch/nds32/include/uapi/asm/unistd.h
index 6e95901cabe3..603e826e0449 100644
--- a/arch/nds32/include/uapi/asm/unistd.h
+++ b/arch/nds32/include/uapi/asm/unistd.h
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2005-2017 Andes Technology Corporation
 
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYNC_FILE_RANGE2
 
 /* Use the standard ABI for syscalls */
diff --git a/arch/nios2/include/uapi/asm/unistd.h b/arch/nios2/include/uapi/asm/unistd.h
index b6bdae04bc84..d9948d88790b 100644
--- a/arch/nios2/include/uapi/asm/unistd.h
+++ b/arch/nios2/include/uapi/asm/unistd.h
@@ -19,6 +19,7 @@
  #define sys_mmap2 sys_mmap_pgoff
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 
 /* Use the standard ABI for syscalls */
 #include <asm-generic/unistd.h>
diff --git a/arch/openrisc/include/uapi/asm/unistd.h b/arch/openrisc/include/uapi/asm/unistd.h
index 11c5a58ab333..ec37df18d8ed 100644
--- a/arch/openrisc/include/uapi/asm/unistd.h
+++ b/arch/openrisc/include/uapi/asm/unistd.h
@@ -20,6 +20,7 @@
 #define sys_mmap2 sys_mmap_pgoff
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
 
diff --git a/arch/unicore32/include/uapi/asm/unistd.h b/arch/unicore32/include/uapi/asm/unistd.h
index 65856eaab163..1e8fe5941b8a 100644
--- a/arch/unicore32/include/uapi/asm/unistd.h
+++ b/arch/unicore32/include/uapi/asm/unistd.h
@@ -15,4 +15,5 @@
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
+#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_CLONE
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index cdf904265caf..ea74eca8463f 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -8,6 +8,5 @@
  * be selected by default.
  */
 #if __BITS_PER_LONG == 32
-#define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_LLSEEK
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 8bcb186c6f67..ce6a26c596e8 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -242,10 +242,12 @@ __SYSCALL(__NR_tee, sys_tee)
 /* fs/stat.c */
 #define __NR_readlinkat 78
 __SYSCALL(__NR_readlinkat, sys_readlinkat)
+#if defined(__ARCH_WANT_NEW_STAT) || defined(__ARCH_WANT_STAT64)
 #define __NR3264_fstatat 79
 __SC_3264(__NR3264_fstatat, sys_fstatat64, sys_newfstatat)
 #define __NR3264_fstat 80
 __SC_3264(__NR3264_fstat, sys_fstat64, sys_newfstat)
+#endif
 
 /* fs/sync.c */
 #define __NR_sync 81
-- 
2.9.0
