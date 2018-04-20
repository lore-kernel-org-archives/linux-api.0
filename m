From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 13/17] signal/powerpc: Replace FPE_FIXME with FPE_FLTUNK
Date: Thu, 19 Apr 2018 20:04:04 -0500
Message-ID: <20180420010408.24438-13-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Paul Mackerras <paulus@samba.org>, Kumar Gala <kumar.gala@freescale.com>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

Using an si_code of 0 that aliases with SI_USER is clearly the
wrong thing todo, and causes problems in interesting ways.

The newly defined FPE_FLTUNK semantically appears to fit the
bill so use it instead.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:  linuxppc-dev@lists.ozlabs.org
Fixes: 9bad068c24d7 ("[PATCH] ppc32: support for e500 and 85xx")
Fixes: 0ed70f6105ef ("PPC32: Provide proper siginfo information on various exceptions.")
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/powerpc/include/uapi/asm/siginfo.h | 7 -------
 arch/powerpc/kernel/traps.c             | 6 +++---
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/siginfo.h b/arch/powerpc/include/uapi/asm/siginfo.h
index 9f142451a01f..0437afc9ef3c 100644
--- a/arch/powerpc/include/uapi/asm/siginfo.h
+++ b/arch/powerpc/include/uapi/asm/siginfo.h
@@ -15,13 +15,6 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGFPE si_codes
- */
-#ifdef __KERNEL__
-#define FPE_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
 /*
  * SIGTRAP si_codes
  */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 087855caf6a9..fdf9400beec8 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1031,7 +1031,7 @@ static void emulate_single_step(struct pt_regs *regs)
 
 static inline int __parse_fpscr(unsigned long fpscr)
 {
-	int ret = FPE_FIXME;
+	int ret = FPE_FLTUNK;
 
 	/* Invalid operation */
 	if ((fpscr & FPSCR_VE) && (fpscr & FPSCR_VX))
@@ -1972,7 +1972,7 @@ void SPEFloatingPointException(struct pt_regs *regs)
 	extern int do_spe_mathemu(struct pt_regs *regs);
 	unsigned long spefscr;
 	int fpexc_mode;
-	int code = FPE_FIXME;
+	int code = FPE_FLTUNK;
 	int err;
 
 	flush_spe_to_thread(current);
@@ -2041,7 +2041,7 @@ void SPEFloatingPointRoundException(struct pt_regs *regs)
 		printk(KERN_ERR "unrecognized spe instruction "
 		       "in %s at %lx\n", current->comm, regs->nip);
 	} else {
-		_exception(SIGFPE, regs, FPE_FIXME, regs->nip);
+		_exception(SIGFPE, regs, FPE_FLTUNK, regs->nip);
 		return;
 	}
 }
-- 
2.14.1
