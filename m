From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 16/20] selftest: Add Time Namespace test for supported clocks
Date: Wed, 19 Sep 2018 21:50:33 +0100
Message-ID: <20180919205037.9574-17-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This test checks that all supported clocks can be changed by
clock_settime.

Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Co-developed-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/timens/.gitignore |   1 +
 tools/testing/selftests/timens/Makefile   |   5 +
 tools/testing/selftests/timens/config     |   1 +
 tools/testing/selftests/timens/log.h      |  21 ++++
 tools/testing/selftests/timens/timens.c   | 196 ++++++++++++++++++++++++++++++
 5 files changed, 224 insertions(+)
 create mode 100644 tools/testing/selftests/timens/.gitignore
 create mode 100644 tools/testing/selftests/timens/Makefile
 create mode 100644 tools/testing/selftests/timens/config
 create mode 100644 tools/testing/selftests/timens/log.h
 create mode 100644 tools/testing/selftests/timens/timens.c

diff --git a/tools/testing/selftests/timens/.gitignore b/tools/testing/selftests/timens/.gitignore
new file mode 100644
index 000000000000..27a693229ce1
--- /dev/null
+++ b/tools/testing/selftests/timens/.gitignore
@@ -0,0 +1 @@
+timens
diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
new file mode 100644
index 000000000000..b877efb78974
--- /dev/null
+++ b/tools/testing/selftests/timens/Makefile
@@ -0,0 +1,5 @@
+TEST_GEN_PROGS := timens
+
+CFLAGS := -Wall -Werror
+
+include ../lib.mk
diff --git a/tools/testing/selftests/timens/config b/tools/testing/selftests/timens/config
new file mode 100644
index 000000000000..4480620f6f49
--- /dev/null
+++ b/tools/testing/selftests/timens/config
@@ -0,0 +1 @@
+CONFIG_TIME_NS=y
diff --git a/tools/testing/selftests/timens/log.h b/tools/testing/selftests/timens/log.h
new file mode 100644
index 000000000000..05fec7f97870
--- /dev/null
+++ b/tools/testing/selftests/timens/log.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __SELFTEST_TIMENS_LOG_H__
+#define __SELFTEST_TIMENS_LOG_H__
+
+#define pr_msg(fmt, lvl, ...)						\
+	fprintf(stderr, "[%s] (%s:%d)\t" fmt "\n",			\
+			lvl, __FILE__, __LINE__, ##__VA_ARGS__)
+
+#define pr_p(func, fmt, ...)	func(fmt ": %m", ##__VA_ARGS__)
+
+#define pr_err(fmt, ...)						\
+	({								\
+		pr_msg(fmt, "ERR", ##__VA_ARGS__)			\
+		-1;							\
+	})
+#define pr_fail(fmt, ...)	pr_msg(fmt, "FAIL", ##__VA_ARGS__)
+
+#define pr_perror(fmt, ...)	pr_p(pr_err, fmt, ##__VA_ARGS__)
+
+#endif
diff --git a/tools/testing/selftests/timens/timens.c b/tools/testing/selftests/timens/timens.c
new file mode 100644
index 000000000000..dfa6701214b1
--- /dev/null
+++ b/tools/testing/selftests/timens/timens.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+#include <time.h>
+
+#include "log.h"
+
+#ifndef CLONE_NEWTIME
+# define CLONE_NEWTIME	0x00001000
+#endif
+
+/*
+ * Test shouldn't be run for a day, so add 10 days to child
+ * time and check parent's time to be in the same day.
+ */
+#define DAY_IN_SEC			(60*60*24)
+#define TEN_DAYS_IN_SEC			(10*DAY_IN_SEC)
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+#define CLOCK_TYPES							\
+	ct(CLOCK_BOOTTIME),						\
+	ct(CLOCK_MONOTONIC),						\
+	ct(CLOCK_MONOTONIC_COARSE),					\
+	ct(CLOCK_MONOTONIC_RAW),					\
+
+
+#define ct(clock)	clock
+static clockid_t clocks[] = {
+	CLOCK_TYPES
+};
+#undef ct
+#define ct(clock)	#clock
+static char *clock_names[] = {
+	CLOCK_TYPES
+};
+
+static int child_ns, parent_ns;
+
+static int switch_ns(int fd)
+{
+	if (setns(fd, CLONE_NEWTIME)) {
+		pr_perror("setns()");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int init_namespaces(void)
+{
+	char path[] = "/proc/self/ns/time";
+	struct stat st1, st2;
+
+	parent_ns = open(path, O_RDONLY);
+	if (parent_ns <= 0)
+		return pr_perror("Unable to open %s", path);
+
+	if (fstat(parent_ns, &st1))
+		return pr_perror("Unable to stat the parent timens");
+
+	if (unshare(CLONE_NEWTIME))
+		return pr_perror("Can't unshare() timens");
+
+	child_ns = open(path, O_RDONLY);
+	if (child_ns <= 0)
+		return pr_perror("Unable to open %s", path);
+
+	if (fstat(child_ns, &st2))
+		return pr_perror("Unable to stat the timens");
+
+	if (st1.st_ino == st2.st_ino)
+		return pr_perror("The same child_ns after CLONE_NEWTIME");
+
+	return 0;
+}
+
+static int _gettime(clockid_t clk_id, struct timespec *res, bool raw_syscall)
+{
+	int err;
+
+	if (!raw_syscall) {
+		if (clock_gettime(clk_id, res)) {
+			pr_perror("clock_gettime(%d)", (int)clk_id);
+			return -1;
+		}
+		return 0;
+	}
+
+	err = syscall(SYS_clock_gettime, clk_id, res);
+	if (err)
+		pr_perror("syscall(SYS_clock_gettime(%d))", (int)clk_id);
+
+	return err;
+}
+
+static int _settime(clockid_t clk_id, struct timespec *res, bool raw_syscall)
+{
+	int err;
+
+	if (!raw_syscall) {
+		if (clock_settime(clk_id, res))
+			return pr_perror("clock_settime(%d)", (int)clk_id);
+		return 0;
+	}
+
+	err = syscall(SYS_clock_settime, clk_id, res);
+	if (err)
+		pr_perror("syscall(SYS_clock_settime(%d))", (int)clk_id);
+
+	return err;
+}
+
+static int test_gettime(clockid_t clock_index, bool raw_syscall, time_t offset)
+{
+	struct timespec child_ts_new, parent_ts_old, cur_ts;
+	char *entry = raw_syscall ? "syscall" : "vdso";
+	double precision = 0.0;
+
+	switch (clocks[clock_index]) {
+	case CLOCK_MONOTONIC_COARSE:
+	case CLOCK_MONOTONIC_RAW:
+		precision = -2.0;
+		break;
+	}
+
+	if (switch_ns(parent_ns))
+		return pr_err("switch_ns(%d)", child_ns);
+
+	if (_gettime(clocks[clock_index], &parent_ts_old, raw_syscall))
+		return -1;
+
+	if (switch_ns(child_ns))
+		return pr_err("switch_ns(%d)", child_ns);
+
+	child_ts_new.tv_nsec = parent_ts_old.tv_nsec;
+	child_ts_new.tv_sec = parent_ts_old.tv_sec + offset;
+
+	if (_settime(clocks[clock_index], &child_ts_new, raw_syscall))
+		return -1;
+
+	if (_gettime(clocks[clock_index], &cur_ts, raw_syscall))
+		return -1;
+
+	if (difftime(cur_ts.tv_sec, child_ts_new.tv_sec) < precision) {
+		pr_fail("Child's %s (%s) time has not changed: %lu -> %lu [%lu]",
+			clock_names[clock_index], entry, parent_ts_old.tv_sec,
+			child_ts_new.tv_sec, cur_ts.tv_sec);
+		return -1;
+	}
+
+	if (switch_ns(parent_ns))
+		return pr_err("switch_ns(%d)", parent_ns);
+
+	if (_gettime(clocks[clock_index], &cur_ts, raw_syscall))
+		return -1;
+
+	if (difftime(cur_ts.tv_sec, parent_ts_old.tv_sec) > DAY_IN_SEC) {
+		pr_fail("Parent's %s (%s) time has changed: %lu -> %lu [%lu]",
+			clock_names[clock_index], entry, parent_ts_old.tv_sec,
+			child_ts_new.tv_sec, cur_ts.tv_sec);
+		/* Let's play nice and put it closer to original */
+		clock_settime(clocks[clock_index], &cur_ts);
+		return -1;
+	}
+
+	pr_msg("Passed for %s (%s)", "OK", clock_names[clock_index], entry);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int i;
+	int ret = 0;
+
+	if (init_namespaces())
+		return 1;
+
+	for (i = 0; i < ARRAY_SIZE(clocks); i++) {
+		ret |= test_gettime(i, true, TEN_DAYS_IN_SEC);
+		ret |= test_gettime(i, true, -TEN_DAYS_IN_SEC);
+		ret |= test_gettime(i, false, TEN_DAYS_IN_SEC);
+		ret |= test_gettime(i, false, -TEN_DAYS_IN_SEC);
+	}
+
+	return !!ret;
+}
-- 
2.13.6
