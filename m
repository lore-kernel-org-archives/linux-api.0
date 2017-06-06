From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 22/26] exit: Fix auto-wait of ptraced children
Date: Tue,  6 Jun 2017 14:03:34 -0500
Message-ID: <20170606190338.28347-22-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In November of 2005 Oleg fixed a kernel crash with commit 7ed0175a462c
("[PATCH] Don't auto-reap traced children").  Oleg's patch was the fix
for CVE-2005-3784 where one description says:

    The auto-reap of child processes in Linux kernel 2.6 before 2.6.15
    includes processes with ptrace attached, which leads to a dangling
    ptrace reference and allows local users to cause a denial of
    service (crash) and gain root privileges.

Not reaping the zombies resulted in zombies on the ptrace list when
threads that ignored them exited.  Resulting in Roland authoring
666f164f4fbf ("fix dangling zombie when new parent ignores children").

Which winds up auto-waiting for those zombies not when the tasks exit
and become zombies but when the ptracer exits.

As the kernel is already auto-waiting zombies for ptraced children
rewrite the code to use the same code paths for auto-waiting as we use
for all other children.

This is a user visible change so something might care but as auto-wait
at exit semantics are not documented anywhere, are in direct violation
of what SIG_IGN and SA_NOCLDWAIT are documented by posix to do, and
added to avoid a kernel crash, I don't expect there will be problems.

Fixes: 7ed0175a462c ("[PATCH] Don't auto-reap traced children")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c   | 10 +++++++---
 kernel/ptrace.c | 23 +----------------------
 kernel/signal.c |  2 +-
 3 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2f01b75e3b2e..eaea41c8e646 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -638,7 +638,7 @@ static void forget_original_parent(struct task_struct *father,
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	int state = EXIT_DEAD;
+	int state;
 	struct task_struct *p, *n;
 	LIST_HEAD(dead);
 
@@ -648,6 +648,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
+renotify:
+	state = EXIT_DEAD;
 	if (thread_group_leader(tsk) && !ptrace_reparented(tsk)) {
 		state = EXIT_ZOMBIE;
 		if (thread_group_empty(tsk) &&
@@ -656,8 +658,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	}
 	else if (unlikely(tsk->ptrace)) {
 		state = EXIT_TRACEE;
-		if (do_notify_parent(tsk, SIGCHLD))
-			state = EXIT_DEAD;
+		if (do_notify_parent(tsk, SIGCHLD)) {
+			__ptrace_unlink(tsk);
+			goto renotify;
+		}
 	}
 
 	tsk->exit_state = state;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 003567a615f9..c52cbbcbe258 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -468,19 +468,6 @@ static int ptrace_traceme(void)
 }
 
 /*
- * Called with irqs disabled, returns true if childs should reap themselves.
- */
-static int ignoring_children(struct sighand_struct *sigh)
-{
-	int ret;
-	spin_lock(&sigh->siglock);
-	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
-	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
-	spin_unlock(&sigh->siglock);
-	return ret;
-}
-
-/*
  * Called with tasklist_lock held for writing.
  * Unlink a traced task, and clean it up if it was a traced zombie.
  * Return true if it needs to be reaped with release_task().
@@ -501,15 +488,7 @@ static bool __exit_ptrace(struct task_struct *tracer, struct task_struct *p)
 
 	__ptrace_unlink(p);
 
-	if (state == EXIT_ZOMBIE) {
-		/* Honor the parents request to autoreap children */
-		if (thread_group_empty(p) &&
-		    ignoring_children(tracer->sighand)) {
-			state = EXIT_DEAD;
-			__wake_up_parent(p, tracer);
-		}
-	}
-	else if (state == EXIT_TRACEE) {
+	if (state == EXIT_TRACEE) {
 		state = EXIT_DEAD;
 		if (thread_group_leader(p)) {
 			state = EXIT_ZOMBIE;
diff --git a/kernel/signal.c b/kernel/signal.c
index 627b482fa3f8..30d652f86964 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1645,7 +1645,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-	if (!tsk->ptrace && sig == SIGCHLD &&
+	if (sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
 		/*
-- 
2.10.1
