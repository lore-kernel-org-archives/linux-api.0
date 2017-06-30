From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/8] signal/mips: Document a conflict with SI_USER with SIGFPE
Date: Fri, 30 Jun 2017 07:39:02 -0500
Message-ID: <20170630123906.8865-4-ebiederm@xmission.com>
References: <87efu22set.fsf@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87efu22set.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Willy Tarreau <w@1wt.eu>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Thiemo Seufer <ths-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
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

Cc: Thiemo Seufer <ths-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Ref: 948a34cf3988 ("[MIPS] Maintain si_code field properly for FP exceptions")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 arch/mips/include/uapi/asm/siginfo.h | 5 +++++
 arch/mips/kernel/traps.c             | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index 8069cf766603..0d80df888325 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -123,4 +123,9 @@ typedef struct siginfo {
 #define SI_TIMER __SI_CODE(__SI_TIMER, -3) /* sent by timer expiration */
 #define SI_MESGQ __SI_CODE(__SI_MESGQ, -4) /* sent by real time mesq state change */
 
+/*
+ * SIGFPE si_codes
+ */
+#define FPE_FIXME	(__SI_FAULT|0)	/* Broken dup of SI_USER */
+
 #endif /* _UAPI_ASM_SIGINFO_H */
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 9681b5877140..477dfca99147 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -732,7 +732,7 @@ void force_fcr31_sig(unsigned long fcr31, void __user *fault_addr,
 	else if (fcr31 & FPU_CSR_INE_X)
 		si.si_code = FPE_FLTRES;
 	else
-		si.si_code = __SI_FAULT;
+		si.si_code = FPE_FIXME;
 	force_sig_info(SIGFPE, &si, tsk);
 }
 
-- 
2.10.1
