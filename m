From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH update for 4.15 3/3] rseq: selftests: Provide self-tests (v4)
Date: Tue, 21 Nov 2017 17:19:33 -0500
Message-ID: <20171121221933.25959-3-mathieu.desnoyers@efficios.com>
References: <20171121221933.25959-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171121221933.25959-1-mathieu.desnoyers@efficios.com>
In-Reply-To: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implements two basic tests of RSEQ functionality, and one more
exhaustive parameterizable test.

The first, "basic_test" only asserts that RSEQ works moderately
correctly. E.g. that the CPUID pointer works.

"basic_percpu_ops_test" is a slightly more "realistic" variant,
implementing a few simple per-cpu operations and testing their
correctness.

"param_test" is a parametrizable restartable sequences test. See
the "--help" output for usage.

A run_param_test.sh script runs many variants of the parametrizable
tests.

As part of those tests, a helper library "rseq" implements a user-space
API around restartable sequences. It uses the cpu_opv system call as
fallback when single-stepped by a debugger. It exposes the instruction
pointer addresses where the rseq assembly blocks begin and end, as well
as the associated abort instruction pointer, in the __rseq_table
section. This section allows debuggers may know where to place
breakpoints when single-stepping through assembly blocks which may be
aborted at any point by the kernel.

The rseq library expose APIs that present the fast-path operations.
The new from userspace is, e.g. for a counter increment:

    cpu = rseq_cpu_start();
    ret = rseq_addv(&data->c[cpu].count, 1, cpu);
    if (likely(!ret))
        return 0;        /* Success. */
    do {
        cpu = rseq_current_cpu();
        ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
        if (likely(!ret))
            return 0;    /* Success. */
    } while (ret > 0 || errno == EAGAIN);
    perror("cpu_op_addv");
    return -1;           /* Unexpected error. */

PowerPC tests have been implemented by Boqun Feng.

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
Changes since v1:
- Provide abort-ip signature: The abort-ip signature is located just
  before the abort-ip target. It is currently hardcoded, but a
  user-space application could use the __rseq_table to iterate on all
  abort-ip targets and use a random value as signature if needed in the
  future.
- Add rseq_prepare_unload(): Libraries and JIT code using rseq critical
  sections need to issue rseq_prepare_unload() on each thread at least
  once before reclaim of struct rseq_cs.
- Use initial-exec TLS model, non-weak symbol: The initial-exec model is
  signal-safe, whereas the global-dynamic model is not.  Remove the
  "weak" symbol attribute from the __rseq_abi in rseq.c. The rseq.so
  library will have ownership of that symbol, and there is not reason for
  an application or user library to try to define that symbol.
  The expected use is to link against libreq.so, which owns and provide
  that symbol.
- Set cpu_id to -2 on register error
- Add rseq_len syscall parameter, rseq_cs version
- Ensure disassember-friendly signature: x86 32/64 disassembler have a
  hard time decoding the instruction stream after a bad instruction. Use
  a nopl instruction to encode the signature. Suggested by Andy Lutomirski.
- Exercise parametrized tests variants in a shell scripts.
- Restartable sequences selftests: Remove use of event counter.
- Use cpu_id_start field:  With the cpu_id_start field, the C
  preparation phase of the fast-path does not need to compare cpu_id < 0
  anymore.
- Signal-safe registration and refcounting: Allow libraries using
  librseq.so to register it from signal handlers.
- Use OVERRIDE_TARGETS in makefile.
- Use "m" constraints for rseq_cs field.

Changes since v2:
- Update based on Thomas Gleixner's comments.

Changes since v3:
- Generate param_test_skip_fastpath and param_test_benchmark with
  -DSKIP_FASTPATH and -DBENCHMARK (respectively). Add param_test_fastpath
  to run_param_test.sh.
