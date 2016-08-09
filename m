From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Tue, 9 Aug 2016 23:33:14 +0200
Message-ID: <20160809213314.GK30192@twins.programming.kicks-ass.net>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net>
 <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <656745027.6624.1470773200334.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 09, 2016 at 08:06:40PM +0000, Mathieu Desnoyers wrote:
> >> +static int rseq_increment_event_counter(struct task_struct *t)
> >> +{
> >> +	if (__put_user(++t->rseq_event_counter,
> >> +			&t->rseq->u.e.event_counter))
> >> +		return -1;
> >> +	return 0;
> >> +}

> >> +void __rseq_handle_notify_resume(struct pt_regs *regs)
> >> +{
> >> +	struct task_struct *t = current;
> >> +
> >> +	if (unlikely(t->flags & PF_EXITING))
> >> +		return;
> >> +	if (!access_ok(VERIFY_WRITE, t->rseq, sizeof(*t->rseq)))
> >> +		goto error;
> >> +	if (__put_user(raw_smp_processor_id(), &t->rseq->u.e.cpu_id))
> >> +		goto error;
> >> +	if (rseq_increment_event_counter(t))
> > 
> > It seems a shame to not use a single __put_user() here. You did the
> > layout to explicitly allow for this, but then you don't.
> 
> The event counter increment needs to be performed at least once before
> returning to user-space whenever the thread is preempted or has a signal
> delivered. This counter increment needs to occur even if we are not nested
> over a restartable assembly block. (more detailed explanation about this
> follows at the end of this email)
> 
> The rseq_ip_fixup only ever needs to update the rseq_cs pointer
> field if it preempts/delivers a signal over a restartable
> assembly block, which happens very rarely.
> 
> Therefore, since the event counter increment is more frequent than
> setting rseq_cs ptr, I don't see much value in trying to combine
> those two into a single __put_user().
> 
> The reason why I combined both the cpu_id and event_counter
> fields into the same 64-bit integer is for user-space rseq_start()
> to be able to fetch them through a single load when the architecture
> allows it.

I wasn't talking about the rseq_up_fixup(), I was talking about both
unconditional __put_user()'s on cpu_id and event_counter.

These are 2 unconditinoal u32 stores that could very easily be done as a
single u64 store (on 64bit hardware).
