From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 11/17] signal/alpha: Replace FPE_FIXME with FPE_FLTUNK
Date: Thu, 19 Apr 2018 20:04:02 -0500
Message-ID: <20180420010408.24438-11-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Helge Deller <deller@gmx.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Using an si_code of 0 that aliases with SI_USER is clearly the wrong
thing todo, and causes problems in interesting ways.

The newly defined FPE_FLTUNK semantically appears to fit the bill so
use it instead.

Given recent experience in this area odds are it will not break
anything.  Fixing it removes a hazard to kernel maintenance.

Cc: Helge Deller <deller@gmx.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Fixes: 0a635c7a84cf ("Fill in siginfo_t.")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/include/uapi/asm/siginfo.h | 7 -------
 arch/alpha/kernel/osf_sys.c           | 2 +-
 arch/alpha/kernel/traps.c             | 2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/siginfo.h b/arch/alpha/include/uapi/asm/siginfo.h
index 0cf3b527b274..3ebbb1e17902 100644
--- a/arch/alpha/include/uapi/asm/siginfo.h
+++ b/arch/alpha/include/uapi/asm/siginfo.h
@@ -7,13 +7,6 @@
 
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
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index f5f154942aab..bb3619118926 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -872,7 +872,7 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
 		fex = (exc >> IEEE_STATUS_TO_EXCSUM_SHIFT) & swcr;
  		if (fex) {
 			siginfo_t info;
-			int si_code = FPE_FIXME;
+			int si_code = FPE_FLTUNK;
 
 			if (fex & IEEE_TRAP_ENABLE_DNO) si_code = FPE_FLTUND;
 			if (fex & IEEE_TRAP_ENABLE_INE) si_code = FPE_FLTRES;
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 91636765dd6d..422b676b28f2 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -328,7 +328,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 			break;
 		case GEN_ROPRAND:
 			signo = SIGFPE;
-			code = FPE_FIXME;
+			code = FPE_FLTUNK;
 			break;
 
 		case GEN_DECOVF:
-- 
2.14.1
