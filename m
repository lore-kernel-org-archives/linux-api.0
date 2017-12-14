From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.16 21/21] rseq: selftests: Provide Makefile, scripts, gitignore
Date: Thu, 14 Dec 2017 11:14:03 -0500
Message-ID: <20171214161403.30643-22-mathieu.desnoyers@efficios.com>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-kselftest@vger.kerne
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
 MAINTAINERS                                    |   1 +
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/rseq/.gitignore        |   7 ++
 tools/testing/selftests/rseq/Makefile          |  37 +++++++
 tools/testing/selftests/rseq/run_param_test.sh | 130 +++++++++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index dce21dea5a63..64422f253aa9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11638,6 +11638,7 @@ S:	Supported
 F:	kernel/rseq.c
 F:	include/uapi/linux/rseq.h
 F:	include/trace/events/rseq.h
+F:	tools/testing/selftests/rseq/
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index fc1eba0e0130..fc314334628a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -26,6 +26,7 @@ TARGETS += nsfs
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
+TARGETS += rseq
 TARGETS += seccomp
 TARGETS += sigaltstack
 TARGETS += size
diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
new file mode 100644
index 000000000000..73dcf05b69fd
--- /dev/null
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -0,0 +1,7 @@
+basic_percpu_ops_test
+basic_test
+basic_rseq_op_test
+param_test
+param_test_benchmark
+param_test_compare_twice
+param_test_skip_fastpath
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 000000000000..69f90d718774
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,37 @@
+CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/ -L./ -Wl,-rpath=./
+LDLIBS += -lpthread
+
+# Own dependencies because we only want to build against 1st prerequisite, but
+# still track changes to header files and depend on shared object.
+OVERRIDE_TARGETS = 1
+
+TEST_GEN_PROGS = basic_test basic_percpu_ops_test \
+		param_test param_test_skip_fastpath \
+		param_test_benchmark param_test_compare_twice
+
+TEST_GEN_PROGS_EXTENDED = librseq.so libcpu-op.so
+
+TEST_PROGS = run_param_test.sh
+
+include ../lib.mk
+
+$(OUTPUT)/librseq.so: rseq.c rseq.h rseq-*.h
+	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
+
+$(OUTPUT)/libcpu-op.so: ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
+	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
+
+$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) rseq.h rseq-*.h ../cpu-opv/cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_skip_fastpath: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h ../cpu-opv/cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DRSEQ_SKIP_FASTPATH $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_benchmark: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h ../cpu-opv/cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DBENCHMARK $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_compare_twice: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h ../cpu-opv/cpu-op.h percpu-op.h
+	$(CC) $(CFLAGS) -DRSEQ_COMPARE_TWICE $< $(LDLIBS) -lrseq -lcpu-op -o $@
diff --git a/tools/testing/selftests/rseq/run_param_test.sh b/tools/testing/selftests/rseq/run_param_test.sh
new file mode 100755
index 000000000000..64d4c7d722c9
--- /dev/null
+++ b/tools/testing/selftests/rseq/run_param_test.sh
@@ -0,0 +1,130 @@
+#!/bin/bash
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
+
+function do_tests()
+{
+	local i=0
+	while [ "$i" -lt "${#TEST_LIST[@]}" ]; do
+		echo "Running test ${TEST_NAME[$i]}"
+		./param_test ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} || exit 1
+		echo "Running skip fast-path test ${TEST_NAME[$i]}"
+		./param_test_skip_fastpath ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} || exit 1
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
