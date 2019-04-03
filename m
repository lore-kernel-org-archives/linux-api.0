From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v4 4/6] arm64: Expose DC CVADP to userspace
Date: Wed,  3 Apr 2019 11:56:26 +0100
Message-ID: <20190403105628.39798-5-andrew.murray@arm.com>
References: <20190403105628.39798-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101154-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190403105628.39798-1-andrew.murray@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: linux-api@vger.kernel.org

ARMv8.5 builds upon the ARMv8.2 DC CVAP instruction by introducing a DC
CVADP instruction which cleans the data cache to the point of deep
persistence. Let's expose this support via the arm64 ELF hwcaps.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 Documentation/arm64/elf_hwcaps.txt  | 4 ++++
 arch/arm64/include/asm/hwcap.h      | 1 +
 arch/arm64/include/uapi/asm/hwcap.h | 5 +++++
 arch/arm64/kernel/cpufeature.c      | 1 +
 arch/arm64/kernel/cpuinfo.c         | 1 +
 5 files changed, 12 insertions(+)

diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index c04f8e87bab8..7b591c1dcb53 100644
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
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 509ee0d2fa0f..732bdd7286c8 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -85,6 +85,7 @@
 #define KERNEL_HWCAP_PACG		__khwcap_feature(PACG)
 
 #define __khwcap2_feature(x)		(ilog2(HWCAP2_ ## x) + 32)
+#define KERNEL_HWCAP_DCPODP		__khwcap2_feature(DCPODP)
 
 #ifndef __ASSEMBLY__
 
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
index a655d1bb1186..f8b682a3a9f4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1591,6 +1591,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
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
