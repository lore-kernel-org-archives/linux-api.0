From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 08:44:38 -0700
Message-ID: <CALCETrU5ZL6Jajc=9up-j86vY_Xtt-gTFjdQE0sB0d=d-CJZ6A@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
 <20160407120254.GY3448@twins.programming.kicks-ass.net> <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
 <20160407152432.GZ3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407152432.GZ3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 7, 2016 at 8:24 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Apr 07, 2016 at 07:35:26AM -0700, Andy Lutomirski wrote:
>> What I meant was: rather than shoving individual values into the TLABI
>> thing, shove in a pointer:
>>
>> struct commit_info {
>>   u64 post_commit_rip;
>>   u32 cpu;
>>   u64 *event;
>>   // whatever else;
>> };
>>
>> and then put a commit_info* in TLABI.
>>
>> This would save some bytes in the TLABI structure.
>
> But would cost us extra indirections. The whole point was getting this
> stuff at a constant offset from the TLS segment register.

I don't think the extra indirections would matter much.  The kernel
would have to chase the pointer, but only in the very rare case where
it resumes userspace during a commit or on the immediately following
instruction.

At the very least, post_commit_rip and the abort address (which I
forgot about) could both live in a static structure, and shoving a
pointer to *that* into TLABI space is one store instead of two.

Admittedly, this is just a minor tweak either way.  I'm just wondering
an extra indirect variant ends up being slightly faster.

>
>> > So letting the user manage the event is doable, but it would still be
>> > advisable to have the event in the same shared word.
>> >
>>
>> Why is a single load needed?  The event and CPU in the TLABI structure
>> are only ever accessed from the thread in question.
>
> Its not required, but being able to do a single load saves on cycles,
> less cycles is more good.
>
>> That way we could take an async signal, handle it, and resume, even in
>> the middle of a commit, without aborting.  Of course, if the signal
>> hander tried to access the same rseq-protected resource, it would bump
>> the event counter and cause an abort.
>
> Ah, so what happens if the signal happens before the commit but after
> the load of the seqcount?
>
> Then, even if the signal motifies the count, we'll not observe.
>

Where exactly?

In my scheme, nothing except the kernel ever loads the seqcount.  The
user code generates a fresh value, writes it to memory, and then, just
before commit, writes that same value to the TLABI area and then
double-checks that the value it wrote at the beginning is still there.

If the signal modifies the count, then the user code won't directly
notice, but prepare_exit_to_usermode on the way out of the signal will
notice that the (restored) TLABI state doesn't match the counter that
the signal handler changed and will just to the abort address.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
