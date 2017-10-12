From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Thu, 12 Oct 2017 19:03:26 -0400
Message-ID: <20171012230326.19984-15-mathieu.desnoyers@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implements two basic tests of RSEQ functionality, and one more
exhaustive parameterizable test.

The first, "basic_test" only asserts that RSEQ works moderately
correctly.
E.g. that:
- The CPUID pointer works
- Code infinitely looping within a critical section will eventually be
  interrupted.
- Critical sections are interrupted by signals.

"basic_percpu_ops_test" is a slightly more "realistic" variant,
implementing a few simple per-cpu operations and testing their
correctness.

"param_test" is a parametrizable restartable sequences test. See
the "--help" output for usage.

As part of those tests, a helper library "rseq" implements a user-space
API around restartable sequences. It uses the cpu_opv system call as
fallback when single-stepped by a debugger. It exposes the instruction
pointer addresses where the rseq assembly blocks begin and end, as well
as the associated abort instruction pointer, in the __rseq_table
section. This section allows debuggers may know where to place
breakpoints when single-stepping through assembly blocks which may be
aborted at any point by the kernel.

The following rseq APIs are implemented in this helper library:
- rseq_register_current_thread()/rseq_unregister_current_thread():
    register/unregister current thread's use of rseq,
- rseq_current_cpu_raw():
    current CPU number,
- rseq_start():
    beginning of a restartable sequence,
- rseq_cpu_at_start():
    CPU number at start of restartable sequence,
- rseq_finish():
    End of restartable sequence made of zero or more loads, completed by
    a word-sized store,
- rseq_finish2():
    End of restartable sequence made of zero or more loads, one
    speculative word-sized store, completed by a word-sized store,
- rseq_finish2_release():
    End of restartable sequence made of zero or more loads, one
    speculative word-sized store, completed by a word-sized store with
    release semantic,
- rseq_finish_memcpy():
    End of restartable sequence made of zero or more loads, a
    speculative copy of a variable length memory region, completed by a
    word-sized store.
- rseq_finish_memcpy_release():
    End of restartable sequence made of zero or more loads, a
    speculative copy of a variable length memory region, completed by a
    word-sized store with release semantic.

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
 MAINTAINERS                                        |    1 +
 tools/testing/selftests/rseq/.gitignore            |    4 +
 tools/testing/selftests/rseq/Makefile              |   13 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  319 +++++
 tools/testing/selftests/rseq/basic_test.c          |   97 ++
 tools/testing/selftests/rseq/param_test.c          | 1246 ++++++++++++++++++++
 tools/testing/selftests/rseq/rseq-arm.h            |  159 +++
 tools/testing/selftests/rseq/rseq-ppc.h            |  266 +++++
 tools/testing/selftests/rseq/rseq-x86.h            |  304 +++++
 tools/testing/selftests/rseq/rseq.c                |   78 ++
 tools/testing/selftests/rseq/rseq.h                |  298 +++++
 11 files changed, 2785 insertions(+)
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

diff --git a/MAINTAINERS b/MAINTAINERS
index 9134a3234737..a79b0b473e7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11242,6 +11242,7 @@ S:	Supported
 F:	kernel/rseq.c
 F:	include/uapi/linux/rseq.h
 F:	include/trace/events/rseq.h
