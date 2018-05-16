From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH] UAPI: Document auxvec AT_* namespace policy and note reservations
Date: Wed, 16 May 2018 15:20:47 +0100
Message-ID: <1526480447-18185-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt <palmer@sifive.com>, Albert Ou <albert@sifive.com>, Martin
List-Id: linux-api@vger.kernel.org

There are constraints on defining AT_* auxvec tags that are not
obvious to the casual maintainer of either the global
<uapi/linux/auxvec.h> or the arch-specific headers.  This is likely
to lead to mistakes.  (I certainly fell foul of it...)

For the benefit of future maintainers, this patch collects the
relevant information in one place, documenting how the namespace
needs to be managed, and noting all the values currently in use.

Maintaining a global list may result in some merge conflicts, but
AT_* values are not added frequently.  I'm open to suggestions on
the best approach.

I also assume that values 38 and 39 may have been used for
historical purposes, such as an architecture that is no longer
supported.  If they have definitely never been used for anything,
they could be removed from the "reserved" list.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Albert Ou <albert@sifive.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/alpha/include/uapi/asm/auxvec.h      |  5 ++++
 arch/arm/include/uapi/asm/auxvec.h        |  5 ++++
 arch/arm64/include/uapi/asm/auxvec.h      |  5 ++++
 arch/ia64/include/uapi/asm/auxvec.h       |  5 ++++
 arch/microblaze/include/uapi/asm/auxvec.h |  4 ++++
 arch/mips/include/uapi/asm/auxvec.h       |  5 ++++
 arch/nds32/include/uapi/asm/auxvec.h      |  5 ++++
 arch/powerpc/include/uapi/asm/auxvec.h    |  5 ++++
 arch/riscv/include/uapi/asm/auxvec.h      |  5 ++++
 arch/s390/include/uapi/asm/auxvec.h       |  5 ++++
 arch/sh/include/uapi/asm/auxvec.h         |  5 ++++
 arch/sparc/include/uapi/asm/auxvec.h      |  8 ++++---
 arch/x86/include/uapi/asm/auxvec.h        |  5 ++++
 arch/xtensa/include/uapi/asm/auxvec.h     |  5 ++++
 include/uapi/linux/auxvec.h               | 40 ++++++++++++++++++++++++++++---
 15 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/auxvec.h b/arch/alpha/include/uapi/asm/auxvec.h
index 57cae87..9370d78 100644
--- a/arch/alpha/include/uapi/asm/auxvec.h
+++ b/arch/alpha/include/uapi/asm/auxvec.h
@@ -22,6 +22,11 @@
 #define AT_L2_CACHESHAPE	36
 #define AT_L3_CACHESHAPE	37
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
 
 #endif /* __ASM_ALPHA_AUXVEC_H */
diff --git a/arch/arm/include/uapi/asm/auxvec.h b/arch/arm/include/uapi/asm/auxvec.h
index 5c09da5..b5cfba2 100644
--- a/arch/arm/include/uapi/asm/auxvec.h
+++ b/arch/arm/include/uapi/asm/auxvec.h
@@ -5,4 +5,9 @@
 /* VDSO location */
 #define AT_SYSINFO_EHDR	33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #endif
diff --git a/arch/arm64/include/uapi/asm/auxvec.h b/arch/arm64/include/uapi/asm/auxvec.h
index ec0a86d..3da03fc 100644
--- a/arch/arm64/include/uapi/asm/auxvec.h
+++ b/arch/arm64/include/uapi/asm/auxvec.h
@@ -20,6 +20,11 @@
 /* vDSO location */
 #define AT_SYSINFO_EHDR	33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
 
 #endif
diff --git a/arch/ia64/include/uapi/asm/auxvec.h b/arch/ia64/include/uapi/asm/auxvec.h
index 09969a5..a81aec5 100644
--- a/arch/ia64/include/uapi/asm/auxvec.h
+++ b/arch/ia64/include/uapi/asm/auxvec.h
@@ -9,6 +9,11 @@
 #define AT_SYSINFO	32
 #define AT_SYSINFO_EHDR	33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 #endif /* _ASM_IA64_AUXVEC_H */
