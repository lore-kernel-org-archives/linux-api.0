From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v9 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Fri, 27 Jun 2014 16:23:00 -0700
Message-ID: <1403911380-27787-12-git-send-email-keescook@chromium.org>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1403911380-27787-1-git-send-email-keescook@chromium.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <dborkman@redhat.com>, Julien Tinnes <jln@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Drysdale <drysdale@google.com>, linux-arm-kernel@lists.infradead.org, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

Applying restrictive seccomp filter programs to large or diverse
codebases often requires handling threads which may be started early in
the process lifetime (e.g., by code that is linked in). While it is
possible to apply permissive programs prior to process start up, it is
difficult to further restrict the kernel ABI to those threads after that
point.

This change adds a new seccomp syscall flag to SECCOMP_SET_MODE_FILTER for
synchronizing thread group seccomp filters at filter installation time.

When calling seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
filter) an attempt will be made to synchronize all threads in current's
threadgroup to its new seccomp filter program. This is possible iff all
threads are using a filter that is an ancestor to the filter current is
attempting to synchronize to. NULL filters (where the task is running as
SECCOMP_MODE_NONE) are also treated as ancestors allowing threads to be
transitioned into SECCOMP_MODE_FILTER. If prctrl(PR_SET_NO_NEW_PRIVS,
...) has been set on the calling thread, no_new_privs will be set for
all synchronized threads too. On success, 0 is returned. On failure,
the pid of one of the failing threads will be returned and no filters
will have been applied.

The race conditions against another thread are:
- requesting TSYNC (already handled by sighand lock)
- performing a clone (already handled by sighand lock)
- changing its filter (already handled by sighand lock)
- calling exec (handled by cred_guard_mutex)
The clone case is assisted by the fact that new threads will have their
seccomp state duplicated from their parent before appearing on the tasklist.

Holding cred_guard_mutex means that seccomp filters cannot be assigned
while in the middle of another thread's exec (potentially bypassing
no_new_privs or similar). To make sure that de_thread() is actually able
to kill other threads during an exec, any sighand holders need to check
if they've been scheduled to be killed, and to give up on their work.