---
 MAINTAINERS                                        |    1 +
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/rseq/.gitignore            |    4 +
 tools/testing/selftests/rseq/Makefile              |   33 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  333 +++++
 tools/testing/selftests/rseq/basic_test.c          |   55 +
 tools/testing/selftests/rseq/param_test.c          | 1285 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  535 ++++++++
 tools/testing/selftests/rseq/rseq-ppc.h            |  567 +++++++++
 tools/testing/selftests/rseq/rseq-x86.h            |  898 ++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  116 ++
 tools/testing/selftests/rseq/rseq.h                |  154 +++
 tools/testing/selftests/rseq/run_param_test.sh     |  126 ++
 13 files changed, 4108 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/param_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
 create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
 create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h
 create mode 100755 tools/testing/selftests/rseq/run_param_test.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index c6c2436d15f8..ba9137c1f295 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11634,6 +11634,7 @@ S:	Supported
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
index 000000000000..9409c3db99b2
--- /dev/null
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -0,0 +1,4 @@
+basic_percpu_ops_test
+basic_test
+basic_rseq_op_test
+param_test
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 000000000000..3c946c517a1a
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,33 @@
+CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/ -L./ -Wl,-rpath=./
+LDLIBS += -lpthread
+
+# Own dependencies because we only want to build against 1st prerequisite, but
+# still track changes to header files and depend on shared object.
+OVERRIDE_TARGETS = 1
+
+TEST_GEN_PROGS = basic_test basic_percpu_ops_test \
+		param_test param_test_skip_fastpath \
+		param_test_benchmark
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
+$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) rseq.h rseq-*.h ../cpu-opv/cpu-op.h
+	$(CC) $(CFLAGS) $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_skip_fastpath: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h ../cpu-opv/cpu-op.h
+	$(CC) $(CFLAGS) -DSKIP_FASTPATH $< $(LDLIBS) -lrseq -lcpu-op -o $@
+
+$(OUTPUT)/param_test_benchmark: param_test.c $(TEST_GEN_PROGS_EXTENDED) \
+					rseq.h rseq-*.h ../cpu-opv/cpu-op.h
+	$(CC) $(CFLAGS) -DBENCHMARK $< $(LDLIBS) -lrseq -lcpu-op -o $@
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
new file mode 100644
index 000000000000..e5f7fed06a03
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -0,0 +1,333 @@
+#define _GNU_SOURCE
+#include <assert.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stddef.h>
+
+#include "rseq.h"
+#include "cpu-op.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+struct percpu_lock_entry {
+	intptr_t v;
+} __attribute__((aligned(128)));
+
+struct percpu_lock {
+	struct percpu_lock_entry c[CPU_SETSIZE];
+};
+
+struct test_data_entry {
+	intptr_t count;
+} __attribute__((aligned(128)));
+
+struct spinlock_test_data {
+	struct percpu_lock lock;
+	struct test_data_entry c[CPU_SETSIZE];
+	int reps;
+};
+
+struct percpu_list_node {
+	intptr_t data;
+	struct percpu_list_node *next;
+};
+
+struct percpu_list_entry {
+	struct percpu_list_node *head;
+} __attribute__((aligned(128)));
+
+struct percpu_list {
+	struct percpu_list_entry c[CPU_SETSIZE];
+};
+
+/* A simple percpu spinlock.  Returns the cpu lock was acquired on. */
+int rseq_percpu_lock(struct percpu_lock *lock)
+{
+	int cpu;
+
+	for (;;) {
+		int ret;
+
+#ifndef SKIP_FASTPATH
+		/* Try fast path. */
+		cpu = rseq_cpu_start();
+		ret = rseq_cmpeqv_storev(&lock->c[cpu].v,
+				0, 1, cpu);
+		if (likely(!ret))
+			break;
+		if (ret > 0)
+			continue;	/* Retry. */
+#endif
+	slowpath:
+		__attribute__((unused));
+		/* Fallback on cpu_opv system call. */
+		cpu = rseq_current_cpu();
+		ret = cpu_op_cmpeqv_storev(&lock->c[cpu].v, 0, 1, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	/*
+	 * Acquire semantic when taking lock after control dependency.
+	 * Matches rseq_smp_store_release().
+	 */
+	rseq_smp_acquire__after_ctrl_dep();
+	return cpu;
+}
+
+void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	assert(lock->c[cpu].v == 1);
+	/*
+	 * Release lock, with release semantic. Matches
+	 * rseq_smp_acquire__after_ctrl_dep().
+	 */
+	rseq_smp_store_release(&lock->c[cpu].v, 0);
+}
+
+void *test_percpu_spinlock_thread(void *arg)
+{
+	struct spinlock_test_data *data = arg;
+	int i, cpu;
+
+	if (rseq_register_current_thread()) {
+		fprintf(stderr, "Error: rseq_register_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		abort();
+	}
+	for (i = 0; i < data->reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->c[cpu].count++;
+		rseq_percpu_unlock(&data->lock, cpu);
+	}
+	if (rseq_unregister_current_thread()) {
+		fprintf(stderr, "Error: rseq_unregister_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		abort();
+	}
+
+	return NULL;
+}
+
+/*
+ * A simple test which implements a sharded counter using a per-cpu
+ * lock.  Obviously real applications might prefer to simply use a
+ * per-cpu increment; however, this is reasonable for a test and the
+ * lock can be extended to synchronize more complicated operations.
+ */
+void test_percpu_spinlock(void)
+{
+	const int num_threads = 200;
+	int i;
+	uint64_t sum;
+	pthread_t test_threads[num_threads];
+	struct spinlock_test_data data;
+
+	memset(&data, 0, sizeof(data));
+	data.reps = 5000;
+
+	for (i = 0; i < num_threads; i++)
+		pthread_create(&test_threads[i], NULL,
+			test_percpu_spinlock_thread, &data);
+
+	for (i = 0; i < num_threads; i++)
+		pthread_join(test_threads[i], NULL);
+
+	sum = 0;
+	for (i = 0; i < CPU_SETSIZE; i++)
+		sum += data.c[i].count;
+
+	assert(sum == (uint64_t)data.reps * num_threads);
+}
+
+int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
+{
+	intptr_t *targetptr, newval, expect;
+	int cpu, ret;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load list->c[cpu].head with single-copy atomicity. */
+	expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+	newval = (intptr_t)node;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	node->next = (struct percpu_list_node *)expect;
+	ret = rseq_cmpeqv_storev(targetptr, expect, newval, cpu);
+	if (likely(!ret))
+		return cpu;
+#endif
+	/* Fallback on cpu_opv system call. */
+	slowpath:
+		__attribute__((unused));
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load list->c[cpu].head with single-copy atomicity. */
+		expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+		newval = (intptr_t)node;
+		targetptr = (intptr_t *)&list->c[cpu].head;
+		node->next = (struct percpu_list_node *)expect;
+		ret = cpu_op_cmpeqv_storev(targetptr, expect, newval, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return cpu;
+}
+
+/*
+ * Unlike a traditional lock-less linked list; the availability of a
+ * rseq primitive allows us to implement pop without concerns over
+ * ABA-type races.
+ */
+struct percpu_list_node *percpu_list_pop(struct percpu_list *list)
+{
+	struct percpu_list_node *head;
+	int cpu, ret;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	ret = rseq_cmpnev_storeoffp_load((intptr_t *)&list->c[cpu].head,
+		(intptr_t)NULL,
+		offsetof(struct percpu_list_node, next),
+		(intptr_t *)&head, cpu);
+	if (likely(!ret))
+		return head;
+	if (ret > 0)
+		return NULL;
+#endif
+	/* Fallback on cpu_opv system call. */
+	slowpath:
+		__attribute__((unused));
+	for (;;) {
+		cpu = rseq_current_cpu();
+		ret = cpu_op_cmpnev_storeoffp_load(
+			(intptr_t *)&list->c[cpu].head,
+			(intptr_t)NULL,
+			offsetof(struct percpu_list_node, next),
+			(intptr_t *)&head, cpu);
+		if (likely(!ret))
+			break;
+		if (ret > 0)
+			return NULL;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (rseq_register_current_thread()) {
+		fprintf(stderr, "Error: rseq_register_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		abort();
+	}
+
+	for (i = 0; i < 100000; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+
+		sched_yield();  /* encourage shuffling */
+		if (node)
+			percpu_list_push(list, node);
+	}
+
+	if (rseq_unregister_current_thread()) {
+		fprintf(stderr, "Error: rseq_unregister_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		abort();
+	}
+
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu linked list from many threads.  */
+void test_percpu_list(void)
+{
+	int i, j;
+	uint64_t sum = 0, expected_sum = 0;
+	struct percpu_list list;
+	pthread_t test_threads[200];
+	cpu_set_t allowed_cpus;
+
+	memset(&list, 0, sizeof(list));
+
+	/* Generate list entries for every usable cpu. */
+	sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus);
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+		for (j = 1; j <= 100; j++) {
+			struct percpu_list_node *node;
+
+			expected_sum += j;
+
+			node = malloc(sizeof(*node));
+			assert(node);
+			node->data = j;
+			node->next = list.c[i].head;
+			list.c[i].head = node;
+		}
+	}
+
+	for (i = 0; i < 200; i++)
+		assert(pthread_create(&test_threads[i], NULL,
+			test_percpu_list_thread, &list) == 0);
+
+	for (i = 0; i < 200; i++)
+		pthread_join(test_threads[i], NULL);
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		cpu_set_t pin_mask;
+		struct percpu_list_node *node;
+
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+
+		CPU_ZERO(&pin_mask);
+		CPU_SET(i, &pin_mask);
+		sched_setaffinity(0, sizeof(pin_mask), &pin_mask);
+
+		while ((node = percpu_list_pop(&list))) {
+			sum += node->data;
+			free(node);
+		}
+	}
+
+	/*
+	 * All entries should now be accounted for (unless some external
+	 * actor is interfering with our allowed affinity while this
+	 * test is running).
+	 */
+	assert(sum == expected_sum);
+}
+
+int main(int argc, char **argv)
+{
+	if (rseq_register_current_thread()) {
+		fprintf(stderr, "Error: rseq_register_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		goto error;
+	}
+	printf("spinlock\n");
+	test_percpu_spinlock();
+	printf("percpu_list\n");
+	test_percpu_list();
+	if (rseq_unregister_current_thread()) {
+		fprintf(stderr, "Error: rseq_unregister_current_thread(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		goto error;
+	}
+	return 0;
+
+error:
+	return -1;
+}
+
diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 000000000000..e2086b3885d7
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,55 @@
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
diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
new file mode 100644
index 000000000000..c7a16b656a36
--- /dev/null
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -0,0 +1,1285 @@
+#define _GNU_SOURCE
+#include <assert.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <poll.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <errno.h>
+#include <stddef.h>
+
+#include "cpu-op.h"
+
+static inline pid_t gettid(void)
+{
+	return syscall(__NR_gettid);
+}
+
+#define NR_INJECT	9
+static int loop_cnt[NR_INJECT + 1];
+
+static int opt_modulo, verbose;
+
+static int opt_yield, opt_signal, opt_sleep,
+		opt_disable_rseq, opt_threads = 200,
+		opt_disable_mod = 0, opt_test = 's', opt_mb = 0;
+
+static long long opt_reps = 5000;
+
+static __thread __attribute__((tls_model("initial-exec"))) unsigned int signals_delivered;
+
+#ifndef BENCHMARK
+
+static __thread __attribute__((tls_model("initial-exec"))) unsigned int yield_mod_cnt, nr_abort;
+
+#define printf_verbose(fmt, ...)			\
+	do {						\
+		if (verbose)				\
+			printf(fmt, ## __VA_ARGS__);	\
+	} while (0)
+
+#define RSEQ_INJECT_INPUT \
+	, [loop_cnt_1]"m"(loop_cnt[1]) \
+	, [loop_cnt_2]"m"(loop_cnt[2]) \
+	, [loop_cnt_3]"m"(loop_cnt[3]) \
+	, [loop_cnt_4]"m"(loop_cnt[4]) \
+	, [loop_cnt_5]"m"(loop_cnt[5]) \
+	, [loop_cnt_6]"m"(loop_cnt[6])
+
+#if defined(__x86_64__) || defined(__i386__)
+
+#define INJECT_ASM_REG	"eax"
+
+#define RSEQ_INJECT_CLOBBER \
+	, INJECT_ASM_REG
+
+#define RSEQ_INJECT_ASM(n) \
+	"mov %[loop_cnt_" #n "], %%" INJECT_ASM_REG "\n\t" \
+	"test %%" INJECT_ASM_REG ",%%" INJECT_ASM_REG "\n\t" \
+	"jz 333f\n\t" \
+	"222:\n\t" \
+	"dec %%" INJECT_ASM_REG "\n\t" \
+	"jnz 222b\n\t" \
+	"333:\n\t"
+
+#elif defined(__ARMEL__)
+
+#define INJECT_ASM_REG	"r4"
+
+#define RSEQ_INJECT_CLOBBER \
+	, INJECT_ASM_REG
+
+#define RSEQ_INJECT_ASM(n) \
+	"ldr " INJECT_ASM_REG ", %[loop_cnt_" #n "]\n\t" \
+	"cmp " INJECT_ASM_REG ", #0\n\t" \
+	"beq 333f\n\t" \
+	"222:\n\t" \
+	"subs " INJECT_ASM_REG ", #1\n\t" \
+	"bne 222b\n\t" \
+	"333:\n\t"
+
+#elif __PPC__
+#define INJECT_ASM_REG	"r18"
+
+#define RSEQ_INJECT_CLOBBER \
+	, INJECT_ASM_REG
+
+#define RSEQ_INJECT_ASM(n) \
+	"lwz %%" INJECT_ASM_REG ", %[loop_cnt_" #n "]\n\t" \
+	"cmpwi %%" INJECT_ASM_REG ", 0\n\t" \
+	"beq 333f\n\t" \
+	"222:\n\t" \
+	"subic. %%" INJECT_ASM_REG ", %%" INJECT_ASM_REG ", 1\n\t" \
+	"bne 222b\n\t" \
+	"333:\n\t"
+#else
+#error unsupported target
+#endif
+
+#define RSEQ_INJECT_FAILED \
+	nr_abort++;
+
+#define RSEQ_INJECT_C(n) \
+{ \
+	int loc_i, loc_nr_loops = loop_cnt[n]; \
+	\
+	for (loc_i = 0; loc_i < loc_nr_loops; loc_i++) { \
+		barrier(); \
+	} \
+	if (loc_nr_loops == -1 && opt_modulo) { \
+		if (yield_mod_cnt == opt_modulo - 1) { \
+			if (opt_sleep > 0) \
+				poll(NULL, 0, opt_sleep); \
+			if (opt_yield) \
+				sched_yield(); \
+			if (opt_signal) \
+				raise(SIGUSR1); \
+			yield_mod_cnt = 0; \
+		} else { \
+			yield_mod_cnt++; \
+		} \
+	} \
+}
+
+#else
+
+#define printf_verbose(fmt, ...)
+
+#endif /* BENCHMARK */
+
+#include "rseq.h"
+
+struct percpu_lock_entry {
+	intptr_t v;
+} __attribute__((aligned(128)));
+
+struct percpu_lock {
+	struct percpu_lock_entry c[CPU_SETSIZE];
+};
+
+struct test_data_entry {
+	intptr_t count;
+} __attribute__((aligned(128)));
+
+struct spinlock_test_data {
+	struct percpu_lock lock;
+	struct test_data_entry c[CPU_SETSIZE];
+};
+
+struct spinlock_thread_test_data {
+	struct spinlock_test_data *data;
+	long long reps;
+	int reg;
+};
+
+struct inc_test_data {
+	struct test_data_entry c[CPU_SETSIZE];
+};
+
+struct inc_thread_test_data {
+	struct inc_test_data *data;
+	long long reps;
+	int reg;
+};
+
+struct percpu_list_node {
+	intptr_t data;
+	struct percpu_list_node *next;
+};
+
+struct percpu_list_entry {
+	struct percpu_list_node *head;
+} __attribute__((aligned(128)));
+
+struct percpu_list {
+	struct percpu_list_entry c[CPU_SETSIZE];
+};
+
+#define BUFFER_ITEM_PER_CPU	100
+
+struct percpu_buffer_node {
+	intptr_t data;
+};
+
+struct percpu_buffer_entry {
+	intptr_t offset;
+	intptr_t buflen;
+	struct percpu_buffer_node **array;
+} __attribute__((aligned(128)));
+
+struct percpu_buffer {
+	struct percpu_buffer_entry c[CPU_SETSIZE];
+};
+
+#define MEMCPY_BUFFER_ITEM_PER_CPU	100
+
+struct percpu_memcpy_buffer_node {
+	intptr_t data1;
+	uint64_t data2;
+};
+
+struct percpu_memcpy_buffer_entry {
+	intptr_t offset;
+	intptr_t buflen;
+	struct percpu_memcpy_buffer_node *array;
+} __attribute__((aligned(128)));
+
+struct percpu_memcpy_buffer {
+	struct percpu_memcpy_buffer_entry c[CPU_SETSIZE];
+};
+
+/* A simple percpu spinlock.  Returns the cpu lock was acquired on. */
+static int rseq_percpu_lock(struct percpu_lock *lock)
+{
+	int cpu;
+
+	for (;;) {
+		int ret;
+
+#ifndef SKIP_FASTPATH
+		/* Try fast path. */
+		cpu = rseq_cpu_start();
+		ret = rseq_cmpeqv_storev(&lock->c[cpu].v,
+				0, 1, cpu);
+		if (likely(!ret))
+			break;
+		if (ret > 0)
+			continue;	/* Retry. */
+#endif
+	slowpath:
+		__attribute__((unused));
+		/* Fallback on cpu_opv system call. */
+		cpu = rseq_current_cpu();
+		ret = cpu_op_cmpeqv_storev(&lock->c[cpu].v, 0, 1, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	/*
+	 * Acquire semantic when taking lock after control dependency.
+	 * Matches rseq_smp_store_release().
+	 */
+	rseq_smp_acquire__after_ctrl_dep();
+	return cpu;
+}
+
+static void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	assert(lock->c[cpu].v == 1);
+	/*
+	 * Release lock, with release semantic. Matches
+	 * rseq_smp_acquire__after_ctrl_dep().
+	 */
+	rseq_smp_store_release(&lock->c[cpu].v, 0);
+}
+
+void *test_percpu_spinlock_thread(void *arg)
+{
+	struct spinlock_thread_test_data *thread_data = arg;
+	struct spinlock_test_data *data = thread_data->data;
+	int cpu;
+	long long i, reps;
+
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_register_current_thread())
+		abort();
+	reps = thread_data->reps;
+	for (i = 0; i < reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->c[cpu].count++;
+		rseq_percpu_unlock(&data->lock, cpu);
+#ifndef BENCHMARK
+		if (i != 0 && !(i % (reps / 10)))
+			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
+#endif
+	}
+	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
+		(int) gettid(), nr_abort, signals_delivered);
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_unregister_current_thread())
+		abort();
+	return NULL;
+}
+
+/*
+ * A simple test which implements a sharded counter using a per-cpu
+ * lock.  Obviously real applications might prefer to simply use a
+ * per-cpu increment; however, this is reasonable for a test and the
+ * lock can be extended to synchronize more complicated operations.
+ */
+void test_percpu_spinlock(void)
+{
+	const int num_threads = opt_threads;
+	int i, ret;
+	uint64_t sum;
+	pthread_t test_threads[num_threads];
+	struct spinlock_test_data data;
+	struct spinlock_thread_test_data thread_data[num_threads];
+
+	memset(&data, 0, sizeof(data));
+	for (i = 0; i < num_threads; i++) {
+		thread_data[i].reps = opt_reps;
+		if (opt_disable_mod <= 0 || (i % opt_disable_mod))
+			thread_data[i].reg = 1;
+		else
+			thread_data[i].reg = 0;
+		thread_data[i].data = &data;
+		ret = pthread_create(&test_threads[i], NULL,
+			test_percpu_spinlock_thread, &thread_data[i]);
+		if (ret) {
+			errno = ret;
+			perror("pthread_create");
+			abort();
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		pthread_join(test_threads[i], NULL);
+		if (ret) {
+			errno = ret;
+			perror("pthread_join");
+			abort();
+		}
+	}
+
+	sum = 0;
+	for (i = 0; i < CPU_SETSIZE; i++)
+		sum += data.c[i].count;
+
+	assert(sum == (uint64_t)opt_reps * num_threads);
+}
+
+void *test_percpu_inc_thread(void *arg)
+{
+	struct inc_thread_test_data *thread_data = arg;
+	struct inc_test_data *data = thread_data->data;
+	long long i, reps;
+
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_register_current_thread())
+		abort();
+	reps = thread_data->reps;
+	for (i = 0; i < reps; i++) {
+		int cpu, ret;
+
+#ifndef SKIP_FASTPATH
+		/* Try fast path. */
+		cpu = rseq_cpu_start();
+		ret = rseq_addv(&data->c[cpu].count, 1, cpu);
+		if (likely(!ret))
+			goto next;
+#endif
+	slowpath:
+		__attribute__((unused));
+		for (;;) {
+			/* Fallback on cpu_opv system call. */
+			cpu = rseq_current_cpu();
+			ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	next:
+		__attribute__((unused));
+#ifndef BENCHMARK
+		if (i != 0 && !(i % (reps / 10)))
+			printf_verbose("tid %d: count %lld\n", (int) gettid(), i);
+#endif
+	}
+	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
+		(int) gettid(), nr_abort, signals_delivered);
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_unregister_current_thread())
+		abort();
+	return NULL;
+}
+
+void test_percpu_inc(void)
+{
+	const int num_threads = opt_threads;
+	int i, ret;
+	uint64_t sum;
+	pthread_t test_threads[num_threads];
+	struct inc_test_data data;
+	struct inc_thread_test_data thread_data[num_threads];
+
+	memset(&data, 0, sizeof(data));
+	for (i = 0; i < num_threads; i++) {
+		thread_data[i].reps = opt_reps;
+		if (opt_disable_mod <= 0 || (i % opt_disable_mod))
+			thread_data[i].reg = 1;
+		else
+			thread_data[i].reg = 0;
+		thread_data[i].data = &data;
+		ret = pthread_create(&test_threads[i], NULL,
+			test_percpu_inc_thread, &thread_data[i]);
+		if (ret) {
+			errno = ret;
+			perror("pthread_create");
+			abort();
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		pthread_join(test_threads[i], NULL);
+		if (ret) {
+			errno = ret;
+			perror("pthread_join");
+			abort();
+		}
+	}
+
+	sum = 0;
+	for (i = 0; i < CPU_SETSIZE; i++)
+		sum += data.c[i].count;
+
+	assert(sum == (uint64_t)opt_reps * num_threads);
+}
+
+int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
+{
+	intptr_t *targetptr, newval, expect;
+	int cpu, ret;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load list->c[cpu].head with single-copy atomicity. */
+	expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+	newval = (intptr_t)node;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	node->next = (struct percpu_list_node *)expect;
+	ret = rseq_cmpeqv_storev(targetptr, expect, newval, cpu);
+	if (likely(!ret))
+		return cpu;
+#endif
+	/* Fallback on cpu_opv system call. */
+slowpath:
+	__attribute__((unused));
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load list->c[cpu].head with single-copy atomicity. */
+		expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+		newval = (intptr_t)node;
+		targetptr = (intptr_t *)&list->c[cpu].head;
+		node->next = (struct percpu_list_node *)expect;
+		ret = cpu_op_cmpeqv_storev(targetptr, expect, newval, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return cpu;
+}
+
+/*
+ * Unlike a traditional lock-less linked list; the availability of a
+ * rseq primitive allows us to implement pop without concerns over
+ * ABA-type races.
+ */
+struct percpu_list_node *percpu_list_pop(struct percpu_list *list)
+{
+	struct percpu_list_node *head;
+	int cpu, ret;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	ret = rseq_cmpnev_storeoffp_load((intptr_t *)&list->c[cpu].head,
+		(intptr_t)NULL,
+		offsetof(struct percpu_list_node, next),
+		(intptr_t *)&head, cpu);
+	if (likely(!ret))
+		return head;
+	if (ret > 0)
+		return NULL;
+#endif
+	/* Fallback on cpu_opv system call. */
+	slowpath:
+		__attribute__((unused));
+	for (;;) {
+		cpu = rseq_current_cpu();
+		ret = cpu_op_cmpnev_storeoffp_load(
+			(intptr_t *)&list->c[cpu].head,
+			(intptr_t)NULL,
+			offsetof(struct percpu_list_node, next),
+			(intptr_t *)&head, cpu);
+		if (likely(!ret))
+			break;
+		if (ret > 0)
+			return NULL;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	long long i, reps;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (!opt_disable_rseq && rseq_register_current_thread())
+		abort();
+
+	reps = opt_reps;
+	for (i = 0; i < reps; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+
+		if (opt_yield)
+			sched_yield();  /* encourage shuffling */
+		if (node)
+			percpu_list_push(list, node);
+	}
+
+	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
+		(int) gettid(), nr_abort, signals_delivered);
+	if (!opt_disable_rseq && rseq_unregister_current_thread())
+		abort();
+
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu linked list from many threads.  */
+void test_percpu_list(void)
+{
+	const int num_threads = opt_threads;
+	int i, j, ret;
+	uint64_t sum = 0, expected_sum = 0;
+	struct percpu_list list;
+	pthread_t test_threads[num_threads];
+	cpu_set_t allowed_cpus;
+
+	memset(&list, 0, sizeof(list));
+
+	/* Generate list entries for every usable cpu. */
+	sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus);
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+		for (j = 1; j <= 100; j++) {
+			struct percpu_list_node *node;
+
+			expected_sum += j;
+
+			node = malloc(sizeof(*node));
+			assert(node);
+			node->data = j;
+			node->next = list.c[i].head;
+			list.c[i].head = node;
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		ret = pthread_create(&test_threads[i], NULL,
+			test_percpu_list_thread, &list);
+		if (ret) {
+			errno = ret;
+			perror("pthread_create");
+			abort();
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		pthread_join(test_threads[i], NULL);
+		if (ret) {
+			errno = ret;
+			perror("pthread_join");
+			abort();
+		}
+	}
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		cpu_set_t pin_mask;
+		struct percpu_list_node *node;
+
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+
+		CPU_ZERO(&pin_mask);
+		CPU_SET(i, &pin_mask);
+		sched_setaffinity(0, sizeof(pin_mask), &pin_mask);
+
+		while ((node = percpu_list_pop(&list))) {
+			sum += node->data;
+			free(node);
+		}
+	}
+
+	/*
+	 * All entries should now be accounted for (unless some external
+	 * actor is interfering with our allowed affinity while this
+	 * test is running).
+	 */
+	assert(sum == expected_sum);
+}
+
+bool percpu_buffer_push(struct percpu_buffer *buffer,
+		struct percpu_buffer_node *node)
+{
+	intptr_t *targetptr_spec, newval_spec;
+	intptr_t *targetptr_final, newval_final;
+	int cpu, ret;
+	intptr_t offset;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == buffer->c[cpu].buflen) {
+		if (unlikely(cpu != rseq_current_cpu_raw()))
+			goto slowpath;
+		return false;
+	}
+	newval_spec = (intptr_t)node;
+	targetptr_spec = (intptr_t *)&buffer->c[cpu].array[offset];
+	newval_final = offset + 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	if (opt_mb)
+		ret = rseq_cmpeqv_trystorev_storev_release(targetptr_final,
+			offset, targetptr_spec, newval_spec,
+			newval_final, cpu);
+	else
+		ret = rseq_cmpeqv_trystorev_storev(targetptr_final,
+			offset, targetptr_spec, newval_spec,
+			newval_final, cpu);
+	if (likely(!ret))
+		return true;
+#endif
+slowpath:
+	__attribute__((unused));
+	/* Fallback on cpu_opv system call. */
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load offset with single-copy atomicity. */
+		offset = READ_ONCE(buffer->c[cpu].offset);
+		if (offset == buffer->c[cpu].buflen)
+			return false;
+		newval_spec = (intptr_t)node;
+		targetptr_spec = (intptr_t *)&buffer->c[cpu].array[offset];
+		newval_final = offset + 1;
+		targetptr_final = &buffer->c[cpu].offset;
+		if (opt_mb)
+			ret = cpu_op_cmpeqv_storev_mb_storev(targetptr_final,
+				offset, targetptr_spec, newval_spec,
+				newval_final, cpu);
+		else
+			ret = cpu_op_cmpeqv_storev_storev(targetptr_final,
+				offset, targetptr_spec, newval_spec,
+				newval_final, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return true;
+}
+
+struct percpu_buffer_node *percpu_buffer_pop(struct percpu_buffer *buffer)
+{
+	struct percpu_buffer_node *head;
+	intptr_t *targetptr, newval;
+	int cpu, ret;
+	intptr_t offset;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == 0) {
+		if (unlikely(cpu != rseq_current_cpu_raw()))
+			goto slowpath;
+		return NULL;
+	}
+	head = buffer->c[cpu].array[offset - 1];
+	newval = offset - 1;
+	targetptr = (intptr_t *)&buffer->c[cpu].offset;
+	ret = rseq_cmpeqv_cmpeqv_storev(targetptr, offset,
+		(intptr_t *)&buffer->c[cpu].array[offset - 1], (intptr_t)head,
+		newval, cpu);
+	if (likely(!ret))
+		return head;
+#endif
+slowpath:
+	__attribute__((unused));
+	/* Fallback on cpu_opv system call. */
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load offset with single-copy atomicity. */
+		offset = READ_ONCE(buffer->c[cpu].offset);
+		if (offset == 0)
+			return NULL;
+		head = buffer->c[cpu].array[offset - 1];
+		newval = offset - 1;
+		targetptr = (intptr_t *)&buffer->c[cpu].offset;
+		ret = cpu_op_cmpeqv_cmpeqv_storev(targetptr, offset,
+			(intptr_t *)&buffer->c[cpu].array[offset - 1],
+			(intptr_t)head, newval, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return head;
+}
+
+void *test_percpu_buffer_thread(void *arg)
+{
+	long long i, reps;
+	struct percpu_buffer *buffer = (struct percpu_buffer *)arg;
+
+	if (!opt_disable_rseq && rseq_register_current_thread())
+		abort();
+
+	reps = opt_reps;
+	for (i = 0; i < reps; i++) {
+		struct percpu_buffer_node *node = percpu_buffer_pop(buffer);
+
+		if (opt_yield)
+			sched_yield();  /* encourage shuffling */
+		if (node) {
+			if (!percpu_buffer_push(buffer, node)) {
+				/* Should increase buffer size. */
+				abort();
+			}
+		}
+	}
+
+	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
+		(int) gettid(), nr_abort, signals_delivered);
+	if (!opt_disable_rseq && rseq_unregister_current_thread())
+		abort();
+
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu buffer from many threads.  */
+void test_percpu_buffer(void)
+{
+	const int num_threads = opt_threads;
+	int i, j, ret;
+	uint64_t sum = 0, expected_sum = 0;
+	struct percpu_buffer buffer;
+	pthread_t test_threads[num_threads];
+	cpu_set_t allowed_cpus;
+
+	memset(&buffer, 0, sizeof(buffer));
+
+	/* Generate list entries for every usable cpu. */
+	sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus);
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+		/* Worse-case is every item in same CPU. */
+		buffer.c[i].array =
+			malloc(sizeof(*buffer.c[i].array) * CPU_SETSIZE
+				* BUFFER_ITEM_PER_CPU);
+		assert(buffer.c[i].array);
+		buffer.c[i].buflen = CPU_SETSIZE * BUFFER_ITEM_PER_CPU;
+		for (j = 1; j <= BUFFER_ITEM_PER_CPU; j++) {
+			struct percpu_buffer_node *node;
+
+			expected_sum += j;
+
+			/*
+			 * We could theoretically put the word-sized
+			 * "data" directly in the buffer. However, we
+			 * want to model objects that would not fit
+			 * within a single word, so allocate an object
+			 * for each node.
+			 */
+			node = malloc(sizeof(*node));
+			assert(node);
+			node->data = j;
+			buffer.c[i].array[j - 1] = node;
+			buffer.c[i].offset++;
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		ret = pthread_create(&test_threads[i], NULL,
+			test_percpu_buffer_thread, &buffer);
+		if (ret) {
+			errno = ret;
+			perror("pthread_create");
+			abort();
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		pthread_join(test_threads[i], NULL);
+		if (ret) {
+			errno = ret;
+			perror("pthread_join");
+			abort();
+		}
+	}
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		cpu_set_t pin_mask;
+		struct percpu_buffer_node *node;
+
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+
+		CPU_ZERO(&pin_mask);
+		CPU_SET(i, &pin_mask);
+		sched_setaffinity(0, sizeof(pin_mask), &pin_mask);
+
+		while ((node = percpu_buffer_pop(&buffer))) {
+			sum += node->data;
+			free(node);
+		}
+		free(buffer.c[i].array);
+	}
+
+	/*
+	 * All entries should now be accounted for (unless some external
+	 * actor is interfering with our allowed affinity while this
+	 * test is running).
+	 */
+	assert(sum == expected_sum);
+}
+
+bool percpu_memcpy_buffer_push(struct percpu_memcpy_buffer *buffer,
+		struct percpu_memcpy_buffer_node item)
+{
+	char *destptr, *srcptr;
+	size_t copylen;
+	intptr_t *targetptr_final, newval_final;
+	int cpu, ret;
+	intptr_t offset;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == buffer->c[cpu].buflen) {
+		if (unlikely(cpu != rseq_current_cpu_raw()))
+			goto slowpath;
+		return false;
+	}
+	destptr = (char *)&buffer->c[cpu].array[offset];
+	srcptr = (char *)&item;
+	copylen = sizeof(item);
+	newval_final = offset + 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	if (opt_mb)
+		ret = rseq_cmpeqv_trymemcpy_storev_release(targetptr_final,
+			offset, destptr, srcptr, copylen,
+			newval_final, cpu);
+	else
+		ret = rseq_cmpeqv_trymemcpy_storev(targetptr_final,
+			offset, destptr, srcptr, copylen,
+			newval_final, cpu);
+	if (likely(!ret))
+		return true;
+#endif
+slowpath:
+	__attribute__((unused));
+	/* Fallback on cpu_opv system call. */
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load offset with single-copy atomicity. */
+		offset = READ_ONCE(buffer->c[cpu].offset);
+		if (offset == buffer->c[cpu].buflen)
+			return false;
+		destptr = (char *)&buffer->c[cpu].array[offset];
+		srcptr = (char *)&item;
+		copylen = sizeof(item);
+		newval_final = offset + 1;
+		targetptr_final = &buffer->c[cpu].offset;
+		/* copylen must be <= PAGE_SIZE. */
+		if (opt_mb)
+			ret = cpu_op_cmpeqv_memcpy_mb_storev(targetptr_final,
+				offset, destptr, srcptr, copylen,
+				newval_final, cpu);
+		else
+			ret = cpu_op_cmpeqv_memcpy_storev(targetptr_final,
+				offset, destptr, srcptr, copylen,
+				newval_final, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return true;
+}
+
+bool percpu_memcpy_buffer_pop(struct percpu_memcpy_buffer *buffer,
+		struct percpu_memcpy_buffer_node *item)
+{
+	char *destptr, *srcptr;
+	size_t copylen;
+	intptr_t *targetptr_final, newval_final;
+	int cpu, ret;
+	intptr_t offset;
+
+#ifndef SKIP_FASTPATH
+	/* Try fast path. */
+	cpu = rseq_cpu_start();
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == 0) {
+		if (unlikely(cpu != rseq_current_cpu_raw()))
+			goto slowpath;
+		return false;
+	}
+	destptr = (char *)item;
+	srcptr = (char *)&buffer->c[cpu].array[offset - 1];
+	copylen = sizeof(*item);
+	newval_final = offset - 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	ret = rseq_cmpeqv_trymemcpy_storev(targetptr_final,
+		offset, destptr, srcptr, copylen,
+		newval_final, cpu);
+	if (likely(!ret))
+		return true;
+#endif
+slowpath:
+	__attribute__((unused));
+	/* Fallback on cpu_opv system call. */
+	for (;;) {
+		cpu = rseq_current_cpu();
+		/* Load offset with single-copy atomicity. */
+		offset = READ_ONCE(buffer->c[cpu].offset);
+		if (offset == 0)
+			return false;
+		destptr = (char *)item;
+		srcptr = (char *)&buffer->c[cpu].array[offset - 1];
+		copylen = sizeof(*item);
+		newval_final = offset - 1;
+		targetptr_final = &buffer->c[cpu].offset;
+		/* copylen must be <= PAGE_SIZE. */
+		ret = cpu_op_cmpeqv_memcpy_storev(targetptr_final,
+			offset, destptr, srcptr, copylen,
+			newval_final, cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	return true;
+}
+
+void *test_percpu_memcpy_buffer_thread(void *arg)
+{
+	long long i, reps;
+	struct percpu_memcpy_buffer *buffer = (struct percpu_memcpy_buffer *)arg;
+
+	if (!opt_disable_rseq && rseq_register_current_thread())
+		abort();
+
+	reps = opt_reps;
+	for (i = 0; i < reps; i++) {
+		struct percpu_memcpy_buffer_node item;
+		bool result;
+
+		result = percpu_memcpy_buffer_pop(buffer, &item);
+		if (opt_yield)
+			sched_yield();  /* encourage shuffling */
+		if (result) {
+			if (!percpu_memcpy_buffer_push(buffer, item)) {
+				/* Should increase buffer size. */
+				abort();
+			}
+		}
+	}
+
+	printf_verbose("tid %d: number of rseq abort: %d, signals delivered: %u\n",
+		(int) gettid(), nr_abort, signals_delivered);
+	if (!opt_disable_rseq && rseq_unregister_current_thread())
+		abort();
+
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu buffer from many threads.  */
+void test_percpu_memcpy_buffer(void)
+{
+	const int num_threads = opt_threads;
+	int i, j, ret;
+	uint64_t sum = 0, expected_sum = 0;
+	struct percpu_memcpy_buffer buffer;
+	pthread_t test_threads[num_threads];
+	cpu_set_t allowed_cpus;
+
+	memset(&buffer, 0, sizeof(buffer));
+
+	/* Generate list entries for every usable cpu. */
+	sched_getaffinity(0, sizeof(allowed_cpus), &allowed_cpus);
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+		/* Worse-case is every item in same CPU. */
+		buffer.c[i].array =
+			malloc(sizeof(*buffer.c[i].array) * CPU_SETSIZE
+				* MEMCPY_BUFFER_ITEM_PER_CPU);
+		assert(buffer.c[i].array);
+		buffer.c[i].buflen = CPU_SETSIZE * MEMCPY_BUFFER_ITEM_PER_CPU;
+		for (j = 1; j <= MEMCPY_BUFFER_ITEM_PER_CPU; j++) {
+			expected_sum += 2 * j + 1;
+
+			/*
+			 * We could theoretically put the word-sized
+			 * "data" directly in the buffer. However, we
+			 * want to model objects that would not fit
+			 * within a single word, so allocate an object
+			 * for each node.
+			 */
+			buffer.c[i].array[j - 1].data1 = j;
+			buffer.c[i].array[j - 1].data2 = j + 1;
+			buffer.c[i].offset++;
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		ret = pthread_create(&test_threads[i], NULL,
+			test_percpu_memcpy_buffer_thread, &buffer);
+		if (ret) {
+			errno = ret;
+			perror("pthread_create");
+			abort();
+		}
+	}
+
+	for (i = 0; i < num_threads; i++) {
+		pthread_join(test_threads[i], NULL);
+		if (ret) {
+			errno = ret;
+			perror("pthread_join");
+			abort();
+		}
+	}
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		cpu_set_t pin_mask;
+		struct percpu_memcpy_buffer_node item;
+
+		if (!CPU_ISSET(i, &allowed_cpus))
+			continue;
+
+		CPU_ZERO(&pin_mask);
+		CPU_SET(i, &pin_mask);
+		sched_setaffinity(0, sizeof(pin_mask), &pin_mask);
+
+		while (percpu_memcpy_buffer_pop(&buffer, &item)) {
+			sum += item.data1;
+			sum += item.data2;
+		}
+		free(buffer.c[i].array);
+	}
+
+	/*
+	 * All entries should now be accounted for (unless some external
+	 * actor is interfering with our allowed affinity while this
+	 * test is running).
+	 */
+	assert(sum == expected_sum);
+}
+
+static void test_signal_interrupt_handler(int signo)
+{
+	signals_delivered++;
+}
+
+static int set_signal_handler(void)
+{
+	int ret = 0;
+	struct sigaction sa;
+	sigset_t sigset;
+
+	ret = sigemptyset(&sigset);
+	if (ret < 0) {
+		perror("sigemptyset");
+		return ret;
+	}
+
+	sa.sa_handler = test_signal_interrupt_handler;
+	sa.sa_mask = sigset;
+	sa.sa_flags = 0;
+	ret = sigaction(SIGUSR1, &sa, NULL);
+	if (ret < 0) {
+		perror("sigaction");
+		return ret;
+	}
+
+	printf_verbose("Signal handler set for SIGUSR1\n");
+
+	return ret;
+}
+
+static void show_usage(int argc, char **argv)
+{
+	printf("Usage : %s <OPTIONS>\n",
+		argv[0]);
+	printf("OPTIONS:\n");
+	printf("	[-1 loops] Number of loops for delay injection 1\n");
+	printf("	[-2 loops] Number of loops for delay injection 2\n");
+	printf("	[-3 loops] Number of loops for delay injection 3\n");
+	printf("	[-4 loops] Number of loops for delay injection 4\n");
+	printf("	[-5 loops] Number of loops for delay injection 5\n");
+	printf("	[-6 loops] Number of loops for delay injection 6\n");
+	printf("	[-7 loops] Number of loops for delay injection 7 (-1 to enable -m)\n");
+	printf("	[-8 loops] Number of loops for delay injection 8 (-1 to enable -m)\n");
+	printf("	[-9 loops] Number of loops for delay injection 9 (-1 to enable -m)\n");
+	printf("	[-m N] Yield/sleep/kill every modulo N (default 0: disabled) (>= 0)\n");
+	printf("	[-y] Yield\n");
+	printf("	[-k] Kill thread with signal\n");
+	printf("	[-s S] S: =0: disabled (default), >0: sleep time (ms)\n");
+	printf("	[-t N] Number of threads (default 200)\n");
+	printf("	[-r N] Number of repetitions per thread (default 5000)\n");
+	printf("	[-d] Disable rseq system call (no initialization)\n");
+	printf("	[-D M] Disable rseq for each M threads\n");
+	printf("	[-T test] Choose test: (s)pinlock, (l)ist, (b)uffer, (m)emcpy, (i)ncrement\n");
+	printf("	[-M] Push into buffer and memcpy buffer with memory barriers.\n");
+	printf("	[-v] Verbose output.\n");
+	printf("	[-h] Show this help.\n");
+	printf("\n");
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	for (i = 1; i < argc; i++) {
+		if (argv[i][0] != '-')
+			continue;
+		switch (argv[i][1]) {
+		case '1':
+		case '2':
+		case '3':
+		case '4':
+		case '5':
+		case '6':
+		case '7':
+		case '8':
+		case '9':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			loop_cnt[argv[i][1] - '0'] = atol(argv[i + 1]);
+			i++;
+			break;
+		case 'm':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_modulo = atol(argv[i + 1]);
+			if (opt_modulo < 0) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 's':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_sleep = atol(argv[i + 1]);
+			if (opt_sleep < 0) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 'y':
+			opt_yield = 1;
+			break;
+		case 'k':
+			opt_signal = 1;
+			break;
+		case 'd':
+			opt_disable_rseq = 1;
+			break;
+		case 'D':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_disable_mod = atol(argv[i + 1]);
+			if (opt_disable_mod < 0) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 't':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_threads = atol(argv[i + 1]);
+			if (opt_threads < 0) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 'r':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_reps = atoll(argv[i + 1]);
+			if (opt_reps < 0) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 'h':
+			show_usage(argc, argv);
+			goto end;
+		case 'T':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_test = *argv[i + 1];
+			switch (opt_test) {
+			case 's':
+			case 'l':
+			case 'i':
+			case 'b':
+			case 'm':
+				break;
+			default:
+				show_usage(argc, argv);
+				goto error;
+			}
+			i++;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'M':
+			opt_mb = 1;
+			break;
+		default:
+			show_usage(argc, argv);
+			goto error;
+		}
+	}
+
+	if (set_signal_handler())
+		goto error;
+
+	if (!opt_disable_rseq && rseq_register_current_thread())
+		goto error;
+	switch (opt_test) {
+	case 's':
+		printf_verbose("spinlock\n");
+		test_percpu_spinlock();
+		break;
+	case 'l':
+		printf_verbose("linked list\n");
+		test_percpu_list();
+		break;
+	case 'b':
+		printf_verbose("buffer\n");
+		test_percpu_buffer();
+		break;
+	case 'm':
+		printf_verbose("memcpy buffer\n");
+		test_percpu_memcpy_buffer();
+		break;
+	case 'i':
+		printf_verbose("counter increment\n");
+		test_percpu_inc();
+		break;
+	}
+	if (!opt_disable_rseq && rseq_unregister_current_thread())
+		abort();
+end:
+	return 0;
+
+error:
+	return -1;
+}
diff --git a/tools/testing/selftests/rseq/rseq-arm.h b/tools/testing/selftests/rseq/rseq-arm.h
new file mode 100644
index 000000000000..47953c0cef4f
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -0,0 +1,535 @@
+/*
+ * rseq-arm.h
+ *
+ * (C) Copyright 2016 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#define RSEQ_SIG	0x53053053
+
+#define rseq_smp_mb()	__asm__ __volatile__ ("dmb" : : : "memory")
+#define rseq_smp_rmb()	__asm__ __volatile__ ("dmb" : : : "memory")
+#define rseq_smp_wmb()	__asm__ __volatile__ ("dmb" : : : "memory")
+
+#define rseq_smp_load_acquire(p)					\
+__extension__ ({							\
+	__typeof(*p) ____p1 = RSEQ_READ_ONCE(*p);			\
+	rseq_smp_mb();							\
+	____p1;								\
+})
+
+#define rseq_smp_acquire__after_ctrl_dep()	rseq_smp_rmb()
+
+#define rseq_smp_store_release(p, v)					\
+do {									\
+	rseq_smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define RSEQ_ASM_DEFINE_TABLE(section, version, flags,			\
+			start_ip, post_commit_offset, abort_ip)		\
+		".pushsection " __rseq_str(section) ", \"aw\"\n\t"	\
+		".balign 32\n\t"					\
+		".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
+		".word " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) ", 0x0\n\t" \
+		".popsection\n\t"
+
+#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)		\
+		RSEQ_INJECT_ASM(1)					\
+		"adr r0, " __rseq_str(cs_label) "\n\t"			\
+		"str r0, %[" __rseq_str(rseq_cs) "]\n\t"		\
+		__rseq_str(label) ":\n\t"
+
+#define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)		\
+		RSEQ_INJECT_ASM(2)					\
+		"ldr r0, %[" __rseq_str(current_cpu_id) "]\n\t"	\
+		"cmp %[" __rseq_str(cpu_id) "], r0\n\t"		\
+		"bne " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_DEFINE_ABORT(table_label, label, section, sig,		\
+			teardown, abort_label, version, flags, start_ip,\
+			post_commit_offset, abort_ip)			\
+		__rseq_str(table_label) ":\n\t"				\
+		".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
+		".word " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) ", 0x0\n\t" \
+		".word " __rseq_str(RSEQ_SIG) "\n\t"			\
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"b %l[" __rseq_str(abort_label) "]\n\t"
+
+#define RSEQ_ASM_DEFINE_CMPFAIL(label, section, teardown, cmpfail_label) \
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+		off_t voffp, intptr_t *load, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expectnot], r0\n\t"
+		"beq 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"str r0, %[load]\n\t"
+		"add r0, %[voffp]\n\t"
+		"ldr r0, [r0]\n\t"
+		/* final store */
+		"str r0, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expectnot]"r"(expectnot),
+		  [voffp]"Ir"(voffp),
+		  [load]"m"(*load)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_addv(intptr_t *v, intptr_t count, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"add r0, %[count]\n\t"
+		/* final store */
+		"str r0, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  [v]"m"(*v),
+		  [count]"Ir"(count)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		"str %[newv2], %[v2]\n\t"
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		"str %[newv2], %[v2]\n\t"
+		RSEQ_INJECT_ASM(5)
+		"dmb\n\t"	/* full mb provides store-release */
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t expect2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"ldr r0, %[v2]\n\t"
+		"cmp %[expect2], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG, "", abort,
+			0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* cmp2 input */
+		  [v2]"m"(*v2),
+		  [expect2]"r"(expect2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	uint32_t rseq_scratch[3];
+
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		"str %[src], %[rseq_scratch0]\n\t"
+		"str %[dst], %[rseq_scratch1]\n\t"
+		"str %[len], %[rseq_scratch2]\n\t"
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		"cmp %[len], #0\n\t" \
+		"beq 333f\n\t" \
+		"222:\n\t" \
+		"ldrb %%r0, [%[src]]\n\t" \
+		"strb %%r0, [%[dst]]\n\t" \
+		"adds %[src], #1\n\t" \
+		"adds %[dst], #1\n\t" \
+		"subs %[len], #1\n\t" \
+		"bne 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		"ldr %[len], %[rseq_scratch2]\n\t"
+		"ldr %[dst], %[rseq_scratch1]\n\t"
+		"ldr %[src], %[rseq_scratch0]\n\t"
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG,
+			/* teardown */
+			"ldr %[len], %[rseq_scratch2]\n\t"
+			"ldr %[dst], %[rseq_scratch1]\n\t"
+			"ldr %[src], %[rseq_scratch0]\n\t",
+			abort, 0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure,
+			/* teardown */
+			"ldr %[len], %[rseq_scratch2]\n\t"
+			"ldr %[dst], %[rseq_scratch1]\n\t"
+			"ldr %[src], %[rseq_scratch0]\n\t",
+			cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len),
+		  [rseq_scratch0]"m"(rseq_scratch[0]),
+		  [rseq_scratch1]"m"(rseq_scratch[1]),
+		  [rseq_scratch2]"m"(rseq_scratch[2])
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	uint32_t rseq_scratch[3];
+
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		"str %[src], %[rseq_scratch0]\n\t"
+		"str %[dst], %[rseq_scratch1]\n\t"
+		"str %[len], %[rseq_scratch2]\n\t"
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"ldr r0, %[v]\n\t"
+		"cmp %[expect], r0\n\t"
+		"bne 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		"cmp %[len], #0\n\t" \
+		"beq 333f\n\t" \
+		"222:\n\t" \
+		"ldrb %%r0, [%[src]]\n\t" \
+		"strb %%r0, [%[dst]]\n\t" \
+		"adds %[src], #1\n\t" \
+		"adds %[dst], #1\n\t" \
+		"subs %[len], #1\n\t" \
+		"bne 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(5)
+		"dmb\n\t"	/* full mb provides store-release */
+		/* final store */
+		"str %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		"ldr %[len], %[rseq_scratch2]\n\t"
+		"ldr %[dst], %[rseq_scratch1]\n\t"
+		"ldr %[src], %[rseq_scratch0]\n\t"
+		"b 6f\n\t"
+		RSEQ_ASM_DEFINE_ABORT(3, 4, __rseq_failure, RSEQ_SIG,
+			/* teardown */
+			"ldr %[len], %[rseq_scratch2]\n\t"
+			"ldr %[dst], %[rseq_scratch1]\n\t"
+			"ldr %[src], %[rseq_scratch0]\n\t",
+			abort, 0x0, 0x0, 1b, 2b-1b, 4f)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure,
+			/* teardown */
+			"ldr %[len], %[rseq_scratch2]\n\t"
+			"ldr %[dst], %[rseq_scratch1]\n\t"
+			"ldr %[src], %[rseq_scratch0]\n\t",
+			cmpfail)
+		"6:\n\t"
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len),
+		  [rseq_scratch0]"m"(rseq_scratch[0]),
+		  [rseq_scratch1]"m"(rseq_scratch[1]),
+		  [rseq_scratch2]"m"(rseq_scratch[2])
+		  RSEQ_INJECT_INPUT
+		: "r0", "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selftests/rseq/rseq-ppc.h
new file mode 100644
index 000000000000..3db6be5ceffb
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -0,0 +1,567 @@
+/*
+ * rseq-ppc.h
+ *
+ * (C) Copyright 2016 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ * (C) Copyright 2016 - Boqun Feng <boqun.feng@gmail.com>
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
+#define RSEQ_SIG	0x53053053
+
+#define rseq_smp_mb()		__asm__ __volatile__ ("sync" : : : "memory")
+#define rseq_smp_lwsync()	__asm__ __volatile__ ("lwsync" : : : "memory")
+#define rseq_smp_rmb()		rseq_smp_lwsync()
+#define rseq_smp_wmb()		rseq_smp_lwsync()
+
+#define rseq_smp_load_acquire(p)					\
+__extension__ ({							\
+	__typeof(*p) ____p1 = RSEQ_READ_ONCE(*p);			\
+	rseq_smp_lwsync();						\
+	____p1;								\
+})
+
+#define rseq_smp_acquire__after_ctrl_dep()	rseq_smp_lwsync()
+
+#define rseq_smp_store_release(p, v)					\
+do {									\
+	rseq_smp_lwsync();						\
+	RSEQ_WRITE_ONCE(*p, v);						\
+} while (0)
+
+/*
+ * The __rseq_table section can be used by debuggers to better handle
+ * single-stepping through the restartable critical sections.
+ */
+
+#ifdef __PPC64__
+
+#define STORE_WORD	"std "
+#define LOAD_WORD	"ld "
+#define LOADX_WORD	"ldx "
+#define CMP_WORD	"cmpd "
+
+#define RSEQ_ASM_DEFINE_TABLE(label, section, version, flags,			\
+			start_ip, post_commit_offset, abort_ip)			\
+		".pushsection " __rseq_str(section) ", \"aw\"\n\t"		\
+		".balign 32\n\t"						\
+		__rseq_str(label) ":\n\t"					\
+		".long " __rseq_str(version) ", " __rseq_str(flags) "\n\t"	\
+		".quad " __rseq_str(start_ip) ", " __rseq_str(post_commit_offset) ", " __rseq_str(abort_ip) "\n\t" \
+		".popsection\n\t"
+
+#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)			\
+		RSEQ_INJECT_ASM(1)						\
+		"lis %%r17, (" __rseq_str(cs_label) ")@highest\n\t"		\
+		"ori %%r17, %%r17, (" __rseq_str(cs_label) ")@higher\n\t"	\
+		"rldicr %%r17, %%r17, 32, 31\n\t"				\
+		"oris %%r17, %%r17, (" __rseq_str(cs_label) ")@high\n\t"	\
+		"ori %%r17, %%r17, (" __rseq_str(cs_label) ")@l\n\t"		\
+		"std %%r17, %[" __rseq_str(rseq_cs) "]\n\t"			\
+		__rseq_str(label) ":\n\t"
+
+#else /* #ifdef __PPC64__ */
+
+#define STORE_WORD	"stw "
+#define LOAD_WORD	"lwz "
+#define LOADX_WORD	"lwzx "
+#define CMP_WORD	"cmpw "
+
+#define RSEQ_ASM_DEFINE_TABLE(label, section, version, flags,			\
+			start_ip, post_commit_offset, abort_ip)			\
+		".pushsection " __rseq_str(section) ", \"aw\"\n\t"		\
+		".balign 32\n\t"						\
+		__rseq_str(label) ":\n\t"					\
+		".long " __rseq_str(version) ", " __rseq_str(flags) "\n\t"	\
+		/* 32-bit only supported on BE */				\
+		".long 0x0, " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) "\n\t" \
+		".popsection\n\t"
+
+#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)			\
+		RSEQ_INJECT_ASM(1)						\
+		"lis %%r17, (" __rseq_str(cs_label) ")@ha\n\t"			\
+		"addi %%r17, %%r17, (" __rseq_str(cs_label) ")@l\n\t"		\
+		"stw %%r17, %[" __rseq_str(rseq_cs) "]\n\t"			\
+		__rseq_str(label) ":\n\t"
+
+#endif /* #ifdef __PPC64__ */
+
+#define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)			\
+		RSEQ_INJECT_ASM(2)						\
+		"lwz %%r17, %[" __rseq_str(current_cpu_id) "]\n\t"		\
+		"cmpw cr7, %[" __rseq_str(cpu_id) "], %%r17\n\t"		\
+		"bne- cr7, " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_DEFINE_ABORT(label, section, sig, teardown, abort_label)	\
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"		\
+		".long " __rseq_str(sig) "\n\t"					\
+		__rseq_str(label) ":\n\t"					\
+		teardown							\
+		"b %l[" __rseq_str(abort_label) "]\n\t"			\
+		".popsection\n\t"
+
+#define RSEQ_ASM_DEFINE_CMPFAIL(label, section, teardown, cmpfail_label)	\
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"		\
+		__rseq_str(label) ":\n\t"					\
+		teardown							\
+		"b %l[" __rseq_str(cmpfail_label) "]\n\t"			\
+		".popsection\n\t"
+
+
+/*
+ * RSEQ_ASM_OPs: asm operations for rseq
+ * 	RSEQ_ASM_OP_R_*: has hard-code registers in it
+ * 	RSEQ_ASM_OP_* (else): doesn't have hard-code registers(unless cr7)
+ */
+#define RSEQ_ASM_OP_CMPEQ(var, expect, label)					\
+		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
+		CMP_WORD "cr7, %%r17, %[" __rseq_str(expect) "]\n\t"		\
+		"bne- cr7, " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_OP_CMPNE(var, expectnot, label)				\
+		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
+		CMP_WORD "cr7, %%r17, %[" __rseq_str(expectnot) "]\n\t"	\
+		"beq- cr7, " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_OP_STORE(value, var)						\
+		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"
+
+/* Load @var to r17 */
+#define RSEQ_ASM_OP_R_LOAD(var)							\
+		LOAD_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+
+/* Store r17 to @var */
+#define RSEQ_ASM_OP_R_STORE(var)						\
+		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"
+
+/* Add @count to r17 */
+#define RSEQ_ASM_OP_R_ADD(count)						\
+		"add %%r17, %[" __rseq_str(count) "], %%r17\n\t"
+
+/* Load (r17 + voffp) to r17 */
+#define RSEQ_ASM_OP_R_LOADX(voffp)						\
+		LOADX_WORD "%%r17, %[" __rseq_str(voffp) "], %%r17\n\t"
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_ASM_OP_R_MEMCPY() \
+		"cmpdi %%r19, 0\n\t" \
+		"beq 333f\n\t" \
+		"addi %%r20, %%r20, -1\n\t" \
+		"addi %%r21, %%r21, -1\n\t" \
+		"222:\n\t" \
+		"lbzu %%r18, 1(%%r20)\n\t" \
+		"stbu %%r18, 1(%%r21)\n\t" \
+		"addi %%r19, %%r19, -1\n\t" \
+		"cmpdi %%r19, 0\n\t" \
+		"bne 222b\n\t" \
+		"333:\n\t" \
+
+#define RSEQ_ASM_OP_R_FINAL_STORE(var, post_commit_label)			\
+		STORE_WORD "%%r17, %[" __rseq_str(var) "]\n\t"			\
+		__rseq_str(post_commit_label) ":\n\t"
+
+#define RSEQ_ASM_OP_FINAL_STORE(value, var, post_commit_label)			\
+		STORE_WORD "%[" __rseq_str(value) "], %[" __rseq_str(var) "]\n\t"	\
+		__rseq_str(post_commit_label) ":\n\t"
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+		off_t voffp, intptr_t *load, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v not equal to @expectnot */
+		RSEQ_ASM_OP_CMPNE(v, expectnot, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* load the value of @v */
+		RSEQ_ASM_OP_R_LOAD(v)
+		/* store it in @load */
+		RSEQ_ASM_OP_R_STORE(load)
+		/* dereference voffp(v) */
+		RSEQ_ASM_OP_R_LOADX(voffp)
+		/* final store the value at voffp(v) */
+		RSEQ_ASM_OP_R_FINAL_STORE(v, 2)
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expectnot]"r"(expectnot),
+		  [voffp]"b"(voffp),
+		  [load]"m"(*load)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_addv(intptr_t *v, intptr_t count, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* load the value of @v */
+		RSEQ_ASM_OP_R_LOAD(v)
+		/* add @count to it */
+		RSEQ_ASM_OP_R_ADD(count)
+		/* final store */
+		RSEQ_ASM_OP_R_FINAL_STORE(v, 2)
+		RSEQ_INJECT_ASM(4)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [count]"r"(count)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		RSEQ_ASM_OP_STORE(newv2, v2)
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		RSEQ_ASM_OP_STORE(newv2, v2)
+		RSEQ_INJECT_ASM(5)
+		/* for 'release' */
+		"lwsync\n\t"
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t expect2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* cmp @v2 equal to @expct2 */
+		RSEQ_ASM_OP_CMPEQ(v2, expect2, 5f)
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* cmp2 input */
+		  [v2]"m"(*v2),
+		  [expect2]"r"(expect2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		/* setup for mempcy */
+		"mr %%r19, %[len]\n\t" \
+		"mr %%r20, %[src]\n\t" \
+		"mr %%r21, %[dst]\n\t" \
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		RSEQ_ASM_OP_R_MEMCPY()
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17", "r18", "r19", "r20", "r21"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		/* setup for mempcy */
+		"mr %%r19, %[len]\n\t" \
+		"mr %%r20, %[src]\n\t" \
+		"mr %%r21, %[dst]\n\t" \
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		/* cmp cpuid */
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* cmp @v equal to @expect */
+		RSEQ_ASM_OP_CMPEQ(v, expect, 5f)
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		RSEQ_ASM_OP_R_MEMCPY()
+		RSEQ_INJECT_ASM(5)
+		/* for 'release' */
+		"lwsync\n\t"
+		/* final store */
+		RSEQ_ASM_OP_FINAL_STORE(newv, v, 2)
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "r17", "r18", "r19", "r20", "r21"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+#undef STORE_WORD
+#undef LOAD_WORD
+#undef LOADX_WORD
+#undef CMP_WORD
diff --git a/tools/testing/selftests/rseq/rseq-x86.h b/tools/testing/selftests/rseq/rseq-x86.h
new file mode 100644
index 000000000000..63e81d6c61fa
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -0,0 +1,898 @@
+/*
+ * rseq-x86.h
+ *
+ * (C) Copyright 2016 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#include <stdint.h>
+
+#define RSEQ_SIG	0x53053053
+
+#ifdef __x86_64__
+
+#define rseq_smp_mb()	__asm__ __volatile__ ("mfence" : : : "memory")
+#define rseq_smp_rmb()	barrier()
+#define rseq_smp_wmb()	barrier()
+
+#define rseq_smp_load_acquire(p)					\
+__extension__ ({							\
+	__typeof(*p) ____p1 = RSEQ_READ_ONCE(*p);			\
+	barrier();							\
+	____p1;								\
+})
+
+#define rseq_smp_acquire__after_ctrl_dep()	rseq_smp_rmb()
+
+#define rseq_smp_store_release(p, v)					\
+do {									\
+	barrier();							\
+	RSEQ_WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define RSEQ_ASM_DEFINE_TABLE(label, section, version, flags,		\
+			start_ip, post_commit_offset, abort_ip)		\
+		".pushsection " __rseq_str(section) ", \"aw\"\n\t"	\
+		".balign 32\n\t"					\
+		__rseq_str(label) ":\n\t"				\
+		".long " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
+		".quad " __rseq_str(start_ip) ", " __rseq_str(post_commit_offset) ", " __rseq_str(abort_ip) "\n\t" \
+		".popsection\n\t"
+
+#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)		\
+		RSEQ_INJECT_ASM(1)					\
+		"leaq " __rseq_str(cs_label) "(%%rip), %%rax\n\t"	\
+		"movq %%rax, %[" __rseq_str(rseq_cs) "]\n\t"		\
+		__rseq_str(label) ":\n\t"
+
+#define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)		\
+		RSEQ_INJECT_ASM(2)					\
+		"cmpl %[" __rseq_str(cpu_id) "], %[" __rseq_str(current_cpu_id) "]\n\t" \
+		"jnz " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_DEFINE_ABORT(label, section, sig, teardown, abort_label) \
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
+		/* Disassembler-friendly signature: nopl <sig>(%rip). */\
+		".byte 0x0f, 0x1f, 0x05\n\t"				\
+		".long " __rseq_str(sig) "\n\t"			\
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"jmp %l[" __rseq_str(abort_label) "]\n\t"		\
+		".popsection\n\t"
+
+#define RSEQ_ASM_DEFINE_CMPFAIL(label, section, teardown, cmpfail_label) \
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"jmp %l[" __rseq_str(cmpfail_label) "]\n\t"		\
+		".popsection\n\t"
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpq %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* final store */
+		"movq %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+		off_t voffp, intptr_t *load, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpq %[v], %[expectnot]\n\t"
+		"jz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"movq %[v], %%rax\n\t"
+		"movq %%rax, %[load]\n\t"
+		"addq %[voffp], %%rax\n\t"
+		"movq (%%rax), %%rax\n\t"
+		/* final store */
+		"movq %%rax, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expectnot]"r"(expectnot),
+		  [voffp]"er"(voffp),
+		  [load]"m"(*load)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_addv(intptr_t *v, intptr_t count, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* final store */
+		"addq %[count], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [count]"er"(count)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpq %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		"movq %[newv2], %[v2]\n\t"
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"movq %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+/* x86-64 is TSO. */
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	return rseq_cmpeqv_trystorev_storev(v, expect, v2, newv2,
+			newv, cpu);
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t expect2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpq %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"cmpq %[v2], %[expect2]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"movq %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* cmp2 input */
+		  [v2]"m"(*v2),
+		  [expect2]"r"(expect2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	uint64_t rseq_scratch[3];
+
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		"movq %[src], %[rseq_scratch0]\n\t"
+		"movq %[dst], %[rseq_scratch1]\n\t"
+		"movq %[len], %[rseq_scratch2]\n\t"
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpq %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		"test %[len], %[len]\n\t" \
+		"jz 333f\n\t" \
+		"222:\n\t" \
+		"movb (%[src]), %%al\n\t" \
+		"movb %%al, (%[dst])\n\t" \
+		"inc %[src]\n\t" \
+		"inc %[dst]\n\t" \
+		"dec %[len]\n\t" \
+		"jnz 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"movq %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		"movq %[rseq_scratch2], %[len]\n\t"
+		"movq %[rseq_scratch1], %[dst]\n\t"
+		"movq %[rseq_scratch0], %[src]\n\t"
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG,
+			"movq %[rseq_scratch2], %[len]\n\t"
+			"movq %[rseq_scratch1], %[dst]\n\t"
+			"movq %[rseq_scratch0], %[src]\n\t",
+			abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure,
+			"movq %[rseq_scratch2], %[len]\n\t"
+			"movq %[rseq_scratch1], %[dst]\n\t"
+			"movq %[rseq_scratch0], %[src]\n\t",
+			cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len),
+		  [rseq_scratch0]"m"(rseq_scratch[0]),
+		  [rseq_scratch1]"m"(rseq_scratch[1]),
+		  [rseq_scratch2]"m"(rseq_scratch[2])
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "rax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+/* x86-64 is TSO. */
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	return rseq_cmpeqv_trymemcpy_storev(v, expect, dst, src,
+			len, newv, cpu);
+}
+
+#elif __i386__
+
+/*
+ * Support older 32-bit architectures that do not implement fence
+ * instructions.
+ */
+#define rseq_smp_mb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+#define rseq_smp_rmb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+#define rseq_smp_wmb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+
+#define rseq_smp_load_acquire(p)					\
+__extension__ ({							\
+	__typeof(*p) ____p1 = RSEQ_READ_ONCE(*p);			\
+	rseq_smp_mb();							\
+	____p1;								\
+})
+
+#define rseq_smp_acquire__after_ctrl_dep()	rseq_smp_rmb()
+
+#define rseq_smp_store_release(p, v)					\
+do {									\
+	rseq_smp_mb();							\
+	RSEQ_WRITE_ONCE(*p, v);						\
+} while (0)
+
+/*
+ * Use eax as scratch register and take memory operands as input to
+ * lessen register pressure. Especially needed when compiling in O0.
+ */
+#define RSEQ_ASM_DEFINE_TABLE(label, section, version, flags,		\
+			start_ip, post_commit_offset, abort_ip)		\
+		".pushsection " __rseq_str(section) ", \"aw\"\n\t"	\
+		".balign 32\n\t"					\
+		__rseq_str(label) ":\n\t"				\
+		".long " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
+		".long " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) ", 0x0\n\t" \
+		".popsection\n\t"
+
+#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)		\
+		RSEQ_INJECT_ASM(1)					\
+		"movl $" __rseq_str(cs_label) ", %[rseq_cs]\n\t"	\
+		__rseq_str(label) ":\n\t"
+
+#define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)		\
+		RSEQ_INJECT_ASM(2)					\
+		"cmpl %[" __rseq_str(cpu_id) "], %[" __rseq_str(current_cpu_id) "]\n\t" \
+		"jnz " __rseq_str(label) "\n\t"
+
+#define RSEQ_ASM_DEFINE_ABORT(label, section, sig, teardown, abort_label) \
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
+		/* Disassembler-friendly signature: nopl <sig>. */\
+		".byte 0x0f, 0x1f, 0x05\n\t"				\
+		".long " __rseq_str(sig) "\n\t"			\
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"jmp %l[" __rseq_str(abort_label) "]\n\t"		\
+		".popsection\n\t"
+
+#define RSEQ_ASM_DEFINE_CMPFAIL(label, section, teardown, cmpfail_label) \
+		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
+		__rseq_str(label) ":\n\t"				\
+		teardown						\
+		"jmp %l[" __rseq_str(cmpfail_label) "]\n\t"		\
+		".popsection\n\t"
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpl %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* final store */
+		"movl %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
+		off_t voffp, intptr_t *load, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpl %[v], %[expectnot]\n\t"
+		"jz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"movl %[v], %%eax\n\t"
+		"movl %%eax, %[load]\n\t"
+		"addl %[voffp], %%eax\n\t"
+		"movl (%%eax), %%eax\n\t"
+		/* final store */
+		"movl %%eax, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(5)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expectnot]"r"(expectnot),
+		  [voffp]"ir"(voffp),
+		  [load]"m"(*load)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_addv(intptr_t *v, intptr_t count, int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		/* final store */
+		"addl %[count], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [count]"ir"(count)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpl %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		"movl %[newv2], %%eax\n\t"
+		"movl %%eax, %[v2]\n\t"
+		RSEQ_INJECT_ASM(5)
+		/* final store */
+		"movl %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"m"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t newv2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"movl %[expect], %%eax\n\t"
+		"cmpl %[v], %%eax\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try store */
+		"movl %[newv2], %[v2]\n\t"
+		RSEQ_INJECT_ASM(5)
+		"lock; addl $0,0(%%esp)\n\t"
+		/* final store */
+		"movl %[newv], %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* try store input */
+		  [v2]"m"(*v2),
+		  [newv2]"r"(newv2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"m"(expect),
+		  [newv]"r"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
+		intptr_t *v2, intptr_t expect2, intptr_t newv,
+		int cpu)
+{
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"cmpl %[v], %[expect]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		"cmpl %[expect2], %[v2]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(5)
+		"movl %[newv], %%eax\n\t"
+		/* final store */
+		"movl %%eax, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* cmp2 input */
+		  [v2]"m"(*v2),
+		  [expect2]"r"(expect2),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"r"(expect),
+		  [newv]"m"(newv)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+/* TODO: implement a faster memcpy. */
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	uint32_t rseq_scratch[3];
+
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		"movl %[src], %[rseq_scratch0]\n\t"
+		"movl %[dst], %[rseq_scratch1]\n\t"
+		"movl %[len], %[rseq_scratch2]\n\t"
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"movl %[expect], %%eax\n\t"
+		"cmpl %%eax, %[v]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		"test %[len], %[len]\n\t" \
+		"jz 333f\n\t" \
+		"222:\n\t" \
+		"movb (%[src]), %%al\n\t" \
+		"movb %%al, (%[dst])\n\t" \
+		"inc %[src]\n\t" \
+		"inc %[dst]\n\t" \
+		"dec %[len]\n\t" \
+		"jnz 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(5)
+		"movl %[newv], %%eax\n\t"
+		/* final store */
+		"movl %%eax, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		"movl %[rseq_scratch2], %[len]\n\t"
+		"movl %[rseq_scratch1], %[dst]\n\t"
+		"movl %[rseq_scratch0], %[src]\n\t"
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG,
+			"movl %[rseq_scratch2], %[len]\n\t"
+			"movl %[rseq_scratch1], %[dst]\n\t"
+			"movl %[rseq_scratch0], %[src]\n\t",
+			abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure,
+			"movl %[rseq_scratch2], %[len]\n\t"
+			"movl %[rseq_scratch1], %[dst]\n\t"
+			"movl %[rseq_scratch0], %[src]\n\t",
+			cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"m"(expect),
+		  [newv]"m"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len),
+		  [rseq_scratch0]"m"(rseq_scratch[0]),
+		  [rseq_scratch1]"m"(rseq_scratch[1]),
+		  [rseq_scratch2]"m"(rseq_scratch[2])
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+/* TODO: implement a faster memcpy. */
+static inline __attribute__((always_inline))
+int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
+		void *dst, void *src, size_t len, intptr_t newv,
+		int cpu)
+{
+	uint32_t rseq_scratch[3];
+
+	RSEQ_INJECT_C(9)
+
+	__asm__ __volatile__ goto (
+		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
+		"movl %[src], %[rseq_scratch0]\n\t"
+		"movl %[dst], %[rseq_scratch1]\n\t"
+		"movl %[len], %[rseq_scratch2]\n\t"
+		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
+		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
+		RSEQ_INJECT_ASM(3)
+		"movl %[expect], %%eax\n\t"
+		"cmpl %%eax, %[v]\n\t"
+		"jnz 5f\n\t"
+		RSEQ_INJECT_ASM(4)
+		/* try memcpy */
+		"test %[len], %[len]\n\t" \
+		"jz 333f\n\t" \
+		"222:\n\t" \
+		"movb (%[src]), %%al\n\t" \
+		"movb %%al, (%[dst])\n\t" \
+		"inc %[src]\n\t" \
+		"inc %[dst]\n\t" \
+		"dec %[len]\n\t" \
+		"jnz 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(5)
+		"lock; addl $0,0(%%esp)\n\t"
+		"movl %[newv], %%eax\n\t"
+		/* final store */
+		"movl %%eax, %[v]\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(6)
+		/* teardown */
+		"movl %[rseq_scratch2], %[len]\n\t"
+		"movl %[rseq_scratch1], %[dst]\n\t"
+		"movl %[rseq_scratch0], %[src]\n\t"
+		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG,
+			"movl %[rseq_scratch2], %[len]\n\t"
+			"movl %[rseq_scratch1], %[dst]\n\t"
+			"movl %[rseq_scratch0], %[src]\n\t",
+			abort)
+		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure,
+			"movl %[rseq_scratch2], %[len]\n\t"
+			"movl %[rseq_scratch1], %[dst]\n\t"
+			"movl %[rseq_scratch0], %[src]\n\t",
+			cmpfail)
+		: /* gcc asm goto does not allow outputs */
+		: [cpu_id]"r"(cpu),
+		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
+		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
+		  /* final store input */
+		  [v]"m"(*v),
+		  [expect]"m"(expect),
+		  [newv]"m"(newv),
+		  /* try memcpy input */
+		  [dst]"r"(dst),
+		  [src]"r"(src),
+		  [len]"r"(len),
+		  [rseq_scratch0]"m"(rseq_scratch[0]),
+		  [rseq_scratch1]"m"(rseq_scratch[1]),
+		  [rseq_scratch2]"m"(rseq_scratch[2])
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc", "eax"
+		  RSEQ_INJECT_CLOBBER
+		: abort, cmpfail
+	);
+	return 0;
+abort:
+	RSEQ_INJECT_FAILED
+	return -1;
+cmpfail:
+	return 1;
+}
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
new file mode 100644
index 000000000000..b83d3196c33e
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -0,0 +1,116 @@
+/*
+ * rseq.c
+ *
+ * Copyright (C) 2016 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#include "rseq.h"
+
+#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
+
+__attribute__((tls_model("initial-exec"))) __thread
+volatile struct rseq __rseq_abi = {
+	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
+};
+
+static __attribute__((tls_model("initial-exec"))) __thread
+volatile int refcount;
+
+static void signal_off_save(sigset_t *oldset)
+{
+	sigset_t set;
+	int ret;
+
+	sigfillset(&set);
+	ret = pthread_sigmask(SIG_BLOCK, &set, oldset);
+	if (ret)
+		abort();
+}
+
+static void signal_restore(sigset_t oldset)
+{
+	int ret;
+
+	ret = pthread_sigmask(SIG_SETMASK, &oldset, NULL);
+	if (ret)
+		abort();
+}
+
+static int sys_rseq(volatile struct rseq *rseq_abi, uint32_t rseq_len,
+		int flags, uint32_t sig)
+{
+	return syscall(__NR_rseq, rseq_abi, rseq_len, flags, sig);
+}
+
+int rseq_register_current_thread(void)
+{
+	int rc, ret = 0;
+	sigset_t oldset;
+
+	signal_off_save(&oldset);
+	if (refcount++)
+		goto end;
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq), 0, RSEQ_SIG);
+	if (!rc) {
+		assert(rseq_current_cpu_raw() >= 0);
+		goto end;
+	}
+	if (errno != EBUSY)
+		__rseq_abi.cpu_id = -2;
+	ret = -1;
+	refcount--;
+end:
+	signal_restore(oldset);
+	return ret;
+}
+
+int rseq_unregister_current_thread(void)
+{
+	int rc, ret = 0;
+	sigset_t oldset;
+
+	signal_off_save(&oldset);
+	if (--refcount)
+		goto end;
+	rc = sys_rseq(&__rseq_abi, sizeof(struct rseq),
+			RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
+	if (!rc)
+		goto end;
+	ret = -1;
+end:
+	signal_restore(oldset);
+	return ret;
+}
+
+int32_t rseq_fallback_current_cpu(void)
+{
+	int32_t cpu;
+
+	cpu = sched_getcpu();
+	if (cpu < 0) {
+		perror("sched_getcpu()");
+		abort();
+	}
+	return cpu;
+}
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
new file mode 100644
index 000000000000..26c8ea01e940
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -0,0 +1,154 @@
+/*
+ * rseq.h
+ *
+ * (C) Copyright 2016 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
+#ifndef RSEQ_H
+#define RSEQ_H
+
+#include <stdint.h>
+#include <stdbool.h>
+#include <pthread.h>
+#include <signal.h>
+#include <sched.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sched.h>
+#include <linux/rseq.h>
+
+/*
+ * Empty code injection macros, override when testing.
+ * It is important to consider that the ASM injection macros need to be
+ * fully reentrant (e.g. do not modify the stack).
+ */
+#ifndef RSEQ_INJECT_ASM
+#define RSEQ_INJECT_ASM(n)
+#endif
+
+#ifndef RSEQ_INJECT_C
+#define RSEQ_INJECT_C(n)
+#endif
+
+#ifndef RSEQ_INJECT_INPUT
+#define RSEQ_INJECT_INPUT
+#endif
+
+#ifndef RSEQ_INJECT_CLOBBER
+#define RSEQ_INJECT_CLOBBER
+#endif
+
+#ifndef RSEQ_INJECT_FAILED
+#define RSEQ_INJECT_FAILED
+#endif
+
+extern __thread volatile struct rseq __rseq_abi;
+
+#define rseq_likely(x)		__builtin_expect(!!(x), 1)
+#define rseq_unlikely(x)	__builtin_expect(!!(x), 0)
+#define rseq_barrier()		__asm__ __volatile__("" : : : "memory")
+
+#define RSEQ_ACCESS_ONCE(x)	(*(__volatile__  __typeof__(x) *)&(x))
+#define RSEQ_WRITE_ONCE(x, v)	__extension__ ({ RSEQ_ACCESS_ONCE(x) = (v); })
+#define RSEQ_READ_ONCE(x)	RSEQ_ACCESS_ONCE(x)
+
+#define __rseq_str_1(x)	#x
+#define __rseq_str(x)		__rseq_str_1(x)
+
+#if defined(__x86_64__) || defined(__i386__)
+#include <rseq-x86.h>
+#elif defined(__ARMEL__)
+#include <rseq-arm.h>
+#elif defined(__PPC__)
+#include <rseq-ppc.h>
+#else
+#error unsupported target
+#endif
+
+/*
+ * Register rseq for the current thread. This needs to be called once
+ * by any thread which uses restartable sequences, before they start
+ * using restartable sequences, to ensure restartable sequences
+ * succeed. A restartable sequence executed from a non-registered
+ * thread will always fail.
+ */
+int rseq_register_current_thread(void);
+
+/*
+ * Unregister rseq for current thread.
+ */
+int rseq_unregister_current_thread(void);
+
+/*
+ * Restartable sequence fallback for reading the current CPU number.
+ */
+int32_t rseq_fallback_current_cpu(void);
+
+/*
+ * Values returned can be either the current CPU number, -1 (rseq is
+ * uninitialized), or -2 (rseq initialization has failed).
+ */
+static inline int32_t rseq_current_cpu_raw(void)
+{
+	return RSEQ_ACCESS_ONCE(__rseq_abi.cpu_id);
+}
+
+/*
+ * Returns a possible CPU number, which is typically the current CPU.
+ * The returned CPU number can be used to prepare for an rseq critical
+ * section, which will confirm whether the cpu number is indeed the
+ * current one, and whether rseq is initialized.
+ *
+ * The CPU number returned by rseq_cpu_start should always be validated
+ * by passing it to a rseq asm sequence, or by comparing it to the
+ * return value of rseq_current_cpu_raw() if the rseq asm sequence
+ * does not need to be invoked.
+ */
+static inline uint32_t rseq_cpu_start(void)
+{
+	return RSEQ_ACCESS_ONCE(__rseq_abi.cpu_id_start);
+}
+
+static inline uint32_t rseq_current_cpu(void)
+{
+	int32_t cpu;
+
+	cpu = rseq_current_cpu_raw();
+	if (rseq_unlikely(cpu < 0))
+		cpu = rseq_fallback_current_cpu();
+	return cpu;
+}
+
+/*
+ * rseq_prepare_unload() should be invoked by each thread using rseq_finish*()
+ * at least once between their last rseq_finish*() and library unload of the
+ * library defining the rseq critical section (struct rseq_cs). This also
+ * applies to use of rseq in code generated by JIT: rseq_prepare_unload()
+ * should be invoked at least once by each thread using rseq_finish*() before
+ * reclaim of the memory holding the struct rseq_cs.
+ */
+static inline void rseq_prepare_unload(void)
+{
+	__rseq_abi.rseq_cs = 0;
+}
+
+#endif  /* RSEQ_H_ */
diff --git a/tools/testing/selftests/rseq/run_param_test.sh b/tools/testing/selftests/rseq/run_param_test.sh
new file mode 100755
index 000000000000..41c83d3f62a3
--- /dev/null
+++ b/tools/testing/selftests/rseq/run_param_test.sh
@@ -0,0 +1,126 @@
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
+function do_tests()
+{
+	local i=0
+	while [ "$i" -lt "${#TEST_LIST[@]}" ]; do
+		echo "Running test ${TEST_NAME[$i]}"
+		./param_test ${TEST_LIST[$i]} ${@} ${EXTRA_ARGS} || exit 1
+		echo "Running skip fast-path test ${TEST_NAME[$i]}"
+		./param_test_skip_fastpath ${TEST_LIST[$i]} ${@} ${EXTRA_ARGS} || exit 1
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
+inject_blocking -m 4 -y -r 100
+
+echo "Yield injection (50%)"
+inject_blocking -m 2 -y -r 100
+
+echo "Yield injection (100%)"
+inject_blocking -m 1 -y -r 100
+
+echo "Kill injection (25%)"
+inject_blocking -m 4 -k -r 100
+
+echo "Kill injection (50%)"
+inject_blocking -m 2 -k -r 100
+
+echo "Kill injection (100%)"
+inject_blocking -m 1 -k -r 100
+
+echo "Sleep injection (1ms, 25%)"
+inject_blocking -m 4 -s 1 -r 100
+
+echo "Sleep injection (1ms, 50%)"
+inject_blocking -m 2 -s 1 -r 100
+
+echo "Sleep injection (1ms, 100%)"
+inject_blocking -m 1 -s 1 -r 100
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
