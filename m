From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Fri, 8 Apr 2016 14:16:35 -0700
Message-ID: <CALCETrWLSZVHfU0tx=pPUr=rQ7Ev=S8=oajJ+KWUjx8dvj6yog@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net> <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
 <20160407201156.GC3448@twins.programming.kicks-ass.net> <CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ@mail.gmail.com>
 <1802683892.49910.1460077902922.JavaMail.zimbra@efficios.com>
 <CALCETrW5o_VuCrH0eUoT9c+izhyOCvkw2FLOzs5nc_+4Uk5+=g@mail.gmail.com>
 <427613474.49955.1460081105607.JavaMail.zimbra@efficios.com> <65466698.51122.1460137589499.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <65466698.51122.1460137589499.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Apr 8, 2016 10:46 AM, "Mathieu Desnoyers"
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> ----- On Apr 7, 2016, at 10:05 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>
> > ----- On Apr 7, 2016, at 9:21 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:
> >
> >> On Thu, Apr 7, 2016 at 6:11 PM, Mathieu Desnoyers
> >> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> >>> ----- On Apr 7, 2016, at 6:05 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:
> >>>
> >>>> On Thu, Apr 7, 2016 at 1:11 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >>>>> On Thu, Apr 07, 2016 at 09:43:33AM -0700, Andy Lutomirski wrote:
> >>> [...]
> >>>>>
> >>>>>> it's inherently debuggable,
> >>>>>
> >>>>> It is more debuggable, agreed.
> >>>>>
> >>>>>> and it allows multiple independent
> >>>>>> rseq-protected things to coexist without forcing each other to abort.
> >>>
> >>> [...]
> >>>
> >>> My understanding is that the main goal of this rather more complex
> >>> proposal is to make interaction with debuggers more straightforward in
> >>> cases of single-stepping through the rseq critical section.
> >>
> >> The things I like about my proposal are both that you can single-step
> >> through it just like any other code as long as you pin the thread to a
> >> CPU and that it doesn't make preemption magical.  (Of course, you can
> >> *force* it to do something on resume and/or preemption by sticking a
> >> bogus value in the expected event count field, but that's not the
> >> intended use.  Hmm, I guess it does need to hook preemption and/or
> >> resume for all processes that enable the thing so it can know to check
> >> for an enabled post_commit_rip, just like all the other proposals.)
> >>
> >> Also, mine lets you have a fairly long-running critical section that
> >> doesn't get aborted under heavy load and can interleave with other
> >> critical sections that don't conflict.
> >
> > Yes, those would be nice advantages. I'll have to do a few more
> > pseudo-code and execution scenarios to get a better understanding of
> > your idea.
> >
> >>
> >>>
> >>> I recently came up with a scheme that should allow us to handle such
> >>> situations in a fashion similar to debuggers handling ll/sc
> >>> restartable sequences of instructions on e.g. powerpc. The good news
> >>> is that my scheme does not require anything at the kernel level.
> >>>
> >>> The idea is simple: the userspace rseq critical sections now
> >>> become marked by 3 inline functions (rather than 2 in Paul's proposal):
> >>>
> >>> rseq_start(void *rseq_key)
> >>> rseq_finish(void *rseq_key)
> >>> rseq_abort(void *rseq_key)
> >>
> >> How do you use this thing?  What are its semantics?
> >
> > You define one rseq_key variable (dummy 1 byte variable, can be an
> > empty structure) for each rseq critical section you have in your
> > program.
> >
> > A rseq critical section will typically have one entry point (rseq_start),
> > and one exit point (rseq_finish). I'm saying "typically" because there
> > may be more than one entry point, and more than one exit point per
> > critical section.
> >
> > Entry and exit points mark the beginning and end of each rseq critical
> > section. rseq_start loads the sequence counter from the TLS and copies
> > it onto the stack. It then gets passed to rseq_finish() to be compared
> > with the final seqnum TLS value just before the commit. rseq_finish is
> > the one responsible for storing into the post_commit_instr field of the
> > TLS and populating rcx with the failure insn label address. rseq_finish()
> > does the commit.
> >
> > And there is rseq_abort(), which would need to be called if we just want
> > to exit from a rseq critical section without doing the commit (no matching
> > call to rseq_finish after a rseq_start).
> >
> > Each of rseq_start, finish, and abort would need to receive a pointer
> > to the rseq_key as parameter.
> >
> > rseq_start would return the sequence number read from the TLS.
> >
> > rseq_finish would also receive as parameter that sequence number that has
> > been returned by rseq_start.
> >
> > Does it make sense ?
>
> By the way, the debugger can always decide to single-step through the
> first iteration of the rseq, and then after it loops, decide to skip
> single-stepping until the exit points are reached.

True, but you're assuming that someone will actually write that code
and then users will know how to use it.  That's something I like about
my version.

Admittedly, LL/SC and TSX have the same problem, but those are
architectural, and it's not really a good excuse to add a new thing
that's awkward to debug.

--Andy
