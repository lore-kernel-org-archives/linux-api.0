From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH v2 1/5] ptrace: Don't wait in PTRACE_O_TRACEEXIT for exec or coredump
Date: Sun, 02 Apr 2017 17:51:16 -0500
Message-ID: <87wpb28luj.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
        <874ly6a0h1.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874ly6a0h1.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Sun, 02 Apr 2017 17:50:02 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Take advantage of the fact that no ptrace stop will wait for
a debugger if another process sends SIGKILL to the waiting task.

In the case of exec and coredump which have many interesting deadlock
opportunities and no one tests the what happens if you are ptraced
during exec or coredump act like another SIGKILL was immediately
sent to the process and don't stop.

Keep sending the signal to the tracer so that this appears like
the worst case where someone else sent the process a SIGKILL before
the tracer could react.  So all non-buggy tracers must support
this case.

Signed-off-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/signal.c | 103 +++++++++++++++++++++++---------------------------------
 1 file changed, 42 insertions(+), 61 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7e59ebc2c25e..11fa736eb2ae 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1740,30 +1740,6 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
-static inline int may_ptrace_stop(void)
-{
-	if (!likely(current->ptrace))
-		return 0;
-	/*
-	 * Are we in the middle of do_coredump?
-	 * If so and our tracer is also part of the coredump stopping
-	 * is a deadlock situation, and pointless because our tracer
-	 * is dead so don't allow us to stop.
-	 * If SIGKILL was already sent before the caller unlocked
-	 * ->siglock we must see ->core_state != NULL. Otherwise it
-	 * is safe to enter schedule().
-	 *
-	 * This is almost outdated, a task with the pending SIGKILL can't
-	 * block in TASK_TRACED. But PTRACE_EVENT_EXIT can be reported
-	 * after SIGKILL was already dequeued.
-	 */
-	if (unlikely(current->mm->core_state) &&
-	    unlikely(current->mm == current->parent->mm))
-		return 0;
-
-	return 1;
-}
-
 /*
  * Return non-zero if there is a SIGKILL that should be waking us up.
  * Called with the siglock held.
@@ -1789,6 +1765,8 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
+	bool ptrace_parent;
+	bool ptrace_wait;
 	bool gstop_done = false;
 
 	if (arch_ptrace_stop_needed(exit_code, info)) {
@@ -1842,53 +1820,56 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (may_ptrace_stop()) {
-		/*
-		 * Notify parents of the stop.
-		 *
-		 * While ptraced, there are two parents - the ptracer and
-		 * the real_parent of the group_leader.  The ptracer should
-		 * know about every stop while the real parent is only
-		 * interested in the completion of group stop.  The states
-		 * for the two don't interact with each other.  Notify
-		 * separately unless they're gonna be duplicates.
-		 */
+	ptrace_parent = likely(current->ptrace);
+	/*
+	 * Notify parents of the stop.
+	 *
+	 * While ptraced, there are two parents - the ptracer and
+	 * the real_parent of the group_leader.  The ptracer should
+	 * know about every stop while the real parent is only
+	 * interested in the completion of group stop.  The states
+	 * for the two don't interact with each other.  Notify
+	 * separately unless they're gonna be duplicates.
+	 */
+	if (ptrace_parent)
 		do_notify_parent_cldstop(current, true, why);
-		if (gstop_done && ptrace_reparented(current))
-			do_notify_parent_cldstop(current, false, why);
+	if (gstop_done && (ptrace_reparented(current) || !ptrace_parent))
+		do_notify_parent_cldstop(current, false, why);
 
-		/*
-		 * Don't want to allow preemption here, because
-		 * sys_ptrace() needs this task to be inactive.
-		 *
-		 * XXX: implement read_unlock_no_resched().
-		 */
-		preempt_disable();
-		read_unlock(&tasklist_lock);
-		preempt_enable_no_resched();
-		freezable_schedule();
-	} else {
-		/*
-		 * By the time we got the lock, our tracer went away.
-		 * Don't drop the lock yet, another tracer may come.
-		 *
-		 * If @gstop_done, the ptracer went away between group stop
-		 * completion and here.  During detach, it would have set
-		 * JOBCTL_STOP_PENDING on us and we'll re-enter
-		 * TASK_STOPPED in do_signal_stop() on return, so notifying
-		 * the real parent of the group stop completion is enough.
-		 */
-		if (gstop_done)
-			do_notify_parent_cldstop(current, false, why);
+	/*
+	 * Always wait for the traceer if the process is traced unless
+	 * the process is in the middle of an exec or core dump.
+	 *
+	 * In exec we risk a deadlock with de_thread waiting for the
+	 * thread to be killed, the tracer, and acquring cred_guard_mutex.
+	 *
+	 * In coredump we risk a deadlock if the tracer is also part
+	 * of the coredump stopping.
+	 */
+	ptrace_wait = ptrace_parent &&
+		!current->signal->group_exit_task &&
+		!current->mm->core_state;
 
+	if (!ptrace_wait) {
 		/* tasklist protects us from ptrace_freeze_traced() */
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code = 0;
-		read_unlock(&tasklist_lock);
 	}
 
 	/*
+	 * Don't want to allow preemption here, because
+	 * sys_ptrace() needs this task to be inactive.
+	 *
+	 * XXX: implement read_unlock_no_resched().
+	 */
+	preempt_disable();
+	read_unlock(&tasklist_lock);
+	preempt_enable_no_resched();
+	if (ptrace_wait)
+		freezable_schedule();
+
+	/*
 	 * We are back.  Now reacquire the siglock before touching
 	 * last_siginfo, so that we are sure to have synchronized with
 	 * any signal-sending on another CPU that wants to examine it.
-- 
2.10.1
