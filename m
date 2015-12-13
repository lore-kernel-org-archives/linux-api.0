From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] thread_local_abi system call: caching current
 CPU number (x86)
Date: Sun, 13 Dec 2015 19:58:48 +0000 (UTC)
Message-ID: <450134747.239045.1450036728930.JavaMail.zimbra@efficios.com>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com> <20151213181527.GV15533@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151213181527.GV15533-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 13, 2015, at 1:15 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:

>> This getcpu cache is an alternative to the sched_getcpu() vdso which has
>> a few benefits:
> 
> 
> Note the first version of getcpu() I proposed had a cache. But it was
> rejected.
> 
>> - It is faster to do a memory read that to call a vDSO,
>> - This cached value can be read from within an inline assembly, which
>>   makes it a useful building block for restartable sequences.
> 
> On x86 we already have the de-facto ABI of using LSL with the magic
> segment directly. While that is a few cycles slower than a memory load
> I question the difference is big enough to justify a new system call,
> and risk slow page fault in context switches.

In the context of restartable sequences [1] [2], the goal is to turn
atomic operations on per-cpu data into a sequence of simple load/store
operations. Therefore, improving getcpu from 12ns to 0.3ns will have a
significant impact there. Those will be used in memory allocators, RCU
read-side in userspace, and tracing fast path, where we can expect
significant speedups even for those few cycles per call.

Moreover, AFAIU, restartable sequences cannot do the function call
required by the  vdso while within the c.s.: those need to entirely fit
within an inline assembly. So this CPU number caching actually enables
restartable sequences, whereas the vdso approach cannot be used in that
context.

Regarding your concern about slow page fault in context switches, this
updated patch takes care of it: the context switch is only setting
TIF_NOTIFY_RESUME, which lets the cache value update be performed on
return to userspace.

Finally, even if overall this new system call is not deemed sufficiently
interesting on x86, other popular architectures such as ARM32 don't have
any vDSO for getcpu at the moment, mainly because they don't have similar
segment selector tricks, and I'm not aware of other solutions than caching
the CPU value for those architectures. So we might very well end up having
to implement this system call for other architectures anyway.

> 
> BTW the vdso could be also optimized I think. For example glibc today
> does some stupid (slow) things with it, like doing double iindirect
> jumps.

I suspect that most of the difference between the vDSO approach and
CPU number caching is simply the function call required for the vDSO.
I doubt there is much to be done on this front.

Thanks,

Mathieu

[1] https://lwn.net/Articles/664645/
[2] https://lkml.org/lkml/2015/10/27/1095

> 
> -Andi

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
