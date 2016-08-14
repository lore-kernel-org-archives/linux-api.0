From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Sun, 14 Aug 2016 15:02:20 +0000 (UTC)
Message-ID: <832944127.9855.1471186940516.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <374861479.8581.1470957990793.JavaMail.zimbra@efficios.com> <20160812012854.GC1740@tardis.cn.ibm.com> <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com> <20160812053008.GA18611@tardis.cn.ibm.com> <20160812163542.GB18611@tardis.cn.ibm.com> <434180831.9286.1471025505641.JavaMail.zimbra@efficios.com> <20160813012834.GC18611@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160813012834.GC18611-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 12, 2016, at 9:28 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Fri, Aug 12, 2016 at 06:11:45PM +0000, Mathieu Desnoyers wrote:
>> ----- On Aug 12, 2016, at 12:35 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> 
>> > On Fri, Aug 12, 2016 at 01:30:15PM +0800, Boqun Feng wrote:
>> > [snip]
>> >> > > Besides, do we allow userspace programs do read-only access to the
>> >> > > memory objects modified by do_rseq(). If so, we have a problem when
>> >> > > there are two writes in a do_rseq()(either in the rseq critical section
>> >> > > or in the asm block), because in current implemetation, these two writes
>> >> > > are unordered, which makes the readers outside a do_rseq() could observe
>> >> > > the ordering of writes differently.
>> >> > > 
>> >> > > For rseq_finish2(), a simple solution would be making the "final" write
>> >> > > a RELEASE.
>> >> > 
>> >> > Indeed, we would need a release semantic for the final store here if this
>> >> > is the common use. Or we could duplicate the "flavors" of rseq_finish2 and
>> >> > add a rseq_finish2_release. We should find a way to eliminate code duplication
>> >> 
>> >> I'm in favor of a separate rseq_finish2_release().
>> >> 
>> >> > there. I suspect we'll end up doing macros.
>> >> > 
>> >> 
>> >> Me too. Lemme have a try ;-)
>> >> 
>> > 
>> > How about this? Although a little messy, I separated the asm block into
>> > several parts and implemented each part in a arch-diagnose way.
>> 
>> I find it rather hard to follow the per-arch assembly with this approach.
>> It might prove to be troublesome if we want to do arch-specific optimizations
>> in the future.
>> 
> 
> It might be, but I was just trying to kill as much duplicate code as
> possible, because the more duplicate we have, the more maintain effort
> we need.
> 
> For example, PPC32 and PPC64 may have the same asm code to check the
> event counter, but different code to do the final store.  Having the
> same RSEQ_CHECK_COUNTER() for PPC32 and PPC64 actually makes it easy if
> we come up a way to optimize the counter check code on PPC.
> 
> And if some arch wants to have some very specifical optimizations,
> it could always write the whole asm block again rather than use the
> helpers macros.

Creating macros for each assembly "operation" done in the restartable
sequence ends up requiring that people learn a new custom mini-language,
and implement those macros for each architecture.

I'd rather prefer to let each architecture maintainer express the
restartable sequence directly in assembly, which is already known to
them, than require them to learn a new small macro-based language.

Eliminating duplicated code is a goal I agree with, but there are
ways to achieve this which don't end up creating a macro-based custom
mini-language (such as what I proposed below).

