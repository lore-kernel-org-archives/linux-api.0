From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Mon, 23 Jun 2014 14:58:11 -0700
Message-ID: <1403560693-21809-8-git-send-email-keescook@chromium.org>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1403560693-21809-1-git-send-email-keescook@chromium.org>
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

The race conditions are against another thread requesting TSYNC, another
thread performing a clone, and another thread changing its filter. The
sighand lock is sufficient for these cases, though the clone case is
assisted by the tasklist_lock so that new threads must have a duplicate
of its parent seccomp state when it appears on the tasklist.

Based on patches by Will Drewry.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                 |    1 +
 include/linux/seccomp.h      |    2 +
 include/uapi/linux/seccomp.h |    3 +
 kernel/seccomp.c             |  135 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 97ff872c7acc..0eae9df35b88 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -321,6 +321,7 @@ config HAVE_ARCH_SECCOMP_FILTER
 	  - secure_computing is called from a ptrace_event()-safe context
 	  - secure_computing return value is checked and a return value of -1
 	    results in the system call being skipped immediately.
+	  - seccomp syscall wired up
 
 config SECCOMP_FILTER
 	def_bool y
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 6a5e2d0ec912..e1ae50f7cb0b 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -5,6 +5,8 @@
 
 #define SECCOMP_FLAG_NO_NEW_PRIVS	0	/* task may not gain privs */
 
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
index a0db770ff26c..ed3a4453c054 100644
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
@@ -217,6 +218,107 @@ static inline void seccomp_assign_mode(struct task_struct *task,
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
+ * Expects both tasklist_lock and current->sighand->siglock to be held.
+ *
+ * Returns 0 on success, -ve on error, or the pid of a thread which was
+ * either not in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter.
+ */
+static pid_t seccomp_can_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
+	BUG_ON(write_can_lock(&tasklist_lock));
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
+		return -EACCES;
+
+	/* Validate all threads being eligible for synchronization. */
+	thread = caller = current;
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
+		if (failed == 0)
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
+ * Expects both tasklist_lock and current->sighand->siglock to be held,
+ * and for seccomp_can_sync_threads() to have returned success already
+ * without dropping the locks.
+ *
+ */
+static void seccomp_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
+	BUG_ON(write_can_lock(&tasklist_lock));
+	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+
+	/* Synchronize all threads. */
+	thread = caller = current;
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
+		/* Opt the other thread into seccomp if needed.
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
@@ -348,7 +450,7 @@ static long seccomp_attach_filter(unsigned int flags,
 	BUG_ON(!spin_is_locked(&current->sighand->siglock));
 
 	/* Validate flags. */
-	if (flags != 0)
+	if (flags & SECCOMP_FILTER_FLAG_MASK)
 		return -EINVAL;
 
 	/* Validate resulting filter length. */
@@ -358,6 +460,15 @@ static long seccomp_attach_filter(unsigned int flags,
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
@@ -365,6 +476,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	filter->prev = current->seccomp.filter;
 	smp_store_release(&current->seccomp.filter, filter);
 
+	/* Now that the new filter is in place, synchronize to all threads. */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		seccomp_sync_threads();
+
 	return 0;
 }
 
@@ -578,7 +693,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 {
 	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
 	struct seccomp_filter *prepared = NULL;
-	unsigned long irqflags;
+	unsigned long irqflags, taskflags;
 	long ret = -EINVAL;
 
 	/* Prepare the new filter outside of any locking. */
@@ -586,6 +701,17 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	if (IS_ERR(prepared))
 		return PTR_ERR(prepared);
 
+	/*
+	 * If we're doing thread sync, we must hold tasklist_lock
+	 * to make sure seccomp filter changes are stable on threads
+	 * entering or leaving the task list. And we must take it
+	 * before the sighand lock to avoid deadlocking.
+	 */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		write_lock_irqsave(&tasklist_lock, taskflags);
+	else
+		__acquire(&tasklist_lock); /* keep sparse happy */
+
 	if (unlikely(!lock_task_sighand(current, &irqflags)))
 		goto out_free;
 
@@ -602,6 +728,11 @@ static long seccomp_set_mode_filter(unsigned int flags,
 out:
 	unlock_task_sighand(current, &irqflags);
 out_free:
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		write_unlock_irqrestore(&tasklist_lock, taskflags);
+	else
+		__release(&tasklist_lock); /* keep sparse happy */
+
 	seccomp_filter_free(prepared);
 	return ret;
 }
-- 
1.7.9.5
