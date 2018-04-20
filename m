From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 04/17] signal/nds32: Use force_sig in unhandled_interruption and unhandled_exceptions
Date: Thu, 19 Apr 2018 20:03:55 -0500
Message-ID: <20180420010408.24438-4-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Vincent Chen <vincentc@andestech.com>, Greentime Hu <greentime@andestech.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Neither unhandled_interrupt nor unhandled_exceptions fills in any of the
siginfo fields whend sending SIGKILL.  Further because it is SIGKILL
even if all of the fields were filled out appropriately it would be impossible
for the process to read any of the siginfo fields.  So simplfy things and
just use force_sig instead of force_sig_info.

Fixes: 2923f5ea7738 ("nds32: Exception handling")
Cc: Vincent Chen <vincentc@andestech.com>
Cc: Greentime Hu <greentime@andestech.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/nds32/kernel/traps.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
index 6e34eb9824a4..65961bf91d64 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -318,29 +318,22 @@ void do_debug_trap(unsigned long entry, unsigned long addr,
 
 void unhandled_interruption(struct pt_regs *regs)
 {
-	siginfo_t si;
 	pr_emerg("unhandled_interruption\n");
 	show_regs(regs);
 	if (!user_mode(regs))
 		do_exit(SIGKILL);
-	si.si_signo = SIGKILL;
-	si.si_errno = 0;
-	force_sig_info(SIGKILL, &si, current);
+	force_sig(SIGKILL, current);
 }
 
 void unhandled_exceptions(unsigned long entry, unsigned long addr,
 			  unsigned long type, struct pt_regs *regs)
 {
-	siginfo_t si;
 	pr_emerg("Unhandled Exception: entry: %lx addr:%lx itype:%lx\n", entry,
 		 addr, type);
 	show_regs(regs);
 	if (!user_mode(regs))
 		do_exit(SIGKILL);
-	si.si_signo = SIGKILL;
-	si.si_errno = 0;
-	si.si_addr = (void *)addr;
-	force_sig_info(SIGKILL, &si, current);
+	force_sig(SIGKILL, current);
 }
 
 extern int do_page_fault(unsigned long entry, unsigned long addr,
-- 
2.14.1
