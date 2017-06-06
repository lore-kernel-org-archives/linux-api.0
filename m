From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 20/26] wait: Don't pass the list to wait_consider_task
Date: Tue,  6 Jun 2017 14:03:32 -0500
Message-ID: <20170606190338.28347-20-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The list a task is found on is not really relevant to wait, so stop passing
the list in and write the conditions in such a way as to not take the list
into consideration.  This is technically user visible due to __WNOTHREAD
but is very unlikely to matter in practice.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 8f3825b22de5..c783d5fb5ab3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1329,8 +1329,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
  * then ->notask_error is 0 if @p is an eligible child,
  * or still -ECHILD.
  */
-static int wait_consider_task(struct wait_opts *wo, int ptrace,
-				struct task_struct *p)
+static int wait_consider_task(struct wait_opts *wo, struct task_struct *p)
 {
 	/*
 	 * We can race with wait_task_zombie() from another thread.
@@ -1356,11 +1355,13 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	 * and reaping will be cascaded to the real parent when the
 	 * ptracer detaches.
 	 */
-	if ((exit_state == EXIT_TRACEE) && ptrace)
+	if ((exit_state == EXIT_TRACEE) && same_thread_group(current, p->parent))
 		return wait_task_zombie(wo, exit_state, p);
 
 	/* Is this task past the point where ptrace cares? */
-	if (unlikely((exit_state == EXIT_TRACED) && ptrace))
+	if (unlikely((exit_state == EXIT_TRACED) &&
+		     !(same_thread_group(current, p->real_parent) &&
+		       thread_group_leader(p))))
 		return 0;
 
 	/*
@@ -1414,7 +1415,7 @@ static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(wo, 0, p);
+		int ret = wait_consider_task(wo, p);
 
 		if (ret)
 			return ret;
@@ -1428,7 +1429,7 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, 1, p);
+		int ret = wait_consider_task(wo, p);
 
 		if (ret)
 			return ret;
-- 
2.10.1
