From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 16/24] arm64: ilp32: share aarch32 syscall handlers
Date: Wed, 16 May 2018 11:19:01 +0300
Message-ID: <20180516081910.10067-17-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

According to userspace/kernel ABI, userspace off_t is  passed in register
pair just like in aarch32. In this patch corresponding aarch32 handlers
are shared to ilp32 code.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/kernel/Makefile         |  1 +
 arch/arm64/kernel/entry32.S        | 80 ------------------------
 arch/arm64/kernel/entry32_common.S | 97 ++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 80 deletions(-)
 create mode 100644 arch/arm64/kernel/entry32_common.S

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 3114191750ae..2dde9ae508ec 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,6 +29,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o binfmt_elf32.o
 arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o
+arm64-obj-$(CONFIG_COMPAT)		+= entry32_common.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
diff --git a/arch/arm64/kernel/entry32.S b/arch/arm64/kernel/entry32.S
index f332d5d1f6b4..4bede0324440 100644
--- a/arch/arm64/kernel/entry32.S
+++ b/arch/arm64/kernel/entry32.S
@@ -39,83 +39,3 @@ ENTRY(compat_sys_rt_sigreturn_wrapper)
 	mov	x0, sp
 	b	compat_sys_rt_sigreturn
 ENDPROC(compat_sys_rt_sigreturn_wrapper)
