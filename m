From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Fri, 8 Apr 2016 08:57:53 -0700
Message-ID: <CALCETrWwNSjr0aRTPB3QrLNXztqwOBPWmNGggEJ+W+nxbLDaDA@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net> <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net> <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net> <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
 <20160407201156.GC3448@twins.programming.kicks-ass.net> <CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ@mail.gmail.com>
 <20160408110232.GP3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160408110232.GP3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Apr 8, 2016 4:04 AM, "Peter Zijlstra" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, Apr 07, 2016 at 03:05:26PM -0700, Andy Lutomirski wrote:
>
> > It doesn't, which is what I like about my variant.  If the thread
> > accesses the protected data structure, though, it should bump the
> > sequence count, which will cause the first thread to about when it
> > gets scheduled in.
>
> Nope it won't, because that first thread is right at the commit
> instruction, nothing will stop it from executing that store and clobbing
> what we just wrote.
>

I don't think so.  I write an event number.  You commit because you
didn't notice.  I haven't loaded yet from the value you wrote when you
committed, so nothing goes wrong.

--Andy
