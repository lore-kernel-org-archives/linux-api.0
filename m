From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Fri, 26 Feb 2016 20:24:15 +0000 (UTC)
Message-ID: <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <390571988.7745.1456419326288.JavaMail.zimbra@efficios.com> <20160225170416.GV6356@twins.programming.kicks-ass.net> <2135602720.7810.1456420671941.JavaMail.zimbra@efficios.com> <20160226113304.GA6356@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1602261719440.3638@nanos> <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com> <alpine.DEB.2.11.1602261855100.3638@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1602261855100.3638@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Feb 26, 2016, at 1:01 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Fri, 26 Feb 2016, Mathieu Desnoyers wrote:
>> ----- On Feb 26, 2016, at 11:29 AM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
>> > Right. There is no point in having two calls and two update mechanisms for a
>> > very similar purpose.
>> > 
>> > So let userspace have one struct where cpu/seq and whatever is required for
>> > rseq is located and flag at register time which parts of the struct need to be
>> > updated.
>> 
>> If we put both cpu/seq/other in that structure, why not plan ahead and make
>> it extensible then ?
>> 
>> That looks very much like the "Thread-local ABI" series I posted last year.
>> See https://lkml.org/lkml/2015/12/22/464
>> 
>> Here is why I ended up introducing the specialized "getcpu_cache" system call
>> rather than the "generic" system call (quote from the getcpu_cache changelog):
>> 
>>     Rationale for the getcpu_cache system call rather than the thread-local
>>     ABI system call proposed earlier:
>>     
>>     Rather than doing a "generic" thread-local ABI, specialize this system
>>     call for a cpu number cache only. Anyway, the thread-local ABI approach
>>     would have required that we introduce "feature" flags, which would have
>>     ended up reimplementing multiplexing of features on top of a system
>>     call. It seems better to introduce one system call per feature instead.
>> 
>> If everyone end up preferring that we introduce a system call that implements
>> many features at once, that's indeed something we can do, but I remember
>> being told in the past that this is generally a bad idea.
> 
> It's a bad idea if you mix stuff which does not belong together, but if you
> have stuff which shares a substantial amount of things then it makes a lot of
> sense. Especially if it adds similar stuff into hotpathes.
> 
>> For one thing, it would make the interface more cumbersome to deal with
>> from user-space in terms of feature detection: if we want to make this
>> interface extensible, in addition to check -1, errno=ENOSYS, userspace
>> would have to deal with a field containing the length of the structure
>> as expected by user-space and kernel, and feature flags to see the common
>> set of features supported by kernel and user-space.
>>
>> Having one system call per feature seems simpler to handle in terms of
>> feature availability detection from a userspace point of view.
> 
> That might well be, but that does not justify two fastpath updates, two
> seperate pointers to handle, etc ....

Keeping two separate pointers in the task_struct rather than a single one
might indeed be unwelcome, but I'm not sure I fully grasp the fast path
argument in this case: getcpu_cache only sets a notifier thread flag
on thread migration, whereas AFAIU rseq adds code to context switch and signal
delivery, which are prone to have a higher impact.

Indeed both will have their own code in the resume notifier, but is it really
a fast path ?

>From my point of view, making it easy for userspace to just enable getcpu_cache
without having the scheduler and signal delivery fast-path overhead of rseq seems
like a good thing. I'm not all that sure that saving an extra pointer in
task_struct justifies the added system call interface complexity.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
