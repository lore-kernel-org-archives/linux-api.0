From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system
 call
Date: Thu, 16 Nov 2017 20:06:17 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711161957570.2109@nanos>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-2-mathieu.desnoyers@efficios.com> <20171116184305.snpudnjdhua2obby@hirez.programming.kicks-ass.net> <1523632942.16739.1510858189882.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1523632942.16739.1510858189882.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

On Thu, 16 Nov 2017, Mathieu Desnoyers wrote:
> ----- On Nov 16, 2017, at 1:43 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> 
> > On Tue, Nov 14, 2017 at 03:03:51PM -0500, Mathieu Desnoyers wrote:
> >> +/*
> >> + * If parent process has a registered restartable sequences area, the
> >> + * child inherits. Only applies when forking a process, not a thread. In
> >> + * case a parent fork() in the middle of a restartable sequence, set the
> >> + * resume notifier to force the child to retry.
> >> + */
> >> +static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
> >> +{
> >> +	if (clone_flags & CLONE_THREAD) {
> >> +		t->rseq = NULL;
> >> +		t->rseq_len = 0;
> >> +		t->rseq_sig = 0;
> >> +	} else {
> >> +		t->rseq = current->rseq;
> >> +		t->rseq_len = current->rseq_len;
> >> +		t->rseq_sig = current->rseq_sig;
> >> +		rseq_set_notify_resume(t);
> >> +	}
> >> +}
> > 
> > This hurts my brain... what happens if you fork a multi-threaded
> > process?
> > 
> > Do we fully inherit the TLS state of the calling thread?
> 
> Yes, exactly. The user-space TLS should be inherited from that of
> the calling thread.
> 
> At kernel-level, the only thing that's not inherited here is the
> task struct rseq_event_mask, which tracks whether a restart is
> needed. But this would only be relevant if fork() can be invoked
> from a signal handler, or if fork() could be invoked from a
> rseq critical section (which really makes little sense).

Whether it makes sense or not does not matter much, especially in context
of user space. You cannot make assumptions like that. When something can be
done, then it's bound to happen sooner than later because somebody thinks
he is extra clever.

The first priority is robustness in any aspect which has to do with user
space.

> Should I copy the current->rseq_event_mask on process fork just to
> be on the safe side though ?

I think so, unless you let fork() fail when invoked from a rseq critical
section.

Thanks,

	tglx
