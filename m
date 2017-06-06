From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 23/26] signal:  Fix SIGCONT before group stop completes.
Date: Tue,  6 Jun 2017 14:03:35 -0500
Message-ID: <20170606190338.28347-23-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606190338.28347-1-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Today initiating a group stop with SIGSTOP, SIGTSTP, SIGTTIN, or
SIGTTOU and then have it contined with SIGCONT before the group stop
is complete results in SIGCHLD being sent with a si_status of 0.  The
field si_status is defined by posix to be the stop signal.  Which means
we wind up violating posix and any reasonable meaning of siginfo
delivered with SIGCHLD by reporting this partial group stop.

A partial group stop will result in even stranger things when seen in
the context of ptrace.  If all of the threads are ptraced they should
all enter a ptrace stop but the cancelation of the group stop before
the group stop completes results in only some of the threads entering
a ptrace stop.

Fix this by performing a delayed thread group wakeup that will take
effect as the last thread is signaling that the group stop is
complete.

This makes reasoning about the code much simpler, fixes partial
group stop interactions with ptrace, and the signal set for
a group stop that sees SIGCONT before it completes.  For
a similar cost in code.

I looked into the history to see if I could understand where this
problematic behavior came from, and the source of the behavior goes
back to the original development of thread groups in the kernel.  A
bug fix was made to improve the handling of SIGCONT that introduced
group_stop_count and the resuming of partial stops that makes no sense
today in the context of ptrace SIGSTOP handling.

At the time that was not a problem because stops when being ptraced
were in ordinary TASK_STOPPED stops.  It potentially became a problem
shortly thereafter when ptrace stops became TASK_TRACED stops which
can not be gotten out of with SIGCONT.  Howeve for it to actually
become a problem the code had to wait until recently when 5224fa3660ad
("ptrace: Make do_signal_stop() use ptrace_stop() if the task is being ptraced")
was merged for ptraced processes to stop with in TASK_TRACED when
they were ptraced.

The practical issue with sending an invalid si_status appears to have
been introduced much later after the locking changed to make it
necessary to send signals to the parent from the destination process
itself.  When Oleg unified partial and full stop handling
group_exit_code wound up being cleared on both code paths.  Not just
the for the full stop case.  That in turn introduced the invalid
si_status of 0.  As until that point group_exit_code always held the
signal when do_notify_parent_cldstop was called for stop signals.

Historical tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Fixes: 5224fa3660ad ("ptrace: Make do_signal_stop() use ptrace_stop() if the task is being ptraced")
Fixes: fc321d2e60d6 ("handle_stop_signal: unify partial/full stop handling")
Reference: e442055193e4 ("signals: re-assign CLD_CONTINUED notification from the sender to reciever")
Reference: cece79ae3a39 ("[PATCH] cleanup ptrace stops and remove notify_parent")
Reference: ca3f74aa7baa ("[PATCH] waitid system call")
Reference: ebf5ebe31d2c ("[PATCH] signal-fixes-2.5.59-A4")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/sched/signal.h | 26 +++++++------
 kernel/signal.c              | 89 ++++++++++++++++++++++++--------------------
 2 files changed, 63 insertions(+), 52 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 0cc626dd79a8..dac2d90217c2 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -227,21 +227,17 @@ struct signal_struct {
 /*
  * Bits in flags field of signal_struct.
  */
-#define SIGNAL_STOP_STOPPED	0x00000001 /* job control stop in effect */
-#define SIGNAL_STOP_CONTINUED	0x00000002 /* SIGCONT since WCONTINUED reap */
-#define SIGNAL_GROUP_EXIT	0x00000004 /* group exit in progress */
-#define SIGNAL_GROUP_COREDUMP	0x00000008 /* coredump in progress */
-/*
- * Pending notifications to parent.
- */
-#define SIGNAL_CLD_STOPPED	0x00000010
-#define SIGNAL_CLD_CONTINUED	0x00000020
-#define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
+#define SIGNAL_CLD_CONTINUED	0x00000001 /* Need to send SIGCONT to parent */
+#define SIGNAL_STOP_STOPPED	0x00000002 /* job control stop in effect */
+#define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
+#define SIGNAL_WAKEUP_PENDING	0x00000008 /* Wakeup for SIGCONT pending */
+#define SIGNAL_GROUP_EXIT	0x00000010 /* group exit in progress */
+#define SIGNAL_GROUP_COREDUMP	0x00000020 /* coredump in progress */
 
 #define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
 
-#define SIGNAL_STOP_MASK (SIGNAL_CLD_MASK | SIGNAL_STOP_STOPPED | \
-			  SIGNAL_STOP_CONTINUED)
+#define SIGNAL_STOP_MASK (SIGNAL_CLD_CONTINUED | SIGNAL_STOP_STOPPED | \
+			  SIGNAL_STOP_CONTINUED | SIGNAL_WAKEUP_PENDING)
 
 static inline void signal_set_stop_flags(struct signal_struct *sig,
 					 unsigned int flags)
