From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 20/24] arm64: ilp32: introduce ilp32-specific sigframe and ucontext
Date: Wed, 16 May 2018 11:19:05 +0300
Message-ID: <20180516081910.10067-21-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.comk>

ILP32 uses AARCH32 compat structures and syscall handlers for signals. But
ILP32 rt_sigframe and ucontext structures differ from both LP64 and AARCH32.
>From software point of view ILP32 is typical 32-bit compat ABI, and from
hardware point of view, it's just like LP64.

struct rt_sigframe defined in this patch in
arch/arm64/kernel/signal_ilp32.c redefines one in
arch/arm64/kernel/signal.c. And functions located in
arch/arm64/include/signal_common.h pick up new structure to generate the
code suitable for ILP32.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/include/asm/signal_ilp32.h | 23 ++++++++++
 arch/arm64/kernel/Makefile            |  3 +-
 arch/arm64/kernel/entry_ilp32.S       | 12 +++++
 arch/arm64/kernel/signal_ilp32.c      | 65 +++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/signal_ilp32.h
 create mode 100644 arch/arm64/kernel/entry_ilp32.S
 create mode 100644 arch/arm64/kernel/signal_ilp32.c

diff --git a/arch/arm64/include/asm/signal_ilp32.h b/arch/arm64/include/asm/signal_ilp32.h
new file mode 100644
index 000000000000..7ee97c133605
--- /dev/null
+++ b/arch/arm64/include/asm/signal_ilp32.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __ASM_SIGNAL_ILP32_H
+#define __ASM_SIGNAL_ILP32_H
+
+#ifdef CONFIG_ARM64_ILP32
+
+#include <linux/compat.h>
+
+int ilp32_setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs);
+
+#else
+
+static inline int ilp32_setup_rt_frame(int usig, struct ksignal *ksig,
+					sigset_t *set, struct pt_regs *regs)
+{
+	return -ENOSYS;
+}
+
+#endif /* CONFIG_ARM64_ILP32 */
+
+#endif /* __ASM_SIGNAL_ILP32_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 9e127c47a25c..27ddf5369f89 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -28,7 +28,8 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o binfmt_elf32.o
-arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o sys_ilp32.o
+arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o sys_ilp32.o 		\
+					   signal_ilp32.o entry_ilp32.o
 arm64-obj-$(CONFIG_COMPAT)		+= entry32_common.o signal32_common.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
diff --git a/arch/arm64/kernel/entry_ilp32.S b/arch/arm64/kernel/entry_ilp32.S
new file mode 100644
index 000000000000..562d5d0a7d82
--- /dev/null
+++ b/arch/arm64/kernel/entry_ilp32.S
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/*
+ * ILP32 system call wrappers
+ */
+
+#include <linux/linkage.h>
+
+ENTRY(ilp32_sys_rt_sigreturn_wrapper)
+	mov	x0, sp
+	b	ilp32_sys_rt_sigreturn
+ENDPROC(ilp32_sys_rt_sigreturn_wrapper)
diff --git a/arch/arm64/kernel/signal_ilp32.c b/arch/arm64/kernel/signal_ilp32.c
new file mode 100644
index 000000000000..f4bcb7332010
--- /dev/null
+++ b/arch/arm64/kernel/signal_ilp32.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * Copyright (C) 1995-2009 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2018 Cavium Networks.
+ * Yury Norov <ynorov@caviumnetworks.com>
+ */
+
+#include <linux/compat.h>
+#include <linux/signal.h>
+#include <linux/syscalls.h>
+
+#include <asm/fpsimd.h>
+#include <asm/unistd.h>
+#include <asm/ucontext.h>
+#include <asm/vdso.h>
+
+#include <asm/signal_ilp32.h>
+#include <asm/signal32_common.h>
+
+#define get_sigset(s, m) get_sigset_t(s, m)
+#define put_sigset(s, m) put_sigset_t(m, s)
+
+#define restore_altstack(stack) compat_restore_altstack(stack)
+#define __save_altstack(stack, sp) __compat_save_altstack(stack, sp)
+#define copy_siginfo_to_user(frame_info, ksig_info) \
+		copy_siginfo_to_user32(frame_info, ksig_info)
+
+#define setup_return(regs, ka, user_layout, usig)			\
+{									\
+	__setup_return(regs, ka, user_layout, usig);			\
+	regs->regs[30] =						\
+		(unsigned long)VDSO_SYMBOL(current->mm->context.vdso,	\
+						    sigtramp_ilp32);	\
+}
+
+struct ilp32_ucontext {
+	u32		uc_flags;
+	u32		uc_link;
+	compat_stack_t	uc_stack;
+	compat_sigset_t	uc_sigmask;
+	/* glibc uses a 1024-bit sigset_t */
+	__u8		__unused[1024 / 8 - sizeof(compat_sigset_t)];
+	/* last for future expansion */
+	struct sigcontext uc_mcontext;
+};
+
+struct rt_sigframe {
+	struct compat_siginfo info;
+	struct ilp32_ucontext uc;
+};
+
+#include <asm/signal_common.h>
+
+asmlinkage long ilp32_sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return __sys_rt_sigreturn(regs);
+}
+
+int ilp32_setup_rt_frame(int usig, struct ksignal *ksig,
+			  sigset_t *set, struct pt_regs *regs)
+{
+	return __setup_rt_frame(usig, ksig, set, regs);
+}
-- 
2.17.0
