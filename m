From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 19/26] wait: Simpler code for clearing notask_error in wait_consider_task
Date: Tue,  6 Jun 2017 14:03:31 -0500
Message-ID: <20170606190338.28347-19-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Start with reaping pending zombies and then return if there is nothing
wait_task_consider can ever do with the task.

What remains are living tasks and delayed child zombie thread group
leaders waiting for their thread group to exit.  Leaving something for
WEXITED to find later.

As long as WEXITED can happen the code is guaranteed not to block
indefinitely, as at least the exit event will wake it up.  The only
reason not to clear notask_error is if it is impossible for wait
to find something to report.  For zombie thread group leaders it
is possible that living threads will report group wide continued
or stopped states.

Which means we can now safely and practically always clear notask_error.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 62 ++++++++++++++++++++++-------------------------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4e2d2b6f5581..8f3825b22de5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1359,47 +1359,31 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if ((exit_state == EXIT_TRACEE) && ptrace)
 		return wait_task_zombie(wo, exit_state, p);
 
-	if (unlikely(exit_state == EXIT_TRACED)) {
-		/*
-		 * ptrace == 0 means we are the natural parent. In this case
-		 * we should clear notask_error, debugger will notify us.
-		 */
-		if (likely(!ptrace))
-			wo->notask_error = 0;
+	/* Is this task past the point where ptrace cares? */
+	if (unlikely((exit_state == EXIT_TRACED) && ptrace))
 		return 0;
-	}
 
-	if (exit_state == EXIT_ZOMBIE) {
-		/*
-		 * Allow access to stopped/continued state via zombie by
-		 * falling through.  Clearing of notask_error is complex.
-		 *
-		 * When !@ptrace:
-		 *
-		 * If WEXITED is set, notask_error should naturally be
-		 * cleared.  If not, subset of WSTOPPED|WCONTINUED is set,
-		 * so, if there are live subthreads, there are events to
-		 * wait for.  If all subthreads are dead, it's still safe
-		 * to clear - this function will be called again in finite
-		 * amount time once all the subthreads are released and
-		 * will then return without clearing.
-		 *
-		 * When @ptrace:
-		 *
-		 * Stopped state is per-task and thus can't change once the
-		 * target task dies.  Only continued and exited can happen.
-		 * Clear notask_error if WCONTINUED | WEXITED.
-		 */
-		if ((!ptrace && (!p->ptrace || ptrace_reparented(p))) ||
-		    (wo->wo_flags & (WCONTINUED | WEXITED)))
-			wo->notask_error = 0;
-	} else {
-		/*
-		 * @p is alive and it's gonna stop, continue or exit, so
-		 * there always is something to wait for.
-		 */
-		wo->notask_error = 0;
-	}
+	/*
+	 * A this point @p is alive or the zombie of a delayed
+	 * child thread group leader that has not been reaped yet.
+	 *
+	 * Allow access to stopped/continued state via zombie by
+	 * falling through.  Clearing of notask_error is logically complex.
+	 *
+	 * When @p is alive and it's gonna stop, continue or exit,
+	 * so there always is something to wait for.
+	 *
+	 * When @p is a zombie
+	 *
+	 * If WEXITED is set, notask_error should naturally be
+	 * cleared.  If not, subset of WSTOPPED|WCONTINUED is set,
+	 * so, if there are live subthreads, there are events to
+	 * wait for.  If all subthreads are dead, it's still safe
+	 * to clear - this function will be called again in finite
+	 * amount time once all the subthreads are released and
+	 * will then return without clearing.
+	 */
+	wo->notask_error = 0;
 
 	/*
 	 * Wait for stopped.
-- 
2.10.1