@@ -250,6 +246,12 @@ static inline void signal_set_stop_flags(struct signal_struct *sig,
 	sig->flags = (sig->flags & ~SIGNAL_STOP_MASK) | flags;
 }
 
+static inline bool signal_delayed_wakeup(struct signal_struct *sig)
+{
+	return (sig->flags & (SIGNAL_STOP_STOPPED | SIGNAL_WAKEUP_PENDING)) ==
+		(SIGNAL_STOP_STOPPED | SIGNAL_WAKEUP_PENDING);
+}
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index 30d652f86964..0ec90689039a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -355,7 +355,8 @@ static bool task_participate_group_stop(struct task_struct *task)
 	 * fresh group stop.  Read comment in do_signal_stop() for details.
 	 */
 	if (!sig->group_stop_count && !(sig->flags & SIGNAL_STOP_STOPPED)) {
-		signal_set_stop_flags(sig, SIGNAL_STOP_STOPPED);
+		int old_flags = (sig->flags & SIGNAL_WAKEUP_PENDING);
+		signal_set_stop_flags(sig, SIGNAL_STOP_STOPPED | old_flags);
 		return true;
 	}
 	return false;
@@ -786,6 +787,14 @@ static void ptrace_trap_notify(struct task_struct *t)
 	ptrace_signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
 }
 
