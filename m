From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/3] restartable sequences: basic user-space self-tests
Date: Wed, 24 Jun 2015 15:26:09 -0700
Message-ID: <20150624222609.6116.42278.stgit@kitami.mtv.corp.google.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624222609.6116.86035.stgit-tdHu5vqousHHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Implements two basic tests of RSEQ functionality.

The first, "basic_test" only asserts that RSEQ works moderately correctly.
E.g. that:
  - The CPUID pointer works
  - Code infinitely looping within a critical section will eventually be
    interrupted.

"basic_percpu_ops_test" is a slightly more "realistic" variant, implementing a
few simple per-cpu operations and testing their correctness.  It also includes
a trivial example of user-space may multiplexing the critical section via the
restart handler.

Signed-off-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/rseq/Makefile              |   15 +
 .../testing/selftests/rseq/basic_percpu_ops_test.S |  131 ++++++++++
 .../testing/selftests/rseq/basic_percpu_ops_test.c |  250 ++++++++++++++++++++
 tools/testing/selftests/rseq/basic_test.c          |   76 ++++++
 tools/testing/selftests/rseq/rseq.c                |   48 ++++
 tools/testing/selftests/rseq/rseq.h                |   28 ++
 6 files changed, 548 insertions(+)
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.S
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/basic_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h

diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
new file mode 100644
index 0000000..c5a2b47
--- /dev/null
+++ b/tools/testing/selftests/rseq/Makefile
@@ -0,0 +1,15 @@
+CFLAGS += -Wall
+LDFLAGS += -lpthread
+
+TESTS = basic_test basic_percpu_ops_test
+
+basic_percpu_ops_test: basic_percpu_ops_test.c basic_percpu_ops_test.S
+
+all: $(TESTS)
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^ rseq.c $(LDFLAGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TESTS)
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.S b/tools/testing/selftests/rseq/basic_percpu_ops_test.S
new file mode 100644
index 0000000..7da7781
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.S
@@ -0,0 +1,131 @@
+#include "rseq.h"
+
+#ifdef __x86_64__
+	.text
+	.code64
+
+#define FETCH_CPU(dest) movl %fs:__rseq_current_cpu@TPOFF, dest
+#define CRITICAL_SECTION_OFFSET(label) $label
+
+/* If start <= %RESTART_ADDR_REG < %end, jump to jump_to */
+#define HANDLE_REGION(start, end, jump_to) \
+	cmpq    CRITICAL_SECTION_OFFSET(end), %RESTART_ADDR_REG; \
+	jge     1f; \
+	cmpq    CRITICAL_SECTION_OFFSET(start), %RESTART_ADDR_REG; \
+	jge     jump_to; \
+	1:;
+
+#define HANDLE_REGION_PREFIX(prefix, start, end, jump_to) \
+	HANDLE_REGION(prefix##start, prefix##end, prefix##jump_to)
+
+/*-----------------------------------------------------------------------------
+ * Start of actual restartable sequences.
+ *---------------------------------------------------------------------------*/
+	.align 8
+	.globl RSEQ_CRITICAL_SECTION_START
+RSEQ_CRITICAL_SECTION_START:
+/* int rseq_percpu_lock() */
+	.globl rseq_percpu_lock
+	.type  rseq_percpu_lock, @function
+rseq_percpu_lock:
+	.cfi_startproc
+rseq_percpu_lock_region0:
+	FETCH_CPU(%eax)
+	leaq (,%eax,8), %RESTART_ADDR_REG
+	leaq (%rdi,%RESTART_ADDR_REG,8), %RESTART_ADDR_REG
+rseq_percpu_lock_retry:
+	cmpw $0, (%RESTART_ADDR_REG)
+	jne rseq_percpu_lock_retry
+	movw $1, (%RESTART_ADDR_REG)  /* 1 => lock owned */
+rseq_percpu_lock_region1:
+	ret
+rseq_percpu_lock_region2:
+	.cfi_endproc
+
+/*
+ * int rseq_cmpxchg(int cpu, intptr_t *p, intptr_t old, intptr_t new)
+ * int rseq_percpu_cmpxchgcheck(int cpu, intptr_t *p,
+ *                              intptr_t old, intptr_t new,
+ *                              intptr_t *check_ptr, intptr_t check_val)
+ *
+ * NOTE:  We don't use cmpxchg in the implementation below as that would make
+ * checking the success of our commit operation was dependent on flags (which
+ * are in turn clobbered by the restart region) -- furthermore we can't just
+ * retry to fill in the flags since the restarted cmpxchg may have actually
+ * succeeded; spuriously failing subsequent attempts.
+ */
+
+	.globl rseq_percpu_cmpxchg
+	.type	rseq_percpu_cmpxchg, @function
+rseq_percpu_cmpxchg:
+	.cfi_startproc
+rseq_percpu_cmpxchg_region0:
+	FETCH_CPU(%eax)
+	cmp %eax, %edi   /* check cpu vs current_cpu */
+	jne rseq_percpu_cmpxchg_region1
+	cmp %rdx, (%rsi) /* verify *p == old */
+	jne rseq_percpu_cmpxchg_region2
+	mov %rcx, (%rsi)
+rseq_percpu_cmpxchg_region1:
+	ret            /* return current cpu, indicating mismatch OR success */
+rseq_percpu_cmpxchg_region2:
+	mov $-1, %eax  /* mismatch versus "old" or "check", return -1 */
+	ret
+rseq_percpu_cmpxchg_region3:
+	.cfi_endproc
+
+	.globl rseq_percpu_cmpxchgcheck
+	.type  rseq_percpu_cmpxchgcheck, @function
+rseq_percpu_cmpxchgcheck:
+	.cfi_startproc
+rseq_percpu_cmpxchgcheck_region0:
+	FETCH_CPU(%eax)
+	cmp %eax, %edi    /* check cpu vs current_cpu */
+	jne rseq_percpu_cmpxchgcheck_region1
+	cmp %rdx, (%rsi)  /* verify *p == old */
+	jne rseq_percpu_cmpxchgcheck_region2
+	cmp %r9, (%r8)    /* verify *check_ptr == check_val */
+	jne rseq_percpu_cmpxchgcheck_region2
+	mov %rcx, (%rsi)
+rseq_percpu_cmpxchgcheck_region1:
+	ret  /* return current cpu, indicating mismatch OR success */
+rseq_percpu_cmpxchgcheck_region2:
+	mov $-1, %eax  /* mismatch versus "old" or "check", return -1 */
+	ret
+rseq_percpu_cmpxchgcheck_region3:
+	.cfi_endproc
+
+	.align 8
+	.globl RSEQ_CRITICAL_SECTION_END
+RSEQ_CRITICAL_SECTION_END:
+
+/*-----------------------------------------------------------------------------
+ * Restart handler
+ * NOTE: per ABI, %RESTART_ADDR_REG is the program-counter we were restarted at.
+ *----------------------------------------------------------------------------
+ */
+
+	.align 8
+	.globl  RSEQ_RESTART_HANDLER
+	.type   RSEQ_RESTART_HANDLER, @function
+RSEQ_RESTART_HANDLER:
+	.cfi_startproc
+	/* There are several ways to implement this more efficiently. */
+	HANDLE_REGION_PREFIX(rseq_percpu_lock_region, 0, 1, 0)
+	HANDLE_REGION_PREFIX(rseq_percpu_lock_region, 1, 2, 1)
+
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchg_region, 0, 1, 0)
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchg_region, 1, 2, 1)
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchg_region, 2, 3, 2)
+
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchgcheck_region, 0, 1, 0)
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchgcheck_region, 1, 2, 1)
+	HANDLE_REGION_PREFIX(rseq_percpu_cmpxchgcheck_region, 2, 3, 2)
+rseq_unknown_restart_addr:
+	mov %RESTART_ADDR_REG, %rdi
+	call rseq_unknown_restart_addr@PLT
+	.cfi_endproc
+
+/* Don't need/want an executable stack. */
+.section	.note.GNU-stack,"",@progbits
+#endif
diff --git a/tools/testing/selftests/rseq/basic_percpu_ops_test.c b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
new file mode 100644
index 0000000..c6d7e4e
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -0,0 +1,250 @@
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
+/* We restrict on !__PIC__ as it greatly simplifies handling of TLS. */
+#if defined(__x86_64__) && !defined(__PIC__)
+
+#define barrier() __asm__ __volatile__("": : :"memory")
+
+/* Implemented by percpu_ops.S */
+struct percpu_lock {
+	int word[CPU_SETSIZE][16];  /* cache aligned; lock-word is [cpu][0] */
+};
+
+/* A simple percpu spinlock.  Returns the cpu lock was acquired on. */
+int rseq_percpu_lock(struct percpu_lock *lock);
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
+int rseq_percpu_cmpxchg(int cpu, intptr_t *p, intptr_t old, intptr_t new);
+int rseq_percpu_cmpxchgcheck(int cpu, intptr_t *p, intptr_t old, intptr_t new,
+			     intptr_t *check_ptr, intptr_t check_val);
+
+
+void rseq_percpu_unlock(struct percpu_lock *lock, int cpu)
+{
+	barrier();  /* need a release-store here, this suffices on x86. */
+	assert(lock->word[cpu][0] == 1);
+	lock->word[cpu][0] = 0;
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
+	rseq_configure_cpu_pointer();
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
+	int i, sum;
+	pthread_t test_threads[200];
+	struct spinlock_test_data data;
+
+	memset(&data, 0, sizeof(data));
+	data.reps = 5000;
+
+	for (i = 0; i < 200; i++)
+		pthread_create(&test_threads[i], NULL,
+			       test_percpu_spinlock_thread, &data);
+
+	for (i = 0; i < 200; i++)
+		pthread_join(test_threads[i], NULL);
+
+	sum = 0;
+	for (i = 0; i < CPU_SETSIZE; i++)
+		sum += data.counts[i];
+
+	assert(sum == data.reps * 200);
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
+	rseq_configure_cpu_pointer();
+	for (i = 0; i < 100000; i++) {
+		struct percpu_list_node *node = percpu_list_pop(list);
+		sched_yield();  /* encourage shuffling */
+		if (node) percpu_list_push(list, node);
+	}
+
+	return 0;
+}
+
+/*
+ * Implements a per-cpu linked list then shuffles it via popping and pushing
+ * from many threads.
+ */
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
+/* defined by basic_percpu_ops_test.S */
+extern void *RSEQ_CRITICAL_SECTION_START;
+extern void *RSEQ_CRITICAL_SECTION_END;
+extern void *RSEQ_RESTART_HANDLER;
+
+int main(int argc, char **argv)
+{
+	rseq_configure_region(&RSEQ_CRITICAL_SECTION_START,
+			      &RSEQ_CRITICAL_SECTION_END,
+			      &RSEQ_RESTART_HANDLER);
+	rseq_configure_cpu_pointer();
+
+	test_percpu_spinlock();
+	test_percpu_list();
+
+	return 0;
+}
+
+#else
+int main(int argc, char **argv)
+{
+	fprintf(stderr, "architecture not supported\n");
+	return 0;
+}
+#endif
diff --git a/tools/testing/selftests/rseq/basic_test.c b/tools/testing/selftests/rseq/basic_test.c
new file mode 100644
index 0000000..cca8edb
--- /dev/null
+++ b/tools/testing/selftests/rseq/basic_test.c
@@ -0,0 +1,76 @@
+/*
+ * Basic test coverage for critical regions and rseq_current_cpu().
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <sched.h>
+
+#include "rseq.h"
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+
+extern void *RSEQ_CRITICAL_SECTION_START;
+extern void *RSEQ_CRITICAL_SECTION_END;
+extern void *RSEQ_RESTART_HANDLER;
+
+/*
+ * Asserts simply that we eventually see *some* event which interrupts our
+ * critical section (which otherwise loops infinitely).  This could be
+ * preemption or signal delivery.
+ */
+int test_critical_section()
+{
+	void* restart_address = 0;
+#if defined(__i386__) || defined(__x86_64__)
+	__asm__(
+		".globl RSEQ_CRITICAL_SECTION_START\n"
+		"RSEQ_CRITICAL_SECTION_START:\n"
+		"  jmp RSEQ_CRITICAL_SECTION_START\n" /* while(1) */
+		".globl RSEQ_CRITICAL_SECTION_END\n"
+		"RSEQ_CRITICAL_SECTION_END:\n"
+		".globl RSEQ_RESTART_HANDLER\n"
+		"RSEQ_RESTART_HANDLER:\n"
+		"  movq %%" STRINGIFY(RESTART_ADDR_REG) ", %0\n"
+	: "=a"(restart_address) ::);
+	assert(restart_address == &RSEQ_CRITICAL_SECTION_START);
+#else
+	fprintf(stderr, "architecture not supported\n");
+#endif
+	return 0;
+}
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
+int main(int argc, char **argv)
+{
+	rseq_configure_region(&RSEQ_CRITICAL_SECTION_START,
+			      &RSEQ_CRITICAL_SECTION_END,
+			      &RSEQ_RESTART_HANDLER);
+	rseq_configure_cpu_pointer();
+
+	test_critical_section();
+	test_cpu_pointer();
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
new file mode 100644
index 0000000..c1ea5d8
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -0,0 +1,48 @@
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
+__thread volatile const int __rseq_current_cpu = -1;
+
+#define __NR_rseq	323
+#define SYS_RSEQ_SET_CRITICAL		0
+#define SYS_RSEQ_SET_CPU_POINTER	1
+
+int sys_rseq(int op, int flags, void* val1, void* val2, void* val3)
+{
+	return syscall(__NR_rseq, op, flags,
+		       (intptr_t)val1, (intptr_t)val2, (intptr_t)val3);
+}
+
+static void sys_rseq_checked(int op, int flags, 
+		void* val1, void* val2, void* val3)
+{
+	int rc = sys_rseq(op, flags, val1, val2, val3);
+	if (rc) {
+		fprintf(stderr,"sys_rseq(%d, %d, %p, %p, %p) failed(%d): %s\n",
+			op, flags, val1, val2, val3, errno, strerror(errno));
+		exit(1);
+	}
+}
+
+void rseq_configure_region(void *rseq_text_start, void *rseq_text_end,
+			   void *rseq_restart_handler)
+{
+	sys_rseq_checked(SYS_RSEQ_SET_CRITICAL, 0,
+		rseq_text_start, rseq_text_end, rseq_restart_handler);
+}
+
+void rseq_configure_cpu_pointer(void)
+{
+	sys_rseq_checked(SYS_RSEQ_SET_CPU_POINTER, 0,
+			(void*)&__rseq_current_cpu, 0, 0);
+	assert(rseq_current_cpu() != -1); /* always updated prior to return. */
+}
+
diff --git a/tools/testing/selftests/rseq/rseq.h b/tools/testing/selftests/rseq/rseq.h
new file mode 100644
index 0000000..91bb655
--- /dev/null
+++ b/tools/testing/selftests/rseq/rseq.h
@@ -0,0 +1,28 @@
+#ifndef RSEQ_TEST_H
+#define RSEQ_TEST_H
+
+#if defined(__i386__)
+#define RESTART_ADDR_REG ecx
+#elif defined(__x86_64__)
+#define RESTART_ADDR_REG r10
+#else
+#define RESTART_ADDR_REG unknown
+#endif
+
+#ifndef __ASSEMBLER__
+int sys_rseq(int op, int flags, void* val1, void* val2, void* val3);
+/* RSEQ provided thread-local current_cpu */
+
+void rseq_configure_cpu_pointer(void);
+
+void rseq_configure_region(void *rseq_text_start, void *rseq_text_end,
+			   void *rseq_restart_handler);
+
+
+extern __thread volatile const int __rseq_current_cpu;
+static inline int rseq_current_cpu(void) { return __rseq_current_cpu; }
+
+void run_tests();
+#endif
+
+#endif
