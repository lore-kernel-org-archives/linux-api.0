From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 17/26] exit: Rework the exit states for ptracees
Date: Tue,  6 Jun 2017 14:03:29 -0500
Message-ID: <20170606190338.28347-17-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Create two new exit states EXIT_TRACEE and EXIT_TRACED replacing
the two states "(EXIT_ZOMBIE && (!thread_group_leader(p) || !ptrace_reparented))
and EXIT_TRACE.  With EXIT_ZOMBIE replacing the state:
"(EXIT_ZOMBIE && thread_group_leader(p) && !ptrace_reparented)".

Rework the code to take advantage of the certain knowledge of
exit state progression:
   EXIT_TRACEE -> EXIT_TRACED -> EXIT_ZOMBIE -> EXIT_DEAD

This makes the code more readable/maintainable by using simple states
rather than complicated expressions.  The values of both of the new
states contain EXIT_ZOMBIE so all of these states appear to userspace
as zombies.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/sched.h |  6 +++++-
 kernel/exit.c         | 51 +++++++++++++++++++++++----------------------------
 kernel/ptrace.c       | 31 +++++++++++++++++--------------
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 461ecd20731c..f2cec7f27e59 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -73,7 +73,6 @@ struct task_group;
 /* Used in tsk->exit_state: */
 #define EXIT_DEAD			16
 #define EXIT_ZOMBIE			32
-#define EXIT_TRACE			(EXIT_ZOMBIE | EXIT_DEAD)
 /* Used in tsk->state again: */
 #define TASK_DEAD			64
 #define TASK_WAKEKILL			128
@@ -82,6 +81,11 @@ struct task_group;
 #define TASK_NOLOAD			1024
 #define TASK_NEW			2048
 #define TASK_STATE_MAX			4096
+/* Used in tsk->exit_state again: */
+#define __EXIT_TRACEE                   8192
+#define __EXIT_TRACED                   16384
+#define EXIT_TRACEE			(EXIT_ZOMBIE | __EXIT_TRACEE)
+#define EXIT_TRACED			(EXIT_ZOMBIE | __EXIT_TRACED)
 
 #define TASK_STATE_TO_CHAR_STR		"RSDTtXZxKWPNn"
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 72591eb5e361..ff2ed1d60a8c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -580,8 +580,7 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	p->exit_signal = SIGCHLD;
 
 	/* If it has exited notify the new parent about this child's death. */
