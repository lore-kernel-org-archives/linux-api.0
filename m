From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v10 09/11] seccomp: introduce writer locking
Date: Thu, 10 Jul 2014 11:40:29 -0700
Message-ID: <1405017631-27346-10-git-send-email-keescook@chromium.org>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1405017631-27346-1-git-send-email-keescook@chromium.org>
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
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
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
moved under the sighand lock. Then parent and child are certain have
the same seccomp state when they exit the lock.

Based on patches by Will Drewry and David Drysdale.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/seccomp.h |    6 +++---
 kernel/fork.c           |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/seccomp.c        |   16 +++++++++++++++-
 3 files changed, 62 insertions(+), 5 deletions(-)

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
index 6a13c46cd87d..ffc1b43e351f 100644
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
@@ -1081,6 +1090,35 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
+static void copy_seccomp(struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	/*
+	 * Must be called with sighand->lock held, which is common to
+	 * all threads in the group. Holding cred_guard_mutex is not
+	 * needed because this new task is not yet running and cannot
+	 * be racing exec.
+	 */
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	/* Ref-count the new filter user, and assign it. */
+	get_seccomp_filter(current);
+	p->seccomp = current->seccomp;
+
+	/*
+	 * Explicitly enable no_new_privs here in case it got set
+	 * between the task_struct being duplicated and holding the
+	 * sighand lock. The seccomp state and nnp must be in sync.
+	 */
+	if (task_no_new_privs(current))
+		task_set_no_new_privs(p);
+
+	/* If we have a seccomp mode, enable the thread flag. */
+	if (p->seccomp.mode != SECCOMP_MODE_DISABLED)
+		set_tsk_thread_flag(p, TIF_SECCOMP);
+#endif
+}
+
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1196,7 +1234,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	ftrace_graph_init_task(p);
-	get_seccomp_filter(p);
 
 	rt_mutex_init_task(p);
 
@@ -1437,6 +1474,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
index 502e54d7f86d..6087e018155c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -199,6 +199,8 @@ static u32 seccomp_run_filters(int syscall)
 
 static inline bool seccomp_check_mode(unsigned long seccomp_mode)
 {
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
 	if (current->seccomp.mode && current->seccomp.mode != seccomp_mode)
 		return false;
 
@@ -207,6 +209,8 @@ static inline bool seccomp_check_mode(unsigned long seccomp_mode)
 
 static inline void seccomp_assign_mode(unsigned long seccomp_mode)
 {
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
 	current->seccomp.mode = seccomp_mode;
 	set_tsk_thread_flag(current, TIF_SECCOMP);
 }
@@ -330,6 +334,8 @@ out:
  * @flags:  flags to change filter behavior
  * @filter: seccomp filter to add to the current process
  *
+ * Caller must be holding current->sighand->siglock lock.
+ *
  * Returns 0 on success, -ve on error.
  */
 static long seccomp_attach_filter(unsigned int flags,
@@ -338,6 +344,8 @@ static long seccomp_attach_filter(unsigned int flags,
 	unsigned long total_insns;
 	struct seccomp_filter *walker;
 
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
 	/* Validate resulting filter length. */
 	total_insns = filter->prog->len;
 	for (walker = current->seccomp.filter; walker; walker = walker->prev)
@@ -527,6 +535,8 @@ static long seccomp_set_mode_strict(void)
 	const unsigned long seccomp_mode = SECCOMP_MODE_STRICT;
 	long ret = -EINVAL;
 
+	spin_lock_irq(&current->sighand->siglock);
+
 	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
 
@@ -537,6 +547,7 @@ static long seccomp_set_mode_strict(void)
 	ret = 0;
 
 out:
+	spin_unlock_irq(&current->sighand->siglock);
 
 	return ret;
 }
@@ -564,13 +575,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
 
 	/* Validate flags. */
 	if (flags != 0)
-		goto out;
+		return -EINVAL;
 
 	/* Prepare the new filter before holding any locks. */
 	prepared = seccomp_prepare_user_filter(filter);
 	if (IS_ERR(prepared))
 		return PTR_ERR(prepared);
 
+	spin_lock_irq(&current->sighand->siglock);
+
 	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
 
@@ -582,6 +595,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 
 	seccomp_assign_mode(seccomp_mode);
 out:
+	spin_unlock_irq(&current->sighand->siglock);
 	seccomp_filter_free(prepared);
 	return ret;
 }
-- 
1.7.9.5
