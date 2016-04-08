From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Fri, 8 Apr 2016 14:25:51 -0700
Message-ID: <CA+55aFwqJmTy+Nz0k9N_2zsms51meTFMdvYYW5VHdiOq8Jjr7Q@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
	<20160407155312.GA3448@twins.programming.kicks-ass.net>
	<CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
	<20160407201156.GC3448@twins.programming.kicks-ass.net>
	<CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ@mail.gmail.com>
	<1802683892.49910.1460077902922.JavaMail.zimbra@efficios.com>
	<CALCETrW5o_VuCrH0eUoT9c+izhyOCvkw2FLOzs5nc_+4Uk5+=g@mail.gmail.com>
	<427613474.49955.1460081105607.JavaMail.zimbra@efficios.com>
	<65466698.51122.1460137589499.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <65466698.51122.1460137589499.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 8, 2016 at 10:46 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> By the way, the debugger can always decide to single-step through the
> first iteration of the rseq, and then after it loops, decide to skip
> single-stepping until the exit points are reached.

A _human_ debugger may decide to do that yes.

But the the debugger _program_ may not be that smart. For example,
let's say that you - as a human - set a few watchpoints. The debugger
will use hardware breakpoints for the first few, but in more complex
cases the debugger will actually say "oops, no more hw breakpoints,
I'll just start single-stepping instead".

The human operator may not even be aware that the debugger has gone
into that slower mode. Normally it's just slower. But you'd want it to
be _only_ slower, not "oops, the program no longer makes any forward
progress at all, because a library that the user didn't even know or
care about - and never sees, because the single-stepping is all
internal = happened to use a code sequence that doesn't work under
single-stepping".

               Linus
