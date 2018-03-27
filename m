From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.17 15/21] cpu_opv: selftests: Implement selftests (v7)
Date: Tue, 27 Mar 2018 12:05:36 -0400
Message-ID: <20180327160542.28457-16-mathieu.desnoyers@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implement cpu_opv selftests. It needs to express dependencies on
header files and .so, which require to override the selftests
lib.mk targets. Use OVERRIDE_TARGETS define for this.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
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
Changes since v1:

- Expose similar library API as rseq:  Expose library API closely
  matching the rseq APIs, following removal of the event counter from
  the rseq kernel API.
- Update makefile to fix make run_tests dependency on "all".
- Introduce a OVERRIDE_TARGETS.

Changes since v2:

- Test page faults.

Changes since v3:

- Move lib.mk OVERRIDE_TARGETS change to its own patch.
- Printout TAP output.

Changes since v4:

- Retry internally within cpu_op_cmpnev_storeoffp_load().

Changes since v5:

- Test huge pages.

Change since v6:

- Test CPU_OP_NR_FLAG,
- Invoke ksft_test_result_fail rather than ksft_exit_fail_msg,
- Test CPU parameter outside of possible CPUs range,
- Test CPU parameter outside of allowed CPUs.
---
 MAINTAINERS                                        |    1 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/cpu-opv/.gitignore         |    1 +
 tools/testing/selftests/cpu-opv/Makefile           |   17 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 1368 ++++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           |  352 +++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |   59 +
 7 files changed, 1799 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-opv/.gitignore
 create mode 100644 tools/testing/selftests/cpu-opv/Makefile
 create mode 100644 tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e32d4415081b..936ff672d5fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3749,6 +3749,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	kernel/cpu_opv.c
 F:	include/uapi/linux/cpu_opv.h
