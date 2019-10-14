From: Christian Kellner <ckellner@redhat.com>
Subject: [PATCH v4 2/2] pidfd: add tests for NSpid info in fdinfo
Date: Mon, 14 Oct 2019 18:20:33 +0200
Message-ID: <20191014162034.2185-2-ckellner@redhat.com>
References: <20191011122323.7770-1-ckellner@redhat.com>
 <20191014162034.2185-1-ckellner@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191014162034.2185-1-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Christian Kellner <christian@kellner.me>, Christian Brauner <christian@brauner.io>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Christian Kellner <christian@kellner.me>

Add a test that checks that if pid namespaces are configured the fdinfo
file of a pidfd contains an NSpid: entry containing the process id in
the current and additionally all nested namespaces. In the case that
a pidfd is from a pid namespace not in the same namespace hierarchy as
the process accessing the fdinfo file, ensure the 'NSpid' shows 0 for
that pidfd, analogous to the 'Pid' entry.

Signed-off-by: Christian Kellner <christian@kellner.me>
---
Changes in v4:
- Rework to test include a the situation where the fdinfo for a pidfd
  of a process in a sibling pid namespace is being read and ensure
  the NSpid field only contains one entry, being 0.

 tools/testing/selftests/pidfd/Makefile        |   2 +-
 .../selftests/pidfd/pidfd_fdinfo_test.c       | 265 ++++++++++++++++++
 2 files changed, 266 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd_fdinfo_test.c

diff --git a/tools/testing/selftests/pidfd/Makefile b/tools/testing/selftests/pidfd/Makefile
index 7550f08822a3..43db1b98e845 100644
--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -g -I../../../../usr/include/ -pthread
 
