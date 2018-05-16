From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 17/24] arm64: ilp32: add sys_ilp32.c and a separate table (in entry.S) to use it
Date: Wed, 16 May 2018 11:19:02 +0300
Message-ID: <20180516081910.10067-18-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

From: Andrew Pinski <apinski@cavium.com>

Add a separate syscall-table for ILP32, which dispatches either to native
LP64 system call implementation or to compat-syscalls, as appropriate.

Signed-off-by: Andrew Pinski <Andrew.Pinski@caviumnetworks.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Bamvor Jian Zhang <bamv2005@gmail.com>
---
 arch/arm64/include/asm/unistd.h      |  8 ++-
 arch/arm64/include/uapi/asm/unistd.h | 12 ++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/entry.S            | 31 +++++++++-
 arch/arm64/kernel/sys_ilp32.c        | 90 ++++++++++++++++++++++++++++
 5 files changed, 137 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/kernel/sys_ilp32.c

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 99d29290c98b..1bf5572cd078 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,12 +13,16 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifdef CONFIG_AARCH32_EL0
+
+#ifdef CONFIG_COMPAT
 #define __ARCH_WANT_COMPAT_STAT64
+#define __ARCH_WANT_SYS_LLSEEK
+#endif
+
+#ifdef CONFIG_AARCH32_EL0
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 439b1c55c827..80f1cb4ae2e1 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -15,7 +15,19 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+/*
+ * Use AARCH32 interface for sys_sync_file_range() as it passes 64-bit arguments.
+ */
+#if defined(__ILP32__) || defined(__SYSCALL_COMPAT)
+#define __ARCH_WANT_SYNC_FILE_RANGE2
+#endif
+
+/*
+ * AARCH64/ILP32 is introduced after next syscalls were deprecated.
+ */
+#if !(defined(__ILP32__) || defined(__SYSCALL_COMPAT))
 #define __ARCH_WANT_RENAMEAT
 #define __ARCH_WANT_SET_GET_RLIMIT
+#endif
 
 #include <asm-generic/unistd.h>
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2dde9ae508ec..a6db407d4089 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -28,7 +28,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o binfmt_elf32.o
-arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o
+arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o sys_ilp32.o
 arm64-obj-$(CONFIG_COMPAT)		+= entry32_common.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 698907724eed..d03542418f9b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -401,6 +401,23 @@ tsk	.req	x28		// current thread_info
 
 	.text
 
+#ifdef CONFIG_ARM64_ILP32
+/*
+ * AARCH64/ILP32. Zero top halves of x0-x7
+ * registers as userspace may put garbage there.
+ */
+	.macro	delouse_input_regs
+	mov w0, w0
+	mov w1, w1
+	mov w2, w2
+	mov w3, w3
+	mov w4, w4
+	mov w5, w5
+	mov w6, w6
+	mov w7, w7
+	.endm
+#endif
+
 /*
  * Exception vectors.
  */
@@ -695,6 +712,7 @@ el0_svc_compat:
 	 */
 	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
 	adrp	stbl, compat_sys_call_table	// load compat syscall table pointer
