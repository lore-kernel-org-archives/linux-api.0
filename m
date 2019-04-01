From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v3 4/7] arm64: Expose DC CVADP to userspace
Date: Mon,  1 Apr 2019 11:45:12 +0100
Message-ID: <20190401104515.39775-5-andrew.murray@arm.com>
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

ARMv8.5 builds upon the ARMv8.2 DC CVAP instruction by introducing a DC
CVADP instruction which cleans the data cache to the point of deep
persistence. Let's expose this support via the arm64 ELF hwcaps.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 Documentation/arm64/elf_hwcaps.txt  | 4 ++++
 arch/arm64/include/uapi/asm/hwcap.h | 5 +++++
 arch/arm64/kernel/cpufeature.c      | 1 +
 arch/arm64/kernel/cpuinfo.c         | 1 +
 4 files changed, 11 insertions(+)

diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index 13d6691b37be..c605757dd4db 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -135,6 +135,10 @@ HWCAP_DCPOP
 
     Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0001.
 
+HWCAP2_DCPODP
+
+    Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0010.
+
 HWCAP_SHA3
 
     Functionality implied by ID_AA64ISAR0_EL1.SHA3 == 0b0001.
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 453b45af80b7..d64af3913a9e 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -53,4 +53,9 @@
 #define HWCAP_PACA		(1 << 30)
 #define HWCAP_PACG		(1UL << 31)
 
+/*
+ * HWCAP2 flags - for AT_HWCAP2
+ */
+#define HWCAP2_DCPODP		(1 << 0)
+
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 84ca52fa75e5..5e27d2dbe45e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1590,6 +1590,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ASIMDHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_DIT_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_DIT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_DPB_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_DCPOP),
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_DPB_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, KERNEL_HWCAP_DCPODP),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_JSCVT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_LRCPC),
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 810db95f293f..093ca53ce1d1 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -85,6 +85,7 @@ static const char *const hwcap_str[] = {
 	"sb",
 	"paca",
 	"pacg",
+	"dcpodp",
 	NULL
 };
 
-- 
2.21.0
