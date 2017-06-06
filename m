From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 12/26] wait: Directly test for the two cases where wait_task_zombie is called
Date: Tue,  6 Jun 2017 14:03:24 -0500
Message-ID: <20170606190338.28347-12-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

We call wait_task_zombie to reap child processes and to release
zombie ptraced threads.  Collect all of the tests for these two
cases into their own individual if statements to make it clear
what is going on.

This results in no change in behavior just a change in how the code is
written.

Seeing how these two cases that call wait_task_zombie
are equivalent to the original is not trivial so here
is my reasoning:

	/*
	 * Original test ---------------------------------------------
	 */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !delay_group_leader(p) &&
	    ((ptrace ||
	      (p->ptrace && !ptrace_reparented(p))) ||
	     !p->ptrace))
		return wait_task_zombile(wo, p);

	/*
	 * Expand delay_group_leader  --------------------------------
	 */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !(thread_group_leader(p) && !thread_group_empty(p)) &&
	    ((ptrace ||
	      (p->ptrace && !ptrace_reparented(p))) ||
	     !p->ptrace))
		return wait_task_zombile(wo, p);

	/*
	 * Moving ! via DeMorgan's law  ------------------------------
	 */
	if ((exit_state == EXIT_ZOMBIE) &&
	    (!thread_group_leader(p) || thread_group_empty(p)) &&
	    ((ptrace ||
	      (p->ptrace && !ptrace_reparented(p))) ||
	     !p->ptrace))
		return wait_task_zombile(wo, p);

	/*
	 * Three basic cases from the last || expression  ------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace && !p->ptrace &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/* ptraced zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace && p->ptrace &&
	    !ptrace_reparented(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/* ptraced process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Combining the first two cases  ----------------------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace &&
	    !ptrace_reparented(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/* ptraced process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Exploiting !ptrace implies thread_group_leader  -----------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace &&
	    !ptrace_reparented(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Splitting the second case by ptrace_reparented  -----------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace &&
	    !ptrace_reparented(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced child process or child thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !ptrace_reparenated(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/* ptraced process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Splitting the second case by leadership  ------------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) && !ptrace &&
	    !ptrace_reparented(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced child process? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !ptrace_reparenated(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced child thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !ptrace_reparenated(p) &&
	    !thread_group_leader(p))
		return wait_task_zombie(wo, p);

	/* ptraced process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Combining the first two cases  ----------------------------
	 * Using the knowledge that !ptrace implies thread_group_leader
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !ptrace_reparented(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced child thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !ptrace_reparenated(p) &&
	    !thread_group_leader(p))
		return wait_task_zombie(wo, p);

	/* ptraced non-child process or thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    (!thread_group_leader(p) || thread_group_empty(p)))
		return wait_task_zombie(wo, p);

	/*
	 * Splitting the thread case by leadership  ------------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !ptrace_reparented(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced child thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !ptrace_reparenated(p) &&
	    !thread_group_leader(p))
		return wait_task_zombie(wo, p);

	/* ptraced non-child thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    !thread_group_leader(p))
		return wait_task_zombie(wo, p);

	/* ptraced non-child process? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/*
	 * Combining the second and third cases  ---------------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !ptrace_reparented(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced thread? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    !thread_group_leader(p))
		return wait_task_zombie(wo, p);

	/* ptraced non-child process? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    ptrace_reparanted(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/*
	 * Combining the second and third cases  ---------------------
	 */
	/* zombie child process? */
	if ((exit_state == EXIT_ZOMBIE) &&
	    !ptrace_reparented(p) &&
	    thread_group_leader(p) &&
	    thread_group_empty(p))
		return wait_task_zombie(wo, p);

	/* ptraced thread or ptraced non-child process? */
	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
	    (!thread_group_leader(p) ||
	     (ptrace_reparented(p) && thread_group_empty(p))))
		return wait_task_zombie(wo, p);

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 306e526f4c5e..9b70e21c960d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1342,6 +1342,24 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (!ret)
 		return ret;
 
+	/* zombie child process? */
+	if ((exit_state == EXIT_ZOMBIE) &&
+	    !ptrace_reparented(p) &&
+	    thread_group_leader(p) &&
+	    thread_group_empty(p))
+		return wait_task_zombie(wo, p);
+
+	/*
+	 * A zombie ptracee that is not a child of it's ptracer's
+	 * thread group is only visible to its ptracer.  Notification
+	 * and reaping will be cascaded to the real parent when the
+	 * ptracer detaches.
+	 */
+	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
+	    (!thread_group_leader(p) ||
+	     (ptrace_reparented(p) && thread_group_empty(p))))
+		return wait_task_zombie(wo, p);
+
 	if (unlikely(exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
@@ -1354,33 +1372,17 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 
 	if (likely(!ptrace) && unlikely(p->ptrace)) {
 		/*
-		 * If it is traced by its real parent's group, just pretend
-		 * the caller is ptrace_do_wait() and reap this child if it
-		 * is zombie.
-		 *
-		 * This also hides group stop state from real parent; otherwise
-		 * a single stop can be reported twice as group and ptrace stop.
-		 * If a ptracer wants to distinguish these two events for its
-		 * own children it should create a separate process which takes
-		 * the role of real parent.
+		 * Hide group stop state from real parent; otherwise a single
+		 * stop can be reported twice as group and ptrace stop.  If a
+		 * ptracer wants to distinguish these two events for its own
+		 * children it should create a separate process which takes the
+		 * role of real parent.
 		 */
 		if (!ptrace_reparented(p))
 			ptrace = 1;
 	}
 
-	/* slay zombie? */
 	if (exit_state == EXIT_ZOMBIE) {
-		/* we don't reap group leaders with subthreads */
-		if (!delay_group_leader(p)) {
-			/*
-			 * A zombie ptracee is only visible to its ptracer.
-			 * Notification and reaping will be cascaded to the
-			 * real parent when the ptracer detaches.
-			 */
-			if (unlikely(ptrace) || likely(!p->ptrace))
-				return wait_task_zombie(wo, p);
-		}
-
 		/*
 		 * Allow access to stopped/continued state via zombie by
 		 * falling through.  Clearing of notask_error is complex.
-- 
2.10.1
