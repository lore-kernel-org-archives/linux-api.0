From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 2/2] tests: add pidfd_open() tests
Date: Mon, 20 May 2019 17:56:30 +0200
Message-ID: <20190520155630.21684-2-christian@brauner.io>
References: <20190520155630.21684-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520155630.21684-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, oleg@redhat.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Cc: akpm@linux-foundation.org, cyphar@cyphar.com, dhowells@redhat.com, ebiederm@xmission.com, elena.reshetova@intel.com, keescook@chromium.org, luto@amacapital.net, luto@kernel.org, tglx@linutronix.de, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, joel@joelfernandes.org, dancol@google.com, serge@hallyn.com, surenb@google.com, kernel-team@android.com, Christian Brauner <christian@brauner.io>, Michael Kerrisk (man-pages)
List-Id: linux-api@vger.kernel.org

This adds testing for the new pidfd_open() syscalls. Specifically, we test:
- that no invalid flags can be passed to pidfd_open()
- that no invalid pid can be passed to pidfd_open()
- that a pidfd can be retrieved with pidfd_open()
- that the retrieved pidfd references the correct pid

Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org
---
v1: unchanged
v2:
- Christian Brauner <christian@brauner.io>:
  - set number of planned tests via ksft_set_plan()
v3: unchanged
---
 tools/testing/selftests/pidfd/.gitignore      |   1 +
 tools/testing/selftests/pidfd/Makefile        |   2 +-
 tools/testing/selftests/pidfd/pidfd.h         |  57 ++++++
 .../testing/selftests/pidfd/pidfd_open_test.c | 169 ++++++++++++++++++
 tools/testing/selftests/pidfd/pidfd_test.c    |  41 +----
 5 files changed, 229 insertions(+), 41 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd.h
 create mode 100644 tools/testing/selftests/pidfd/pidfd_open_test.c

diff --git a/tools/testing/selftests/pidfd/.gitignore b/tools/testing/selftests/pidfd/.gitignore
index 822a1e63d045..16d84d117bc0 100644
--- a/tools/testing/selftests/pidfd/.gitignore
+++ b/tools/testing/selftests/pidfd/.gitignore
@@ -1 +1,2 @@
+pidfd_open_test
 pidfd_test
diff --git a/tools/testing/selftests/pidfd/Makefile b/tools/testing/selftests/pidfd/Makefile
index deaf8073bc06..b36c0be70848 100644
--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,6 +1,6 @@
 CFLAGS += -g -I../../../../usr/include/
 
