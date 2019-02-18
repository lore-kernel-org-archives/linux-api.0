From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/8] asm-generic: Drop getrlimit and setrlimit syscalls from default list
Date: Mon, 18 Feb 2019 22:07:07 +0100
Message-ID: <20190218210712.3503891-4-arnd@arndb.de>
References: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218210712.3503891-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, yury.norov@gmail.com, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, arnd@arndb.de, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>, Yury Norov <ynorov@caviumnetworks.com>, Mark Salter <msalter@redhat.com>, James Hogan <james.hogan@imgtec.com>, Ley Foon Tan <lftan@altera.com>, Will Deacon <will.deacon@arm.com>, Yury Norov <ynorov@marvell.com>
List-Id: linux-api@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.com>

The newer prlimit64 syscall provides all the functionality of getrlimit
and setrlimit syscalls and adds the pid of target process, so future
architectures won't need to include getrlimit and setrlimit.

Therefore drop getrlimit and setrlimit syscalls from the generic syscall
list unless __ARCH_WANT_SET_GET_RLIMIT is defined by the architecture's
unistd.h prior to including asm-generic/unistd.h, and adjust all
architectures using the generic syscall list to define it so that no
in-tree architectures are affected.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-hexagon@vger.kernel.org
Cc: uclinux-h8-devel@lists.sourceforge.jp
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Salter <msalter@redhat.com> [c6x]
Acked-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: Ley Foon Tan <lftan@altera.com> [nios2]
Acked-by: Stafford Horne <shorne@gmail.com> [openrisc]
Acked-by: Will Deacon <will.deacon@arm.com> [arm64]
Acked-by: Vineet Gupta <vgupta@synopsys.com> #arch/arc bits
Signed-off-by: Yury Norov <ynorov@marvell.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/uapi/asm/unistd.h       | 1 +
 arch/arm64/include/uapi/asm/unistd.h     | 1 +
 arch/c6x/include/uapi/asm/unistd.h       | 1 +
 arch/csky/include/uapi/asm/unistd.h      | 1 +
 arch/h8300/include/uapi/asm/unistd.h     | 1 +
 arch/hexagon/include/uapi/asm/unistd.h   | 1 +
 arch/nds32/include/uapi/asm/unistd.h     | 1 +
 arch/nios2/include/uapi/asm/unistd.h     | 1 +
 arch/openrisc/include/uapi/asm/unistd.h  | 1 +
 arch/riscv/include/uapi/asm/unistd.h     | 1 +
 arch/unicore32/include/uapi/asm/unistd.h | 1 +
 include/uapi/asm-generic/unistd.h        | 5 +++++
 scripts/checksyscalls.sh                 | 5 +++++
 13 files changed, 21 insertions(+)

diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 3b3543fd151c..6a1a62a979dd 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -18,6 +18,7 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index dae1584cf017..79937de2a0cc 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -17,5 +17,6 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_NEW_STAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 #include <asm-generic/unistd.h>
diff --git a/arch/c6x/include/uapi/asm/unistd.h b/arch/c6x/include/uapi/asm/unistd.h
index 6b2fe792de9d..e3721b2cfd6a 100644
--- a/arch/c6x/include/uapi/asm/unistd.h
+++ b/arch/c6x/include/uapi/asm/unistd.h
@@ -17,6 +17,7 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_CLONE
 
 /* Use the standard ABI for syscalls. */
diff --git a/arch/csky/include/uapi/asm/unistd.h b/arch/csky/include/uapi/asm/unistd.h
index 224c9a9ab45b..f5c83492136f 100644
--- a/arch/csky/include/uapi/asm/unistd.h
+++ b/arch/csky/include/uapi/asm/unistd.h
@@ -2,6 +2,7 @@
 // Copyright (C) 2018 Hangzhou C-SKY Microsystems co.,ltd.
 
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SET_GET_RLIMIT
 #include <asm-generic/unistd.h>
 
 #define __NR_set_thread_area	(__NR_arch_specific_syscall + 0)
