From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 03/10] signal: Properly deliver SIGSEGV from x86 uprobes
Date: Mon,  3 Sep 2018 22:44:23 +0200
Message-ID: <20180903204430.25473-3-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

For userspace to tell the difference between an random signal
and an exception, the exception must include siginfo information.

Using SEND_SIG_FORCED for SIGSEGV is thus wrong, and it will result in
userspace seeing si_code == SI_USER (like a random signal) instead of
si_code == SI_KERNEL or a more specific si_code as all exceptions
deliver.

Therefore replace force_sig_info(SIGSEGV, SEND_SIG_FORCE, current)
with force_sig(SIG_SEGV, current) which gets this right and is shorter
and easier to type.

Fixes: 791eca10107f ("uretprobes/x86: Hijack return address")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index deb576b23b7c..843feb94a950 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1086,7 +1086,7 @@ arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs
 		pr_err("return address clobbered: pid=%d, %%sp=%#lx, %%ip=%#lx\n",
 		       current->pid, regs->sp, regs->ip);
 
-		force_sig_info(SIGSEGV, SEND_SIG_FORCED, current);
+		force_sig(SIGSEGV, current);
 	}
 
 	return -1;
-- 
2.17.1
