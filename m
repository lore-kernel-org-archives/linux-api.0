From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 5/6] seccomp: Filter flag to log all actions except
	SECCOMP_RET_ALLOW
Date: Fri, 11 Aug 2017 04:33:56 +0000
Message-ID: <1502426037-3777-6-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@docker.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-audit@redhat.com, John Crispin <john@phrozen.org>, Will Drewry <wad@chromium.org>
List-Id: linux-api@vger.kernel.org

Add a new filter flag, SECCOMP_FILTER_FLAG_LOG, that enables logging for
all actions except for SECCOMP_RET_ALLOW for the given filter.

SECCOMP_RET_KILL actions are always logged, when "kill" is in the
actions_logged sysctl, and SECCOMP_RET_ALLOW actions are never logged,
regardless of this flag.

This flag can be used to create noisy filters that result in all
non-allowed actions to be logged. A process may have one noisy filter,
which is loaded with this flag, as well as a quiet filter that's not
loaded with this flag. This allows for the actions in a set of filters
to be selectively conveyed to the admin.

Since a system could have a large number of allocated seccomp_filter
structs, struct packing was taken in consideration. On 32 and 64 bit
x86, the new log member takes up one byte of an existing three byte hole
in the struct.

Unfortunately, the tests added for SECCOMP_FILTER_FLAG_LOG are not
capable of inspecting the audit log to verify that the actions taken in
the filter were logged.

With this patch, the logic for deciding if an action will be logged is:

if action == RET_ALLOW:
  do not log
else if action == RET_KILL && RET_KILL in actions_logged:
  log
else if filter-requests-logging && action in actions_logged:
  log
else if audit_enabled && process-is-being-audited:
  log
else:
  do not log

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 include/linux/seccomp.h                       |  3 +-
 include/uapi/linux/seccomp.h                  |  1 +
 kernel/seccomp.c                              | 26 +++++++---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 69 ++++++++++++++++++++++++++-
 4 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 59d001b..c881b10 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -4,7 +4,8 @@
 #include <uapi/linux/seccomp.h>
 
 #define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC | \
-					 SECCOMP_FILTER_FLAG_KILL_PROCESS)
+					 SECCOMP_FILTER_FLAG_KILL_PROCESS | \
+					 SECCOMP_FILTER_FLAG_LOG)
 
 #ifdef CONFIG_SECCOMP
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 95d20d2..144a101 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -18,6 +18,7 @@
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
 #define SECCOMP_FILTER_FLAG_TSYNC		1
 #define SECCOMP_FILTER_FLAG_KILL_PROCESS	2
+#define SECCOMP_FILTER_FLAG_LOG			4
 
 /*
  * All BPF programs must return a 32-bit value.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 2cb362a..e9ebaa5 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -44,6 +44,7 @@
  *         get/put helpers should be used when accessing an instance
  *         outside of a lifetime-guarded section.  In general, this
  *         is only needed for handling filters shared across tasks.
+ * @log: true if all actions except for SECCOMP_RET_ALLOW should be logged
  * @prev: points to a previously installed, or inherited, filter
  * @prog: the BPF program to evaluate
  * @kill_process: if true, RET_KILL will kill process rather than thread.
@@ -61,6 +62,7 @@
 struct seccomp_filter {
 	refcount_t usage;
 	bool kill_process;
+	bool log;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
 };
@@ -475,6 +477,10 @@ static long seccomp_attach_filter(unsigned int flags,
 	if (flags & SECCOMP_FILTER_FLAG_KILL_PROCESS)
 		filter->kill_process = true;
 
+	/* Set log flag, if present. */
+	if (flags & SECCOMP_FILTER_FLAG_LOG)
+		filter->log = true;
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -555,15 +561,22 @@ static void seccomp_send_sigsys(int syscall, int reason)
 static u32 seccomp_actions_logged = SECCOMP_LOG_KILL  | SECCOMP_LOG_TRAP  |
 				    SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE;
 
