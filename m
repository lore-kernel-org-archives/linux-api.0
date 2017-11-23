From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Thu, 23 Nov 2017 23:51:27 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711232346030.2364@nanos>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local> <20171122193734.GO22648@arm.com>
 <165707648.21250.1511471721845.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <165707648.21250.1511471721845.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

On Thu, 23 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 22, 2017, at 2:37 PM, Will Deacon will.deacon-5wv7dgnIgG8@public.gmane.org wrote:
> > On Wed, Nov 22, 2017 at 08:32:19PM +0100, Peter Zijlstra wrote:
> >>
> >> So what exactly is the problem of leaving out the whole cpu_opv thing
> >> for now? Pure rseq is usable -- albeit a bit cumbersome without
> >> additional debugger support.
> > 
> > Drive-by "ack" to that. I'd really like a working rseq implementation in
> > mainline, but I don't much care for another interpreter.
> 
> Considering the arm 64 use-case of reading PMU counters from user-space
> using rseq to prevent migration, I understand that you're lucky enough to
> already have a system call at your disposal that can perform the slow-path
> in case of single-stepping.
> 
> So yes, your particular case is already covered, but unfortunately that's
> not the same situation for other use-cases that have been expressed.

If we have users of rseq which can do without the other muck, then what's
the reason not to support it?

The sysops thing can be sorted out on top and the use cases which need both
will have to test for both syscalls being available anyway.

Tanks,

	tglx
