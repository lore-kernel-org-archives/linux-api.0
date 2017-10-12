From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 13/14] cpu_opv: Implement selftests
Date: Thu, 12 Oct 2017 19:03:25 -0400
Message-ID: <20171012230326.19984-14-mathieu.desnoyers@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
CC: Shuah Khan <shuah@kernel.org>
CC: linux-kselftest@vger.kernel.org
CC: linux-api@vger.kernel.org
---
 MAINTAINERS                                        |   1 +
 tools/testing/selftests/cpu-opv/.gitignore         |   1 +
 tools/testing/selftests/cpu-opv/Makefile           |  13 +
 .../testing/selftests/cpu-opv/basic_cpu_opv_test.c | 828 +++++++++++++++++++++
 tools/testing/selftests/cpu-opv/cpu-op.c           | 189 +++++
 tools/testing/selftests/cpu-opv/cpu-op.h           |  53 ++
 6 files changed, 1085 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-opv/.gitignore
 create mode 100644 tools/testing/selftests/cpu-opv/Makefile
 create mode 100644 tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.c
 create mode 100644 tools/testing/selftests/cpu-opv/cpu-op.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a5f3afb2ea4..9134a3234737 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3617,6 +3617,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	kernel/cpu_opv.c
 F:	include/uapi/linux/cpu_opv.h
