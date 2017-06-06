From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/26] exit:  Remove the pointless clearing of SIGPENDING in __exit_signal
Date: Tue,  6 Jun 2017 14:03:17 -0500
Message-ID: <20170606190338.28347-5-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Handling of signals does not happen once do_exit is called as a
process never again exits from the kernel.  So remove this ancient hold
over from something else.

Furthermore this is TIF_SIGPENDING on a zombie.  Which will never
be scheduled on a cpu again.

Setting sigpending=0 was silly in 2.4 when exit_sighand did it and was
called from do_exit.  When exit_sighand started being called from
release_task the code went from silly to completely pointless.

History  tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/
Fixes: 6dfc88977e42 ("[PATCH] shared thread signals")
Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 8926cdd132f2..c3de7ace243c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -164,7 +164,6 @@ static void __exit_signal(struct task_struct *tsk)
 	spin_unlock(&sighand->siglock);
 
 	__cleanup_sighand(sighand);
-	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
 		tty_kref_put(tty);
-- 
2.10.1
