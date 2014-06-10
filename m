From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 10 Jun 2014 16:01:52 -0700
Message-ID: <1402441314-7447-8-git-send-email-keescook@chromium.org>
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
 include/uapi/linux/seccomp.h |    4 ++
 kernel/seccomp.c             |  135 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 138 insertions(+), 2 deletions(-)

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
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index b258878ba754..3e651f757b48 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -14,6 +14,10 @@
 #define SECCOMP_SET_MODE_STRICT	0
 #define SECCOMP_SET_MODE_FILTER	1
 
+/* Valid flags for SECCOMP_SET_MODE_FILTER */
+#define SECCOMP_FILTER_FLAG_TSYNC	1
+#define SECCOMP_FILTER_FLAG_MASK	~(SECCOMP_FILTER_FLAG_TSYNC)
+
 /*
  * All BPF programs must return a 32-bit value.
  * The bottom 16-bits are for optional return data.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index c0cafa9e84af..d03d470ca36b 100644
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
@@ -219,6 +220,107 @@ static inline void seccomp_assign_mode(struct task_struct *task,
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
@@ -342,7 +444,7 @@ static long seccomp_attach_filter(unsigned int flags,
 	BUG_ON(!spin_is_locked(&current->sighand->siglock));
 
 	/* Validate flags. */
-	if (flags != 0)
+	if (flags & SECCOMP_FILTER_FLAG_MASK)
 		return -EINVAL;
 
 	/* Validate resulting filter length. */
@@ -352,6 +454,15 @@ static long seccomp_attach_filter(unsigned int flags,
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
@@ -359,6 +470,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	filter->prev = current->seccomp.filter;
 	smp_store_release(&current->seccomp.filter, filter);
 
+	/* Now that the new filter is in place, synchronize to all threads. */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		seccomp_sync_threads();
+
 	return 0;
 }
 
@@ -564,7 +679,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 {
 	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
 	struct seccomp_filter *prepared = NULL;
-	unsigned long irqflags;
+	unsigned long irqflags, taskflags;
 	long ret = -EINVAL;
 
 	/* Prepare the new filter outside of any locking. */
@@ -572,6 +687,17 @@ static long seccomp_set_mode_filter(unsigned int flags,
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
 
@@ -588,6 +714,11 @@ static long seccomp_set_mode_filter(unsigned int flags,
 out:
 	unlock_task_sighand(current, &irqflags);
 out_free:
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		write_unlock_irqrestore(&tasklist_lock, taskflags);
+	else
+		__release(&tasklist_lock); /* keep sparse happy */
+
 	kfree(prepared);
 	return ret;
 }
-- 
1.7.9.5
