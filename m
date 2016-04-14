From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH 1/4] [Cleanup] x86: signal: unify the sigaltstack check with other arches
Date: Thu, 14 Apr 2016 23:20:02 +0300
Message-ID: <1460665206-13646-2-git-send-email-stsp@list.ru>
References: <1460665206-13646-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460665206-13646-1-git-send-email-stsp@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Richard Weinberger <richard@nod.at>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Currently x86's get_sigframe() checks for "current->sas_ss_size"
to determine whether there is a need to switch to sigaltstack.
The common practice used by all other arches is to check for
sas_ss_flags(sp) == 0

This patch makes the code consistent with other arches.
The slight complexity of the patch is added by the optimization on
!sigstack check that was requested by Andy Lutomirski: sas_ss_flags(sp)==0
already implies that we are not on a sigstack, so the code is shuffled
to avoid the duplicate checking.

This patch have no any user-visible impact. It is purely a cleanup.

CC: linux-kernel@vger.kernel.org
CC: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: Borislav Petkov <bp@suse.de>
CC: Brian Gerst <brgerst@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Richard Weinberger <richard@nod.at>
CC: linux-api@vger.kernel.org
CC: Shuah Khan <shuahkh@osg.samsung.com>

Signed-off-by: Stas Sergeev <stsp@list.ru>
---
 arch/x86/kernel/signal.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cb6282c..285183b 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -213,18 +213,17 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (config_enabled(CONFIG_X86_64))
 		sp -= 128;
 
-	if (!onsigstack) {
-		/* This is the X/Open sanctioned signal stack switching.  */
-		if (ka->sa.sa_flags & SA_ONSTACK) {
-			if (current->sas_ss_size)
-				sp = current->sas_ss_sp + current->sas_ss_size;
-		} else if (config_enabled(CONFIG_X86_32) &&
-			   (regs->ss & 0xffff) != __USER_DS &&
-			   !(ka->sa.sa_flags & SA_RESTORER) &&
-			   ka->sa.sa_restorer) {
-				/* This is the legacy signal stack switching. */
-				sp = (unsigned long) ka->sa.sa_restorer;
-		}
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	} else if (config_enabled(CONFIG_X86_32) &&
+		   !onsigstack &&
+		   (regs->ss & 0xffff) != __USER_DS &&
+		   !(ka->sa.sa_flags & SA_RESTORER) &&
+		   ka->sa.sa_restorer) {
+		/* This is the legacy signal stack switching. */
+		sp = (unsigned long) ka->sa.sa_restorer;
 	}
 
 	if (fpu->fpstate_active) {
-- 
2.7.2
