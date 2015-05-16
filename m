From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for v4.2 2/3] selftests: add membarrier syscall test
Date: Sat, 16 May 2015 19:48:19 -0400
Message-ID: <1431820100-17040-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431820100-17040-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pranith Kumar <bobby.prani@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

This patch adds a self test for the membarrier system call.

CC: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/membarrier/.gitignore      |    1 +
 tools/testing/selftests/membarrier/Makefile        |   11 +++
 .../testing/selftests/membarrier/membarrier_test.c |   71 ++++++++++++++++++++
 4 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/membarrier/.gitignore
 create mode 100644 tools/testing/selftests/membarrier/Makefile
 create mode 100644 tools/testing/selftests/membarrier/membarrier_test.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 95abddc..73824b1 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -5,6 +5,7 @@ TARGETS += exec
 TARGETS += firmware
 TARGETS += ftrace
 TARGETS += kcmp
+TARGETS += membarrier
 TARGETS += memfd
 TARGETS += memory-hotplug
 TARGETS += mount
diff --git a/tools/testing/selftests/membarrier/.gitignore b/tools/testing/selftests/membarrier/.gitignore
new file mode 100644
index 0000000..020c44f4
--- /dev/null
+++ b/tools/testing/selftests/membarrier/.gitignore
@@ -0,0 +1 @@
+membarrier_test
diff --git a/tools/testing/selftests/membarrier/Makefile b/tools/testing/selftests/membarrier/Makefile
new file mode 100644
index 0000000..877a503
--- /dev/null
+++ b/tools/testing/selftests/membarrier/Makefile
@@ -0,0 +1,11 @@
+CFLAGS += -g -I../../../../usr/include/
+
+all:
+	$(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
+
+TEST_PROGS := membarrier_test
+
+include ../lib.mk
+
+clean:
+	$(RM) membarrier_test
diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
new file mode 100644
index 0000000..3c9f217
--- /dev/null
+++ b/tools/testing/selftests/membarrier/membarrier_test.c
@@ -0,0 +1,71 @@
+#define _GNU_SOURCE
+#define __EXPORTED_HEADERS__
+
+#include <linux/membarrier.h>
+#include <asm-generic/unistd.h>
+#include <sys/syscall.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+
+#include "../kselftest.h"
+
+static int sys_membarrier(int cmd, int flags)
+{
+	return syscall(__NR_membarrier, cmd, flags);
+}
+
+static void test_membarrier_fail(void)
+{
+	int cmd = -1, flags = 0;
+
+	if (sys_membarrier(cmd, flags) != -1) {
+		printf("membarrier: Should fail but passed\n");
+		ksft_exit_fail();
+	}
+}
+
+static void test_membarrier_success(void)
+{
+	int flags = 0;
+
+	if (sys_membarrier(MEMBARRIER_CMD_SHARED, flags) != 0) {
+		printf("membarrier: Executing MEMBARRIER failed, %s\n",
+				strerror(errno));
+		ksft_exit_fail();
+	}
+
+	printf("membarrier: MEMBARRIER_CMD_SHARED success\n");
+}
+
+static void test_membarrier(void)
+{
+	test_membarrier_fail();
+	test_membarrier_success();
+}
+
+static int test_membarrier_exists(void)
+{
+	int flags = 0;
+
+	if (sys_membarrier(MEMBARRIER_CMD_QUERY, flags))
+		return 0;
+
+	return 1;
+}
+
+int main(int argc, char **argv)
+{
+	printf("membarrier: MEMBARRIER_CMD_QUERY ");
+	if (test_membarrier_exists()) {
+		printf("syscall implemented\n");
+		test_membarrier();
+	} else {
+		printf("syscall not implemented!\n");
+		return ksft_exit_fail();
+	}
+
+	printf("membarrier: tests done!\n");
+
+	return ksft_exit_pass();
+}
-- 
1.7.7.3
