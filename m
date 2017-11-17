From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 21:07:23 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711172025320.2186@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos>
 <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com> <20171117181839.GH2482@two.firstfloor.org> <alpine.DEB.2.20.1711171922420.2186@nanos> <20171117191547.GI2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117191547.GI2482-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 17 Nov 2017, Andi Kleen wrote:
> > The most straight forward is to have a mechanism which forces everything
> > into the slow path in case of debugging, lack of progress, etc. The slow
> 
> That's the abort address, right?

Yes.

> For the generic case the fall back path would require disabling preemption
> unfortunately, for which we don't have a mechanism in user space.
> 
> I think that is what Mathieu tried to implement here with this call.

Yes. preempt disabled execution of byte code to make sure that the
transaction succeeds.

But, why is disabling preemption mandatory? If stuff fails due to hitting a
breakpoint or because it retried a gazillion times without progress, then
the abort code can detect that and act accordingly. Pseudo code:

abort:
	if (!slowpath_required() &&
	    !breakpoint_caused_abort() &&
	    !stall_detected()) {
		do_the_normal_abort_postprocessing();
		goto retry;
	}

	lock(slowpath_lock[cpu]);

	if (!slowpath_required()) {
	   	unlock(slowpath_lock[cpu]);
		goto retry;
	}

	if (rseq_supported)
		set_slow_path();

	/* Same code as inside the actual rseq */
	do_transaction();

	if (rseq_supported)
		unset_slow_path();

	unlock(slowpath_lock[cpu]);

The only interesting question is how to make sure that all threads on that
CPU see the slowpath required before they execute the commit so they are
forced into the slow path. The simplest thing would be atomics, but that's
what rseq wants to avoid.

I think that this can be solved cleanly with the help of the membarrier
syscall or some variant of that without all that 'yet another byte code
interpreter' mess.

The other question is whether do_transaction() is required to run on that
specific CPU. I don't think so because that magic interpreter operates even
when the required target cpu is offline and with locking in place there is
no reason why running on the target CPU would be required.

Sure, that's going to affect performance, but only for two cases:

  1) Debugging. That's completely uninteresting

  2) No progress at all. Performance is down the drain anyway, so it does
     not matter at all whether you spend a few more cycles or not to
     resolve that.

I might be missing something as usual :)

Thanks

	tglx
