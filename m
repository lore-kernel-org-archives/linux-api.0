From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 24 Jun 2014 13:48:13 -0700
Message-ID: <1403642893-23107-10-git-send-email-keescook@chromium.org>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403642893-23107-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
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
sighand lock is sufficient for these cases. The clone case is assisted
by the fact that new threads will have their seccomp state duplicated
from their parent before appearing on the tasklist.

Based on patches by Will Drewry.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/seccomp.h      |    2 +
 include/uapi/linux/seccomp.h |    3 ++
 kernel/seccomp.c             |  115 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 119 insertions(+), 1 deletion(-)

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
index 051c3da4fb4c..c58b49375125 100644
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
@@ -218,6 +219,105 @@ static inline void seccomp_assign_mode(struct task_struct *task,
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
+ * Expects current->sighand->siglock to be held.
+ *
+ * Returns 0 on success, -ve on error, or the pid of a thread which was
+ * either not in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter.
+ */
+static pid_t seccomp_can_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
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
+ * Expects current->sighand->siglock to be held,
+ * and for seccomp_can_sync_threads() to have returned success already
+ * without dropping the locks.
+ *
+ */
+static void seccomp_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+
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
@@ -349,7 +449,7 @@ static long seccomp_attach_filter(unsigned int flags,
 	BUG_ON(!spin_is_locked(&current->sighand->siglock));
 
 	/* Validate flags. */
-	if (flags != 0)
+	if (flags & SECCOMP_FILTER_FLAG_MASK)
 		return -EINVAL;
 
 	/* Validate resulting filter length. */
@@ -359,6 +459,15 @@ static long seccomp_attach_filter(unsigned int flags,
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
@@ -366,6 +475,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	filter->prev = current->seccomp.filter;
 	smp_store_release(&current->seccomp.filter, filter);
 
+	/* Now that the new filter is in place, synchronize to all threads. */
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
+		seccomp_sync_threads();
+
 	return 0;
 }
 
-- 
1.7.9.5
