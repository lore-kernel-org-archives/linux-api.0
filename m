From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 12/17] signal/ia64: Replace FPE_FIXME with FPE_FLTUNK
Date: Thu, 19 Apr 2018 20:04:03 -0500
Message-ID: <20180420010408.24438-12-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Using an si_code of 0 that aliases with SI_USER is clearly the wrong
thing todo, and causes problems in interesting ways.

The newly defined FPE_FLTUNK semantically appears to fit the bill so
use it instead.

Given recent experience in this area odds are it will not
break anything.  Fixing it removes a hazard to kernel maintenance.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Fixes: 987159266c45 ("Linux version 2.3.48")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/ia64/include/uapi/asm/siginfo.h | 7 -------
 arch/ia64/kernel/traps.c             | 4 ++--
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/uapi/asm/siginfo.h b/arch/ia64/include/uapi/asm/siginfo.h
index 5aa454ed89db..52b5af424511 100644
--- a/arch/ia64/include/uapi/asm/siginfo.h
+++ b/arch/ia64/include/uapi/asm/siginfo.h
@@ -27,11 +27,4 @@
 #define __ISR_VALID_BIT	0
 #define __ISR_VALID	(1 << __ISR_VALID_BIT)
 
-/*
- * SIGFPE si_codes
- */
-#ifdef __KERNEL__
-#define FPE_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
 #endif /* _UAPI_ASM_IA64_SIGINFO_H */
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 972873ed1ae5..c6f4932073a1 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -353,7 +353,7 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
-			siginfo.si_code = FPE_FIXME;	/* default code */
+			siginfo.si_code = FPE_FLTUNK;	/* default code */
 			siginfo.si_addr = (void __user *) (regs->cr_iip + ia64_psr(regs)->ri);
 			if (isr & 0x11) {
 				siginfo.si_code = FPE_FLTINV;
@@ -380,7 +380,7 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			clear_siginfo(&siginfo);
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
-			siginfo.si_code = FPE_FIXME;	/* default code */
+			siginfo.si_code = FPE_FLTUNK;	/* default code */
 			siginfo.si_addr = (void __user *) (regs->cr_iip + ia64_psr(regs)->ri);
 			if (isr & 0x880) {
 				siginfo.si_code = FPE_FLTOVF;
-- 
2.14.1
