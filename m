From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Fri, 26 Feb 2016 17:29:55 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1602261719440.3638@nanos>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com> <20160225095635.GO6356@twins.programming.kicks-ass.net> <390571988.7745.1456419326288.JavaMail.zimbra@efficios.com>
 <20160225170416.GV6356@twins.programming.kicks-ass.net> <2135602720.7810.1456420671941.JavaMail.zimbra@efficios.com> <20160226113304.GA6356@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226113304.GA6356-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 26 Feb 2016, Peter Zijlstra wrote:
> On Thu, Feb 25, 2016 at 05:17:51PM +0000, Mathieu Desnoyers wrote:
> > ----- On Feb 25, 2016, at 12:04 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> > 
> > > On Thu, Feb 25, 2016 at 04:55:26PM +0000, Mathieu Desnoyers wrote:
> > >> ----- On Feb 25, 2016, at 4:56 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> > >> The restartable sequences are intrinsically designed to work
> > >> on per-cpu data, so they need to fetch the current CPU number
> > >> within the rseq critical section. This is where the getcpu_cache
> > >> system call becomes very useful when combined with rseq:
> > >> getcpu_cache allows reading the current CPU number in a
> > >> fraction of cycle.
> > > 
> > > Yes yes, I know how restartable sequences work.
> > > 
> > > But what I worry about is that they want a cpu number and a sequence
> > > number, and for performance it would be very good if those live in the
> > > same cacheline.
> > > 
> > > That means either getcpu needs to grow a seq number, or restartable
> > > sequences need to _also_ provide the cpu number.
> > 
> > If we plan things well, we could have both the cpu number and the
> > seqnum in the same cache line, registered by two different system
> > calls. It's up to user-space to organize those two variables
> > to fit within the same cache-line.
> 
> I feel this is more fragile than needed. Why not do a single systemcall
> that does both?

Right. There is no point in having two calls and two update mechanisms for a
very similar purpose.

So let userspace have one struct where cpu/seq and whatever is required for
rseq is located and flag at register time which parts of the struct need to be
updated.

Thanks,

	tglx
