From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical
 sections
Date: Mon, 25 May 2015 18:30:13 +0000 (UTC)
Message-ID: <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com> <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com> <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com> <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com> <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com> <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com> <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- Original Message -----
> On May 23, 2015 10:09 AM, "Mathieu Desnoyers"
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> >
> > ----- Original Message -----
> > > On Fri, May 22, 2015 at 2:34 PM, Mathieu Desnoyers
> > > <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> > > > ----- Original Message -----
> > > >> On Fri, May 22, 2015 at 1:26 PM, Michael Kerrisk
> > > >> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > >> wrote:
> > > >> > [CC += linux-api@]
> > > >> >
> > > >> > On Thu, May 21, 2015 at 4:44 PM, Mathieu Desnoyers
> > > >> > <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> > > >> >> Expose a new system call allowing userspace threads to register
> > > >> >> a TLS area used as an ABI between the kernel and userspace to
> > > >> >> share information required to create efficient per-cpu critical
> > > >> >> sections in user-space.
> > > >> >>
> > > >> >> This ABI consists of a thread-local structure containing:
> > > >> >>
> > > >> >> - a nesting count surrounding the critical section,
> > > >> >> - a signal number to be sent to the thread when preempting a thread
> > > >> >>   with non-zero nesting count,
> > > >> >> - a flag indicating whether the signal has been sent within the
> > > >> >>   critical section,
> > > >> >> - an integer where to store the current CPU number, updated
> > > >> >> whenever
> > > >> >>   the thread is preempted. This CPU number cache is not strictly
> > > >> >>   needed, but performs better than getcpu vdso.
> > > >> >>
> > > >> >> This approach is inspired by Paul Turner and Andrew Hunter's work
> > > >> >> on percpu atomics, which lets the kernel handle restart of critical
> > > >> >> sections, ref.
> > > >> >> http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
> > > >> >>
> > > >> >> What is done differently here compared to percpu atomics: we track
> > > >> >> a single nesting counter per thread rather than many ranges of
> > > >> >> instruction pointer values. We deliver a signal to user-space and
> > > >> >> let the logic of restart be handled in user-space, thus moving
> > > >> >> the complexity out of the kernel. The nesting counter approach
> > > >> >> allows us to skip the complexity of interacting with signals that
> > > >> >> would be otherwise needed with the percpu atomics approach, which
> > > >> >> needs to know which instruction pointers are preempted, including
> > > >> >> when preemption occurs on a signal handler nested over an
> > > >> >> instruction
> > > >> >> pointer of interest.
> > > >> >>
> > > >>
> > > >> I talked about this kind of thing with PeterZ at LSF/MM, and I was
> > > >> unable to convince myself that the kernel needs to help at all.  To do
> > > >> this without kernel help, I want to relax the requirements slightly.
> > > >> With true per-cpu atomic sections, you have a guarantee that you are
> > > >> either really running on the same CPU for the entire duration of the
> > > >> atomic section or you abort.  I propose a weaker primitive: you
> > > >> acquire one of an array of locks (probably one per cpu), and you are
> > > >> guaranteed that, if you don't abort, no one else acquires the same
> > > >> lock while you hold it.
> > > >
> > > > In my proof of concept (https://github.com/compudj/percpu-dev) I
> > > > actually implement an array of per-cpu lock. The issue here boils
> > > > down to grabbing this per-cpu lock efficiently. Once the lock is taken,
> > > > the thread has exclusive access to that per-cpu lock, even if it
> > > > migrates.
> > > >
> > > >>  Here's how:
> > > >>
> > > >> Create an array of user-managed locks, one per cpu.  Call them lock[i]
> > > >> for 0 <= i < ncpus.
> > > >>
> > > >> To acquire, look up your CPU number.  Then, atomically, check that
> > > >> lock[cpu] isn't held and, if so, mark it held and record both your tid
> > > >> and your lock acquisition count.  If you learn that the lock *was*
> > > >> held after all, signal the holder (with kill or your favorite other
> > > >> mechanism), telling it which lock acquisition count is being aborted.
> > > >> Then atomically steal the lock, but only if the lock acquisition count
> > > >> hasn't changed.
> > > >>
> > > >> This has a few benefits over the in-kernel approach:
> > > >>
> > > >> 1. No kernel patch.
> > > >>
> > > >> 2. No unnecessary abort if you are preempted in favor of a thread that
> > > >> doesn't content for your lock.
> > > >>
> > > >> 3. Greatly improved debuggability.
> > > >>
> > > >> 4. With long critical sections and heavy load, you can improve
> > > >> performance by having several locks per cpu and choosing one at
> > > >> random.
> > > >>
> > > >> Is there a reason that a scheme like this doesn't work?
> > > >
> > > > What do you mean exactly by "atomically check that lock is not
> > > > held and, if so, mark it held" ? Do you imply using a lock-prefixed
> > > > atomic operation ?
> > >
> > > Yes.
> > >
> > > >
> > > > The goal of this whole restart section approach is to allow grabbing
> > > > a lock (or doing other sequences of operations ending with a single
> > > > store) on per-cpu data without having to use slow lock-prefixed
> > > > atomic operations.
> > >
> > > Ah, ok, I assumed it was to allow multiple threads to work in parallel.
> > >
> > > How arch-specific are you willing to be?
> >
> > I'd want this to be usable on every major architectures.
> >
> > > On x86, it might be possible
> > > to play some GDT games so that an unlocked xchg relative
> >
> > AFAIK, there is no such thing as an unlocked xchg. xchg always
> > imply the lock prefix on x86. I guess you mean cmpxchg here.
> >
> 
> Right, got my special cases mixed up.
> 
> I wonder if we could instead have a vdso function that did something like:
> 
> unsigned long __vdso_cpu_local_exchange(unsigned long *base, int
> shift, unsigned long newval)
> {
>   unsigned long *ptr = base + (cpu << shift);
>   unsigned long old = *ptr;
>   *ptr = new;
>   return *ptr;
> }
> 
> I think this primitive would be sufficient to let user code do the
> rest.  There might be other more simple primitives that would work.
> It could be implemented by fiddling with IP ranges, but we could
> change the implementation later without breaking anything.  The only
> really hard part would be efficiently figuring out what CPU we're on.

The "fiddling with IP ranges" is where the restart sections come into
play. Paul Turner's approach indeed knows about IP ranges, and performs
the restart from the kernel. My alternative approach uses a signal and
page protection in user-space to reach the same result. It appears that
CONFIG_PREEMPT kernels are difficult to handle with Paul's approach, so
perhaps we could combine our approaches to get the best of both.

> 
> FWIW, 'xchg' to cache-hot memory is only about 20 cycles on my laptop,
> and cmpxchg seems to be about 6 cycles.  Both are faster than getcpu.
> How much are we really saving with any of this over the pure userspace
> approach?  I think that the most that the kernel can possibly help us
> is to give us a faster getcpu and to help us deal with being migrated
> to a different cpu if we want to avoid expensive operations and don't
> want to play unlocked cmpxchg tricks.

You appear to summarize the two things that are added to the kernel with
this RFC patch:
- faster getcpu(): 12.7 ns -> 0.3 ns
- allow using less expensive operations to perform per-cpu-atomic ops:
  (on my system):
  - lock; cmpxchg (18 ns) -> load-test-branch-store (5.4 ns)

> 
> I was wrong about set_thread_area giving us efficient per-cpu data,
> BTW, although it would be easy to add a similar feature that would
> give us a per-cpu segment base on x86.

ok

> 
> > > to gs would
> > > work if you arranged for gs to refer to the GDT.  On 32-bit userspace,
> > > you can do this with set_thread_area and on 64-bit userspace you can
> > > do it with arch_prctl.  You'd be relying on nothing else in the
> > > process using gs, but your proposal already relies on nothing else in
> > > the process using your signal number.
> >
> > Ideally, and this is indeed a limitation of my own approach, I would
> > like to be able to use this scheme from a library injected into
> > processes for tracing purposes, which means that I would be tempted
> > to stay away from solutions that affect the application too much.
> > This includes sending a signal unfortunately.
> >
> > In addition, the gs approach you propose here would work as long
> > as we use non-lock-prefixed atomic operations (e.g. cmpxchg), but
> > it would not work for sequences of instructions that need to be
> > performed over the same data (e.g. load, test, conditional branch,
> > store), which performs slightly faster than non-lock-prefixed atomic
> > ops.
> >
> 
> > > >> >> - With Linux vdso:            12.7 ns
> > > >> >> - With TLS-cached cpu number:  0.3 ns
> > > >>
> > > >> Slightly off-topic: try this again on a newer kernel.  The vdso should
> > > >> have gotten a bit faster in 3.19 or 4.0 IIRC.
> > > >
> > > > Those benchmarks were done on Linux 4.0.
> > >
> > > What cpu?  I'm surprised it's that bad.
> >
> > Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
> > (Haswell)
> > Please note that I run this benchmark under a kvm guest VM, but
> > I doubt it would impact these numbers.
> 
> Go figure.  My laptop (SNB, 2.7GHz) can do it in 8ns or so.
> 
> >
> > > (TLS-cached will always be
> > > better, but still.  Although I'm curious how you're making the
> > > TLS-cached value work reliably enough.)
> >
> > What do you have in mind as possibility of having an unreliable TLS-cached
> > value ?
> 
> Something like the old vdso getcpu cache -- re-read the cpu count if
> it has expired since last time.
> 
> > In my approach, the tls-cached value is updated in the preempt in
> > notifier, whenever the CPU number has changed compared to the value in
> > user-space.
> 
> Ah, I missed that part.
> 
> This ABI is kind of unfortunate in that it can't be shared between
> multiple libraries.

Well ideally you'd want one library to implement this (e.g. glibc), and
other libraries to use it. I'm not sure doing a linked list of TLS entries
per thread would really be useful here.

> 
> Accessing the TLS value from user-space is performed with the
> > help of the compiler, including all the complexity involved in using a
> > TLS from a library if need be (lazy allocation, internal glibc mutex, etc).
> > However, since I control very precisely where in my critical section the
> > execution flow can be restarted (it's only on the store operation that
> > touch the write-protected memory range), there is no need to worry about
> > restarting in the middle of a held lock. It also works if a system call
> > is issued within the critical section (e.g. sys_futex due to lock), and
> > works with function calls.
> 
> Oh, you're delivering a signal every time you're preempted, even
> outside the critical section?  That sounds expensive.

No, the signal is only delivered if the kernel preempts the critical
section.

Thanks for the feedback!

Mathieu

> 
> --Andy
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
