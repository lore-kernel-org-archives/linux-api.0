From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 14/17] signal/unicore32: Use FPE_FLTUNK instead of 0 in ucf64_raise_sigfpe
Date: Thu, 19 Apr 2018 20:04:05 -0500
Message-ID: <20180420010408.24438-14-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

The si_code of 0 (aka SI_USER) has fields si_pid and si_uid not
si_addr so it so only by luck would the appropriate fields by copied
to userspace by copy_siginfo_to_user.

This is just broken and wrong.

Make it obvious what is happening by moving the si_code from a
parameter of the one call to ucf64_raise_sigfpe to a constant value
that info.si_code gets set to.

Explicitly set the si_code to FPE_FLTUNK the newly reserved floating
point si_code for an unknown floating point exception.

It looks like there is a fair chance that this is a code path that has
never been used in real life on unicore32.  The bad si_code and the
print statement that calls it an unhandled exception.  So I really
don't expect anyone will mind if this just gets fixed.

In similar situations on more popular architectures the conclusion was
just fix it.

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: d9bc15794d12 ("unicore32 additional architecture files: float point handling")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/unicore32/kernel/fpu-ucf64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/kernel/fpu-ucf64.c b/arch/unicore32/kernel/fpu-ucf64.c
index d785955e1c29..8594b168f25e 100644
--- a/arch/unicore32/kernel/fpu-ucf64.c
+++ b/arch/unicore32/kernel/fpu-ucf64.c
@@ -52,14 +52,14 @@
  * Raise a SIGFPE for the current process.
  * sicode describes the signal being raised.
  */
-void ucf64_raise_sigfpe(unsigned int sicode, struct pt_regs *regs)
+void ucf64_raise_sigfpe(struct pt_regs *regs)
 {
 	siginfo_t info;
 
 	clear_siginfo(&info);
 
 	info.si_signo = SIGFPE;
-	info.si_code = sicode;
+	info.si_code = FPE_FLTUNK;
 	info.si_addr = (void __user *)(instruction_pointer(regs) - 4);
 
 	/*
@@ -94,7 +94,7 @@ void ucf64_exchandler(u32 inst, u32 fpexc, struct pt_regs *regs)
 		pr_debug("UniCore-F64 FPSCR 0x%08x INST 0x%08x\n",
 				cff(FPSCR), inst);
 
-		ucf64_raise_sigfpe(0, regs);
+		ucf64_raise_sigfpe(regs);
 		return;
 	}
 
-- 
2.14.1
