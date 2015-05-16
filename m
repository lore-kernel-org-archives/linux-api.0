From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for v4.2 3/3] selftests: enhance membarrier syscall test
Date: Sat, 16 May 2015 19:48:20 -0400
Message-ID: <1431820100-17040-4-git-send-email-mathieu.desnoyers@efficios.com>
References: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michael Ellerman <mpe@ellerman.id.au>, Pranith Kumar <bobby.prani@gmail.com>
List-Id: linux-api@vger.kernel.org

Update the membarrier syscall self-test to match the membarrier
interface. Extend coverage of the interface. Consider ENOSYS as a "SKIP"
test, since it is a valid configuration, but does not allow testing the
system call.

CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../testing/selftests/membarrier/membarrier_test.c |  100 +++++++++++++++-----
 1 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
index 3c9f217..dde3125 100644
--- a/tools/testing/selftests/membarrier/membarrier_test.c
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -10,62 +10,112 @@
 
 #include "../kselftest.h"
 
+enum test_membarrier_status {
+	TEST_MEMBARRIER_PASS = 0,
+	TEST_MEMBARRIER_FAIL,
+	TEST_MEMBARRIER_SKIP,
+};
+
 static int sys_membarrier(int cmd, int flags)
 {
 	return syscall(__NR_membarrier, cmd, flags);
 }
 
-static void test_membarrier_fail(void)
+static enum test_membarrier_status test_membarrier_cmd_fail(void)
 {
 	int cmd = -1, flags = 0;
 
 	if (sys_membarrier(cmd, flags) != -1) {
-		printf("membarrier: Should fail but passed\n");
-		ksft_exit_fail();
+		printf("membarrier: Wrong command should fail but passed.\n");
+		return TEST_MEMBARRIER_FAIL;
+	}
+	return TEST_MEMBARRIER_PASS;
+}
+
+static enum test_membarrier_status test_membarrier_flags_fail(void)
+{
+	int cmd = MEMBARRIER_CMD_QUERY, flags = 1;
+
+	if (sys_membarrier(cmd, flags) != -1) {
+		printf("membarrier: Wrong flags should fail but passed.\n");
+		return TEST_MEMBARRIER_FAIL;
 	}
+	return TEST_MEMBARRIER_PASS;
 }
 
-static void test_membarrier_success(void)
+static enum test_membarrier_status test_membarrier_success(void)
 {
-	int flags = 0;
+	int cmd = MEMBARRIER_CMD_SHARED, flags = 0;
 
-	if (sys_membarrier(MEMBARRIER_CMD_SHARED, flags) != 0) {
-		printf("membarrier: Executing MEMBARRIER failed, %s\n",
+	if (sys_membarrier(cmd, flags) != 0) {
+		printf("membarrier: Executing MEMBARRIER_CMD_SHARED failed. %s.\n",
 				strerror(errno));
-		ksft_exit_fail();
+		return TEST_MEMBARRIER_FAIL;
 	}
 
-	printf("membarrier: MEMBARRIER_CMD_SHARED success\n");
+	printf("membarrier: MEMBARRIER_CMD_SHARED success.\n");
+	return TEST_MEMBARRIER_PASS;
 }
 
-static void test_membarrier(void)
+static enum test_membarrier_status test_membarrier(void)
 {
-	test_membarrier_fail();
-	test_membarrier_success();
+	enum test_membarrier_status status;
+
+	status = test_membarrier_cmd_fail();
+	if (status)
+		return status;
+	status = test_membarrier_flags_fail();
+	if (status)
+		return status;
+	status = test_membarrier_success();
+	if (status)
+		return status;
+	return TEST_MEMBARRIER_PASS;
 }
 
-static int test_membarrier_exists(void)
+static enum test_membarrier_status test_membarrier_query(void)
 {
-	int flags = 0;
-
-	if (sys_membarrier(MEMBARRIER_CMD_QUERY, flags))
-		return 0;
+	int flags = 0, ret;
 
-	return 1;
+	printf("membarrier MEMBARRIER_CMD_QUERY ");
+	ret = sys_membarrier(MEMBARRIER_CMD_QUERY, flags);
+	if (ret < 0) {
+		printf("failed. %s.\n", strerror(errno));
+		switch (errno) {
+		case ENOSYS:
+			/*
+			 * It is valid to build a kernel with
+			 * CONFIG_MEMBARRIER=n. However, this skips the tests.
+			 */
+			return TEST_MEMBARRIER_SKIP;
+		case EINVAL:
+		default:
+			return TEST_MEMBARRIER_FAIL;
+		}
+	}
+	if (!(ret & MEMBARRIER_CMD_SHARED)) {
+		printf("command MEMBARRIER_CMD_SHARED is not supported.\n");
+		return TEST_MEMBARRIER_FAIL;
+	}
+	printf("syscall available.\n");
+	return TEST_MEMBARRIER_PASS;
 }
 
 int main(int argc, char **argv)
 {
-	printf("membarrier: MEMBARRIER_CMD_QUERY ");
-	if (test_membarrier_exists()) {
-		printf("syscall implemented\n");
-		test_membarrier();
-	} else {
-		printf("syscall not implemented!\n");
+	switch (test_membarrier_query()) {
+	case TEST_MEMBARRIER_FAIL:
 		return ksft_exit_fail();
+	case TEST_MEMBARRIER_SKIP:
+		return ksft_exit_skip();
+	}
+	switch (test_membarrier()) {
+	case TEST_MEMBARRIER_FAIL:
+		return ksft_exit_fail();
+	case TEST_MEMBARRIER_SKIP:
+		return ksft_exit_skip();
 	}
 
 	printf("membarrier: tests done!\n");
-
 	return ksft_exit_pass();
 }
-- 
1.7.7.3