Based on patches by Will Drewry.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c                    |    2 +-
 include/linux/seccomp.h      |    2 +
 include/uapi/linux/seccomp.h |    3 +
 kernel/seccomp.c             |  139 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0f5c272410f6..ab1f1200ce5d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1216,7 +1216,7 @@ EXPORT_SYMBOL(install_exec_creds);
 /*
  * determine how safe it is to execute the proposed program
  * - the caller must hold ->cred_guard_mutex to protect against
- *   PTRACE_ATTACH
+ *   PTRACE_ATTACH or seccomp thread-sync
  */
 static void check_unsafe_exec(struct linux_binprm *bprm)
 {
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 9ff98b4bfe2e..15de2a711518 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -3,6 +3,8 @@
 
 #include <uapi/linux/seccomp.h>
 
+#define SECCOMP_FILTER_FLAG_MASK	~(SECCOMP_FILTER_FLAG_TSYNC)
+
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index b258878ba754..0f238a43ff1e 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -14,6 +14,9 @@
 #define SECCOMP_SET_MODE_STRICT	0
 #define SECCOMP_SET_MODE_FILTER	1
 
+/* Valid flags for SECCOMP_SET_MODE_FILTER */
+#define SECCOMP_FILTER_FLAG_TSYNC	1
+
 /*
  * All BPF programs must return a 32-bit value.
  * The bottom 16-bits are for optional return data.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 7bbcb9ed16df..0a82e16da7ef 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -26,6 +26,7 @@
 #ifdef CONFIG_SECCOMP_FILTER
 #include <asm/syscall.h>
 #include <linux/filter.h>
+#include <linux/pid.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/tracehook.h>
@@ -222,6 +223,108 @@ static inline void seccomp_assign_mode(struct task_struct *task,
 }
 
 #ifdef CONFIG_SECCOMP_FILTER
+/* Returns 1 if the candidate is an ancestor. */
+static int is_ancestor(struct seccomp_filter *candidate,
+		       struct seccomp_filter *child)
+{
+	/* NULL is the root ancestor. */
+	if (candidate == NULL)
+		return 1;
+	for (; child; child = child->prev)
+		if (child == candidate)
+			return 1;
+	return 0;
+}
+
+/**
+ * seccomp_can_sync_threads: checks if all threads can be synchronized
+ *
+ * Expects sighand and cred_guard_mutex locks to be held.
+ *
+ * Returns 0 on success, -ve on error, or the pid of a thread which was
+ * either not in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter.
+ */
+static inline pid_t seccomp_can_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
+	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
+		return -EACCES;
+
+	/* Validate all threads being eligible for synchronization. */
+	caller = current;
+	for_each_thread(caller, thread) {
+		pid_t failed;
+
+		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
+		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
+		     is_ancestor(thread->seccomp.filter,
+				 caller->seccomp.filter)))
+			continue;
+
+		/* Return the first thread that cannot be synchronized. */
+		failed = task_pid_vnr(thread);
+		/* If the pid cannot be resolved, then return -ESRCH */
+		if (unlikely(WARN_ON(failed == 0)))
+			failed = -ESRCH;
+		return failed;
+	}
+
+	return 0;
+}
+
+/**
+ * seccomp_sync_threads: sets all threads to use current's filter
+ *
+ * Expects sighand and cred_guard_mutex locks to be held, and for
+ * seccomp_can_sync_threads() to have returned success already
+ * without dropping the locks.
+ *
+ */
+static inline void seccomp_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
+	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	/* Synchronize all threads. */
+	caller = current;
+	for_each_thread(caller, thread) {
+		/* Get a task reference for the new leaf node. */
+		get_seccomp_filter(caller);
+		/*
+		 * Drop the task reference to the shared ancestor since
+		 * current's path will hold a reference.  (This also
+		 * allows a put before the assignment.)
+		 */
+		put_seccomp_filter(thread);
+		thread->seccomp.filter = caller->seccomp.filter;
+		/*
+		 * Opt the other thread into seccomp if needed.
+		 * As threads are considered to be trust-realm
+		 * equivalent (see ptrace_may_access), it is safe to
+		 * allow one thread to transition the other.
+		 */
+		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
+			/*
+			 * Don't let an unprivileged task work around
+			 * the no_new_privs restriction by creating
+			 * a thread that sets it up, enters seccomp,
+			 * then dies.
+			 */
+			if (task_no_new_privs(caller))
+				task_set_no_new_privs(thread);
+
+			seccomp_assign_mode(thread, SECCOMP_MODE_FILTER);
+		}
+	}
+}
+
 /**
  * seccomp_prepare_filter: Prepares a seccomp filter for use.
  * @fprog: BPF program to install
@@ -359,6 +462,15 @@ static long seccomp_attach_filter(unsigned int flags,
 	if (total_insns > MAX_INSNS_PER_PATH)
 		return -ENOMEM;
 
+	/* If thread sync has been requested, check that it is possible. */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
+		int ret;
+
+		ret = seccomp_can_sync_threads();
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -366,6 +478,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	filter->prev = current->seccomp.filter;
 	smp_store_release(&current->seccomp.filter, filter);
 
+	/* Now that the new filter is in place, synchronize to all threads. */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		seccomp_sync_threads();
+
 	return 0;
 }
 
@@ -547,6 +663,11 @@ static long seccomp_set_mode_strict(void)
 	long ret = -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
+	if (unlikely(signal_group_exit(current->signal))) {
+		/* If thread is dying, return to process the signal. */
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
@@ -585,7 +706,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	long ret = -EINVAL;
 
 	/* Validate flags. */
-	if (flags != 0)
+	if (flags & SECCOMP_FILTER_FLAG_MASK)
 		return -EINVAL;
 
 	/* Prepare the new filter before holding any locks. */
@@ -593,7 +714,20 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	if (IS_ERR(prepared))
 		return PTR_ERR(prepared);
 
+	/*
+	 * Make sure we cannot change seccomp or nnp state via TSYNC
+	 * while another thread is in the middle of calling exec.
+	 */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
+	    mutex_lock_killable(&current->signal->cred_guard_mutex))
+		goto out_free;
+
 	spin_lock_irq(&current->sighand->siglock);
+	if (unlikely(signal_group_exit(current->signal))) {
+		/* If thread is dying, return to process the signal. */
+		ret = -EAGAIN;
+		goto out;
+	}
 
 	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
@@ -607,6 +741,9 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	seccomp_assign_mode(current, seccomp_mode);
 out:
 	spin_unlock_irq(&current->sighand->siglock);
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		mutex_unlock(&current->signal->cred_guard_mutex);
+out_free:
 	seccomp_filter_free(prepared);
 	return ret;
 }
-- 
1.7.9.5
