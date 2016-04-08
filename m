From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space
 percpu critical sections
Date: Fri, 8 Apr 2016 01:11:42 +0000 (UTC)
Message-ID: <1802683892.49910.1460077902922.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com> <20160407152432.GZ3448@twins.programming.kicks-ass.net> <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com> <20160407155312.GA3448@twins.programming.kicks-ass.net> <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com> <20160407201156.GC3448@twins.programming.kicks-ass.net> <CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 7, 2016, at 6:05 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

> On Thu, Apr 7, 2016 at 1:11 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Thu, Apr 07, 2016 at 09:43:33AM -0700, Andy Lutomirski wrote:
[...]
>>
>>> it's inherently debuggable,
>>
>> It is more debuggable, agreed.
>>
>>> and it allows multiple independent
>>> rseq-protected things to coexist without forcing each other to abort.

[...]

My understanding is that the main goal of this rather more complex
proposal is to make interaction with debuggers more straightforward in
cases of single-stepping through the rseq critical section.

I recently came up with a scheme that should allow us to handle such
situations in a fashion similar to debuggers handling ll/sc
restartable sequences of instructions on e.g. powerpc. The good news
is that my scheme does not require anything at the kernel level.

The idea is simple: the userspace rseq critical sections now
become marked by 3 inline functions (rather than 2 in Paul's proposal):

rseq_start(void *rseq_key)
rseq_finish(void *rseq_key)
rseq_abort(void *rseq_key)

We associate each critical section with a unique "key" (dummy
1 byte object in the process address space), so we can group
them. The new "rseq_abort" would mark exit points that would
exit the critical section without executing the final commit
instruction.

Within each of rseq_start, rseq_finish and rseq_abort,
we declare a non-loadable section that gets populated
with the following tuples:

(RSEQ_TYPE, insn address, rseq_key)

Where RSEQ_TYPE is either RSEQ_START, RSEQ_FINISH, or RSEQ_ABORT.

That special section would be found in the executable by the
debugger, which can then skip over entire restartable critical
sections when it encounters them by placing breakpoints at
all exit points (finish and cancel) associated to the same
rseq_key as the entry point (start).

This way we don't need to complexify the runtime code, neither
at kernel nor user-space level, and we get debuggability using
a trick similar to what ll/sc architectures already need to do.

Of course, this requires extending gdb, which should not be
a show-stopper.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
