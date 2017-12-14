From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 14 Dec 2017 21:09:26 +0100
Message-ID: <20171214200926.GF3326@worktop>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com>
 <20171214161403.30643-3-mathieu.desnoyers@efficios.com>
 <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake>
 <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.20.1712141238180.8340@nuc-kabylake>
 <20171214194853.GE3326@worktop>
 <1772818221.34575.1513281428902.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1772818221.34575.1513281428902.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Thu, Dec 14, 2017 at 07:57:08PM +0000, Mathieu Desnoyers wrote:
> ----- On Dec 14, 2017, at 2:48 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> 
> > On Thu, Dec 14, 2017 at 12:50:13PM -0600, Christopher Lameter wrote:
> >> Ultimately I wish fast increments like done by this_cpu_inc() could be
> >> implemented in an efficient way on non x86 platforms that do not have
> >> cheap instructions like that.
> > 
> > So the problem isn't migration; for that we could wrap the operation in
> > preempt_disable() which is not more expensive than rseq would be. And a
> > lot more deterministic.
> > 
> > The problem instead is interrupts, which can result in nested load-store
> > operations, and that comes apart. This then means having to disable
> > interrupts over these things and _that_ is expensive.
> 
> Then could we consider checking a per task-struct rseq_cs pointer when
> returning from interrupt handler ? This rseq_cs pointer would track
> kernel restartable sequences. This would also work for NMI handlers.

I really don't much like making the interrupt handlers more expensive
for this.

And I don't think NMIs are a real worry, you should be very careful when
you share state with any of them in any case.

Also; what you can do is soft interrupt disable, which is effectively
the oppose approach, instead of restarting the sequence, you delay the
interrupt handler. And that has the obvious benefit of making all the
local_irq_disable/enable crud much faster all over.

This is something PowerPC already does.
