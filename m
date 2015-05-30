From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 97/98] HACK include/uapi/linux/elfcore.h: use __kernel_pid_t and remove elf_greg_t stuff in userspace
Date: Sat, 30 May 2015 17:39:29 +0200
Message-ID: <1433000370-19509-98-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

__kernel_pid_t change feels like right one. Commenting out elf_greg_t
things in userspace does not but exporting x86/include/asm/elf.h and it=
s
dependencies to userspace does not feel right either. Hence HACK.

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98elf_greg_t=E2=80=99
 typedef elf_greg_t greg_t;
error: unknown type name =E2=80=98pid_t=E2=80=99
  pid_t pr_pid;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/elfcore.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/elfcore.h b/include/uapi/linux/elfcore.=
h
index 569737c..b9d1233 100644
--- a/include/uapi/linux/elfcore.h
+++ b/include/uapi/linux/elfcore.h
@@ -17,11 +17,13 @@ struct elf_siginfo
=20
=20
 #ifndef __KERNEL__
+#if 0
 typedef elf_greg_t greg_t;
 typedef elf_gregset_t gregset_t;
 typedef elf_fpregset_t fpregset_t;
 typedef elf_fpxregset_t fpxregset_t;
 #define NGREG ELF_NGREG
+#endif /* 0 */
 #endif
=20
 /*
@@ -48,10 +50,10 @@ struct elf_prstatus
 	struct sigaltstack pr_altstack;	/* Alternate stack info */
 	struct sigaction pr_action;	/* Signal action for current sig */
 #endif
-	pid_t	pr_pid;
-	pid_t	pr_ppid;
-	pid_t	pr_pgrp;
-	pid_t	pr_sid;
+	__kernel_pid_t	pr_pid;
+	__kernel_pid_t	pr_ppid;
+	__kernel_pid_t	pr_pgrp;
+	__kernel_pid_t	pr_sid;
 	struct timeval pr_utime;	/* User time */
 	struct timeval pr_stime;	/* System time */
 	struct timeval pr_cutime;	/* Cumulative user time */
@@ -59,7 +61,9 @@ struct elf_prstatus
 #if 0
 	long	pr_instr;		/* Current instruction */
 #endif
+#ifdef __KERNEL__
 	elf_gregset_t pr_reg;	/* GP registers */
+#endif /* __KERNEL__ */
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 	/* When using FDPIC, the loadmap addresses need to be communicated
 	 * to GDB in order for GDB to do the necessary relocations.  The
@@ -84,7 +88,7 @@ struct elf_prpsinfo
 	unsigned long pr_flag;	/* flags */
 	__kernel_uid_t	pr_uid;
 	__kernel_gid_t	pr_gid;
-	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	__kernel_pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
 	char	pr_fname[16];	/* filename of executable */
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
--=20
2.1.4
