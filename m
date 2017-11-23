From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide
 self-tests
Date: Thu, 23 Nov 2017 22:53:28 +0000 (UTC)
Message-ID: <1128913311.21369.1511477608469.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-16-mathieu.desnoyers@efficios.com> <20171122214813.GK3165@worktop.lehotels.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122214813.GK3165-IIpfhp3q70x9+YH6RuovlLjjLBE8jN/0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 4:48 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Nov 21, 2017 at 09:18:53AM -0500, Mathieu Desnoyers wrote:
>> diff --git a/tools/testing/selftests/rseq/rseq-x86.h
>> b/tools/testing/selftests/rseq/rseq-x86.h
>> new file mode 100644
>> index 000000000000..63e81d6c61fa
>> --- /dev/null
>> +++ b/tools/testing/selftests/rseq/rseq-x86.h
>> @@ -0,0 +1,898 @@
>> +/*
>> + * rseq-x86.h
>> + *
>> + * (C) Copyright 2016 - Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a copy
>> + * of this software and associated documentation files (the "Software"), to
>> deal
>> + * in the Software without restriction, including without limitation the rights
>> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>> + * copies of the Software, and to permit persons to whom the Software is
>> + * furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>> FROM,
>> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>> THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <stdint.h>
>> +
>> +#define RSEQ_SIG	0x53053053
>> +
>> +#ifdef __x86_64__
>> +
>> +#define rseq_smp_mb()	__asm__ __volatile__ ("mfence" : : : "memory")
> 
> See commit:
> 
>  450cbdd0125c ("locking/x86: Use LOCK ADD for smp_mb() instead of MFENCE")

OK, will use:

#define rseq_smp_mb()   \
        __asm__ __volatile__ ("lock; addl $0,-128(%%rsp)" ::: "memory", "cc")

as done in tools/virtio/ringtest/main.h

> 
>> +#define rseq_smp_rmb()	barrier()
>> +#define rseq_smp_wmb()	barrier()
>> +
>> +#define rseq_smp_load_acquire(p)					\
>> +__extension__ ({							\
>> +	__typeof(*p) ____p1 = RSEQ_READ_ONCE(*p);			\
>> +	barrier();							\
>> +	____p1;								\
>> +})
>> +
>> +#define rseq_smp_acquire__after_ctrl_dep()	rseq_smp_rmb()
>> +
>> +#define rseq_smp_store_release(p, v)					\
>> +do {									\
>> +	barrier();							\
>> +	RSEQ_WRITE_ONCE(*p, v);						\
>> +} while (0)
>> +
>> +#define RSEQ_ASM_DEFINE_TABLE(label, section, version, flags,		\
>> +			start_ip, post_commit_offset, abort_ip)		\
>> +		".pushsection " __rseq_str(section) ", \"aw\"\n\t"	\
>> +		".balign 32\n\t"					\
>> +		__rseq_str(label) ":\n\t"				\
>> +		".long " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
>> +		".quad " __rseq_str(start_ip) ", " __rseq_str(post_commit_offset) ", "
>> __rseq_str(abort_ip) "\n\t" \
>> +		".popsection\n\t"
> 
> OK, so this creates table entry, but why is @section an argument, AFAICT
> its _always_ the same thing, no?

I agree that section names don't need to be passed as arguments, since it
is not useful information to understand the flow of asm using those
macros. Will remove.

> 
>> +#define RSEQ_ASM_STORE_RSEQ_CS(label, cs_label, rseq_cs)		\
>> +		RSEQ_INJECT_ASM(1)					\
>> +		"leaq " __rseq_str(cs_label) "(%%rip), %%rax\n\t"	\
>> +		"movq %%rax, %[" __rseq_str(rseq_cs) "]\n\t"		\
>> +		__rseq_str(label) ":\n\t"
> 
> And this sets the TLS variable to point to the table entry from the
> previous macro, no? But again @rseq_cs seems to always be the very same,
> why is that an argument?

I don't want to hide anything within macros that would prevent someone
looking that the overall assembly to understand the flow.

So all labels and references to named input operands, are passed as
arguments to those macros.

> 
>> +#define RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, label)		\
>> +		RSEQ_INJECT_ASM(2)					\
>> +		"cmpl %[" __rseq_str(cpu_id) "], %[" __rseq_str(current_cpu_id) "]\n\t" \
>> +		"jnz " __rseq_str(label) "\n\t"
> 
> more things that are always the same it seems..

See this as passing arguments to functions. It makes the overall
assembly using those macros easier to read.

> 
>> +#define RSEQ_ASM_DEFINE_ABORT(label, section, sig, teardown, abort_label) \
>> +		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
>> +		/* Disassembler-friendly signature: nopl <sig>(%rip). */\
>> +		".byte 0x0f, 0x1f, 0x05\n\t"				\
>> +		".long " __rseq_str(sig) "\n\t"			\
>> +		__rseq_str(label) ":\n\t"				\
>> +		teardown						\
>> +		"jmp %l[" __rseq_str(abort_label) "]\n\t"		\
>> +		".popsection\n\t"
> 
> @section and @sig seem to always be the same...

