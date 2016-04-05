From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/3] restartable sequences: basic self-tests
Date: Tue, 5 Apr 2016 20:33:27 +0000 (UTC)
Message-ID: <1276514010.46061.1459888406999.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <20151027235716.16059.47610.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027235716.16059.47610.stgit-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Oct 27, 2015, at 7:57 PM, Paul Turner commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: pjt <pjt-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>

Hi Paul,

I'm worried about a possible ABA in your percpu_list_pop() implementation
below.

[...]

> seq_percpu_cmpxchgcheck(int cpu, intptr_t *p, intptr_t old, intptr_t new,
> +			     intptr_t *check_ptr, intptr_t check_val)
> +{
> +	struct rseq_state start;
> +
> +	while (1) {
> +		start = rseq_start();
> +		if (rseq_current_cpu() != cpu) return rseq_current_cpu();
> +		/*
> +		 * Note that we'd want the ultimate implementation of this to
> +		 * be open coded (similar to rseq_finish) so that we can
> +		 * guarantee *check is not dereferenced when old does not
> +		 * match.  This could also be facilitated with a generic
> +		 * rseq_read_if_valid(...) helper.
> +		 */
> +		if (*p != old || *check_ptr != check_val)
> +			return -1;
> +		if (rseq_finish(p, new, start)) return cpu;
> +	}
> +}
> +

[...]

> +struct percpu_list_node {
> +	intptr_t data;
> +	struct percpu_list_node *next;
> +};
> +
> +struct percpu_list {
> +	struct percpu_list_node *heads[CPU_SETSIZE];
> +};
> +
> +int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
> +{
> +	int cpu;
> +
> +	do {
> +		cpu = rseq_current_cpu();
> +		node->next = list->heads[cpu];
> +	} while (cpu != rseq_percpu_cmpxchg(cpu,
> +			(intptr_t *)&list->heads[cpu], (intptr_t)node->next,
> +			(intptr_t)node));
> +
> +	return cpu;
> +}
> +
> +struct percpu_list_node *percpu_list_pop(struct percpu_list *list)
> +{
> +	int cpu;
> +	struct percpu_list_node *head, *next;
> +
> +	do {
> +		cpu = rseq_current_cpu();
> +		head = list->heads[cpu];
> +		/*
> +		 * Unlike a traditional lock-less linked list; the availability
> +		 * of a cmpxchg-check primitive allows us to implement pop
> +		 * without concerns over ABA-type races.
> +		 */

The comment above clearly states that "rseq_percpu_cmpxchgcheck"
prevents ABA, and it indeed does, to some extend. My understanding
is that it prevents ABA from happening between rseq_start() and
rseq_finish().

The problem I see is with the percpu_list_pop() implementation. It
fetches list->heads[cpu] outside of the rseq critical section. I'm
concerned that a long preemption happening between loading the list
head and rseq_start() could cause an ABA that won't be detected by
rseq_finish().

The code seems to assume that comparing the CPU number, thus ensuring that
the rseq_current_cpu() read outside of the rseq critical section (just
before loading the list head) is the same CPU number seen in the
cmpxchgcheck is sufficient to ensure there is no ABA. However, this
check does not detect preemption nor signal delivery before rseq_start().
Moreover it does not cover cases where a thread would be migrated to
a remote CPU, and then migrated back to the original CPU.

A problematic execution sequence would be

* Exhibit A: ABA (all threads running on same CPU):

Initial state: the list has a single entry "object Z"

       Thread A                       Thread B
- percpu_list_pop()
  - cpu = rseq_current_cpu();
  - head = list->heads[cpu];
    (head is a pointer to object Z)
  - next = head->next;
  (preempted)
                                      (scheduled in)
                                      - percpu_list_pop()
                                        - cpu = rseq_current_cpu();
                                        - head = list->heads[cpu];
                                          (head is a pointer to object Z)
                                        - rseq_percpu_cmpxchgcheck succeeds
                                      - percpu_list_push of a new object Y
                                      - percpu_list_push of a re-used object Z
                                        (its next pointer now points to object Y
                                        rather than end of list)
                                      (preempted)
  (scheduled in)
  - rseq_percpu_cmpxchgcheck succeeds,
    setting a wrong value into the list
    head: it will store an end of list,
    thus skipping over object Y.

percpu_list_push() seems to show a similar ABA possibility
if preempted between reading the list head and the start of the
rseq critical section. In this situation, rseq_finish() would
not see preemption or signals delivered before the rseq_start().

In order to fix those ABA issues, my understanding is that we
should surround the entire do/while loop content of
percpu_list_push/pop by an rseq critical section, including
reading the list head.


Another issue we run into is a use-after-free if we are preempted
before reading head->hext.

* Exhibit B: Use after free (all threads running on same CPU):

Initial state: the list has a single entry "object Z"

       Thread A                       Thread B
- percpu_list_pop()
  - cpu = rseq_current_cpu();
  - head = list->heads[cpu];
    (head is a pointer to object Z)
  (preempted)
                                      (scheduled in)
                                      - percpu_list_pop()
                                        - cpu = rseq_current_cpu();
                                        - head = list->heads[cpu];
                                          (head is a pointer to object Z)
                                        - rseq_percpu_cmpxchgcheck succeeds
                                      - free object Z
                                      (preempted)
  (scheduled in)
  - reading free'd memory by trying
    to dereference:
    next = head->next;

Are complementary mechanisms expected to deal with the list element
life-time to prevent use-after-free, e.g. RCU ?

Or am I missing something ?

Thanks,

Mathieu

> +		if (!head) return 0;
> +		next = head->next;
> +	} while (cpu != rseq_percpu_cmpxchgcheck(cpu,
> +		(intptr_t *)&list->heads[cpu], (intptr_t)head, (intptr_t)next,
> +		(intptr_t *)&head->next, (intptr_t)next));
> +
> +	return head;
> +}
> +
> +
> +void *test_percpu_list_thread(void *arg)
> +{
> +	int i;
> +	struct percpu_list *list = (struct percpu_list *)arg;
> +
> +	rseq_init_current_thread();
> +	for (i = 0; i < 100000; i++) {
> +		struct percpu_list_node *node = percpu_list_pop(list);
> +		sched_yield();  /* encourage shuffling */
> +		if (node) percpu_list_push(list, node);
> +	}
> +
> +	return 0;
> +}
> +

