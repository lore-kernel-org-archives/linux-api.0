From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide
 self-tests
Date: Fri, 24 Nov 2017 14:15:43 +0000 (UTC)
Message-ID: <1492925582.21712.1511532943476.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-16-mathieu.desnoyers@efficios.com> <20171123085511.ohwuobf5v32vggho@hirez.programming.kicks-ass.net> <20171123085721.bzburngdsatgewjo@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171123085721.bzburngdsatgewjo-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 23, 2017, at 3:57 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Thu, Nov 23, 2017 at 09:55:11AM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 21, 2017 at 09:18:53AM -0500, Mathieu Desnoyers wrote:
>> > +static inline __attribute__((always_inline))
>> > +int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
>> > +		int cpu)
>> > +{
>> > +	__asm__ __volatile__ goto (
>> > +		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>> > +		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
>> 
>> > +		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
> 
>> > +		"cmpq %[v], %[expect]\n\t"
>> > +		"jnz 5f\n\t"
> 
> Also, I'm confused between the abort and cmpfail cases.
> 
> In would expect the cpu_id compare to also result in cmpfail, that is, I
> would only expect the kernel to result in abort.

Let's take the per-cpu spinlock as an example to explain why we need
the "compare fail" and "cpu_id compare fail" to return different
values.

Getting this lock involves doing:

cpu = rseq_cpu_start();
ret = rseq_cmpeqv_storev(&lock->c[cpu].v, 0, 1, cpu);

Now based on the "ret" value:

if ret == 0, it means that @v was indeed 0, and that rseq
executed the commit (stored 1).

if ret > 0, it means the comparison of @v against 0 failed,
which means the lock was already held. We therefore need to
postpone and retry later. A "try_lock" operation would return
that the lock is currently busy.

if ret < 0, then we have either been aborted by the kernel,
or the comparison of @cpu against cpu_id failed. If we think
about it, having @cpu != cpu_id will happen if we are migrated
before we enter the rseq critical section, which is pretty
similar to being aborted by the kernel within the critical
section. So I don't see any reason for making the branch target
of the cpu_id comparison anything else than the abort_ip. In
that situation, the caller needs to either re-try with an
updated @cpu value (except for multi-part algorithms e.g.
reserve+commit, which don't allow changing the @cpu number on
commit), or use cpu_opv to perform the operation.

Note that another cause why the @cpu == cpu_id test may fail is
if rseq is not registered for the current thread. Again, just
branching to the abort_ip and letting the caller fallback to
cpu_opv solves this.

> 
>> > +		/* final store */
>> > +		"movq %[newv], %[v]\n\t"
>> > +		"2:\n\t"
>> > +		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
>> > +		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
>> > +		: /* gcc asm goto does not allow outputs */
>> > +		: [cpu_id]"r"(cpu),
>> > +		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
>> > +		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
>> > +		  [v]"m"(*v),
>> > +		  [expect]"r"(expect),
>> > +		  [newv]"r"(newv)
>> > +		: "memory", "cc", "rax"
>> > +		: abort, cmpfail
>> > +	);
>> > +	return 0;
>> > +abort:
>> > +	return -1;
> 
> Which then would suggest this be -EINTR or something like that.

I'm not so sure returning kernel error codes is the expected
practice for user-space libraries.

Thoughts ?

Thanks!

Mathieu


> 
>> > +cmpfail:
>> > +	return 1;
> > > +}

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
