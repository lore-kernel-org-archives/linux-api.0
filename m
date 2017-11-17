From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 19:59:33 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711171922420.2186@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos>
 <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com> <20171117181839.GH2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117181839.GH2482-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 17 Nov 2017, Andi Kleen wrote:
> > 1) Handling single-stepping from tools
> > 
> > Tools like debuggers, and simulators like record-replay ("rr") use
> > single-stepping to run through existing programs. If core libraries start
> 
> No rr doesn't use single stepping. It uses branch stepping based on the
> PMU, and those should only happen on external events or syscalls which would
> abort the rseq anyways.
> 
> Eventually it will suceeed because not every retry there will be a new
> signal. If you put a syscall into your rseq you will just get
> what you deserve.
> 
> If it was single stepping it couldn't execute the vDSO (and it would
> be incredible slow)
>
> Yes debuggers have to skip instead of step, but that's easily done
> (and needed today already for every gettimeofday, which tends to be
> the most common syscall...)

The same problem exists with TSX. Hitting a break point inside a
transaction section triggers abort with the cause bit 'breakpoint' set.

rseq can be looked at as a variant of software transactional memory with a
limited feature set, but the underlying problems are exactly the
same. Breakpoints are not working either.

> > to use restartable sequences for e.g. memory allocation, this means
> > pre-existing programs cannot be single-stepped, simply because the
> > underlying glibc or jemalloc has changed.
> 
> But how likely is it that the fall back path even works?
> 
> It would never be exercised in normal operation, so it would be a prime
> target for bit rot, or not ever being tested and be broken in the first place.

What's worse is that the fall back path cannot be debugged at all. It's a
magic byte code which is interpreted inside the kernel.


I really do not understand why this does not utilize existing design
patterns well known from transactional memory.

The most straight forward is to have a mechanism which forces everything
into the slow path in case of debugging, lack of progress, etc. The slow
path uses traditional locking to resolve the situation. That's well known
to work and if done correctly then the only difference between slow path
and fast path is locking/transaction control, i.e. it's a single
implementation of the actual memory operations which can be single stepped,
debug traced and whatever.

It solves _ALL_ of the problems you describe including support for systems
which do not support rseq at all.

This syscall is horribly overengineered and creates more problems than it
solves.

Thanks,

	tglx
