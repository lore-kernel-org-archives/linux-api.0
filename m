From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 1/7] signal/alpha: Document a conflict with SI_USER for SIGTRAP
Date: Tue, 18 Jul 2017 09:06:45 -0500
Message-ID: <20170718140651.15973-1-ebiederm@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87o9shg7t7.fsf_-_@xmission.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Helge Deller <deller@gmx.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@ju>
List-Id: linux-api@vger.kernel.org

Setting si_code to __SI_FAULT results in a userspace seeing
an si_code of 0.  This is the same si_code as SI_USER.  Posix
and common sense requires that SI_USER not be a signal specific
si_code.  As such this use of 0 for the si_code is a pretty
horribly broken ABI.

Given that alpha is on it's last legs I don't know that it is worth
fixing this, but it is worth documenting what is going on so that
no one decides to copy this bad decision.

This was introduced during the 2.5 development cycle so this
mess has had a long time for people to be able to depend upon it.

v2: Added FPE_FIXME for alpha as Helge Deller <deller@gmx.de> pointed out
    with his alternate patch one of the cases is SIGFPE not SIGTRAP.

Cc: Helge Deller <deller@gmx.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Ref: 0a635c7a84cf ("Fill in siginfo_t.")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/include/uapi/asm/siginfo.h | 14 ++++++++++++++
 arch/alpha/kernel/traps.c             |  6 +++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/siginfo.h b/arch/alpha/include/uapi/asm/siginfo.h
index 9822362a8424..972f547d9e41 100644
--- a/arch/alpha/include/uapi/asm/siginfo.h
+++ b/arch/alpha/include/uapi/asm/siginfo.h
@@ -6,4 +6,18 @@
 
 #include <asm-generic/siginfo.h>
 
+/*
+ * SIGFPE si_codes
+ */
+#ifdef __KERNEL__
+#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#endif /* __KERNEL__ */
+
+/*
+ * SIGTRAP si_codes
+ */
+#ifdef __KERNEL__
+#define TRAP_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#endif /* __KERNEL__ */
+
 #endif
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 65bb102d985b..e94f4b73ac04 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -278,7 +278,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 	      case 1: /* bugcheck */
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
-		info.si_code = __SI_FAULT;
+		info.si_code = TRAP_FIXME;
 		info.si_addr = (void __user *) regs->pc;
 		info.si_trapno = 0;
 		send_sig_info(SIGTRAP, &info, current);
@@ -318,7 +318,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 			break;
 		case GEN_ROPRAND:
 			signo = SIGFPE;
-			code = __SI_FAULT;
+			code = FPE_FIXME;
 			break;
 
 		case GEN_DECOVF:
@@ -340,7 +340,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 		case GEN_SUBRNG7:
 		default:
 			signo = SIGTRAP;
-			code = __SI_FAULT;
+			code = TRAP_FIXME;
 			break;
 		}
 
-- 
2.10.1
