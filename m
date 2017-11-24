From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Fri, 24 Nov 2017 15:47:20 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711241541340.1757@nanos>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <20171122193219.GI3165@worktop.lehotels.local> <20171122193734.GO22648@arm.com> <165707648.21250.1511471721845.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1711232346030.2364@nanos> <739755311.21380.1511478071883.JavaMail.zimbra@efficios.com> <alpine.DEB.2.20.1711240026480.2364@nanos> <1589826840.21401.1511481874141.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1589826840.21401.1511481874141.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin
List-Id: linux-api@vger.kernel.org

On Fri, 24 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 23, 2017, at 6:38 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
> > You have to test for sys_rseq somewhere in the init code. So you can test
> > for the other two being fully functional as well.
> > 
> > If one of them is missing then you can avoid that rseq fastpath either
> > completely or because you never registered that rseq muck your rseq will
> > just contain stale init data which kicks you into some slowpath fallback
> > code.
> 
> That would work if we could have more than one rseq TLS entry per thread.
> If it would be the case, then e.g. lttng-ust could own its own rseq
> TLS and do just as you explain above.
> 
> It's not the case with the current proposal. This means multiple user
> libraries will have to share the same cpu_id and cpu_id_start fields,
> which breaks your proposed new-app/old-kernel backward compatibility
> check proposal.
> 
> For instance, if glibc librseq.so happily registers rseq (and does not
> care about testing for cpu_opv or membarrier availability), then
> lttng-ust cannot leave stale rseq init data which kicks in its slowpath
> fallback.

You have to make sure that _ALL_ prerequisites are there before you start
using it whether you have a shared rseq or not. If a setup has rseq working
and sysops are blocked by a stupid mistake in a security filter, then your
assumption of testing rseq alone is broken already and stuff will explode
in hard to debug ways.

You CANNOT make such assumptions ever. Robustness is the first thing to
look at and after that you can optimize the hell out of it, without
violating robustness while doing that.

Thanks,

	tglx