diff --git a/arch/microblaze/include/uapi/asm/auxvec.h b/arch/microblaze/include/uapi/asm/auxvec.h
index 93dd07b..b08c6dc 100644
--- a/arch/microblaze/include/uapi/asm/auxvec.h
+++ b/arch/microblaze/include/uapi/asm/auxvec.h
@@ -1,2 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
diff --git a/arch/mips/include/uapi/asm/auxvec.h b/arch/mips/include/uapi/asm/auxvec.h
index 612c2c4..ee94899 100644
--- a/arch/mips/include/uapi/asm/auxvec.h
+++ b/arch/mips/include/uapi/asm/auxvec.h
@@ -15,6 +15,11 @@
 /* Location of VDSO image. */
 #define AT_SYSINFO_EHDR		33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
 
 #endif /* __ASM_AUXVEC_H */
diff --git a/arch/nds32/include/uapi/asm/auxvec.h b/arch/nds32/include/uapi/asm/auxvec.h
index 56043ce..0173da1 100644
--- a/arch/nds32/include/uapi/asm/auxvec.h
+++ b/arch/nds32/include/uapi/asm/auxvec.h
@@ -7,6 +7,11 @@
 /* VDSO location */
 #define AT_SYSINFO_EHDR	33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 1
 
 #endif
diff --git a/arch/powerpc/include/uapi/asm/auxvec.h b/arch/powerpc/include/uapi/asm/auxvec.h
index 7af21dc..3da0713 100644
--- a/arch/powerpc/include/uapi/asm/auxvec.h
+++ b/arch/powerpc/include/uapi/asm/auxvec.h
@@ -48,6 +48,11 @@
 #define AT_L3_CACHESIZE		46
 #define AT_L3_CACHEGEOMETRY	47
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH	14 /* entries in ARCH_DLINFO */
 
 #endif
diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index 1376515..0dd7983 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -21,4 +21,9 @@
 /* vDSO location */
 #define AT_SYSINFO_EHDR 33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/s390/include/uapi/asm/auxvec.h b/arch/s390/include/uapi/asm/auxvec.h
index a056c46..c30090a 100644
--- a/arch/s390/include/uapi/asm/auxvec.h
+++ b/arch/s390/include/uapi/asm/auxvec.h
@@ -4,6 +4,11 @@
 
 #define AT_SYSINFO_EHDR		33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
 
 #endif
diff --git a/arch/sh/include/uapi/asm/auxvec.h b/arch/sh/include/uapi/asm/auxvec.h
index 8eb47ed..e5b6ebc 100644
--- a/arch/sh/include/uapi/asm/auxvec.h
+++ b/arch/sh/include/uapi/asm/auxvec.h
@@ -34,6 +34,11 @@
 #define AT_L1D_CACHESHAPE	35
 #define AT_L2_CACHESHAPE	36
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
 
 #endif /* __ASM_SH_AUXVEC_H */
diff --git a/arch/sparc/include/uapi/asm/auxvec.h b/arch/sparc/include/uapi/asm/auxvec.h
index ab8780f..76aba18 100644
--- a/arch/sparc/include/uapi/asm/auxvec.h
+++ b/arch/sparc/include/uapi/asm/auxvec.h
@@ -3,13 +3,15 @@
 
 #define AT_SYSINFO_EHDR		33
 
-/* Avoid overlap with other AT_* values since they are consolidated in
- * glibc and any overlaps can cause problems
- */
 #define AT_ADI_BLKSZ	48
 #define AT_ADI_NBITS	49
 #define AT_ADI_UEONADI	50
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #define AT_VECTOR_SIZE_ARCH	4
 
 #endif /* !(__ASMSPARC_AUXVEC_H) */
diff --git a/arch/x86/include/uapi/asm/auxvec.h b/arch/x86/include/uapi/asm/auxvec.h
index 580e3c5..700c0fc 100644
--- a/arch/x86/include/uapi/asm/auxvec.h
+++ b/arch/x86/include/uapi/asm/auxvec.h
@@ -10,6 +10,11 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 /* entries in ARCH_DLINFO: */
 #if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
 # define AT_VECTOR_SIZE_ARCH 2
