From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 05/17] signal/nds32: Use force_sig(SIGILL) in do_revisn
Date: Thu, 19 Apr 2018 20:03:56 -0500
Message-ID: <20180420010408.24438-5-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Vincent Chen <vincentc@andestech.com>, Greentime Hu <greentime@andestech.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

As originally committed do_revisn would deliver a siginfo for SIGILL
with an si_code composed of random stack contents.  That makes no
sense and is not something userspace can depend on.  So simplify
the code and just use "force_sig(SIG_ILL, current)" instead.

Fixes: 2923f5ea7738 ("nds32: Exception handling")
Cc: Vincent Chen <vincentc@andestech.com>
Cc: Greentime Hu <greentime@andestech.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/nds32/kernel/traps.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
index 65961bf91d64..8e9a5b1f6234 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -356,14 +356,11 @@ void do_dispatch_tlb_misc(unsigned long entry, unsigned long addr,
 
 void do_revinsn(struct pt_regs *regs)
 {
-	siginfo_t si;
 	pr_emerg("Reserved Instruction\n");
 	show_regs(regs);
 	if (!user_mode(regs))
 		do_exit(SIGILL);
-	si.si_signo = SIGILL;
-	si.si_errno = 0;
-	force_sig_info(SIGILL, &si, current);
+	force_sig(SIGILL, current);
 }
 
 #ifdef CONFIG_ALIGNMENT_TRAP
-- 
2.14.1
