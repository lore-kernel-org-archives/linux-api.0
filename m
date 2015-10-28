From: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] restartable sequences: x86 ABI
Date: Tue, 27 Oct 2015 22:19:24 -0700
Message-ID: <CADm5QV90dE+05in-P9_ZjcF=mB173gFmD=LALxNDeye0HZ1Zug@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <20151027235705.16059.63268.stgit@pjt-glaptop.roam.corp.google.com> <20151028050314.GC11242@worktop.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028050314.GC11242-IIpfhp3q70xmmu7s1q4rt2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 27, 2015 at 10:03 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Tue, Oct 27, 2015 at 04:57:05PM -0700, Paul Turner wrote:
> > +static void rseq_sched_out(struct preempt_notifier *pn,
> > +                        struct task_struct *next)
> > +{
> > +     set_thread_flag(TIF_NOTIFY_RESUME);
> > +}
> >
> >  static __read_mostly struct preempt_ops rseq_preempt_ops = {
> >       .sched_in = rseq_sched_in_nop,
> > -     .sched_out = rseq_sched_out_nop,
> > +     .sched_out = rseq_sched_out,
> >  };
>
> Since we're unconditionally setting this TIF flag for these tasks, can't
> we introduce something similar to the (contested) TIF_NOHZ_FULL thing
> which is kept on the task indefinitely.
>
So Andy and I talked about this also, I'm in favor, in particular this
has two nice effects:
 a) In exit_to_usermode_loop() we can ensure that this is evaluated
prior to _TIF_SIGPENDING.  This removes the current requirement that
we also validate this state in setup_rt_frame() [which can perturb
this state prior to our existing notifier].
 b) We avoid spurious interactions with other things that use notify resume.

> That avoids having the preempt notifiers and this atomic op in the
> schedule path.


So we still want something there (although it can be definitely be
inlined as opposed to a preempt_notifier) since this allows us to only
evaluate this check on returns to user-space that might matter as
opposed to every syscall.
