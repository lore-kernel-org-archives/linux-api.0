From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 18:21:10 -0700
Message-ID: <CALCETrW5o_VuCrH0eUoT9c+izhyOCvkw2FLOzs5nc_+4Uk5+=g@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net> <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
 <20160407155312.GA3448@twins.programming.kicks-ass.net> <CALCETrVGo1Di3qamxx1NAFUSN_o=-HnYRDpeVp7zrQEBwe5u-g@mail.gmail.com>
 <20160407201156.GC3448@twins.programming.kicks-ass.net> <CALCETrXVReuuGGKW6EOV7tFFaK9RbwWxYvKdpUdvU=MpDaOtsQ@mail.gmail.com>
 <1802683892.49910.1460077902922.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1802683892.49910.1460077902922.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Paul Turner <commonly@gmail.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, linux-api <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Hunter <ahh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 6:11 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Apr 7, 2016, at 6:05 PM, Andy Lutomirski luto@amacapital.net wrote:
>
>> On Thu, Apr 7, 2016 at 1:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Thu, Apr 07, 2016 at 09:43:33AM -0700, Andy Lutomirski wrote:
> [...]
>>>
>>>> it's inherently debuggable,
>>>
>>> It is more debuggable, agreed.
>>>
>>>> and it allows multiple independent
>>>> rseq-protected things to coexist without forcing each other to abort.
>
> [...]
>
> My understanding is that the main goal of this rather more complex
> proposal is to make interaction with debuggers more straightforward in
> cases of single-stepping through the rseq critical section.

The things I like about my proposal are both that you can single-step
through it just like any other code as long as you pin the thread to a
CPU and that it doesn't make preemption magical.  (Of course, you can
*force* it to do something on resume and/or preemption by sticking a
bogus value in the expected event count field, but that's not the
intended use.  Hmm, I guess it does need to hook preemption and/or
resume for all processes that enable the thing so it can know to check
for an enabled post_commit_rip, just like all the other proposals.)

Also, mine lets you have a fairly long-running critical section that
doesn't get aborted under heavy load and can interleave with other
critical sections that don't conflict.

>
> I recently came up with a scheme that should allow us to handle such
> situations in a fashion similar to debuggers handling ll/sc
> restartable sequences of instructions on e.g. powerpc. The good news
> is that my scheme does not require anything at the kernel level.
>
> The idea is simple: the userspace rseq critical sections now
> become marked by 3 inline functions (rather than 2 in Paul's proposal):
>
> rseq_start(void *rseq_key)
> rseq_finish(void *rseq_key)
> rseq_abort(void *rseq_key)

How do you use this thing?  What are its semantics?

--Andy

>
> We associate each critical section with a unique "key" (dummy
> 1 byte object in the process address space), so we can group
> them. The new "rseq_abort" would mark exit points that would
> exit the critical section without executing the final commit
> instruction.
>
> Within each of rseq_start, rseq_finish and rseq_abort,
> we declare a non-loadable section that gets populated
> with the following tuples:
>
> (RSEQ_TYPE, insn address, rseq_key)
>
> Where RSEQ_TYPE is either RSEQ_START, RSEQ_FINISH, or RSEQ_ABORT.
>
> That special section would be found in the executable by the
> debugger, which can then skip over entire restartable critical
> sections when it encounters them by placing breakpoints at
> all exit points (finish and cancel) associated to the same
> rseq_key as the entry point (start).
>
> This way we don't need to complexify the runtime code, neither
> at kernel nor user-space level, and we get debuggability using
> a trick similar to what ll/sc architectures already need to do.
>
> Of course, this requires extending gdb, which should not be
> a show-stopper.
>
> Thoughts ?
>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com



-- 
Andy Lutomirski
AMA Capital Management, LLC
