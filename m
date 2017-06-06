From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 24/26] signal: In ptrace_stop improve identical signal detection
Date: Tue,  6 Jun 2017 14:03:36 -0500
Message-ID: <20170606190338.28347-24-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When two signals are generated make it the thread level signal that is
possibly surpessed.  The reasoning is that the group level signal
always needs to be generated to report a group stop when that happens
and it is possibly doing double duty as both the group level and the
thread level signal.  So if the thread level signal is identical to
the group level signal it does not need to be sent (or even attempted
to be sent).

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/signal.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0ec90689039a..ff41e6ee2b5e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1813,6 +1813,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__acquires(&current->sighand->siglock)
 {
 	bool gstop_done = false;
+	bool identical = false;
 
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
@@ -1852,8 +1853,16 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * could be clear now.  We act as if SIGCONT is received after
 	 * TASK_TRACED is entered - ignore it.
 	 */
-	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
-		gstop_done = task_participate_group_stop(current);
+	if (why == CLD_STOPPED) {
+		if (current->jobctl & JOBCTL_STOP_PENDING)
+			gstop_done = task_participate_group_stop(current);
+
+		/* Will the two generated signals be identical? */
+		identical = gstop_done &&
+			!(current->jobctl & JOBCTL_TRAP_NOTIFY) &&
+			!ptrace_reparented(current) &&
+			(task_pid(current) == task_tgid(current));
+	}
 
 	/* any trap clears pending STOP trap, STOP trap clears NOTIFY */
 	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
@@ -1874,10 +1883,11 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 * know about every stop while the real parent is only
 		 * interested in the completion of group stop.  The states
 		 * for the two don't interact with each other.  Notify
-		 * separately unless they're gonna be duplicates.
+		 * separately unless they are going to be identical.
 		 */
-		do_notify_parent_cldstop(current, true, why);
-		if (gstop_done && ptrace_reparented(current))
+		if (!identical)
+			do_notify_parent_cldstop(current, true, why);
+		if (gstop_done)
 			do_notify_parent_cldstop(current, false, why);
 
 		/*
-- 
2.10.1
