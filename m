From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 19/24] arm64: signal32: move ilp32 and aarch32 common code to separated file
Date: Wed, 16 May 2018 11:19:04 +0300
Message-ID: <20180516081910.10067-20-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

ILP32 needs to mix 32bit struct siginfo and 64bit sigframe for its signal
handlers. Move the existing compat code for copying siginfo to user space
and manipulating signal masks into signal32_common.c so it can be used to
deliver aarch32 and ilp32 signals.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/include/asm/signal32_common.h | 13 +++++++++
 arch/arm64/kernel/Makefile               |  2 +-
 arch/arm64/kernel/signal32.c             | 23 +--------------
 arch/arm64/kernel/signal32_common.c      | 37 ++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 23 deletions(-)
 create mode 100644 arch/arm64/include/asm/signal32_common.h
 create mode 100644 arch/arm64/kernel/signal32_common.c

diff --git a/arch/arm64/include/asm/signal32_common.h b/arch/arm64/include/asm/signal32_common.h
new file mode 100644
index 000000000000..10bcdf6b8b4c
--- /dev/null
+++ b/arch/arm64/include/asm/signal32_common.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __ASM_SIGNAL32_COMMON_H
+#define __ASM_SIGNAL32_COMMON_H
+
+#ifdef CONFIG_COMPAT
+
+int put_sigset_t(compat_sigset_t __user *uset, sigset_t *set);
+int get_sigset_t(sigset_t *set, const compat_sigset_t __user *uset);
+
+#endif /* CONFIG_COMPAT*/
+
+#endif /* __ASM_SIGNAL32_COMMON_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index a6db407d4089..9e127c47a25c 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,7 +29,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o binfmt_elf32.o
 arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o sys_ilp32.o
-arm64-obj-$(CONFIG_COMPAT)		+= entry32_common.o
+arm64-obj-$(CONFIG_COMPAT)		+= entry32_common.o signal32_common.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 739e13b54820..fdcc210028b5 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -26,6 +26,7 @@
 #include <asm/esr.h>
 #include <asm/fpsimd.h>
 #include <asm/signal32.h>
+#include <asm/signal32_common.h>
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 
@@ -103,28 +104,6 @@ struct a32_rt_sigframe {
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
-static inline int put_sigset_t(compat_sigset_t __user *uset, sigset_t *set)
-{
-	compat_sigset_t	cset;
-
-	cset.sig[0] = set->sig[0] & 0xffffffffull;
-	cset.sig[1] = set->sig[0] >> 32;
-
-	return copy_to_user(uset, &cset, sizeof(*uset));
-}
-
-static inline int get_sigset_t(sigset_t *set,
-			       const compat_sigset_t __user *uset)
-{
-	compat_sigset_t s32;
-
-	if (copy_from_user(&s32, uset, sizeof(*uset)))
-		return -EFAULT;
-
-	set->sig[0] = s32.sig[0] | (((long)s32.sig[1]) << 32);
-	return 0;
-}
-
 /*
  * VFP save/restore code.
  *
diff --git a/arch/arm64/kernel/signal32_common.c b/arch/arm64/kernel/signal32_common.c
new file mode 100644
index 000000000000..21995fc4e0b4
--- /dev/null
+++ b/arch/arm64/kernel/signal32_common.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * Based on arch/arm/kernel/signal.c
+ *
+ * Copyright (C) 1995-2009 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ * Modified by Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/compat.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+
+#include <asm/signal32_common.h>
+#include <asm/unistd.h>
+
+int put_sigset_t(compat_sigset_t __user *uset, sigset_t *set)
+{
+	compat_sigset_t	cset;
+
+	cset.sig[0] = set->sig[0] & 0xffffffffull;
+	cset.sig[1] = set->sig[0] >> 32;
+
+	return copy_to_user(uset, &cset, sizeof(*uset));
+}
+
+int get_sigset_t(sigset_t *set, const compat_sigset_t __user *uset)
+{
+	compat_sigset_t s32;
+
+	if (copy_from_user(&s32, uset, sizeof(*uset)))
+		return -EFAULT;
+
+	set->sig[0] = s32.sig[0] | (((long)s32.sig[1]) << 32);
+	return 0;
+}
-- 
2.17.0
