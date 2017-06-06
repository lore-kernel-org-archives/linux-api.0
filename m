From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 16/26] exit: Fix reporting a ptraced !reparented leader has exited
Date: Tue,  6 Jun 2017 14:03:28 -0500
Message-ID: <20170606190338.28347-16-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When a task exits and uses do_notify_parent to send tsk->exit_signal
or SIGCHLD this has one of two possible meanings.
- The ptraced task has exited
- The thread group has exited

Linux resolves this ambiguity by preferring the thread group exit
interpretation if it is possible.  As the exit of a thread group
containing a task is a superset of the exit of a task.

The code attempts to implement this in it's selection of signal
before calling do_notify_parent for a ptraced task.  Unfortunately
it fails to properly handle the case when the thread_group is still
running (but it's leader has exited).

Fix this for a ptraced child leader by skipping the notification
instead of changing the exit signal.  If we skip sending the signal in
exit_noitfy, when the last of the other threads are reaped
release_task will send the signal for us.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 85b34eff8807..72591eb5e361 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -639,7 +639,7 @@ static void forget_original_parent(struct task_struct *father,
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	bool autoreap;
+	bool autoreap = true;
 	struct task_struct *p, *n;
 	LIST_HEAD(dead);
 
@@ -649,17 +649,12 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
-	if (unlikely(tsk->ptrace)) {
-		int sig = thread_group_leader(tsk) &&
-				thread_group_empty(tsk) &&
-				!ptrace_reparented(tsk) ?
-			tsk->exit_signal : SIGCHLD;
-		autoreap = do_notify_parent(tsk, sig);
-	} else if (thread_group_leader(tsk)) {
+	if (thread_group_leader(tsk) && !ptrace_reparented(tsk)) {
 		autoreap = thread_group_empty(tsk) &&
 			do_notify_parent(tsk, tsk->exit_signal);
-	} else {
-		autoreap = true;
+	}
+	else if (unlikely(tsk->ptrace)) {
+		autoreap = do_notify_parent(tsk, SIGCHLD);
 	}
 
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
-- 
2.10.1
