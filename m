From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 4/4] Restartable sequences: Add self-tests for PPC
Date: Thu, 28 Jul 2016 13:42:02 +0000 (UTC)
Message-ID: <686023493.738.1469713322407.JavaMail.zimbra@efficios.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com> <20160727150517.26983-1-boqun.feng@gmail.com> <20160727150517.26983-4-boqun.feng@gmail.com> <389340521.403.1469674785661.JavaMail.zimbra@efficios.com> <20160728044304.GC24740@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160728044304.GC24740-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 28, 2016, at 12:43 AM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Thu, Jul 28, 2016 at 02:59:45AM +0000, Mathieu Desnoyers wrote:
>> ----- On Jul 27, 2016, at 11:05 AM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> 
>> > As rseq syscall is enabled on PPC, implement the self-tests on PPC to
>> > verify the implementation of the syscall.
>> > 
>> > Please note we only support 32bit userspace on BE kernel.
>> > 
>> > Signed-off-by: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>> > tools/testing/selftests/rseq/param_test.c |  14 ++++
>> > tools/testing/selftests/rseq/rseq.h       | 120 ++++++++++++++++++++++++++++++
>> > 2 files changed, 134 insertions(+)
>> > 
>> > diff --git a/tools/testing/selftests/rseq/param_test.c
>> > b/tools/testing/selftests/rseq/param_test.c
>> > index db25e0a818e5..e2cb1b165f81 100644
>> > --- a/tools/testing/selftests/rseq/param_test.c
>> > +++ b/tools/testing/selftests/rseq/param_test.c
>> > @@ -75,6 +75,20 @@ static __thread unsigned int yield_mod_cnt, nr_retry;
>> > 	"bne 222b\n\t" \
>> > 	"333:\n\t"
>> > 
>> > +#elif __PPC__
>> > +#define INJECT_ASM_REG	"r18"
>> > +
>> > +#define RSEQ_INJECT_CLOBBER \
>> > +	, INJECT_ASM_REG
>> > +
>> > +#define RSEQ_INJECT_ASM(n) \
>> > +	"lwz %%" INJECT_ASM_REG ", %[loop_cnt_" #n "]\n\t" \
>> > +	"cmpwi %%" INJECT_ASM_REG ", 0\n\t" \
>> > +	"beq 333f\n\t" \
>> > +	"222:\n\t" \
>> > +	"subic. %%" INJECT_ASM_REG ", %%" INJECT_ASM_REG ", 1\n\t" \
>> > +	"bne 222b\n\t" \
>> > +	"333:\n\t"
>> > #else
>> > #error unsupported target
>> > #endif
>> > diff --git a/tools/testing/selftests/rseq/rseq.h
>> > b/tools/testing/selftests/rseq/rseq.h
>> > index 791e14cf42ae..dea0bea52566 100644
>> > --- a/tools/testing/selftests/rseq/rseq.h
>> > +++ b/tools/testing/selftests/rseq/rseq.h
>> > @@ -138,6 +138,35 @@ do {									\
>> > #define has_fast_acquire_release()	0
>> > #define has_single_copy_load_64()	1
>> > 
>> > +#elif __PPC__
>> > +#define smp_mb()	__asm__ __volatile__ ("sync" : : : "memory")
>> > +#define smp_lwsync()	__asm__ __volatile__ ("lwsync" : : : "memory")
>> > +#define smp_rmb()	smp_lwsync()
>> > +#define smp_wmb()	smp_lwsync()
>> > +
>> > +#define smp_load_acquire(p)						\
>> > +__extension__ ({							\
>> > +	__typeof(*p) ____p1 = READ_ONCE(*p);				\
>> > +	smp_lwsync();							\
>> > +	____p1;								\
>> > +})
>> > +
>> > +#define smp_acquire__after_ctrl_dep()	smp_lwsync()
>> > +
>> > +#define smp_store_release(p, v)						\
>> > +do {									\
>> > +	smp_lwsync();							\
>> > +	WRITE_ONCE(*p, v);						\
>> > +} while (0)
>> > +
>> > +#define has_fast_acquire_release()	1
>> 
>> Can you check if defining has_fast_acquire_release() to 0 speeds up
>> performance significantly ? It turns the smp_lwsync() into a
>> compiler barrier() on the smp_load_acquire() side (fast-path), and
>> turn the smp_lwsync() into a membarrier system call instead of the
>> matching smp_store_release() (slow path).
>> 
> 
> Good point. Here are the numbers:
> 
> Power8 PSeries KVM Guest(64 VCPUs, the host has 16 cores, 128 hardware
> threads):
> 
>                                 Counter increment speed (ns/increment)
>                              1 thread   2 threads   4 threads   8 threads   16 threads   32 threads
> global increment (baseline)     6.5          N/A         N/A         N/A
> N/A           N/A
> percpu rseq increment           7.0          7.0         7.2         7.2
> 9.3          14.5
> percpu rseq spinlock           18.5         18.5        18.6        18.8
> 25.5          52.7
> 
> So looks like defining has_fast_acquire_release() to 0 could benefit the
> cases with more threads in current benchmark. I will send a updated
> patch doing this.

Good to know the lwsync barrier overhead kicks in at that level of
workload on Power8.

> 
> And as discussed in IRC, I will also remove jump from rseq_finish()
> fast-path in powerpc asm in the updated patch as you did for x86 and
> ARM.

Allright, thanks!

Mathieu

> 
> Regards,
> Boqun
> 
> 
>> Thanks,
>> 
>> Mathieu
>> 
>> > +
>> > +# if __PPC64__
>> > +# define has_single_copy_load_64()	1
>> > +# else
>> > +# define has_single_copy_load_64()	0
>> > +# endif
>> > +
>> > #else
>> > #error unsupported target
>> > #endif
>> > @@ -404,6 +433,97 @@ bool rseq_finish(struct rseq_lock *rlock,
>> > 			: succeed
>> > 		);
>> > 	}
>> > +#elif __PPC64__
>> > +	{
>> > +		/*
>> > +		 * The __rseq_table section can be used by debuggers to better
>> > +		 * handle single-stepping through the restartable critical
>> > +		 * sections.
>> > +		 */
>> > +		__asm__ __volatile__ goto (
>> > +			".pushsection __rseq_table, \"aw\"\n\t"
>> > +			".balign 8\n\t"
>> > +			"4:\n\t"
>> > +			".quad 1f, 2f, 3f\n\t"
>> > +			".popsection\n\t"
>> > +			"1:\n\t"
>> > +			RSEQ_INJECT_ASM(1)
>> > +			"lis %%r17, (4b)@highest\n\t"
>> > +			"ori %%r17, %%r17, (4b)@higher\n\t"
>> > +			"rldicr %%r17, %%r17, 32, 31\n\t"
>> > +			"oris %%r17, %%r17, (4b)@h\n\t"
>> > +			"ori %%r17, %%r17, (4b)@l\n\t"
>> > +			"std %%r17, 0(%[rseq_cs])\n\t"
>> > +			RSEQ_INJECT_ASM(2)
>> > +			"lwz %%r17, %[current_event_counter]\n\t"
>> > +			"li %%r16, 0\n\t"
>> > +			"cmpw cr7, %[start_event_counter], %%r17\n\t"
>> > +			"bne cr7, 3f\n\t"
>> > +			RSEQ_INJECT_ASM(3)
>> > +			"std %[to_write], 0(%[target])\n\t"
>> > +			"2:\n\t"
>> > +			RSEQ_INJECT_ASM(4)
>> > +			"std %%r16, 0(%[rseq_cs])\n\t"
>> > +			"b %l[succeed]\n\t"
>> > +			"3:\n\t"
>> > +			"li %%r16, 0\n\t"
>> > +			"std %%r16, 0(%[rseq_cs])\n\t"
>> > +			: /* no outputs */
>> > +			: [start_event_counter]"r"(start_value.event_counter),
>> > +			  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
>> > +			  [to_write]"r"(to_write),
>> > +			  [target]"b"(p),
>> > +			  [rseq_cs]"b"(&start_value.rseqp->abi.rseq_cs)
>> > +			  RSEQ_INJECT_INPUT
>> > +			: "r16", "r17", "memory", "cc"
>> > +			  RSEQ_INJECT_CLOBBER
>> > +			: succeed
>> > +		);
>> > +	}
>> > +#elif __PPC__
>> > +	{
>> > +		/*
>> > +		 * The __rseq_table section can be used by debuggers to better
>> > +		 * handle single-stepping through the restartable critical
>> > +		 * sections.
>> > +		 */
>> > +		__asm__ __volatile__ goto (
>> > +			".pushsection __rseq_table, \"aw\"\n\t"
>> > +			".balign 8\n\t"
>> > +			"4:\n\t"
>> > +			".long 0x0, 1f, 0x0, 2f, 0x0, 3f\n\t" /* 32 bit only supported on BE */
>> > +			".popsection\n\t"
>> > +			"1:\n\t"
>> > +			RSEQ_INJECT_ASM(1)
>> > +			"lis %%r17, (4b)@ha\n\t"
>> > +			"addi %%r17, %%r17, (4b)@l\n\t"
>> > +			"stw %%r17, 0(%[rseq_cs])\n\t"
>> > +			RSEQ_INJECT_ASM(2)
>> > +			"lwz %%r17, %[current_event_counter]\n\t"
>> > +			"li %%r16, 0\n\t"
>> > +			"cmpw cr7, %[start_event_counter], %%r17\n\t"
>> > +			"bne cr7, 3f\n\t"
>> > +			RSEQ_INJECT_ASM(3)
>> > +			"stw %[to_write], 0(%[target])\n\t"
>> > +			"2:\n\t"
>> > +			RSEQ_INJECT_ASM(4)
>> > +			"stw %%r16, 0(%[rseq_cs])\n\t"
>> > +			"b %l[succeed]\n\t"
>> > +			"3:\n\t"
>> > +			"li %%r16, 0\n\t"
>> > +			"stw %%r16, 0(%[rseq_cs])\n\t"
>> > +			: /* no outputs */
>> > +			: [start_event_counter]"r"(start_value.event_counter),
>> > +			  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
>> > +			  [to_write]"r"(to_write),
>> > +			  [target]"b"(p),
>> > +			  [rseq_cs]"b"(&start_value.rseqp->abi.rseq_cs)
>> > +			  RSEQ_INJECT_INPUT
>> > +			: "r16", "r17", "memory", "cc"
>> > +			  RSEQ_INJECT_CLOBBER
>> > +			: succeed
>> > +		);
>> > +	}
>> > #else
>> > #error unsupported target
>> > #endif
>> > --
>> > 2.9.0
>> 
>> --
>> Mathieu Desnoyers
>> EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
