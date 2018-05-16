From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 04/24] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T config option
Date: Wed, 16 May 2018 11:18:49 +0300
Message-ID: <20180516081910.10067-5-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

All new 32-bit architectures should have 64-bit userspace off_t type, but
existing architectures has 32-bit ones.

To enforce the rule, new config option is added to arch/Kconfig that defaults
ARCH_32BIT_OFF_T to be disabled for new 32-bit architectures. All existing
32-bit architectures enable it explicitly.

New option affects force_o_largefile() behaviour. Namely, if userspace
off_t is 64-bits long, we have no reason to reject user to open big files.

Note that even if architectures has only 64-bit off_t in the kernel
(arc, c6x, h8300, hexagon, metag, nios2, openrisc, tile32 and unicore32),
a libc may use 32-bit off_t, and therefore want to limit the file size
to 4GB unless specified differently in the open flags.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig            | 15 +++++++++++++++
 arch/arc/Kconfig        |  1 +
 arch/arm/Kconfig        |  1 +
 arch/blackfin/Kconfig   |  1 +
 arch/cris/Kconfig       |  1 +
 arch/frv/Kconfig        |  1 +
 arch/h8300/Kconfig      |  1 +
 arch/hexagon/Kconfig    |  1 +
 arch/m32r/Kconfig       |  1 +
 arch/m68k/Kconfig       |  1 +
 arch/metag/Kconfig      |  1 +
 arch/microblaze/Kconfig |  1 +
 arch/mips/Kconfig       |  1 +
 arch/mn10300/Kconfig    |  1 +
 arch/nios2/Kconfig      |  1 +
 arch/openrisc/Kconfig   |  1 +
 arch/parisc/Kconfig     |  1 +
 arch/powerpc/Kconfig    |  1 +
 arch/score/Kconfig      |  1 +
 arch/sh/Kconfig         |  1 +
 arch/sparc/Kconfig      |  1 +
 arch/tile/Kconfig       |  1 +
 arch/unicore32/Kconfig  |  1 +
 arch/x86/Kconfig        |  1 +
 arch/x86/um/Kconfig     |  1 +
 arch/xtensa/Kconfig     |  1 +
 include/linux/fcntl.h   |  2 +-
 27 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 76c0b54443b1..ee079244dc3c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -264,6 +264,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
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
index d76bf4a83740..9b48c82a12f6 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -11,6 +11,7 @@ config ARC
 	select ARC_TIMERS
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_SUPPORTS_ATOMIC_RMW if ARC_HAS_LLSC
+	select ARCH_32BIT_OFF_T
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7e3d53575486..825a611a9d86 100644
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
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index d9c2866ba618..5a99c1ccad67 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -13,6 +13,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config BLACKFIN
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index cd5a0865c97f..db7ea0a9e805 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -54,6 +54,7 @@ config LOCKDEP_SUPPORT
 config CRIS
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index af369b05fed5..9dc671f8f4a6 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -2,6 +2,7 @@
 config FRV
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_PERF_EVENTS
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 091d6d04b5e5..6fc8a034ddb6 100644
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
index 76d2f20d525e..f6e748178292 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -4,6 +4,7 @@ comment "Linux Kernel Configuration for Hexagon"
 
 config HEXAGON
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select HAVE_OPROFILE
 	# Other pending projects/to-do items.
 	# select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index dd84ee194579..8d9c2244b144 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -2,6 +2,7 @@
 config M32R
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select INIT_ALL_POSSIBLE
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 785612b576f7..8aafd39b5142 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -2,6 +2,7 @@
 config M68K
 	bool
 	default y
+	select ARCH_32BIT_OFF_T
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
 	select ARCH_NO_COHERENT_DMA_MMAP if !MMU
 	select HAVE_IDE
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index c7b62a339539..8bc07fa5982d 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config METAG
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select EMBEDDED
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 3817a3e2146c..48270951c3aa 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -1,5 +1,6 @@
 config MICROBLAZE
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_NO_COHERENT_DMA_MMAP if !MMU
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8128c3b68d6b..3eb048042004 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2,6 +2,7 @@
 config MIPS
 	bool
 	default y
+	select ARCH_32BIT_OFF_T if !64BIT
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index e9d8d60bd28b..7840859b3f9f 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config MN10300
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select HAVE_EXIT_THREAD
 	select HAVE_OPROFILE
 	select HAVE_UID16
diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
index 3d4ec88f1db1..9b4a9cf4af3b 100644
--- a/arch/nios2/Kconfig
+++ b/arch/nios2/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config NIOS2
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select TIMER_OF
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 339df7324e9c..24c7c25064e5 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -6,6 +6,7 @@
 
 config OPENRISC
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select OF
 	select OF_EARLY_FLATTREE
 	select IRQ_DOMAIN
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 9792d8cf4f56..93f8cecbb741 100644
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
index 73ce5dd07642..4f38ce304b78 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -134,6 +134,7 @@ config PPC
 	#
 	# Please keep this list sorted alphabetically.
 	#
+	select ARCH_32BIT_OFF_T if PPC32
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select ARCH_HAS_ELF_RANDOMIZE
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index d881f99c9ddd..7371e5fb18b9 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -3,6 +3,7 @@ menu "Machine selection"
 
 config SCORE
        def_bool y
+       select ARCH_32BIT_OFF_T
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
        select GENERIC_ATOMIC64
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 97fe29316476..bbd75a7cbbc4 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -58,6 +58,7 @@ config SUPERH
 
 config SUPERH32
 	def_bool ARCH = "sh"
+	select ARCH_32BIT_OFF_T
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_IOREMAP_PROT if MMU && !X2TLB
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 8767e45f1b2b..3cc26d90ab82 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -47,6 +47,7 @@ config SPARC
 
 config SPARC32
 	def_bool !64BIT
+	select ARCH_32BIT_OFF_T
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
 	select HAVE_UID16
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index ef9d403cbbe4..542bf49cdfcc 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -4,6 +4,7 @@
 
 config TILE
 	def_bool y
+	select ARCH_32BIT_OFF_T if !64BIT
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 462e59a7ae78..34694eb7c790 100644
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
index 0fa71a78ec99..47c2f1eaa7ad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -44,6 +44,7 @@ config X86
 	select ACPI_LEGACY_TABLES_LOOKUP	if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ANON_INODES
+	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 13ed827c7c66..d1de823a8fe7 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -22,6 +22,7 @@ config 64BIT
 config X86_32
 	def_bool !64BIT
 	select HAVE_AOUT
+	select ARCH_32BIT_OFF_T
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index c921e8bccdc8..20ebab4fbaf6 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -4,6 +4,7 @@ config ZONE_DMA
 
 config XTENSA
 	def_bool y
+	select ARCH_32BIT_OFF_T
 	select ARCH_NO_COHERENT_DMA_MMAP if !MMU
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_IPC_PARSE_VERSION
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
2.17.0
