From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] Fix: membarrier: racy access to p->mm in membarrier_global_expedited()
Date: Mon, 28 Jan 2019 23:45:32 +0100
Message-ID: <CAG48ez1+Vx7=ZqeLJ0waceSneCQhEcoS=bv9ggb3Dbveb+W6AQ@mail.gmail.com>
References: <20190128220707.30774-1-mathieu.desnoyers@efficios.com> <20190128223948.GD4240@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128223948.GD4240@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrea Parri <parri.andrea@gmail.com>, Andy Lutomirski <luto@kernel.org>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, David Sehr <sehr@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Maged Michael <maged.michael@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 11:39 PM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> On Mon, Jan 28, 2019 at 05:07:07PM -0500, Mathieu Desnoyers wrote:
> > Jann Horn identified a racy access to p->mm in the global expedited
> > command of the membarrier system call.
> >
> > The suggested fix is to hold the task_lock() around the accesses to
> > p->mm and to the mm_struct membarrier_state field to guarantee the
> > existence of the mm_struct.
> >
> > Link: https://lore.kernel.org/lkml/CAG48ez2G8ctF8dHS42TF37pThfr3y0RNOOYTmxvACm4u8Yu3cw@mail.gmail.com
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
[...]
> > --- a/kernel/sched/membarrier.c
> > +++ b/kernel/sched/membarrier.c
> > @@ -81,12 +81,27 @@ static int membarrier_global_expedited(void)
> >
> >               rcu_read_lock();
> >               p = task_rcu_dereference(&cpu_rq(cpu)->curr);
> > -             if (p && p->mm && (atomic_read(&p->mm->membarrier_state) &
> > -                                MEMBARRIER_STATE_GLOBAL_EXPEDITED)) {
> > -                     if (!fallback)
> > -                             __cpumask_set_cpu(cpu, tmpmask);
> > -                     else
> > -                             smp_call_function_single(cpu, ipi_mb, NULL, 1);
> > +             /*
> > +              * Skip this CPU if the runqueue's current task is NULL or if
> > +              * it is a kernel thread.
> > +              */
> > +             if (p && READ_ONCE(p->mm)) {
> > +                     bool mm_match;
> > +
> > +                     /*
> > +                      * Read p->mm and access membarrier_state while holding
> > +                      * the task lock to ensure existence of mm.
> > +                      */
> > +                     task_lock(p);
> > +                     mm_match = p->mm && (atomic_read(&p->mm->membarrier_state) &
>
> Are we guaranteed that this p->mm will be the same as the one loaded via
> READ_ONCE() above?

No; the way I read it, that's just an optimization and has no effect
on correctness.

> Either way, wouldn't it be better to READ_ONCE() it a
> single time and use the same value everywhere?

No; the first READ_ONCE() returns a pointer that you can't access
because it wasn't read under a lock. You can only use it for a NULL
check.
