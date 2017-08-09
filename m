From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 2/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
Date: Wed,  9 Aug 2017 12:01:55 -0700
Message-ID: <1502305317-85052-3-git-send-email-keescook@chromium.org>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502305317-85052-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Tycho Andersen <tycho@docker.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Right now, SECCOMP_RET_KILL kills the current thread. There have been
a few requests for RET_KILL to kill the entire process (the thread
group), but since seccomp's u32 return values are ABI, and ordered by
lowest value, with RET_KILL as 0, there isn't a trivial way to provide
an even smaller value that would mean the more restrictive action of
killing the thread group.

Changing the definition of SECCOMP_RET_KILL to mean "kill process" and
then adding a new higher definition of SECCOMP_RET_KILL_THREAD isn't
possible since there are already userspace programs depending on the
kill-thread behavior.

Instead, create a simulated SECCOMP_RET_KILL_PROCESS action which
has the semantics of such a return had it been possible to create
it naturally. This is done by adding a filter flag that indicates
that a RET_KILL from this filter must kill the process rather
than the thread. This can be set (and not cleared) via the new
SECCOMP_FILTER_FLAG_KILL_PROCESS flag.

Pros:
 - the logic for the filter action is contained in the filter.
 - userspace can detect support for the feature since earlier kernels
   will reject the new flag.
 - can be distinguished from "normal" RET_KILL in the same filter
   chain (in case a program wants to choose to kill thread or process).
Cons:
 - depends on adding an assignment to the seccomp_run_filters() loop
   (previous patch).
 - adds logic to the seccomp_run_filters() loop (though it is a single
   unlikely test for zero, so the cycle count change isn't measurable).

Alternatives to this approach with pros/cons:

- Change userspace API to use an s32 for BPF return value, and use a
  negative value to indicate SECCOMP_RET_KILL_PROCESS.
  Pros:
   - no change needed to seccomp_run_filters() loop.
   - the logic for the filter action is contained in the filter.
   - can be distinguished from "normal" RET_KILL in the same filter
     chain (in case a program wants to choose to kill thread or process).
  Cons:
   - there isn't a trivial way for userspace to detect if the kernel
     supports the feature (earlier kernels will silently ignore the
     new value, only kill the thread).
   - need to teach libseccomp about new details, extensive updates
     to documentation, and hope there is not confusion about signedness
     in existing userspace.

- Use a new test during seccomp_run_filters() that treats the RET_DATA
  mask of a RET_KILL action as special. If a new bit is set in the data,
  then treat the return value as -1 (lower than 0).
  Pros:
   - the logic for the filter action is contained in the filter.
   - can be distinguished from "normal" RET_KILL in the same filter
     chain (in case a program wants to choose to kill thread or process).
  Cons:
   - adds more than a single unlikely test to time-sensitive
     seccomp_run_filters() loop.
   - there isn't a trivial way for userspace to detect if the kernel
     supports the feature (earlier kernels will silently ignore the
     RET_DATA and only kill the thread).
   - Violates the "most recent RET_DATA" return value used for all
     other actions (since processing must continue to find the first
     RET_KILL with the flag set).
   - May create problems for existing programs that were using RET_DATA
     to distinguish between various SECCOMP_RET_KILL locations.

- Have SECCOMP_FILTER_FLAG_KILL_PROCESS attach to the seccomp struct
  rather than the filter.
  Pros:
   - no change needed to seccomp_run_filters() loop.
   - userspace can detect support for the feature since earlier kernels
     will reject the new flag.
  Cons:
   - does not provide a way for a set of filters to distinguish
     between wanting to kill a thread or a process.
   - the logic for the filter action isn't contained in the filter,
     which may lead to synchronization bugs (e.g. vs TSYNC, vs CRIU, etc).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/seccomp.h      |  3 ++-
 include/uapi/linux/seccomp.h |  3 ++-
 kernel/seccomp.c             | 54 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index ecc296c137cd..59d001ba655c 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -3,7 +3,8 @@
 
 #include <uapi/linux/seccomp.h>
 
-#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC)
+#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC | \
+					 SECCOMP_FILTER_FLAG_KILL_PROCESS)
 
 #ifdef CONFIG_SECCOMP
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a43ff1e..4b75d8c297b6 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -15,7 +15,8 @@
 #define SECCOMP_SET_MODE_FILTER	1
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
-#define SECCOMP_FILTER_FLAG_TSYNC	1
+#define SECCOMP_FILTER_FLAG_TSYNC		1
+#define SECCOMP_FILTER_FLAG_KILL_PROCESS	2
 
 /*
  * All BPF programs must return a 32-bit value.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 1f3347fc2605..6a196d1495e6 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -44,6 +44,7 @@
  *         is only needed for handling filters shared across tasks.
  * @prev: points to a previously installed, or inherited, filter
  * @prog: the BPF program to evaluate
+ * @kill_process: if true, RET_KILL will kill process rather than thread.
  *
  * seccomp_filter objects are organized in a tree linked via the @prev
  * pointer.  For any task, it appears to be a singly-linked list starting
@@ -57,6 +58,7 @@
  */
 struct seccomp_filter {
 	refcount_t usage;
+	bool kill_process;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
 };
