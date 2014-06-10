From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 3/9] seccomp: introduce writer locking
Date: Tue, 10 Jun 2014 16:01:48 -0700
Message-ID: <1402441314-7447-4-git-send-email-keescook@chromium.org>
References: <1402441314-7447-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1402441314-7447-1-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Alexei Starovoitov <ast@plumgrid.com>, John Johansen <john.johansen@canonical.com>, Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Frederic Weisbecker <fweisbec@gmail.com>, "David A. Long" <dave.long@lina>
List-Id: linux-api@vger.kernel.org

Normally, task_struct.seccomp.filter is only ever read or modified by
the task that owns it (current). This property aids in fast access
during system call filtering as read access is lockless.

Updating the pointer from another task, however, opens up race
conditions. To allow cross-thread filter pointer updates, writes to
the seccomp fields are now protected by the sighand spinlock (which
is unique to the thread group). Read access remains lockless because
pointer updates themselves are atomic.  However, writes (or cloning)
often entail additional checking (like maximum instruction counts)
which require locking to perform safely.

In the case of cloning threads, the child is invisible to the system
until it enters the task list. To make sure a child can't be cloned from
a thread and left in a prior state, seccomp duplication is additionally
moved under the tasklist_lock. Then parent and child are certain have
the same seccomp state when they exit the lock.

Based on patches by Will Drewry and David Drysdale.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/seccomp.h |    6 +++---
 kernel/fork.c           |   40 ++++++++++++++++++++++++++++++++++++----
 kernel/seccomp.c        |   22 ++++++++++++++++------
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 4054b0994071..9ff98b4bfe2e 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -14,11 +14,11 @@ struct seccomp_filter;
  *
  * @mode:  indicates one of the valid values above for controlled
  *         system calls available to a process.
- * @filter: The metadata and ruleset for determining what system calls
- *          are allowed for a task.
+ * @filter: must always point to a valid seccomp-filter or NULL as it is
+ *          accessed without locking during system call entry.
  *
  *          @filter must only be accessed from the context of current as there
- *          is no locking.
+ *          is no read locking.
  */
 struct seccomp {
 	int mode;
diff --git a/kernel/fork.c b/kernel/fork.c
index d2799d1fc952..6b2a9add1079 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -315,6 +315,15 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto free_ti;
 
 	tsk->stack = ti;
+#ifdef CONFIG_SECCOMP
+	/*
+	 * We must handle setting up seccomp filters once we're under
+	 * the tasklist_lock in case orig has changed between now and
+	 * then. Until then, filter must be NULL to avoid messing up
+	 * the usage counts on the error path calling free_task.
+	 */
+	tsk->seccomp.filter = NULL;
+#endif
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1081,6 +1090,23 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
+static void copy_seccomp(struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Must be called with sighand->lock held. Child lock not needed
+	 * since it is not yet in tasklist.
+	 */
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	get_seccomp_filter(current);
+	p->seccomp = current->seccomp;
+
+	if (p->seccomp.mode != SECCOMP_MODE_DISABLED)
+		set_tsk_thread_flag(p, TIF_SECCOMP);
+#endif
+}
+
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1142,6 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	unsigned long irqflags;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	ftrace_graph_init_task(p);
-	get_seccomp_filter(p);
 
 	rt_mutex_init_task(p);
 
@@ -1434,7 +1460,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->parent_exec_id = current->self_exec_id;
 	}
 
-	spin_lock(&current->sighand->siglock);
+	spin_lock_irqsave(&current->sighand->siglock, irqflags);
+
+	/*
+	 * Copy seccomp details explicitly here, in case they were changed
+	 * before holding tasklist_lock.
+	 */
+	copy_seccomp(p);
 
 	/*
 	 * Process group and session signals need to be delivered to just the
@@ -1446,7 +1478,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	*/
 	recalc_sigpending();
 	if (signal_pending(current)) {
-		spin_unlock(&current->sighand->siglock);
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
 		goto bad_fork_free_pid;
@@ -1486,7 +1518,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	}
 
 	total_forks++;
-	spin_unlock(&current->sighand->siglock);
+	spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 7a9257ddd69c..33655302b658 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -174,12 +174,12 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(int syscall)
 {
-	struct seccomp_filter *f;
+	struct seccomp_filter *f = smp_load_acquire(&current->seccomp.filter);
 	struct seccomp_data sd;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(current->seccomp.filter == NULL))
+	if (WARN_ON(f == NULL))
 		return SECCOMP_RET_KILL;
 
 	populate_seccomp_data(&sd);
@@ -188,7 +188,7 @@ static u32 seccomp_run_filters(int syscall)
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	for (f = current->seccomp.filter; f; f = f->prev) {
+	for (; f; f = smp_load_acquire(&f->prev)) {
 		u32 cur_ret = sk_run_filter_int_seccomp(&sd, f->insnsi);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
@@ -305,6 +305,8 @@ out:
  * seccomp_attach_filter: validate and attach filter
  * @filter: seccomp filter to add to the current process
  *
+ * Caller must be holding current->sighand->siglock lock.
+ *
  * Returns 0 on success, -ve on error.
  */
 static long seccomp_attach_filter(struct seccomp_filter *filter)
@@ -312,6 +314,8 @@ static long seccomp_attach_filter(struct seccomp_filter *filter)
 	unsigned long total_insns;
 	struct seccomp_filter *walker;
 
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
 	/* Validate resulting filter length. */
 	total_insns = filter->len;
 	for (walker = current->seccomp.filter; walker; walker = filter->prev)
@@ -324,7 +328,7 @@ static long seccomp_attach_filter(struct seccomp_filter *filter)
 	 * task reference.
 	 */
 	filter->prev = current->seccomp.filter;
-	current->seccomp.filter = filter;
+	smp_store_release(&current->seccomp.filter, filter);
 
 	return 0;
 }
@@ -332,7 +336,7 @@ static long seccomp_attach_filter(struct seccomp_filter *filter)
 /* get_seccomp_filter - increments the reference count of the filter on @tsk */
 void get_seccomp_filter(struct task_struct *tsk)
 {
-	struct seccomp_filter *orig = tsk->seccomp.filter;
+	struct seccomp_filter *orig = smp_load_acquire(&tsk->seccomp.filter);
 	if (!orig)
 		return;
 	/* Reference count is bounded by the number of total processes. */
@@ -346,7 +350,7 @@ void put_seccomp_filter(struct task_struct *tsk)
 	/* Clean up single-reference branches iteratively. */
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
-		orig = orig->prev;
+		orig = smp_load_acquire(&orig->prev);
 		kfree(freeme);
 	}
 }
@@ -498,6 +502,7 @@ long prctl_get_seccomp(void)
 static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	struct seccomp_filter *prepared = NULL;
+	unsigned long irqflags;
 	long ret = -EINVAL;
 
 #ifdef CONFIG_SECCOMP_FILTER
@@ -509,6 +514,9 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 	}
 #endif
 
+	if (unlikely(!lock_task_sighand(current, &irqflags)))
+		goto out_free;
+
 	if (current->seccomp.mode &&
 	    current->seccomp.mode != seccomp_mode)
 		goto out;
@@ -536,6 +544,8 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 	current->seccomp.mode = seccomp_mode;
 	set_thread_flag(TIF_SECCOMP);
 out:
+	unlock_task_sighand(current, &irqflags);
+out_free:
 	kfree(prepared);
 	return ret;
 }
-- 
1.7.9.5
