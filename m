From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 08/17] signal: Stop special casing TRAP_FIXME and FPE_FIXME in siginfo_layout
Date: Thu, 19 Apr 2018 20:03:59 -0500
Message-ID: <20180420010408.24438-8-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

After more experience with the cases where no one the si_code of 0
is used both as a signal specific si_code, and as SI_USER it appears
that no one cares about the signal specific si_code case and the
good solution is to just fix the architectures by using
a different si_code.

In none of the conversations has anyone even suggested that
anything depends on the signal specific redefinition of SI_USER.

There are at least test cases that care when si_code as 0 does
not work as si_user.

So make things simple and keep the generic code from introducing
problems by removing the special casing of TRAP_FIXME and FPE_FIXME.
This will ensure the generic case of sending a signal with
kill will always set SI_USER and work.

The architecture specific, and signal specific overloads that
set si_code to 0 will now have problems with signalfd and
the 32bit compat versions of siginfo copying.   At least
until they are fixed.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d56f4d496c89..fc82d2c0918f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2835,15 +2835,6 @@ enum siginfo_layout siginfo_layout(int sig, int si_code)
 			layout = SIL_POLL;
 		else if (si_code < 0)
 			layout = SIL_RT;
-		/* Tests to support buggy kernel ABIs */
-#ifdef TRAP_FIXME
-		if ((sig == SIGTRAP) && (si_code == TRAP_FIXME))
-			layout = SIL_FAULT;
-#endif
-#ifdef FPE_FIXME
-		if ((sig == SIGFPE) && (si_code == FPE_FIXME))
-			layout = SIL_FAULT;
-#endif
 	}
 	return layout;
 }
-- 
2.14.1
