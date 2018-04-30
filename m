From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 11/14] rseq: selftests: Provide basic test
Date: Mon, 30 Apr 2018 18:44:30 -0400
Message-ID: <20180430224433.17407-12-mathieu.desnoyers@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuahkh@osg.sams>
List-Id: linux-api@vger.kernel.org

"basic_test" only asserts that RSEQ works moderately correctly. E.g.
that the CPUID pointer works.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Shuah Khan <shuahkh@osg.samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-kselftest@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 tools/testing/selftests/rseq/basic_test.c | 56 +++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/basic_test.c

diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 000000000000..d8efbfb89193
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Basic test coverage for critical regions and rseq_current_cpu().
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/time.h>
+
+#include "rseq.h"
+
+void test_cpu_pointer(void)
+{
+	cpu_set_t affinity, test_affinity;
+	int i;
+
+	sched_getaffinity(0, sizeof(affinity), &affinity);
+	CPU_ZERO(&test_affinity);
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (CPU_ISSET(i, &affinity)) {
+			CPU_SET(i, &test_affinity);
+			sched_setaffinity(0, sizeof(test_affinity),
+					&test_affinity);
+			assert(sched_getcpu() == i);
+			assert(rseq_current_cpu() == i);
+			assert(rseq_current_cpu_raw() == i);
+			assert(rseq_cpu_start() == i);
+			CPU_CLR(i, &test_affinity);
+		}
+	}
+	sched_setaffinity(0, sizeof(affinity), &affinity);
+}
+
+int main(int argc, char **argv)
+{
+	if (rseq_register_current_thread()) {
+		fprintf(stderr, "Error: rseq_register_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		goto init_thread_error;
+	}
+	printf("testing current cpu\n");
+	test_cpu_pointer();
+	if (rseq_unregister_current_thread()) {
+		fprintf(stderr, "Error: rseq_unregister_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		goto init_thread_error;
+	}
+	return 0;
+
+init_thread_error:
+	return -1;
+}
-- 
2.11.0
