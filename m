From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v5 5/6] seccomp: Action to log before allowing
Date: Fri, 28 Jul 2017 20:55:51 +0000
Message-ID: <1501275352-30045-6-git-send-email-tyhicks@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, linux-audit@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
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

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---

* Change since v4:
  - folded the previously separate selftest patch into this patch
  - add TODO to verify that RET_LOG generates log messages in selftests
  - adjust for new reStructuredText format

 Documentation/userspace-api/seccomp_filter.rst |  6 ++
 include/uapi/linux/seccomp.h                   |  1 +
 kernel/seccomp.c                               | 17 ++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c  | 97 +++++++++++++++++++++++++-
 4 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 2d1d8ab..2ece856 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -141,6 +141,12 @@ In precedence order, they are:
 	allow use of ptrace, even of other sandboxed processes, without
 	extreme care; ptracers can use this mechanism to escape.)
 
+``SECCOMP_RET_LOG``:
+	Results in the system call being executed after it is logged. This
+	should be used by application developers to learn which syscalls their
+	application needs without having to iterate through multiple test and
+	development cycles to build the list.
+
 ``SECCOMP_RET_ALLOW``:
 	Results in the system call being executed.
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 19a611d..f944332 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -31,6 +31,7 @@
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_LOG		0x7ffc0000U /* allow after logging */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 03ad3ba..c12d3dd 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -533,10 +533,12 @@ static void seccomp_send_sigsys(int syscall, int reason)
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
@@ -554,6 +556,9 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 		case SECCOMP_RET_TRACE:
 			log = seccomp_actions_logged & SECCOMP_LOG_TRACE;
 			break;
+		case SECCOMP_RET_LOG:
+			log = seccomp_actions_logged & SECCOMP_LOG_LOG;
+			break;
 		case SECCOMP_RET_ALLOW:
 			log = false;
 			break;
@@ -701,6 +706,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 		return 0;
 
+	case SECCOMP_RET_LOG:
+		seccomp_log(this_syscall, 0, action, true);
+		return 0;
+
 	case SECCOMP_RET_ALLOW:
 		return 0;
 
@@ -870,6 +879,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
 	case SECCOMP_RET_TRAP:
 	case SECCOMP_RET_ERRNO:
 	case SECCOMP_RET_TRACE:
+	case SECCOMP_RET_LOG:
 	case SECCOMP_RET_ALLOW:
 		break;
 	default:
@@ -1020,12 +1030,14 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
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
 
 #define SECCOMP_ACTIONS_AVAIL_LEN	strlen(seccomp_actions_avail)
@@ -1040,6 +1052,7 @@ static const struct seccomp_log_name seccomp_log_names[] = {
 	{ SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
 	{ SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
 	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
+	{ SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
 	{ SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
 	{ }
 };
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 8f0872b..040e875 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -87,6 +87,10 @@ struct seccomp_data {
 };
 #endif
 
+#ifndef SECCOMP_RET_LOG
+#define SECCOMP_RET_LOG       0x7ffc0000U /* allow after logging */
+#endif
+
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
 #elif __BYTE_ORDER == __BIG_ENDIAN
@@ -342,6 +346,28 @@ TEST(empty_prog)
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
@@ -735,6 +761,7 @@ TEST_F(TRAP, handler)
 
 FIXTURE_DATA(precedence) {
 	struct sock_fprog allow;
+	struct sock_fprog log;
 	struct sock_fprog trace;
 	struct sock_fprog error;
 	struct sock_fprog trap;
@@ -746,6 +773,13 @@ FIXTURE_SETUP(precedence)
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
@@ -782,6 +816,7 @@ FIXTURE_SETUP(precedence)
 	memcpy(self->_x.filter, &_x##_insns, sizeof(_x##_insns)); \
 	self->_x.len = (unsigned short)ARRAY_SIZE(_x##_insns)
 	FILTER_ALLOC(allow);
+	FILTER_ALLOC(log);
 	FILTER_ALLOC(trace);
 	FILTER_ALLOC(error);
 	FILTER_ALLOC(trap);
@@ -792,6 +827,7 @@ FIXTURE_TEARDOWN(precedence)
 {
 #define FILTER_FREE(_x) if (self->_x.filter) free(self->_x.filter)
 	FILTER_FREE(allow);
+	FILTER_FREE(log);
 	FILTER_FREE(trace);
 	FILTER_FREE(error);
 	FILTER_FREE(trap);
@@ -809,6 +845,8 @@ TEST_F(precedence, allow_ok)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -833,6 +871,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest, SIGSYS)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -864,6 +904,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest_in_any_order, SIGSYS)
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
@@ -885,6 +927,8 @@ TEST_F_SIGNAL(precedence, trap_is_second, SIGSYS)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -910,6 +954,8 @@ TEST_F_SIGNAL(precedence, trap_is_second_in_any_order, SIGSYS)
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -931,6 +977,8 @@ TEST_F(precedence, errno_is_third)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
@@ -949,6 +997,8 @@ TEST_F(precedence, errno_is_third_in_any_order)
 	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
 	ASSERT_EQ(0, ret);
 
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
 	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
@@ -971,6 +1021,8 @@ TEST_F(precedence, trace_is_fourth)
 
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
 	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log);
+	ASSERT_EQ(0, ret);
 	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
 	ASSERT_EQ(0, ret);
 	/* Should work just fine. */
@@ -992,12 +1044,54 @@ TEST_F(precedence, trace_is_fourth_in_any_order)
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
@@ -2494,7 +2588,7 @@ TEST(get_action_avail)
 {
 	__u32 actions[] = { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
 			    SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
-			    SECCOMP_RET_ALLOW };
+			    SECCOMP_RET_LOG,   SECCOMP_RET_ALLOW };
 	__u32 unknown_action = 0x10000000U;
 	int i;
 	long ret;
@@ -2531,6 +2625,7 @@ TEST(get_action_avail)
  * - 64-bit arg prodding
  * - arch value testing (x86 modes especially)
  * - verify that FILTER_FLAG_LOG filters generate log messages
+ * - verify that RET_LOG generates log messages
  * - ...
  */
 
-- 
2.7.4