-	if (!p->ptrace &&
-	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
+	if (p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		if (do_notify_parent(p, p->exit_signal)) {
 			p->exit_state = EXIT_DEAD;
 			list_add(&p->ptrace_entry, dead);
@@ -639,7 +638,7 @@ static void forget_original_parent(struct task_struct *father,
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	bool autoreap = true;
+	int state = EXIT_DEAD;
 	struct task_struct *p, *n;
 	LIST_HEAD(dead);
 
@@ -650,14 +649,18 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
 	if (thread_group_leader(tsk) && !ptrace_reparented(tsk)) {
-		autoreap = thread_group_empty(tsk) &&
-			do_notify_parent(tsk, tsk->exit_signal);
+		state = EXIT_ZOMBIE;
+		if (thread_group_empty(tsk) &&
+		    do_notify_parent(tsk, tsk->exit_signal))
+			state = EXIT_DEAD;
 	}
 	else if (unlikely(tsk->ptrace)) {
-		autoreap = do_notify_parent(tsk, SIGCHLD);
+		state = EXIT_TRACEE;
+		if (do_notify_parent(tsk, SIGCHLD))
+			state = EXIT_DEAD;
 	}
 
-	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
+	tsk->exit_state = state;
 	if (tsk->exit_state == EXIT_DEAD)
 		list_add(&tsk->ptrace_entry, &dead);
 
@@ -1001,7 +1004,7 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
+static int wait_task_zombie(struct wait_opts *wo, int old_state, struct task_struct *p)
 {
 	int state, retval, status;
 	pid_t pid = task_pid_vnr(p);
@@ -1029,11 +1032,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
 	/*
-	 * Move the task's state to DEAD/TRACE, only one thread can do this.
+	 * Move the task's state to DEAD/TRACED only one thread can do this.
 	 */
-	state = (ptrace_reparented(p) && thread_group_leader(p)) ?
-		EXIT_TRACE : EXIT_DEAD;
-	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
+	state = ((old_state == EXIT_TRACEE) && thread_group_leader(p)) ?
+		EXIT_TRACED : EXIT_DEAD;
+	if (cmpxchg(&p->exit_state, old_state, state) != old_state)
 		return 0;
 	/*
 	 * We own this thread, nobody else can reap it.
@@ -1041,10 +1044,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	read_unlock(&tasklist_lock);
 	sched_annotate_sleep();
 
-	/*
-	 * Check thread_group_leader() to exclude the traced sub-threads.
-	 */
-	if (state == EXIT_DEAD && thread_group_leader(p)) {
+	if (old_state == EXIT_ZOMBIE) {
 		struct signal_struct *sig = p->signal;
 		struct signal_struct *psig = current->signal;
 		unsigned long maxrss;
@@ -1132,7 +1132,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	if (!retval)
 		retval = pid;
 
-	if (state == EXIT_TRACE) {
+	if (state == EXIT_TRACED) {
 		write_lock_irq(&tasklist_lock);
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
@@ -1335,8 +1335,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 {
 	/*
 	 * We can race with wait_task_zombie() from another thread.
-	 * Ensure that EXIT_ZOMBIE -> EXIT_DEAD/EXIT_TRACE transition
-	 * can't confuse the checks below.
+	 * Ensure that exit_state transition can't confuse the checks below.
 	 */
 	int exit_state = ACCESS_ONCE(p->exit_state);
 	int ret;
@@ -1349,11 +1348,8 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return ret;
 
 	/* zombie child process? */
-	if ((exit_state == EXIT_ZOMBIE) &&
-	    !ptrace_reparented(p) &&
-	    thread_group_leader(p) &&
-	    thread_group_empty(p))
-		return wait_task_zombie(wo, p);
+	if ((exit_state == EXIT_ZOMBIE) && thread_group_empty(p))
+		return wait_task_zombie(wo, exit_state, p);
 
 	/*
 	 * A zombie ptracee that is not a child of it's ptracer's
@@ -1361,11 +1357,10 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	 * and reaping will be cascaded to the real parent when the
 	 * ptracer detaches.
 	 */
-	if ((exit_state == EXIT_ZOMBIE) && ptrace &&
-	    (!thread_group_leader(p) || ptrace_reparented(p)))
-		return wait_task_zombie(wo, p);
+	if ((exit_state == EXIT_TRACEE) && ptrace)
+		return wait_task_zombie(wo, exit_state, p);
 
-	if (unlikely(exit_state == EXIT_TRACE)) {
+	if (unlikely(exit_state == EXIT_TRACED)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
 		 * we should clear notask_error, debugger will notify us.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 490333db9e21..003567a615f9 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -497,27 +497,30 @@ static int ignoring_children(struct sighand_struct *sigh)
  */
 static bool __exit_ptrace(struct task_struct *tracer, struct task_struct *p)
 {
-	bool dead;
+	int state = p->exit_state;
 
 	__ptrace_unlink(p);
 
-	if (p->exit_state != EXIT_ZOMBIE)
-		return false;
-
-	dead = !thread_group_leader(p);
-
-	if (!dead && thread_group_empty(p)) {
-		if (!same_thread_group(p->real_parent, tracer))
-			dead = do_notify_parent(p, p->exit_signal);
-		else if (ignoring_children(tracer->sighand)) {
+	if (state == EXIT_ZOMBIE) {
+		/* Honor the parents request to autoreap children */
+		if (thread_group_empty(p) &&
+		    ignoring_children(tracer->sighand)) {
+			state = EXIT_DEAD;
 			__wake_up_parent(p, tracer);
-			dead = true;
+		}
+	}
+	else if (state == EXIT_TRACEE) {
+		state = EXIT_DEAD;
+		if (thread_group_leader(p)) {
+			state = EXIT_ZOMBIE;
+			if (thread_group_empty(p) &&
+			    do_notify_parent(p, p->exit_signal))
+				state = EXIT_DEAD;
 		}
 	}
 	/* Mark it as in the process of being reaped. */
-	if (dead)
-		p->exit_state = EXIT_DEAD;
-	return dead;
+	p->exit_state = state;
+	return state == EXIT_DEAD;
 }
 
 static int ptrace_detach(struct task_struct *child, unsigned int data)
-- 
2.10.1
