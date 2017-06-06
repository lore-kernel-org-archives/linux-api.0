From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 18/26] wait: Fix WSTOPPED on a ptraced child
Date: Tue,  6 Jun 2017 14:03:30 -0500
Message-ID: <20170606190338.28347-18-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When ptracing waitpid(pid, WUNTRACED) has two possible meanings.
- Wait for ptrace stops from the task with tid == pid
- Wait for ordinary stops from the process with tgid == pid

The only sensible behavior and the Linux behavior in 2.2 and
2.4 has been to consume both ptrace stops and group stops
in this case.  It looks like when Oleg disentangled thread
stops and group stops in 2.6.30 fixing a lot of other issues
the case when we want to reap both was overlooked.

Consume both the group and the ptrace stop state when
waitpid(pid, WUNTRACED) could be asking for both, and
the wait status for both is idenitical.  This keeps
us from double reporting the stop and causing confusion.

This is very slight user visible change and is only visible
in the unlikely case a ptracer specifies WUNTRACED aka
WSTOPPED.

Write this code in such a way that it doesn't matter which
list we are traversing when we find a child whose stop states
we care about.

Fixes: 90bc8d8b1a38 ("do_wait: fix waiting for the group stop with the dead leader")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 kernel/exit.c | 82 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ff2ed1d60a8c..4e2d2b6f5581 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1151,22 +1151,23 @@ static int wait_task_zombie(struct wait_opts *wo, int old_state, struct task_str
 	return retval;
 }
 
-static int *task_stopped_code(struct task_struct *p, bool ptrace)
+static int *task_trace_stopped_code(struct task_struct *p)
 {
-	if (ptrace) {
-		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
-			return &p->exit_code;
-	} else {
-		if (p->signal->flags & SIGNAL_STOP_STOPPED)
-			return &p->signal->group_exit_code;
-	}
+	if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
+		return &p->exit_code;
+	return NULL;
+}
+
+static int *task_group_stopped_code(struct task_struct *p)
+{
+	if (p->signal->flags & SIGNAL_STOP_STOPPED)
+		return &p->signal->group_exit_code;
 	return NULL;
 }
 
 /**
  * wait_task_stopped - Wait for %TASK_STOPPED or %TASK_TRACED
  * @wo: wait options
- * @ptrace: is the wait for ptrace
  * @p: task to wait for
  *
  * Handle sys_wait4() work for %p in state %TASK_STOPPED or %TASK_TRACED.
@@ -1181,49 +1182,47 @@ static int *task_stopped_code(struct task_struct *p, bool ptrace)
  * success, implies that tasklist_lock is released and wait condition
  * search should terminate.
  */
-static int wait_task_stopped(struct wait_opts *wo,
-				int ptrace, struct task_struct *p)
+static int wait_task_stopped(struct wait_opts *wo, struct task_struct *p)
 {
 	struct siginfo __user *infop;
-	int retval, exit_code, *p_code, why;
-	uid_t uid = 0; /* unneeded, required by compiler */
+	int retval, exit_code, *p_code, *g_code, why;
+	bool group, gstop, pstop;
+	uid_t uid;
 	pid_t pid;
 
 	/*
-	 * Hide group stop state from real parent; otherwise a single
-	 * stop can be reported twice as group and ptrace stop.  If a
-	 * ptracer wants to distinguish these two events for its own
-	 * children it should create a separate process which takes the
-	 * role of real parent.
-	 */
-	if (!ptrace && p->ptrace && !ptrace_reparented(p))
-		ptrace = 1;
-
-	/*
 	 * Traditionally we see ptrace'd stopped tasks regardless of options.
 	 */
-	if (!ptrace && !(wo->wo_flags & WUNTRACED))
+	group = thread_group_leader(p) && !ptrace_reparented(p);
+	pstop = same_thread_group(current, p->parent);
+	gstop = group && (wo->wo_flags & WUNTRACED);
+	if (!pstop && !gstop)
 		return 0;
 
-	if (!task_stopped_code(p, ptrace))
+	if ((!pstop || !task_trace_stopped_code(p)) &&
+	    (!gstop || !task_group_stopped_code(p)))
 		return 0;
 
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	p_code = task_stopped_code(p, ptrace);
-	if (unlikely(!p_code))
-		goto unlock_sig;
-
-	exit_code = *p_code;
-	if (!exit_code)
-		goto unlock_sig;
-
-	if (!unlikely(wo->wo_flags & WNOWAIT))
-		*p_code = 0;
-
-	uid = from_kuid_munged(current_user_ns(), task_uid(p));
-unlock_sig:
+	p_code = g_code = NULL;
+	if (pstop)
+		p_code = task_trace_stopped_code(p);
+	if (gstop)
+		g_code = task_group_stopped_code(p);
+	if (p_code) {
+		exit_code = *p_code;
+		why = CLD_TRAPPED;
+		if (!(wo->wo_flags & WNOWAIT))
+			*p_code = 0;
+	}
+	if (g_code && (!exit_code || (*g_code == exit_code))) {
+		exit_code = *g_code;
+		why = CLD_STOPPED;
+		if (!(wo->wo_flags & WNOWAIT))
+			*g_code = 0;
+	}
 	spin_unlock_irq(&p->sighand->siglock);
 	if (!exit_code)
 		return 0;
@@ -1236,8 +1235,8 @@ static int wait_task_stopped(struct wait_opts *wo,
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
+	uid = from_kuid_munged(current_user_ns(), task_uid(p));
 	pid = task_pid_vnr(p);
-	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 	sched_annotate_sleep();
 
@@ -1403,10 +1402,9 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	}
 
 	/*
-	 * Wait for stopped.  Depending on @ptrace, different stopped state
-	 * is used and the two don't interact with each other.
+	 * Wait for stopped.
 	 */
-	ret = wait_task_stopped(wo, ptrace, p);
+	ret = wait_task_stopped(wo, p);
 	if (ret)
 		return ret;
 
-- 
2.10.1
