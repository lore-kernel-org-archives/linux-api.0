From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 14 Dec 2017 12:50:13 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1712141238180.8340@nuc-kabylake>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com> <20171214161403.30643-3-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake> <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12046460.34426.1513275177081.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 14 Dec 2017, Mathieu Desnoyers wrote:

> > I think the proper way to think about gs and fs on x86 is as base
> > registers. They are essentially values in registers added to the address
> > generated in an instruction. As such the approach is transferable to other
> > processor architecture. Many support base register and base register
> > relative processing. If a processor can do RMV instructions base register
> > relative then you have something similar.
>
> How would you do it on ARM32 ?

Actually you do not really need RMV instructions. The data is cpu specific
so within a restartable sequence you would have exclusive access right?

F.e. a increment would be

1. Load base register relative
2. add 1
3. Store base register relative

The main overhead would be the registeration of the sequence.

The advantage on x86 is that you do not need a restartable sequence
since a single lockless RMV instruction can do this (this_cpu_inc f.e.)

> One benefit of your proposal is to lessen the number of retired instructions,
> but if we take the IPC into account, it is slower than rseq in my benchmark. What
> benefits do you expect from using segment selectors and non-lock-prefixed atomic
> instructions on the fast-path ?

Ultimately I wish fast increments like done by this_cpu_inc() could be
implemented in an efficient way on non x86 platforms that do not have
cheap instructions like that.

If cmpxchg local is slower than a group of instructions to do the same
then there is an obvious question to the cpu architects why we would need
the instruction at all (aside from the fact that we do not need a
restartable sequence for these instructions).