diff --git a/arch/xtensa/include/uapi/asm/auxvec.h b/arch/xtensa/include/uapi/asm/auxvec.h
index 257dec7..995bbd8 100644
--- a/arch/xtensa/include/uapi/asm/auxvec.h
+++ b/arch/xtensa/include/uapi/asm/auxvec.h
@@ -1,4 +1,9 @@
 #ifndef __XTENSA_AUXVEC_H
 #define __XTENSA_AUXVEC_H
 
+/*
+ * Do not add new AT_* definitions here without coordinating with
+ * <uapi/linux/auxvec.h>
+ */
+
 #endif
diff --git a/include/uapi/linux/auxvec.h b/include/uapi/linux/auxvec.h
index abe5f2b..c19c043 100644
--- a/include/uapi/linux/auxvec.h
+++ b/include/uapi/linux/auxvec.h
@@ -4,8 +4,19 @@
 
 #include <asm/auxvec.h>
 
-/* Symbolic values for the entries in the auxiliary table
-   put on the initial stack */
+/*
+ * Symbolic values for the entries in the auxiliary table
+ * put on the initial stack.
+ *
+ * Values with definitions here are common to all architectures.
+ * Individual architectures may define additional values in their
+ * <uapi/asm/auxvec.h>.
+ *
+ * NOTE: Userspace may treat these numbers as a global namespace.
+ * Any per-architecture definition must not overlap with these or with
+ * any other architecture's definitions, unless it has identical name
+ * and number and compatible meaning.
+ */
 #define AT_NULL   0	/* end of vector */
 #define AT_IGNORE 1	/* entry should be ignored */
 #define AT_EXECFD 2	/* file descriptor of program */
@@ -24,7 +35,11 @@
 #define AT_PLATFORM 15  /* string identifying CPU for optimizations */
 #define AT_HWCAP  16    /* arch dependent hints at CPU capabilities */
 #define AT_CLKTCK 17	/* frequency at which times() increments */
-/* AT_* values 18 through 22 are reserved */
+/* 18 reserved for AT_FPUCW		(sh) */
+/* 19 reserved for AT_DCACHEBSIZE	(powerpc) */
+/* 20 reserved for AT_ICACHEBSIZE	(powerpc) */
+/* 21 reserved for AT_UCACHEBSIZE	(powerpc) */
+/* 22 reserved for AT_IGNOREPPC		(powerpc) */
 #define AT_SECURE 23   /* secure mode boolean */
 #define AT_BASE_PLATFORM 24	/* string identifying real platform, may
 				 * differ from AT_PLATFORM. */
@@ -33,5 +48,24 @@
 
 #define AT_EXECFN  31	/* filename of program */
 
+/* 32 reserved for AT_SYSINFO		(alpha ia64 um x86) */
+/* 33 reserved for AT_SYSINFO_EHDR	(various architectures) */
+/* 34 reserved for AT_L1I_CACHESHAPE	(alpha sh) */
+/* 35 reserved for AT_L1D_CACHESHAPE	(alpha sh) */
+/* 36 reserved for AT_L2_CACHESHAPE	(alpha sh) */
+/* 37 reserved for AT_L3_CACHESHAPE	(alpha) */
+/* 38 reserved, do not allocate */
+/* 39 reserved, do not allocate */
+/* 40 reserved for AT_L1I_CACHESIZE	(powerpc) */
+/* 41 reserved for AT_L1I_CACHEGEOMETRY	(powerpc) */
+/* 42 reserved for AT_L1D_CACHESIZE	(powerpc) */
+/* 43 reserved for AT_L1D_CACHEGEOMETRY	(powerpc) */
+/* 44 reserved for AT_L2_CACHESIZE	(powerpc) */
+/* 45 reserved for AT_L2_CACHEGEOMETRY	(powerpc) */
+/* 46 reserved for AT_L3_CACHESIZE	(powerpc) */
+/* 47 reserved for AT_L3_CACHEGEOMETRY	(powerpc) */
+/* 48 reserved for AT_ADI_BLKSZ		(sparc) */
+/* 49 reserved for AT_ADI_NBITS		(sparc) */
+/* 50 reserved for AT_ADI_UEONADI	(sparc) */
 
 #endif /* _UAPI_LINUX_AUXVEC_H */
-- 
2.1.4
