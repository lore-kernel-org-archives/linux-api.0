From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 10/17] signal: Remove ifdefs for BUS_MCEERR_AR and BUS_MCEERR_AO
Date: Thu, 19 Apr 2018 20:04:01 -0500
Message-ID: <20180420010408.24438-10-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

With the recent architecture cleanups these si_codes are always
defined so there is no need to test for them.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/signalfd.c   | 15 ++-------------
 kernel/signal.c | 24 ++++++++----------------
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index d2187a813376..ff302bf50be4 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -117,26 +117,15 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(kinfo->si_trapno, &uinfo->ssi_trapno);
 #endif
-#ifdef BUS_MCEERR_AO
 		/*
 		 * Other callers might not initialize the si_lsb field,
 		 * so check explicitly for the right codes here.
 		 */
 		if (kinfo->si_signo == SIGBUS &&
-		     kinfo->si_code == BUS_MCEERR_AO)
+		    ((kinfo->si_code == BUS_MCEERR_AR) ||
+		     (kinfo->si_code == BUS_MCEERR_AO)))
 			err |= __put_user((short) kinfo->si_addr_lsb,
 					  &uinfo->ssi_addr_lsb);
-#endif
-#ifdef BUS_MCEERR_AR
-		/*
-		 * Other callers might not initialize the si_lsb field,
-		 * so check explicitly for the right codes here.
-		 */
-		if (kinfo->si_signo == SIGBUS &&
-		    kinfo->si_code == BUS_MCEERR_AR)
-			err |= __put_user((short) kinfo->si_addr_lsb,
-					  &uinfo->ssi_addr_lsb);
-#endif
 		break;
 	case SIL_CHLD:
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
diff --git a/kernel/signal.c b/kernel/signal.c
index a6d55a6e9915..b87a9c21f698 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1539,7 +1539,6 @@ int send_sig_fault(int sig, int code, void __user *addr
 	return send_sig_info(info.si_signo, &info, t);
 }
 
-#if defined(BUS_MCEERR_AO) && defined(BUS_MCEERR_AR)
 int force_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *t)
 {
 	struct siginfo info;
@@ -1568,7 +1567,6 @@ int send_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *
 	return send_sig_info(info.si_signo, &info, t);
 }
 EXPORT_SYMBOL(send_sig_mceerr);
-#endif
 
 int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
 {
@@ -2880,14 +2878,11 @@ int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
 #ifdef __ARCH_SI_TRAPNO
 		new.si_trapno = from->si_trapno;
 #endif
-#ifdef BUS_MCEERR_AR
-		if ((from->si_signo == SIGBUS) && (from->si_code == BUS_MCEERR_AR))
-			new.si_addr_lsb = from->si_addr_lsb;
-#endif
-#ifdef BUS_MCEERR_AO
-		if ((from->si_signo == SIGBUS) && (from->si_code == BUS_MCEERR_AO))
+		if ((from->si_signo == SIGBUS) &&
+		    ((from->si_code == BUS_MCEERR_AR) ||
+		     (from->si_code == BUS_MCEERR_AO)))
 			new.si_addr_lsb = from->si_addr_lsb;
-#endif
+
 		if ((from->si_signo == SIGSEGV) &&
 		    (from->si_code == SEGV_BNDERR)) {
 			new.si_lower = ptr_to_compat(from->si_lower);
@@ -2964,14 +2959,11 @@ int copy_siginfo_from_user32(struct siginfo *to,
 #ifdef __ARCH_SI_TRAPNO
 		to->si_trapno = from.si_trapno;
 #endif
-#ifdef BUS_MCEERR_AR
-		if ((from.si_signo == SIGBUS) && (from.si_code == BUS_MCEERR_AR))
+		if ((from.si_signo == SIGBUS) &&
+		    ((from.si_code == BUS_MCEERR_AR) ||
+		     (from.si_code == BUS_MCEERR_AO)))
 			to->si_addr_lsb = from.si_addr_lsb;
-#endif
-#ifdef BUS_MCEER_AO
-		if ((from.si_signo == SIGBUS) && (from.si_code == BUS_MCEERR_AO))
-			to->si_addr_lsb = from.si_addr_lsb;
-#endif
+
 		if ((from.si_signo == SIGSEGV) && (from.si_code == SEGV_BNDERR)) {
 			to->si_lower = compat_ptr(from.si_lower);
 			to->si_upper = compat_ptr(from.si_upper);
-- 
2.14.1
