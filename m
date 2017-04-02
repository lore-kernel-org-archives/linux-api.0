From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH v2 4/5] exec: If possible don't wait for ptraced threads to be reaped
Date: Sun, 02 Apr 2017 17:53:52 -0500
Message-ID: <87efxa8lq7.fsf_-_@xmission.com>
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


Take advantage of the situation when sighand->count == 1 to only wait
for threads to reach EXIT_ZOMBIE instead of EXIT_DEAD in de_thread.
Only old old linux threading libraries use CLONE_SIGHAND without
CLONE_THREAD.  So this situation should be present most of the time.

This allows ptracing through a multi-threaded exec without the danger
of stalling the exec.  As historically exec waits for the other
threads to be reaped in de_thread before completing.  This is
necessary as it is not safe to unshare the sighand_struct until all of
the other threads in this thread group are reaped, because the lock to
serialize threads in a thread group siglock lives in sighand_struct.

When oldsighand->count == 1 we know that there are no other
users and unsharing the sighand struct in exec is pointless.
This makes it safe to only wait for threads to become zombies
as the siglock won't change during exec and release_task
will use the samve siglock for the old threads as for
the new threads.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/exec.c       | 22 ++--------------------
 kernel/exit.c   | 18 ++++++++----------
 kernel/signal.c |  2 +-
 3 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 65145a3df065..303a114b00ce 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1071,9 +1071,6 @@ static int de_thread(struct task_struct *tsk)
 
 	sig->group_exit_task = tsk;
 	sig->notify_count = zap_other_threads(tsk);
-	if (!thread_group_leader(tsk))
-		sig->notify_count--;
-
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
@@ -1092,23 +1089,8 @@ static int de_thread(struct task_struct *tsk)
 	if (!thread_group_leader(tsk)) {
 		struct task_struct *leader = tsk->group_leader;
 
-		for (;;) {
-			cgroup_threadgroup_change_begin(tsk);
-			write_lock_irq(&tasklist_lock);
-			/*
-			 * Do this under tasklist_lock to ensure that
-			 * exit_notify() can't miss ->group_exit_task
-			 */
-			sig->notify_count = -1;
-			if (likely(leader->exit_state))
-				break;
-			__set_current_state(TASK_KILLABLE);
-			write_unlock_irq(&tasklist_lock);
-			cgroup_threadgroup_change_end(tsk);
-			schedule();
-			if (unlikely(__fatal_signal_pending(tsk)))
-				goto killed;
-		}
+		cgroup_threadgroup_change_begin(tsk);
+		write_lock_irq(&tasklist_lock);
 
 		/*
 		 * The only record we have of the real-time age of a
diff --git a/kernel/exit.c b/kernel/exit.c
index 8c5b3e106298..955c96e3fc12 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -118,13 +118,6 @@ static void __exit_signal(struct task_struct *tsk)
 		tty = sig->tty;
 		sig->tty = NULL;
 	} else {
-		/*
-		 * If there is any task waiting for the group exit
-		 * then notify it:
-		 */
-		if (sig->notify_count > 0 && !--sig->notify_count)
-			wake_up_process(sig->group_exit_task);
-
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
 	}
@@ -712,6 +705,8 @@ static void forget_original_parent(struct task_struct *father,
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
+	struct sighand_struct *sighand = tsk->sighand;
+	struct signal_struct *signal = tsk->signal;
 	bool autoreap;
 	struct task_struct *p, *n;
 	LIST_HEAD(dead);
@@ -739,9 +734,12 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (tsk->exit_state == EXIT_DEAD)
 		list_add(&tsk->ptrace_entry, &dead);
 
-	/* mt-exec, de_thread() is waiting for group leader */
-	if (unlikely(tsk->signal->notify_count < 0))
-		wake_up_process(tsk->signal->group_exit_task);
+	spin_lock(&sighand->siglock);
+	/* mt-exec, de_thread is waiting for threads to exit */
+	if (signal->notify_count > 0 && !--signal->notify_count)
+		wake_up_process(signal->group_exit_task);
+
+	spin_unlock(&sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
diff --git a/kernel/signal.c b/kernel/signal.c
index 11fa736eb2ae..fd75ba33ee3d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1205,13 +1205,13 @@ int zap_other_threads(struct task_struct *p)
 
 	while_each_thread(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-		count++;
 
 		/* Don't bother with already dead threads */
 		if (t->exit_state)
 			continue;
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
+		count++;
 	}
 
 	return count;
-- 
2.10.1
