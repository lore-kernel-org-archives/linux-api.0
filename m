From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Thu, 21 Jul 2016 17:14:22 -0400
Message-ID: <1469135662-31512-8-git-send-email-mathieu.desnoyers@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
API around restartable sequences. It takes care of ensuring progress in
case of debugger single-stepping with a fall-back to locking, and
exposes the instruction pointer addresses where the rseq assembly blocks
begin and end, as well as the associated abort instruction pointer, in
the __rseq_table section. This section allows debuggers may know where
to place breakpoints when single-stepping through assembly blocks which
may be aborted at any point by the kernel.

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
CC: linux-api@vger.kernel.org
---
 tools/testing/selftests/rseq/.gitignore            |   3 +
 tools/testing/selftests/rseq/Makefile              |  13 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c | 279 ++++++++
 tools/testing/selftests/rseq/basic_test.c          | 106 +++
 tools/testing/selftests/rseq/param_test.c          | 707 +++++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                | 200 ++++++
 tools/testing/selftests/rseq/rseq.h                | 449 +++++++++++++
 7 files changed, 1757 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/.gitignore
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/param_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h

diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
new file mode 100644
index 0000000..2596e26
--- /dev/null
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -0,0 +1,3 @@
+basic_percpu_ops_test
+basic_test
+param_test
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 0000000..3d1ad8e
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,13 @@
+CFLAGS += -O2 -Wall -g -I../../../../usr/include/
+LDFLAGS += -lpthread
+
+TESTS = basic_test basic_percpu_ops_test param_test
+
+all: $(TESTS)
+%: %.c rseq.h rseq.c
+	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TESTS)
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
new file mode 100644
index 0000000..4667dc5
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -0,0 +1,279 @@
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
+
+static struct rseq_lock rseq_lock;
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
+	int count;
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
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	for (;;) {
+		do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+			{
+				if (unlikely(lock->c[cpu].v)) {
+					result = false;
+				} else {
+					newval = 1;
+					targetptr = (intptr_t *)&lock->c[cpu].v;
+				}
+			});
+		if (likely(result))
+			break;
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
+	if (rseq_init_current_thread())
+		abort();
+	for (i = 0; i < data->reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->c[cpu].count++;
+		rseq_percpu_unlock(&data->lock, cpu);
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
+	int i, sum;
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
+	assert(sum == data.reps * num_threads);
+}
+
+int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
+{
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+		{
+			newval = (intptr_t)node;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			node->next = list->c[cpu].head;
+		});
+
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
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+		{
+			head = list->c[cpu].head;
+			if (!head) {
+				result = false;
+			} else {
+				next = head->next;
+				newval = (intptr_t) next;
+				targetptr = (intptr_t *)&list->c[cpu].head;
+			}
+		});
+
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (rseq_init_current_thread())
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
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu linked list from many threads.  */
+void test_percpu_list(void)
+{
+	int i, j;
+	long sum = 0, expected_sum = 0;
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
+	if (rseq_init_lock(&rseq_lock)) {
+		perror("rseq_init_lock");
+		return -1;
+	}
+	if (rseq_init_current_thread())
+		goto error;
+	printf("spinlock\n");
+	test_percpu_spinlock();
+	printf("percpu_list\n");
+	test_percpu_list();
+
+	if (rseq_destroy_lock(&rseq_lock)) {
+		perror("rseq_destroy_lock");
+		return -1;
+	}
+	return 0;
+
+error:
+	if (rseq_destroy_lock(&rseq_lock))
+		perror("rseq_destroy_lock");
+	return -1;
+}
+
diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 0000000..e8fdcd6
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,106 @@
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
+static struct rseq_lock rseq_lock;
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
+	start = rseq_start(&rseq_lock);
+	event_counter = start.event_counter;
+	do {
+		start = rseq_start(&rseq_lock);
+	} while (start.event_counter == event_counter);
+}
+
+void test_signal_interrupt_handler(int signo)
+{
+	struct rseq_state current;
+
+	current = rseq_start(&rseq_lock);
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
+
+	setitimer(ITIMER_PROF, &it, NULL);
+	signal(SIGPROF, test_signal_interrupt_handler);
+
+	do {
+		sigtest_start = rseq_start(&rseq_lock);
+	} while (signals_delivered < 10);
+	setitimer(ITIMER_PROF, NULL, NULL);
+}
+
+int main(int argc, char **argv)
+{
+	if (rseq_init_lock(&rseq_lock)) {
+		perror("rseq_init_lock");
+		return -1;
+	}
+	if (rseq_init_current_thread())
+		goto init_thread_error;
+	printf("testing current cpu\n");
+	test_cpu_pointer();
+	printf("testing critical section\n");
+	test_critical_section();
+	printf("testing critical section is interrupted by signal\n");
+	test_signal_interrupts();
+
+	if (rseq_destroy_lock(&rseq_lock)) {
+		perror("rseq_destroy_lock");
+		return -1;
+	}
+	return 0;
+
+init_thread_error:
+	if (rseq_destroy_lock(&rseq_lock))
+		perror("rseq_destroy_lock");
+	return -1;
+}
diff --git a/tools/testing/selftests/rseq/param_test.c b/tools/testing/selftests/rseq/param_test.c
new file mode 100644
index 0000000..f95fba5
--- /dev/null
+++ b/tools/testing/selftests/rseq/param_test.c
@@ -0,0 +1,707 @@
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
+static int opt_yield, opt_signal, opt_sleep, opt_fallback_cnt = 3,
+		opt_disable_rseq, opt_threads = 200,
+		opt_reps = 5000, opt_disable_mod = 0, opt_test = 's';
+
+static __thread unsigned int signals_delivered;
+
+static struct rseq_lock rseq_lock;
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
+	, [loop_cnt_4]"m"(loop_cnt[4])
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
+#define RSEQ_FALLBACK_CNT	\
+	opt_fallback_cnt
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
+	int count;
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
+/* A simple percpu spinlock.  Returns the cpu lock was acquired on. */
+static int rseq_percpu_lock(struct percpu_lock *lock)
+{
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	for (;;) {
+		do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+			{
+				if (unlikely(lock->c[cpu].v)) {
+					result = false;
+				} else {
+					newval = 1;
+					targetptr = (intptr_t *)&lock->c[cpu].v;
+				}
+			});
+		if (likely(result))
+			break;
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
+			&& rseq_init_current_thread())
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
+	printf_nobench("tid %d: number of retry: %d, signals delivered: %u, nr_fallback %u, nr_fallback_wait %u\n",
+		(int) gettid(), nr_retry, signals_delivered,
+		__rseq_thread_state.fallback_cnt,
+		__rseq_thread_state.fallback_wait_cnt);
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
+	int i, sum, ret;
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
+	assert(sum == opt_reps * num_threads);
+}
+
+void *test_percpu_inc_thread(void *arg)
+{
+	struct inc_thread_test_data *thread_data = arg;
+	struct inc_test_data *data = thread_data->data;
+	int i;
+
+	if (!opt_disable_rseq && thread_data->reg
+			&& rseq_init_current_thread())
+		abort();
+	for (i = 0; i < thread_data->reps; i++) {
+		struct rseq_state rseq_state;
+		intptr_t *targetptr, newval;
+		int cpu;
+		bool result;
+
+		do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+			{
+				newval = (intptr_t)data->c[cpu].count + 1;
+				targetptr = (intptr_t *)&data->c[cpu].count;
+			});
+
+#ifndef BENCHMARK
+		if (i != 0 && !(i % (thread_data->reps / 10)))
+			printf("tid %d: count %d\n", (int) gettid(), i);
+#endif
+	}
+	printf_nobench("tid %d: number of retry: %d, signals delivered: %u, nr_fallback %u, nr_fallback_wait %u\n",
+		(int) gettid(), nr_retry, signals_delivered,
+		__rseq_thread_state.fallback_cnt,
+		__rseq_thread_state.fallback_wait_cnt);
+	return NULL;
+}
+
+void test_percpu_inc(void)
+{
+	const int num_threads = opt_threads;
+	int i, sum, ret;
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
+	assert(sum == opt_reps * num_threads);
+}
+
+int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
+{
+	struct rseq_state rseq_state;
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+		{
+			newval = (intptr_t)node;
+			targetptr = (intptr_t *)&list->c[cpu].head;
+			node->next = list->c[cpu].head;
+		});
+
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
+	intptr_t *targetptr, newval;
+	int cpu;
+	bool result;
+
+	do_rseq(&rseq_lock, rseq_state, cpu, result, targetptr, newval,
+		{
+			head = list->c[cpu].head;
+			if (!head) {
+				result = false;
+			} else {
+				next = head->next;
+				newval = (intptr_t) next;
+				targetptr = (intptr_t *) &list->c[cpu].head;
+			}
+		});
+
+	return head;
+}
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	if (rseq_init_current_thread())
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
+	return NULL;
+}
+
+/* Simultaneous modification to a per-cpu linked list from many threads.  */
+void test_percpu_list(void)
+{
+	const int num_threads = opt_threads;
+	int i, j, ret;
+	long sum = 0, expected_sum = 0;
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
+	printf("	[-5 loops] Number of loops for delay injection 5 (-1 to enable -m)\n");
+	printf("	[-6 loops] Number of loops for delay injection 6 (-1 to enable -m)\n");
+	printf("	[-7 loops] Number of loops for delay injection 7 (-1 to enable -m)\n");
+	printf("	[-8 loops] Number of loops for delay injection 8 (-1 to enable -m)\n");
+	printf("	[-9 loops] Number of loops for delay injection 9 (-1 to enable -m)\n");
+	printf("	[-m N] Yield/sleep/kill every modulo N (default 0: disabled) (>= 0)\n");
+	printf("	[-y] Yield\n");
+	printf("	[-k] Kill thread with signal\n");
+	printf("	[-s S] S: =0: disabled (default), >0: sleep time (ms)\n");
+	printf("	[-f N] Use fallback every N failure (>= 1)\n");
+	printf("	[-t N] Number of threads (default 200)\n");
+	printf("	[-r N] Number of repetitions per thread (default 5000)\n");
+	printf("	[-d] Disable rseq system call (no initialization)\n");
+	printf("	[-D M] Disable rseq for each M threads\n");
+	printf("	[-T test] Choose test: (s)pinlock, (l)ist, (i)ncrement\n");
+	printf("	[-h] Show this help.\n");
+	printf("\n");
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	if (rseq_init_lock(&rseq_lock)) {
+		perror("rseq_init_lock");
+		return -1;
+	}
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
+		case 'f':
+			if (argc < i + 2) {
+				show_usage(argc, argv);
+				goto error;
+			}
+			opt_fallback_cnt = atol(argv[i + 1]);
+			if (opt_fallback_cnt < 1) {
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
+	if (!opt_disable_rseq && rseq_init_current_thread())
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
+	case 'i':
+		printf_nobench("counter increment\n");
+		test_percpu_inc();
+		break;
+	}
+end:
+	return 0;
+
+error:
+	if (rseq_destroy_lock(&rseq_lock))
+		perror("rseq_destroy_lock");
+	return -1;
+}
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
new file mode 100644
index 0000000..f411be2
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -0,0 +1,200 @@
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
+#include <linux/membarrier.h>
+
+#include "rseq.h"
+
+#ifdef __NR_membarrier
+# define membarrier(...)		syscall(__NR_membarrier, __VA_ARGS__)
+#else
+# define membarrier(...)		-ENOSYS
+#endif
+
+__thread volatile struct rseq_thread_state __rseq_thread_state = {
+	.abi.u.e.cpu_id = -1,
+};
+
+int rseq_has_sys_membarrier;
+
+static int sys_rseq(volatile struct rseq *rseq_abi, int flags)
+{
+	return syscall(__NR_rseq, rseq_abi, flags);
+}
+
+int rseq_init_current_thread(void)
+{
+	int rc;
+
+	rc = sys_rseq(&__rseq_thread_state.abi, 0);
+	if (rc) {
+		fprintf(stderr, "Error: sys_rseq(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		return -1;
+	}
+	assert(rseq_current_cpu() >= 0);
+	return 0;
+}
+
+int rseq_init_lock(struct rseq_lock *rlock)
+{
+	int ret;
+
+	ret = pthread_mutex_init(&rlock->lock, NULL);
+	if (ret) {
+		errno = ret;
+		return -1;
+	}
+	rlock->state = RSEQ_LOCK_STATE_RESTART;
+	return 0;
+}
+
+int rseq_destroy_lock(struct rseq_lock *rlock)
+{
+	int ret;
+
+	ret = pthread_mutex_destroy(&rlock->lock);
+	if (ret) {
+		errno = ret;
+		return -1;
+	}
+	return 0;
+}
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
+static void rseq_fallback_lock(struct rseq_lock *rlock)
+{
+	signal_off_save((sigset_t *)&__rseq_thread_state.sigmask_saved);
+	pthread_mutex_lock(&rlock->lock);
+	__rseq_thread_state.fallback_cnt++;
+	/*
+	 * For concurrent threads arriving before we set LOCK:
+	 * reading cpu_id after setting the state to LOCK
+	 * ensures they restart.
+	 */
+	ACCESS_ONCE(rlock->state) = RSEQ_LOCK_STATE_LOCK;
+	/*
+	 * For concurrent threads arriving after we set LOCK:
+	 * those will grab the lock, so we are protected by
+	 * mutual exclusion.
+	 */
+}
+
+void rseq_fallback_wait(struct rseq_lock *rlock)
+{
+	signal_off_save((sigset_t *)&__rseq_thread_state.sigmask_saved);
+	pthread_mutex_lock(&rlock->lock);
+	__rseq_thread_state.fallback_wait_cnt++;
+	pthread_mutex_unlock(&rlock->lock);
+	signal_restore(__rseq_thread_state.sigmask_saved);
+}
+
+static void rseq_fallback_unlock(struct rseq_lock *rlock, int cpu_at_start)
+{
+	/*
+	 * Concurrent rseq arriving before we set state back to RESTART
+	 * grab the lock. Those arriving after we set state back to
+	 * RESTART will perform restartable critical sections. The next
+	 * owner of the lock will take take of making sure it prevents
+	 * concurrent restartable sequences from completing.  We may be
+	 * writing from another CPU, so update the state with a store
+	 * release semantic to ensure restartable sections will see our
+	 * side effect (writing to *p) before they enter their
+	 * restartable critical section.
+	 *
+	 * In cases where we observe that we are on the right CPU after the
+	 * critical section, program order ensures that following restartable
+	 * critical sections will see our stores, so we don't have to use
+	 * store-release or membarrier.
+	 *
+	 * Use sys_membarrier when available to remove the memory barrier
+	 * implied by smp_load_acquire().
+	 */
+	barrier();
+	if (likely(rseq_current_cpu() == cpu_at_start)) {
+		ACCESS_ONCE(rlock->state) = RSEQ_LOCK_STATE_RESTART;
+	} else {
+		if (!has_fast_acquire_release() && rseq_has_sys_membarrier) {
+			if (membarrier(MEMBARRIER_CMD_SHARED, 0))
+				abort();
+			ACCESS_ONCE(rlock->state) = RSEQ_LOCK_STATE_RESTART;
+		} else {
+			/*
+			 * Store with release semantic to ensure
+			 * restartable sections will see our side effect
+			 * (writing to *p) before they enter their
+			 * restartable critical section. Matches
+			 * smp_load_acquire() in rseq_start().
+			 */
+			smp_store_release(&rlock->state,
+				RSEQ_LOCK_STATE_RESTART);
+		}
+	}
+	pthread_mutex_unlock(&rlock->lock);
+	signal_restore(__rseq_thread_state.sigmask_saved);
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
+
+int rseq_fallback_begin(struct rseq_lock *rlock)
+{
+	rseq_fallback_lock(rlock);
+	return rseq_fallback_current_cpu();
+}
+
+void rseq_fallback_end(struct rseq_lock *rlock, int cpu)
+{
+	rseq_fallback_unlock(rlock, cpu);
+}
+
+/* Handle non-initialized rseq for this thread. */
+void rseq_fallback_noinit(struct rseq_state *rseq_state)
+{
+	rseq_state->lock_state = RSEQ_LOCK_STATE_FAIL;
+	rseq_state->cpu_id = 0;
+}
+
+void __attribute__((constructor)) rseq_init(void)
+{
+	int ret;
+
+	ret = membarrier(MEMBARRIER_CMD_QUERY, 0);
+	if (ret >= 0 && (ret & MEMBARRIER_CMD_SHARED))
+		rseq_has_sys_membarrier = 1;
+}
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
new file mode 100644
index 0000000..791e14c
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -0,0 +1,449 @@
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
+#ifndef RSEQ_FALLBACK_CNT
+#define RSEQ_FALLBACK_CNT	3
+#endif
+
+struct rseq_thread_state {
+	struct rseq abi;	/* Kernel ABI. */
+	uint32_t fallback_wait_cnt;
+	uint32_t fallback_cnt;
+	sigset_t sigmask_saved;
+};
+
+extern __thread volatile struct rseq_thread_state __rseq_thread_state;
+extern int rseq_has_sys_membarrier;
+
+#define likely(x)		__builtin_expect(!!(x), 1)
+#define unlikely(x)		__builtin_expect(!!(x), 0)
+#define barrier()		__asm__ __volatile__("" : : : "memory")
+
+#define ACCESS_ONCE(x)		(*(__volatile__  __typeof__(x) *)&(x))
+#define WRITE_ONCE(x, v)	__extension__ ({ ACCESS_ONCE(x) = (v); })
+#define READ_ONCE(x)		ACCESS_ONCE(x)
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
+#elif defined(__ARMEL__)
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
+#else
+#error unsupported target
+#endif
+
+enum rseq_lock_state {
+	RSEQ_LOCK_STATE_RESTART = 0,
+	RSEQ_LOCK_STATE_LOCK = 1,
+	RSEQ_LOCK_STATE_FAIL = 2,
+};
+
+struct rseq_lock {
+	pthread_mutex_t lock;
+	int32_t state;		/* enum rseq_lock_state */
+};
+
+/* State returned by rseq_start, passed as argument to rseq_finish. */
+struct rseq_state {
+	volatile struct rseq_thread_state *rseqp;
+	int32_t cpu_id;		/* cpu_id at start. */
+	uint32_t event_counter;	/* event_counter at start. */
+	int32_t lock_state;	/* Lock state at start. */
+};
+
+/*
+ * Initialize rseq for the current thread.  Must be called once by any
+ * thread which uses restartable sequences, before they start using
+ * restartable sequences. If initialization is not invoked, or if it
+ * fails, the restartable critical sections will fall-back on locking
+ * (rseq_lock).
+ */
+int rseq_init_current_thread(void);
+
+/*
+ * The fallback lock should be initialized before being used by any
+ * thread, and destroyed after all threads are done using it. This lock
+ * should be used by all rseq calls associated with shared data, either
+ * between threads, or between processes in a shared memory.
+ *
+ * There may be many rseq_lock per process, e.g. one per protected data
+ * structure.
+ */
+int rseq_init_lock(struct rseq_lock *rlock);
+int rseq_destroy_lock(struct rseq_lock *rlock);
+
+/*
+ * Restartable sequence fallback prototypes. Fallback on locking when
+ * rseq is not initialized, not available on the system, or during
+ * single-stepping to ensure forward progress.
+ */
+int rseq_fallback_begin(struct rseq_lock *rlock);
+void rseq_fallback_end(struct rseq_lock *rlock, int cpu);
+void rseq_fallback_wait(struct rseq_lock *rlock);
+void rseq_fallback_noinit(struct rseq_state *rseq_state);
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
+	return ACCESS_ONCE(__rseq_thread_state.abi.u.e.cpu_id);
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
+struct rseq_state rseq_start(struct rseq_lock *rlock)
+{
+	struct rseq_state result;
+
+	result.rseqp = &__rseq_thread_state;
+	if (has_single_copy_load_64()) {
+		union {
+			struct {
+				uint32_t cpu_id;
+				uint32_t event_counter;
+			} e;
+			uint64_t v;
+		} u;
+
+		u.v = ACCESS_ONCE(result.rseqp->abi.u.v);
+		result.event_counter = u.e.event_counter;
+		result.cpu_id = u.e.cpu_id;
+	} else {
+		result.event_counter =
+			ACCESS_ONCE(result.rseqp->abi.u.e.event_counter);
+		/* load event_counter before cpu_id. */
+		RSEQ_INJECT_C(5)
+		result.cpu_id = ACCESS_ONCE(result.rseqp->abi.u.e.cpu_id);
+	}
+	/*
+	 * Read event counter before lock state and cpu_id. This ensures
+	 * that when the state changes from RESTART to LOCK, if we have
+	 * some threads that have already seen the RESTART still in
+	 * flight, they will necessarily be preempted/signalled before a
+	 * thread can see the LOCK state for that same CPU. That
+	 * preemption/signalling will cause them to restart, so they
+	 * don't interfere with the lock.
+	 */
+	RSEQ_INJECT_C(6)
+
+	if (!has_fast_acquire_release() && likely(rseq_has_sys_membarrier)) {
+		result.lock_state = ACCESS_ONCE(rlock->state);
+		barrier();
+	} else {
+		/*
+		 * Load lock state with acquire semantic. Matches
+		 * smp_store_release() in rseq_fallback_end().
+		 */
+		result.lock_state = smp_load_acquire(&rlock->state);
+	}
+	if (unlikely(result.cpu_id < 0))
+		rseq_fallback_noinit(&result);
+	/*
+	 * We need to ensure that the compiler does not re-order the
+	 * loads of any protected values before we read the current
+	 * state.
+	 */
+	barrier();
+	return result;
+}
+
+static inline __attribute__((always_inline))
+bool rseq_finish(struct rseq_lock *rlock,
+		intptr_t *p, intptr_t to_write,
+		struct rseq_state start_value)
+{
+	RSEQ_INJECT_C(9)
+
+	if (unlikely(start_value.lock_state != RSEQ_LOCK_STATE_RESTART)) {
+		if (start_value.lock_state == RSEQ_LOCK_STATE_LOCK)
+			rseq_fallback_wait(rlock);
+		return false;
+	}
+
+#ifdef __x86_64__
+	/*
+	 * The __rseq_table section can be used by debuggers to better
+	 * handle single-stepping through the restartable critical
+	 * sections.
+	 */
+	__asm__ __volatile__ goto (
+		".pushsection __rseq_table, \"aw\"\n\t"
+		".balign 8\n\t"
+		"4:\n\t"
+		".quad 1f, 2f, 3f\n\t"
+		".popsection\n\t"
+		"1:\n\t"
+		RSEQ_INJECT_ASM(1)
+		"movq $4b, (%[rseq_cs])\n\t"
+		RSEQ_INJECT_ASM(2)
+		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
+		"jnz 3f\n\t"
+		RSEQ_INJECT_ASM(3)
+		"movq %[to_write], (%[target])\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		"movq $0, (%[rseq_cs])\n\t"
+		"jmp %l[succeed]\n\t"
+		"3: movq $0, (%[rseq_cs])\n\t"
+		: /* no outputs */
+		: [start_event_counter]"r"(start_value.event_counter),
+		  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
+		  [to_write]"r"(to_write),
+		  [target]"r"(p),
+		  [rseq_cs]"r"(&start_value.rseqp->abi.rseq_cs)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: succeed
+	);
+#elif defined(__i386__)
+	/*
+	 * The __rseq_table section can be used by debuggers to better
+	 * handle single-stepping through the restartable critical
+	 * sections.
+	 */
+	__asm__ __volatile__ goto (
+		".pushsection __rseq_table, \"aw\"\n\t"
+		".balign 8\n\t"
+		"4:\n\t"
+		".long 1f, 0x0, 2f, 0x0, 3f, 0x0\n\t"
+		".popsection\n\t"
+		"1:\n\t"
+		RSEQ_INJECT_ASM(1)
+		"movl $4b, (%[rseq_cs])\n\t"
+		RSEQ_INJECT_ASM(2)
+		"cmpl %[start_event_counter], %[current_event_counter]\n\t"
+		"jnz 3f\n\t"
+		RSEQ_INJECT_ASM(3)
+		"movl %[to_write], (%[target])\n\t"
+		"2:\n\t"
+		RSEQ_INJECT_ASM(4)
+		"movl $0, (%[rseq_cs])\n\t"
+		"jmp %l[succeed]\n\t"
+		"3: movl $0, (%[rseq_cs])\n\t"
+		: /* no outputs */
+		: [start_event_counter]"r"(start_value.event_counter),
+		  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
+		  [to_write]"r"(to_write),
+		  [target]"r"(p),
+		  [rseq_cs]"r"(&start_value.rseqp->abi.rseq_cs)
+		  RSEQ_INJECT_INPUT
+		: "memory", "cc"
+		  RSEQ_INJECT_CLOBBER
+		: succeed
+	);
+#elif defined(__ARMEL__)
+	{
+		/*
+		 * The __rseq_table section can be used by debuggers to better
+		 * handle single-stepping through the restartable critical
+		 * sections.
+		 */
+		__asm__ __volatile__ goto (
+			".pushsection __rseq_table, \"aw\"\n\t"
+			".balign 8\n\t"
+			".word 1f, 0x0, 2f, 0x0, 3f, 0x0\n\t"
+			".popsection\n\t"
+			"1:\n\t"
+			RSEQ_INJECT_ASM(1)
+			"adr r0, 4f\n\t"
+			"str r0, [%[rseq_cs]]\n\t"
+			RSEQ_INJECT_ASM(2)
+			"ldr r0, %[current_event_counter]\n\t"
+			"mov r1, #0\n\t"
+			"cmp %[start_event_counter], r0\n\t"
+			"bne 3f\n\t"
+			RSEQ_INJECT_ASM(3)
+			"str %[to_write], [%[target]]\n\t"
+			"2:\n\t"
+			RSEQ_INJECT_ASM(4)
+			"str r1, [%[rseq_cs]]\n\t"
+			"b %l[succeed]\n\t"
+			".balign 8\n\t"
+			"4:\n\t"
+			".word 1b, 0x0, 2b, 0x0, 3f, 0x0\n\t"
+			"3:\n\t"
+			"mov r1, #0\n\t"
+			"str r1, [%[rseq_cs]]\n\t"
+			: /* no outputs */
+			: [start_event_counter]"r"(start_value.event_counter),
+			  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
+			  [to_write]"r"(to_write),
+			  [rseq_cs]"r"(&start_value.rseqp->abi.rseq_cs),
+			  [target]"r"(p)
+			  RSEQ_INJECT_INPUT
+			: "r0", "r1", "memory", "cc"
+			  RSEQ_INJECT_CLOBBER
+			: succeed
+		);
+	}
+#else
+#error unsupported target
+#endif
+	RSEQ_INJECT_FAILED
+	return false;
+succeed:
+	return true;
+}
+
+/*
+ * Helper macro doing two restartable critical section attempts, and if
+ * they fail, fallback on locking.
+ */
+#define do_rseq(_lock, _rseq_state, _cpu, _result, _targetptr, _newval, \
+		_code)							\
+	do {								\
+		_rseq_state = rseq_start(_lock);			\
+		_cpu = rseq_cpu_at_start(_rseq_state);			\
+		_result = true;						\
+		_code							\
+		if (unlikely(!_result))					\
+			break;						\
+		if (likely(rseq_finish(_lock, _targetptr, _newval,	\
+				_rseq_state)))				\
+			break;						\
+		_rseq_state = rseq_start(_lock);			\
+		_cpu = rseq_cpu_at_start(_rseq_state);			\
+		_result = true;						\
+		_code							\
+		if (unlikely(!_result))					\
+			break;						\
+		if (likely(rseq_finish(_lock, _targetptr, _newval,	\
+				_rseq_state)))				\
+			break;						\
+		_cpu = rseq_fallback_begin(_lock);			\
+		_result = true;						\
+		_code							\
+		if (likely(_result))					\
+			*(_targetptr) = (_newval);			\
+		rseq_fallback_end(_lock, _cpu);				\
+	} while (0)
+
+#endif  /* RSEQ_H_ */
-- 
2.1.4
