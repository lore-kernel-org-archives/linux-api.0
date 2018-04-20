From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 07/17] signal: Reduce copy_siginfo_to_user to just copy_to_user
Date: Thu, 19 Apr 2018 20:03:58 -0500
Message-ID: <20180420010408.24438-7-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Now that every instance of struct siginfo is now initialized it is no
longer necessary to copy struct siginfo piece by piece to userspace
but instead the entire structure can be copied.

As well as making the code simpler and more efficient this means that
copy_sinfo_to_user no longer cares which union member of struct
siginfo is in use.

In practice this means that all 32bit architectures that define
FPE_FIXME will handle properly send SI_USER when kill(SIGFPE) is sent.
While still performing their historic architectural brokenness when 0
is used a floating pointer signal.  This matches the current behavior
of 64bit architectures that define FPE_FIXME who get lucky and an
overloaded SI_USER has continuted to work through copy_siginfo_to_user
because the 8 byte si_addr occupies the same bytes in struct siginfo
as the 4 byte si_pid and the 4 byte si_uid.

Problematic architectures still need to fix their ABI so that signalfd
and 32bit compat code will work properly.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 84 ++-------------------------------------------------------
 1 file changed, 2 insertions(+), 82 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d4ccea599692..d56f4d496c89 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2850,89 +2850,9 @@ enum siginfo_layout siginfo_layout(int sig, int si_code)
 
 int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 {
-	int err;
-
-	if (!access_ok (VERIFY_WRITE, to, sizeof(siginfo_t)))
+	if (copy_to_user(to, from , sizeof(struct siginfo)))
 		return -EFAULT;
-	if (from->si_code < 0)
-		return __copy_to_user(to, from, sizeof(siginfo_t))
-			? -EFAULT : 0;
-	/*
-	 * If you change siginfo_t structure, please be sure
-	 * this code is fixed accordingly.
-	 * Please remember to update the signalfd_copyinfo() function
-	 * inside fs/signalfd.c too, in case siginfo_t changes.
-	 * It should never copy any pad contained in the structure
-	 * to avoid security leaks, but must copy the generic
-	 * 3 ints plus the relevant union member.
-	 */
-	err = __put_user(from->si_signo, &to->si_signo);
-	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user(from->si_code, &to->si_code);
-	switch (siginfo_layout(from->si_signo, from->si_code)) {
-	case SIL_KILL:
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		break;
-	case SIL_TIMER:
-		/* Unreached SI_TIMER is negative */
-		break;
-	case SIL_POLL:
-		err |= __put_user(from->si_band, &to->si_band);
-		err |= __put_user(from->si_fd, &to->si_fd);
-		break;
-	case SIL_FAULT:
-		err |= __put_user(from->si_addr, &to->si_addr);
-#ifdef __ARCH_SI_TRAPNO
-		err |= __put_user(from->si_trapno, &to->si_trapno);
-#endif
-#ifdef __ia64__
-		err |= __put_user(from->si_imm, &to->si_imm);
-		err |= __put_user(from->si_flags, &to->si_flags);
-		err |= __put_user(from->si_isr, &to->si_isr);
-#endif
-		/*
-		 * Other callers might not initialize the si_lsb field,
-		 * so check explicitly for the right codes here.
-		 */
-#ifdef BUS_MCEERR_AR
-		if (from->si_signo == SIGBUS && from->si_code == BUS_MCEERR_AR)
-			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
-#endif
-#ifdef BUS_MCEERR_AO
-		if (from->si_signo == SIGBUS && from->si_code == BUS_MCEERR_AO)
-			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
-#endif
-#ifdef SEGV_BNDERR
-		if (from->si_signo == SIGSEGV && from->si_code == SEGV_BNDERR) {
-			err |= __put_user(from->si_lower, &to->si_lower);
-			err |= __put_user(from->si_upper, &to->si_upper);
-		}
-#endif
-#ifdef SEGV_PKUERR
-		if (from->si_signo == SIGSEGV && from->si_code == SEGV_PKUERR)
-			err |= __put_user(from->si_pkey, &to->si_pkey);
-#endif
-		break;
-	case SIL_CHLD:
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		err |= __put_user(from->si_status, &to->si_status);
-		err |= __put_user(from->si_utime, &to->si_utime);
-		err |= __put_user(from->si_stime, &to->si_stime);
-		break;
-	case SIL_RT:
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		err |= __put_user(from->si_ptr, &to->si_ptr);
-		break;
-	case SIL_SYS:
-		err |= __put_user(from->si_call_addr, &to->si_call_addr);
-		err |= __put_user(from->si_syscall, &to->si_syscall);
-		err |= __put_user(from->si_arch, &to->si_arch);
-		break;
-	}
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.14.1