-
-ENTRY(compat_sys_statfs64_wrapper)
-	mov	w3, #84
-	cmp	w1, #88
-	csel	w1, w3, w1, eq
-	b	compat_sys_statfs64
-ENDPROC(compat_sys_statfs64_wrapper)
-
-ENTRY(compat_sys_fstatfs64_wrapper)
-	mov	w3, #84
-	cmp	w1, #88
-	csel	w1, w3, w1, eq
-	b	compat_sys_fstatfs64
-ENDPROC(compat_sys_fstatfs64_wrapper)
-
-/*
- * Note: off_4k (w5) is always in units of 4K. If we can't do the
- * requested offset because it is not page-aligned, we return -EINVAL.
- */
-ENTRY(compat_sys_mmap2_wrapper)
-#if PAGE_SHIFT > 12
-	tst	w5, #~PAGE_MASK >> 12
-	b.ne	1f
-	lsr	w5, w5, #PAGE_SHIFT - 12
-#endif
-	b	sys_mmap_pgoff
-1:	mov	x0, #-EINVAL
-	ret
-ENDPROC(compat_sys_mmap2_wrapper)
-
-/*
- * Wrappers for AArch32 syscalls that either take 64-bit parameters
- * in registers or that take 32-bit parameters which require sign
- * extension.
- */
-ENTRY(compat_sys_pread64_wrapper)
-	regs_to_64	x3, x4, x5
-	b	sys_pread64
-ENDPROC(compat_sys_pread64_wrapper)
-
-ENTRY(compat_sys_pwrite64_wrapper)
-	regs_to_64	x3, x4, x5
-	b	sys_pwrite64
-ENDPROC(compat_sys_pwrite64_wrapper)
-
-ENTRY(compat_sys_truncate64_wrapper)
-	regs_to_64	x1, x2, x3
-	b	sys_truncate
-ENDPROC(compat_sys_truncate64_wrapper)
-
-ENTRY(compat_sys_ftruncate64_wrapper)
-	regs_to_64	x1, x2, x3
-	b	sys_ftruncate
-ENDPROC(compat_sys_ftruncate64_wrapper)
-
-ENTRY(compat_sys_readahead_wrapper)
-	regs_to_64	x1, x2, x3
-	mov	w2, w4
-	b	sys_readahead
-ENDPROC(compat_sys_readahead_wrapper)
-
-ENTRY(compat_sys_fadvise64_64_wrapper)
-	mov	w6, w1
-	regs_to_64	x1, x2, x3
-	regs_to_64	x2, x4, x5
-	mov	w3, w6
-	b	sys_fadvise64_64
-ENDPROC(compat_sys_fadvise64_64_wrapper)
-
-ENTRY(compat_sys_sync_file_range2_wrapper)
-	regs_to_64	x2, x2, x3
-	regs_to_64	x3, x4, x5
-	b	sys_sync_file_range2
-ENDPROC(compat_sys_sync_file_range2_wrapper)
-
-ENTRY(compat_sys_fallocate_wrapper)
-	regs_to_64	x2, x2, x3
-	regs_to_64	x3, x4, x5
-	b	sys_fallocate
-ENDPROC(compat_sys_fallocate_wrapper)
diff --git a/arch/arm64/kernel/entry32_common.S b/arch/arm64/kernel/entry32_common.S
new file mode 100644
index 000000000000..6ef4752162d0
--- /dev/null
+++ b/arch/arm64/kernel/entry32_common.S
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * Compat system call wrappers
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ * Authors: Will Deacon <will.deacon@arm.com>
+ *	    Catalin Marinas <catalin.marinas@arm.com>
+ */
+
+#include <linux/linkage.h>
+#include <linux/const.h>
+
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/errno.h>
+#include <asm/page.h>
+
+/*
+ * Note: off_4k (w5) is always in units of 4K. If we can't do the
+ * requested offset because it is not page-aligned, we return -EINVAL.
+ */
+ENTRY(compat_sys_mmap2_wrapper)
+#if PAGE_SHIFT > 12
+	tst	w5, #~PAGE_MASK >> 12
+	b.ne	1f
+	lsr	w5, w5, #PAGE_SHIFT - 12
+#endif
+	b	sys_mmap_pgoff
+1:	mov	x0, #-EINVAL
+	ret
+ENDPROC(compat_sys_mmap2_wrapper)
+
+/*
+ * Wrappers for AArch32 syscalls that either take 64-bit parameters
+ * in registers or that take 32-bit parameters which require sign
+ * extension.
+ */
+ENTRY(compat_sys_pread64_wrapper)
+	regs_to_64	x3, x4, x5
+	b	sys_pread64
+ENDPROC(compat_sys_pread64_wrapper)
+
+ENTRY(compat_sys_pwrite64_wrapper)
+	regs_to_64	x3, x4, x5
+	b	sys_pwrite64
+ENDPROC(compat_sys_pwrite64_wrapper)
+
+ENTRY(compat_sys_truncate64_wrapper)
+	regs_to_64	x1, x2, x3
+	b	sys_truncate
+ENDPROC(compat_sys_truncate64_wrapper)
+
+ENTRY(compat_sys_ftruncate64_wrapper)
+	regs_to_64	x1, x2, x3
+	b	sys_ftruncate
+ENDPROC(compat_sys_ftruncate64_wrapper)
+
+ENTRY(compat_sys_readahead_wrapper)
+	regs_to_64	x1, x2, x3
+	mov	w2, w4
+	b	sys_readahead
+ENDPROC(compat_sys_readahead_wrapper)
+
+ENTRY(compat_sys_fadvise64_64_wrapper)
+	mov	w6, w1
+	regs_to_64	x1, x2, x3
+	regs_to_64	x2, x4, x5
+	mov	w3, w6
+	b	sys_fadvise64_64
+ENDPROC(compat_sys_fadvise64_64_wrapper)
+
+ENTRY(compat_sys_sync_file_range2_wrapper)
+	regs_to_64	x2, x2, x3
+	regs_to_64	x3, x4, x5
+	b	sys_sync_file_range2
+ENDPROC(compat_sys_sync_file_range2_wrapper)
+
+ENTRY(compat_sys_fallocate_wrapper)
+	regs_to_64	x2, x2, x3
+	regs_to_64	x3, x4, x5
+	b	sys_fallocate
+ENDPROC(compat_sys_fallocate_wrapper)
+
+ENTRY(compat_sys_statfs64_wrapper)
+	mov	w3, #84
+	cmp	w1, #88
+	csel	w1, w3, w1, eq
+	b	compat_sys_statfs64
+ENDPROC(compat_sys_statfs64_wrapper)
+
+ENTRY(compat_sys_fstatfs64_wrapper)
+	mov	w3, #84
+	cmp	w1, #88
+	csel	w1, w3, w1, eq
+	b	compat_sys_fstatfs64
+ENDPROC(compat_sys_fstatfs64_wrapper)
-- 
2.17.0
