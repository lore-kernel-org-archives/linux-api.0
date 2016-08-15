From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 7/7] Restartable sequences: self-tests
Date: Mon, 15 Aug 2016 18:06:41 +0000 (UTC)
Message-ID: <1861719735.10537.1471284401541.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <365498072.8664.1470971438957.JavaMail.zimbra@efficios.com> <20160812053008.GA18611@tardis.cn.ibm.com> <20160812163542.GB18611@tardis.cn.ibm.com> <434180831.9286.1471025505641.JavaMail.zimbra@efficios.com> <20160813012834.GC18611@tardis.cn.ibm.com> <832944127.9855.1471186940516.JavaMail.zimbra@efficios.com> <20160815005607.GD18611@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160815005607.GD18611-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 14, 2016, at 8:56 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Sun, Aug 14, 2016 at 03:02:20PM +0000, Mathieu Desnoyers wrote:
>> ----- On Aug 12, 2016, at 9:28 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> 
>> > On Fri, Aug 12, 2016 at 06:11:45PM +0000, Mathieu Desnoyers wrote:
>> >> ----- On Aug 12, 2016, at 12:35 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >> 
>> >> > On Fri, Aug 12, 2016 at 01:30:15PM +0800, Boqun Feng wrote:
>> >> > [snip]
>> >> >> > > Besides, do we allow userspace programs do read-only access to the
>> >> >> > > memory objects modified by do_rseq(). If so, we have a problem when
>> >> >> > > there are two writes in a do_rseq()(either in the rseq critical section
>> >> >> > > or in the asm block), because in current implemetation, these two writes
>> >> >> > > are unordered, which makes the readers outside a do_rseq() could observe
>> >> >> > > the ordering of writes differently.
>> >> >> > > 
>> >> >> > > For rseq_finish2(), a simple solution would be making the "final" write
>> >> >> > > a RELEASE.
>> >> >> > 
>> >> >> > Indeed, we would need a release semantic for the final store here if this
>> >> >> > is the common use. Or we could duplicate the "flavors" of rseq_finish2 and
>> >> >> > add a rseq_finish2_release. We should find a way to eliminate code duplication
>> >> >> 
>> >> >> I'm in favor of a separate rseq_finish2_release().
>> >> >> 
>> >> >> > there. I suspect we'll end up doing macros.
>> >> >> > 
>> >> >> 
>> >> >> Me too. Lemme have a try ;-)
>> >> >> 
>> >> > 
>> >> > How about this? Although a little messy, I separated the asm block into
>> >> > several parts and implemented each part in a arch-diagnose way.
>> >> 
>> >> I find it rather hard to follow the per-arch assembly with this approach.
>> >> It might prove to be troublesome if we want to do arch-specific optimizations
>> >> in the future.
>> >> 
>> > 
>> > It might be, but I was just trying to kill as much duplicate code as
>> > possible, because the more duplicate we have, the more maintain effort
>> > we need.
>> > 
>> > For example, PPC32 and PPC64 may have the same asm code to check the
>> > event counter, but different code to do the final store.  Having the
>> > same RSEQ_CHECK_COUNTER() for PPC32 and PPC64 actually makes it easy if
>> > we come up a way to optimize the counter check code on PPC.
>> > 
>> > And if some arch wants to have some very specifical optimizations,
>> > it could always write the whole asm block again rather than use the
>> > helpers macros.
>> 
>> Creating macros for each assembly "operation" done in the restartable
>> sequence ends up requiring that people learn a new custom mini-language,
>> and implement those macros for each architecture.
>> 
>> I'd rather prefer to let each architecture maintainer express the
>> restartable sequence directly in assembly, which is already known to
>> them, than require them to learn a new small macro-based language.
>> 
>> Eliminating duplicated code is a goal I agree with, but there are
>> ways to achieve this which don't end up creating a macro-based custom
>> mini-language (such as what I proposed below).
>> 
> 
> Fair point ;-)
> 
> One more thing, do we want to use arch-specific header files to put
> arch-specific assembly code? For example, rseq-x86.h, rseq-powerpc.h,
> etc. This may save readers a lot of time if he or she is only interested
> in a particular arch, and also make maintaining a little easier(no need
> to worry about breaking other archs accidentally)
> 
> [...]

Good point. I wanted to wait until we had enough architectures before
doing this, but now that we have x86 32/64, ppc 32/64 and arm 32, it
appears to be the right time. Done and pushed.

>> 
>> In terms of fast-path, you would be trading:
>> 
>> (1)
>> 	"ldr r0, %[current_event_counter]\n\t" \
>> 	"mov r1, #0\n\t"
>> 	"cmp %[start_event_counter], r0\n\t" \
>> 	"bne %l[failure]\n\t" \
>> 	"str %[to_write_final], [%[target_final]]\n\t" \
>> 	"2:\n\t" \
>> 	"str r1, [%[rseq_cs]]\n\t" \
>> for
>> 
>> (2)
>> 	"ldr r0, %[current_event_counter]\n\t" \
>> 	"cmp %[start_event_counter], r0\n\t" \
>> 	"bne %l[failure]\n\t" \
>> 	"str %[to_write_final], [%[target_final]]\n\t" \
>> 	"2:\n\t" \
>> 	"mov r0, #0\n\t"
>> 	"str r0, [%[rseq_cs]]\n\t" \
>> 
>> Your proposal (2) saves a register (does not clobber r1), but this
>> is at the expense of a slower fast-path. In (1), loading the constant
>> 0 is done while the processor is stalled on the current_event_counter
>> load, which is needed by a following comparison. Therefore, we can
>> increase instruction-level parallelism by placing the immediate value
>> 0 load right after the ldr instruction. This, however, requires that
>> we use a different register than r0, because r0 is already used by the
>> ldr/cmp instructions.
>> 
>> Since this is a fast-path, achieving higher instruction throughput
>> is more important than saving a register.
>> 
>> I came up with this as an optimization while doing benchmarking
>> on a ARM32 Cubietruck as a reference architecture.
>> 
> 
> Nice ;-) Better to put a comment there?

Done.

> 
> I should try to investigate something similar for powerpc.
> 

Yes, you could try clobbering one extra register to move the
"li %%r17, 0\n\t" right after the lwz instruction. Depending on
the architecture characteristics, it may speed it up a bit. I
would expect that benchmarks on older architectures (e.g. old ppc32)
might be more affected by such tweak than newer POWER8.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
