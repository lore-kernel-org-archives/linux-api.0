From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 6/6] seccomp: Action to log before allowing
Date: Fri, 11 Aug 2017 04:33:57 +0000
Message-ID: <1502426037-3777-7-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, Tycho Andersen <tycho@docker.com>, linux-audit@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a new action, SECCOMP_RET_LOG, that logs a syscall before allowing
the syscall. At the implementation level, this action is identical to
the existing SECCOMP_RET_ALLOW action. However, it can be very useful when
initially developing a seccomp filter for an application. The developer
can set the default action to be SECCOMP_RET_LOG, maybe mark any
obviously needed syscalls with SECCOMP_RET_ALLOW, and then put the
application through its paces. A list of syscalls that triggered the
default action (SECCOMP_RET_LOG) can be easily gleaned from the logs and
that list can be used to build the syscall whitelist. Finally, the
developer can change the default action to the desired value.

This provides a more friendly experience than seeing the application get
killed, then updating the filter and rebuilding the app, seeing the
application get killed due to a different syscall, then updating the
filter and rebuilding the app, etc.

The functionality is similar to what's supported by the various LSMs.
SELinux has permissive mode, AppArmor has complain mode, SMACK has
bring-up mode, etc.

SECCOMP_RET_LOG is given a lower value than SECCOMP_RET_ALLOW as allow
while logging is slightly more restrictive than quietly allowing.

Unfortunately, the tests added for SECCOMP_RET_LOG are not capable of
inspecting the audit log to verify that the syscall was logged.

With this patch, the logic for deciding if an action will be logged is:

if action == RET_ALLOW:
  do not log
else if action == RET_KILL && RET_KILL in actions_logged:
  log
else if action == RET_LOG && RET_LOG in actions_logged:
  log
else if filter-requests-logging && action in actions_logged:
  log
else if audit_enabled && process-is-being-audited:
  log
else:
  do not log

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 Documentation/userspace-api/seccomp_filter.rst |  9 +++
 include/uapi/linux/seccomp.h                   |  1 +
 kernel/seccomp.c                               | 23 ++++--
 tools/testing/selftests/seccomp/seccomp_bpf.c  | 97 +++++++++++++++++++++++++-
 4 files changed, 124 insertions(+), 6 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 2d1d8ab..f497735 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -141,6 +141,15 @@ In precedence order, they are:
 	allow use of ptrace, even of other sandboxed processes, without
 	extreme care; ptracers can use this mechanism to escape.)
 
+``SECCOMP_RET_LOG``:
+	Results in the system call being executed after it is logged. This
+	should be used by application developers to learn which syscalls their
+	application needs without having to iterate through multiple test and
+	development cycles to build the list.
+
+	This action will only be logged if "log" is present in the
+	actions_logged sysctl string.
+
 ``SECCOMP_RET_ALLOW``:
 	Results in the system call being executed.
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 144a101..58a07f4 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -32,6 +32,7 @@
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_LOG		0x7ffc0000U /* allow after logging */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e9ebaa5..cf841d7 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -556,10 +556,12 @@ static void seccomp_send_sigsys(int syscall, int reason)
 #define SECCOMP_LOG_TRAP		(1 << 2)
 #define SECCOMP_LOG_ERRNO		(1 << 3)
 #define SECCOMP_LOG_TRACE		(1 << 4)
-#define SECCOMP_LOG_ALLOW		(1 << 5)
+#define SECCOMP_LOG_LOG			(1 << 5)
+#define SECCOMP_LOG_ALLOW		(1 << 6)
 
 static u32 seccomp_actions_logged = SECCOMP_LOG_KILL  | SECCOMP_LOG_TRAP  |
-				    SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE;
+				    SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE |
+				    SECCOMP_LOG_LOG;
 
 static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 			       bool requested)
@@ -578,15 +580,18 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 	case SECCOMP_RET_TRACE:
 		log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
 		break;
+	case SECCOMP_RET_LOG:
+		log = seccomp_actions_logged & SECCOMP_LOG_LOG;
+		break;
 	case SECCOMP_RET_KILL:
 	default:
 		log = seccomp_actions_logged & SECCOMP_LOG_KILL;
 	}
 
 	/*
-	 * Force an audit message to be emitted when the action is RET_KILL or
-	 * the FILTER_FLAG_LOG bit was set and the action is allowed to be
-	 * logged by the admin.
+	 * Force an audit message to be emitted when the action is RET_KILL,
+	 * RET_LOG, or the FILTER_FLAG_LOG bit was set and the action is
+	 * allowed to be logged by the admin.
 	 */
 	if (log)
 		return __audit_seccomp(syscall, signr, action);
@@ -723,6 +728,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 		return 0;
 