+F:	tools/testing/selftests/cpu-opv/
 
 CRAMFS FILESYSTEM
 M:	Nicolas Pitre <nico@linaro.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 7442dfb73b7f..1322e63f5963 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -5,6 +5,7 @@ TARGETS += breakpoints
 TARGETS += capabilities
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += cpu-opv
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += firmware
diff --git a/tools/testing/selftests/cpu-opv/.gitignore b/tools/testing/selftests/cpu-opv/.gitignore
new file mode 100644
index 000000000000..c7186eb95cf5
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/.gitignore
@@ -0,0 +1 @@
+basic_cpu_opv_test
diff --git a/tools/testing/selftests/cpu-opv/Makefile b/tools/testing/selftests/cpu-opv/Makefile
new file mode 100644
index 000000000000..21e63545d521
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/Makefile
@@ -0,0 +1,17 @@
+CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./
+
+# Own dependencies because we only want to build against 1st prerequisite, but
+# still track changes to header files and depend on shared object.
+OVERRIDE_TARGETS = 1
+
+TEST_GEN_PROGS = basic_cpu_opv_test
+
+TEST_GEN_PROGS_EXTENDED = libcpu-op.so
+
+include ../lib.mk
+
+$(OUTPUT)/libcpu-op.so: cpu-op.c cpu-op.h
+	$(CC) $(CFLAGS) -shared -fPIC $< -o $@
+
+$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) cpu-op.h
+	$(CC) $(CFLAGS) $< -lcpu-op -o $@
diff --git a/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c b/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
new file mode 100644
index 000000000000..792b68f4f330
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
@@ -0,0 +1,1368 @@
+/*
+ * Basic test coverage for cpu_opv system call.
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <sys/mman.h>
+#include <sched.h>
+
+#include "../kselftest.h"
+
+#include "cpu-op.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+#define TESTBUFLEN	4096
+#define TESTBUFLEN_CMP	16
+
+#define TESTBUFLEN_PAGE_MAX	65536
+
+#define NR_PF_ARRAY	16384
+#define PF_ARRAY_LEN	4096
+
+#define NR_HUGE_ARRAY	512
+#define HUGEMAPLEN	(NR_HUGE_ARRAY * PF_ARRAY_LEN)
+
+/* 64 MB arrays for page fault testing. */
+char pf_array_dst[NR_PF_ARRAY][PF_ARRAY_LEN];
+char pf_array_src[NR_PF_ARRAY][PF_ARRAY_LEN];
+
+static int test_ops_supported(void)
+{
+	const char *test_name = "test_ops_supported";
+	int ret;
+
+	ret = cpu_opv(NULL, 0, -1, CPU_OP_NR_FLAG);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret < NR_CPU_OPS) {
+		ksft_test_result_fail("%s test: only %d operations supported, expecting at least %d\n",
+				      test_name, ret, NR_CPU_OPS);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_compare_eq_op(char *a, char *b, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, a),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, b),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_compare_eq_same(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_compare_eq same";
+
+	/* Test compare_eq */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf2[i] = (char)i;
+	ret = test_compare_eq_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret > 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 0);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_compare_eq_diff(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_compare_eq different";
+
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_compare_eq_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret == 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 1);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_compare_ne_op(char *a, char *b, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_NE_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, a),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, b),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_compare_ne_same(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_compare_ne same";
+
+	/* Test compare_ne */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf2[i] = (char)i;
+	ret = test_compare_ne_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret == 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 1);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_compare_ne_diff(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_compare_ne different";
+
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_compare_ne_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 0);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_2compare_eq_op(char *a, char *b, char *c, char *d,
+		size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, a),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, b),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, c),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, d),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_2compare_eq_index(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN_CMP];
+	char buf2[TESTBUFLEN_CMP];
+	char buf3[TESTBUFLEN_CMP];
+	char buf4[TESTBUFLEN_CMP];
+	const char *test_name = "test_2compare_eq index";
+
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN_CMP);
+	memset(buf3, 0, TESTBUFLEN_CMP);
+	memset(buf4, 0, TESTBUFLEN_CMP);
+
+	/* First compare failure is op[0], expect 1. */
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 1) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 1);
+		return -1;
+	}
+
+	/* All compares succeed. */
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf2[i] = (char)i;
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 0);
+		return -1;
+	}
+
+	/* First compare failure is op[1], expect 2. */
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf3[i] = (char)i;
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 2) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 2);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_2compare_ne_op(char *a, char *b, char *c, char *d,
+		size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_NE_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, a),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, b),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_NE_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.a, c),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.compare_op.b, d),
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_2compare_ne_index(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN_CMP];
+	char buf2[TESTBUFLEN_CMP];
+	char buf3[TESTBUFLEN_CMP];
+	char buf4[TESTBUFLEN_CMP];
+	const char *test_name = "test_2compare_ne index";
+
+	memset(buf1, 0, TESTBUFLEN_CMP);
+	memset(buf2, 0, TESTBUFLEN_CMP);
+	memset(buf3, 0, TESTBUFLEN_CMP);
+	memset(buf4, 0, TESTBUFLEN_CMP);
+
+	/* First compare ne failure is op[0], expect 1. */
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 1) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 1);
+		return -1;
+	}
+
+	/* All compare ne succeed. */
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf3[i] = (char)i;
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 0) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 0);
+		return -1;
+	}
+
+	/* First compare failure is op[1], expect 2. */
+	for (i = 0; i < TESTBUFLEN_CMP; i++)
+		buf4[i] = (char)i;
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN_CMP);
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret != 2) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, ret, 2);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_memcpy_op(void *dst, void *src, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src),
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_memcpy(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_memcpy";
+
+	/* Test memcpy */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_memcpy_op(buf2, buf1, TESTBUFLEN);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	for (i = 0; i < TESTBUFLEN; i++) {
+		if (buf2[i] != (char)i) {
+			ksft_test_result_fail("%s test: unexpected value at offset %d. Found %d. Should be %d.\n",
+					      test_name, i, buf2[i], (char)i);
+			return -1;
+		}
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_memcpy_u32(void)
+{
+	int ret;
+	uint32_t v1, v2;
+	const char *test_name = "test_memcpy_u32";
+
+	/* Test memcpy_u32 */
+	v1 = 42;
+	v2 = 0;
+	ret = test_memcpy_op(&v2, &v1, sizeof(v1));
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v1 != v2) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v2, v1);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_memcpy_mb_memcpy_op(void *dst1, void *src1,
+		void *dst2, void *src2, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst1),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src1),
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[1] = {
+			.op = CPU_MB_OP,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst2),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src2),
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_memcpy_mb_memcpy(void)
+{
+	int ret;
+	int v1, v2, v3;
+	const char *test_name = "test_memcpy_mb_memcpy";
+
+	/* Test memcpy */
+	v1 = 42;
+	v2 = v3 = 0;
+	ret = test_memcpy_mb_memcpy_op(&v2, &v1, &v3, &v2, sizeof(int));
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v3 != v1) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v3, v1);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_add_op(int *v, int64_t increment)
+{
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_op_add(v, increment, sizeof(*v), cpu);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_add(void)
+{
+	int orig_v = 42, v, ret;
+	int increment = 1;
+	const char *test_name = "test_add";
+
+	v = orig_v;
+	ret = test_add_op(&v, increment);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != orig_v + increment) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v,
+				      orig_v + increment);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_two_add_op(int *v, int64_t *increments)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_ADD_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.arithmetic_op.p, v),
+			.u.arithmetic_op.count = increments[0],
+			.u.arithmetic_op.expect_fault_p = 0,
+		},
+		[1] = {
+			.op = CPU_ADD_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.arithmetic_op.p, v),
+			.u.arithmetic_op.count = increments[1],
+			.u.arithmetic_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_two_add(void)
+{
+	int orig_v = 42, v, ret;
+	int64_t increments[2] = { 99, 123 };
+	const char *test_name = "test_two_add";
+
+	v = orig_v;
+	ret = test_two_add_op(&v, increments);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != orig_v + increments[0] + increments[1]) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v,
+				      orig_v + increments[0] + increments[1]);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_or_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_OR_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.bitwise_op.p, v),
+			.u.bitwise_op.mask = mask,
+			.u.bitwise_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_or(void)
+{
+	int orig_v = 0xFF00000, v, ret;
+	uint32_t mask = 0xFFF;
+	const char *test_name = "test_or";
+
+	v = orig_v;
+	ret = test_or_op(&v, mask);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v | mask)) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v, orig_v | mask);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_and_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_AND_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.bitwise_op.p, v),
+			.u.bitwise_op.mask = mask,
+			.u.bitwise_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_and(void)
+{
+	int orig_v = 0xF00, v, ret;
+	uint32_t mask = 0xFFF;
+	const char *test_name = "test_and";
+
+	v = orig_v;
+	ret = test_and_op(&v, mask);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v & mask)) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v, orig_v & mask);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_xor_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_XOR_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.bitwise_op.p, v),
+			.u.bitwise_op.mask = mask,
+			.u.bitwise_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_xor(void)
+{
+	int orig_v = 0xF00, v, ret;
+	uint32_t mask = 0xFFF;
+	const char *test_name = "test_xor";
+
+	v = orig_v;
+	ret = test_xor_op(&v, mask);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v ^ mask)) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v, orig_v ^ mask);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_lshift_op(int *v, uint32_t bits)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_LSHIFT_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.shift_op.p, v),
+			.u.shift_op.bits = bits,
+			.u.shift_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_lshift(void)
+{
+	int orig_v = 0xF00, v, ret;
+	uint32_t bits = 5;
+	const char *test_name = "test_lshift";
+
+	v = orig_v;
+	ret = test_lshift_op(&v, bits);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v << bits)) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v, orig_v << bits);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_rshift_op(int *v, uint32_t bits)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_RSHIFT_OP,
+			.len = sizeof(*v),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(
+				.u.shift_op.p, v),
+			.u.shift_op.bits = bits,
+			.u.shift_op.expect_fault_p = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_rshift(void)
+{
+	int orig_v = 0xF00, v, ret;
+	uint32_t bits = 5;
+	const char *test_name = "test_rshift";
+
+	v = orig_v;
+	ret = test_rshift_op(&v, bits);
+	if (ret) {
+		ksft_test_result_fail("%s test: returned with %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v >> bits)) {
+		ksft_test_result_fail("%s test: unexpected value %d. Should be %d.\n",
+				      test_name, v, orig_v >> bits);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_cmpxchg_op(void *v, void *expect, void *old, void *n,
+		size_t len)
+{
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_op_cmpxchg(v, expect, old, n, len, cpu);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_cmpxchg_success(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 1, old = 0, n = 3;
+	const char *test_name = "test_cmpxchg success";
+
+	v = orig_v;
+	ret = test_cmpxchg_op(&v, &expect, &old, &n, sizeof(uint64_t));
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret) {
+		ksft_test_result_fail("%s returned %d, expecting %d\n",
+				      test_name, ret, 0);
+		return -1;
+	}
+	if (v != n) {
+		ksft_test_result_fail("%s v is %lld, expecting %lld\n",
+				      test_name, (long long)v, (long long)n);
+		return -1;
+	}
+	if (old != orig_v) {
+		ksft_test_result_fail("%s old is %lld, expecting %lld\n",
+				      test_name, (long long)old,
+				      (long long)orig_v);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_cmpxchg_fail(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 123, old = 0, n = 3;
+	const char *test_name = "test_cmpxchg fail";
+
+	v = orig_v;
+	ret = test_cmpxchg_op(&v, &expect, &old, &n, sizeof(uint64_t));
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (ret == 0) {
+		ksft_test_result_fail("%s returned %d, expecting %d\n",
+				      test_name, ret, 1);
+		return -1;
+	}
+	if (v == n) {
+		ksft_test_result_fail("%s returned %lld, expecting %lld\n",
+				      test_name, (long long)v,
+				      (long long)orig_v);
+		return -1;
+	}
+	if (old != orig_v) {
+		ksft_test_result_fail("%s old is %lld, expecting %lld\n",
+				      test_name, (long long)old,
+				      (long long)orig_v);
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_memcpy_expect_fault_op(void *dst, void *src, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src),
+			.u.memcpy_op.expect_fault_dst = 0,
+			/* Return EAGAIN on fault. */
+			.u.memcpy_op.expect_fault_src = 1,
+		},
+	};
+	int cpu;
+
+	cpu = cpu_op_get_current_cpu();
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int test_memcpy_fault(void)
+{
+	int ret;
+	char buf1[TESTBUFLEN];
+	const char *test_name = "test_memcpy_fault";
+
+	/* Test memcpy */
+	ret = test_memcpy_op(buf1, NULL, TESTBUFLEN);
+	if (!ret || (ret < 0 && errno != EFAULT)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	/* Test memcpy expect fault */
+	ret = test_memcpy_expect_fault_op(buf1, NULL, TESTBUFLEN);
+	if (!ret || (ret < 0 && errno != EAGAIN)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int do_test_unknown_op(void)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = -1,	/* Unknown */
+			.len = 0,
+		},
+	};
+	int cpu;
+
+	cpu = cpu_op_get_current_cpu();
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int test_unknown_op(void)
+{
+	int ret;
+	const char *test_name = "test_unknown_op";
+
+	ret = do_test_unknown_op();
+	if (!ret || (ret < 0 && errno != EINVAL)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int do_test_max_ops(void)
+{
+	struct cpu_op opvec[] = {
+		[0] = { .op = CPU_MB_OP, },
+		[1] = { .op = CPU_MB_OP, },
+		[2] = { .op = CPU_MB_OP, },
+		[3] = { .op = CPU_MB_OP, },
+		[4] = { .op = CPU_MB_OP, },
+		[5] = { .op = CPU_MB_OP, },
+		[6] = { .op = CPU_MB_OP, },
+		[7] = { .op = CPU_MB_OP, },
+		[8] = { .op = CPU_MB_OP, },
+		[9] = { .op = CPU_MB_OP, },
+		[10] = { .op = CPU_MB_OP, },
+		[11] = { .op = CPU_MB_OP, },
+		[12] = { .op = CPU_MB_OP, },
+		[13] = { .op = CPU_MB_OP, },
+		[14] = { .op = CPU_MB_OP, },
+		[15] = { .op = CPU_MB_OP, },
+	};
+	int cpu;
+
+	cpu = cpu_op_get_current_cpu();
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int test_max_ops(void)
+{
+	int ret;
+	const char *test_name = "test_max_ops";
+
+	ret = do_test_max_ops();
+	if (ret < 0) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int do_test_too_many_ops(void)
+{
+	struct cpu_op opvec[] = {
+		[0] = { .op = CPU_MB_OP, },
+		[1] = { .op = CPU_MB_OP, },
+		[2] = { .op = CPU_MB_OP, },
+		[3] = { .op = CPU_MB_OP, },
+		[4] = { .op = CPU_MB_OP, },
+		[5] = { .op = CPU_MB_OP, },
+		[6] = { .op = CPU_MB_OP, },
+		[7] = { .op = CPU_MB_OP, },
+		[8] = { .op = CPU_MB_OP, },
+		[9] = { .op = CPU_MB_OP, },
+		[10] = { .op = CPU_MB_OP, },
+		[11] = { .op = CPU_MB_OP, },
+		[12] = { .op = CPU_MB_OP, },
+		[13] = { .op = CPU_MB_OP, },
+		[14] = { .op = CPU_MB_OP, },
+		[15] = { .op = CPU_MB_OP, },
+		[16] = { .op = CPU_MB_OP, },
+	};
+	int cpu;
+
+	cpu = cpu_op_get_current_cpu();
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int test_too_many_ops(void)
+{
+	int ret;
+	const char *test_name = "test_too_many_ops";
+
+	ret = do_test_too_many_ops();
+	if (!ret || (ret < 0 && errno != EINVAL)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+/* Use 64kB len, largest page size known on Linux. */
+static int test_memcpy_single_too_large(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN_PAGE_MAX + 1];
+	char buf2[TESTBUFLEN_PAGE_MAX + 1];
+	const char *test_name = "test_memcpy_single_too_large";
+
+	/* Test memcpy */
+	for (i = 0; i < TESTBUFLEN_PAGE_MAX + 1; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN_PAGE_MAX + 1);
+	ret = test_memcpy_op(buf2, buf1, TESTBUFLEN_PAGE_MAX + 1);
+	if (!ret || (ret < 0 && errno != EINVAL)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+static int test_memcpy_single_ok_sum_too_large_op(void *dst, void *src,
+						  size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src),
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.dst, dst),
+			LINUX_FIELD_u32_u64_INIT_ONSTACK(.u.memcpy_op.src, src),
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+	int ret, cpu;
+
+	do {
+		cpu = cpu_op_get_current_cpu();
+		ret = cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_memcpy_single_ok_sum_too_large(void)
+{
+	int i, ret;
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	const char *test_name = "test_memcpy_single_ok_sum_too_large";
+
+	/* Test memcpy */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_memcpy_single_ok_sum_too_large_op(buf2, buf1, TESTBUFLEN);
+	if (!ret || (ret < 0 && errno != EINVAL)) {
+		ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+/*
+ * Iterate over large uninitialized arrays to trigger page faults.
+ * This includes reading from zero pages.
+ */
+int test_page_fault(void)
+{
+	int ret = 0;
+	uint64_t i;
+	const char *test_name = "test_page_fault";
+
+	for (i = 0; i < NR_PF_ARRAY; i++) {
+		ret = test_memcpy_op(pf_array_dst[i],
+				     pf_array_src[i],
+				     PF_ARRAY_LEN);
+		if (ret) {
+			ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+					      test_name, ret, strerror(errno));
+			return ret;
+		}
+	}
+	ksft_test_result_pass("%s test\n", test_name);
+	return 0;
+}
+
+/*
+ * Try to use 2MB huge pages.
+ */
+int test_hugetlb(void)
+{
+	int ret = 0;
+	uint64_t i;
+	const char *test_name = "test_hugetlb";
+	int *dst, *src;
+
+	dst = mmap(NULL, HUGEMAPLEN, PROT_READ | PROT_WRITE,
+		   MAP_HUGETLB | MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (dst == MAP_FAILED) {
+		switch (errno) {
+		case ENOMEM:
+		case ENOENT:
+		case EINVAL:
+			ksft_test_result_skip("%s test.\n", test_name);
+			goto end;
+		default:
+			break;
+		}
+		perror("mmap");
+		abort();
+	}
+	src = mmap(NULL, HUGEMAPLEN, PROT_READ | PROT_WRITE,
+		   MAP_HUGETLB | MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (src == MAP_FAILED) {
+		if (errno == ENOMEM) {
+			ksft_test_result_skip("%s test.\n", test_name);
+			goto unmap_dst;
+		}
+		perror("mmap");
+		abort();
+	}
+
+	/* Read/write from/to huge zero pages. */
+	for (i = 0; i < NR_HUGE_ARRAY; i++) {
+		ret = test_memcpy_op(dst + (i * PF_ARRAY_LEN / sizeof(int)),
+				     src + (i * PF_ARRAY_LEN / sizeof(int)),
+				     PF_ARRAY_LEN);
+		if (ret) {
+			ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+					      test_name, ret, strerror(errno));
+			return ret;
+		}
+	}
+	for (i = 0; i < NR_HUGE_ARRAY * (PF_ARRAY_LEN / sizeof(int)); i++)
+		src[i] = i;
+
+	for (i = 0; i < NR_HUGE_ARRAY; i++) {
+		ret = test_memcpy_op(dst + (i * PF_ARRAY_LEN / sizeof(int)),
+				     src + (i * PF_ARRAY_LEN / sizeof(int)),
+				     PF_ARRAY_LEN);
+		if (ret) {
+			ksft_test_result_fail("%s test: ret = %d, errno = %s\n",
+					      test_name, ret, strerror(errno));
+			return ret;
+		}
+	}
+
+	for (i = 0; i < NR_HUGE_ARRAY * (PF_ARRAY_LEN / sizeof(int)); i++) {
+		if (dst[i] != i) {
+			ksft_test_result_fail("%s mismatch, expect %d, got %d\n",
+					      test_name, i, dst[i]);
+			return ret;
+		}
+	}
+
+	ksft_test_result_pass("%s test\n", test_name);
+
+	if (munmap(src, HUGEMAPLEN)) {
+		perror("munmap");
+		abort();
+	}
+unmap_dst:
+	if (munmap(dst, HUGEMAPLEN)) {
+		perror("munmap");
+		abort();
+	}
+end:
+	return 0;
+}
+
+static int test_cmpxchg_op_cpu(void *v, void *expect, void *old, void *n,
+		size_t len, int cpu)
+{
+	int ret;
+
+	do {
+		ret = cpu_op_cmpxchg(v, expect, old, n, len, cpu);
+	} while (ret == -1 && errno == EAGAIN);
+
+	return ret;
+}
+
+static int test_over_possible_cpu(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 1, old = 0, n = 3;
+	const char *test_name = "test_over_possible_cpu";
+
+	v = orig_v;
+	ret = test_cmpxchg_op_cpu(&v, &expect, &old, &n, sizeof(uint64_t),
+				  0xFFFFFFFF);
+	if (ret == 0) {
+		ksft_test_result_fail("%s test: ret = %d\n",
+				      test_name, ret);
+		return -1;
+	}
+	if (ret < 0 && errno == EINVAL) {
+		ksft_test_result_pass("%s test\n", test_name);
+		return 0;
+	}
+	ksft_test_result_fail("%s returned %d, errno %s, expecting %d, errno %s\n",
+			      test_name, ret, strerror(errno),
+			      0, strerror(EINVAL));
+	return -1;
+}
+
+static int test_allowed_affinity(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 1, old = 0, n = 3;
+	const char *test_name = "test_allowed_affinity";
+	cpu_set_t allowed_cpus, cpuset;
+
+	ret = sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus);
+	if (ret) {
+		ksft_test_result_fail("%s returned %d, errno %s\n",
+				      test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (!(CPU_ISSET(0, &allowed_cpus) && CPU_ISSET(1, &allowed_cpus))) {
+		ksft_test_result_skip("%s test. Requiring allowed CPUs 0 and 1.\n",
+				      test_name);
+		return 0;
+	}
+	CPU_ZERO(&cpuset);
+	CPU_SET(0, &cpuset);
+	if (sched_setaffinity(0, sizeof(cpuset), &cpuset) != 0) {
+		ksft_test_result_fail("%s test. Unable to set affinity. errno = %s\n",
+				      test_name, strerror(errno));
+		return -1;
+	}
+	v = orig_v;
+	ret = test_cmpxchg_op_cpu(&v, &expect, &old, &n, sizeof(uint64_t),
+				  1);
+	if (sched_setaffinity(0, sizeof(allowed_cpus), &allowed_cpus) != 0) {
+		ksft_test_result_fail("%s test. Unable to set affinity. errno = %s\n",
+				      test_name, strerror(errno));
+		return -1;
+	}
+	if (ret == 0) {
+		ksft_test_result_fail("%s test: ret = %d\n",
+				      test_name, ret);
+		return -1;
+	}
+
+	if (ret < 0 && errno == EINVAL) {
+		ksft_test_result_pass("%s test\n", test_name);
+		return 0;
+	}
+	ksft_test_result_fail("%s returned %d, errno %s, expecting %d, errno %s\n",
+			      test_name, ret, strerror(errno),
+			      0, strerror(EINVAL));
+	return -1;
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+
+	test_ops_supported();
+	test_compare_eq_same();
+	test_compare_eq_diff();
+	test_compare_ne_same();
+	test_compare_ne_diff();
+	test_2compare_eq_index();
+	test_2compare_ne_index();
+	test_memcpy();
+	test_memcpy_u32();
+	test_memcpy_mb_memcpy();
+	test_add();
+	test_two_add();
+	test_or();
+	test_and();
+	test_xor();
+	test_lshift();
+	test_rshift();
+	test_cmpxchg_success();
+	test_cmpxchg_fail();
+	test_memcpy_fault();
+	test_unknown_op();
+	test_max_ops();
+	test_too_many_ops();
+	test_memcpy_single_too_large();
+	test_memcpy_single_ok_sum_too_large();
+	test_page_fault();
+	test_hugetlb();
+	test_over_possible_cpu();
+	test_allowed_affinity();
+
+	return ksft_exit_pass();
+}
diff --git a/tools/testing/selftests/cpu-opv/cpu-op.c b/tools/testing/selftests/cpu-opv/cpu-op.c
new file mode 100644
index 000000000000..5981895df25a
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.c
@@ -0,0 +1,352 @@
+/*
+ * cpu-op.c
+ *
+ * Copyright (C) 2017 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; only
+ * version 2.1 of the License.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <syscall.h>
+#include <assert.h>
+#include <signal.h>
+
+#include "cpu-op.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+#define ACCESS_ONCE(x)		(*(__volatile__  __typeof__(x) *)&(x))
+#define WRITE_ONCE(x, v)	__extension__ ({ ACCESS_ONCE(x) = (v); })
+#define READ_ONCE(x)		ACCESS_ONCE(x)
+
+int cpu_opv(struct cpu_op *cpu_opv, int cpuopcnt, int cpu, int flags)
+{
+	return syscall(__NR_cpu_opv, cpu_opv, cpuopcnt, cpu, flags);
+}
+
+int cpu_op_get_current_cpu(void)
+{
+	int cpu;
+
+	cpu = sched_getcpu();
+	if (cpu < 0) {
+		perror("sched_getcpu()");
+		abort();
+	}
+	return cpu;
+}
+
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *n, size_t len,
+		   int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)old,
+			.u.memcpy_op.src = (unsigned long)v,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)n,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_add(void *v, int64_t count, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_ADD_OP,
+			.len = len,
+			.u.arithmetic_op.p = (unsigned long)v,
+			.u.arithmetic_op.count = count,
+			.u.arithmetic_op.expect_fault_p = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+			 int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+static int cpu_op_cmpeqv_storep_expect_fault(intptr_t *v, intptr_t expect,
+					     intptr_t *newp, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)newp,
+			.u.memcpy_op.expect_fault_dst = 0,
+			/* Return EAGAIN on src fault. */
+			.u.memcpy_op.expect_fault_src = 1,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+				 off_t voffp, intptr_t *load, int cpu)
+{
+	int ret;
+
+	do {
+		intptr_t oldv = READ_ONCE(*v);
+		intptr_t *newp = (intptr_t *)(oldv + voffp);
+
+		if (oldv == expectnot)
+			return 1;
+		ret = cpu_op_cmpeqv_storep_expect_fault(v, oldv, newp, cpu);
+		if (!ret) {
+			*load = oldv;
+			return 0;
+		}
+	} while (ret > 0);
+
+	return -1;
+}
+
+int cpu_op_cmpeqv_storev_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t newv2,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v2,
+			.u.memcpy_op.src = (unsigned long)&newv2,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_storev_mb_storev(intptr_t *v, intptr_t expect,
+				   intptr_t *v2, intptr_t newv2,
+				   intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v2,
+			.u.memcpy_op.src = (unsigned long)&newv2,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MB_OP,
+		},
+		[3] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t expect2,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v2,
+			.u.compare_op.b = (unsigned long)&expect2,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_memcpy_storev(intptr_t *v, intptr_t expect,
+				void *dst, void *src, size_t len,
+				intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpeqv_memcpy_mb_storev(intptr_t *v, intptr_t expect,
+				   void *dst, void *src, size_t len,
+				   intptr_t newv, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = sizeof(intptr_t),
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)&expect,
+			.u.compare_op.expect_fault_a = 0,
+			.u.compare_op.expect_fault_b = 0,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+		[2] = {
+			.op = CPU_MB_OP,
+		},
+		[3] = {
+			.op = CPU_MEMCPY_OP,
+			.len = sizeof(intptr_t),
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)&newv,
+			.u.memcpy_op.expect_fault_dst = 0,
+			.u.memcpy_op.expect_fault_src = 0,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_addv(intptr_t *v, int64_t count, int cpu)
+{
+	return cpu_op_add(v, count, sizeof(intptr_t), cpu);
+}
diff --git a/tools/testing/selftests/cpu-opv/cpu-op.h b/tools/testing/selftests/cpu-opv/cpu-op.h
new file mode 100644
index 000000000000..762a38d6e0d0
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.h
@@ -0,0 +1,59 @@
+/*
+ * cpu-op.h
+ *
+ * (C) Copyright 2017 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef CPU_OPV_H
+#define CPU_OPV_H
+
+#include <stdlib.h>
+#include <stdint.h>
+#include <linux/cpu_opv.h>
+
+int cpu_opv(struct cpu_op *cpuopv, int cpuopcnt, int cpu, int flags);
+int cpu_op_get_current_cpu(void);
+
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *_new, size_t len,
+		   int cpu);
+int cpu_op_add(void *v, int64_t count, size_t len, int cpu);
+
+int cpu_op_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv, int cpu);
+int cpu_op_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+				 off_t voffp, intptr_t *load, int cpu);
+int cpu_op_cmpeqv_storev_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t newv2,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_storev_mb_storev(intptr_t *v, intptr_t expect,
+				   intptr_t *v2, intptr_t newv2,
+				   intptr_t newv, int cpu);
+int cpu_op_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+				intptr_t *v2, intptr_t expect2,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_memcpy_storev(intptr_t *v, intptr_t expect,
+				void *dst, void *src, size_t len,
+				intptr_t newv, int cpu);
+int cpu_op_cmpeqv_memcpy_mb_storev(intptr_t *v, intptr_t expect,
+				   void *dst, void *src, size_t len,
+				   intptr_t newv, int cpu);
+int cpu_op_addv(intptr_t *v, int64_t count, int cpu);
+
+#endif  /* CPU_OPV_H_ */
-- 
2.11.0
