From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/8] signal/ia64: Document a conflict with SI_USER with SIGFPE
Date: Fri, 30 Jun 2017 07:39:00 -0500
Message-ID: <20170630123906.8865-2-ebiederm@xmission.com>
References: <87efu22set.fsf@xmission.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87efu22set.fsf@xmission.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Setting si_code to __SI_FAULT results in a userspace seeing
an si_code of 0.  This is the same si_code as SI_USER.  Posix
and common sense requires that SI_USER not be a signal specific
si_code.  As such this use of 0 for the si_code is a pretty
horribly broken ABI.

Given that ia64 is on it's last legs I don't know that it is worth
fixing this, but it is worth documenting what is going on so that
no one decides to copy this bad decision.

This was introduced in 2.3.51 so this mess has had a long time for
people to be able to start depending on it.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/ia64/include/uapi/asm/siginfo.h | 1 +
 arch/ia64/kernel/traps.c             | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/include/uapi/asm/siginfo.h b/arch/ia64/include/uapi/asm/siginfo.h
index f72bf0172bb2..fafea221f49c 100644
--- a/arch/ia64/include/uapi/asm/siginfo.h
+++ b/arch/ia64/include/uapi/asm/siginfo.h
@@ -108,6 +108,7 @@ typedef struct siginfo {
 /*
  * SIGFPE si_codes
  */
+#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
 #define __FPE_DECOVF	(__SI_FAULT|9)	/* decimal overflow */
 #define __FPE_DECDIV	(__SI_FAULT|10)	/* decimal division by zero */
 #define __FPE_DECERR	(__SI_FAULT|11)	/* packed decimal error */
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 7b1fe9462158..3cb17cf9b362 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -349,7 +349,7 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			}
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
-			siginfo.si_code = __SI_FAULT;	/* default code */
+			siginfo.si_code = FPE_FIXME;	/* default code */
 			siginfo.si_addr = (void __user *) (regs->cr_iip + ia64_psr(regs)->ri);
 			if (isr & 0x11) {
 				siginfo.si_code = FPE_FLTINV;
@@ -373,7 +373,7 @@ handle_fpu_swa (int fp_fault, struct pt_regs *regs, unsigned long isr)
 			/* raise exception */
 			siginfo.si_signo = SIGFPE;
 			siginfo.si_errno = 0;
-			siginfo.si_code = __SI_FAULT;	/* default code */
+			siginfo.si_code = FPE_FIXME;	/* default code */
 			siginfo.si_addr = (void __user *) (regs->cr_iip + ia64_psr(regs)->ri);
 			if (isr & 0x880) {
 				siginfo.si_code = FPE_FLTOVF;
-- 
2.10.1
