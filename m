From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH] exec: Don't wait for ptraced threads to be reaped.
Date: Fri, 03 Mar 2017 14:11:16 -0600
Message-ID: <87lgsmunmj.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87tw7aunuh.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Fri, 03 Mar 2017 14:06:30 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Ever since CLONE_THREAD support was added to the kernel it has been
possible to dead-lock userspace by ptracing a process and not reaping
it's child threads.  With use of the cred_guard_mutex in proc the ways
userspace can unknowningly trigger a dead-lock have grown.  Which makes
a simple -f strace on a program that performs a mult-threaded exec
unsafe.

        #include <unistd.h>
        #include <signal.h>
        #include <sys/ptrace.h>
        #include <pthread.h>

        void *thread(void *arg)
        {
                ptrace(PTRACE_TRACEME, 0,0,0);
                return NULL;
        }

        int main(void)
        {
                int pid = fork();

                if (!pid) {
                        pthread_t pt;
                        pthread_create(&pt, NULL, thread, NULL);
                        pthread_join(pt, NULL);
                        execlp("echo", "echo", "passed", NULL);
                }

                sleep(1);
                // or anything else which needs ->cred_guard_mutex,
                // say open(/proc/$pid/mem)
                ptrace(PTRACE_ATTACH, pid, 0,0);
                kill(pid, SIGCONT);

                return 0;
        }

Sovle this by modifying exec to only wait until all of the other
threads are zombies, and not waiting until the other threads
are reaped.

As well as simplifying the userspace semantics this simplifies
the code.

Reported-by: Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>
Reported-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Fixes: v2.4.0
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/exec.c             | 31 +++++--------------------------
 include/linux/sched.h |  5 ++---
 kernel/exit.c         | 18 +++++-------------
 kernel/signal.c       |  6 +-----
 4 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 698a86094f76..f78205a72304 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1065,11 +1065,8 @@ static int de_thread(struct task_struct *tsk)
 	}
 
 	sig->group_exit_task = tsk;
-	sig->notify_count = zap_other_threads(tsk);
-	if (!thread_group_leader(tsk))
-		sig->notify_count--;
-
-	while (sig->notify_count) {
+	zap_other_threads(tsk);
+	while (atomic_read(&sig->live) > 1) {
 		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
 		schedule();
@@ -1081,29 +1078,13 @@ static int de_thread(struct task_struct *tsk)
 
 	/*
 	 * At this point all other threads have exited, all we have to
-	 * do is to wait for the thread group leader to become inactive,
-	 * and to assume its PID:
+	 * do is to assume the PID of the thread group leader.
 	 */
 	if (!thread_group_leader(tsk)) {
 		struct task_struct *leader = tsk->group_leader;
 
-		for (;;) {
-			threadgroup_change_begin(tsk);
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
-			threadgroup_change_end(tsk);
-			schedule();
-			if (unlikely(__fatal_signal_pending(tsk)))
-				goto killed;
-		}
+		threadgroup_change_begin(tsk);
+		write_lock_irq(&tasklist_lock);
 
 		/*
 		 * The only record we have of the real-time age of a
@@ -1163,7 +1144,6 @@ static int de_thread(struct task_struct *tsk)
 	}
 
 	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
 
 no_thread_group:
 	/* we have changed execution domain */
@@ -1204,7 +1184,6 @@ static int de_thread(struct task_struct *tsk)
 	/* protects against exit_notify() and __exit_signal() */
 	read_lock(&tasklist_lock);
 	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
 	read_unlock(&tasklist_lock);
 	return -EAGAIN;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6261bfc12853..ff6aa76beac5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -711,11 +711,10 @@ struct signal_struct {
 	/* thread group exit support */
 	int			group_exit_code;
 	/* overloaded:
-	 * - notify group_exit_task when ->count is equal to notify_count
+	 * - notify group_exit_task when ->live is equal to 1
 	 * - everyone except group_exit_task is stopped during signal delivery
 	 *   of fatal signals, group_exit_task processes the signal.
 	 */
-	int			notify_count;
 	struct task_struct	*group_exit_task;
 
 	/* thread group stop support, overloads group_exit_code too */
@@ -2763,7 +2762,7 @@ extern __must_check bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
-extern int zap_other_threads(struct task_struct *p);
+extern void zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
diff --git a/kernel/exit.c b/kernel/exit.c
index 5cfbd595f918..dc9bc2bdb45a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -111,13 +111,6 @@ static void __exit_signal(struct task_struct *tsk)
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
@@ -701,10 +694,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
 	if (tsk->exit_state == EXIT_DEAD)
 		list_add(&tsk->ptrace_entry, &dead);
-
-	/* mt-exec, de_thread() is waiting for group leader */
-	if (unlikely(tsk->signal->notify_count < 0))
-		wake_up_process(tsk->signal->group_exit_task);
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
@@ -740,7 +729,7 @@ static inline void check_stack_usage(void) {}
 void __noreturn do_exit(long code)
 {
 	struct task_struct *tsk = current;
-	int group_dead;
+	int group_left, group_dead;
 	TASKS_RCU(int tasks_rcu_i);
 
 	profile_task_exit(tsk);
@@ -809,7 +798,8 @@ void __noreturn do_exit(long code)
 	if (tsk->mm)
 		sync_mm_rss(tsk->mm);
 	acct_update_integrals(tsk);
-	group_dead = atomic_dec_and_test(&tsk->signal->live);
+	group_left = atomic_dec_return(&tsk->signal->live);
+	group_dead = group_left == 0;
 	if (group_dead) {
 #ifdef CONFIG_POSIX_TIMERS
 		hrtimer_cancel(&tsk->signal->real_timer);
@@ -818,6 +808,8 @@ void __noreturn do_exit(long code)
 		if (tsk->mm)
 			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
 	}
+	if ((group_left == 1) && tsk->signal->group_exit_task)
+		wake_up_process(tsk->signal->group_exit_task);
 	acct_collect(code, group_dead);
 	if (group_dead)
 		tty_audit_exit();
diff --git a/kernel/signal.c b/kernel/signal.c
index fbbab5a7c84d..17312c71f1ae 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1191,16 +1191,14 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 /*
  * Nuke all other threads in the group.
  */
-int zap_other_threads(struct task_struct *p)
+void zap_other_threads(struct task_struct *p)
 {
 	struct task_struct *t = p;
-	int count = 0;
 
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-		count++;
 
 		/* Don't bother with already dead threads */
 		if (t->exit_state)
@@ -1208,8 +1206,6 @@ int zap_other_threads(struct task_struct *p)
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
 	}
-
-	return count;
 }
 
 struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
-- 
2.10.1
