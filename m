From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 11/26] wait: Properly implement __WCLONE handling in the presence of exec and ptrace
Date: Tue,  6 Jun 2017 14:03:23 -0500
Message-ID: <20170606190338.28347-11-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Rewrite the condition for what contitues a clone child.  AKA a child
that reports to it's parent using something other than SIGCHLD.

If the parent has called exec since the child has started that child
will alwasy report to it's parent with SIGCHLD.

If the parent is only ptracing the child the child will always
report to the parent with SIGCHLD.

This implements the documented semantics and subsumes the fix Oleg
made in 4.7 to make __WCLONE unnecessary when ptracing a child.  It was
just a bug in the check for __WCLONE support that made that necessary
the ``semantic'' change necessary.

Around v2.3.23 notify_parent was fixed to send SIGCHLD if the parent
had exec'd.  Fixing half a bug but wait was not fixed to see children
in that case.

Not handling either the ptrace or the parent exec case appears to
go all of the way back to 1.0.

Fixes: bf959931ddb8 ("wait/ptrace: assume __WALL if the child is traced")
Fixes: v1.0
Fixes: v2.3.23
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 625e57f1bb5c..306e526f4c5e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -950,31 +950,26 @@ static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 		task_pid_type(p, wo->wo_type) == wo->wo_pid;
 }
 
-static int
-eligible_child(struct wait_opts *wo, bool ptrace, struct task_struct *p)
+static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
 	if (!eligible_pid(wo, p))
 		return 0;
 
 	/*
-	 * Wait for all children (clone and not) if __WALL is set or
-	 * if it is traced by us.
+	 * Wait for all children (clone and not) if __WALL is set.
 	 */
-	if (ptrace || (wo->wo_flags & __WALL))
+	if (wo->wo_flags & __WALL)
 		return 1;
 
 	/*
-	 * Otherwise, wait for clone children *only* if __WCLONE is set;
-	 * otherwise, wait for non-clone children *only*.
-	 *
-	 * Note: a "clone" child here is one that reports to its parent
-	 * using a signal other than SIGCHLD, or a non-leader thread which
-	 * we can only see if it is traced by us.
+	 * Otherwise wait for either children that report to their
+	 * parent via SIGCHLD (when __WCLONE is not set) or use
+	 * another signal (when __WCLONE is set).
 	 */
-	if ((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
-		return 0;
-
-	return 1;
+	return (((p->exit_signal == SIGCHLD) ||
+		 (p->parent_exec_id == p->real_parent->self_exec_id))
+		 && thread_group_leader(p) && !ptrace_reparented(p)) ^
+		!!(wo->wo_flags & __WCLONE);
 }
 
 static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
@@ -1343,7 +1338,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (unlikely(exit_state == EXIT_DEAD))
 		return 0;
 
-	ret = eligible_child(wo, ptrace, p);
+	ret = eligible_child(wo, p);
 	if (!ret)
 		return ret;
 
-- 
2.10.1
