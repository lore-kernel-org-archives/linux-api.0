From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Fri, 8 Apr 2016 08:58:27 -0700
Message-ID: <CALCETrUi+TXUD3PJqm9BqV+e9ozi7nJDp2u+gpUHBzPxe8Ub9A@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net> <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net> <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net> <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
 <20160408064136.GJ3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160408064136.GJ3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Apr 7, 2016 11:41 PM, "Peter Zijlstra" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, Apr 07, 2016 at 09:43:33AM -0700, Andy Lutomirski wrote:
> > enter the critical section:
> > 1:
> > movq %[cpu], %%r12
> > movq {address of counter for our cpu}, %%r13
> > movq {some fresh value}, (%%r13)
> > cmpq %[cpu], %%r12
> > jne 1b
>
> This is inherently racy; your forgot the detail of 'some fresh value',
> but since you want to avoid collisions you really want an increment.
>
> But load-store archs cannot do that. Or rather, they need to do:
>
>         load    Rn, $event
>         add     Rn, Rn, 1
>         store   $event, Rn
>
> But if they're preempted in the middle, two threads will collide and
> generate the _same_ increment. Comparing CPU numbers will not fix that.

Even on x86 this won't work -- we have no actual guarantee we're on
the right CPU, so we'd have to use an atomic.

I was thinking we'd allocate from a per-thread pool (say 24 bits of
thread ID and the rest being a nonce).  On load-store architectures
this wouldn't be async-signal-safe, though.  Hmm.

--Andy