Good point for the @section, will move it into the macro because it is not
useful to understand the flow.

Same for @sig. Will move into the macro, given that it's not useful to
understand the flow.

> 
>> +#define RSEQ_ASM_DEFINE_CMPFAIL(label, section, teardown, cmpfail_label) \
>> +		".pushsection " __rseq_str(section) ", \"ax\"\n\t"	\
>> +		__rseq_str(label) ":\n\t"				\
>> +		teardown						\
>> +		"jmp %l[" __rseq_str(cmpfail_label) "]\n\t"		\
>> +		".popsection\n\t"
> 
> Somewhat failing to see the point of this macro, it seems to just
> obfuscate the normal failure path.

It's needed to hold the "teardown" code needed on error, for the
memcpy loops. You're right that I don't need it for all the other
cases, and I can directly jump to the cmpfail_label. Will do.

> 
>> +static inline __attribute__((always_inline))
>> +int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
>> +		int cpu)
> 
> I find this a very confusing name for what is essentially
> compare-and-exchange or compare-and-swap, no?

A compare-and-exchange will load the original value and return it.
With rseq, it appears that all we need is to compare a value, and
store the new value if the comparison succeeded. We seldom care
about returning the old value, so we might as well skip that load.
But then it's _not_ a cmpxchg, because it does not return the prior
value.


> 
>> +{
>> +	__asm__ __volatile__ goto (
>> +		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
> 
> So we set up the section, but unreadably so... reducing the number of
> arguments would help a lot.
> 
> Rename the current one to __RSEQ_ASM_DEFINE_TABLE() and then use:
> 
> #define RSEQ_ASM_DEFINE_TABLE(label, start_ip, post_commit_ip, abort_ip) \
>	__RSEQ_ASM_DEFINE_TABLE(label, __rseq_table, 0x0, 0x0, start_ip, \
>				(post_commit_ip - start_ip), abort_ip)
> 
> or something, such that we can write:
> 
>		RSEQ_ASM_DEFINE_TABLE(3, 1f, 2f, 4f) /* start, commit, abort */
> 

Good point, it removes @version, @flags, and the 2f-1f calculation from the
asm, which distract from the flow.


>> +		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
> 
> And here we open start the rseq by storing the table entry pointer into
> the TLS thingy.

I'll add a comment if that's what you're pointing to.

> 
>> +		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
>> +		"cmpq %[v], %[expect]\n\t"
>> +		"jnz 5f\n\t"
> 
>		"jnz %l[cmpfail]\n\t"
> 
> was too complicated?

Good point. It's a leftover from the prior iterations where I needed
to clear the rseq_cs field before exiting from the critical section.
Now that the kernel does it lazily, I don't need a "teardown" code
in those cases, and we can directly jump to the cmpfail label. Will
do.


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
> 
>		: [cpu_id]         "r" (cpu),
>		  [current_cpu_id] "m" (__rseq_abi.cpu_id),
>		  [rseq_cs]        "m" (__rseq_abi.rseq_cs),
>		  [v]              "m" (*v),
>		  [expect]         "r" (expect),
>		  [newv]           "r" (newv)
> 
> or something does read much better

done.

> 
>> +		: "memory", "cc", "rax"
>> +		: abort, cmpfail
>> +	);
>> +	return 0;
>> +abort:
>> +	return -1;
>> +cmpfail:
>> +	return 1;
>> +}
>> +
>> +static inline __attribute__((always_inline))
>> +int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
>> +		off_t voffp, intptr_t *load, int cpu)
> 
> so this thing does what now? It compares @v to @expectnot, when _not_
> matching it will store @voffp into @v and load something..?

Not quite. I'll add this comment:

/*
 * Compare @v against @expectnot. When it does _not_ match, load @v
 * into @load, and store the content of *@v + voffp into @v.
 */

