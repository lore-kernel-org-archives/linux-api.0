From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 15:29:20 +0200
Message-ID: <20160810132920.GN30192@twins.programming.kicks-ass.net>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net>
 <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 09, 2016 at 08:06:40PM +0000, Mathieu Desnoyers wrote:
> On Aug 3, 2016, at 9:19 AM, Peter Zijlstra peterz@infradead.org wrote:

> >> +++ b/kernel/sched/core.c
> >> @@ -2664,6 +2664,7 @@ prepare_task_switch(struct rq *rq, struct task_struct
> >> *prev,
> >>  {
> >>  	sched_info_switch(rq, prev, next);
> >>  	perf_event_task_sched_out(prev, next);
> >> +	rseq_sched_out(prev);
> > 
> > One thing I considered is doing something like:
> > 
> > static inline void rseq_sched_out(struct task_struct *t)
> > {
> >	unsigned long ptr;
> >	int err;
> > 
> >	if (!t->rseq)
> >		return;
> > 
> >	err = __get_user(ptr, &t->rseq->rseq_cs);
> >	if (err || ptr)
> >		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
> > }
> > 
> > That will optimistically try to read the rseq_cs pointer and, on success
> > and empty (the most likely case) avoid setting the TIF flag.
> > 
> > This will require an explicit migration hook to unconditionally set the
> > TIF flag such that we keep the cpu_id field correct of course.
> > 
> > And obviously we can do this later, as an optimization. Its just
> > something I figured might be worth it.
> 
> This won't work. The rseq mechanism proposed here is really the overlap
> of _two_ distinct restart mechanisms: a sequence counter for C code,
> and a ip-fixup-based mechanism for the assembly "finish" instruction
> sequence.
> 
> What you propose here only considers the fixup of the assembly instruction
> sequence, but not the C code that runs before. The C code between
> rseq_start() and rseq_finish() loads the current value of the sequence
> counter in rseq_start(), and then it gets compared with the new current
> value within the rseq_finish restartable sequence of instructions. So the
> sequence counter needs to be updated upon preemption/signal delivery that
> occurs on top of C code, even if not nesting over a sequence of
> restartable assembly instructions.

True; we could of course have the rseq_start() also set a !0 state
before reading the seq, but not sure that all is worth it.
