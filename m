From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 1/2] arm64: fpsimd: Fix bad si_code for undiagnosed SIGFPE
Date: Mon, 22 Jan 2018 12:23:17 +0000
Message-ID: <1516623798-25001-2-git-send-email-Dave.Martin@arm.com>
References: <1516623798-25001-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1516623798-25001-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@armlinux.org.uk>
List-Id: linux-api@vger.kernel.org

Currently a SIGFPE delivered in response to a floating-point
exception trap may have si_code set to 0 on arm64.  As reported by
Eric, this is a bad idea since this is the value of SI_USER -- yet
this signal is definitely not the result of kill(2), tgkill(2) etc.
and si_uid and si_pid make limited sense whereas we do want to
yield a value for si_addr (which doesn't exist for SI_USER).

It's not entirely clear whether the architecure permits a
"spurious" fp exception trap where none of the exception flag bits
in ESR_ELx is set.  (IMHO the architectural intent is to forbid
this.)  However, it does permit those bits to contain garbage if
the TFV bit in ESR_ELx is 0.  That case isn't currently handled at
all and may result in si_code == 0 or si_code containing a FPE_FLT*
constant corresponding to an exception that did not in fact happen.

There is nothing sensible we can return for si_code in such cases,
but SI_USER is certainly not appropriate and will lead to violation
of legitimate userspace assumptions.

This patch allocates a new si_code value FPE_UNKNOWN that at least
does not conflict with any existing SI_* or FPE_* code, and yields
this in si_code for undiagnosable cases.  This is probably the best
simplicity/incorrectness tradeoff achieveable without relying on
implementation-dependent features or adding a lot of code.  In any
case, there appears to be no perfect solution possible that would
justify a lot of effort here.

Yielding FPE_UNKNOWN when some well-defined fp exception caused the
trap is a violation of POSIX, but this is forced by the
architecture.  We have no realistic prospect of yielding the
correct code in such cases.  At present I am not aware of any ARMv8
implementation that supports trapped floating-point exceptions in
any case.

The new code may be applicable to other architectures for similar
reasons.

No attempt is made to provide ESR_ELx to userspace in the signal
frame, since architectural limitations mean that it is unlikely to
provide much diagnostic value, doesn't benefit existing software
and would create ABI with no proven purpose.  The existing
mechanism for passing it also has problems of its own which may
result in the wrong value being passed to userspace due to
interaction with mm faults.  The implied rework does not appear
justified.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/esr.h       |  9 +++++++++
 arch/arm64/kernel/fpsimd.c         | 27 +++++++++++++++------------
 include/uapi/asm-generic/siginfo.h |  3 ++-
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 014d7d8..c585e91 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -220,6 +220,15 @@
 		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
 		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
 
+/*
+ * ISS field definitions for floating-point exception traps
+ * (FP_EXC_32/FP_EXC_64).
+ *
+ * (The FPEXC_* constants are used instead for common bits.)
+ */
+
+#define ESR_ELx_FP_EXC_TFV	(UL(1) << 23)
+
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index fae81f7..2d6ba9e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 
+#include <asm/esr.h>
 #include <asm/fpsimd.h>
 #include <asm/cputype.h>
 #include <asm/simd.h>
@@ -867,18 +868,20 @@ asmlinkage void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
 asmlinkage void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
 {
 	siginfo_t info;
-	unsigned int si_code = 0;
-
-	if (esr & FPEXC_IOF)
-		si_code = FPE_FLTINV;
-	else if (esr & FPEXC_DZF)
-		si_code = FPE_FLTDIV;
-	else if (esr & FPEXC_OFF)
-		si_code = FPE_FLTOVF;
-	else if (esr & FPEXC_UFF)
-		si_code = FPE_FLTUND;
-	else if (esr & FPEXC_IXF)
-		si_code = FPE_FLTRES;
+	unsigned int si_code = FPE_UNKNOWN;
+
+	if (esr & ESR_ELx_FP_EXC_TFV) {
+		if (esr & FPEXC_IOF)
+			si_code = FPE_FLTINV;
+		else if (esr & FPEXC_DZF)
+			si_code = FPE_FLTDIV;
+		else if (esr & FPEXC_OFF)
+			si_code = FPE_FLTOVF;
+		else if (esr & FPEXC_UFF)
+			si_code = FPE_FLTUND;
+		else if (esr & FPEXC_IXF)
+			si_code = FPE_FLTRES;
+	}
 
 	memset(&info, 0, sizeof(info));
 	info.si_signo = SIGFPE;
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index e447283..77edb00 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -193,7 +193,8 @@ typedef struct siginfo {
 #define FPE_FLTRES	6	/* floating point inexact result */
 #define FPE_FLTINV	7	/* floating point invalid operation */
 #define FPE_FLTSUB	8	/* subscript out of range */
-#define NSIGFPE		8
+#define FPE_UNKNOWN	9	/* undiagnosed floating-point exception */
+#define NSIGFPE		9
 
 /*
  * SIGSEGV si_codes
-- 
2.1.4