-static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
+static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
+			       bool requested)
 {
 	bool log = false;
 
 	switch (action) {
 	case SECCOMP_RET_ALLOW:
+		break;
 	case SECCOMP_RET_TRAP:
+		log = requested && seccomp_actions_logged & SECCOMP_LOG_TRAP;
+		break;
 	case SECCOMP_RET_ERRNO:
+		log = requested && seccomp_actions_logged & SECCOMP_LOG_ERRNO;
+		break;
 	case SECCOMP_RET_TRACE:
+		log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
 		break;
 	case SECCOMP_RET_KILL:
 	default:
@@ -571,8 +584,9 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
 	}
 
 	/*
-	 * Force an audit message to be emitted when the action is RET_KILL and
-	 * the action is allowed to be logged by the admin.
+	 * Force an audit message to be emitted when the action is RET_KILL or
+	 * the FILTER_FLAG_LOG bit was set and the action is allowed to be
+	 * logged by the admin.
 	 */
 	if (log)
 		return __audit_seccomp(syscall, signr, action);
@@ -609,7 +623,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
-	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
+	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL, true);
 	do_exit(SIGKILL);
 }
 
@@ -719,7 +733,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 	case SECCOMP_RET_KILL:
 	default:
-		seccomp_log(this_syscall, SIGSYS, action);
+		seccomp_log(this_syscall, SIGSYS, action, true);
 
 		/*
 		 * The only way match can be NULL here is if something
@@ -758,7 +772,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	unreachable();
 
 skip:
-	seccomp_log(this_syscall, 0, action);
+	seccomp_log(this_syscall, 0, action, match ? match->log : false);
 	return -1;
 }
 #else
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index ed4528c..fd0fb32 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -128,6 +128,10 @@ struct seccomp_data {
 #define SECCOMP_FILTER_FLAG_KILL_PROCESS 2
 #endif
 
+#ifndef SECCOMP_FILTER_FLAG_LOG
+#define SECCOMP_FILTER_FLAG_LOG 4
+#endif
+
 #ifndef seccomp
 int seccomp(unsigned int op, unsigned int flags, void *args)
 {
@@ -1927,7 +1931,8 @@ TEST(seccomp_syscall_mode_lock)
 TEST(detect_seccomp_filter_flags)
 {
 	unsigned int flags[] = { SECCOMP_FILTER_FLAG_TSYNC,
-				 SECCOMP_FILTER_FLAG_KILL_PROCESS };
+				 SECCOMP_FILTER_FLAG_KILL_PROCESS,
+				 SECCOMP_FILTER_FLAG_LOG };
 	unsigned int flag, all_flags;
 	int i;
 	long ret;
@@ -2615,6 +2620,67 @@ TEST(syscall_restart)
 		_metadata->passed = 0;
 }
 
+TEST_SIGNAL(filter_flag_log, SIGSYS)
+{
+	struct sock_filter allow_filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_filter kill_filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog allow_prog = {
+		.len = (unsigned short)ARRAY_SIZE(allow_filter),
+		.filter = allow_filter,
+	};
+	struct sock_fprog kill_prog = {
+		.len = (unsigned short)ARRAY_SIZE(kill_filter),
+		.filter = kill_filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	/* Verify that the FILTER_FLAG_LOG flag isn't accepted in strict mode */
+	ret = seccomp(SECCOMP_SET_MODE_STRICT, SECCOMP_FILTER_FLAG_LOG,
+		      &allow_prog);
+	ASSERT_NE(ENOSYS, errno) {
+		TH_LOG("Kernel does not support seccomp syscall!");
+	}
+	EXPECT_NE(0, ret) {
+		TH_LOG("Kernel accepted FILTER_FLAG_LOG flag in strict mode!");
+	}
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Kernel returned unexpected errno for FILTER_FLAG_LOG flag in strict mode!");
+	}
+
+	/* Verify that a simple, permissive filter can be added with no flags */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &allow_prog);
+	EXPECT_EQ(0, ret);
+
+	/* See if the same filter can be added with the FILTER_FLAG_LOG flag */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG,
+		      &allow_prog);
+	ASSERT_NE(EINVAL, errno) {
+		TH_LOG("Kernel does not support the FILTER_FLAG_LOG flag!");
+	}
+	EXPECT_EQ(0, ret);
+
+	/* Ensure that the kill filter works with the FILTER_FLAG_LOG flag */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG,
+		      &kill_prog);
+	EXPECT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
 TEST(get_action_avail)
 {
 	__u32 actions[] = { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
@@ -2655,6 +2721,7 @@ TEST(get_action_avail)
  * - endianness checking when appropriate
  * - 64-bit arg prodding
  * - arch value testing (x86 modes especially)
+ * - verify that FILTER_FLAG_LOG filters generate log messages
  * - ...
  */
 
-- 
2.7.4
