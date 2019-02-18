From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/8] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
Date: Mon, 18 Feb 2019 22:07:06 +0100
Message-ID: <20190218210712.3503891-3-arnd@arndb.de>
References: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218210712.3503891-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, yury.norov@gmail.com, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, arnd@arndb.de, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>, Yury Norov <ynorov@caviumnetworks.com>, Yury Norov <ynorov@marvell.com>
List-Id: linux-api@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.com>

All new 32-bit architectures should have 64-bit userspace off_t type, but
existing architectures has 32-bit ones.

To enforce the rule, new config option is added to arch/Kconfig that defaults
ARCH_32BIT_OFF_T to be disabled for new 32-bit architectures. All existing
32-bit architectures enable it explicitly.

New option affects force_o_largefile() behaviour. Namely, if userspace
off_t is 64-bits long, we have no reason to reject user to open big files.

Note that even if architectures has only 64-bit off_t in the kernel
(arc, c6x, h8300, hexagon, nios2, openrisc, and unicore32),
a libc may use 32-bit off_t, and therefore want to limit the file size
to 4GB unless specified differently in the open flags.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Yury Norov <ynorov@marvell.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig            | 15 +++++++++++++++
 arch/arc/Kconfig        |  1 +
 arch/arm/Kconfig        |  1 +
 arch/c6x/Kconfig        |  1 +
 arch/csky/Kconfig       |  1 +
 arch/h8300/Kconfig      |  1 +
 arch/hexagon/Kconfig    |  1 +
 arch/m68k/Kconfig       |  1 +
 arch/microblaze/Kconfig |  1 +
 arch/mips/Kconfig       |  1 +
 arch/nds32/Kconfig      |  1 +
 arch/nios2/Kconfig      |  1 +
 arch/openrisc/Kconfig   |  1 +
 arch/parisc/Kconfig     |  1 +
 arch/powerpc/Kconfig    |  1 +
 arch/riscv/Kconfig      |  1 +
 arch/sh/Kconfig         |  1 +
 arch/sparc/Kconfig      |  1 +
 arch/unicore32/Kconfig  |  1 +
 arch/x86/Kconfig        |  1 +
 arch/x86/um/Kconfig     |  1 +
 arch/xtensa/Kconfig     |  1 +
 include/linux/fcntl.h   |  2 +-
 23 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 46db715a7f42..89fe3d651349 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -276,6 +276,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
 config ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	bool
 
+config ARCH_32BIT_OFF_T
+	bool
+	depends on !64BIT
+	help
+	  All new 32-bit architectures should have 64-bit off_t type on
+	  userspace side which corresponds to the loff_t kernel type. This
+	  is the requirement for modern ABIs. Some existing architectures
+	  already have 32-bit off_t. This option is enabled for all such
+	  architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
+	  h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
+	  nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
+	  unicore32, x86_32 and xtensa. This is the complete list. Any
+	  new 32-bit architecture should declare 64-bit off_t type on user
+	  side and so should not enable this option.
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 376366a7db81..1cfe4197146f 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -14,6 +14,7 @@ config ARC
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_SUPPORTS_ATOMIC_RMW if ARC_HAS_LLSC
+	select ARCH_32BIT_OFF_T
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 664e918e2624..8933f7337e56 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2,6 +2,7 @@
 config ARM
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK if !HAVE_ARCH_PFN_VALID && !KEXEC
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 456e154674d1..e5cd3c5f8399 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -6,6 +6,7 @@
 
 config C6X
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select CLKDEV_LOOKUP
diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
index 398113c845f5..6959e0b1e956 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -1,5 +1,6 @@
 config CSKY
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 6472a0685470..c071da34e081 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config H8300
         def_bool y
+	select ARCH_32BIT_OFF_T
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index fb2fbfcfc532..ac441680dcc0 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -4,6 +4,7 @@ comment "Linux Kernel Configuration for Hexagon"
 
 config HEXAGON
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_NO_PREEMPT
 	select HAVE_OPROFILE
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index e173ea2ff395..b54206408f91 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -2,6 +2,7 @@
 config M68K
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if HAS_DMA
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
 	select ARCH_NO_COHERENT_DMA_MMAP if !MMU
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 58aff2653d86..a51b965b3b82 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -1,5 +1,6 @@
 config MICROBLAZE
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_NO_SWAP
 	select ARCH_HAS_DMA_COHERENT_TO_PFN if MMU
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 787290781b8c..d80ccabd3c06 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2,6 +2,7 @@
 config MIPS
 	bool
 	default y
+	select ARCH_32BIT_OFF_T if !64BIT
 	select ARCH_BINFMT_ELF_STATE if MIPS_FP_SUPPORT
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK
diff --git a/arch/nds32/Kconfig b/arch/nds32/Kconfig
index dda1906bba11..addb7f5f5264 100644
--- a/arch/nds32/Kconfig
+++ b/arch/nds32/Kconfig
@@ -5,6 +5,7 @@
 
 config NDS32
         def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_WANT_FRAME_POINTERS if FTRACE
diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
index 532343eebf89..c3e913ef4f0c 100644
--- a/arch/nios2/Kconfig
+++ b/arch/nios2/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config NIOS2
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_NO_SWAP
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 09ab59e942ae..a5e361fbb75a 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -6,6 +6,7 @@
 
 config OPENRISC
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select OF
 	select OF_EARLY_FLATTREE
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 7ca2c3ebad64..c8e621296092 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config PARISC
 	def_bool y
+	select ARCH_32BIT_OFF_T if !64BIT
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2890d36eb531..375d0dc0dc7d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -128,6 +128,7 @@ config PPC
 	#
 	# Please keep this list sorted alphabetically.
 	#
+	select ARCH_32BIT_OFF_T if PPC32
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index feeeaa60697c..09fa3a87bf30 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -11,6 +11,7 @@ config 32BIT
 
 config RISCV
 	def_bool y
+	select ARCH_32BIT_OFF_T if !64BIT
 	# even on 32-bit, physical (and DMA) addresses are > 32-bits
 	select PHYS_ADDR_T_64BIT
 	select OF
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index a9c36f95744a..d9a9144dec35 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -62,6 +62,7 @@ config SUPERH
 
 config SUPERH32
 	def_bool "$(ARCH)" = "sh"
+	select ARCH_32BIT_OFF_T
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_IOREMAP_PROT if MMU && !X2TLB
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index d5dd652fb8cc..40f8f4f73fe8 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -49,6 +49,7 @@ config SPARC
 
 config SPARC32
 	def_bool !64BIT
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index c3a41bfe161b..a7f1ae58d211 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config UNICORE32
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15af091611e2..7aac274c2849 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select ACPI_LEGACY_TABLES_LOOKUP	if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ANON_INODES
+	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_DISCARD_MEMBLOCK
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index f518b4744ff8..ab14e6f73ca4 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -17,6 +17,7 @@ config 64BIT
 config X86_32
 	def_bool !64BIT
 	select HAVE_AOUT
+	select ARCH_32BIT_OFF_T
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 20a0756f27ef..2033b4485cc4 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config XTENSA
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_NO_COHERENT_DMA_MMAP if !MMU
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 27dc7a60693e..d019df946cb2 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -12,7 +12,7 @@
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
 
 #ifndef force_o_largefile
-#define force_o_largefile() (BITS_PER_LONG != 32)
+#define force_o_largefile() (!IS_ENABLED(CONFIG_ARCH_32BIT_OFF_T))
 #endif
 
 #if BITS_PER_LONG == 32
-- 
2.20.0
