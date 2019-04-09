From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v5 2/6] arm64: HWCAP: encapsulate elf_hwcap
Date: Tue,  9 Apr 2019 10:52:41 +0100
Message-ID: <20190409095245.42524-3-andrew.murray@arm.com>
References: <20190409095245.42524-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101257-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190409095245.42524-1-andrew.murray@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: linux-api@vger.kernel.org

The introduction of AT_HWCAP2 introduced accessors which ensure that
hwcap features are set and tested appropriately.

Let's now mandate access to elf_hwcap via these accessors by making
elf_hwcap static within cpufeature.c.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 15 ++++---------
 arch/arm64/include/asm/hwcap.h      |  7 +++---
 arch/arm64/kernel/cpufeature.c      | 33 +++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 347c17046668..a3f028f82def 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -392,19 +392,12 @@ extern DECLARE_BITMAP(boot_capabilities, ARM64_NPATCHABLE);
 	for_each_set_bit(cap, cpu_hwcaps, ARM64_NCAPS)
 
 bool this_cpu_has_cap(unsigned int cap);
+void cpu_set_feature(unsigned int num);
+bool cpu_have_feature(unsigned int num);
+unsigned long cpu_get_elf_hwcap(void);
+unsigned long cpu_get_elf_hwcap2(void);
 
-static inline void cpu_set_feature(unsigned int num)
-{
-	WARN_ON(num >= MAX_CPU_FEATURES);
-	elf_hwcap |= BIT(num);
-}
 #define cpu_set_named_feature(name) cpu_set_feature(cpu_feature(name))
-
-static inline bool cpu_have_feature(unsigned int num)
-{
-	WARN_ON(num >= MAX_CPU_FEATURES);
-	return elf_hwcap & BIT(num);
-}
 #define cpu_have_named_feature(name) cpu_have_feature(cpu_feature(name))
 
 /* System capability check for constant caps */
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index beb53a00eb16..d0d4e163c50b 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -17,6 +17,7 @@
 #define __ASM_HWCAP_H
 
 #include <uapi/asm/hwcap.h>
+#include <asm/cpufeature.h>
 
 #define COMPAT_HWCAP_HALF	(1 << 1)
 #define COMPAT_HWCAP_THUMB	(1 << 2)
@@ -40,7 +41,6 @@
 #define COMPAT_HWCAP2_CRC32	(1 << 4)
 
 #ifndef __ASSEMBLY__
-#include <linux/kernel.h>
 #include <linux/log2.h>
 
 /*
@@ -93,8 +93,8 @@
  * This yields a mask that user programs can use to figure out what
  * instruction set this cpu supports.
  */
-#define ELF_HWCAP		lower_32_bits(elf_hwcap)
-#define ELF_HWCAP2		upper_32_bits(elf_hwcap)
+#define ELF_HWCAP		cpu_get_elf_hwcap()
+#define ELF_HWCAP2		cpu_get_elf_hwcap2()
 
 #ifdef CONFIG_COMPAT
 #define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
@@ -110,6 +110,5 @@ enum {
 #endif
 };
 
-extern unsigned long elf_hwcap;
 #endif
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 986ceeacd19f..a655d1bb1186 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -35,8 +35,8 @@
 #include <asm/traps.h>
 #include <asm/virt.h>
 
-unsigned long elf_hwcap __read_mostly;
-EXPORT_SYMBOL_GPL(elf_hwcap);
+/* Kernel representation of AT_HWCAP and AT_HWCAP2 */
+static unsigned long elf_hwcap __read_mostly;
 
 #ifdef CONFIG_COMPAT
 #define COMPAT_ELF_HWCAP_DEFAULT	\
@@ -1947,6 +1947,35 @@ bool this_cpu_has_cap(unsigned int n)
 	return false;
 }
 
+void cpu_set_feature(unsigned int num)
+{
+	WARN_ON(num >= MAX_CPU_FEATURES);
+	elf_hwcap |= BIT(num);
+}
+EXPORT_SYMBOL_GPL(cpu_set_feature);
+
+bool cpu_have_feature(unsigned int num)
+{
+	WARN_ON(num >= MAX_CPU_FEATURES);
+	return elf_hwcap & BIT(num);
+}
+EXPORT_SYMBOL_GPL(cpu_have_feature);
+
+unsigned long cpu_get_elf_hwcap(void)
+{
+	/*
+	 * We currently only populate the first 32 bits of AT_HWCAP. Please
+	 * note that for userspace compatibility we guarantee that bits 62
+	 * and 63 will always be returned as 0.
+	 */
+	return lower_32_bits(elf_hwcap);
+}
+
+unsigned long cpu_get_elf_hwcap2(void)
+{
+	return upper_32_bits(elf_hwcap);
+}
+
 static void __init setup_system_capabilities(void)
 {
 	/*
-- 
2.21.0
