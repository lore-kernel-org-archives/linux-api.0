From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Thu, 25 Aug 2016 17:08:32 +0000 (UTC)
Message-ID: <545371402.19191.1472144912215.JavaMail.zimbra@efficios.com>
References: <1471637274-13583-1-git-send-email-mathieu.desnoyers@efficios.com> <1471637274-13583-2-git-send-email-mathieu.desnoyers@efficios.com> <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFz+Q33m1+ju3ANaznBwYCcWo9D9WDr2=p0YLEF4gJF12g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manp>
List-Id: linux-api@vger.kernel.org

----- On Aug 19, 2016, at 4:23 PM, Linus Torvalds torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:

> On Fri, Aug 19, 2016 at 1:07 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Benchmarking various approaches for reading the current CPU number:
> 
> So I'd like to see the benchmarks of something that actually *does* something.
> 
> IOW, what's the bigger-picture "this is what it actually is useful
> for, and how it speeds things up".
> 
> Nobody gets a cpu number just to get a cpu number - it's not a useful
> thing to benchmark. What does getcpu() so much that we care?
> 
> We've had tons of clever features that nobody actually uses, because
> they aren't really portable enough. I'd like to be convinced that this
> is actually going to be used by real applications.

I completely agree with your request for real-life application numbers.

The most appealing application we have so far is Dave Watson's Facebook
services using jemalloc as a memory allocator. It would be nice if he
could re-run those benchmarks with my rseq implementation. The trade-offs
here are about speed and memory usage:

1) single process-wide pool:
   - speed: does not scale well to many-cores,
   + efficient use of memory.
2) per-thread pools:
   + speed: scales really well to many-cores,
   - inefficient use of memory.
3) per-cpu pools without rseq:
   - speed: requires atomic instructions due to migration and preemption,
   + efficient use of memory.
4) per-cpu pools with rseq:
   + speed: no atomic instructions required,
   + efficient use of memory.

His benchmarks should confirm that we get best of speed and
memory use with (4).

I plan to personally start working on integrating rseq with
the lttng-ust user-space tracer per-CPU ring buffer, but
I expect to mainly publish microbenchmarks, as most of
our heavy tracing users are proprietary applications, for
which it's tricky to publish numbers. I suspect that
microbenchmarks are not what you are looking for here.

Boqun Feng expressed interested in working on a
userspace RCU flavor that would implement per-CPU
(rather than per-thread) grace period tracking. I suspect
this will be a rather large undertaking. The benefits
should be visible as grace period overhead and speed
in applications that have many more threads than cores.

Paul Turner from Google probably have interesting numbers too,
but I suspect he is busy on other projects at the moment.

Let's see if we can get Dave Watson to provide those numbers.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
