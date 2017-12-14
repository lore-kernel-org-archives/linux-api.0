From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.16 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 14 Dec 2017 18:12:57 +0000 (UTC)
Message-ID: <12046460.34426.1513275177081.JavaMail.zimbra@efficios.com>
References: <20171214161403.30643-1-mathieu.desnoyers@efficios.com> <20171214161403.30643-3-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1712141033100.6249@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 14, 2017, at 11:44 AM, Chris Lameter cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org wrote:

> On Thu, 14 Dec 2017, Mathieu Desnoyers wrote:
> 
>> On x86, yet another possible approach would be to use the gs segment
>> selector to point to user-space per-cpu data. This approach performs
>> similarly to the cpu id cache, but it has two disadvantages: it is
>> not portable, and it is incompatible with existing applications already
>> using the gs segment selector for other purposes.
> 
> I think the proper way to think about gs and fs on x86 is as base
> registers. They are essentially values in registers added to the address
> generated in an instruction. As such the approach is transferable to other
> processor architecture. Many support base register and base register
> relative processing. If a processor can do RMV instructions base register
> relative then you have something similar.

How would you do it on ARM32 ?

> 
> In a restartable sequence you could increase efficieny by avoiding full
> atomic instructions. This would be similar to the lockless RMV available
> on x86 then. And in that form it is portable.
> 
> A context switch to another processors would mean that the value of the
> base register has changed and that we therefore are accessing another per
> cpu segment. Restarting the sequence will yield a correct result without
> any reloading of registers.

As a concrete example, let's try to apply your proposal on a common use-case:
a compare-and-store on user-space per-cpu data.

With my rseq proposal the fast-path pseudo-code boils down to:

load TLS::cpu_id_start into reg_X
add reg_X offset to base to find target v
store pointer to TLS::rseq_cs
compare reg_X against TLS::cpu_id
jne abort
cmp *v, value
jne cmpfail
store newval to *v

My benchmark on Intel x86-64 E5-2630 shows that it takes 1.9 ns/iteration
for a test-case incrementing a counter with this rseq compare-and-store
sequence.

Let's assume we can reserve the gs segment selector for use in user-space,
and that the per-cpu data layout allows using this segment selector as offset.
The compare-and-store use-case would require a "cmpxchg" instruction with
a gs segment selector.

A single-threaded test-case which uses non-lock-prefixed cmpxchg in a loop
on a E5-2630, I get 2.8 ns/iteration. (no per-cpu data involved, done on a single
global value)

One benefit of your proposal is to lessen the number of retired instructions,
but if we take the IPC into account, it is slower than rseq in my benchmark. What
benefits do you expect from using segment selectors and non-lock-prefixed atomic
instructions on the fast-path ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
