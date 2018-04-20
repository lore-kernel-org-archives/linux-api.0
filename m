From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 17/17] signal/powerpc: Replace TRAP_FIXME with TRAP_UNK
Date: Thu, 19 Apr 2018 20:04:08 -0500
Message-ID: <20180420010408.24438-17-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Paul Mackerras <paulus@samba.org>, Kumar Gala <kumar.gala@freescale.com>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

Using an si_code of 0 that aliases with SI_USER is clearly the wrong
thing todo, and causes problems in interesting ways.

For use in unknown_exception the recently defined TRAP_UNK
semantically is a perfect fit.  For use in RunModeException it looks
like something more specific than TRAP_UNK could be used.  No one has
bothered to find a better fit than the broken si_code of 0 in all of
these years and I don't see an obvious better fit so TRAP_UNK is
switching RunModeException to return TRAP_UNK is clearly an
improvement.

Recent history suggests no actually cares about crazy corner
cases of the kernel behavior like this so I don't expect any
regressions from changing this.  However if something does
happen this change is easy to revert.

Though I wonder if SIGKILL might not be a better fit.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Fixes: 9bad068c24d7 ("[PATCH] ppc32: support for e500 and 85xx")
Fixes: 0ed70f6105ef ("PPC32: Provide proper siginfo information on various exceptions.")
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/powerpc/include/uapi/asm/siginfo.h | 8 --------
 arch/powerpc/kernel/traps.c             | 4 ++--
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/siginfo.h b/arch/powerpc/include/uapi/asm/siginfo.h
index 0437afc9ef3c..1d51d9b88221 100644
--- a/arch/powerpc/include/uapi/asm/siginfo.h
+++ b/arch/powerpc/include/uapi/asm/siginfo.h
@@ -15,12 +15,4 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#ifdef __KERNEL__
-#define TRAP_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
-
 #endif	/* _ASM_POWERPC_SIGINFO_H */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index fdf9400beec8..0e17dcb48720 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -969,7 +969,7 @@ void unknown_exception(struct pt_regs *regs)
 	printk("Bad trap at PC: %lx, SR: %lx, vector=%lx\n",
 	       regs->nip, regs->msr, regs->trap);
 
-	_exception(SIGTRAP, regs, TRAP_FIXME, 0);
+	_exception(SIGTRAP, regs, TRAP_UNK, 0);
 
 	exception_exit(prev_state);
 }
@@ -991,7 +991,7 @@ void instruction_breakpoint_exception(struct pt_regs *regs)
 
 void RunModeException(struct pt_regs *regs)
 {
-	_exception(SIGTRAP, regs, TRAP_FIXME, 0);
+	_exception(SIGTRAP, regs, TRAP_UNK, 0);
 }
 
 void single_step_exception(struct pt_regs *regs)
-- 
2.14.1
