From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Wed, 22 Nov 2017 16:25:01 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711221538190.1751@nanos>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711212315450.2399@nanos>
 <809252084.19901.1511354219731.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <809252084.19901.1511354219731.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Wed, 22 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 21, 2017, at 5:59 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> >> Using vDSO as an example of how things should be done is just wrong: the
> >> vDSO interaction with debugger instruction single-stepping is broken,
> >> as I detailed in my previous email.
> > 
> > Let me turn that around. You're lamenting about a conditional branch in
> > your rseq thing for performance reasons and at the same time you want to
> > force extra code into the VDSO? clock_gettime() is one of the hottest
> > vsyscalls in certain scenarions. So why would we want to have extra code
> > there? Just to make debuggers happy. You really can't be serious about
> > that.
> 
> There is *already* an existing branch in the clock_gettime vsyscall:
> it's a loop. It won't hurt the fast-path to use that branch and
> make it do something else instead. It could even help the vDSO fast-path
> for some non-x86 architectures where branch prediction assumes that
> backward branches are always taken (adding an unlikely() does not help
> in those cases).

Yes, there is an existing branch, but forcing that thing into the real
syscall when the seqcount does not match is silly.

> >> Thomas' proposal of handling single-stepping with a user-space locking
> >> fallback, which is pretty much what I had in 2016, pushes a lot of
> >> complexity to user-space, requires an extra branch in the fast-path,
> >> as well as additional store-release/load-acquire semantics for consistency.
> >> I don't plan going down that route.
> >>
> >> Other than that, I have not received any concrete alternative proposal to
> >> properly handle single-stepping.
> > 
> > You provided the details today. Up to that point all we had was handwaving
> > and inconsistent information.
> 
> I mistakenly presumed you took interest in the past 2 years discussions.
> It appears I was wrong, and that information needed to be summarized in
> my changelog. This was my mistake and I fixed it.

I took interest, but I did not follow all the details. And it's not about
me. Anyone who looks at those patches for whatever reason should get enough
information.

> >> The only opposition against cpu_opv is that there *should* be an hypothetical
> >> simpler solution. The rseq idea is not new: it's been presented by Paul Turner
> >> in 2012 at LPC. And so far, cpu_opv is the overall simplest and most
> >> efficient way I encountered to handle single-stepping, and it gives extra
> >> benefits, as described in my changelog.
> > 
> > That's how you define it and that does not make cpu_opv less complex and
> > more debuggable. There is no way to debug that and still you claim that it
> > removes compexity from user space.
> 
> So I should ask: what kind of observability within cpu_opv() do you want ?
> I can add a tracepoint for each operation, which would technically take care
> of your concern. You main counter-argument seems to be a tooling issue.

Yes, it's a tooling issue and this is issue is not going to be solved
faster than gdb support for skipping rseq sections.

> > That ops stuff comes from user space and
> > is not magically constructed by the kernel. In some of your use cases it
> > even has different semantics than the rseq section code. So how is that
> > removing any complexity from user space? All it buys you is an extra branch
> > less in your rseq hotpath and that's your justification to shove that
> > thing into the kernel.
> 
> Actually, the cpu-op user-space library can hide this difference from the
> user: I implemented the equivalent rseq algorithm using a compare-and-store:

Yes, you implemented it and I don't want to know how long it took to get it
right. But syscalls are not coupled to be used with a particular library.

> So from a library user perspective, the fast-path and slow-path are
> exactly the same.

Aside of the fact that they are not the same in terms of implementation and
semantics. I'm looking at the syscall and not reviewing your magic user
space library.

Thanks,

	tglx
