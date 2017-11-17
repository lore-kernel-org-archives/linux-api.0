From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 10:18:39 -0800
Message-ID: <20171117181839.GH2482@two.firstfloor.org>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-9-mathieu.desnoyers@efficios.com>
 <alpine.DEB.2.20.1711162215100.2109@nanos>
 <20171117001410.GG2482@two.firstfloor.org>
 <alpine.DEB.2.20.1711171107450.1709@nanos>
 <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1756446476.17265.1510938872121.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

Thanks for the detailed write up. That should have been in the
changelog...

Some comments below. Overall I think the case for the syscall is still
very weak.

> Let's have a look at why cpu_opv is needed. I'll make sure to enhance the
> changelog and documentation to include that information.
> 
> 1) Handling single-stepping from tools
> 
> Tools like debuggers, and simulators like record-replay ("rr") use
> single-stepping to run through existing programs. If core libraries start

No rr doesn't use single stepping. It uses branch stepping based on the
PMU, and those should only happen on external events or syscalls which would
abort the rseq anyways.

Eventually it will suceeed because not every retry there will be a new
signal. If you put a syscall into your rseq you will just get
what you deserve.

If it was single stepping it couldn't execute the vDSO (and it would
be incredible slow)

Yes debuggers have to skip instead of step, but that's easily done
(and needed today already for every gettimeofday, which tends to be
the most common syscall...) 

> to use restartable sequences for e.g. memory allocation, this means
> pre-existing programs cannot be single-stepped, simply because the
> underlying glibc or jemalloc has changed.

But how likely is it that the fall back path even works?

It would never be exercised in normal operation, so it would be a prime
target for bit rot, or not ever being tested and be broken in the first place.

> Having a performance-related library improvement break tooling is likely to
> cause a big push-back against wide adoption of rseq. *I* would not even
> be using rseq in liburcu and lttng-ust until gdb gets updated in every
> distributions that my users depend on. This will likely happen... never.

I suspect your scheme already has a <50% likelihood of working due to
the above that it's equivalent.

> 
> 
> 2) Forward-progress guarantee
> 
> Having a piece of user-space code that stops progressing due to
> external conditions is pretty bad. We are used to think of fast-path and
> slow-path (e.g. for locking), where the contended vs uncontended cases
> have different performance characteristics, but each need to provide some
> level of progress guarantees.

We already have that in the vDSO. Has never been a problem.

> 3) Handling page faults
> 
> If we get creative enough, it's pretty easy to come up with corner-case
> scenarios where rseq does not progress without the help from cpu_opv. For
> instance, a system with swap enabled which is under high memory pressure
> could trigger page faults at pretty much every rseq attempt. I recognize
> that this scenario is extremely unlikely, but I'm not comfortable making
> rseq the weak link of the chain here.

Seems very unlikely. But if this happens the program is dead anyways,
so doesn't make much difference.


> The main difference between LL/SC and rseq is that debuggers had
> to support single-stepping through LL/SC critical sections from the
> get go in order to support a given architecture. For rseq, we're
> adding critical sections into pre-existing applications/libraries,
> so the user expectation is that tools don't break due to a library
> optimization.

I would argue that debugging some other path that is normally
executed is wrong by definition. How would you find the bug if it is 
in the original path only, but not the fallback.

The whole point of debugging is to punch through abstractions,
but you're adding another layer of obfuscation here. And worse
you have no guarantee that the new layer is actually functionally
equivalent.

Having less magic and just assume the user can do the right thing
seems like a far more practical scheme.

> In order to facilitate integration of rseq into user-space, cpu_opv
> can provide a (relatively slower) architecture-agnostic implementation
> of rseq. This means that user-space code can be ported to all
> architectures through use of cpu_opv initially, and have the fast-path
> use rseq whenever the asm code is implemented.

While that's in theory correct, in practice it will be so slow
that it is useless. Nobody will want a system call in their malloc
fast path.


-Andi
