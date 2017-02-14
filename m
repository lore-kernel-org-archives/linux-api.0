From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v3 4/4] seccomp: Add tests for SECCOMP_RET_LOG
Date: Tue, 14 Feb 2017 03:45:28 +0000
Message-ID: <1487043928-5982-5-git-send-email-tyhicks@canonical.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

Extend the kernel selftests for seccomp to test the newly added
SECCOMP_RET_LOG action. The added tests follow the example of existing
tests.

Unfortunately, the tests are not capable of inspecting the audit log to
verify that the syscall was logged.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 94 +++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 03f1fa4..5633b42 100644
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
-- 
2.7.4
