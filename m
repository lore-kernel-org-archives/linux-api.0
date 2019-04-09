From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v5 3/6] arm64: Handle trapped DC CVADP
Date: Tue,  9 Apr 2019 10:52:42 +0100
Message-ID: <20190409095245.42524-4-andrew.murray@arm.com>
References: <20190409095245.42524-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-101258-glibc-alpha=m.gmane.org@sourceware.org>
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

The ARMv8.5 DC CVADP instruction may be trapped to EL1 via
SCTLR_EL1.UCI therefore let's provide a handler for it.

Just like the CVAP instruction we use a 'sys' instruction instead of
the 'dc' alias to avoid build issues with older toolchains.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/esr.h | 3 ++-
 arch/arm64/kernel/traps.c    | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 52233f00d53d..07d5c026a0b3 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -198,9 +198,10 @@
 /*
  * User space cache operations have the following sysreg encoding
  * in System instructions.
- * op0=1, op1=3, op2=1, crn=7, crm={ 5, 10, 11, 12, 14 }, WRITE (L=0)
+ * op0=1, op1=3, op2=1, crn=7, crm={ 5, 10, 11, 12, 13, 14 }, WRITE (L=0)
  */
 #define ESR_ELx_SYS64_ISS_CRM_DC_CIVAC	14
+#define ESR_ELx_SYS64_ISS_CRM_DC_CVADP	13
 #define ESR_ELx_SYS64_ISS_CRM_DC_CVAP	12
 #define ESR_ELx_SYS64_ISS_CRM_DC_CVAU	11
 #define ESR_ELx_SYS64_ISS_CRM_DC_CVAC	10
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 8ad119c3f665..f66e1ddbe4a7 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -459,6 +459,9 @@ static void user_cache_maint_handler(unsigned int esr, struct pt_regs *regs)
 	case ESR_ELx_SYS64_ISS_CRM_DC_CVAC:	/* DC CVAC, gets promoted */
 		__user_cache_maint("dc civac", address, ret);
 		break;
+	case ESR_ELx_SYS64_ISS_CRM_DC_CVADP:	/* DC CVADP */
+		__user_cache_maint("sys 3, c7, c13, 1", address, ret);
+		break;
 	case ESR_ELx_SYS64_ISS_CRM_DC_CVAP:	/* DC CVAP */
 		__user_cache_maint("sys 3, c7, c12, 1", address, ret);
 		break;
-- 
2.21.0
