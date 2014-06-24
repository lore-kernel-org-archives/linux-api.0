From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 13:48:07 -0700
Message-ID: <1403642893-23107-4-git-send-email-keescook@chromium.org>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1403642893-23107-1-git-send-email-keescook@chromium.org>
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
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
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
 kernel/fork.c           |   34 +++++++++++++++++++++++++++++++++-
 kernel/seccomp.c        |   18 +++++++++++++-----
 3 files changed, 49 insertions(+), 9 deletions(-)

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
index d2799d1fc952..d41bdc8700b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -315,6 +315,15 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto free_ti;
 
 	tsk->stack = ti;
+#ifdef CONFIG_SECCOMP
+	/*
+	 * We must handle setting up seccomp filters once we're under
+	 * the sighand lock in case orig has changed between now and
+	 * then. Until then, filter must be NULL to avoid messing up
+	 * the usage counts on the error path calling free_task.
+	 */
+	tsk->seccomp.filter = NULL;
+#endif
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1081,6 +1090,24 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
+static void copy_seccomp(struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Must be called with sighand->lock held, which is common to
+	 * all threads in the group. Regardless, nothing special is
+	 * needed for the child since it is not yet in the tasklist.
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
@@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	ftrace_graph_init_task(p);
-	get_seccomp_filter(p);
 
 	rt_mutex_init_task(p);
 
@@ -1437,6 +1463,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	spin_lock(&current->sighand->siglock);
 
 	/*
+	 * Copy seccomp details explicitly here, in case they were changed
+	 * before holding sighand lock.
+	 */
+	copy_seccomp(p);
+
+	/*
 	 * Process group and session signals need to be delivered to just the
 	 * parent before the fork or both the parent and the child after the
 	 * fork. Restart if a signal comes in before we add the new process to
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index edc8c79ed16d..405eb72dfe35 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -172,12 +172,12 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(int syscall)
 {
-	struct seccomp_filter *f;
+	struct seccomp_filter *f = smp_load_acquire(&current->seccomp.filter);
 	struct seccomp_data sd;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(current->seccomp.filter == NULL))
+	if (unlikely(WARN_ON(f == NULL)))
 		return SECCOMP_RET_KILL;
 
 	populate_seccomp_data(&sd);
@@ -186,7 +186,7 @@ static u32 seccomp_run_filters(int syscall)
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	for (f = current->seccomp.filter; f; f = f->prev) {
+	for (; f; f = f->prev) {
 		u32 cur_ret = SK_RUN_FILTER(f->prog, (void *)&sd);
 
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
@@ -312,6 +312,8 @@ out:
  * seccomp_attach_filter: validate and attach filter
  * @filter: seccomp filter to add to the current process
  *
+ * Caller must be holding current->sighand->siglock lock.
+ *
  * Returns 0 on success, -ve on error.
  */
 static long seccomp_attach_filter(struct seccomp_filter *filter)
@@ -319,6 +321,8 @@ static long seccomp_attach_filter(struct seccomp_filter *filter)
 	unsigned long total_insns;
 	struct seccomp_filter *walker;
 
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
 	/* Validate resulting filter length. */
 	total_insns = filter->prog->len;
 	for (walker = current->seccomp.filter; walker; walker = walker->prev)
@@ -331,7 +335,7 @@ static long seccomp_attach_filter(struct seccomp_filter *filter)
 	 * task reference.
 	 */
 	filter->prev = current->seccomp.filter;
-	current->seccomp.filter = filter;
+	smp_store_release(&current->seccomp.filter, filter);
 
 	return 0;
 }
@@ -357,7 +361,7 @@ static inline void seccomp_filter_free(struct seccomp_filter *filter)
 /* put_seccomp_filter - decrements the ref count of tsk->seccomp.filter */
 void put_seccomp_filter(struct task_struct *tsk)
 {
-	struct seccomp_filter *orig = tsk->seccomp.filter;
+	struct seccomp_filter *orig = smp_load_acquire(&tsk->seccomp.filter);
 	/* Clean up single-reference branches iteratively. */
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
@@ -513,6 +517,7 @@ long prctl_get_seccomp(void)
 static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	struct seccomp_filter *prepared = NULL;
+	unsigned long irqflags;
 	long ret = -EINVAL;
 
 #ifdef CONFIG_SECCOMP_FILTER
@@ -524,6 +529,8 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 	}
 #endif
 
+	spin_lock_irqsave(&current->sighand->siglock, irqflags);
+
 	if (current->seccomp.mode &&
 	    current->seccomp.mode != seccomp_mode)
 		goto out;
@@ -551,6 +558,7 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 	current->seccomp.mode = seccomp_mode;
 	set_thread_flag(TIF_SECCOMP);
 out:
+	spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	seccomp_filter_free(prepared);
 	return ret;
 }
-- 
1.7.9.5
