From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 02/17] sparc: fix compat siginfo ABI regression
Date: Thu, 19 Apr 2018 20:03:53 -0500
Message-ID: <20180420010408.24438-2-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>, David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

From: "Dmitry V. Levin" <ldv@altlinux.org>

Starting with commit v4.14-rc1~60^2^2~1, a SIGFPE signal sent via kill
results to wrong values in si_pid and si_uid fields of compat siginfo_t.

This happens due to FPE_FIXME being defined to 0 for sparc, and at the
same time siginfo_layout() introduced by the same commit returns
SIL_FAULT for SIGFPE if si_code == SI_USER and FPE_FIXME is defined to 0.

Fix this regression by removing FPE_FIXME macro and changing all its users
to assign FPE_FLTUNK to si_code instead of FPE_FIXME.

Note that FPE_FLTUNK is a new macro introduced by commit
266da65e9156d93e1126e185259a4aae68188d0e.

Tested with commit v4.16-11958-g16e205cf42da.

This bug was found by strace test suite.

In the discussion about FPE_FLTUNK on sparc David Miller said:
> Eric, feel free to do something similar on Sparc.

Link: https://github.com/strace/strace/issues/21
Fixes: cc731525f26a ("signal: Remove kernel interal si_code magic")
Fixes: 2.3.41
Cc: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Conceptually-Acked-By: David Miller <davem@davemloft.net>
Thanks-to: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/sparc/include/uapi/asm/siginfo.h | 7 -------
 arch/sparc/kernel/traps_32.c          | 2 +-
 arch/sparc/kernel/traps_64.c          | 2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/siginfo.h b/arch/sparc/include/uapi/asm/siginfo.h
index 896ce447d16a..e7049550ac82 100644
--- a/arch/sparc/include/uapi/asm/siginfo.h
+++ b/arch/sparc/include/uapi/asm/siginfo.h
@@ -17,13 +17,6 @@
 
 #define SI_NOINFO	32767		/* no information in siginfo_t */
 
-/*
- * SIGFPE si_codes
- */
-#ifdef __KERNEL__
-#define FPE_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
 /*
  * SIGEMT si_codes
  */
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index b1ed763e4787..33cd35bf3dc8 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -307,7 +307,7 @@ void do_fpe_trap(struct pt_regs *regs, unsigned long pc, unsigned long npc,
 	info.si_errno = 0;
 	info.si_addr = (void __user *)pc;
 	info.si_trapno = 0;
-	info.si_code = FPE_FIXME;
+	info.si_code = FPE_FLTUNK;
 	if ((fsr & 0x1c000) == (1 << 14)) {
 		if (fsr & 0x10)
 			info.si_code = FPE_FLTINV;
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 462a21abd105..e81072ac52c3 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2372,7 +2372,7 @@ static void do_fpe_common(struct pt_regs *regs)
 		info.si_errno = 0;
 		info.si_addr = (void __user *)regs->tpc;
 		info.si_trapno = 0;
-		info.si_code = FPE_FIXME;
+		info.si_code = FPE_FLTUNK;
 		if ((fsr & 0x1c000) == (1 << 14)) {
 			if (fsr & 0x10)
 				info.si_code = FPE_FLTINV;
-- 
2.14.1
