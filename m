From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 17:39:48 +0200
Message-ID: <20160407153948.GH24771@twins.programming.kicks-ass.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net>
 <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407152432.GZ3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 05:24:32PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2016 at 07:35:26AM -0700, Andy Lutomirski wrote:
> > That way we could take an async signal, handle it, and resume, even in
> > the middle of a commit, without aborting.  Of course, if the signal
> > hander tried to access the same rseq-protected resource, it would bump
> > the event counter and cause an abort.
> 
> Ah, so what happens if the signal happens before the commit but after
> the load of the seqcount?
> 
> Then, even if the signal motifies the count, we'll not observe.

Ah, and the same is true for preemptions. Which is why all this was
preemption driven, and not migration driven.
