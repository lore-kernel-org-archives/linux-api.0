From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Sun, 28 Jun 2015 16:11:00 +0000 (UTC)
Message-ID: <1800108908.323.1435507860145.JavaMail.zimbra@efficios.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com> <CALCETrXAtYDZBbpwZceFyhLOnqFmTDqTxhGfbrrVrY+34cxSFg@mail.gmail.com> <CAPM31R+GUtD_9S+m7U0DGpeqSCT1n98bvQ0NUOwMHX7-CoKigQ@mail.gmail.com> <842897619.3710.1435281350583.JavaMail.zimbra@efficios.com> <CAPM31RJwFJXjxLnwFMCBE1=wVXyU06ttrT-_fNr1rb=+ewxVrg@mail.gmail.com> <CALCETrVRE+6nM6DGa8ph84cX+CdRXh+qXyReU+jHgx9-+uCTyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVRE+6nM6DGa8ph84cX+CdRXh+qXyReU+jHgx9-+uCTyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 27, 2015, at 12:25 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

> Let me try to summarize some of the approaches with their pros and cons:
> 

I can try summarizing a desiderata that I gather from this
thread so far:

- *very fast* accesses for per-cpu push/pop, per-cpu lock
  acquisition, and per-cpu counters,
- guaranteed progress (don't loop forever when single-stepped),
- critical section implementation flexibility:
  - can be written only in assembly or also in C,
  - provide a single building-block (e.g. cmpxchg) or allow
    applications/libraries to do arbitrary critical sections,
- portability to non-x86 architectures,
- low-intrusiveness for injection into applications (no signal
  handler, no segment selector used by pre-existing applications).
- can be used by either a single or many shared objects per process,
- don't disturb real-time scheduling,
- minimal slowdown of kernel scheduling execution.

More comments on each approach below:

> --- percpu segment ---
> 
> This is probably the simplest and might make sense regardless.
> cmpxchg can be used to do an atomic push onto a linked list.  I think
> that unlocked cmpxchg16b can be used to get an atomic pop.  (You'd
> have the list head pointer next to an auxiliary pointer to the second
> element in the list, perhaps.)

Based on http://www.agner.org/optimize/instruction_tables.pdf
On Intel Haswell:

instruction       latency (cycles)
cmpxchg:          8
lock cmpxchg:     19
cmpxchg16b:       15

cmpxchg16b does not appear to be particularly fast (twice the latency of
cmpxchg).

> 
> You can also use this for limited forms of speculative locking.
> Aborting cleanly if your lock is stolen might require the kernel's
> help, though (you're now on the wrong cpu, so you can't atomically
> poke the lock variable any more).
> 
> The ABI is straightforward, and the only limitation on multiple users
> in the same process is that they need to coordinate their offsets into
> the percpu segment.

One more downside about this approach: some applications already use
the gs segment (AFAIK the wine emulator uses it), so can be prohibitive
to use it from tracing code injected into pre-existing applications.

Another downside is that it is x86-specific.

> 
> --- vdso-provided atomic ops ---
> 
> This could be quite flexible.  The upside is that the ABI would be
> straightforward (call a function with clearly-specified behavior).

Following same ref as above, the call/ret pair alone would cost
about 5 cycles.

> The downside is that implementing it well might require percpu
> segments and a certain amount of coordination, and it requires a
> function call.

Same downside as above about gs segment being already used by some
applications.

> 
> One nice thing about doing it in the vdso is that we can change the
> implementation down the road.

Yes, this is clearly an advantage over letting applications inline
their cmpxchg on gs:.

Same downside as above about being x86-specific.

> 
> --- kernel preemption hooks ---
> 
> I'm defining a preemption hook as an action taken by the kernel when a
> user task is preempted during a critical section.
> 
> As an upside, we get extremely efficient, almost arbitrary percpu
> operations.  We don't need to worry about memory ordering at all,
> because the whole sequence aborts if anything else might run on the
> same cpu.  Push and pop are both easy.
> 
> One con is that actually defining where the critical section is might
> be nasty.  If there's a single IP range, then two libraries could
> fight over it.  We could have a variable somewhere that you write to
> arm the critical section, but that's a bit slower.

My current understanding is that we have two means to tell the kernel
"we are in a critical section": either through register content or
through a per-thread memory area. Paul's implementation uses the
instruction pointer, but it could perhaps use another reserved register
state, which might help us do the critical functions in C code rather
than assembly. It might be tricky to find a register that is guaranteed
not to be used though, hence the per-thread memory area.

The per-thread memory area has the advantage of allowing the critical
sections to be implemented in C code rather than assembly, but, as you
say, its downside is that we need at the very least to set/clear a TLS
flag (or have a nesting counter) surrounding the critical section. This
approach is quite similar to preempt_disable()/preempt_enable() in the
Linux kernel.

Another advantage of preempt migration hooks over migration hooks
is that the critical section can assume it has mutually exclusive
access, which is not the case for migration hooks, because it can
be preempted and continue execution afterward. This means what can
be achieved with e.g. "load+test+store" with preempt hook needs to
be performed with "cmpxchg" with migration hooks. This might not be
a huge issue for x86, but can become more expensive on other
architectures.

> 
> Another con is that you can't single-step through this type of
> critical section.  It will be preempted every time.

Could we simply make single-stepping skip over those critical
sections ? AFAIU the kernel should have all the information needed
to do that.

One more advantage: could be implemented for all architectures.

Then the part that is missing from this summary is how to handle
the "restart". Paul's approach moves execution to a restart ip,
which is fine since the entire critical section is written in
assembly. My approach uses page protection on the per-thread
virtual memory mapping to the per-cpu data (e.g. the lock) to
make the thread fault. My approach is more intrusive (requires
implementation of SIGSEGV handler in user-space), but allows
doing the critical sections in plain C.

> 
> --- kernel migration hooks ---
> 
> I'm not sure either Paul or Mattieu discussed this, but another option
> would be to have some special handling if a task is migrated during a
> critical section

I don't think we discussed this yet. See my point above about not
having exclusive access within the critical section. This can be
limiting, especially on architectures that don't provide per-cpu
atomic ops as efficient as x86 cmpxchg.

> or to allow a task to prevent migration entirely
> during a critical section.

Following past discussion with Peter Zijlstra, I understood that this
approach would receive a huge pushback from real-time people, since
letting user-space hold off migration for an arbitrary amount of time
destroys many nice real-time guarantees. However, since the kernel
also allows threads to pin themselves to specific cores explicitly,
I still don't get how preventing migration from userspace for an
arbitrary amount of time is different from setting CPU affinity.

>  From the user's point of view, this is
> weaker than preemption hooks: it's possible to start your critical
> section, be preempted, and have another thread enter its own critical
> section, then get rescheduled on the same cpu without aborting.  Users
> would have to use local atomics (like cmpxchg) to make it useful.
> 
> As a major advantage, single-stepping still works.
> 
> This shares the coordination downside with preemption hooks (users
> have to tell the kernel about their critical sections somehow).
> 
> Push can certainly be implemented using cmpxchg.  The gs prefix isn't
> even needed.  Pop might be harder to implement directly without
> resorting to cmpxchg16b or similar.
> 
> --- Unnamed trick ---
> 
> On entry to a critical section, try to take a per-cpu lock that stores
> the holder's tid.  This might require percpu segments.
> 
> If you get the lock, then start doing your thing.  For example, you
> could pop by reading head->next and writing it back to head.
> 
> If, however, you miss the lock, then you need to either wait or
> forcibly abort the lock holder.  You could do the latter by sending a
> signal or possibly using a new syscall that atomically aborts the lock
> holder and takes the lock.  You don't need to wait, though -- all you
> need to do is queue the signal and, if the lock holder is actually
> running, wait for signal delivery to start.

Aborting the critical section can be tricky in the general case. See
my point above about critical sections written in assembly or C.
Would you require that c.s. are written in assembly for this ?

> 
> Thoughts?  I personally like the other options better than preemption
> hooks.  I prefer solutions that don't interfere with debugging.

Would skipping over the critical section be doable/acceptable for the
single-stepping case ?

One more card we have is to design algorithms that have a restartable
fast-path, but their restart point go to a path that is guaranteed to
progress. For instance, lock-acquisition can be achieved in this way
using a "2-threads" Peterson's algorithm for each core where the variable
used for thread 1 is always guaranteed to have exclusive access (can be
restarted), but the 2nd thread variable is not restarted (guaranteed
progress), and updates to this variable can go through a lock-prefixed
cmpxchg. Basically, we can see this as a 2-class Peterson algorithm
(rather than 2 threads), where the first class has exclusive access,
and the 2nd class serializes many threads through an atomic instruction.
This approach should work well for locks, but I'm not sure it would
do for push/pop of a linked list.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
