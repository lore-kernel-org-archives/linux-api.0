From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 16/17] signal/alpha:  Replace TRAP_FIXME with TRAP_UNK
Date: Thu, 19 Apr 2018 20:04:07 -0500
Message-ID: <20180420010408.24438-16-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Helge Deller <deller@gmx.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Using an si_code of 0 that aliases with SI_USER is clearly the wrong
thing to do, and causes problems in interesting ways.

For it really is not clear to me if using TRAP_UNK bugcheck or
the default case of gentrap is really the best way to handle
things.  There is certainly enough information that that a more
specific si_code could potentially be used.  That said TRAP_UNK
is definitely an improvement over 0 as it removes the ambiguiuty
of what si_code of 0 with SIGTRAP means on alpha.

Recent history suggests no actually cares about crazy corner cases of
the kernel behavior like this so I don't expect any regressions from
changing this.  However if something does happen this change is easy
to revert.

Cc: Helge Deller <deller@gmx.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
Fixes: 0a635c7a84cf ("Fill in siginfo_t.")
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/include/uapi/asm/siginfo.h | 7 -------
 arch/alpha/kernel/traps.c             | 4 ++--
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/siginfo.h b/arch/alpha/include/uapi/asm/siginfo.h
index 3ebbb1e17902..db3f0138536f 100644
--- a/arch/alpha/include/uapi/asm/siginfo.h
+++ b/arch/alpha/include/uapi/asm/siginfo.h
@@ -7,11 +7,4 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#ifdef __KERNEL__
-#define TRAP_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
 #endif
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 422b676b28f2..242c83d86ace 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -288,7 +288,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 	      case 1: /* bugcheck */
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
-		info.si_code = TRAP_FIXME;
+		info.si_code = TRAP_UNK;
 		info.si_addr = (void __user *) regs->pc;
 		info.si_trapno = 0;
 		send_sig_info(SIGTRAP, &info, current);
@@ -350,7 +350,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 		case GEN_SUBRNG7:
 		default:
 			signo = SIGTRAP;
-			code = TRAP_FIXME;
+			code = TRAP_UNK;
 			break;
 		}
 
-- 
2.14.1
