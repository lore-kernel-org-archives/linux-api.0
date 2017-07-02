From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 1/8] signal/alpha: Document a conflict with SI_USER for
 SIGTRAP
Date: Sun, 2 Jul 2017 16:13:20 +0200
Message-ID: <20170702141320.GA32254@ls3530.fritz.box>
References: <87efu22set.fsf@xmission.com>
 <20170630123906.8865-1-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-alpha-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170630123906.8865-1-ebiederm@xmission.com>
Sender: linux-alpha-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>
List-Id: linux-api@vger.kernel.org

* Eric W. Biederman <ebiederm@xmission.com>:
> Setting si_code to __SI_FAULT results in a userspace seeing
> an si_code of 0.  This is the same si_code as SI_USER.  Posix
> and common sense requires that SI_USER not be a signal specific
> si_code.  As such this use of 0 for the si_code is a pretty
> horribly broken ABI.
> 
> Given that alpha is on it's last legs I don't know that it is worth
> fixing this, but it is worth documenting what is going on so that
> no one decides to copy this bad decision.

The ABI was already broken, so IMHO I think it's better to somehow "fix"
it instead. Agreed, alpha and some other architectures are already aged,
but nevertheless most of them build in debian-ports.  Below is a
suggested fix which reuses/misuses other existing trap codes instead.

Helge

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 65bb102..2ed37dd 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -278,7 +278,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 	      case 1: /* bugcheck */
 		info.si_signo = SIGTRAP;
 		info.si_errno = 0;
-		info.si_code = __SI_FAULT;
+		info.si_code = TRAP_HWBKPT;
 		info.si_addr = (void __user *) regs->pc;
 		info.si_trapno = 0;
 		send_sig_info(SIGTRAP, &info, current);
@@ -318,7 +318,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 			break;
 		case GEN_ROPRAND:
 			signo = SIGFPE;
-			code = __SI_FAULT;
+			code = FPE_FLTSUB;
 			break;
 
 		case GEN_DECOVF:
@@ -340,7 +340,7 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 		case GEN_SUBRNG7:
 		default:
 			signo = SIGTRAP;
-			code = __SI_FAULT;
+			code = TRAP_HWBKPT;
 			break;
 		}
 


