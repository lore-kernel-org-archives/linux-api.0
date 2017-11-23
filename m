From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide self-tests
Date: Thu, 23 Nov 2017 09:55:11 +0100
Message-ID: <20171123085511.ohwuobf5v32vggho@hirez.programming.kicks-ass.net>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121141900.18471-16-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171121141900.18471-16-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 21, 2017 at 09:18:53AM -0500, Mathieu Desnoyers wrote:
> +int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
> +{
> +	intptr_t *targetptr, newval, expect;
> +	int cpu, ret;
> +
> +	/* Try fast path. */
> +	cpu = rseq_cpu_start();

> +	/* Load list->c[cpu].head with single-copy atomicity. */
> +	expect = (intptr_t)READ_ONCE(list->c[cpu].head);
> +	newval = (intptr_t)node;
> +	targetptr = (intptr_t *)&list->c[cpu].head;
> +	node->next = (struct percpu_list_node *)expect;

> +	ret = rseq_cmpeqv_storev(targetptr, expect, newval, cpu);

> +	if (likely(!ret))
> +		return cpu;

> +	return cpu;
> +}

> +static inline __attribute__((always_inline))
> +int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
> +		int cpu)
> +{
> +	__asm__ __volatile__ goto (
> +		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
> +		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)

> +		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)

So the actual C part of the RSEQ is subject to an ABA, right? We can get
migrated to another CPU and back again without then failing here.

It used to be that this was caught by the sequence count, but that is
now gone.

The thing that makes it work is the compare against @v:

> +		"cmpq %[v], %[expect]\n\t"
> +		"jnz 5f\n\t"

That then ensures things are still as we observed them before (although
this itself is also subject to ABA).

This means all RSEQ primitives that have a C part must have a cmp-and-
form, but I suppose that was already pretty much the case anyway. I just
don't remember seeing that spelled out anywhere. Then again, I've not
yet read that manpage.

> +		/* final store */
> +		"movq %[newv], %[v]\n\t"
> +		"2:\n\t"
> +		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
> +		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
> +		: /* gcc asm goto does not allow outputs */
> +		: [cpu_id]"r"(cpu),
> +		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
> +		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
> +		  [v]"m"(*v),
> +		  [expect]"r"(expect),
> +		  [newv]"r"(newv)
> +		: "memory", "cc", "rax"
> +		: abort, cmpfail
> +	);
> +	return 0;
> +abort:
> +	return -1;
> +cmpfail:
> +	return 1;
> +}
