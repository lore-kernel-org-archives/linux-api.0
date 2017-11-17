From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Fri, 17 Nov 2017 17:14:32 +0000 (UTC)
Message-ID: <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos> <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711171107450.1709@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael
List-Id: linux-api@vger.kernel.org

----- On Nov 17, 2017, at 5:09 AM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:

> On Thu, 16 Nov 2017, Andi Kleen wrote:
>> My preference would be just to drop this new super ugly system call.
>> 
>> It's also not just the ugliness, but the very large attack surface
>> that worries me here.
>> 
>> As far as I know it is only needed to support single stepping, correct?
> 
> I can't figure that out because the changelog describes only WHAT the patch
> does and not WHY. Useful, isn't it?
> 
>> Then this whole mess would disappear.
> 
> Agreed. That would be much appreciated.

Let's have a look at why cpu_opv is needed. I'll make sure to enhance the
changelog and documentation to include that information.

1) Handling single-stepping from tools

Tools like debuggers, and simulators like record-replay ("rr") use
single-stepping to run through existing programs. If core libraries start
to use restartable sequences for e.g. memory allocation, this means
pre-existing programs cannot be single-stepped, simply because the
underlying glibc or jemalloc has changed.

The rseq user-space does expose a __rseq_table section for the sake of
debuggers, so they can skip over the rseq critical sections if they want.
However, this requires upgrading tools, and still breaks single-stepping
in case where glibc or jemalloc is updated, but not the tooling.

Having a performance-related library improvement break tooling is likely to
cause a big push-back against wide adoption of rseq. *I* would not even
be using rseq in liburcu and lttng-ust until gdb gets updated in every
distributions that my users depend on. This will likely happen... never.


2) Forward-progress guarantee

Having a piece of user-space code that stops progressing due to
external conditions is pretty bad. We are used to think of fast-path and
slow-path (e.g. for locking), where the contended vs uncontended cases
have different performance characteristics, but each need to provide some
level of progress guarantees.

I'm very concerned about proposing just "rseq" without the associated
slow-path (cpu_opv) that guarantees progress. It's just asking for trouble
when real-life will happen: page faults, uprobes, and other unforeseen
conditions that would seldom cause a rseq fast-path to never progress.


3) Handling page faults

If we get creative enough, it's pretty easy to come up with corner-case
scenarios where rseq does not progress without the help from cpu_opv. For
instance, a system with swap enabled which is under high memory pressure
could trigger page faults at pretty much every rseq attempt. I recognize
that this scenario is extremely unlikely, but I'm not comfortable making
rseq the weak link of the chain here.


4) Comparison with LL/SC

The layman versed in the load-link/store-conditional instructions in
RISC architectures will notice the similarity between rseq and LL/SC
critical sections. The comparison can even be pushed further: since
debuggers can handle those LL/SC critical sections, they should be
able to handle rseq c.s. in the same way.

First, the way gdb recognises LL/SC c.s. patterns is very fragile:
it's limited to specific common patterns, and will miss the pattern
in all other cases. But fear not, having the rseq c.s. expose a
__rseq_table to debuggers removes that guessing part.

The main difference between LL/SC and rseq is that debuggers had
to support single-stepping through LL/SC critical sections from the
get go in order to support a given architecture. For rseq, we're
adding critical sections into pre-existing applications/libraries,
so the user expectation is that tools don't break due to a library
optimization.


5) Perform maintenance operations on per-cpu data

rseq c.s. are quite limited feature-wise: they need to end with a
*single* commit instruction that updates a memory location. On the
other hand, the cpu_opv system call can combine a sequence of operations
that need to be executed with preemption disabled. While slower than
rseq, this allows for more complex maintenance operations to be
performed on per-cpu data concurrently with rseq fast-paths, in cases
where it's not possible to map those sequences of ops to a rseq.


6) Use cpu_opv as generic implementation for architectures not
   implementing rseq assembly code

rseq critical sections require architecture-specific user-space code
to be crafted in order to port an algorithm to a given architecture.
In addition, it requires that the kernel architecture implementation
adds hooks into signal delivery and resume to user-space.

In order to facilitate integration of rseq into user-space, cpu_opv
can provide a (relatively slower) architecture-agnostic implementation
of rseq. This means that user-space code can be ported to all
architectures through use of cpu_opv initially, and have the fast-path
use rseq whenever the asm code is implemented.


7) Allow libraries with multi-part algorithms to work on same per-cpu
   data without affecting the allowed cpu mask

I stumbled on an interesting use-case within the lttng-ust tracer
per-cpu buffers: the algorithm needs to update a "reserve" counter,
serialize data into the buffer, and then update a "commit" counter
_on the same per-cpu buffer_. My goal is to use rseq for both reserve
and commit.

Clearly, if rseq reserve fails, the algorithm can retry on a different
per-cpu buffer. However, it's not that easy for the commit. It needs to
be performed on the same per-cpu buffer as the reserve.

The cpu_opv system call solves that problem by receiving the cpu number
on which the operation needs to be performed as argument. It can push
the task to the right CPU if needed, and perform the operations there
with preemption disabled.

Changing the allowed cpu mask for the current thread is not an acceptable
alternative for a tracing library, because the application being traced
does not expect that mask to be changed by libraries.


So, TLDR: cpu_opv is needed for many use-cases other that single-stepping,
and facilitates adoption of rseq into pre-existing applications.


Thanks,

Mathieu

> 
> Thanks,
> 
> 	tglx

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
