From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 18/20] selftest/timens: Add test for clock_nanosleep
Date: Wed, 19 Sep 2018 21:50:35 +0100
Message-ID: <20180919205037.9574-19-dima@arista.com>
References: <20180919205037.9574-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919205037.9574-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

Check that clock_nanosleep() takes into account clock offsets.

Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/timens/.gitignore        |  1 +
 tools/testing/selftests/timens/Makefile          |  2 +-
 tools/testing/selftests/timens/clock_nanosleep.c | 98 ++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/timens/clock_nanosleep.c

diff --git a/tools/testing/selftests/timens/.gitignore b/tools/testing/selftests/timens/.gitignore
index b609f6ee9fb9..9b6c8ddac2c8 100644
--- a/tools/testing/selftests/timens/.gitignore
+++ b/tools/testing/selftests/timens/.gitignore
@@ -1,2 +1,3 @@
+clock_nanosleep
 timens
 timerfd
diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
index 66b90cd28e5c..76a1dc891184 100644
--- a/tools/testing/selftests/timens/Makefile
+++ b/tools/testing/selftests/timens/Makefile
@@ -1,4 +1,4 @@
-TEST_GEN_PROGS := timens timerfd
+TEST_GEN_PROGS := timens timerfd clock_nanosleep
 
 CFLAGS := -Wall -Werror
 
diff --git a/tools/testing/selftests/timens/clock_nanosleep.c b/tools/testing/selftests/timens/clock_nanosleep.c
new file mode 100644
index 000000000000..5af780b4cfe0
--- /dev/null
+++ b/tools/testing/selftests/timens/clock_nanosleep.c
@@ -0,0 +1,98 @@
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
+#define CLONE_NEWTIME   0x00001000
+#endif
+
+static long long get_elapsed_time(int clockid, struct timespec *start)
+{
+	struct timespec curr;
+	long long secs, nsecs;
+
+	if (clock_gettime(clockid, &curr) == -1)
+		return pr_perror("clock_gettime");
+
+	secs = curr.tv_sec - start->tv_sec;
+	nsecs = curr.tv_nsec - start->tv_nsec;
+	if (nsecs < 0) {
+		secs--;
+		nsecs += 1000000000;
+	}
+	if (nsecs > 1000000000) {
+		secs++;
+		nsecs -= 1000000000;
+	}
+	return secs * 1000 + nsecs / 1000000;
+}
+
+int run_test(int clockid)
+{
+	long long elapsed;
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		struct timespec now = {};
+		struct timespec start;
+
+		if (clock_gettime(clockid, &start) == -1)
+			return pr_perror("clock_gettime");
+
+
+		if (i == 1) {
+			now.tv_sec = start.tv_sec;
+			now.tv_nsec = start.tv_nsec;
+		}
+
+		printf("clock_nanosleep: %d\n", clockid);
+		now.tv_sec += 2;
+		clock_nanosleep(clockid, i ? TIMER_ABSTIME : 0, &now, NULL);
+
+		elapsed = get_elapsed_time(clockid, &start);
+		if (elapsed < 1900 || elapsed > 2100) {
+			pr_fail("elapsed %lld\n", elapsed);
+			return 1;
+		}
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
+		return pr_perror("unshare");;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &tp))
+		return pr_perror("clock_gettime");
+	tp.tv_sec += 7 * 24 * 3600;
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
+	ret |= run_test(CLOCK_MONOTONIC);
+	return ret;
+}
+
-- 
2.13.6