+F:	tools/testing/selftests/cpu-opv/
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
diff --git a/tools/testing/selftests/cpu-opv/.gitignore b/tools/testing/selftests/cpu-opv/.gitignore
new file mode 100644
index 000000000000..c7186eb95cf5
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/.gitignore
@@ -0,0 +1 @@
+basic_cpu_opv_test
diff --git a/tools/testing/selftests/cpu-opv/Makefile b/tools/testing/selftests/cpu-opv/Makefile
new file mode 100644
index 000000000000..81d0596824ee
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/Makefile
@@ -0,0 +1,13 @@
+CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/
+LDFLAGS += -lpthread
+
+TESTS = basic_cpu_opv_test
+
+all: $(TESTS)
+%: %.c cpu-op.c cpu-op.h
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TESTS)
diff --git a/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c b/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
new file mode 100644
index 000000000000..e2ad818cca1c
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c
@@ -0,0 +1,828 @@
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
+#include <sys/time.h>
+#include <errno.h>
+#include <stdlib.h>
+
+#include "cpu-op.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+#define TESTBUFLEN	4096
+
+static int test_compare_eq_op(char *a, char *b, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)a,
+			.u.compare_op.b = (unsigned long)b,
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
+	printf("Testing %s\n", test_name);
+
+	/* Test compare_eq */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf2[i] = (char)i;
+	ret = test_compare_eq_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret > 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 0);
+		return -1;
+	}
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
+	printf("Testing %s\n", test_name);
+
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_compare_eq_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret == 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 1);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_compare_ne_op(char *a, char *b, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_NE_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)a,
+			.u.compare_op.b = (unsigned long)b,
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
+	printf("Testing %s\n", test_name);
+
+	/* Test compare_ne */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf2[i] = (char)i;
+	ret = test_compare_ne_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret == 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 1);
+		return -1;
+	}
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
+	printf("Testing %s\n", test_name);
+
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_compare_ne_op(buf2, buf1, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 0);
+		return -1;
+	}
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
+			.u.compare_op.a = (unsigned long)a,
+			.u.compare_op.b = (unsigned long)b,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)c,
+			.u.compare_op.b = (unsigned long)d,
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
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	char buf3[TESTBUFLEN];
+	char buf4[TESTBUFLEN];
+	const char *test_name = "test_2compare_eq index";
+
+	printf("Testing %s\n", test_name);
+
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	memset(buf3, 0, TESTBUFLEN);
+	memset(buf4, 0, TESTBUFLEN);
+
+	/* First compare failure is op[0], expect 1. */
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 1) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 1);
+		return -1;
+	}
+
+	/* All compares succeed. */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf2[i] = (char)i;
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 0);
+		return -1;
+	}
+
+	/* First compare failure is op[1], expect 2. */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf3[i] = (char)i;
+	ret = test_2compare_eq_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 2) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 2);
+		return -1;
+	}
+
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
+			.u.compare_op.a = (unsigned long)a,
+			.u.compare_op.b = (unsigned long)b,
+		},
+		[1] = {
+			.op = CPU_COMPARE_NE_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)c,
+			.u.compare_op.b = (unsigned long)d,
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
+	char buf1[TESTBUFLEN];
+	char buf2[TESTBUFLEN];
+	char buf3[TESTBUFLEN];
+	char buf4[TESTBUFLEN];
+	const char *test_name = "test_2compare_ne index";
+
+	printf("Testing %s\n", test_name);
+
+	memset(buf1, 0, TESTBUFLEN);
+	memset(buf2, 0, TESTBUFLEN);
+	memset(buf3, 0, TESTBUFLEN);
+	memset(buf4, 0, TESTBUFLEN);
+
+	/* First compare ne failure is op[0], expect 1. */
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 1) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 1);
+		return -1;
+	}
+
+	/* All compare ne succeed. */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf3[i] = (char)i;
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 0);
+		return -1;
+	}
+
+	/* First compare failure is op[1], expect 2. */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf4[i] = (char)i;
+	ret = test_2compare_ne_op(buf2, buf1, buf4, buf3, TESTBUFLEN);
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret != 2) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 2);
+		return -1;
+	}
+
+	return 0;
+}
+
+
+static int test_memcpy_op(void *dst, void *src, size_t len)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
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
+	printf("Testing %s\n", test_name);
+
+	/* Test memcpy */
+	for (i = 0; i < TESTBUFLEN; i++)
+		buf1[i] = (char)i;
+	memset(buf2, 0, TESTBUFLEN);
+	ret = test_memcpy_op(buf2, buf1, TESTBUFLEN);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	for (i = 0; i < TESTBUFLEN; i++) {
+		if (buf2[i] != (char)i) {
+			printf("%s failed. Expecting '%d', found '%d' at offset %d\n",
+				test_name, (char)i, buf2[i], i);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int test_memcpy_u32(void)
+{
+	int ret;
+	uint32_t v1, v2;
+	const char *test_name = "test_memcpy_u32";
+
+	printf("Testing %s\n", test_name);
+
+	/* Test memcpy_u32 */
+	v1 = 42;
+	v2 = 0;
+	ret = test_memcpy_op(&v2, &v1, sizeof(v1));
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (v1 != v2) {
+		printf("%s failed. Expecting '%d', found '%d'\n",
+			test_name, v1, v2);
+		return -1;
+	}
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_add_op(&v, increment);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != orig_v + increment) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_two_add_op(int *v, int64_t *increments)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_ADD_OP,
+			.len = sizeof(*v),
+			.u.arithmetic_op.p = (unsigned long)v,
+			.u.arithmetic_op.count = increments[0],
+		},
+		[1] = {
+			.op = CPU_ADD_OP,
+			.len = sizeof(*v),
+			.u.arithmetic_op.p = (unsigned long)v,
+			.u.arithmetic_op.count = increments[1],
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_two_add_op(&v, increments);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != orig_v + increments[0] + increments[1]) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_or_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_OR_OP,
+			.len = sizeof(*v),
+			.u.bitwise_op.p = (unsigned long)v,
+			.u.bitwise_op.mask = mask,
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_or_op(&v, mask);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v | mask)) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v | mask);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_and_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_AND_OP,
+			.len = sizeof(*v),
+			.u.bitwise_op.p = (unsigned long)v,
+			.u.bitwise_op.mask = mask,
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_and_op(&v, mask);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v & mask)) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v & mask);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_xor_op(int *v, uint64_t mask)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_XOR_OP,
+			.len = sizeof(*v),
+			.u.bitwise_op.p = (unsigned long)v,
+			.u.bitwise_op.mask = mask,
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_xor_op(&v, mask);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v ^ mask)) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v ^ mask);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_lshift_op(int *v, uint32_t bits)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_LSHIFT_OP,
+			.len = sizeof(*v),
+			.u.shift_op.p = (unsigned long)v,
+			.u.shift_op.bits = bits,
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_lshift_op(&v, bits);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v << bits)) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v << bits);
+		return -1;
+	}
+	return 0;
+}
+
+
+static int test_rshift_op(int *v, uint32_t bits)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_RSHIFT_OP,
+			.len = sizeof(*v),
+			.u.shift_op.p = (unsigned long)v,
+			.u.shift_op.bits = bits,
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
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_rshift_op(&v, bits);
+	if (ret) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		return -1;
+	}
+	if (v != (orig_v >> bits)) {
+		printf("%s unexpected value: %d. Should be %d.\n",
+			test_name, v, orig_v >> bits);
+		return -1;
+	}
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
+
+static int test_cmpxchg_success(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 1, old = 0, n = 3;
+	const char *test_name = "test_cmpxchg success";
+
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_cmpxchg_op(&v, &expect, &old, &n, sizeof(uint64_t));
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 0);
+		return -1;
+	}
+	if (v != n) {
+		printf("%s v is %lld, expecting %lld\n",
+			test_name, (long long)v, (long long)n);
+		return -1;
+	}
+	if (old != orig_v) {
+		printf("%s old is %lld, expecting %lld\n",
+			test_name, (long long)old, (long long)orig_v);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_cmpxchg_fail(void)
+{
+	int ret;
+	uint64_t orig_v = 1, v, expect = 123, old = 0, n = 3;
+	const char *test_name = "test_cmpxchg fail";
+
+	printf("Testing %s\n", test_name);
+
+	v = orig_v;
+	ret = test_cmpxchg_op(&v, &expect, &old, &n, sizeof(uint64_t));
+	if (ret < 0) {
+		printf("%s returned with %d, errno: %s\n",
+			test_name, ret, strerror(errno));
+		exit(-1);
+	}
+	if (ret == 0) {
+		printf("%s returned %d, expecting %d\n",
+			test_name, ret, 1);
+		return -1;
+	}
+	if (v == n) {
+		printf("%s v is %lld, expecting %lld\n",
+			test_name, (long long)v, (long long)orig_v);
+		return -1;
+	}
+	if (old != orig_v) {
+		printf("%s old is %lld, expecting %lld\n",
+			test_name, (long long)old, (long long)orig_v);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int ret = 0;
+
+	ret |= test_compare_eq_same();
+	ret |= test_compare_eq_diff();
+	ret |= test_compare_ne_same();
+	ret |= test_compare_ne_diff();
+	ret |= test_2compare_eq_index();
+	ret |= test_2compare_ne_index();
+	ret |= test_memcpy();
+	ret |= test_memcpy_u32();
+	ret |= test_add();
+	ret |= test_two_add();
+	ret |= test_or();
+	ret |= test_and();
+	ret |= test_xor();
+	ret |= test_lshift();
+	ret |= test_rshift();
+	ret |= test_cmpxchg_success();
+	ret |= test_cmpxchg_fail();
+
+	return ret;
+}
diff --git a/tools/testing/selftests/cpu-opv/cpu-op.c b/tools/testing/selftests/cpu-opv/cpu-op.c
new file mode 100644
index 000000000000..d25420c74a71
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.c
@@ -0,0 +1,189 @@
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
+int cpu_op_cmpstore(void *v, void *expect, void *n, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)n,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_2cmp1store(void *v, void *expect, void *n, void *check2,
+		void *expect2, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)check2,
+			.u.compare_op.b = (unsigned long)expect2,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)n,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_1cmp2store(void *v, void *expect, void *_new,
+		void *v2, void *_new2, size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)_new,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v2,
+			.u.memcpy_op.src = (unsigned long)_new2,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *n,
+		size_t len, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)old,
+			.u.memcpy_op.src = (unsigned long)v,
+		},
+		[1] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)n,
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
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
+
+int cpu_op_cmpstorememcpy(void *v, void *expect, void *_new, size_t len,
+		void *dst, void *src, size_t copylen, int cpu)
+{
+	struct cpu_op opvec[] = {
+		[0] = {
+			.op = CPU_COMPARE_EQ_OP,
+			.len = len,
+			.u.compare_op.a = (unsigned long)v,
+			.u.compare_op.b = (unsigned long)expect,
+		},
+		[1] = {
+			.op = CPU_MEMCPY_OP,
+			.len = len,
+			.u.memcpy_op.dst = (unsigned long)v,
+			.u.memcpy_op.src = (unsigned long)_new,
+		},
+		[2] = {
+			.op = CPU_MEMCPY_OP,
+			.len = copylen,
+			.u.memcpy_op.dst = (unsigned long)dst,
+			.u.memcpy_op.src = (unsigned long)src,
+		},
+	};
+
+	return cpu_opv(opvec, ARRAY_SIZE(opvec), cpu, 0);
+}
diff --git a/tools/testing/selftests/cpu-opv/cpu-op.h b/tools/testing/selftests/cpu-opv/cpu-op.h
new file mode 100644
index 000000000000..3f5679e643bb
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/cpu-op.h
@@ -0,0 +1,53 @@
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
+#include <linux/cpu_opv.h>
+
+#define likely(x)		__builtin_expect(!!(x), 1)
+#define unlikely(x)		__builtin_expect(!!(x), 0)
+#define barrier()		__asm__ __volatile__("" : : : "memory")
+
+#define ACCESS_ONCE(x)		(*(__volatile__  __typeof__(x) *)&(x))
+#define WRITE_ONCE(x, v)	__extension__ ({ ACCESS_ONCE(x) = (v); })
+#define READ_ONCE(x)		ACCESS_ONCE(x)
+
+int cpu_opv(struct cpu_op *cpuopv, int cpuopcnt, int cpu, int flags);
+int cpu_op_get_current_cpu(void);
+
+int cpu_op_cmpstore(void *v, void *expect, void *_new, size_t len, int cpu);
+int cpu_op_2cmp1store(void *v, void *expect, void *_new, void *check2,
+		void *expect2, size_t len, int cpu);
+int cpu_op_1cmp2store(void *v, void *expect, void *_new,
+		void *v2, void *_new2, size_t len, int cpu);
+int cpu_op_cmpxchg(void *v, void *expect, void *old, void *_new,
+		size_t len, int cpu);
+int cpu_op_add(void *v, int64_t count, size_t len, int cpu);
+int cpu_op_cmpstorememcpy(void *v, void *expect, void *_new, size_t len,
+		void *dst, void *src, size_t copylen, int cpu);
+
+#endif  /* CPU_OPV_H_ */
-- 
2.11.0
