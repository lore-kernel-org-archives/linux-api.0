From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v5 6/6] arm64: Advertise ARM64_HAS_DCPODP cpu feature
Date: Tue,  9 Apr 2019 10:52:45 +0100
Message-ID: <20190409095245.42524-7-andrew.murray@arm.com>
References: <20190409095245.42524-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101261-glibc-alpha=m.gmane.org@sourceware.org>
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

Advertise ARM64_HAS_DCPODP when both DC CVAP and DC CVADP are supported.

Even though we don't use this feature now, we provide it for consistency
with DCPOP and anticipate it being used in the future.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpufeature.c   | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f6a76e43f39e..defdc67d9ab4 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -61,7 +61,8 @@
 #define ARM64_HAS_GENERIC_AUTH_ARCH		40
 #define ARM64_HAS_GENERIC_AUTH_IMP_DEF		41
 #define ARM64_HAS_IRQ_PRIO_MASKING		42
+#define ARM64_HAS_DCPODP			43
 
-#define ARM64_NCAPS				43
+#define ARM64_NCAPS				44
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f8b682a3a9f4..9d18e45311fd 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1340,6 +1340,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Data cache clean to Point of Deep Persistence",
+		.capability = ARM64_HAS_DCPODP,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
+		.min_field_value = 2,
+	},
 #endif
 #ifdef CONFIG_ARM64_SVE
 	{
-- 
2.21.0
