From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 15/26] wait: Don't delay !ptrace_reparented leaders
Date: Tue,  6 Jun 2017 14:03:27 -0500
Message-ID: <20170606190338.28347-15-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When ptracing waitpid(pid) has two possible meanings.
- Wait for the task with tid == pid to exit
- Wait for the thread group with tgid == pid to exit

Linux resolves this ambiguity by prefering the thread group
interpretation if it is possible.  As the exit of a thread group
containing a task is the superset of the exit of a task.

Delaying reaping of thread group leaders for ptraced children
is how the code implements this resolution.

For ptraced tasks that are not also children this ambiguity does
not exit.  The only possible valid meaning of waitpid(pid) is
to wait for the task with tid == pid to exit.  As such there is
no need to delay reaping ptraced tasks when the tasks are
not also children of the tracer.

Change this carefully as the real parent does need to delay reaping
of these tasks.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index dbf3fce00a1f..85b34eff8807 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1144,7 +1144,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 		/* If parent wants a zombie, don't release it now */
 		state = EXIT_ZOMBIE;
-		if (do_notify_parent(p, p->exit_signal))
+		if (thread_group_empty(p) &&
+		    do_notify_parent(p, p->exit_signal))
 			state = EXIT_DEAD;
 		p->exit_state = state;
 		write_unlock_irq(&tasklist_lock);
@@ -1366,8 +1367,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	 * ptracer detaches.
 	 */
 	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
-	    (!thread_group_leader(p) ||
-	     (ptrace_reparented(p) && thread_group_empty(p))))
+	    (!thread_group_leader(p) || ptrace_reparented(p)))
 		return wait_task_zombie(wo, p);
 
 	if (unlikely(exit_state == EXIT_TRACE)) {
-- 
2.10.1
