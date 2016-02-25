From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Thu, 25 Feb 2016 16:55:26 +0000 (UTC)
Message-ID: <390571988.7745.1456419326288.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com> <20160225095635.GO6356@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160225095635.GO6356-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Feb 25, 2016, at 4:56 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Feb 23, 2016 at 06:28:36PM -0500, Mathieu Desnoyers wrote:
>> This approach is inspired by Paul Turner and Andrew Hunter's work
>> on percpu atomics, which lets the kernel handle restart of critical
>> sections. [1] [2]
> 
> So I'd like a few extra words on the intersection with that work.
> 
> Yes, that also needs a CPU number, but that needs a little extra as
> well. Can this work be extended to provide the little extra and is the
> getcpu name still sane in that case?
> 
> Alternatively, could you not, at equal speed, get the CPU number from
> the restartable sequence data?
> 
> That is, do explain why we want both.

Paul Turner's percpu atomics (restartable sequences) allow
turning atomic instructions (e.g. LOCK; cmpxchg on x86) meant
to update userspace per-cpu data into a sequence of instructions
that end with a single commit instruction. The primary use-case
for this is for implementing efficient memory allocators with
per-cpu memory pools (rather than global or per-thread pools).

This is made possible with the collaboration between kernel and
user-space, where user-space marks the surrounding of this "rseq"
critical section, and the kernel moves the instruction pointer
to a restart address (also published by user-space) if it
preempts/migrates/delivers a signal over that critical section.

The benefit of those restartable sequences over atomic instructions
is that it is much faster to execute a sequence of simple non-atomic
instructions (e.g. load, test, cond. branch, store) than a single
atomic instruction.

The restartable sequences are intrinsically designed to work
on per-cpu data, so they need to fetch the current CPU number
within the rseq critical section. This is where the getcpu_cache
system call becomes very useful when combined with rseq:
getcpu_cache allows reading the current CPU number in a
fraction of cycle.

However, there are other use-cases for having a fast mechanism
for reading the current CPU number, besides restartable sequences.
For instance, it can be used by glibc to implement a faster
sched_getcpu. Therefore, implementing getcpu_cache as its own
system call makes sense: an architecture could very well just
introduce getcpu_cache even if it cannot support restartable
sequences for some reason. Also, a kernel configuration can
enable getcpu_cache (since it has no effect on the scheduler
switch time, only migration) without enabling restartable
sequences.

The main reason why I decided to start working on getcpu_cache
is because I noticed that the restartable sequences system
call originally proposed by Paul Turner was trying to accomplish
too much at once: both handling of restartable sequences, and
quickly reading the current CPU number. My thinking is that
the issue of reading the current CPU number could be completely
taken out of the rseq picture by having rseq rely on the
address registered by getcpu_cache to read the CPU number.
This would therefore simplify the implementation of rseq,
and allow us to focus the rseq review discussions without
being side-tracked on the simpler problem of quickly reading
the current CPU number.

> 
> (And remind Paul to keep pushing that)

Indeed, I look forward to Paul's feedback on my review of his
last patchset round. Hopefully this getcpu_cache work will
allow us to better focus the discussions on rseq work.

Is the explanation above OK for you ? I'll add it to the
Changelog in v5 of the getcpu_cache series if so.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