-TEST_GEN_PROGS := pidfd_test pidfd_open_test pidfd_poll_test pidfd_wait
+TEST_GEN_PROGS := pidfd_test pidfd_fdinfo_test pidfd_open_test pidfd_poll_test pidfd_wait
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
new file mode 100644
index 000000000000..3721be994abd
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/types.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <sys/wait.h>
+
+#include "pidfd.h"
+#include "../kselftest.h"
+
+struct error {
+	int  code;
+	char msg[512];
+};
+
+static int error_set(struct error *err, int code, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	if (code == PIDFD_PASS || !err || err->code != PIDFD_PASS)
+		return code;
+
+	err->code = code;
+	va_start(args, fmt);
+	r = vsnprintf(err->msg, sizeof(err->msg), fmt, args);
+	assert((size_t)r < sizeof(err->msg));
+	va_end(args);
+
+	return code;
+}
+
+static void error_report(struct error *err, const char *test_name)
+{
+	switch (err->code) {
+	case PIDFD_ERROR:
+		ksft_exit_fail_msg("%s test: Fatal: %s\n", test_name, err->msg);
+		break;
+
+	case PIDFD_FAIL:
+		/* will be: not ok %d # error %s test: %s */
+		ksft_test_result_error("%s test: %s\n", test_name, err->msg);
+		break;
+
+	case PIDFD_SKIP:
+		/* will be: not ok %d # SKIP %s test: %s */
+		ksft_test_result_skip("%s test: %s\n", test_name, err->msg);
+		break;
+
+	case PIDFD_XFAIL:
+		ksft_test_result_pass("%s test: Expected failure: %s\n",
+				      test_name, err->msg);
+		break;
+
+	case PIDFD_PASS:
+		ksft_test_result_pass("%s test: Passed\n");
+		break;
+
+	default:
+		ksft_exit_fail_msg("%s test: Unknown code: %d %s\n",
+				   test_name, err->code, err->msg);
+		break;
+	}
+}
+
+static inline int error_check(struct error *err, const char *test_name)
+{
+	/* In case of error we bail out and terminate the test program */
+	if (err->code == PIDFD_ERROR)
+		error_report(err, test_name);
+
+	return err->code;
+}
+
+struct child {
+	pid_t pid;
+	int   fd;
+};
+
+static struct child clone_newns(int (*fn)(void *), void *args,
+				struct error *err)
+{
+	static int flags = CLONE_PIDFD | CLONE_NEWPID | CLONE_NEWNS | SIGCHLD;
+	size_t stack_size = 1024;
+	char *stack[1024] = { 0 };
+	struct child ret;
+
+	if (!(flags & CLONE_NEWUSER) && geteuid() != 0)
+		flags |= CLONE_NEWUSER;
+
+#ifdef __ia64__
+	ret.pid = __clone2(fn, stack, stack_size, flags, args, &ret.fd);
+#else
+	ret.pid = clone(fn, stack + stack_size, flags, args, &ret.fd);
+#endif
+
+	if (ret.pid < 0) {
+		error_set(err, PIDFD_ERROR, "clone failed (ret %d, errno %d)",
+			  ret.fd, errno);
+		return ret;
+	}
+
+	ksft_print_msg("New child: %d, fd: %d\n", ret.pid, ret.fd);
+
+	return ret;
+}
+
+static inline int child_join(struct child *child, struct error *err)
+{
+	int r;
+
+	(void)close(child->fd);
+	r = wait_for_pid(child->pid);
+	if (r < 0)
+		error_set(err, PIDFD_ERROR, "waitpid failed (ret %d, errno %d)",
+			  r, errno);
+	else if (r > 0)
+		error_set(err, r, "child %d reported: %d", child->pid, r);
+
+	return r;
+}
+
+static inline void trim_newline(char *str)
+{
+	char *pos = strrchr(str, '\n');
+
+	if (pos)
+		*pos = '\0';
+}
+
+static int verify_fdinfo_nspid(int pidfd, struct error *err,
+			       const char *expect, ...)
+{
+	char buffer[512] = {0, };
+	char path[512] = {0, };
+	va_list args;
+	FILE *f;
+	char *line = NULL;
+	size_t n = 0;
+	int found = 0;
+	int r;
+
+	va_start(args, expect);
+	r = vsnprintf(buffer, sizeof(buffer), expect, args);
+	assert((size_t)r < sizeof(buffer));
+	va_end(args);
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
+	f = fopen(path, "re");
+	if (!f)
+		return error_set(err, PIDFD_ERROR, "fdinfo open failed for %d",
+				 pidfd);
+
+	while (getline(&line, &n, f) != -1) {
+		if (strncmp(line, "NSpid:", 6))
+			continue;
+
+		found = 1;
+
+		r = strcmp(line + 6, buffer);
+		if (r != 0) {
+			trim_newline(line);
+			trim_newline(buffer);
+			error_set(err, PIDFD_FAIL, "NSpid: '%s' != '%s'",
+				  line + 6, buffer);
+		}
+		break;
+	}
+
+	free(line);
+	fclose(f);
+
+	if (found == 0)
+		return error_set(err, PIDFD_FAIL, "NSpid not found for fd %d",
+				 pidfd);
+
+	return PIDFD_PASS;
+}
+
+static int child_fdinfo_nspid_test(void *args)
+{
+	struct error err;
+	int pidfd;
+	int r;
+
+	/* if we got no fd for the sibling, we are done */
+	if (!args)
+		return PIDFD_PASS;
+
+	/* verify that we can not resolve the pidfd for a process
+	 * in a sibling pid namespace, i.e. a pid namespace it is
+	 * not in our or a descended namespace
+	 */
+	r = mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, 0);
+	if (r < 0) {
+		ksft_print_msg("Failed to remount / private\n");
+		return PIDFD_ERROR;
+	}
+
+	(void)umount2("/proc", MNT_DETACH);
+	r = mount("proc", "/proc", "proc", 0, NULL);
+	if (r < 0) {
+		ksft_print_msg("Failed to remount /proc\n");
+		return PIDFD_ERROR;
+	}
+
+	pidfd = *(int *)args;
+	r = verify_fdinfo_nspid(pidfd, &err, "\t0\n");
+
+	if (r != PIDFD_PASS)
+		ksft_print_msg("NSpid fdinfo check failed: %s\n", err.msg);
+
+	return r;
+}
+
+static void test_pidfd_fdinfo_nspid(void)
+{
+	struct child a, b;
+	struct error err = {0, };
+	const char *test_name = "pidfd check for NSpid in fdinfo";
+
+	/* Create a new child in a new pid and mount namespace */
+	a = clone_newns(child_fdinfo_nspid_test, NULL, &err);
+	error_check(&err, test_name);
+
+	/* Pass the pidfd representing the first child to the
+	 * second child, which will be in a sibling pid namespace,
+	 * which means that the fdinfo NSpid entry for the pidfd
+	 * should only contain '0'.
+	 */
+	b = clone_newns(child_fdinfo_nspid_test, &a.fd, &err);
+	error_check(&err, test_name);
+
+	/* The children will have pid 1 in the new pid namespace,
+	 * so the line must be 'NSPid:\t<pid>\t1'.
+	 */
+	verify_fdinfo_nspid(a.fd, &err, "\t%d\t%d\n", a.pid, 1);
+	verify_fdinfo_nspid(b.fd, &err, "\t%d\t%d\n", b.pid, 1);
+
+	/* wait for the process, check the exit status and set
+	 * 'err' accordingly, if it is not already set.
+	 */
+	child_join(&a, &err);
+	child_join(&b, &err);
+
+	error_report(&err, test_name);
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	test_pidfd_fdinfo_nspid();
+
+	return ksft_exit_pass();
+}
-- 
2.21.0