> 
>> +{
>> +	__asm__ __volatile__ goto (
>> +		RSEQ_ASM_DEFINE_TABLE(3, __rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>> +		RSEQ_ASM_STORE_RSEQ_CS(1, 3b, rseq_cs)
>> +		RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, 4f)
>> +		"cmpq %[v], %[expectnot]\n\t"
>> +		"jz 5f\n\t"
> 
> So I would prefer "je" in this context, or rather:
> 
>		je %l[cmpfail]

ok

> 
>> +		"movq %[v], %%rax\n\t"
> 
> loads @v in A
> 
> But it could already have changed since the previous load from cmp, no?

No, given that it should only be touched by rseq or cpu_opv, which
don't allow concurrent accesses on the same per-cpu data.

> Would it not make sense to put this load before the cmp and use A
> instead?

Sure, I could do the load once, and compare against a register
instead. It's not needed for correctness, but seems cleaner
nevertheless. I'll need to use some other register than rax though,
because I don't want to clash with the RSEQ_INJECT_ASM() delay-injection
loops, which are using eax. Perhaps rbx then.

> 
>> +		"movq %%rax, %[load]\n\t"
> 
> stores A in @load
> 
>> +		"addq %[voffp], %%rax\n\t"
> 
> adds @off to A
> 
>> +		"movq (%%rax), %%rax\n\t"
> 
> loads (A) in A
> 
>> +		/* final store */
>> +		"movq %%rax, %[v]\n\t"
> 
> stores A in @v
> 
> 
> So the whole thing loads @v into @load, adds and offset, dereferences
> and adds that back in @v, provided @v doesn't match @expected.. whee.

Yes, exactly! ;)


> 
>> +		"2:\n\t"
>> +		RSEQ_ASM_DEFINE_ABORT(4, __rseq_failure, RSEQ_SIG, "", abort)
>> +		RSEQ_ASM_DEFINE_CMPFAIL(5, __rseq_failure, "", cmpfail)
>> +		: /* gcc asm goto does not allow outputs */
>> +		: [cpu_id]"r"(cpu),
>> +		  [current_cpu_id]"m"(__rseq_abi.cpu_id),
>> +		  [rseq_cs]"m"(__rseq_abi.rseq_cs),
>> +		  /* final store input */
>> +		  [v]"m"(*v),
>> +		  [expectnot]"r"(expectnot),
>> +		  [voffp]"er"(voffp),
>> +		  [load]"m"(*load)
>> +		: "memory", "cc", "rax"
>> +		: abort, cmpfail
>> +	);
>> +	return 0;
>> +abort:
>> +	return -1;
>> +cmpfail:
>> +	return 1;
>> +}
> 
>> +#elif __i386__
>> +
>> +/*
>> + * Support older 32-bit architectures that do not implement fence
>> + * instructions.
>> + */
>> +#define rseq_smp_mb()	\
>> +	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
>> +#define rseq_smp_rmb()	\
>> +	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
>> +#define rseq_smp_wmb()	\
>> +	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory")
> 
> Oh shiny, you're supporting that OOSTORE and PPRO_FENCE nonsense?

Well, what's the point in supporting only a subset of the x86 architecture ? ;)

> 
> Going by commit:
> 
>  09df7c4c8097 ("x86: Remove CONFIG_X86_OOSTORE")
> 
> That smp_wmb() one was an 'optimization' (forced store buffer flush) but
> not a correctness thing. And we dropped that stuff from the kernel a
> _long_ time ago.

Perhaps from a kernel code perspective it's not a correctness thing, but
this is a correctness issue for user-space code.

I have the following comments in liburcu near the x86-32 barriers:

 * We leave smp_rmb/smp_wmb as full barriers for processors that do not have
 * fence instructions.
 *
 * An empty cmm_smp_rmb() may not be enough on old PentiumPro multiprocessor
 * systems, due to an erratum.  The Linux kernel says that "Even distro
 * kernels should think twice before enabling this", but for now let's
 * be conservative and leave the full barrier on 32-bit processors.  Also,
 * IDT WinChip supports weak store ordering, and the kernel may enable it
 * under our feet; cmm_smp_wmb() ceases to be a nop for these processors.

So it looks like from a user-space perspective, having the smp_wmb() would
be a correctness issue for older kernels on IDT WinChip processors.

Now you could argue that the recent kernel that will implement the "rseq"
system call will _never_ enable this IDT WinChip OOSTORE stuff. So we would
end up relying on success of the rseq cpu_id field comparison to ensure
rseq is indeed available, and in those cases the OOSTORE-aware smp_wmb is not
needed on x86-32.

Am I understanding this correctly ?

In that case, we should really document that those rseq_smp_wmb() are only
valid when running on kernels that provide the rseq system call.

> Ideally we'd kill that PPRO_FENCE crap too.

AFAIU, this one is part of the PPRO architecture, not really enabled explicitly
by the kernel, right ? I'm not sure what we can do about this other than
politely asking everyone to throw away these old pieces of hardware... ;)

Thanks for the review!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
