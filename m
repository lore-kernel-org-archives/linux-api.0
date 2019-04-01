From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 6/7] arm64: Advertise ARM64_HAS_DCPODP cpu feature
Date: Mon,  1 Apr 2019 11:45:14 +0100
Message-ID: <20190401104515.39775-7-andrew.murray@arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190401104515.39775-1-andrew.murray@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-api@vger.kernel.org, Phil Blundell <pb@pbcl.net>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Advertise ARM64_HAS_DCPOP when both DC CVAP and DC CVADP are supported.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/cpucaps.h | 3 ++-
 arch/arm64/kernel/cpufeature.c   | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

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
index 5e27d2dbe45e..c74b25895c43 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1339,6 +1339,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Data cache clean to Point of Deep Persistence",
+		.capability = ARM64_HAS_DCPODP,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
+		.min_field_value = 2,
+	},
 #endif
 #ifdef CONFIG_ARM64_SVE
 	{
-- 
2.21.0
