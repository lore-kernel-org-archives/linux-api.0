From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 09/17] signal: Remove SEGV_BNDERR ifdefs
Date: Thu, 19 Apr 2018 20:04:00 -0500
Message-ID: <20180420010408.24438-9-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

After the last round of cleanups to siginfo.h SEGV_BNDERR is defined
on all architectures so testing to see if it is defined is unnecessary.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index fc82d2c0918f..a6d55a6e9915 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1570,7 +1570,6 @@ int send_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *
 EXPORT_SYMBOL(send_sig_mceerr);
 #endif
 
-#ifdef SEGV_BNDERR
 int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
 {
 	struct siginfo info;
@@ -1584,7 +1583,6 @@ int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
 	info.si_upper = upper;
 	return force_sig_info(info.si_signo, &info, current);
 }
-#endif
 
 #ifdef SEGV_PKUERR
 int force_sig_pkuerr(void __user *addr, u32 pkey)
@@ -2890,13 +2888,11 @@ int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
 		if ((from->si_signo == SIGBUS) && (from->si_code == BUS_MCEERR_AO))
 			new.si_addr_lsb = from->si_addr_lsb;
 #endif
-#ifdef SEGV_BNDERR
 		if ((from->si_signo == SIGSEGV) &&
 		    (from->si_code == SEGV_BNDERR)) {
 			new.si_lower = ptr_to_compat(from->si_lower);
 			new.si_upper = ptr_to_compat(from->si_upper);
 		}
-#endif
 #ifdef SEGV_PKUERR
 		if ((from->si_signo == SIGSEGV) &&
 		    (from->si_code == SEGV_PKUERR))
@@ -2976,12 +2972,10 @@ int copy_siginfo_from_user32(struct siginfo *to,
 		if ((from.si_signo == SIGBUS) && (from.si_code == BUS_MCEERR_AO))
 			to->si_addr_lsb = from.si_addr_lsb;
 #endif
-#ifdef SEGV_BNDERR
 		if ((from.si_signo == SIGSEGV) && (from.si_code == SEGV_BNDERR)) {
 			to->si_lower = compat_ptr(from.si_lower);
 			to->si_upper = compat_ptr(from.si_upper);
 		}
-#endif
 #ifdef SEGV_PKUERR
 		if ((from.si_signo == SIGSEGV) && (from.si_code == SEGV_PKUERR))
 			to->si_pkey = from.si_pkey;
-- 
2.14.1
