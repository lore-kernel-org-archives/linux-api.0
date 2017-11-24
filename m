From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide
 self-tests
Date: Fri, 24 Nov 2017 13:55:47 +0000 (UTC)
Message-ID: <1080135963.21671.1511531747949.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-16-mathieu.desnoyers@efficios.com> <20171123085511.ohwuobf5v32vggho@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171123085511.ohwuobf5v32vggho-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 23, 2017, at 3:55 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Nov 21, 2017 at 09:18:53AM -0500, Mathieu Desnoyers wrote:
>> +int percpu_list_push(struct percpu_list *list, struct percpu_list_node *node)
>> +{
>> +	intptr_t *targetptr, newval, expect;
>> +	int cpu, ret;
>> +
>> +	/* Try fast path. */
>> +	cpu = rseq_cpu_start();
> 
>> +	/* Load list->c[cpu].head with single-copy atomicity. */
>> +	expect = (intptr_t)READ_ONCE(list->c[cpu].head);
>> +	newval = (intptr_t)node;
>> +	targetptr = (intptr_t *)&list->c[cpu].head;
>> +	node->next = (struct percpu_list_node *)expect;
> 
>> +	ret = rseq_cmpeqv_storev(targetptr, expect, newval, cpu);
> 
>> +	if (likely(!ret))
>> +		return cpu;
> 
>> +	return cpu;
>> +}
> 
>> +static inline __attribute__((always_inline))
>> +int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
>> +		int cpu)
>> +{
>> +	__asm__ __volatile__ goto (
>> +		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>> +		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
> 
>> +		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
> 
> So the actual C part of the RSEQ is subject to an ABA, right? We can get
> migrated to another CPU and back again without then failing here.

Yes, that's correct. All algorithms preparing something in C and
then using a compare-and-other-stuff sequence need to ensure they
do not have ABA situations. For instance, a list push does not care
if the list head is reclaimed and re-inserted concurrently, because
none of the preparation steps in C involve the head next pointer.

> 
> It used to be that this was caught by the sequence count, but that is
> now gone.

The sequence count introduced other weirdness: although it would catch
those migration cases, it is a sequence read-lock, which means
the C code "protected" by this sequence read-lock needed to be
extremely careful about not accessing reclaimed memory.
The sequence lock ensures consistency of the data when they comparison
matches, but it does not protect against other side-effects.

So removing this sequence lock is actually a good thing: it removes
any expectation that users may have about that sequence counter being
anything stronger than a read seqlock.

> 
> The thing that makes it work is the compare against @v:
> 
>> +		"cmpq %[v], %[expect]\n\t"
>> +		"jnz 5f\n\t"
> 
> That then ensures things are still as we observed them before (although
> this itself is also subject to ABA).

Yes.

> 
> This means all RSEQ primitives that have a C part must have a cmp-and-
> form, but I suppose that was already pretty much the case anyway. I just
> don't remember seeing that spelled out anywhere. Then again, I've not
> yet read that manpage.

Yes, pretty much. The only primitives that don't have the compare are
things like "rseq_addv()", which does not have much in the C part
(it's just incrementing a counter).

I did not state anything like "typical rseq c.s. do a compare and other stuff"
in rseq(2), given that the role of this man page, AFAIU, is to explain
how to interact with the kernel system call, and not really a document
about user-space implementation guide lines.

But let me know if I should expand it with a user-space sequence implementation
guide lines, which would include notes about being careful about ABA. I'm
not sure it belongs there though.

Thanks!

Mathieu

> 
>> +		/* final store */
>> +		"movq %[newv], %[v]\n\t"
>> +		"2:\n\t"
>> +		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
>> +		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
>> +		: /* gcc asm goto does not allow outputs */
>> +		: [cpu_id]"r"(cpu),
>> +		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
>> +		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
>> +		  [v]"m"(*v),
>> +		  [expect]"r"(expect),
>> +		  [newv]"r"(newv)
>> +		: "memory", "cc", "rax"
>> +		: abort, cmpfail
>> +	);
>> +	return 0;
>> +abort:
>> +	return -1;
>> +cmpfail:
>> +	return 1;
> > +}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
