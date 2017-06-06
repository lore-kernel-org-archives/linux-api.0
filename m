From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 25/26] signal: In ptrace_stop use CLD_TRAPPED in all ptrace signals
Date: Tue,  6 Jun 2017 14:03:37 -0500
Message-ID: <20170606190338.28347-25-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

If the only job of the signal is to report a ptrace level event set
si_code to CLD_TRAPPED instead of possibly CLD_STOPPED.

This causes the siginfo of the signals that are sent to match the
signinfo of the signals returned by waitid.

This is a user visible difference but I don't expect anything will
care.

In fact this is a return to historical linux behavior.  In linux 2.4.0
all ptrace stops were reported through do_notify_parent with
CLD_TRAPPED.  When do_notify_parent_cldstop was added the CLD_TRAPPED
logic was not included and CLD_TRAPPED for ptrace stops was lost.  As
nothing was said about this case I assume it was an oversight.

When waitid was added a little earlier all stops were being
reported with do_notify_parent and all ptrace stops were setting
CLD_TRAPPED.  So initially signals and waitid were in sync with
respect to setting CLD_TRAPPED.

It is also worth knowing that posix uses documents CLD_TRAPPED
as "Traced child has trapped."

History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Ref: ca3f74aa7baa ("[PATCH] waitid system call")
Fixes: Fixes: ebf5ebe31d2c ("[PATCH] signal-fixes-2.5.59-A4")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ff41e6ee2b5e..0d4ca87f1fee 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1886,9 +1886,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 * separately unless they are going to be identical.
 		 */
 		if (!identical)
-			do_notify_parent_cldstop(current, true, why);
+			do_notify_parent_cldstop(current, true, CLD_TRAPPED);
 		if (gstop_done)
-			do_notify_parent_cldstop(current, false, why);
+			do_notify_parent_cldstop(current, false, CLD_STOPPED);
 
 		/*
 		 * Don't want to allow preemption here, because
@@ -1912,7 +1912,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 * the real parent of the group stop completion is enough.
 		 */
 		if (gstop_done)
-			do_notify_parent_cldstop(current, false, why);
+			do_notify_parent_cldstop(current, false, CLD_STOPPED);
 
 		/* tasklist protects us from ptrace_freeze_traced() */
 		__set_current_state(TASK_RUNNING);
-- 
2.10.1