-TEST_GEN_PROGS := pidfd_test
+TEST_GEN_PROGS := pidfd_test pidfd_open_test
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/pidfd/pidfd.h b/tools/testing/selftests/pidfd/pidfd.h
new file mode 100644
index 000000000000..8452e910463f
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __PIDFD_H
+#define __PIDFD_H
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <sys/mount.h>
+
+#include "../kselftest.h"
+
+/*
+ * The kernel reserves 300 pids via RESERVED_PIDS in kernel/pid.c
+ * That means, when it wraps around any pid < 300 will be skipped.
+ * So we need to use a pid > 300 in order to test recycling.
+ */
+#define PID_RECYCLE 1000
+
+/*
+ * Define a few custom error codes for the child process to clearly indicate
+ * what is happening. This way we can tell the difference between a system
+ * error, a test error, etc.
+ */
+#define PIDFD_PASS 0
+#define PIDFD_FAIL 1
+#define PIDFD_ERROR 2
+#define PIDFD_SKIP 3
+#define PIDFD_XFAIL 4
+
+int wait_for_pid(pid_t pid)
+{
+	int status, ret;
+
+again:
+	ret = waitpid(pid, &status, 0);
+	if (ret == -1) {
+		if (errno == EINTR)
+			goto again;
+
+		return -1;
+	}
+
+	if (!WIFEXITED(status))
+		return -1;
+
+	return WEXITSTATUS(status);
+}
+
+
+#endif /* __PIDFD_H */
diff --git a/tools/testing/selftests/pidfd/pidfd_open_test.c b/tools/testing/selftests/pidfd/pidfd_open_test.c
new file mode 100644
index 000000000000..0377133dd6dc
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_open_test.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <limits.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <sys/mount.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "pidfd.h"
+#include "../kselftest.h"
+
+static inline int sys_pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static int safe_int(const char *numstr, int *converted)
+{
+	char *err = NULL;
+	long sli;
+
+	errno = 0;
+	sli = strtol(numstr, &err, 0);
+	if (errno == ERANGE && (sli == LONG_MAX || sli == LONG_MIN))
+		return -ERANGE;
+
+	if (errno != 0 && sli == 0)
+		return -EINVAL;
+
+	if (err == numstr || *err != '\0')
+		return -EINVAL;
+
+	if (sli > INT_MAX || sli < INT_MIN)
+		return -ERANGE;
+
+	*converted = (int)sli;
+	return 0;
+}
+
+static int char_left_gc(const char *buffer, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (buffer[i] == ' ' ||
+		    buffer[i] == '\t')
+			continue;
+
+		return i;
+	}
+
+	return 0;
+}
+
+static int char_right_gc(const char *buffer, size_t len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		if (buffer[i] == ' '  ||
+		    buffer[i] == '\t' ||
+		    buffer[i] == '\n' ||
+		    buffer[i] == '\0')
+			continue;
+
+		return i + 1;
+	}
+
+	return 0;
+}
+
+static char *trim_whitespace_in_place(char *buffer)
+{
+	buffer += char_left_gc(buffer, strlen(buffer));
+	buffer[char_right_gc(buffer, strlen(buffer))] = '\0';
+	return buffer;
+}
+
+static pid_t get_pid_from_fdinfo_file(int pidfd, const char *key, size_t keylen)
+{
+	int ret;
+	char path[512];
+	FILE *f;
+	size_t n = 0;
+	pid_t result = -1;
+	char *line = NULL;
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
+
+	f = fopen(path, "re");
+	if (!f)
+		return -1;
+
+	while (getline(&line, &n, f) != -1) {
+		char *numstr;
+
+		if (strncmp(line, key, keylen))
+			continue;
+
+		numstr = trim_whitespace_in_place(line + 4);
+		ret = safe_int(numstr, &result);
+		if (ret < 0)
+			goto out;
+
+		break;
+	}
+
+out:
+	free(line);
+	fclose(f);
+	return result;
+}
+
+int main(int argc, char **argv)
+{
+	int pidfd = -1, ret = 1;
+	pid_t pid;
+
+	ksft_set_plan(3);
+
+	pidfd = sys_pidfd_open(-1, 0);
+	if (pidfd >= 0) {
+		ksft_print_msg(
+			"%s - succeeded to open pidfd for invalid pid -1\n",
+			strerror(errno));
+		goto on_error;
+	}
+	ksft_test_result_pass("do not allow invalid pid test: passed\n");
+
+	pidfd = sys_pidfd_open(getpid(), 1);
+	if (pidfd >= 0) {
+		ksft_print_msg(
+			"%s - succeeded to open pidfd with invalid flag value specified\n",
+			strerror(errno));
+		goto on_error;
+	}
+	ksft_test_result_pass("do not allow invalid flag test: passed\n");
+
+	pidfd = sys_pidfd_open(getpid(), 0);
+	if (pidfd < 0) {
+		ksft_print_msg("%s - failed to open pidfd\n", strerror(errno));
+		goto on_error;
+	}
+	ksft_test_result_pass("open a new pidfd test: passed\n");
+
+	pid = get_pid_from_fdinfo_file(pidfd, "Pid:", sizeof("Pid:") - 1);
+	ksft_print_msg("pidfd %d refers to process with pid %d\n", pidfd, pid);
+
+	ret = 0;
+
+on_error:
+	if (pidfd >= 0)
+		close(pidfd);
+
+	return !ret ? ksft_exit_pass() : ksft_exit_fail();
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_test.c b/tools/testing/selftests/pidfd/pidfd_test.c
index 5bae1792e3d6..a03387052aa7 100644
--- a/tools/testing/selftests/pidfd/pidfd_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_test.c
@@ -14,6 +14,7 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#include "pidfd.h"
 #include "../kselftest.h"
 
 static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
@@ -62,28 +63,6 @@ static int test_pidfd_send_signal_simple_success(void)
 	return 0;
 }
 
-static int wait_for_pid(pid_t pid)
-{
-	int status, ret;
-
-again:
-	ret = waitpid(pid, &status, 0);
-	if (ret == -1) {
-		if (errno == EINTR)
-			goto again;
-
-		return -1;
-	}
-
-	if (ret != pid)
-		goto again;
-
-	if (!WIFEXITED(status))
-		return -1;
-
-	return WEXITSTATUS(status);
-}
-
 static int test_pidfd_send_signal_exited_fail(void)
 {
 	int pidfd, ret, saved_errno;
@@ -128,13 +107,6 @@ static int test_pidfd_send_signal_exited_fail(void)
 	return 0;
 }
 
-/*
- * The kernel reserves 300 pids via RESERVED_PIDS in kernel/pid.c
- * That means, when it wraps around any pid < 300 will be skipped.
- * So we need to use a pid > 300 in order to test recycling.
- */
-#define PID_RECYCLE 1000
-
 /*
  * Maximum number of cycles we allow. This is equivalent to PID_MAX_DEFAULT.
  * If users set a higher limit or we have cycled PIDFD_MAX_DEFAULT number of
@@ -143,17 +115,6 @@ static int test_pidfd_send_signal_exited_fail(void)
  */
 #define PIDFD_MAX_DEFAULT 0x8000
 
-/*
- * Define a few custom error codes for the child process to clearly indicate
- * what is happening. This way we can tell the difference between a system
- * error, a test error, etc.
- */
-#define PIDFD_PASS 0
-#define PIDFD_FAIL 1
-#define PIDFD_ERROR 2
-#define PIDFD_SKIP 3
-#define PIDFD_XFAIL 4
-
 static int test_pidfd_send_signal_recycled_pid_fail(void)
 {
 	int i, ret;
-- 
2.21.0