> 
>> I've come up with the following macro approach instead, feedback welcome!
>> 
>> 
>> commit 4d27431d6aefaee617540ef04518962b0e4d14f4
>> Author: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> Date:   Thu Aug 11 19:11:27 2016 -0400
>> 
>>     rseq_finish2, rseq_finish2_release (WIP)
>> 
> [...]
>> +#elif defined(__ARMEL__)
>> +
>> +#define RSEQ_FINISH_ASM(_target_final, _to_write_final, _start_value, \
>> +		_failure, extra_store, extra_input) \
>> +	__asm__ __volatile__ goto ( \
>> +		".pushsection __rseq_table, \"aw\"\n\t" \
>> +		".balign 32\n\t" \
>> +		".word 1f, 0x0, 2f, 0x0, %l[failure], 0x0, 0x0, 0x0\n\t" \
>> +		".popsection\n\t" \
>> +		"1:\n\t" \
>> +		RSEQ_INJECT_ASM(1) \
>> +		"adr r0, 3f\n\t" \
>> +		"str r0, [%[rseq_cs]]\n\t" \
>> +		RSEQ_INJECT_ASM(2) \
>> +		"ldr r0, %[current_event_counter]\n\t" \
>> +		"mov r1, #0\n\t" \
>> +		"cmp %[start_event_counter], r0\n\t" \
>> +		"bne %l[failure]\n\t" \
>> +		RSEQ_INJECT_ASM(3) \
>> +		extra_store \
>> +		"str %[to_write_final], [%[target_final]]\n\t" \
>> +		"2:\n\t" \
>> +		RSEQ_INJECT_ASM(5) \
>> +		"str r1, [%[rseq_cs]]\n\t" \
> 
> I find this is a little weird here, that is having an extra register for
> zeroing the rseq_cs. Could we
> 
>		"mov r0, #0\n\t"
>		"str r0, [%[rseq_cs]]\n\t"
> 
> here? Which not only saves a register, but also an instruction "mov r1,
> #0" in the fast path. Am I missing something subtle?

In terms of fast-path, you would be trading:

(1)
	"ldr r0, %[current_event_counter]\n\t" \
	"mov r1, #0\n\t"
	"cmp %[start_event_counter], r0\n\t" \
	"bne %l[failure]\n\t" \
	"str %[to_write_final], [%[target_final]]\n\t" \
	"2:\n\t" \
	"str r1, [%[rseq_cs]]\n\t" \
for

(2)
	"ldr r0, %[current_event_counter]\n\t" \
	"cmp %[start_event_counter], r0\n\t" \
	"bne %l[failure]\n\t" \
	"str %[to_write_final], [%[target_final]]\n\t" \
	"2:\n\t" \
	"mov r0, #0\n\t"
	"str r0, [%[rseq_cs]]\n\t" \

Your proposal (2) saves a register (does not clobber r1), but this
is at the expense of a slower fast-path. In (1), loading the constant
0 is done while the processor is stalled on the current_event_counter
load, which is needed by a following comparison. Therefore, we can
increase instruction-level parallelism by placing the immediate value
0 load right after the ldr instruction. This, however, requires that
we use a different register than r0, because r0 is already used by the
ldr/cmp instructions.

Since this is a fast-path, achieving higher instruction throughput
is more important than saving a register.

I came up with this as an optimization while doing benchmarking
on a ARM32 Cubietruck as a reference architecture.

> 
>> +		"b 4f\n\t" \
>> +		".balign 32\n\t" \
>> +		"3:\n\t" \
>> +		".word 1b, 0x0, 2b, 0x0, l[failure], 0x0, 0x0, 0x0\n\t" \
>> +		"4:\n\t" \
>> +		: /* no outputs */ \
>> +		: [start_event_counter]"r"((_start_value).event_counter), \
>> +		  [current_event_counter]"m"((_start_value).rseqp->u.e.event_counter), \
>> +		  [to_write_final]"r"(_to_write_final), \
>> +		  [target_final]"r"(_target_final), \
>> +		  [rseq_cs]"r"(&(_start_value).rseqp->rseq_cs) \
>> +		  extra_input \
>> +		  RSEQ_INJECT_INPUT \
>> +		: "r0", "r1", "memory", "cc" \
>> +		  RSEQ_INJECT_CLOBBER \
>> +		: _failure \
>>  	);
> 
> [...]
> 
>> +
>> +#define RSEQ_FINISH2_RELEASE_SPECULATIVE_STORE_ASM() \
>> +		RSEQ_FINISH2_SPECULATIVE_STORE_ASM() \
>> +		"dmb\n\t"
>> +
> 
> Having a RELEASE barrier here may be OK for all current archs we
> support, but there are archs which rather than have a lightweight
> RELEASE barrier but use a special instruction for RELEASE operations,
> for example, AArch64. Do we need to take that into consideration and
> define a RSEQ_FINISH_ASM_RELEASE() rather than a
> RSEQ_FINISH2_SPECULATIVE_STORE_INPUT_ASM()?

Good point. We should introduce the barrier before the final
store to fit this scenario. This would also work if we want to
do many speculative stores followed by a final store: it really
makes sense to put the barrier just before the final store rather
than after each speculative store.

I just pushed a commit in my dev branch implementing this. Testing
is welcome.

Thanks!

Mathieu

> 
> [...]
> 
> Regards
> Boqun

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