@@ -201,8 +203,25 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 	 */
 	for (; f; f = f->prev) {
 		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
+		u32 action = cur_ret & SECCOMP_RET_ACTION;
 
-		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION)) {
+		/*
+		 * In order to distinguish between SECCOMP_RET_KILL and
+		 * "higher priority" synthetic SECCOMP_RET_KILL_PROCESS
+		 * identified by the kill_process filter flag, treat any
+		 * case as immediately stopping filter processing. No
+		 * higher priority action can exist, and we can't stop
+		 * on the first RET_KILL (which may not have set
+		 * f->kill_process) when a RET_KILL further up the filter
+		 * list may have f->kill_process set which would go
+		 * unnoticed.
+		 */
+		if (unlikely(action == SECCOMP_RET_KILL && f->kill_process)) {
+			*match = f;
+			return cur_ret;
+		}
+
+		if (action < (ret & SECCOMP_RET_ACTION)) {
 			ret = cur_ret;
 			*match = f;
 		}
@@ -450,6 +469,10 @@ static long seccomp_attach_filter(unsigned int flags,
 			return ret;
 	}
 
+	/* Set process-killing flag, if present. */
+	if (flags & SECCOMP_FILTER_FLAG_KILL_PROCESS)
+		filter->kill_process = true;
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -574,6 +597,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	u32 filter_ret, action;
 	struct seccomp_filter *match = NULL;
 	int data;
+	bool kill_process;
 
 	/*
 	 * Make sure that any changes to mode from another thread have
@@ -655,8 +679,26 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL:
 	default:
 		audit_seccomp(this_syscall, SIGSYS, action);
-		/* Dump core only if this is the last remaining thread. */
-		if (get_nr_threads(current) == 1) {
+
+		/*
+		 * The only way match can be NULL here is if something
+		 * went very wrong in seccomp_run_filters() (e.g. a NULL
+		 * filter list in struct seccomp) and the return action
+		 * falls back to failing closed. In this case, take the
+		 * strongest possible action.
+		 *
+		 * If we get here with match->kill_process set, we need
+		 * to kill the entire thread group. Otherwise, kill only
+		 * the offending thread.
+		 */
+		kill_process = (!match || match->kill_process);
+
+		/*
+		 * Dumping core kills the entire thread group, so only
+		 * coredump if that has been requested or this was already
+		 * the only thread running.
+		 */
+		if (kill_process || get_nr_threads(current) == 1) {
 			siginfo_t info;
 
 			/* Show the original registers in the dump. */
@@ -665,7 +707,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			seccomp_init_siginfo(&info, this_syscall, data);
 			do_coredump(&info);
 		}
-		do_exit(SIGSYS);
+
+		if (kill_process)
+			do_group_exit(SIGSYS);
+		else
+			do_exit(SIGSYS);
 	}
 
 	unreachable();
-- 
2.7.4