+	case SECCOMP_RET_LOG:
+		seccomp_log(this_syscall, 0, action, true);
+		return 0;
+
 	case SECCOMP_RET_ALLOW:
 		/*
 		 * Note that the "match" filter will always be NULL for
@@ -919,6 +928,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
 	case SECCOMP_RET_TRAP:
 	case SECCOMP_RET_ERRNO:
 	case SECCOMP_RET_TRACE:
+	case SECCOMP_RET_LOG:
 	case SECCOMP_RET_ALLOW:
 		break;
 	default:
@@ -1069,12 +1079,14 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #define SECCOMP_RET_TRAP_NAME		"trap"
 #define SECCOMP_RET_ERRNO_NAME		"errno"
 #define SECCOMP_RET_TRACE_NAME		"trace"
+#define SECCOMP_RET_LOG_NAME		"log"
 #define SECCOMP_RET_ALLOW_NAME		"allow"
 
 static const char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
 					    SECCOMP_RET_TRAP_NAME	" "
 					    SECCOMP_RET_ERRNO_NAME	" "
 					    SECCOMP_RET_TRACE_NAME	" "
+					    SECCOMP_RET_LOG_NAME	" "
 					    SECCOMP_RET_ALLOW_NAME;
 
 struct seccomp_log_name {
@@ -1087,6 +1099,7 @@ static const struct seccomp_log_name seccomp_log_names[] = {
 	{ SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
 	{ SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
 	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
+	{ SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
 	{ SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
 	{ }
 };
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index fd0fb32..f64c81d2 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -140,6 +140,10 @@ int seccomp(unsigned int op, unsigned int flags, void *args)
 }
 #endif
 
+#ifndef SECCOMP_RET_LOG
+#define SECCOMP_RET_LOG       0x7ffc0000U /* allow after logging */
+#endif
+
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
 #elif __BYTE_ORDER == __BIG_ENDIAN
@@ -395,6 +399,28 @@ TEST(empty_prog)
 	EXPECT_EQ(EINVAL, errno);
 }
 
+TEST(log_all)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_LOG),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	/* getppid() should succeed and be logged (no check for logging) */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+}
+
 TEST_SIGNAL(unknown_ret_is_kill_inside, SIGSYS)
 {
 	struct sock_filter filter[] = {
@@ -915,6 +941,7 @@ TEST_F(TRAP, handler)
 
 FIXTURE_DATA(precedence) {
 	struct sock_fprog allow;
+	struct sock_fprog log;
 	struct sock_fprog trace;
 	struct sock_fprog error;
 	struct sock_fprog trap;
@@ -926,6 +953,13 @@ FIXTURE_SETUP(precedence)
 	struct sock_filter allow_insns[] = {
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
+	struct sock_filter log_insns[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_LOG),
+	};
 	struct sock_filter trace_insns[] = {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
@@ -962,6 +996,7 @@ FIXTURE_SETUP(precedence)
 	memcpy(self->_x.filter, &_x##_insns, sizeof(_x##_insns)); \
 	self->_x.len = (unsigned short)ARRAY_SIZE(_x##_insns)
 	FILTER_ALLOC(allow);
+	FILTER_ALLOC(log);
 	FILTER_ALLOC(trace);
 	FILTER_ALLOC(error);
 	FILTER_ALLOC(trap);
@@ -972,6 +1007,7 @@ FIXTURE_TEARDOWN(precedence)
 {
 #define FILTER_FREE(_x) if (self->_x.filter) free(self->_x.filter)
 	FILTER_FREE(allow);
+	FILTER_FREE(log);
 	FILTER_FREE(trace);
 	FILTER_FREE(error);
 	FILTER_FREE(trap);
@@ -989,6 +1025,8 @@ TEST_F(precedence, allow_ok)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -1013,6 +1051,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest, SIGSYS)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -1044,6 +1084,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest_in_any_order, SIGSYS)
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
@@ -1065,6 +1107,8 @@ TEST_F_SIGNAL(precedence, trap_is_second, SIGSYS)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -1090,6 +1134,8 @@ TEST_F_SIGNAL(precedence, trap_is_second_in_any_order, SIGSYS)
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -1111,6 +1157,8 @@ TEST_F(precedence, errno_is_third)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -1129,6 +1177,8 @@ TEST_F(precedence, errno_is_third_in_any_order)
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
 
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
@@ -1151,6 +1201,8 @@ TEST_F(precedence, trace_is_fourth)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	/* Should work just fine. */
@@ -1172,12 +1224,54 @@ TEST_F(precedence, trace_is_fourth_in_any_order)
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	/* Should work just fine. */
 	EXPECT_EQ(parent, syscall(__NR_getppid));
 	/* No ptracer */
 	EXPECT_EQ(-1, syscall(__NR_getpid));
 }
 
+TEST_F(precedence, log_is_fifth)
+{
+	pid_t mypid, parent;
+	long ret;
+
+	mypid = getpid();
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* Should also work just fine */
+	EXPECT_EQ(mypid, syscall(__NR_getpid));
+}
+
+TEST_F(precedence, log_is_fifth_in_any_order)
+{
+	pid_t mypid, parent;
+	long ret;
+
+	mypid = getpid();
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* Should also work just fine */
+	EXPECT_EQ(mypid, syscall(__NR_getpid));
+}
+
 #ifndef PTRACE_O_TRACESECCOMP
 #define PTRACE_O_TRACESECCOMP	0x00000080
 #endif
@@ -2685,7 +2779,7 @@ TEST(get_action_avail)
 {
 	__u32 actions[] = { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
 			    SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
-			    SECCOMP_RET_ALLOW };
+			    SECCOMP_RET_LOG,   SECCOMP_RET_ALLOW };
 	__u32 unknown_action = 0x10000000U;
 	int i;
 	long ret;
@@ -2722,6 +2816,7 @@ TEST(get_action_avail)
  * - 64-bit arg prodding
  * - arch value testing (x86 modes especially)
  * - verify that FILTER_FLAG_LOG filters generate log messages
+ * - verify that RET_LOG generates log messages
  * - ...
  */
 
-- 
2.7.4
