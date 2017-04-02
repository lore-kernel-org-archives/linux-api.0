From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH v2 5/5] signal: Don't allow accessing signal_struct by old threads after exec
Date: Sun, 02 Apr 2017 17:57:46 -0500
Message-ID: <87zify76z9.fsf_-_@xmission.com>
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


Add exec_id to signal_struct and compare it at a few choice moments.

I believe this closes the security holes that letting the zombie
threads linger after exec opens up.

The problem is that old threads may have different creds after a setuid
exec, and then formerly shared resources may change.  So signal sending
and accesses by proc need to be blocked.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/exec.c                    | 1 +
 include/linux/sched/signal.h | 1 +
 kernel/fork.c                | 1 +
 kernel/ptrace.c              | 4 ++++
 kernel/signal.c              | 7 ++++++-
 5 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 303a114b00ce..730dee8bb2f8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1323,6 +1323,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 	current->self_exec_id++;
+	current->signal->exec_id = current->self_exec_id;
 	flush_signal_handlers(current, 0);
 }
 EXPORT_SYMBOL(setup_new_exec);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 2cf446704cd4..63ae951ee330 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -80,6 +80,7 @@ struct signal_struct {
 	atomic_t		live;
 	int			nr_threads;
 	struct list_head	thread_head;
+	u32			exec_id;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 0632ac1180be..a442fa099842 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1387,6 +1387,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
+	sig->exec_id = current->self_exec_id;
 
 	mutex_init(&sig->cred_guard_mutex);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0af928712174..cc6b10b1ffbe 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -277,6 +277,10 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 * or halting the specified task is impossible.
 	 */
 
+	/* Don't allow inspecting a thread after exec */
+	if (task->self_exec_id != task->signal->exec_id)
+		return 1;
+
 	/* Don't let security modules deny introspection */
 	if (same_thread_group(task, current))
 		return 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index fd75ba33ee3d..fe8dcdb622f5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -995,6 +995,10 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		goto ret;
 
+	/* Don't allow thread group signals after exec */
+	if (group && (t->signal->exec_id != t->self_exec_id))
+		goto ret;
+
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
 	 * Short-circuit ignored signals and support queuing
@@ -1247,7 +1251,8 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 		 * must see ->sighand == NULL.
 		 */
 		spin_lock(&sighand->siglock);
-		if (likely(sighand == tsk->sighand)) {
+		if (likely((sighand == tsk->sighand) &&
+			   (tsk->self_exec_id == tsk->signal->exec_id))) {
 			rcu_read_unlock();
 			break;
 		}
-- 
2.10.1
