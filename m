From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 08/26] exit: Make the runqueue rcu safe
Date: Tue,  6 Jun 2017 14:03:20 -0500
Message-ID: <20170606190338.28347-8-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Add a rcu_usage to task_struct and use it to reuse the delayed rcu put
logic from release_task in finish_task_switch.  This guarantees that
there will be an rcu interval before usage drops to zero for any task
on the run queue.  Making it safe to unconditionally call
get_task_struct in a rcu critical section for any task on the run
queue.

This guarantee in turn allows the fair scheduluer to use ordinary rcu
primitives to access tasks on the run queue and makes the magic functions
task_rcu_dereference and try_get_task_struct completely unnecessary.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/sched.h      |  1 +
 include/linux/sched/task.h |  4 +--
 kernel/exit.c              | 83 ++++------------------------------------------
 kernel/fork.c              |  3 +-
 kernel/sched/core.c        |  2 +-
 kernel/sched/fair.c        |  2 +-
 6 files changed, 12 insertions(+), 83 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b69fc650201..461ecd20731c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -492,6 +492,7 @@ struct task_struct {
 	volatile long			state;
 	void				*stack;
 	atomic_t			usage;
+	atomic_t			rcu_usage;
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index a978d7189cfd..dc4a4f4c566b 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -94,9 +94,7 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
-struct task_struct *task_rcu_dereference(struct task_struct **ptask);
-struct task_struct *try_get_task_struct(struct task_struct **ptask);
-
+extern void rcu_put_task_struct(struct task_struct *tsk);
 
 #ifdef CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT
 extern int arch_task_struct_size __read_mostly;
diff --git a/kernel/exit.c b/kernel/exit.c
index c3de7ace243c..625e57f1bb5c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -179,6 +179,11 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(tsk);
 }
 
+void rcu_put_task_struct(struct task_struct *tsk)
+{
+	if (atomic_dec_and_test(&tsk->rcu_usage))
+		call_rcu(&tsk->rcu, delayed_put_task_struct);
+}
 
 void release_task(struct task_struct *p)
 {
@@ -218,76 +223,13 @@ void release_task(struct task_struct *p)
 
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
-	call_rcu(&p->rcu, delayed_put_task_struct);
+	rcu_put_task_struct(p);
 
 	p = leader;
 	if (unlikely(zap_leader))
 		goto repeat;
 }
 
-/*
- * Note that if this function returns a valid task_struct pointer (!NULL)
- * task->usage must remain >0 for the duration of the RCU critical section.
- */
-struct task_struct *task_rcu_dereference(struct task_struct **ptask)
-{
-	struct sighand_struct *sighand;
-	struct task_struct *task;
-
-	/*
-	 * We need to verify that release_task() was not called and thus
-	 * delayed_put_task_struct() can't run and drop the last reference
-	 * before rcu_read_unlock(). We check task->sighand != NULL,
-	 * but we can read the already freed and reused memory.
-	 */
-retry:
-	task = rcu_dereference(*ptask);
-	if (!task)
-		return NULL;
-
-	probe_kernel_address(&task->sighand, sighand);
-
-	/*
-	 * Pairs with atomic_dec_and_test() in put_task_struct(). If this task
-	 * was already freed we can not miss the preceding update of this
-	 * pointer.
-	 */
-	smp_rmb();
-	if (unlikely(task != READ_ONCE(*ptask)))
-		goto retry;
-
-	/*
-	 * We've re-checked that "task == *ptask", now we have two different
-	 * cases:
-	 *
-	 * 1. This is actually the same task/task_struct. In this case
-	 *    sighand != NULL tells us it is still alive.
-	 *
-	 * 2. This is another task which got the same memory for task_struct.
-	 *    We can't know this of course, and we can not trust
-	 *    sighand != NULL.
-	 *
-	 *    In this case we actually return a random value, but this is
-	 *    correct.
-	 *
-	 *    If we return NULL - we can pretend that we actually noticed that
-	 *    *ptask was updated when the previous task has exited. Or pretend
-	 *    that probe_slab_address(&sighand) reads NULL.
-	 *
-	 *    If we return the new task (because sighand is not NULL for any
-	 *    reason) - this is fine too. This (new) task can't go away before
-	 *    another gp pass.
-	 *
-	 *    And note: We could even eliminate the false positive if re-read
-	 *    task->sighand once again to avoid the falsely NULL. But this case
-	 *    is very unlikely so we don't care.
-	 */
-	if (!sighand)
-		return NULL;
-
-	return task;
-}
-
 void rcuwait_wake_up(struct rcuwait *w)
 {
 	struct task_struct *task;
@@ -317,19 +259,6 @@ void rcuwait_wake_up(struct rcuwait *w)
 	rcu_read_unlock();
 }
 
-struct task_struct *try_get_task_struct(struct task_struct **ptask)
-{
-	struct task_struct *task;
-
-	rcu_read_lock();
-	task = task_rcu_dereference(ptask);
-	if (task)
-		get_task_struct(task);
-	rcu_read_unlock();
-
-	return task;
-}
-
 /*
  * Determine if a process group is "orphaned", according to the POSIX
  * definition in 2.2.2.52.  Orphaned process groups are not to be affected
diff --git a/kernel/fork.c b/kernel/fork.c
index aa1076c5e4a9..1fe837e8c38e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -567,7 +567,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	 * One for us, one for whoever does the "release_task()" (usually
 	 * parent)
 	 */
-	atomic_set(&tsk->usage, 2);
+	atomic_set(&tsk->rcu_usage, 2);
+	atomic_set(&tsk->usage, 1); /* For rcu_usage */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 803c3bc274c4..1fccfd397cab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2762,7 +2762,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 		/* Task is done with its stack. */
 		put_task_stack(prev);
 
-		put_task_struct(prev);
+		rcu_put_task_struct(prev);
 	}
 
 	tick_nohz_task_switch();
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d71109321841..5c0a1e1cc0f6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1527,7 +1527,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	int dist = env->dist;
 
 	rcu_read_lock();
-	cur = task_rcu_dereference(&dst_rq->curr);
+	cur = rcu_dereference(dst_rq->curr);
 	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
 		cur = NULL;
 
-- 
2.10.1
