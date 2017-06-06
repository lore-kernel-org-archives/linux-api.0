From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 14/26] wait: Move changing of ptrace from wait_consider_task into wait_task_stopped
Date: Tue,  6 Jun 2017 14:03:26 -0500
Message-ID: <20170606190338.28347-14-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

With the freeing and slaying of zombies moved earlier in wait_consider_task
changing of the ptrace value only effects the clearing of notask_error and
wait_task_stopped.  Move the changing of ptrace into wait_task_stopped.
The value of ptrace coming into the code clearing notask_error is left
at it's original value.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 9b70e21c960d..dbf3fce00a1f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1194,6 +1194,16 @@ static int wait_task_stopped(struct wait_opts *wo,
 	pid_t pid;
 
 	/*
+	 * Hide group stop state from real parent; otherwise a single
+	 * stop can be reported twice as group and ptrace stop.  If a
+	 * ptracer wants to distinguish these two events for its own
+	 * children it should create a separate process which takes the
+	 * role of real parent.
+	 */
+	if (!ptrace && p->ptrace && !ptrace_reparented(p))
+		ptrace = 1;
+
+	/*
 	 * Traditionally we see ptrace'd stopped tasks regardless of options.
 	 */
 	if (!ptrace && !(wo->wo_flags & WUNTRACED))
@@ -1370,18 +1380,6 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (likely(!ptrace) && unlikely(p->ptrace)) {
-		/*
-		 * Hide group stop state from real parent; otherwise a single
-		 * stop can be reported twice as group and ptrace stop.  If a
-		 * ptracer wants to distinguish these two events for its own
-		 * children it should create a separate process which takes the
-		 * role of real parent.
-		 */
-		if (!ptrace_reparented(p))
-			ptrace = 1;
-	}
-
 	if (exit_state == EXIT_ZOMBIE) {
 		/*
 		 * Allow access to stopped/continued state via zombie by
@@ -1403,7 +1401,8 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		 * target task dies.  Only continued and exited can happen.
 		 * Clear notask_error if WCONTINUED | WEXITED.
 		 */
-		if (likely(!ptrace) || (wo->wo_flags & (WCONTINUED | WEXITED)))
+		if ((!ptrace && (!p->ptrace || ptrace_reparented(p))) ||
+		    (wo->wo_flags & (WCONTINUED | WEXITED)))
 			wo->notask_error = 0;
 	} else {
 		/*
-- 
2.10.1
