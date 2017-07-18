From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4/7] signal/mips: Document a conflict with SI_USER with SIGFPE
Date: Tue, 18 Jul 2017 09:06:48 -0500
Message-ID: <20170718140651.15973-4-ebiederm@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87o9shg7t7.fsf_-_@xmission.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ralf Baechle <ralf@linux-mips.org>
List-Id: linux-api@vger.kernel.org

Setting si_code to __SI_FAULT results in a userspace seeing
an si_code of 0.  This is the same si_code as SI_USER.  Posix
and common sense requires that SI_USER not be a signal specific
si_code.  As such this use of 0 for the si_code is a pretty
horribly broken ABI.

This use of of __SI_FAULT is only a decade old.  Which compared
to the other pieces of kernel code that has made this mistake
is almost yesterday.

This is probably worth fixing but I don't know mips well enough
to know what si_code to would be the proper one to use.

Cc: Ralf Baechle <ralf@linux-mips.org>
Ref: 948a34cf3988 ("[MIPS] Maintain si_code field properly for FP exceptions")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/mips/include/uapi/asm/siginfo.h | 7 +++++++
 arch/mips/kernel/traps.c             | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index 8069cf766603..9becfd102132 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -123,4 +123,11 @@ typedef struct siginfo {
 #define SI_TIMER __SI_CODE(__SI_TIMER, -3) /* sent by timer expiration */
 #define SI_MESGQ __SI_CODE(__SI_MESGQ, -4) /* sent by real time mesq state change */
 
+/*
+ * SIGFPE si_codes
+ */
+#ifdef __KERNEL__
+#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+#endif /* __KERNEL__ */
+
 #endif /* _UAPI_ASM_SIGINFO_H */
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index b68b4d0726d3..6c9cca9c5341 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -735,7 +735,7 @@ void force_fcr31_sig(unsigned long fcr31, void __user *fault_addr,
 	else if (fcr31 & FPU_CSR_INE_X)
 		si.si_code = FPE_FLTRES;
 	else
-		si.si_code = __SI_FAULT;
+		si.si_code = FPE_FIXME;
 	force_sig_info(SIGFPE, &si, tsk);
 }
 
-- 
2.10.1