+	ldr     x19, [tsk, #TSK_TI_FLAGS]
 	mov	wscno, w7			// syscall number in w7 (r7)
 	mov     wsc_nr, #__NR_compat_syscalls
 	b	el0_svc_naked
@@ -916,14 +934,15 @@ ENDPROC(ret_to_user)
 el0_svc:
 	ldr	x16, [tsk, #TSK_TI_FLAGS]	// load thread flags
 	adrp	stbl, sys_call_table		// load syscall table pointer
+	ldr	x19, [tsk, #TSK_TI_FLAGS]
 	mov	wscno, w8			// syscall number in w8
 	mov	wsc_nr, #__NR_syscalls
 
 #ifdef CONFIG_ARM64_SVE
 alternative_if_not ARM64_SVE
-	b	el0_svc_naked
+	b	el0_svc_select_table
 alternative_else_nop_endif
-	tbz	x16, #TIF_SVE, el0_svc_naked	// Skip unless TIF_SVE set:
+	tbz	x16, #TIF_SVE, el0_svc_select_table	// Skip unless TIF_SVE set:
 	bic	x16, x16, #_TIF_SVE		// discard SVE state
 	str	x16, [tsk, #TSK_TI_FLAGS]
 
@@ -939,12 +958,18 @@ alternative_else_nop_endif
 	msr	cpacr_el1, x9			// synchronised by eret to el0
 #endif
 
+el0_svc_select_table:
+#ifdef CONFIG_ARM64_ILP32
+	tbz	x19, #TIF_32BIT_AARCH64, el0_svc_naked	// We are using LP64  syscall table
+	adrp	stbl, sys_call_ilp32_table	// load ilp32 syscall table pointer
+	delouse_input_regs
+#endif
 el0_svc_naked:					// compat entry point
 	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
 	enable_daif
 	ct_user_exit 1
 
-	tst	x16, #_TIF_SYSCALL_WORK		// check for syscall hooks
+	tst	x19, #_TIF_SYSCALL_WORK		// check for syscall hooks
 	b.ne	__sys_trace
 	cmp     wscno, wsc_nr			// check upper syscall limit
 	b.hs	ni_sys
diff --git a/arch/arm64/kernel/sys_ilp32.c b/arch/arm64/kernel/sys_ilp32.c
new file mode 100644
index 000000000000..9803d7806328
--- /dev/null
+++ b/arch/arm64/kernel/sys_ilp32.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * AArch64- ILP32 specific system calls implementation
+ *
+ * Copyright (C) 2018 Cavium Inc.
+ * Author: Andrew Pinski <apinski@cavium.com>
+ */
+
+#define __SYSCALL_COMPAT
+
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/msg.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <asm-generic/syscalls.h>
+
+/*
+ * AARCH32 requires 4-page alignment for shared memory,
+ * but AARCH64 - only 1 page. This is the only difference
+ * between compat and native sys_shmat(). So ILP32 just pick
+ * AARCH64 version.
+ */
+#define compat_sys_shmat		sys_shmat
+
+/*
+ * ILP32 needs special handling for some ptrace requests.
+ */
+#define sys_ptrace			compat_sys_ptrace
+
+/*
+ * Using AARCH32 interface for syscalls that take 64-bit
+ * parameters in registers.
+ */
+#define compat_sys_fadvise64_64		compat_sys_fadvise64_64_wrapper
+#define compat_sys_fallocate		compat_sys_fallocate_wrapper
+#define compat_sys_ftruncate64		compat_sys_ftruncate64_wrapper
+#define compat_sys_pread64		compat_sys_pread64_wrapper
+#define compat_sys_pwrite64		compat_sys_pwrite64_wrapper
+#define compat_sys_readahead		compat_sys_readahead_wrapper
+#define compat_sys_sync_file_range2	compat_sys_sync_file_range2_wrapper
+#define compat_sys_truncate64		compat_sys_truncate64_wrapper
+#define sys_mmap2			compat_sys_mmap2_wrapper
+
+/*
+ * Using AARCH32 interface for syscalls that take the size of
+ * struct statfs as an argument, as it's calculated differently
+ * in kernel and user spaces.
+ */
+#define compat_sys_fstatfs64		compat_sys_fstatfs64_wrapper
+#define compat_sys_statfs64		compat_sys_statfs64_wrapper
+
+/*
+ * Using custom wrapper for rt_sigreturn() to handle custom
+ * struct rt_sigframe.
+ */
+#define compat_sys_rt_sigreturn        ilp32_sys_rt_sigreturn_wrapper
+
+asmlinkage long compat_sys_fstatfs64_wrapper(void);
+asmlinkage long compat_sys_statfs64_wrapper(void);
+asmlinkage long compat_sys_fadvise64_64_wrapper(void);
+asmlinkage long compat_sys_fallocate_wrapper(void);
+asmlinkage long compat_sys_ftruncate64_wrapper(void);
+asmlinkage long compat_sys_mmap2_wrapper(void);
+asmlinkage long compat_sys_pread64_wrapper(void);
+asmlinkage long compat_sys_pwrite64_wrapper(void);
+asmlinkage long compat_sys_readahead_wrapper(void);
+asmlinkage long compat_sys_sync_file_range2_wrapper(void);
+asmlinkage long compat_sys_truncate64_wrapper(void);
+asmlinkage long ilp32_sys_rt_sigreturn_wrapper(void);
+
+#include <asm/syscall.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, sym)	[nr] = sym,
+
+/*
+ * The sys_call_ilp32_table array must be 4K aligned to be accessible from
+ * kernel/entry.S.
+ */
+void *sys_call_ilp32_table[__NR_syscalls] __aligned(4096) = {
+	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
-- 
2.17.0
