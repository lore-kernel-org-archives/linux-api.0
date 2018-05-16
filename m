From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 14/24] arm64: change compat_elf_hwcap and compat_elf_hwcap2 prefix to a32
Date: Wed, 16 May 2018 11:18:59 +0300
Message-ID: <20180516081910.10067-15-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

ILP32 patch series introduces new type of binaries which is also compat.
So rename existung aarch32 compat_elf_hwcap's helps to avoid confusing.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/arm64/include/asm/hwcap.h       |  2 +-
 arch/arm64/kernel/binfmt_elf32.c     |  4 ++--
 arch/arm64/kernel/cpufeature.c       | 14 +++++++-------
 arch/arm64/kernel/cpuinfo.c          | 10 +++++-----
 drivers/clocksource/arm_arch_timer.c |  2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 99dfd9277559..428b745b5386 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -47,7 +47,7 @@
 #define ELF_HWCAP		(elf_hwcap)
 
 #ifdef CONFIG_AARCH32_EL0
-extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
+extern unsigned int a32_elf_hwcap, a32_elf_hwcap2;
 #endif
 
 enum {
diff --git a/arch/arm64/kernel/binfmt_elf32.c b/arch/arm64/kernel/binfmt_elf32.c
index 440fa84f62b3..2b49d2a40d8b 100644
--- a/arch/arm64/kernel/binfmt_elf32.c
+++ b/arch/arm64/kernel/binfmt_elf32.c
@@ -20,8 +20,8 @@
 })
 
 #define COMPAT_ARCH_DLINFO
-#define COMPAT_ELF_HWCAP		(compat_elf_hwcap)
-#define COMPAT_ELF_HWCAP2		(compat_elf_hwcap2)
+#define COMPAT_ELF_HWCAP		(a32_elf_hwcap)
+#define COMPAT_ELF_HWCAP2		(a32_elf_hwcap2)
 
 #define compat_arch_setup_additional_pages \
 					aarch32_setup_vectors_page
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 28b7bc582334..4867fb142e86 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -38,15 +38,15 @@ unsigned long elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);
 
 #ifdef CONFIG_AARCH32_EL0
-#define COMPAT_ELF_HWCAP_DEFAULT	\
+#define AARCH32_EL0_ELF_HWCAP_DEFAULT	\
 				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
 				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
 				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
 				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
 				 COMPAT_HWCAP_LPAE)
-unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
-unsigned int compat_elf_hwcap2 __read_mostly;
+unsigned int a32_elf_hwcap __read_mostly = AARCH32_EL0_ELF_HWCAP_DEFAULT;
+unsigned int a32_elf_hwcap2 __read_mostly;
 #endif
 
 DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
@@ -1151,10 +1151,10 @@ static void __init cap_set_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 		break;
 #ifdef CONFIG_AARCH32_EL0
 	case CAP_COMPAT_HWCAP:
-		compat_elf_hwcap |= (u32)cap->hwcap;
+		a32_elf_hwcap |= (u32)cap->hwcap;
 		break;
 	case CAP_COMPAT_HWCAP2:
-		compat_elf_hwcap2 |= (u32)cap->hwcap;
+		a32_elf_hwcap2 |= (u32)cap->hwcap;
 		break;
 #endif
 	default:
@@ -1174,10 +1174,10 @@ static bool cpus_have_elf_hwcap(const struct arm64_cpu_capabilities *cap)
 		break;
 #ifdef CONFIG_AARCH32_EL0
 	case CAP_COMPAT_HWCAP:
-		rc = (compat_elf_hwcap & (u32)cap->hwcap) != 0;
+		rc = (a32_elf_hwcap & (u32)cap->hwcap) != 0;
 		break;
 	case CAP_COMPAT_HWCAP2:
-		rc = (compat_elf_hwcap2 & (u32)cap->hwcap) != 0;
+		rc = (a32_elf_hwcap2 & (u32)cap->hwcap) != 0;
 		break;
 #endif
 	default:
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 23fdf30dc0a3..a57a6fd0afab 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -120,7 +120,7 @@ static const char *const compat_hwcap2_str[] = {
 static int c_show(struct seq_file *m, void *v)
 {
 	int i, j;
-	bool compat = personality(current->personality) == PER_LINUX32;
+	bool aarch32 = personality(current->personality) == PER_LINUX32;
 
 	for_each_online_cpu(i) {
 		struct cpuinfo_arm64 *cpuinfo = &per_cpu(cpu_data, i);
@@ -132,7 +132,7 @@ static int c_show(struct seq_file *m, void *v)
 		 * "processor".  Give glibc what it expects.
 		 */
 		seq_printf(m, "processor\t: %d\n", i);
-		if (compat)
+		if (aarch32)
 			seq_printf(m, "model name\t: ARMv8 Processor rev %d (%s)\n",
 				   MIDR_REVISION(midr), COMPAT_ELF_PLATFORM);
 
@@ -147,14 +147,14 @@ static int c_show(struct seq_file *m, void *v)
 		 * software which does already (at least for 32-bit).
 		 */
 		seq_puts(m, "Features\t:");
-		if (compat) {
+		if (aarch32) {
 #ifdef CONFIG_AARCH32_EL0
 			for (j = 0; compat_hwcap_str[j]; j++)
-				if (compat_elf_hwcap & (1 << j))
+				if (a32_elf_hwcap & (1 << j))
 					seq_printf(m, " %s", compat_hwcap_str[j]);
 
 			for (j = 0; compat_hwcap2_str[j]; j++)
-				if (compat_elf_hwcap2 & (1 << j))
+				if (a32_elf_hwcap2 & (1 << j))
 					seq_printf(m, " %s", compat_hwcap2_str[j]);
 #endif /* CONFIG_AARCH32_EL0 */
 		} else {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index c3c6a8d48adc..d8b12b9be97b 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -765,7 +765,7 @@ static void arch_timer_evtstrm_enable(int divider)
 	arch_timer_set_cntkctl(cntkctl);
 	elf_hwcap |= HWCAP_EVTSTRM;
 #ifdef CONFIG_AARCH32_EL0
-	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
+	a32_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
 #endif
 	cpumask_set_cpu(smp_processor_id(), &evtstrm_available);
 }
-- 
2.17.0
