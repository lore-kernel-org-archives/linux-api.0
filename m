From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 16/16] cpu-opv/selftests: Provide Makefile, scripts, gitignore
Date: Thu,  1 Nov 2018 10:58:44 +0100
Message-ID: <20181101095844.24462-17-mathieu.desnoyers@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

A run_param_test.sh script runs many variants of the parametrizable
tests.

Wire up the cpu-opv Makefile, add directory entry into MAINTAINERS file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Watson <davejwatson@fb.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: linux-kselftest@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Chris Lameter <cl@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Maurer <bmaurer@fb.com>
Cc: linux-api@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 MAINTAINERS                                       |   1 +
 tools/testing/selftests/Makefile                  |   1 +
 tools/testing/selftests/cpu-opv/.gitignore        |   6 +
 tools/testing/selftests/cpu-opv/Makefile          |  39 +++++++
 tools/testing/selftests/cpu-opv/run_param_test.sh | 134 ++++++++++++++++++++++
 5 files changed, 181 insertions(+)
 create mode 100644 tools/testing/selftests/cpu-opv/.gitignore
 create mode 100644 tools/testing/selftests/cpu-opv/Makefile
 create mode 100755 tools/testing/selftests/cpu-opv/run_param_test.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index de59c7c12c8f..ad9addbc5510 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3878,6 +3878,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	kernel/cpu_opv.c
 F:	include/uapi/linux/cpu_opv.h
+F:	tools/testing/selftests/cpu-opv/
 
 CRAMFS FILESYSTEM
 M:	Nicolas Pitre <nico@linaro.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index f1fe492c8e17..42bcc6e5fc5d 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += capabilities
 TARGETS += cgroup
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += cpu-opv
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += filesystems
diff --git a/tools/testing/selftests/cpu-opv/.gitignore b/tools/testing/selftests/cpu-opv/.gitignore
new file mode 100644
index 000000000000..8c7bb1f8be79
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/.gitignore
@@ -0,0 +1,6 @@
+basic_cpu_opv_test
+basic_percpu_ops_test
+param_test
+param_test_benchmark
+param_test_compare_twice
+param_test_skip_fastpath
diff --git a/tools/testing/selftests/cpu-opv/Makefile b/tools/testing/selftests/cpu-opv/Makefile
new file mode 100644
index 000000000000..46f49bf30bae
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/Makefile
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+CFLAGS += -O2 -Wall -g -I./ -I../rseq/ -I../../../../usr/include/ -L./ -Wl,-rpath=./
+LDLIBS += -lpthread
+
+# Own dependencies because we only want to build against 1st prerequisite, but
+# still track changes to header files and depend on shared object.
+OVERRIDE_TARGETS = 1
+
+TEST_GEN_PROGS = basic_cpu_opv_test basic_percpu_ops_test \
+		param_test param_test_skip_fastpath \
+		param_test_benchmark param_test_compare_twice
+
+TEST_GEN_PROGS_EXTENDED = librseq.so libcpu-op.so
+
+TEST_PROGS = run_param_test.sh
+
+include ../lib.mk
+
+$(OUTPUT)/libcpu-op.so: cpu-op.c cpu-op.h
+	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
+
+$(OUTPUT)/librseq.so: ../rseq/rseq.c ../rseq/rseq.h ../rseq/rseq-*.h
+	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
+
+$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) ../rseq/rseq.h ../rseq/rseq-*.h cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_skip_fastpath: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					../rseq/rseq.h ../rseq/rseq-*.h cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DRSEQ_SKIP_FASTPATH $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_benchmark: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					../rseq/rseq.h ../rseq/rseq-*.h cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DBENCHMARK $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_compare_twice: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					../rseq/rseq.h ../rseq/rseq-*.h cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DRSEQ_COMPARE_TWICE $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
diff --git a/tools/testing/selftests/cpu-opv/run_param_test.sh b/tools/testing/selftests/cpu-opv/run_param_test.sh
new file mode 100755
index 000000000000..066d2479893c
--- /dev/null
+++ b/tools/testing/selftests/cpu-opv/run_param_test.sh
@@ -0,0 +1,134 @@
+#!/bin/bash
+
+NR_CPUS=`grep '^processor' /proc/cpuinfo | wc -l`
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
+NR_THREADS=$((6*${NR_CPUS}))
+
+function do_tests()
+{
+	local i=0
+	while [ "$i" -lt "${#TEST_LIST[@]}" ]; do
+		echo "Running test ${TEST_NAME[$i]}"
+		./param_test ${TEST_LIST[$i]} -r ${REPS} -t ${NR_THREADS} ${@} ${EXTRA_ARGS} || exit 1
+		echo "Running skip fast-path test ${TEST_NAME[$i]}"
+		./param_test_skip_fastpath ${TEST_LIST[$i]} -r ${SLOW_REPS} -t ${NR_THREADS} ${@} ${EXTRA_ARGS} || exit 1
+		echo "Running compare-twice test ${TEST_NAME[$i]}"
+		./param_test_compare_twice ${TEST_LIST[$i]} -r ${REPS} -t ${NR_THREADS} ${@} ${EXTRA_ARGS} || exit 1
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
+
+echo "Disable rseq for 25% threads"
+do_tests -D 4
+
+echo "Disable rseq for 50% threads"
+do_tests -D 2
+
+echo "Disable rseq"
+do_tests -d
-- 
2.11.0