diff --git a/arch/h8300/include/uapi/asm/unistd.h b/arch/h8300/include/uapi/asm/unistd.h
index 628195823816..b9e9352f2328 100644
--- a/arch/h8300/include/uapi/asm/unistd.h
+++ b/arch/h8300/include/uapi/asm/unistd.h
@@ -2,5 +2,6 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 #include <asm-generic/unistd.h>
diff --git a/arch/hexagon/include/uapi/asm/unistd.h b/arch/hexagon/include/uapi/asm/unistd.h
index c91ca7d02461..6bb392a33c35 100644
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -30,6 +30,7 @@
 #define sys_mmap2 sys_mmap_pgoff
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
diff --git a/arch/nds32/include/uapi/asm/unistd.h b/arch/nds32/include/uapi/asm/unistd.h
index c2c3a3e34083..eb98d24d3190 100644
--- a/arch/nds32/include/uapi/asm/unistd.h
+++ b/arch/nds32/include/uapi/asm/unistd.h
@@ -3,6 +3,7 @@
 
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYNC_FILE_RANGE2
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls */
 #include <asm-generic/unistd.h>
diff --git a/arch/nios2/include/uapi/asm/unistd.h b/arch/nios2/include/uapi/asm/unistd.h
index d9948d88790b..fa68e68bc26d 100644
--- a/arch/nios2/include/uapi/asm/unistd.h
+++ b/arch/nios2/include/uapi/asm/unistd.h
@@ -20,6 +20,7 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls */
 #include <asm-generic/unistd.h>
diff --git a/arch/openrisc/include/uapi/asm/unistd.h b/arch/openrisc/include/uapi/asm/unistd.h
index ec37df18d8ed..2e0bc0ff9f31 100644
--- a/arch/openrisc/include/uapi/asm/unistd.h
+++ b/arch/openrisc/include/uapi/asm/unistd.h
@@ -21,6 +21,7 @@
 
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_SYS_CLONE
 
diff --git a/arch/riscv/include/uapi/asm/unistd.h b/arch/riscv/include/uapi/asm/unistd.h
index 1f3bd3ebbb0d..d9340c52e7ad 100644
--- a/arch/riscv/include/uapi/asm/unistd.h
+++ b/arch/riscv/include/uapi/asm/unistd.h
@@ -18,6 +18,7 @@
 #ifdef __LP64__
 #define __ARCH_WANT_NEW_STAT
 #endif /* __LP64__ */
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 #include <asm-generic/unistd.h>
 
diff --git a/arch/unicore32/include/uapi/asm/unistd.h b/arch/unicore32/include/uapi/asm/unistd.h
index 1e8fe5941b8a..2b575c0cf177 100644
--- a/arch/unicore32/include/uapi/asm/unistd.h
+++ b/arch/unicore32/include/uapi/asm/unistd.h
@@ -12,6 +12,7 @@
  */
 
 #define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_SET_GET_RLIMIT
 
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index b928eff3bf92..2cdf600b05fa 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -467,10 +467,15 @@ __SYSCALL(__NR_uname, sys_newuname)
 __SYSCALL(__NR_sethostname, sys_sethostname)
 #define __NR_setdomainname 162
 __SYSCALL(__NR_setdomainname, sys_setdomainname)
+
+#ifdef __ARCH_WANT_SET_GET_RLIMIT
+/* getrlimit and setrlimit are superseded with prlimit64 */
 #define __NR_getrlimit 163
 __SC_COMP(__NR_getrlimit, sys_getrlimit, compat_sys_getrlimit)
 #define __NR_setrlimit 164
 __SC_COMP(__NR_setrlimit, sys_setrlimit, compat_sys_setrlimit)
+#endif
+
 #define __NR_getrusage 165
 __SC_COMP(__NR_getrusage, sys_getrusage, compat_sys_getrusage)
 #define __NR_umask 166
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index cc70a64fa81f..53c5677d7e82 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -38,6 +38,11 @@ cat << EOF
 #define __IGNORE_lstat64	/* fstatat64 */
 #endif
 
+#ifndef __ARCH_WANT_SET_GET_RLIMIT
+#define __IGNORE_getrlimit	/* getrlimit */
+#define __IGNORE_setrlimit	/* setrlimit */
+#endif
+
 /* Missing flags argument */
 #define __IGNORE_renameat	/* renameat2 */
 
-- 
2.20.0