[...]

> diff --git a/tools/testing/selftests/rseq/rseq.h
> b/tools/testing/selftests/rseq/rseq.h
> new file mode 100644
> index 0000000..d16e02d
> --- /dev/null
> +++ b/tools/testing/selftests/rseq/rseq.h
> @@ -0,0 +1,109 @@
> +#ifndef RSEQ_H
> +#define RSEQ_H
> +
> +#include <stdint.h>
> +
> +struct rseq_state {
> +	union {
> +		/*
> +		 * Updated by the kernel.  The time between two rseq state
> +		 * objects can be considered non-interrupted if-and-only-if
> +		 * both cpu and event_counter match.
> +		 *
> +		 * Explicitly: the kernel is allowed to maintain a
> +		 * per-cpu event_counter.
> +		 */
> +		struct {
> +			int cpu;
> +			int event_counter;
> +		};
> +		uint64_t storage;
> +	};
> +	void* post_commit_instr;
> +};
> +
> +extern __thread volatile struct rseq_state __rseq_state;
> +
> +int sys_rseq(int flags,
> +	     volatile uint64_t* event_and_cpu,
> +	     volatile void* post_commit_instr);
> +
> +#define barrier() __asm__ __volatile__("": : :"memory")
> +
> +static inline struct rseq_state rseq_start()
> +{
> +	struct rseq_state result = __rseq_state;
> +	/*
> +	 * We need to ensure that the compiler does not re-order the loads of
> +	 * any protected values before we read the current state.
> +	 */
> +	barrier();
> +	return result;
> +}
> +
> +static inline int rseq_cpu_at_start(struct rseq_state start_value)
> +{
> +	return start_value.cpu;
> +}
> +
> +static inline int rseq_current_cpu(void)
> +{
> +	return __rseq_state.cpu;
> +}
> +
> +static inline int rseq_finish(intptr_t *p, intptr_t to_write,
> +			      struct rseq_state start_value)
> +{
> +#ifdef __x86_64__
> +	__asm__ __volatile__ goto (
> +			"movq $%l[failed], %%rcx\n"
> +			"movq $1f, %[commit_instr]\n"
> +			"cmpq %[start_value], %[current_value]\n"
> +			"jnz %l[failed]\n"
> +			"movq %[to_write], (%[target])\n"
> +			"1: movq $0, %[commit_instr]\n"
> +	  : /* no outputs */
> +	  : [start_value]"d"(start_value.storage),
> +	    [current_value]"m"(__rseq_state),
> +	    [to_write]"r"(to_write),
> +	    [target]"r"(p),
> +	    [commit_instr]"m"(__rseq_state.post_commit_instr)
> +	  : "rcx", "memory"
> +	  : failed
> +	);
> +#elif __i386__
> +	__asm__ __volatile__ goto (
> +			"movl $%l[failed], %%ecx\n"
> +			"movl $1f, %[post_commit_instr]\n"
> +			"cmp %[start_cpu], %[current_cpu]\n"
> +			"jnz %l[failed]\n"
> +			"cmp %[start_event], %[current_event]\n"
> +			"jnz %l[failed]\n"
> +			"movl %[to_write], (%[target])\n"
> +			"1: movl $0, %[post_commit_instr]\n"
> +	  : /* no outputs */
> +	  : [start_cpu]"a"(start_value.cpu),
> +	    [start_event]"d"(start_value.event_counter),
> +	    [current_cpu]"g"(__rseq_state.cpu),
> +	    [current_event]"g"(__rseq_state.event_counter),
> +	    [post_commit_instr]"g"(__rseq_state.post_commit_instr),
> +	    [to_write]"r"(to_write),
> +	    [target]"r"(p)
> +	  : "ecx", "memory"
> +	  : failed
> +	);
> +#else
> +#error unsupported target
> +#endif
> +	return 1;
> +failed:
> +	return 0;
> +}
> +
> +/*
> + * Initialize rseq for the current thread.  Must be called once by any thread
> + * which uses restartable_sequences.
> + */
> +void rseq_init_current_thread(void);
> +
> +#endif  /* RSEQ_H_ */

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