+F:	tools/testing/selftests/rseq/
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
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
index 000000000000..7f0153556b80
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,13 @@
+CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/
+LDFLAGS += -lpthread
+
+TESTS = basic_test basic_percpu_ops_test param_test
+
+all: $(TESTS)
+%: %.c rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TESTS)
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
new file mode 100644
index 000000000000..5771470862bf
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -0,0 +1,319 @@
+#define _GNU_SOURCE
+#include <assert.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
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
+		struct rseq_state rseq_state;
+		intptr_t expect = 0, n = 1;
+		int ret;
+
+		/* Try fast path. */
+		rseq_state = rseq_start();
+		cpu = rseq_cpu_at_start(rseq_state);
+		if (unlikely(lock->c[cpu].v != 0))
+			continue;	/* Retry.*/
+		if (likely(rseq_finish(&lock->c[cpu].v, 1, rseq_state)))
+			break;
+		/* Fallback on cpu_opv system call. */
+		cpu = rseq_current_cpu_raw();
+		ret = cpu_op_cmpstore(&lock->c[cpu].v, &expect, &n,
+			sizeof(intptr_t), cpu);
+		if (likely(!ret))
+			break;
+		assert(ret >= 0 || errno == EAGAIN);
+	}
+	/*
+	 * Acquire semantic when taking lock after control dependency.
+	 * Matches smp_store_release().
+	 */
+	smp_acquire__after_ctrl_dep();
+	return cpu;
+}
+
+void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	assert(lock->c[cpu].v == 1);
+	/*
+	 * Release lock, with release semantic. Matches
+	 * smp_acquire__after_ctrl_dep().
+	 */
+	smp_store_release(&lock->c[cpu].v, 0);
+}
+
+void *test_percpu_spinlock_thread(void *arg)
+{
+	struct spinlock_test_data *data = arg;
+	int i, cpu;
+
+	if (rseq_register_current_thread())
+		abort();
+	for (i = 0; i < data->reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->c[cpu].count++;
+		rseq_percpu_unlock(&data->lock, cpu);
+	}
+	if (rseq_unregister_current_thread())
+		abort();
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
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval, expect;
+	int cpu;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	newval = (intptr_t)node;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	node->next = list->c[cpu].head;
+	if (unlikely(!rseq_finish(targetptr, newval, rseq_state))) {
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load list->c[cpu].head with single-copy atomicity. */
+			expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+			newval = (intptr_t)node;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			node->next = (struct percpu_list_node *)expect;
+			ret = cpu_op_cmpstore(targetptr, &expect, &newval,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
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
+	struct percpu_list_node *head, *next;
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval, expect;
+	int cpu;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load head with single-copy atomicity. */
+	head = READ_ONCE(list->c[cpu].head);
+	if (!head)
+		return NULL;
+	/* Load head->next with single-copy atomicity. */
+	next = READ_ONCE(head->next);
+	newval = (intptr_t)next;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	if (unlikely(!rseq_finish(targetptr, newval, rseq_state))) {
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load head with single-copy atomicity. */
+			head = READ_ONCE(list->c[cpu].head);
+			if (!head)
+				return NULL;
+			expect = (intptr_t)head;
+			/* Load head->next with single-copy atomicity. */
+			next = READ_ONCE(head->next);
+			newval = (intptr_t)next;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			ret = cpu_op_2cmp1store(targetptr, &expect, &newval,
+				&head->next, &next,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (rseq_register_current_thread())
+		abort();
+
+	for (i = 0; i < 100000; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+
+		sched_yield();  /* encourage shuffling */
+		if (node)
+			percpu_list_push(list, node);
+	}
+
+	if (rseq_unregister_current_thread())
+		abort();
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
+	if (rseq_register_current_thread())
+		goto error;
+	printf("spinlock\n");
+	test_percpu_spinlock();
+	printf("percpu_list\n");
+	test_percpu_list();
+	if (rseq_unregister_current_thread())
+		goto error;
+	return 0;
+
+error:
+	return -1;
+}
+
diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 000000000000..236bbe2610af
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,97 @@
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
+volatile int signals_delivered;
+volatile __thread struct rseq_state sigtest_start;
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
+			assert(rseq_current_cpu() == sched_getcpu());
+			assert(rseq_current_cpu() == i);
+			CPU_CLR(i, &test_affinity);
+		}
+	}
+	sched_setaffinity(0, sizeof(affinity), &affinity);
+}
+
+/*
+ * This depends solely on some environmental event triggering a counter
+ * increase.
+ */
+void test_critical_section(void)
+{
+	struct rseq_state start;
+	uint32_t event_counter;
+
+	start = rseq_start();
+	event_counter = start.event_counter;
+	do {
+		start = rseq_start();
+	} while (start.event_counter == event_counter);
+}
+
+void test_signal_interrupt_handler(int signo)
+{
+	struct rseq_state current;
+
+	current = rseq_start();
+	/*
+	 * The potential critical section bordered by 'start' must be
+	 * invalid.
+	 */
+	assert(current.event_counter != sigtest_start.event_counter);
+	signals_delivered++;
+}
+
+void test_signal_interrupts(void)
+{
+	struct itimerval it = { { 0, 1 }, { 0, 1 } };
+	struct itimerval stop_it = { { 0, 0 }, { 0, 0 } };
+
+	setitimer(ITIMER_PROF, &it, NULL);
+	signal(SIGPROF, test_signal_interrupt_handler);
+
+	do {
+		sigtest_start = rseq_start();
+	} while (signals_delivered < 10);
+	setitimer(ITIMER_PROF, &stop_it, NULL);
+}
+
+int main(int argc, char **argv)
+{
+	if (rseq_register_current_thread())
+		goto init_thread_error;
+	printf("testing current cpu\n");
+	test_cpu_pointer();
+	printf("testing critical section\n");
+	test_critical_section();
+	printf("testing critical section is interrupted by signal\n");
+	test_signal_interrupts();
+	if (rseq_unregister_current_thread())
+		goto init_thread_error;
+	return 0;
+
+init_thread_error:
+	return -1;
+}
diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
new file mode 100644
index 000000000000..a68fa0886d50
--- /dev/null
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -0,0 +1,1246 @@
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
+static int opt_modulo;
+
+static int opt_yield, opt_signal, opt_sleep,
+		opt_disable_rseq, opt_threads = 200,
+		opt_reps = 5000, opt_disable_mod = 0, opt_test = 's';
+
+static __thread unsigned int signals_delivered;
+
+#ifndef BENCHMARK
+
+static __thread unsigned int yield_mod_cnt, nr_retry;
+
+#define printf_nobench(fmt, ...)	printf(fmt, ## __VA_ARGS__)
+
+#define RSEQ_INJECT_INPUT \
+	, [loop_cnt_1]"m"(loop_cnt[1]) \
+	, [loop_cnt_2]"m"(loop_cnt[2]) \
+	, [loop_cnt_3]"m"(loop_cnt[3]) \
+	, [loop_cnt_4]"m"(loop_cnt[4]) \
+	, [loop_cnt_5]"m"(loop_cnt[5])
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
+	nr_retry++;
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
+#define printf_nobench(fmt, ...)
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
+	int reps;
+	int reg;
+};
+
+struct inc_test_data {
+	struct test_data_entry c[CPU_SETSIZE];
+};
+
+struct inc_thread_test_data {
+	struct inc_test_data *data;
+	int reps;
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
+#ifndef SKIP_FASTPATH
+		struct rseq_state rseq_state;
+
+		/* Try fast path. */
+		rseq_state = rseq_start();
+		cpu = rseq_cpu_at_start(rseq_state);
+		if (unlikely(lock->c[cpu].v != 0))
+			continue;	/* Retry.*/
+		if (likely(rseq_finish(&lock->c[cpu].v, 1, rseq_state)))
+			break;
+		else
+#endif
+		{
+			/* Fallback on cpu_opv system call. */
+			intptr_t expect = 0, n = 1;
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			ret = cpu_op_cmpstore(&lock->c[cpu].v, &expect, &n,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+	/*
+	 * Acquire semantic when taking lock after control dependency.
+	 * Matches smp_store_release().
+	 */
+	smp_acquire__after_ctrl_dep();
+	return cpu;
+}
+
+static void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	assert(lock->c[cpu].v == 1);
+	/*
+	 * Release lock, with release semantic. Matches
+	 * smp_acquire__after_ctrl_dep().
+	 */
+	smp_store_release(&lock->c[cpu].v, 0);
+}
+
+void *test_percpu_spinlock_thread(void *arg)
+{
+	struct spinlock_thread_test_data *thread_data = arg;
+	struct spinlock_test_data *data = thread_data->data;
+	int i, cpu;
+
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_register_current_thread())
+		abort();
+	for (i = 0; i < thread_data->reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->c[cpu].count++;
+		rseq_percpu_unlock(&data->lock, cpu);
+#ifndef BENCHMARK
+		if (i != 0 && !(i % (thread_data->reps / 10)))
+			printf("tid %d: count %d\n", (int) gettid(), i);
+#endif
+	}
+	printf_nobench("tid %d: number of retry: %d, signals delivered: %u\n",
+		(int) gettid(), nr_retry, signals_delivered);
+	if (rseq_unregister_current_thread())
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
+	int i;
+
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_register_current_thread())
+		abort();
+	for (i = 0; i < thread_data->reps; i++) {
+		int cpu;
+
+#ifndef SKIP_FASTPATH
+		struct rseq_state rseq_state;
+		intptr_t *targetptr, newval;
+
+		/* Try fast path. */
+		rseq_state = rseq_start();
+		cpu = rseq_cpu_at_start(rseq_state);
+		newval = (intptr_t)data->c[cpu].count + 1;
+		targetptr = (intptr_t *)&data->c[cpu].count;
+		if (unlikely(!rseq_finish(targetptr, newval, rseq_state)))
+#endif
+		{
+			for (;;) {
+				/* Fallback on cpu_opv system call. */
+				int ret;
+
+				cpu = rseq_current_cpu_raw();
+				ret = cpu_op_add(&data->c[cpu].count, 1,
+					sizeof(intptr_t), cpu);
+				if (likely(!ret))
+					break;
+				assert(ret >= 0 || errno == EAGAIN);
+			}
+		}
+
+#ifndef BENCHMARK
+		if (i != 0 && !(i % (thread_data->reps / 10)))
+			printf("tid %d: count %d\n", (int) gettid(), i);
+#endif
+	}
+	printf_nobench("tid %d: number of retry: %d, signals delivered: %u\n",
+		(int) gettid(), nr_retry, signals_delivered);
+	if (rseq_unregister_current_thread())
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
+	int cpu;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	newval = (intptr_t)node;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	node->next = list->c[cpu].head;
+	if (unlikely(!rseq_finish(targetptr, newval, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load list->c[cpu].head with single-copy atomicity. */
+			expect = (intptr_t)READ_ONCE(list->c[cpu].head);
+			newval = (intptr_t)node;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			node->next = (struct percpu_list_node *)expect;
+			ret = cpu_op_cmpstore(targetptr, &expect, &newval,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
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
+	struct percpu_list_node *head, *next;
+	intptr_t *targetptr, newval, expect;
+	int cpu;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load list->c[cpu].head with single-copy atomicity. */
+	head = READ_ONCE(list->c[cpu].head);
+	if (!head)
+		return NULL;
+	/* Load head->next with single-copy atomicity. */
+	next = READ_ONCE(head->next);
+	newval = (intptr_t)next;
+	targetptr = (intptr_t *)&list->c[cpu].head;
+	if (unlikely(!rseq_finish(targetptr, newval, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load list->c[cpu].head with single-copy atomicity. */
+			head = READ_ONCE(list->c[cpu].head);
+			if (!head)
+				return NULL;
+			expect = (intptr_t)head;
+			/* Load head->next with single-copy atomicity. */
+			next = READ_ONCE(head->next);
+			newval = (intptr_t)next;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			ret = cpu_op_2cmp1store(targetptr, &expect, &newval,
+				&head->next, &next,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (rseq_register_current_thread())
+		abort();
+
+	for (i = 0; i < opt_reps; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+
+		if (opt_yield)
+			sched_yield();  /* encourage shuffling */
+		if (node)
+			percpu_list_push(list, node);
+	}
+
+	if (rseq_unregister_current_thread())
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
+	int cpu;
+	intptr_t offset;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == buffer->c[cpu].buflen)
+		return false;
+	newval_spec = (intptr_t)node;
+	targetptr_spec = (intptr_t *)&buffer->c[cpu].array[offset];
+	newval_final = offset + 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	if (unlikely(!rseq_finish2(targetptr_spec, newval_spec,
+			targetptr_final, newval_final, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load offset with single-copy atomicity. */
+			offset = READ_ONCE(buffer->c[cpu].offset);
+			if (offset == buffer->c[cpu].buflen)
+				return false;
+			newval_spec = (intptr_t)node;
+			targetptr_spec = (intptr_t *)&buffer->c[cpu].array[offset];
+			newval_final = offset + 1;
+			targetptr_final = &buffer->c[cpu].offset;
+			ret = cpu_op_1cmp2store(targetptr_final, &offset, &newval_final,
+				targetptr_spec, &newval_spec,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+	return true;
+}
+
+struct percpu_buffer_node *percpu_buffer_pop(struct percpu_buffer *buffer)
+{
+	struct percpu_buffer_node *head;
+	intptr_t *targetptr, newval;
+	int cpu;
+	intptr_t offset;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == 0)
+		return NULL;
+	head = buffer->c[cpu].array[offset - 1];
+	newval = offset - 1;
+	targetptr = (intptr_t *)&buffer->c[cpu].offset;
+	if (unlikely(!rseq_finish(targetptr, newval, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load offset with single-copy atomicity. */
+			offset = READ_ONCE(buffer->c[cpu].offset);
+			if (offset == 0)
+				return NULL;
+			head = buffer->c[cpu].array[offset - 1];
+			newval = offset - 1;
+			targetptr = (intptr_t *)&buffer->c[cpu].offset;
+			ret = cpu_op_2cmp1store(targetptr, &offset, &newval,
+				&buffer->c[cpu].array[offset - 1], &head,
+				sizeof(intptr_t), cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+	return head;
+}
+
+void *test_percpu_buffer_thread(void *arg)
+{
+	int i;
+	struct percpu_buffer *buffer = (struct percpu_buffer *)arg;
+
+	if (rseq_register_current_thread())
+		abort();
+
+	for (i = 0; i < opt_reps; i++) {
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
+	if (rseq_unregister_current_thread())
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
+	int cpu;
+	intptr_t offset;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == buffer->c[cpu].buflen)
+		return false;
+	destptr = (char *)&buffer->c[cpu].array[offset];
+	srcptr = (char *)&item;
+	copylen = sizeof(item);
+	newval_final = offset + 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	if (unlikely(!rseq_finish_memcpy(destptr, srcptr, copylen,
+			targetptr_final, newval_final, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load offset with single-copy atomicity. */
+			offset = READ_ONCE(buffer->c[cpu].offset);
+			if (offset == buffer->c[cpu].buflen)
+				return false;
+			destptr = (char *)&buffer->c[cpu].array[offset];
+			srcptr = (char *)&item;
+			copylen = sizeof(item);
+			newval_final = offset + 1;
+			targetptr_final = &buffer->c[cpu].offset;
+			/* copylen must be <= PAGE_SIZE. */
+			ret = cpu_op_cmpstorememcpy(targetptr_final, &offset, &newval_final,
+				sizeof(intptr_t), destptr, srcptr, copylen, cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
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
+	int cpu;
+	intptr_t offset;
+#ifndef SKIP_FASTPATH
+	struct rseq_state rseq_state;
+
+	/* Try fast path. */
+	rseq_state = rseq_start();
+	cpu = rseq_cpu_at_start(rseq_state);
+	/* Load offset with single-copy atomicity. */
+	offset = READ_ONCE(buffer->c[cpu].offset);
+	if (offset == 0)
+		return false;
+	destptr = (char *)item;
+	srcptr = (char *)&buffer->c[cpu].array[offset - 1];
+	copylen = sizeof(*item);
+	newval_final = offset - 1;
+	targetptr_final = &buffer->c[cpu].offset;
+	if (unlikely(!rseq_finish_memcpy(destptr, srcptr, copylen,
+			targetptr_final, newval_final, rseq_state)))
+#endif
+	{
+		/* Fallback on cpu_opv system call. */
+		for (;;) {
+			int ret;
+
+			cpu = rseq_current_cpu_raw();
+			/* Load offset with single-copy atomicity. */
+			offset = READ_ONCE(buffer->c[cpu].offset);
+			if (offset == 0)
+				return false;
+			destptr = (char *)item;
+			srcptr = (char *)&buffer->c[cpu].array[offset - 1];
+			copylen = sizeof(*item);
+			newval_final = offset - 1;
+			targetptr_final = &buffer->c[cpu].offset;
+			/* copylen must be <= PAGE_SIZE. */
+			ret = cpu_op_cmpstorememcpy(targetptr_final, &offset, &newval_final,
+				sizeof(intptr_t), destptr, srcptr, copylen, cpu);
+			if (likely(!ret))
+				break;
+			assert(ret >= 0 || errno == EAGAIN);
+		}
+	}
+	return true;
+}
+
+void *test_percpu_memcpy_buffer_thread(void *arg)
+{
+	int i;
+	struct percpu_memcpy_buffer *buffer = (struct percpu_memcpy_buffer *)arg;
+
+	if (rseq_register_current_thread())
+		abort();
+
+	for (i = 0; i < opt_reps; i++) {
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
+	if (rseq_unregister_current_thread())
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
+	printf_nobench("Signal handler set for SIGUSR1\n");
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
+	printf("	[-6 loops] Number of loops for delay injection 6 (-1 to enable -m)\n");
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
+	printf("	[-h] Show this help.\n");
+	printf("\n");
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	if (set_signal_handler())
+		goto error;
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
+			opt_reps = atol(argv[i + 1]);
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
+		default:
+			show_usage(argc, argv);
+			goto error;
+		}
+	}
+
+	if (!opt_disable_rseq && rseq_register_current_thread())
+		goto error;
+	switch (opt_test) {
+	case 's':
+		printf_nobench("spinlock\n");
+		test_percpu_spinlock();
+		break;
+	case 'l':
+		printf_nobench("linked list\n");
+		test_percpu_list();
+		break;
+	case 'b':
+		printf_nobench("buffer\n");
+		test_percpu_buffer();
+		break;
+	case 'm':
+		printf_nobench("memcpy buffer\n");
+		test_percpu_memcpy_buffer();
+		break;
+	case 'i':
+		printf_nobench("counter increment\n");
+		test_percpu_inc();
+		break;
+	}
+	if (rseq_unregister_current_thread())
+		abort();
+end:
+	return 0;
+
+error:
+	return -1;
+}
diff --git a/tools/testing/selftests/rseq/rseq-arm.h b/tools/testing/selftests/rseq/rseq-arm.h
new file mode 100644
index 000000000000..b5f57d250071
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-arm.h
@@ -0,0 +1,159 @@
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
+#define smp_mb()	__asm__ __volatile__ ("dmb" : : : "memory")
+#define smp_rmb()	__asm__ __volatile__ ("dmb" : : : "memory")
+#define smp_wmb()	__asm__ __volatile__ ("dmb" : : : "memory")
+
+#define smp_load_acquire(p)						\
+__extension__ ({							\
+	__typeof(*p) ____p1 = READ_ONCE(*p);				\
+	smp_mb();							\
+	____p1;								\
+})
+
+#define smp_acquire__after_ctrl_dep()	smp_rmb()
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define has_fast_acquire_release()	0
+#define has_single_copy_load_64()	1
+
+/*
+ * The __rseq_table section can be used by debuggers to better handle
+ * single-stepping through the restartable critical sections.
+ */
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, _spec_store, _spec_input, \
+		_final_store, _final_input, _extra_clobber, \
+		_setup, _teardown, _scratch) \
+do { \
+	_scratch \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		".word 1f, 0x0, 2f, 0x0, 5f, 0x0, 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		_setup \
+		RSEQ_INJECT_ASM(1) \
+		"adr r0, 3f\n\t" \
+		"str r0, [%[rseq_cs]]\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"ldr r0, %[current_event_counter]\n\t" \
+		"cmp %[start_event_counter], r0\n\t" \
+		"bne 5f\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		_spec_store \
+		_final_store \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		_teardown \
+		"b 4f\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".word 1b, 0x0, 2b, 0x0, 5f, 0x0, 0x0, 0x0\n\t" \
+		"5:\n\t" \
+		_teardown \
+		"b %l[failure]\n\t" \
+		"4:\n\t" \
+		: /* gcc asm goto does not allow outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
+		  _spec_input \
+		  _final_input \
+		  RSEQ_INJECT_INPUT \
+		: "r0", "memory", "cc" \
+		  _extra_clobber \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	); \
+} while (0)
+
+#define RSEQ_FINISH_FINAL_STORE_ASM() \
+		"str %[to_write_final], [%[target_final]]\n\t"
+
+#define RSEQ_FINISH_FINAL_STORE_RELEASE_ASM() \
+		"dmb\n\t" \
+		RSEQ_FINISH_FINAL_STORE_ASM()
+
+#define RSEQ_FINISH_FINAL_STORE_INPUT(_target_final, _to_write_final) \
+		, [to_write_final]"r"(_to_write_final), \
+		[target_final]"r"(_target_final)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_ASM() \
+		"str %[to_write_spec], [%[target_spec]]\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_INPUT(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"r"(_target_spec)
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_FINISH_MEMCPY_STORE_ASM() \
+		"cmp %[len_memcpy], #0\n\t" \
+		"beq 333f\n\t" \
+		"222:\n\t" \
+		"ldrb %%r0, [%[to_write_memcpy]]\n\t" \
+		"strb %%r0, [%[target_memcpy]]\n\t" \
+		"adds %[to_write_memcpy], #1\n\t" \
+		"adds %[target_memcpy], #1\n\t" \
+		"subs %[len_memcpy], #1\n\t" \
+		"bne 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_MEMCPY_STORE_INPUT(_target_memcpy, _to_write_memcpy, _len_memcpy) \
+		, [to_write_memcpy]"r"(_to_write_memcpy), \
+		[target_memcpy]"r"(_target_memcpy), \
+		[len_memcpy]"r"(_len_memcpy), \
+		[rseq_scratch0]"m"(rseq_scratch[0]), \
+		[rseq_scratch1]"m"(rseq_scratch[1]), \
+		[rseq_scratch2]"m"(rseq_scratch[2])
+
+/* We can use r0. */
+#define RSEQ_FINISH_MEMCPY_CLOBBER()
+
+#define RSEQ_FINISH_MEMCPY_SCRATCH() \
+		uint32_t rseq_scratch[3];
+
+/*
+ * We need to save and restore those input registers so they can be
+ * modified within the assembly.
+ */
+#define RSEQ_FINISH_MEMCPY_SETUP() \
+		"str %[to_write_memcpy], %[rseq_scratch0]\n\t" \
+		"str %[target_memcpy], %[rseq_scratch1]\n\t" \
+		"str %[len_memcpy], %[rseq_scratch2]\n\t"
+
+#define RSEQ_FINISH_MEMCPY_TEARDOWN() \
+		"ldr %[len_memcpy], %[rseq_scratch2]\n\t" \
+		"ldr %[target_memcpy], %[rseq_scratch1]\n\t" \
+		"ldr %[to_write_memcpy], %[rseq_scratch0]\n\t"
diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selftests/rseq/rseq-ppc.h
new file mode 100644
index 000000000000..94c8ba0b4311
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -0,0 +1,266 @@
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
+#define smp_mb()	__asm__ __volatile__ ("sync" : : : "memory")
+#define smp_lwsync()	__asm__ __volatile__ ("lwsync" : : : "memory")
+#define smp_rmb()	smp_lwsync()
+#define smp_wmb()	smp_lwsync()
+
+#define smp_load_acquire(p)						\
+__extension__ ({							\
+	__typeof(*p) ____p1 = READ_ONCE(*p);				\
+	smp_lwsync();							\
+	____p1;								\
+})
+
+#define smp_acquire__after_ctrl_dep()	smp_lwsync()
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_lwsync();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define has_fast_acquire_release()	0
+
+#ifdef __PPC64__
+#define has_single_copy_load_64()	1
+#else
+#define has_single_copy_load_64()	0
+#endif
+
+/*
+ * The __rseq_table section can be used by debuggers to better handle
+ * single-stepping through the restartable critical sections.
+ */
+
+#ifdef __PPC64__
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, _spec_store, _spec_input, \
+		_final_store, _final_input, _extra_clobber, \
+		_setup, _teardown, _scratch) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".quad 1f, 2f, 4f\n\t" \
+		".long 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		_setup \
+		RSEQ_INJECT_ASM(1) \
+		"lis %%r17, (3b)@highest\n\t" \
+		"ori %%r17, %%r17, (3b)@higher\n\t" \
+		"rldicr %%r17, %%r17, 32, 31\n\t" \
+		"oris %%r17, %%r17, (3b)@h\n\t" \
+		"ori %%r17, %%r17, (3b)@l\n\t" \
+		"std %%r17, 0(%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"lwz %%r17, %[current_event_counter]\n\t" \
+		"cmpw cr7, %[start_event_counter], %%r17\n\t" \
+		"bne- cr7, 4f\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		_spec_store \
+		_final_store \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		_teardown \
+		"b 5f\n\t" \
+		"4:\n\t" \
+		_teardown \
+		"b %l[failure]\n\t" \
+		"5:\n\t" \
+		: /* gcc asm goto does not allow outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [rseq_cs]"b"(&(_start_value).rseqp->rseq_cs) \
+		  _spec_input \
+		  _final_input \
+		  RSEQ_INJECT_INPUT \
+		: "r17", "memory", "cc" \
+		  _extra_clobber \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	)
+
+#define RSEQ_FINISH_FINAL_STORE_ASM() \
+		"std %[to_write_final], 0(%[target_final])\n\t"
+
+#define RSEQ_FINISH_FINAL_STORE_RELEASE_ASM() \
+		"lwsync\n\t" \
+		RSEQ_FINISH_FINAL_STORE_ASM()
+
+#define RSEQ_FINISH_FINAL_STORE_INPUT(_target_final, _to_write_final) \
+		, [to_write_final]"r"(_to_write_final), \
+		[target_final]"b"(_target_final)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_ASM() \
+		"std %[to_write_spec], 0(%[target_spec])\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_INPUT(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"b"(_target_spec)
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_FINISH_MEMCPY_STORE_ASM() \
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
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_MEMCPY_STORE_INPUT(_target_memcpy, _to_write_memcpy, _len_memcpy) \
+		, [to_write_memcpy]"r"(_to_write_memcpy), \
+		[target_memcpy]"r"(_target_memcpy), \
+		[len_memcpy]"r"(_len_memcpy)
+
+#define RSEQ_FINISH_MEMCPY_CLOBBER() \
+		, "r18", "r19", "r20", "r21"
+
+#define RSEQ_FINISH_MEMCPY_SCRATCH()
+
+/*
+ * We use extra registers to hold the input registers, and we don't need to
+ * save and restore the input registers.
+ */
+#define RSEQ_FINISH_MEMCPY_SETUP() \
+		"mr %%r19, %[len_memcpy]\n\t" \
+		"mr %%r20, %[to_write_memcpy]\n\t" \
+		"mr %%r21, %[target_memcpy]\n\t" \
+
+#define RSEQ_FINISH_MEMCPY_TEARDOWN()
+
+#else	/* #ifdef __PPC64__ */
+
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, _spec_store, _spec_input, \
+		_final_store, _final_input, _extra_clobber, \
+		_setup, _teardown, _scratch) \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		/* 32-bit only supported on BE */ \
+		".long 0x0, 1f, 0x0, 2f, 0x0, 4f, 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		_setup \
+		RSEQ_INJECT_ASM(1) \
+		"lis %%r17, (3b)@ha\n\t" \
+		"addi %%r17, %%r17, (3b)@l\n\t" \
+		"stw %%r17, 0(%[rseq_cs])\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"lwz %%r17, %[current_event_counter]\n\t" \
+		"cmpw cr7, %[start_event_counter], %%r17\n\t" \
+		"bne- cr7, 4f\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		_spec_store \
+		_final_store \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		_teardown \
+		"b 5f\n\t" \
+		"4:\n\t" \
+		_teardown \
+		"b %l[failure]\n\t" \
+		"5:\n\t" \
+		: /* gcc asm goto does not allow outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [rseq_cs]"b"(&(_start_value).rseqp->rseq_cs) \
+		  _spec_input \
+		  _final_input \
+		  RSEQ_INJECT_INPUT \
+		: "r17", "memory", "cc" \
+		  _extra_clobber \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	)
+
+#define RSEQ_FINISH_FINAL_STORE_ASM() \
+		"stw %[to_write_final], 0(%[target_final])\n\t"
+
+#define RSEQ_FINISH_FINAL_STORE_RELEASE_ASM() \
+		"lwsync\n\t" \
+		RSEQ_FINISH_FINAL_STORE_ASM()
+
+#define RSEQ_FINISH_FINAL_STORE_INPUT(_target_final, _to_write_final) \
+		, [to_write_final]"r"(_to_write_final), \
+		[target_final]"b"(_target_final)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_ASM() \
+		"stw %[to_write_spec], 0(%[target_spec])\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_INPUT(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"b"(_target_spec)
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_FINISH_MEMCPY_STORE_ASM() \
+		"cmpwi %%r19, 0\n\t" \
+		"beq 333f\n\t" \
+		"addi %%r20, %%r20, -1\n\t" \
+		"addi %%r21, %%r21, -1\n\t" \
+		"222:\n\t" \
+		"lbzu %%r18, 1(%%r20)\n\t" \
+		"stbu %%r18, 1(%%r21)\n\t" \
+		"addi %%r19, %%r19, -1\n\t" \
+		"cmpwi %%r19, 0\n\t" \
+		"bne 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_MEMCPY_STORE_INPUT(_target_memcpy, _to_write_memcpy, _len_memcpy) \
+		, [to_write_memcpy]"r"(_to_write_memcpy), \
+		[target_memcpy]"r"(_target_memcpy), \
+		[len_memcpy]"r"(_len_memcpy)
+
+#define RSEQ_FINISH_MEMCPY_CLOBBER() \
+		, "r18", "r19", "r20", "r21"
+
+#define RSEQ_FINISH_MEMCPY_SCRATCH()
+
+/*
+ * We use extra registers to hold the input registers, and we don't need to
+ * save and restore the input registers.
+ */
+#define RSEQ_FINISH_MEMCPY_SETUP() \
+		"mr %%r19, %[len_memcpy]\n\t" \
+		"mr %%r20, %[to_write_memcpy]\n\t" \
+		"mr %%r21, %[target_memcpy]\n\t" \
+
+#define RSEQ_FINISH_MEMCPY_TEARDOWN()
+
+#endif	/* #else #ifdef __PPC64__ */
diff --git a/tools/testing/selftests/rseq/rseq-x86.h b/tools/testing/selftests/rseq/rseq-x86.h
new file mode 100644
index 000000000000..2896186eef9b
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq-x86.h
@@ -0,0 +1,304 @@
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
+#ifdef __x86_64__
+
+#define smp_mb()	__asm__ __volatile__ ("mfence" : : : "memory")
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+
+#define smp_load_acquire(p)						\
+__extension__ ({							\
+	__typeof(*p) ____p1 = READ_ONCE(*p);				\
+	barrier();							\
+	____p1;								\
+})
+
+#define smp_acquire__after_ctrl_dep()	smp_rmb()
+
+#define smp_store_release(p, v)						\
+do {									\
+	barrier();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define has_fast_acquire_release()	1
+#define has_single_copy_load_64()	1
+
+/*
+ * The __rseq_table section can be used by debuggers to better handle
+ * single-stepping through the restartable critical sections.
+ */
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, _spec_store, _spec_input, \
+		_final_store, _final_input, _extra_clobber, \
+		_setup, _teardown, _scratch) \
+do { \
+	_scratch \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".quad 1f, 2f, 4f\n\t" \
+		".long 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		_setup \
+		RSEQ_INJECT_ASM(1) \
+		"leaq 3b(%%rip), %%rax\n\t" \
+		"movq %%rax, %[rseq_cs]\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"cmpl %[start_event_counter], %[current_event_counter]\n\t" \
+		"jnz 4f\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		_spec_store \
+		_final_store \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		_teardown \
+		".pushsection __rseq_failure, \"a\"\n\t" \
+		"4:\n\t" \
+		_teardown \
+		"jmp %l[failure]\n\t" \
+		".popsection\n\t" \
+		: /* gcc asm goto does not allow outputs */ \
+		: [start_event_counter]"r"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [rseq_cs]"m"((_start_value).rseqp->rseq_cs) \
+		  _spec_input \
+		  _final_input \
+		  RSEQ_INJECT_INPUT \
+		: "memory", "cc", "rax" \
+		  _extra_clobber \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	); \
+} while (0)
+
+#define RSEQ_FINISH_FINAL_STORE_ASM() \
+		"movq %[to_write_final], %[target_final]\n\t"
+
+/* x86-64 is TSO */
+#define RSEQ_FINISH_FINAL_STORE_RELEASE_ASM() \
+		RSEQ_FINISH_FINAL_STORE_ASM()
+
+#define RSEQ_FINISH_FINAL_STORE_INPUT(_target_final, _to_write_final) \
+		, [to_write_final]"r"(_to_write_final), \
+		[target_final]"m"(*(_target_final))
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_ASM() \
+		"movq %[to_write_spec], %[target_spec]\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_INPUT(_target_spec, _to_write_spec) \
+		, [to_write_spec]"r"(_to_write_spec), \
+		[target_spec]"m"(*(_target_spec))
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_FINISH_MEMCPY_STORE_ASM() \
+		"test %[len_memcpy], %[len_memcpy]\n\t" \
+		"jz 333f\n\t" \
+		"222:\n\t" \
+		"movb (%[to_write_memcpy]), %%al\n\t" \
+		"movb %%al, (%[target_memcpy])\n\t" \
+		"inc %[to_write_memcpy]\n\t" \
+		"inc %[target_memcpy]\n\t" \
+		"dec %[len_memcpy]\n\t" \
+		"jnz 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_MEMCPY_STORE_INPUT(_target_memcpy, _to_write_memcpy, _len_memcpy) \
+		, [to_write_memcpy]"r"(_to_write_memcpy), \
+		[target_memcpy]"r"(_target_memcpy), \
+		[len_memcpy]"r"(_len_memcpy), \
+		[rseq_scratch0]"m"(rseq_scratch[0]), \
+		[rseq_scratch1]"m"(rseq_scratch[1]), \
+		[rseq_scratch2]"m"(rseq_scratch[2])
+
+#define RSEQ_FINISH_MEMCPY_CLOBBER()	\
+		, "rax"
+
+#define RSEQ_FINISH_MEMCPY_SCRATCH() \
+		uint64_t rseq_scratch[3];
+
+/*
+ * We need to save and restore those input registers so they can be
+ * modified within the assembly.
+ */
+#define RSEQ_FINISH_MEMCPY_SETUP() \
+		"movq %[to_write_memcpy], %[rseq_scratch0]\n\t" \
+		"movq %[target_memcpy], %[rseq_scratch1]\n\t" \
+		"movq %[len_memcpy], %[rseq_scratch2]\n\t"
+
+#define RSEQ_FINISH_MEMCPY_TEARDOWN() \
+		"movq %[rseq_scratch2], %[len_memcpy]\n\t" \
+		"movq %[rseq_scratch1], %[target_memcpy]\n\t" \
+		"movq %[rseq_scratch0], %[to_write_memcpy]\n\t"
+
+#elif __i386__
+
+/*
+ * Support older 32-bit architectures that do not implement fence
+ * instructions.
+ */
+#define smp_mb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+#define smp_rmb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+#define smp_wmb()	\
+	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
+
+#define smp_load_acquire(p)						\
+__extension__ ({							\
+	__typeof(*p) ____p1 = READ_ONCE(*p);				\
+	smp_mb();							\
+	____p1;								\
+})
+
+#define smp_acquire__after_ctrl_dep()	smp_rmb()
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+#define has_fast_acquire_release()	0
+#define has_single_copy_load_64()	0
+
+/*
+ * Use eax as scratch register and take memory operands as input to
+ * lessen register pressure. Especially needed when compiling
+ * do_rseq_memcpy() in O0.
+ */
+#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
+		_failure, _spec_store, _spec_input, \
+		_final_store, _final_input, _extra_clobber, \
+		_setup, _teardown, _scratch) \
+do { \
+	_scratch \
+	__asm__ __volatile__ goto ( \
+		".pushsection __rseq_table, \"aw\"\n\t" \
+		".balign 32\n\t" \
+		"3:\n\t" \
+		".long 1f, 0x0, 2f, 0x0, 4f, 0x0, 0x0, 0x0\n\t" \
+		".popsection\n\t" \
+		"1:\n\t" \
+		_setup \
+		RSEQ_INJECT_ASM(1) \
+		"movl $3b, %[rseq_cs]\n\t" \
+		RSEQ_INJECT_ASM(2) \
+		"movl %[start_event_counter], %%eax\n\t" \
+		"cmpl %%eax, %[current_event_counter]\n\t" \
+		"jnz 4f\n\t" \
+		RSEQ_INJECT_ASM(3) \
+		_spec_store \
+		_final_store \
+		"2:\n\t" \
+		RSEQ_INJECT_ASM(5) \
+		_teardown \
+		".pushsection __rseq_failure, \"a\"\n\t" \
+		"4:\n\t" \
+		_teardown \
+		"jmp %l[failure]\n\t" \
+		".popsection\n\t" \
+		: /* gcc asm goto does not allow outputs */ \
+		: [start_event_counter]"m"((_start_value).event_counter), \
+		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
+		  [rseq_cs]"m"((_start_value).rseqp->rseq_cs) \
+		  _spec_input \
+		  _final_input \
+		  RSEQ_INJECT_INPUT \
+		: "memory", "cc", "eax" \
+		  _extra_clobber \
+		  RSEQ_INJECT_CLOBBER \
+		: _failure \
+	); \
+} while (0)
+
+#define RSEQ_FINISH_FINAL_STORE_ASM() \
+		"movl %[to_write_final], %%eax\n\t" \
+		"movl %%eax, %[target_final]\n\t"
+
+#define RSEQ_FINISH_FINAL_STORE_RELEASE_ASM() \
+		"lock; addl $0,0(%%esp)\n\t" \
+		RSEQ_FINISH_FINAL_STORE_ASM()
+
+#define RSEQ_FINISH_FINAL_STORE_INPUT(_target_final, _to_write_final) \
+		, [to_write_final]"m"(_to_write_final), \
+		[target_final]"m"(*(_target_final))
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_ASM() \
+		"movl %[to_write_spec], %%eax\n\t" \
+		"movl %%eax, %[target_spec]\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_SPECULATIVE_STORE_INPUT(_target_spec, _to_write_spec) \
+		, [to_write_spec]"m"(_to_write_spec), \
+		[target_spec]"m"(*(_target_spec))
+
+/* TODO: implement a faster memcpy. */
+#define RSEQ_FINISH_MEMCPY_STORE_ASM() \
+		"movl %[len_memcpy], %%eax\n\t" \
+		"test %%eax, %%eax\n\t" \
+		"jz 333f\n\t" \
+		"222:\n\t" \
+		"movb (%[to_write_memcpy]), %%al\n\t" \
+		"movb %%al, (%[target_memcpy])\n\t" \
+		"inc %[to_write_memcpy]\n\t" \
+		"inc %[target_memcpy]\n\t" \
+		"decl %[rseq_scratch2]\n\t" \
+		"jnz 222b\n\t" \
+		"333:\n\t" \
+		RSEQ_INJECT_ASM(4)
+
+#define RSEQ_FINISH_MEMCPY_STORE_INPUT(_target_memcpy, _to_write_memcpy, _len_memcpy) \
+		, [to_write_memcpy]"r"(_to_write_memcpy), \
+		[target_memcpy]"r"(_target_memcpy), \
+		[len_memcpy]"m"(_len_memcpy), \
+		[rseq_scratch0]"m"(rseq_scratch[0]), \
+		[rseq_scratch1]"m"(rseq_scratch[1]), \
+		[rseq_scratch2]"m"(rseq_scratch[2])
+
+#define RSEQ_FINISH_MEMCPY_CLOBBER()
+
+#define RSEQ_FINISH_MEMCPY_SCRATCH() \
+		uint32_t rseq_scratch[3];
+
+/*
+ * We need to save and restore those input registers so they can be
+ * modified within the assembly.
+ */
+#define RSEQ_FINISH_MEMCPY_SETUP() \
+		"movl %[to_write_memcpy], %[rseq_scratch0]\n\t" \
+		"movl %[target_memcpy], %[rseq_scratch1]\n\t" \
+		"movl %[len_memcpy], %%eax\n\t" \
+		"movl %%eax, %[rseq_scratch2]\n\t"
+
+#define RSEQ_FINISH_MEMCPY_TEARDOWN() \
+		"movl %[rseq_scratch1], %[target_memcpy]\n\t" \
+		"movl %[rseq_scratch0], %[to_write_memcpy]\n\t"
+
+#endif
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
new file mode 100644
index 000000000000..79eba7f20064
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -0,0 +1,78 @@
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
+__attribute__((weak)) __thread volatile struct rseq __rseq_abi = {
+	.u.e.cpu_id = -1,
+};
+
+static int sys_rseq(volatile struct rseq *rseq_abi, int flags)
+{
+	return syscall(__NR_rseq, rseq_abi, flags);
+}
+
+int rseq_register_current_thread(void)
+{
+	int rc;
+
+	rc = sys_rseq(&__rseq_abi, 0);
+	if (rc) {
+		fprintf(stderr, "Error: sys_rseq(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		return -1;
+	}
+	assert(rseq_current_cpu() >= 0);
+	return 0;
+}
+
+int rseq_unregister_current_thread(void)
+{
+	int rc;
+
+	rc = sys_rseq(NULL, 0);
+	if (rc) {
+		fprintf(stderr, "Error: sys_rseq(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+int rseq_fallback_current_cpu(void)
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
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
new file mode 100644
index 000000000000..b0015f255ffc
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -0,0 +1,298 @@
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
+#define likely(x)		__builtin_expect(!!(x), 1)
+#define unlikely(x)		__builtin_expect(!!(x), 0)
+#define barrier()		__asm__ __volatile__("" : : : "memory")
+
+#define ACCESS_ONCE(x)		(*(__volatile__  __typeof__(x) *)&(x))
+#define WRITE_ONCE(x, v)	__extension__ ({ ACCESS_ONCE(x) = (v); })
+#define READ_ONCE(x)		ACCESS_ONCE(x)
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
+/* State returned by rseq_start, passed as argument to rseq_finish. */
+struct rseq_state {
+	volatile struct rseq *rseqp;
+	int32_t cpu_id;		/* cpu_id at start. */
+	uint32_t event_counter;	/* event_counter at start. */
+};
+
+/*
+ * Register rseq for the current thread. This needs to be called once
+ * by any thread which uses restartable sequences, before they start
+ * using restartable sequences. If initialization is not invoked, or if
+ * it fails, the restartable critical sections will fall-back on locking
+ * (rseq_lock).
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
+int rseq_fallback_current_cpu(void);
+
+static inline int32_t rseq_cpu_at_start(struct rseq_state start_value)
+{
+	return start_value.cpu_id;
+}
+
+static inline int32_t rseq_current_cpu_raw(void)
+{
+	return ACCESS_ONCE(__rseq_abi.u.e.cpu_id);
+}
+
+static inline int32_t rseq_current_cpu(void)
+{
+	int32_t cpu;
+
+	cpu = rseq_current_cpu_raw();
+	if (unlikely(cpu < 0))
+		cpu = rseq_fallback_current_cpu();
+	return cpu;
+}
+
+static inline __attribute__((always_inline))
+struct rseq_state rseq_start(void)
+{
+	struct rseq_state result;
+
+	result.rseqp = &__rseq_abi;
+	if (has_single_copy_load_64()) {
+		union rseq_cpu_event u;
+
+		u.v = ACCESS_ONCE(result.rseqp->u.v);
+		result.event_counter = u.e.event_counter;
+		result.cpu_id = u.e.cpu_id;
+	} else {
+		result.event_counter =
+			ACCESS_ONCE(result.rseqp->u.e.event_counter);
+		/* load event_counter before cpu_id. */
+		RSEQ_INJECT_C(6)
+		result.cpu_id = ACCESS_ONCE(result.rseqp->u.e.cpu_id);
+	}
+	RSEQ_INJECT_C(7)
+	/*
+	 * Ensure the compiler does not re-order loads of protected
+	 * values before we load the event counter.
+	 */
+	barrier();
+	return result;
+}
+
+enum rseq_finish_type {
+	RSEQ_FINISH_SINGLE,
+	RSEQ_FINISH_TWO,
+	RSEQ_FINISH_MEMCPY,
+};
+
+/*
+ * p_spec and to_write_spec are used for a speculative write attempted
+ * near the end of the restartable sequence. A rseq_finish2 may fail
+ * even after this write takes place.
+ *
+ * p_final and to_write_final are used for the final write. If this
+ * write takes place, the rseq_finish2 is guaranteed to succeed.
+ */
+static inline __attribute__((always_inline))
+bool __rseq_finish(intptr_t *p_spec, intptr_t to_write_spec,
+		void *p_memcpy, void *to_write_memcpy, size_t len_memcpy,
+		intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value,
+		enum rseq_finish_type type, bool release)
+{
+	RSEQ_INJECT_C(9)
+
+	switch (type) {
+	case RSEQ_FINISH_SINGLE:
+		RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+			/* no speculative write */, /* no speculative write */,
+			RSEQ_FINISH_FINAL_STORE_ASM(),
+			RSEQ_FINISH_FINAL_STORE_INPUT(p_final, to_write_final),
+			/* no extra clobber */, /* no arg */, /* no arg */,
+			/* no arg */
+		);
+		break;
+	case RSEQ_FINISH_TWO:
+		if (release) {
+			RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+				RSEQ_FINISH_SPECULATIVE_STORE_ASM(),
+				RSEQ_FINISH_SPECULATIVE_STORE_INPUT(p_spec, to_write_spec),
+				RSEQ_FINISH_FINAL_STORE_RELEASE_ASM(),
+				RSEQ_FINISH_FINAL_STORE_INPUT(p_final, to_write_final),
+				/* no extra clobber */, /* no arg */, /* no arg */,
+				/* no arg */
+			);
+		} else {
+			RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+				RSEQ_FINISH_SPECULATIVE_STORE_ASM(),
+				RSEQ_FINISH_SPECULATIVE_STORE_INPUT(p_spec, to_write_spec),
+				RSEQ_FINISH_FINAL_STORE_ASM(),
+				RSEQ_FINISH_FINAL_STORE_INPUT(p_final, to_write_final),
+				/* no extra clobber */, /* no arg */, /* no arg */,
+				/* no arg */
+			);
+		}
+		break;
+	case RSEQ_FINISH_MEMCPY:
+		if (release) {
+			RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+				RSEQ_FINISH_MEMCPY_STORE_ASM(),
+				RSEQ_FINISH_MEMCPY_STORE_INPUT(p_memcpy, to_write_memcpy, len_memcpy),
+				RSEQ_FINISH_FINAL_STORE_RELEASE_ASM(),
+				RSEQ_FINISH_FINAL_STORE_INPUT(p_final, to_write_final),
+				RSEQ_FINISH_MEMCPY_CLOBBER(),
+				RSEQ_FINISH_MEMCPY_SETUP(),
+				RSEQ_FINISH_MEMCPY_TEARDOWN(),
+				RSEQ_FINISH_MEMCPY_SCRATCH()
+			);
+		} else {
+			RSEQ_FINISH_ASM(p_final, to_write_final, start_value, failure,
+				RSEQ_FINISH_MEMCPY_STORE_ASM(),
+				RSEQ_FINISH_MEMCPY_STORE_INPUT(p_memcpy, to_write_memcpy, len_memcpy),
+				RSEQ_FINISH_FINAL_STORE_ASM(),
+				RSEQ_FINISH_FINAL_STORE_INPUT(p_final, to_write_final),
+				RSEQ_FINISH_MEMCPY_CLOBBER(),
+				RSEQ_FINISH_MEMCPY_SETUP(),
+				RSEQ_FINISH_MEMCPY_TEARDOWN(),
+				RSEQ_FINISH_MEMCPY_SCRATCH()
+			);
+		}
+		break;
+	}
+	return true;
+failure:
+	RSEQ_INJECT_FAILED
+	return false;
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish(intptr_t *p, intptr_t to_write,
+		struct rseq_state start_value)
+{
+	return __rseq_finish(NULL, 0,
+			NULL, NULL, 0,
+			p, to_write, start_value,
+			RSEQ_FINISH_SINGLE, false);
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish2(intptr_t *p_spec, intptr_t to_write_spec,
+		intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	return __rseq_finish(p_spec, to_write_spec,
+			NULL, NULL, 0,
+			p_final, to_write_final, start_value,
+			RSEQ_FINISH_TWO, false);
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish2_release(intptr_t *p_spec, intptr_t to_write_spec,
+		intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	return __rseq_finish(p_spec, to_write_spec,
+			NULL, NULL, 0,
+			p_final, to_write_final, start_value,
+			RSEQ_FINISH_TWO, true);
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish_memcpy(void *p_memcpy, void *to_write_memcpy,
+		size_t len_memcpy, intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	return __rseq_finish(NULL, 0,
+			p_memcpy, to_write_memcpy, len_memcpy,
+			p_final, to_write_final, start_value,
+			RSEQ_FINISH_MEMCPY, false);
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish_memcpy_release(void *p_memcpy, void *to_write_memcpy,
+		size_t len_memcpy, intptr_t *p_final, intptr_t to_write_final,
+		struct rseq_state start_value)
+{
+	return __rseq_finish(NULL, 0,
+			p_memcpy, to_write_memcpy, len_memcpy,
+			p_final, to_write_final, start_value,
+			RSEQ_FINISH_MEMCPY, true);
+}
+
+#endif  /* RSEQ_H_ */
-- 
2.11.0
