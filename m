From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 77/79] include/uapi/linux/elfcore.h: remove non-compiling userspace parts
Date: Thu, 15 Oct 2015 07:56:55 +0200
Message-ID: <1444888618-4506-78-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Remove typedef elf_greg_t greg_t and friends from userspace.
Remove struct elf_prstatus completely from userspace.

elfcore.h as such does not compile in userspace. All userspace users
of <linux/elfcore.h> like gcc/gdb and linux-tools contain their own modified
versions of the file. With these changes the file compiles but is generally
not usable for things like core dump parsing but luckily userspace users
already know this and have their own modified version of the needed
definitions and headers. But at least this compiles now.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/elfcore.h | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/elfcore.h b/include/uapi/linux/elfcore.h
index 569737c..6c23066 100644
--- a/include/uapi/linux/elfcore.h
+++ b/include/uapi/linux/elfcore.h
@@ -15,15 +15,7 @@ struct elf_siginfo
 	int	si_errno;			/* errno */
 };
 
-
-#ifndef __KERNEL__
-typedef elf_greg_t greg_t;
-typedef elf_gregset_t gregset_t;
-typedef elf_fpregset_t fpregset_t;
-typedef elf_fpxregset_t fpxregset_t;
-#define NGREG ELF_NGREG
-#endif
-
+#ifdef __KERNEL__
 /*
  * Definitions to generate Intel SVR4-like core files.
  * These mostly have the same names as the SVR4 types with "elf_"
@@ -48,10 +40,10 @@ struct elf_prstatus
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
@@ -72,6 +64,7 @@ struct elf_prstatus
 #endif
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
+#endif /* __KERNEL__ */
 
 #define ELF_PRARGSZ	(80)	/* Number of chars for args */
 
@@ -84,7 +77,7 @@ struct elf_prpsinfo
 	unsigned long pr_flag;	/* flags */
 	__kernel_uid_t	pr_uid;
 	__kernel_gid_t	pr_gid;
-	pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	__kernel_pid_t	pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	/* Lots missing */
 	char	pr_fname[16];	/* filename of executable */
 	char	pr_psargs[ELF_PRARGSZ];	/* initial part of arg list */
-- 
2.5.0
