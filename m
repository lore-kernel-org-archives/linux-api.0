From: Paul Turner <commonly@gmail.com>
Subject: [RFC PATCH v2 3/3] restartable sequences: basic self-tests
Date: Tue, 27 Oct 2015 16:57:16 -0700
Message-ID: <20151027235716.16059.47610.stgit@pjt-glaptop.roam.corp.google.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dave Watson <davejwatson@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@redhat.com>, Chris Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

From: pjt <pjt@pjt-glaptop.roam.corp.google.com>

Implements two basic tests of RSEQ functionality.

The first, "basic_test" only asserts that RSEQ works moderately correctly.
E.g. that:
- The CPUID pointer works
- Code infinitely looping within a critical section will eventually be
interrupted.
- Critical sections are interrupted by signals.

"basic_percpu_ops_test" is a slightly more "realistic" variant, implementing a
few simple per-cpu operations and testing their correctness.  It also includes
a trivial example of user-space may multiplexing the critical section via the
restart handler.

Signed-off-by: Paul Turner <pjt@google.com>
---
 tools/testing/selftests/rseq/Makefile              |   13 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  268 ++++++++++++++++++++
 tools/testing/selftests/rseq/basic_test.c          |   87 ++++++
 tools/testing/selftests/rseq/rseq.c                |   36 +++
 tools/testing/selftests/rseq/rseq.h                |  109 ++++++++
 5 files changed, 513 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h

diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 0000000..40b9338
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,13 @@
+CFLAGS += -Wall
+LDFLAGS += -lpthread
+
+TESTS = basic_test basic_percpu_ops_test
+
+all: $(TESTS)
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^ rseq.c $(LDFLAGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TESTS)
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
new file mode 100644
index 0000000..dcc57ad
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -0,0 +1,268 @@
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
+struct percpu_lock {
+	intptr_t word[CPU_SETSIZE][64 / sizeof(intptr_t)];  /* Cache aligned */
+};
+
+/* A simple percpu spinlock.  Returns the cpu lock was acquired on. */
+int rseq_percpu_lock(struct percpu_lock *lock)
+{
+	struct rseq_state start;
+	int cpu;
+
+	do {
+		start = rseq_start();
+		cpu = rseq_cpu_at_start(start);
+	} while (lock->word[cpu][0] ||
+		 !rseq_finish(&lock->word[cpu][0], 1, start));
+	return cpu;
+}
+
+void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	barrier();  /* need a release-store here, this suffices on x86. */
+	assert(lock->word[cpu][0] == 1);
+	lock->word[cpu][0] = 0;
+}
+
+/*
+ * cmpxchg [with an additional check value].
+ *
+ * Returns:
+ *  -1 if *p != old [ || check_ptr != check_val, ] otherwise
+ *  cpu that rseq_percpu_cmpxchgcheck was executed.
+ *   - If this is different from the passed cpu, no modifications were made.
+ *
+ * Note: When specified, check_ptr is dereferenced iff *p == old
+ */
+int rseq_percpu_cmpxchg(int cpu, intptr_t *p, intptr_t old, intptr_t new)
+{
+	struct rseq_state start;
+
+	while (1) {
+		start = rseq_start();
+		if (rseq_current_cpu() != cpu) return rseq_current_cpu();
+		if (*p != old)
+			return -1;
+		if (rseq_finish(p, new, start)) return cpu;
+	}
+}
+
+int rseq_percpu_cmpxchgcheck(int cpu, intptr_t *p, intptr_t old, intptr_t new,
+			     intptr_t *check_ptr, intptr_t check_val)
+{
+	struct rseq_state start;
+
+	while (1) {
+		start = rseq_start();
+		if (rseq_current_cpu() != cpu) return rseq_current_cpu();
+		/*
+		 * Note that we'd want the ultimate implementation of this to
+		 * be open coded (similar to rseq_finish) so that we can
+		 * guarantee *check is not dereferenced when old does not
+		 * match.  This could also be facilitated with a generic
+		 * rseq_read_if_valid(...) helper.
+		 */
+		if (*p != old || *check_ptr != check_val)
+			return -1;
+		if (rseq_finish(p, new, start)) return cpu;
+	}
+}
+
+void rseq_unknown_restart_addr(void *addr)
+{
+	fprintf(stderr, "rseq: unrecognized restart address %p\n", addr);
+	exit(1);
+}
+
+struct spinlock_test_data {
+	struct percpu_lock lock;
+	int counts[CPU_SETSIZE];
+	int reps;
+};
+
+void *test_percpu_spinlock_thread(void *arg)
+{
+	struct spinlock_test_data *data = arg;
+
+	int i, cpu;
+	rseq_init_current_thread();
+	for (i = 0; i < data->reps; i++) {
+		cpu = rseq_percpu_lock(&data->lock);
+		data->counts[cpu]++;
+		rseq_percpu_unlock(&data->lock, cpu);
+	}
+
+	return 0;
+}
+
+/*
+ * A simple test which implements a sharded counter using a per-cpu lock.
+ * Obviously real applications might prefer to simply use a per-cpu increment;
+ * however, this is reasonable for a test and the lock can be extended to
+ * synchronize more complicated operations.
+ */
+void test_percpu_spinlock()
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
+			       test_percpu_spinlock_thread, &data);
+
+	for (i = 0; i < num_threads; i++)
+		pthread_join(test_threads[i], NULL);
+
+	sum = 0;
+	for (i = 0; i < CPU_SETSIZE; i++)
+		sum += data.counts[i];
+
+	assert(sum == data.reps * num_threads);
+}
+
+struct percpu_list_node {
+	intptr_t data;
+	struct percpu_list_node *next;
+};
+
+struct percpu_list {
+	struct percpu_list_node *heads[CPU_SETSIZE];
+};
+
+int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
+{
+	int cpu;
+
+	do {
+		cpu = rseq_current_cpu();
+		node->next = list->heads[cpu];
+	} while (cpu != rseq_percpu_cmpxchg(cpu,
+			(intptr_t *)&list->heads[cpu], (intptr_t)node->next,
+			(intptr_t)node));
+
+	return cpu;
+}
+
+struct percpu_list_node *percpu_list_pop(struct percpu_list *list)
+{
+	int cpu;
+	struct percpu_list_node *head, *next;
+
+	do {
+		cpu = rseq_current_cpu();
+		head = list->heads[cpu];
+		/*
+		 * Unlike a traditional lock-less linked list; the availability
+		 * of a cmpxchg-check primitive allows us to implement pop
+		 * without concerns over ABA-type races.
+		 */
+		if (!head) return 0;
+		next = head->next;
+	} while (cpu != rseq_percpu_cmpxchgcheck(cpu,
+		(intptr_t *)&list->heads[cpu], (intptr_t)head, (intptr_t)next,
+		(intptr_t *)&head->next, (intptr_t)next));
+
+	return head;
+}
+
+
+void *test_percpu_list_thread(void *arg)
+{
+	int i;
+	struct percpu_list *list = (struct percpu_list *)arg;
+
+	rseq_init_current_thread();
+	for (i = 0; i < 100000; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+		sched_yield();  /* encourage shuffling */
+		if (node) percpu_list_push(list, node);
+	}
+
+	return 0;
+}
+
+/* Simultaneous modification to a per-cpu linked list from many threads.  */
+void test_percpu_list()
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
+		if (!CPU_ISSET(i, &allowed_cpus)) continue;
+		for (j = 1; j <= 100; j++) {
+			struct percpu_list_node *node;
+
+			expected_sum += j;
+
+			node = malloc(sizeof(*node));
+			assert(node);
+			node->data = j;
+			node->next = list.heads[i];
+			list.heads[i] = node;
+		}
+	}
+
+	for (i = 0; i < 200; i++)
+		assert(pthread_create(&test_threads[i], NULL,
+			       test_percpu_list_thread, &list) == 0);
+
+	for (i = 0; i < 200; i++)
+		pthread_join(test_threads[i], NULL);
+
+	for (i = 0; i < CPU_SETSIZE; i++) {
+		cpu_set_t pin_mask;
+		struct percpu_list_node *node;
+
+		if (!CPU_ISSET(i, &allowed_cpus)) continue;
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
+	 * All entries should now be accounted for (unless some external actor
+	 * is interfering with our allowed affinity while this test is
+	 * running).
+	 */
+	assert(sum == expected_sum);
+}
+
+int main(int argc, char **argv)
+{
+	rseq_init_current_thread();
+	printf("spinlock\n");
+	test_percpu_spinlock();
+	printf("percpu_list\n");
+	test_percpu_list();
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 0000000..a3d3cdf
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,87 @@
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
+void test_cpu_pointer()
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
+					  &test_affinity);
+			assert(rseq_current_cpu() == sched_getcpu());
+			assert(rseq_current_cpu() == i);
+			CPU_CLR(i, &test_affinity);
+		}
+	}
+	sched_setaffinity(0, sizeof(affinity), &affinity);
+}
+
+void test_critical_section()
+{
+	/*
+	 * This depends solely on some environmental event triggering a counter
+	 * increase.
+	 */
+	struct rseq_state start = rseq_start(), current;
+	do {
+		current = rseq_start();
+	} while (start.cpu == current.cpu &&
+		 start.event_counter == current.event_counter);
+}
+
+volatile int signals_delivered;
+volatile struct rseq_state start;
+
+void test_signal_interrupt_handler()
+{
+	struct rseq_state current = rseq_start();
+	/*
+	 * The potential critical section bordered by 'start' must be invalid.
+	 */
+	assert(current.cpu != start.cpu ||
+	       current.event_counter != start.event_counter);
+	signals_delivered++;
+}
+
+void test_signal_interrupts()
+{
+	struct itimerval it = {{0, 1}, {0, 1}};
+	setitimer(ITIMER_PROF, &it, NULL);
+	signal(SIGPROF, test_signal_interrupt_handler);
+
+	do {
+		start = rseq_start();
+	} while (signals_delivered < 10);
+	setitimer(ITIMER_PROF, NULL, NULL);
+}
+
+int main(int argc, char **argv)
+{
+	rseq_init_current_thread();
+
+	printf("testing current cpu\n");
+	test_cpu_pointer();
+	printf("testing critical section\n");
+	test_critical_section();
+	printf("testing critical section is interrupted by signal\n");
+	test_signal_interrupts();
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
new file mode 100644
index 0000000..0ed5c8e
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -0,0 +1,36 @@
+#define _GNU_SOURCE
+#include <assert.h>
+#include <errno.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "rseq.h"
+
+__thread volatile struct rseq_state __rseq_state = { .cpu=-1 };
+
+#define __NR_rseq	325
+
+int sys_rseq(int flags,
+	     volatile uint64_t* event_and_cpu,
+	     volatile void* post_commit_instr)
+{
+	return syscall(__NR_rseq, flags,
+		       (intptr_t)event_and_cpu,
+		       (intptr_t)post_commit_instr);
+}
+
+void rseq_init_current_thread(void)
+{
+	int rc = sys_rseq(0, &__rseq_state.storage,
+			  &__rseq_state.post_commit_instr);
+	if (rc) {
+		fprintf(stderr,"Error: sys_rseq(...) failed(%d): %s\n",
+			errno, strerror(errno));
+		exit(1);
+	}
+	assert(rseq_current_cpu() != -1); /* always updated prior to return. */
+}
+
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
new file mode 100644
index 0000000..d16e02d
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -0,0 +1,109 @@
+#ifndef RSEQ_H
+#define RSEQ_H
+
+#include <stdint.h>
+
+struct rseq_state {
+	union {
+		/*
+		 * Updated by the kernel.  The time between two rseq state
+		 * objects can be considered non-interrupted if-and-only-if
+		 * both cpu and event_counter match.
+		 *
+		 * Explicitly: the kernel is allowed to maintain a
+		 * per-cpu event_counter.
+		 */
+		struct {
+			int cpu;
+			int event_counter;
+		};
+		uint64_t storage;
+	};
+	void* post_commit_instr;
+};
+
+extern __thread volatile struct rseq_state __rseq_state;
+
+int sys_rseq(int flags,
+	     volatile uint64_t* event_and_cpu,
+	     volatile void* post_commit_instr);
+
+#define barrier() __asm__ __volatile__("": : :"memory")
+
+static inline struct rseq_state rseq_start()
+{
+	struct rseq_state result = __rseq_state;
+	/*
+	 * We need to ensure that the compiler does not re-order the loads of
+	 * any protected values before we read the current state.
+	 */
+	barrier();
+	return result;
+}
+
+static inline int rseq_cpu_at_start(struct rseq_state start_value)
+{
+	return start_value.cpu;
+}
+
+static inline int rseq_current_cpu(void)
+{
+	return __rseq_state.cpu;
+}
+
+static inline int rseq_finish(intptr_t *p, intptr_t to_write,
+			      struct rseq_state start_value)
+{
+#ifdef __x86_64__
+	__asm__ __volatile__ goto (
+			"movq $%l[failed], %%rcx\n"
+			"movq $1f, %[commit_instr]\n"
+			"cmpq %[start_value], %[current_value]\n"
+			"jnz %l[failed]\n"
+			"movq %[to_write], (%[target])\n"
+			"1: movq $0, %[commit_instr]\n"
+	  : /* no outputs */
+	  : [start_value]"d"(start_value.storage),
+	    [current_value]"m"(__rseq_state),
+	    [to_write]"r"(to_write),
+	    [target]"r"(p),
+	    [commit_instr]"m"(__rseq_state.post_commit_instr)
+	  : "rcx", "memory"
+	  : failed
+	);
+#elif __i386__
+	__asm__ __volatile__ goto (
+			"movl $%l[failed], %%ecx\n"
+			"movl $1f, %[post_commit_instr]\n"
+			"cmp %[start_cpu], %[current_cpu]\n"
+			"jnz %l[failed]\n"
+			"cmp %[start_event], %[current_event]\n"
+			"jnz %l[failed]\n"
+			"movl %[to_write], (%[target])\n"
+			"1: movl $0, %[post_commit_instr]\n"
+	  : /* no outputs */
+	  : [start_cpu]"a"(start_value.cpu),
+	    [start_event]"d"(start_value.event_counter),
+	    [current_cpu]"g"(__rseq_state.cpu),
+	    [current_event]"g"(__rseq_state.event_counter),
+	    [post_commit_instr]"g"(__rseq_state.post_commit_instr),
+	    [to_write]"r"(to_write),
+	    [target]"r"(p)
+	  : "ecx", "memory"
+	  : failed
+	);
+#else
+#error unsupported target
+#endif
+	return 1;
+failed:
+	return 0;
+}
+
+/*
+ * Initialize rseq for the current thread.  Must be called once by any thread
+ * which uses restartable_sequences.
+ */
+void rseq_init_current_thread(void);
+
+#endif  /* RSEQ_H_ */
