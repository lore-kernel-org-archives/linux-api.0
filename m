From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Wed, 22 Nov 2017 12:36:59 +0000 (UTC)
Message-ID: <809252084.19901.1511354219731.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711212315450.2399@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711212315450.2399@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 21, 2017, at 5:59 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Tue, 21 Nov 2017, Mathieu Desnoyers wrote:
>> ----- On Nov 21, 2017, at 12:21 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:
>> 
>> > On Tue, Nov 21, 2017 at 09:18:38AM -0500, Mathieu Desnoyers wrote:
>> >> Hi,
>> >> 
>> >> Following changes based on a thorough coding style and patch changelog
>> >> review from Thomas Gleixner and Peter Zijlstra, I'm respinning this
>> >> series for another RFC.
>> >> 
>> > My suggestion would be that you also split out the opv system call.
>> > That seems to be main contention point currently, and the restartable
>> > sequences should be useful without it.
>> 
>> I consider rseq to be incomplete and a pain to use in various scenarios
>> without cpu_opv.
>> 
>> About the contention point you refer to:
>> 
>> Using vDSO as an example of how things should be done is just wrong: the
>> vDSO interaction with debugger instruction single-stepping is broken,
>> as I detailed in my previous email.
> 
> Let me turn that around. You're lamenting about a conditional branch in
> your rseq thing for performance reasons and at the same time you want to
> force extra code into the VDSO? clock_gettime() is one of the hottest
> vsyscalls in certain scenarions. So why would we want to have extra code
> there? Just to make debuggers happy. You really can't be serious about
> that.

There is *already* an existing branch in the clock_gettime vsyscall:
it's a loop. It won't hurt the fast-path to use that branch and
make it do something else instead. It could even help the vDSO fast-path
for some non-x86 architectures where branch prediction assumes that
backward branches are always taken (adding an unlikely() does not help
in those cases).

> 
>> Thomas' proposal of handling single-stepping with a user-space locking
>> fallback, which is pretty much what I had in 2016, pushes a lot of
>> complexity to user-space, requires an extra branch in the fast-path,
>> as well as additional store-release/load-acquire semantics for consistency.
>> I don't plan going down that route.
>>
>> Other than that, I have not received any concrete alternative proposal to
>> properly handle single-stepping.
> 
> You provided the details today. Up to that point all we had was handwaving
> and inconsistent information.

I mistakenly presumed you took interest in the past 2 years discussions.
It appears I was wrong, and that information needed to be summarized in
my changelog. This was my mistake and I fixed it.

> 
>> The only opposition against cpu_opv is that there *should* be an hypothetical
>> simpler solution. The rseq idea is not new: it's been presented by Paul Turner
>> in 2012 at LPC. And so far, cpu_opv is the overall simplest and most
>> efficient way I encountered to handle single-stepping, and it gives extra
>> benefits, as described in my changelog.
> 
> That's how you define it and that does not make cpu_opv less complex and
> more debuggable. There is no way to debug that and still you claim that it
> removes compexity from user space.

So I should ask: what kind of observability within cpu_opv() do you want ?
I can add a tracepoint for each operation, which would technically take care
of your concern. You main counter-argument seems to be a tooling issue.

> That ops stuff comes from user space and
> is not magically constructed by the kernel. In some of your use cases it
> even has different semantics than the rseq section code. So how is that
> removing any complexity from user space? All it buys you is an extra branch
> less in your rseq hotpath and that's your justification to shove that
> thing into the kernel.

Actually, the cpu-op user-space library can hide this difference from the
user: I implemented the equivalent rseq algorithm using a compare-and-store:

int cpu_op_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
                off_t voffp, intptr_t *load, int cpu)
{
        intptr_t oldv = READ_ONCE(*v);
        intptr_t *newp = (intptr_t *)(oldv + voffp);
        int ret;

        if (oldv == expectnot)
                return 1;
        ret = cpu_op_cmpeqv_storep_expect_fault(v, oldv, newp, cpu);
        if (!ret) {
                *load = oldv;
                return 0;
        }
        if (ret > 0) {
                errno = EAGAIN;
                return -1;
        }
        return -1;
}

So from a library user perspective, the fast-path and slow-path are
exactly the same.

> 
> The version I reviewed was just undigestable.

Thanks for the thorough coding style review by the way.

> I did not have time to look
> at the hastily cobbled together version of today. Aside of that the
> scheduler portion of it has not seen any review from scheduler folks
> either.

True. It appears that it really takes a merge window to get some
people's attention. That's OK, you guys are really busy on other
stuff. It's just unfortunate that the feedback about the cpu_opv
concept did not come sooner, e.g. during first rounds of patches
where the cpu_opv design was presented, or even at KS.

> 
> AFAICT there is not a single reviewed-by tag on the sys_rseq and the
> sys_opv patches either.

Very good point! Anyone in CC who cares about getting this in can
find time to do some official review ?

> 
> Are you seriously expecting that new syscalls of that kind are going to be
> merged without a deep and thorough review just based on your decision to
> declare them ready?

In my reply to Andi, I merely state that I'm not willing to push an
half-baked user-space ABI into the kernel, and rseq without cpu_opv
is only part of the solution.

Let's see if others find time to do an official review.

Thanks,

Mathieu



> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
