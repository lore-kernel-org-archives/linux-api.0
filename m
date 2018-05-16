From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 15/24] arm64: ilp32: introduce binfmt_ilp32.c
Date: Wed, 16 May 2018 11:19:00 +0300
Message-ID: <20180516081910.10067-16-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

Like binfmt_elf32.c for AARCH32, binfmt_ilp32.c is needed to handle
ILP32 binaries.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Bamvor Jian Zhang <bamv2005@gmail.com>
---
 arch/arm64/kernel/Makefile       |  1 +
 arch/arm64/kernel/binfmt_ilp32.c | 87 ++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100644 arch/arm64/kernel/binfmt_ilp32.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index c63e0164fc12..3114191750ae 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -28,6 +28,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 
 arm64-obj-$(CONFIG_AARCH32_EL0)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o binfmt_elf32.o
+arm64-obj-$(CONFIG_ARM64_ILP32)		+= binfmt_ilp32.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
diff --git a/arch/arm64/kernel/binfmt_ilp32.c b/arch/arm64/kernel/binfmt_ilp32.c
new file mode 100644
index 000000000000..26b2477d190d
--- /dev/null
+++ b/arch/arm64/kernel/binfmt_ilp32.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * Support for ILP32 Linux/aarch64 ELF binaries.
+ */
+#undef CONFIG_AARCH32_EL0
+#define compat_elf_gregset_t	elf_gregset_t
+
+#include <linux/elfcore-compat.h>
+#include <linux/time.h>
+
+#undef	ELF_CLASS
+#define ELF_CLASS	ELFCLASS32
+
+#undef	elfhdr
+#undef	elf_phdr
+#undef	elf_shdr
+#undef	elf_note
+#undef	elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Addr
+
+/*
+ * Some data types as stored in coredump.
+ */
+#define user_long_t		compat_long_t
+#define user_siginfo_t		compat_siginfo_t
+#define copy_siginfo_to_user	copy_siginfo_to_user32
+
+/*
+ * The machine-dependent core note format types are defined in elfcore-compat.h,
+ * which requires asm/elf.h to define compat_elf_gregset_t et al.
+ */
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+/* AARCH64 ILP32 EABI. */
+#undef elf_check_arch
+#define elf_check_arch(x)		(((x)->e_machine == EM_AARCH64)	\
+					&& (x)->e_ident[EI_CLASS] == ELFCLASS32)
+
+#undef SET_PERSONALITY
+#define SET_PERSONALITY(ex)						\
+do {									\
+	set_bit(TIF_32BIT, &current->mm->context.flags);	\
+	set_thread_flag(TIF_32BIT_AARCH64);				\
+	clear_thread_flag(TIF_32BIT);					\
+} while (0)
+
+#undef ARCH_DLINFO
+#define ARCH_DLINFO							\
+do {									\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
+		    (elf_addr_t)(long)current->mm->context.vdso);	\
+} while (0)
+
+#undef ELF_PLATFORM
+#ifdef __AARCH64EB__
+#define ELF_PLATFORM		("aarch64_be:ilp32")
+#else
+#define ELF_PLATFORM		("aarch64:ilp32")
+#endif
+
+#undef ELF_ET_DYN_BASE
+#define ELF_ET_DYN_BASE COMPAT_ELF_ET_DYN_BASE
+
+#undef ELF_HWCAP
+#undef ELF_HWCAP2
+#define ELF_HWCAP			((u32) elf_hwcap)
+#define ELF_HWCAP2			((u32) (elf_hwcap >> 32))
+
+/*
+ * Rename a few of the symbols that binfmt_elf.c will define.
+ * These are all local so the names don't really matter, but it
+ * might make some debugging less confusing not to duplicate them.
+ */
+#define elf_format		compat_elf_format
+#define init_elf_binfmt		init_compat_elf_binfmt
+#define exit_elf_binfmt		exit_compat_elf_binfmt
+
+#undef ns_to_timeval
+#define ns_to_timeval ns_to_compat_timeval
+
+#include "../../../fs/binfmt_elf.c"
-- 
2.17.0