+static void wake_up_stopped_thread(struct task_struct *t)
+{
+	if (likely(!(t->ptrace & PT_SEIZED)))
+		wake_up_state(t, __TASK_STOPPED);
+	else
+		ptrace_trap_notify(t);
+}
+
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -817,7 +826,13 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 		for_each_thread(p, t)
 			flush_sigqueue_mask(&flush, &t->pending);
 	} else if (sig == SIGCONT) {
-		unsigned int why;
+		if (signal->group_stop_count) {
+			/* Let the stop complete before continuing.  This
+			 * ensures there are well definined interactions with
+			 * ptrace.
+			 */
+			signal->flags |= SIGNAL_WAKEUP_PENDING;
+		}
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
@@ -825,35 +840,21 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 		flush_sigqueue_mask(&flush, &signal->shared_pending);
 		for_each_thread(p, t) {
 			flush_sigqueue_mask(&flush, &t->pending);
+			if (signal->flags & SIGNAL_WAKEUP_PENDING)
+				continue;
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
-			if (likely(!(t->ptrace & PT_SEIZED)))
-				wake_up_state(t, __TASK_STOPPED);
-			else
-				ptrace_trap_notify(t);
+			wake_up_stopped_thread(t);
 		}
 
-		/*
-		 * Notify the parent with CLD_CONTINUED if we were stopped.
-		 *
-		 * If we were in the middle of a group stop, we pretend it
-		 * was already finished, and then continued. Since SIGCHLD
-		 * doesn't queue we report only CLD_STOPPED, as if the next
-		 * CLD_CONTINUED was dropped.
-		 */
-		why = 0;
-		if (signal->flags & SIGNAL_STOP_STOPPED)
-			why |= SIGNAL_CLD_CONTINUED;
-		else if (signal->group_stop_count)
-			why |= SIGNAL_CLD_STOPPED;
-
-		if (why) {
+		/* Notify the parent with CLD_CONTINUED if we were stopped. */
+		if (signal->flags & SIGNAL_STOP_STOPPED) {
 			/*
 			 * The first thread which returns from do_signal_stop()
-			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
-			 * notify its parent. See get_signal_to_deliver().
+			 * will take ->siglock, notice SIGNAL_CLD_CONTINUED, and
+			 * notify its parent. See get_signal().
 			 */
-			signal_set_stop_flags(signal, why | SIGNAL_STOP_CONTINUED);
-			signal->group_stop_count = 0;
+			signal_set_stop_flags(signal,
+				SIGNAL_STOP_CONTINUED | SIGNAL_CLD_CONTINUED);
 			signal->group_exit_code = 0;
 		}
 	}
@@ -1691,6 +1692,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 static void do_notify_parent_cldstop(struct task_struct *tsk,
 				     bool for_ptracer, int why)
 {
+	struct signal_struct *sig = tsk->signal;
 	struct siginfo info;
 	unsigned long flags;
 	struct task_struct *parent;
@@ -1724,7 +1726,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
  		info.si_status = SIGCONT;
  		break;
  	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		info.si_status = sig->group_exit_code & 0x7f;
  		break;
  	case CLD_TRAPPED:
  		info.si_status = tsk->exit_code & 0x7f;
@@ -1743,6 +1745,22 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	__wake_up_parent(tsk, parent);
 	spin_unlock_irqrestore(&sighand->siglock, flags);
+
+	/*
+	 * If there was a delayed SIGCONT process it now.
+	 */
+	spin_lock_irqsave(&tsk->sighand->siglock, flags);
+	if ((why == CLD_STOPPED) && signal_delayed_wakeup(sig)) {
+		struct task_struct *t;
+
+		for_each_thread(tsk, t)
+			wake_up_stopped_thread(t);
+
+		signal_set_stop_flags(sig,
+			SIGNAL_CLD_CONTINUED | SIGNAL_STOP_CONTINUED);
+		sig->group_exit_code = 0;
+	}
+	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 }
 
 static inline int may_ptrace_stop(void)
@@ -2166,19 +2184,10 @@ int get_signal(struct ksignal *ksig)
 	spin_lock_irq(&sighand->siglock);
 	/*
 	 * Every stopped thread goes here after wakeup. Check to see if
-	 * we should notify the parent, prepare_signal(SIGCONT) encodes
-	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
+	 * we should notify the parent.
 	 */
-	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		int why;
-
-		if (signal->flags & SIGNAL_CLD_CONTINUED)
-			why = CLD_CONTINUED;
-		else
-			why = CLD_STOPPED;
-
-		signal->flags &= ~SIGNAL_CLD_MASK;
-
+	if (unlikely(signal->flags & SIGNAL_CLD_CONTINUED)) {
+		signal->flags &= ~SIGNAL_CLD_CONTINUED;
 		spin_unlock_irq(&sighand->siglock);
 
 		/*
@@ -2190,11 +2199,11 @@ int get_signal(struct ksignal *ksig)
 		 * a duplicate.
 		 */
 		read_lock(&tasklist_lock);
-		do_notify_parent_cldstop(current, false, why);
+		do_notify_parent_cldstop(current, false, CLD_CONTINUED);
 
 		if (ptrace_reparented(current->group_leader))
 			do_notify_parent_cldstop(current->group_leader,
-						true, why);
+						 true, CLD_CONTINUED);
 		read_unlock(&tasklist_lock);
 
 		goto relock;
-- 
2.10.1
