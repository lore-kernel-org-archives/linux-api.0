From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 17/20] selftest/timens: Add test for timerfd
Date: Wed, 19 Sep 2018 21:50:34 +0100
Message-ID: <20180919205037.9574-18-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Check that timerfd_create takes into account clock offsets.

Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/timens/.gitignore |  1 +
 tools/testing/selftests/timens/Makefile   |  2 +-
 tools/testing/selftests/timens/timerfd.c  | 96 +++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/timens/timerfd.c

diff --git a/tools/testing/selftests/timens/.gitignore b/tools/testing/selftests/timens/.gitignore
index 27a693229ce1..b609f6ee9fb9 100644
--- a/tools/testing/selftests/timens/.gitignore
+++ b/tools/testing/selftests/timens/.gitignore
@@ -1 +1,2 @@
 timens
+timerfd
diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
index b877efb78974..66b90cd28e5c 100644
--- a/tools/testing/selftests/timens/Makefile
+++ b/tools/testing/selftests/timens/Makefile
@@ -1,4 +1,4 @@
-TEST_GEN_PROGS := timens
+TEST_GEN_PROGS := timens timerfd
 
 CFLAGS := -Wall -Werror
 
diff --git a/tools/testing/selftests/timens/timerfd.c b/tools/testing/selftests/timens/timerfd.c
new file mode 100644
index 000000000000..914a4cd9a0df
--- /dev/null
+++ b/tools/testing/selftests/timens/timerfd.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <sys/timerfd.h>
+#include <sys/syscall.h>
+#include <time.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+
+#include "log.h"
+
+#ifndef CLONE_NEWTIME
+# define CLONE_NEWTIME	0x00001000
+#endif
+
+int run_test(int clockid)
+{
+	struct itimerspec new_value;
+	struct timespec now;
+	long long elapsed;
+	int fd, i;
+
+	if (clock_gettime(clockid, &now))
+		return pr_perror("clock_gettime");
+
+	for (i = 0; i < 2; i++) {
+		int flags = 0;
+
+		pr_msg("timerfd_settime: %d", "INFO", clockid);
+		new_value.it_value.tv_sec = 3600;
+		new_value.it_value.tv_nsec = 0;
+		new_value.it_interval.tv_sec = 1;
+		new_value.it_interval.tv_nsec = 0;
+
+		if (i == 1) {
+			new_value.it_value.tv_sec += now.tv_sec;
+			new_value.it_value.tv_nsec += now.tv_nsec;
+		}
+
+		fd = timerfd_create(clockid, 0);
+		if (fd == -1)
+			return pr_perror("timerfd_create");
+
+		if (i == 1)
+			flags |= TFD_TIMER_ABSTIME;
+
+		if (timerfd_settime(fd, flags, &new_value, NULL))
+			return pr_perror("timerfd_settime");
+
+		if (timerfd_gettime(fd, &new_value))
+			return pr_perror("timerfd_gettime");
+
+		elapsed = new_value.it_value.tv_sec;
+		if (abs(elapsed - 3600) > 60) {
+			printf("FAIL\n");
+			return 1;
+		}
+
+		close(fd);
+	}
+
+	printf("PASS\n");
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct timespec tp;
+	int ret;
+
+	if (unshare(CLONE_NEWTIME))
+		return pr_perror("unshare");
+
+	if (clock_gettime(CLOCK_MONOTONIC, &tp))
+		return pr_perror("clock_gettime");
+	tp.tv_sec = 7 * 24 * 3600;
+	if (clock_settime(CLOCK_MONOTONIC, &tp))
+		return pr_perror("clock_settime");
+
+	if (clock_gettime(CLOCK_BOOTTIME, &tp))
+		return pr_perror("clock_gettime");
+	tp.tv_sec += 9 * 24 * 3600;
+	tp.tv_nsec = 0;
+	if (clock_settime(CLOCK_BOOTTIME, &tp))
+		return pr_perror("clock_settime");
+
+	ret = 0;
+	ret |= run_test(CLOCK_BOOTTIME);
+	ret |= run_test(CLOCK_MONOTONIC);
+	return ret;
+}
+
-- 
2.13.6
