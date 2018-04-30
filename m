From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 14/14] rseq: selftests: Provide Makefile, scripts, gitignore (v2)
Date: Mon, 30 Apr 2018 18:44:33 -0400
Message-ID: <20180430224433.17407-15-mathieu.desnoyers@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuahkh@osg.sams>
List-Id: linux-api@vger.kernel.org

A run_param_test.sh script runs many variants of the parametrizable
tests.

Wire up the rseq Makefile, add directory entry into MAINTAINERS file.

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
Changes since v1:
- Use only rseq, remove use of cpu_opv.
---
 MAINTAINERS                                    |   1 +
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/rseq/.gitignore        |   6 ++
 tools/testing/selftests/rseq/Makefile          |  30 ++++++
 tools/testing/selftests/rseq/run_param_test.sh | 121 +++++++++++++++++++++++++
 5 files changed, 159 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d61ce154dfc..5e8968b3ccae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11991,6 +11991,7 @@ S:	Supported
 F:	kernel/rseq.c
 F:	include/uapi/linux/rseq.h
 F:	include/trace/events/rseq.h
+F:	tools/testing/selftests/rseq/
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 32aafa92074c..593fb44c9cd4 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -28,6 +28,7 @@ TARGETS += powerpc
 TARGETS += proc
 TARGETS += pstore
 TARGETS += ptrace
+TARGETS += rseq
 TARGETS += seccomp
 TARGETS += sigaltstack
 TARGETS += size
diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
new file mode 100644
index 000000000000..cc610da7e369
--- /dev/null
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -0,0 +1,6 @@
+basic_percpu_ops_test
+basic_test
+basic_rseq_op_test
+param_test
+param_test_benchmark
+param_test_compare_twice
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 000000000000..c30c52e1d0d2
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./
+LDLIBS += -lpthread
+
+# Own dependencies because we only want to build against 1st prerequisite, but
+# still track changes to header files and depend on shared object.
+OVERRIDE_TARGETS = 1
+
+TEST_GEN_PROGS = basic_test basic_percpu_ops_test param_test \
+		param_test_benchmark param_test_compare_twice
+
+TEST_GEN_PROGS_EXTENDED = librseq.so
+
+TEST_PROGS = run_param_test.sh
+
+include ../lib.mk
+
+$(OUTPUT)/librseq.so: rseq.c rseq.h rseq-*.h
+	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
+
+$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) rseq.h rseq-*.h
+	$(CC) $(CFLAGS) $< $(LDLIBS) -lrseq -o $@
+
+$(OUTPUT)/param_test_benchmark: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h
+	$(CC) $(CFLAGS) -DBENCHMARK $< $(LDLIBS) -lrseq -o $@
+
+$(OUTPUT)/param_test_compare_twice: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h
+	$(CC) $(CFLAGS) -DRSEQ_COMPARE_TWICE $< $(LDLIBS) -lrseq -o $@
diff --git a/tools/testing/selftests/rseq/run_param_test.sh b/tools/testing/selftests/rseq/run_param_test.sh
new file mode 100755
index 000000000000..3acd6d75ff9f
--- /dev/null
+++ b/tools/testing/selftests/rseq/run_param_test.sh
@@ -0,0 +1,121 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+ or MIT
+
+EXTRA_ARGS=${@}
+
+OLDIFS="$IFS"
+IFS=$'\n'
+TEST_LIST=(
+	"-T s"
+	"-T l"
+	"-T b"
+	"-T b -M"
+	"-T m"
+	"-T m -M"
+	"-T i"
+)
+
+TEST_NAME=(
+	"spinlock"
+	"list"
+	"buffer"
+	"buffer with barrier"
+	"memcpy"
+	"memcpy with barrier"
+	"increment"
+)
+IFS="$OLDIFS"
+
+REPS=1000
+SLOW_REPS=100
+
+function do_tests()
+{
+	local i=0
+	while [ "$i" -lt "${#TEST_LIST[@]}" ]; do
+		echo "Running test ${TEST_NAME[$i]}"
+		./param_test ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} || exit 1
+		echo "Running compare-twice test ${TEST_NAME[$i]}"
+		./param_test_compare_twice ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} || exit 1
+		let "i++"
+	done
+}
+
+echo "Default parameters"
+do_tests
+
+echo "Loop injection: 10000 loops"
+
+OLDIFS="$IFS"
+IFS=$'\n'
+INJECT_LIST=(
+	"1"
+	"2"
+	"3"
+	"4"
+	"5"
+	"6"
+	"7"
+	"8"
+	"9"
+)
+IFS="$OLDIFS"
+
+NR_LOOPS=10000
+
+i=0
+while [ "$i" -lt "${#INJECT_LIST[@]}" ]; do
+	echo "Injecting at <${INJECT_LIST[$i]}>"
+	do_tests -${INJECT_LIST[i]} ${NR_LOOPS}
+	let "i++"
+done
+NR_LOOPS=
+
+function inject_blocking()
+{
+	OLDIFS="$IFS"
+	IFS=$'\n'
+	INJECT_LIST=(
+		"7"
+		"8"
+		"9"
+	)
+	IFS="$OLDIFS"
+
+	NR_LOOPS=-1
+
+	i=0
+	while [ "$i" -lt "${#INJECT_LIST[@]}" ]; do
+		echo "Injecting at <${INJECT_LIST[$i]}>"
+		do_tests -${INJECT_LIST[i]} -1 ${@}
+		let "i++"
+	done
+	NR_LOOPS=
+}
+
+echo "Yield injection (25%)"
+inject_blocking -m 4 -y
+
+echo "Yield injection (50%)"
+inject_blocking -m 2 -y
+
+echo "Yield injection (100%)"
+inject_blocking -m 1 -y
+
+echo "Kill injection (25%)"
+inject_blocking -m 4 -k
+
+echo "Kill injection (50%)"
+inject_blocking -m 2 -k
+
+echo "Kill injection (100%)"
+inject_blocking -m 1 -k
+
+echo "Sleep injection (1ms, 25%)"
+inject_blocking -m 4 -s 1
+
+echo "Sleep injection (1ms, 50%)"
+inject_blocking -m 2 -s 1
+
+echo "Sleep injection (1ms, 100%)"
+inject_blocking -m 1 -s 1
-- 
2.11.0
