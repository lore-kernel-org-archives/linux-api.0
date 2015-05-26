From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Tue, 26 May 2015 13:58:50 -0700
Message-ID: <CALCETrWuOp3ZERae=OwkfuHkZNMgiuyij7+gTPMzxhxpSOKGtA@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com>
 <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com>
 <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com>
 <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com>
 <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
 <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
 <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com> <933886515.8478.1432672739485.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <933886515.8478.1432672739485.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 26, 2015 at 1:38 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- Original Message -----
>> [cc: hpa, Borislav and Andi]
>>
>> On Mon, May 25, 2015 at 11:30 AM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> > ----- Original Message -----
>> >> On May 23, 2015 10:09 AM, "Mathieu Desnoyers"
>> >> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> >> >
>> >> > ----- Original Message -----
>> >> > > On Fri, May 22, 2015 at 2:34 PM, Mathieu Desnoyers
>> >> > > <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> >> > > > ----- Original Message -----
>> >> > > >> On Fri, May 22, 2015 at 1:26 PM, Michael Kerrisk
>> >> > > >> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> > > >> wrote:
>> >> > > >> > [CC += linux-api@]
>> >> > > >> >
>> >> > > >> > On Thu, May 21, 2015 at 4:44 PM, Mathieu Desnoyers
>> >> > > >> > <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> >> > > >> >> Expose a new system call allowing userspace threads to register
>> >> > > >> >> a TLS area used as an ABI between the kernel and userspace to
>> >> > > >> >> share information required to create efficient per-cpu critical
>> >> > > >> >> sections in user-space.
>> >> > > >> >>
>> >> > > >> >> This ABI consists of a thread-local structure containing:
>> >> > > >> >>
>> >> > > >> >> - a nesting count surrounding the critical section,
>> >> > > >> >> - a signal number to be sent to the thread when preempting a
>> >> > > >> >> thread
>> >> > > >> >>   with non-zero nesting count,
>> >> > > >> >> - a flag indicating whether the signal has been sent within the
>> >> > > >> >>   critical section,
>> >> > > >> >> - an integer where to store the current CPU number, updated
>> >> > > >> >> whenever
>> >> > > >> >>   the thread is preempted. This CPU number cache is not strictly
>> >> > > >> >>   needed, but performs better than getcpu vdso.
>> >> > > >> >>
>> >> > > >> >> This approach is inspired by Paul Turner and Andrew Hunter's
>> >> > > >> >> work
>> >> > > >> >> on percpu atomics, which lets the kernel handle restart of
>> >> > > >> >> critical
>> >> > > >> >> sections, ref.
>> >> > > >> >> http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
>> >> > > >> >>
>> >> > > >> >> What is done differently here compared to percpu atomics: we
>> >> > > >> >> track
>> >> > > >> >> a single nesting counter per thread rather than many ranges of
>> >> > > >> >> instruction pointer values. We deliver a signal to user-space
>> >> > > >> >> and
>> >> > > >> >> let the logic of restart be handled in user-space, thus moving
>> >> > > >> >> the complexity out of the kernel. The nesting counter approach
>> >> > > >> >> allows us to skip the complexity of interacting with signals
>> >> > > >> >> that
>> >> > > >> >> would be otherwise needed with the percpu atomics approach,
>> >> > > >> >> which
>> >> > > >> >> needs to know which instruction pointers are preempted,
>> >> > > >> >> including
>> >> > > >> >> when preemption occurs on a signal handler nested over an
>> >> > > >> >> instruction
>> >> > > >> >> pointer of interest.
>> >> > > >> >>
>> >> > > >>
>> >> > > >> I talked about this kind of thing with PeterZ at LSF/MM, and I was
>> >> > > >> unable to convince myself that the kernel needs to help at all.  To
>> >> > > >> do
>> >> > > >> this without kernel help, I want to relax the requirements
>> >> > > >> slightly.
>> >> > > >> With true per-cpu atomic sections, you have a guarantee that you
>> >> > > >> are
>> >> > > >> either really running on the same CPU for the entire duration of
>> >> > > >> the
>> >> > > >> atomic section or you abort.  I propose a weaker primitive: you
>> >> > > >> acquire one of an array of locks (probably one per cpu), and you
>> >> > > >> are
>> >> > > >> guaranteed that, if you don't abort, no one else acquires the same
>> >> > > >> lock while you hold it.
>> >> > > >
>> >> > > > In my proof of concept (https://github.com/compudj/percpu-dev) I
>> >> > > > actually implement an array of per-cpu lock. The issue here boils
>> >> > > > down to grabbing this per-cpu lock efficiently. Once the lock is
>> >> > > > taken,
>> >> > > > the thread has exclusive access to that per-cpu lock, even if it
>> >> > > > migrates.
>> >> > > >
>> >> > > >>  Here's how:
>> >> > > >>
>> >> > > >> Create an array of user-managed locks, one per cpu.  Call them
>> >> > > >> lock[i]
>> >> > > >> for 0 <= i < ncpus.
>> >> > > >>
>> >> > > >> To acquire, look up your CPU number.  Then, atomically, check that
>> >> > > >> lock[cpu] isn't held and, if so, mark it held and record both your
>> >> > > >> tid
>> >> > > >> and your lock acquisition count.  If you learn that the lock *was*
>> >> > > >> held after all, signal the holder (with kill or your favorite other
>> >> > > >> mechanism), telling it which lock acquisition count is being
>> >> > > >> aborted.
>> >> > > >> Then atomically steal the lock, but only if the lock acquisition
>> >> > > >> count
>> >> > > >> hasn't changed.
>> >> > > >>
>> >> > > >> This has a few benefits over the in-kernel approach:
>> >> > > >>
>> >> > > >> 1. No kernel patch.
>> >> > > >>
>> >> > > >> 2. No unnecessary abort if you are preempted in favor of a thread
>> >> > > >> that
>> >> > > >> doesn't content for your lock.
>> >> > > >>
>> >> > > >> 3. Greatly improved debuggability.
>> >> > > >>
>> >> > > >> 4. With long critical sections and heavy load, you can improve
>> >> > > >> performance by having several locks per cpu and choosing one at
>> >> > > >> random.
>> >> > > >>
>> >> > > >> Is there a reason that a scheme like this doesn't work?
>> >> > > >
>> >> > > > What do you mean exactly by "atomically check that lock is not
>> >> > > > held and, if so, mark it held" ? Do you imply using a lock-prefixed
>> >> > > > atomic operation ?
>> >> > >
>> >> > > Yes.
>> >> > >
>> >> > > >
>> >> > > > The goal of this whole restart section approach is to allow grabbing
>> >> > > > a lock (or doing other sequences of operations ending with a single
>> >> > > > store) on per-cpu data without having to use slow lock-prefixed
>> >> > > > atomic operations.
>> >> > >
>> >> > > Ah, ok, I assumed it was to allow multiple threads to work in
>> >> > > parallel.
>> >> > >
>> >> > > How arch-specific are you willing to be?
>> >> >
>> >> > I'd want this to be usable on every major architectures.
>> >> >
>> >> > > On x86, it might be possible
>> >> > > to play some GDT games so that an unlocked xchg relative
>> >> >
>> >> > AFAIK, there is no such thing as an unlocked xchg. xchg always
>> >> > imply the lock prefix on x86. I guess you mean cmpxchg here.
>> >> >
>> >>
>> >> Right, got my special cases mixed up.
>> >>
>> >> I wonder if we could instead have a vdso function that did something like:
>> >>
>> >> unsigned long __vdso_cpu_local_exchange(unsigned long *base, int
>> >> shift, unsigned long newval)
>> >> {
>> >>   unsigned long *ptr = base + (cpu << shift);
>> >>   unsigned long old = *ptr;
>> >>   *ptr = new;
>> >>   return *ptr;
>> >> }
>> >>
>> >> I think this primitive would be sufficient to let user code do the
>> >> rest.  There might be other more simple primitives that would work.
>> >> It could be implemented by fiddling with IP ranges, but we could
>> >> change the implementation later without breaking anything.  The only
>> >> really hard part would be efficiently figuring out what CPU we're on.
>> >
>> > The "fiddling with IP ranges" is where the restart sections come into
>> > play. Paul Turner's approach indeed knows about IP ranges, and performs
>> > the restart from the kernel. My alternative approach uses a signal and
>> > page protection in user-space to reach the same result. It appears that
>> > CONFIG_PREEMPT kernels are difficult to handle with Paul's approach, so
>> > perhaps we could combine our approaches to get the best of both.
>>
>> I'm not sure why CONFIG_PREEMPT would matter.  What am I missing?
>
> With CONFIG_PREEMPT, the scheduler can preempt the kernel while
> it's running a page fault, or a system call, on behalf of a thread.
>
> So in addition of having to check which instruction pointer is preempted,
> and which IP is having a signal delivered on, we may need to add a check
> when entering into the kernel on pretty much every path, including
> page faults and system calls. I presume the interrupt handler is OK,
> provided that interrupt handlers cannot be preempted, and that the explicit
> preempt check is done before the interrupt handler returns to user-space,
> AFAIU passing the user-space pt_regs, which should be OK already.
>
> I may very have missed other subtleties of issues related to pjt's approach
> with CONFIG_PREEMPT. Hopefully he can enlighten us with the missing parts.

Oh, right.

FWIW, we don't really have accurate tracking of the original user
state before the outermost nested entry.  There's perf_get_regs_user,
but that's a hack.  On the other hand, we only care about potentially
preemptable entries, so no NMI, but even machine checks can sort of
sleep these days (even on non-CONFIG_PREEMPT).

Yuck.

>
>>
>> Doing this in the vdso has some sneaky benefits: rather than aborting
>> a very short vdso-based primitive on context switch, we could just fix
>> it up in the kernel and skip ahead to the end.
>
> The fixup rather than restart idea is quite interesting. However, it may
> require to do the fixup in the kernel before being migrated, and I'm not
> sure it's that easy to find a preemptable spot where we can do the user
> accesses needed for the fixup before migration.

Isn't schedule() itself a reasonable spot?  We could wrap it in
pagefault_disable() and presumably find some reasonable way to retry
if the fault fails.  We also might not need user vm access at all --
pt_regs could be sufficient.  But the same CONFIG_PREEMPT caveat
applies, I think.

> One advantage of the
> "restart" approach is that we can perform the user-accesses after the
> migration, which allow us to call that code right before return to
> userspace. Unfortunately, doing the fixup from the kernel after the
> migration might be tricky, even if we use a lock-atomic op in the fixup,
> because we might be doing a store concurrently with a non-locked atomic
> op running in userspace on the original CPU.

But we can check what cpu we're on if we're in the kernel.  In fact,
once the x86 exit-to-userspace code gets rewritten (working on that,
but maybe not ready for 4.2), this would actually be straightforward,
modulo forcing a slower exit path on migration if we don't have a good
way to exclude migrations that don't matter.

>
> Here is an idea I'm not totally proud of, but might work if we really
> want to do this without restarting userspace: we could expose a vdso
> that both performs an atomic operation on an array of pointers to
> per-cpu values, and gets the cpu number:
>
> void __vdso_cmpxchg_getcpu(unsigned long **p, unsigned long _old,
>     unsigned long _new, int *cpu);
>
> If we preempt this vdso, the in-kernel fixup simply grabs the current CPU
> number and updates the right array entry, all this locally. The advantage
> here is that we can perform this after migration. It comes at the expense
> of an indirection through the pointer array, which I rather dislike. If
> we can rather find a way to perform the userspace fixup before migration,
> it would be much better.

Sneaky.  I think that's actually kind of neat, except that it's
incompatible with the x86 gs-based cmpxchg trick.

FWIW, I should probably stop complaining about having some per-process
non-library-compatible state.  We already have that with
set_robust_list.  If we want to have userspace register a per-thread
virtual address at which the thread's cpu number lives, so be it.  How
do we handle a page fault on migration, though?

Grumble.  I really wish that we had per-cpu virtual memory mappings.
Oh, well.  Also, I think PeterZ's opinion on anything that mucks with
the scheduler is critical here.

>
>>
>> >
>> >>
>> >> FWIW, 'xchg' to cache-hot memory is only about 20 cycles on my laptop,
>> >> and cmpxchg seems to be about 6 cycles.  Both are faster than getcpu.
>> >> How much are we really saving with any of this over the pure userspace
>> >> approach?  I think that the most that the kernel can possibly help us
>> >> is to give us a faster getcpu and to help us deal with being migrated
>> >> to a different cpu if we want to avoid expensive operations and don't
>> >> want to play unlocked cmpxchg tricks.
>> >
>> > You appear to summarize the two things that are added to the kernel with
>> > this RFC patch:
>> > - faster getcpu(): 12.7 ns -> 0.3 ns
>>
>> Yeah, I figured that out the second time I read your email and re-read
>> the original message, but I apparently forgot to fix up the email I
>> was typing.
>>
>> > - allow using less expensive operations to perform per-cpu-atomic ops:
>> >   (on my system):
>> >   - lock; cmpxchg (18 ns) -> load-test-branch-store (5.4 ns)
>> >
>>
>> When you say "load-test-branch-store", do you mean that sequence of
>> normal code or a literal cmpxchg?  On x86, we really can pull off the
>> sneaky trick of gs-relative cmpxchg in a single instruction, which
>> gives us per-cpu atomic locking without any special kernel fixups,
>> although that locks down gs and isn't currently supported.
>
> It's a sequence of normal code. Ideally I'd want this to be doable
> on other architectures too (powerpc and ARM at least).

Agreed.

BTW, I just found this thread:

http://comments.gmane.org/gmane.linux.kernel/1786674

this is kind of like my sort-of-proposal for using gs.

--Andy
