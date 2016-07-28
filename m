From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC 4/4] Restartable sequences: Add self-tests for PPC
Date: Thu, 28 Jul 2016 02:59:45 +0000 (UTC)
Message-ID: <389340521.403.1469674785661.JavaMail.zimbra@efficios.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com> <20160727150517.26983-1-boqun.feng@gmail.com> <20160727150517.26983-4-boqun.feng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160727150517.26983-4-boqun.feng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 27, 2016, at 11:05 AM, Boqun Feng boqun.feng@gmail.com wrote:

> As rseq syscall is enabled on PPC, implement the self-tests on PPC to
> verify the implementation of the syscall.
> 
> Please note we only support 32bit userspace on BE kernel.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
> tools/testing/selftests/rseq/param_test.c |  14 ++++
> tools/testing/selftests/rseq/rseq.h       | 120 ++++++++++++++++++++++++++++++
> 2 files changed, 134 insertions(+)
> 
> diff --git a/tools/testing/selftests/rseq/param_test.c
> b/tools/testing/selftests/rseq/param_test.c
> index db25e0a818e5..e2cb1b165f81 100644
> --- a/tools/testing/selftests/rseq/param_test.c
> +++ b/tools/testing/selftests/rseq/param_test.c
> @@ -75,6 +75,20 @@ static __thread unsigned int yield_mod_cnt, nr_retry;
> 	"bne 222b\n\t" \
> 	"333:\n\t"
> 
> +#elif __PPC__
> +#define INJECT_ASM_REG	"r18"
> +
> +#define RSEQ_INJECT_CLOBBER \
> +	, INJECT_ASM_REG
> +
> +#define RSEQ_INJECT_ASM(n) \
> +	"lwz %%" INJECT_ASM_REG ", %[loop_cnt_" #n "]\n\t" \
> +	"cmpwi %%" INJECT_ASM_REG ", 0\n\t" \
> +	"beq 333f\n\t" \
> +	"222:\n\t" \
> +	"subic. %%" INJECT_ASM_REG ", %%" INJECT_ASM_REG ", 1\n\t" \
> +	"bne 222b\n\t" \
> +	"333:\n\t"
> #else
> #error unsupported target
> #endif
> diff --git a/tools/testing/selftests/rseq/rseq.h
> b/tools/testing/selftests/rseq/rseq.h
> index 791e14cf42ae..dea0bea52566 100644
> --- a/tools/testing/selftests/rseq/rseq.h
> +++ b/tools/testing/selftests/rseq/rseq.h
> @@ -138,6 +138,35 @@ do {									\
> #define has_fast_acquire_release()	0
> #define has_single_copy_load_64()	1
> 
> +#elif __PPC__
> +#define smp_mb()	__asm__ __volatile__ ("sync" : : : "memory")
> +#define smp_lwsync()	__asm__ __volatile__ ("lwsync" : : : "memory")
> +#define smp_rmb()	smp_lwsync()
> +#define smp_wmb()	smp_lwsync()
> +
> +#define smp_load_acquire(p)						\
> +__extension__ ({							\
> +	__typeof(*p) ____p1 = READ_ONCE(*p);				\
> +	smp_lwsync();							\
> +	____p1;								\
> +})
> +
> +#define smp_acquire__after_ctrl_dep()	smp_lwsync()
> +
> +#define smp_store_release(p, v)						\
> +do {									\
> +	smp_lwsync();							\
> +	WRITE_ONCE(*p, v);						\
> +} while (0)
> +
> +#define has_fast_acquire_release()	1

Can you check if defining has_fast_acquire_release() to 0 speeds up
performance significantly ? It turns the smp_lwsync() into a
compiler barrier() on the smp_load_acquire() side (fast-path), and
turn the smp_lwsync() into a membarrier system call instead of the
matching smp_store_release() (slow path).

Thanks,

Mathieu

> +
> +# if __PPC64__
> +# define has_single_copy_load_64()	1
> +# else
> +# define has_single_copy_load_64()	0
> +# endif
> +
> #else
> #error unsupported target
> #endif
> @@ -404,6 +433,97 @@ bool rseq_finish(struct rseq_lock *rlock,
> 			: succeed
> 		);
> 	}
> +#elif __PPC64__
> +	{
> +		/*
> +		 * The __rseq_table section can be used by debuggers to better
> +		 * handle single-stepping through the restartable critical
> +		 * sections.
> +		 */
> +		__asm__ __volatile__ goto (
> +			".pushsection __rseq_table, \"aw\"\n\t"
> +			".balign 8\n\t"
> +			"4:\n\t"
> +			".quad 1f, 2f, 3f\n\t"
> +			".popsection\n\t"
> +			"1:\n\t"
> +			RSEQ_INJECT_ASM(1)
> +			"lis %%r17, (4b)@highest\n\t"
> +			"ori %%r17, %%r17, (4b)@higher\n\t"
> +			"rldicr %%r17, %%r17, 32, 31\n\t"
> +			"oris %%r17, %%r17, (4b)@h\n\t"
> +			"ori %%r17, %%r17, (4b)@l\n\t"
> +			"std %%r17, 0(%[rseq_cs])\n\t"
> +			RSEQ_INJECT_ASM(2)
> +			"lwz %%r17, %[current_event_counter]\n\t"
> +			"li %%r16, 0\n\t"
> +			"cmpw cr7, %[start_event_counter], %%r17\n\t"
> +			"bne cr7, 3f\n\t"
> +			RSEQ_INJECT_ASM(3)
> +			"std %[to_write], 0(%[target])\n\t"
> +			"2:\n\t"
> +			RSEQ_INJECT_ASM(4)
> +			"std %%r16, 0(%[rseq_cs])\n\t"
> +			"b %l[succeed]\n\t"
> +			"3:\n\t"
> +			"li %%r16, 0\n\t"
> +			"std %%r16, 0(%[rseq_cs])\n\t"
> +			: /* no outputs */
> +			: [start_event_counter]"r"(start_value.event_counter),
> +			  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
> +			  [to_write]"r"(to_write),
> +			  [target]"b"(p),
> +			  [rseq_cs]"b"(&start_value.rseqp->abi.rseq_cs)
> +			  RSEQ_INJECT_INPUT
> +			: "r16", "r17", "memory", "cc"
> +			  RSEQ_INJECT_CLOBBER
> +			: succeed
> +		);
> +	}
> +#elif __PPC__
> +	{
> +		/*
> +		 * The __rseq_table section can be used by debuggers to better
> +		 * handle single-stepping through the restartable critical
> +		 * sections.
> +		 */
> +		__asm__ __volatile__ goto (
> +			".pushsection __rseq_table, \"aw\"\n\t"
> +			".balign 8\n\t"
> +			"4:\n\t"
> +			".long 0x0, 1f, 0x0, 2f, 0x0, 3f\n\t" /* 32 bit only supported on BE */
> +			".popsection\n\t"
> +			"1:\n\t"
> +			RSEQ_INJECT_ASM(1)
> +			"lis %%r17, (4b)@ha\n\t"
> +			"addi %%r17, %%r17, (4b)@l\n\t"
> +			"stw %%r17, 0(%[rseq_cs])\n\t"
> +			RSEQ_INJECT_ASM(2)
> +			"lwz %%r17, %[current_event_counter]\n\t"
> +			"li %%r16, 0\n\t"
> +			"cmpw cr7, %[start_event_counter], %%r17\n\t"
> +			"bne cr7, 3f\n\t"
> +			RSEQ_INJECT_ASM(3)
> +			"stw %[to_write], 0(%[target])\n\t"
> +			"2:\n\t"
> +			RSEQ_INJECT_ASM(4)
> +			"stw %%r16, 0(%[rseq_cs])\n\t"
> +			"b %l[succeed]\n\t"
> +			"3:\n\t"
> +			"li %%r16, 0\n\t"
> +			"stw %%r16, 0(%[rseq_cs])\n\t"
> +			: /* no outputs */
> +			: [start_event_counter]"r"(start_value.event_counter),
> +			  [current_event_counter]"m"(start_value.rseqp->abi.u.e.event_counter),
> +			  [to_write]"r"(to_write),
> +			  [target]"b"(p),
> +			  [rseq_cs]"b"(&start_value.rseqp->abi.rseq_cs)
> +			  RSEQ_INJECT_INPUT
> +			: "r16", "r17", "memory", "cc"
> +			  RSEQ_INJECT_CLOBBER
> +			: succeed
> +		);
> +	}
> #else
> #error unsupported target
> #endif
> --
> 2.9.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
