From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Sat, 27 Jun 2015 09:25:02 -0700
Message-ID: <CALCETrVRE+6nM6DGa8ph84cX+CdRXh+qXyReU+jHgx9-+uCTyg@mail.gmail.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
 <CALCETrXAtYDZBbpwZceFyhLOnqFmTDqTxhGfbrrVrY+34cxSFg@mail.gmail.com>
 <CAPM31R+GUtD_9S+m7U0DGpeqSCT1n98bvQ0NUOwMHX7-CoKigQ@mail.gmail.com>
 <842897619.3710.1435281350583.JavaMail.zimbra@efficios.com> <CAPM31RJwFJXjxLnwFMCBE1=wVXyU06ttrT-_fNr1rb=+ewxVrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RJwFJXjxLnwFMCBE1=wVXyU06ttrT-_fNr1rb=+ewxVrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Let me try to summarize some of the approaches with their pros and cons:

--- percpu segment ---

This is probably the simplest and might make sense regardless.
cmpxchg can be used to do an atomic push onto a linked list.  I think
that unlocked cmpxchg16b can be used to get an atomic pop.  (You'd
have the list head pointer next to an auxiliary pointer to the second
element in the list, perhaps.)

You can also use this for limited forms of speculative locking.
Aborting cleanly if your lock is stolen might require the kernel's
help, though (you're now on the wrong cpu, so you can't atomically
poke the lock variable any more).

The ABI is straightforward, and the only limitation on multiple users
in the same process is that they need to coordinate their offsets into
the percpu segment.

--- vdso-provided atomic ops ---

This could be quite flexible.  The upside is that the ABI would be
straightforward (call a function with clearly-specified behavior).
The downside is that implementing it well might require percpu
segments and a certain amount of coordination, and it requires a
function call.

One nice thing about doing it in the vdso is that we can change the
implementation down the road.

--- kernel preemption hooks ---

I'm defining a preemption hook as an action taken by the kernel when a
user task is preempted during a critical section.

As an upside, we get extremely efficient, almost arbitrary percpu
operations.  We don't need to worry about memory ordering at all,
because the whole sequence aborts if anything else might run on the
same cpu.  Push and pop are both easy.

One con is that actually defining where the critical section is might
be nasty.  If there's a single IP range, then two libraries could
fight over it.  We could have a variable somewhere that you write to
arm the critical section, but that's a bit slower.

Another con is that you can't single-step through this type of
critical section.  It will be preempted every time.

--- kernel migration hooks ---

I'm not sure either Paul or Mattieu discussed this, but another option
would be to have some special handling if a task is migrated during a
critical section or to allow a task to prevent migration entirely
during a critical section.  From the user's point of view, this is
weaker than preemption hooks: it's possible to start your critical
section, be preempted, and have another thread enter its own critical
section, then get rescheduled on the same cpu without aborting.  Users
would have to use local atomics (like cmpxchg) to make it useful.

As a major advantage, single-stepping still works.

This shares the coordination downside with preemption hooks (users
have to tell the kernel about their critical sections somehow).

Push can certainly be implemented using cmpxchg.  The gs prefix isn't
even needed.  Pop might be harder to implement directly without
resorting to cmpxchg16b or similar.

--- Unnamed trick ---

On entry to a critical section, try to take a per-cpu lock that stores
the holder's tid.  This might require percpu segments.

If you get the lock, then start doing your thing.  For example, you
could pop by reading head->next and writing it back to head.

If, however, you miss the lock, then you need to either wait or
forcibly abort the lock holder.  You could do the latter by sending a
signal or possibly using a new syscall that atomically aborts the lock
holder and takes the lock.  You don't need to wait, though -- all you
need to do is queue the signal and, if the lock holder is actually
running, wait for signal delivery to start.


Thoughts?  I personally like the other options better than preemption
hooks.  I prefer solutions that don't interfere with debugging.

--Andy
