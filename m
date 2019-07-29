From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv5 37/37] selftest/timens: Check that a right vdso is mapped after fork and exec
Date: Mon, 29 Jul 2019 22:57:19 +0100
Message-ID: <20190729215758.28405-38-dima@arista.com>
References: <20190729215758.28405-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/timens/.gitignore |  1 +
 tools/testing/selftests/timens/Makefile   |  2 +-
 tools/testing/selftests/timens/exec.c     | 93 +++++++++++++++++++++++
 3 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/timens/exec.c

diff --git a/tools/testing/selftests/timens/.gitignore b/tools/testing/selftests/timens/.gitignore
index 16292e4d08a5..789f21e81028 100644
--- a/tools/testing/selftests/timens/.gitignore
+++ b/tools/testing/selftests/timens/.gitignore
@@ -1,4 +1,5 @@
 clock_nanosleep
+exec
 gettime_perf
 gettime_perf_cold
 procfs
diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
index 97e0460eaf48..b77fe22fa24d 100644
--- a/tools/testing/selftests/timens/Makefile
+++ b/tools/testing/selftests/timens/Makefile
@@ -1,4 +1,4 @@
-TEST_GEN_PROGS := timens timerfd timer clock_nanosleep procfs gettime_perf
+TEST_GEN_PROGS := timens timerfd timer clock_nanosleep procfs gettime_perf exec
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
diff --git a/tools/testing/selftests/timens/exec.c b/tools/testing/selftests/timens/exec.c
new file mode 100644
index 000000000000..de7798832429
--- /dev/null
+++ b/tools/testing/selftests/timens/exec.c
@@ -0,0 +1,93 @@
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
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+#include <time.h>
+#include <string.h>
+
+#include "log.h"
+#include "timens.h"
+
+#define OFFSET (36000)
+
+int main(int argc, char *argv[])
+{
+	struct timespec now, tst;
+	int status, i;
+	pid_t pid;
+
+	if (argc > 1) {
+		if (sscanf(argv[1], "%ld", &now.tv_sec) != 1)
+			return pr_perror("sscanf");
+
+		for (i = 0; i < 2; i++) {
+			_gettime(CLOCK_MONOTONIC, &tst, i);
+			if (abs(tst.tv_sec - now.tv_sec) > 5)
+				return pr_fail("%ld %ld\n", now.tv_sec, tst.tv_sec);
+		}
+	}
+
+	nscheck();
+
+	ksft_set_plan(1);
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+
+	if (unshare(CLONE_NEWTIME))
+		return pr_perror("Can't unshare() timens");
+
+	if (_settime(CLOCK_MONOTONIC, OFFSET))
+		return 1;
+
+	for (i = 0; i < 2; i++) {
+		_gettime(CLOCK_MONOTONIC, &tst, i);
+		if (abs(tst.tv_sec - now.tv_sec) > 5)
+			return pr_fail("%ld %ld\n",
+					now.tv_sec, tst.tv_sec);
+	}
+
+	if (argc > 1)
+		return 0;
+
+	pid = fork();
+	if (pid < 0)
+		return pr_perror("fork");
+
+	if (pid == 0) {
+		char now_str[64];
+		char *cargv[] = {"exec", now_str, NULL};
+		char *cenv[] = {NULL};
+
+		/* Check that a child process is in the new timens. */
+		for (i = 0; i < 2; i++) {
+			_gettime(CLOCK_MONOTONIC, &tst, i);
+			if (abs(tst.tv_sec - now.tv_sec - OFFSET) > 5)
+				return pr_fail("%ld %ld\n",
+						now.tv_sec + OFFSET, tst.tv_sec);
+		}
+
+		/* Check that a proper vdso will be mapped after execve. */
+		snprintf(now_str, sizeof(now_str), "%ld", now.tv_sec + OFFSET);
+		execve("/proc/self/exe", cargv, cenv);
+		return pr_perror("execve");
+	}
+
+	if (waitpid(pid, &status, 0) != pid)
+		return pr_perror("waitpid");
+
+	if (status)
+		ksft_exit_fail();
+
+	ksft_test_result_pass("exec\n");
+	ksft_exit_pass();
+	return 0;
+}
-- 
2.22.0
