From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Mon, 25 Jul 2016 16:02:24 -0700
Message-ID: <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469135662-31512-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 21, 2016 at 2:14 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> Man page associated:
>
> RSEQ(2)                Linux Programmer's Manual               RSEQ(2=
)
>
> NAME
>        rseq - Restartable sequences and cpu number cache
>
> SYNOPSIS
>        #include <linux/rseq.h>
>
>        int rseq(struct rseq * rseq, int flags);
>
> DESCRIPTION
>        The  rseq()  ABI  accelerates  user-space operations on per-cp=
u
>        data by defining a shared data structure ABI between each user=
-
>        space thread and the kernel.
>
>        The  rseq argument is a pointer to the thread-local rseq struc=
=E2=80=90
>        ture to be shared between kernel and user-space.  A  NULL  rse=
q
>        value  can  be used to check whether rseq is registered for th=
e
>        current thread.
>
>        The layout of struct rseq is as follows:
>
>        Structure alignment
>               This structure needs to be aligned on  multiples  of  6=
4
>               bytes.
>
>        Structure size
>               This structure has a fixed size of 128 bytes.
>
>        Fields
>
>            cpu_id
>               Cache  of  the CPU number on which the calling thread i=
s
>               running.
>
>            event_counter
>               Restartable sequences event_counter field.

That's an unhelpful description.

>
>            rseq_cs
>               Restartable sequences rseq_cs field. Points to a  struc=
t
>               rseq_cs.

Why is it a pointer?

>
>        The layout of struct rseq_cs is as follows:
>
>        Structure alignment
>               This  structure  needs  to be aligned on multiples of 6=
4
>               bytes.
>
>        Structure size
>               This structure has a fixed size of 192 bytes.
>
>        Fields
>
>            start_ip
>               Instruction pointer address of the first instruction  o=
f
>               the sequence of consecutive assembly instructions.
>
>            post_commit_ip
>               Instruction  pointer  address after the last instructio=
n
>               of the sequence of consecutive assembly instructions.
>
>            abort_ip
>               Instruction pointer address where to move the  executio=
n
>               flow  in  case  of  abort of the sequence of consecutiv=
e
>               assembly instructions.
>
>        The flags argument is currently unused and must be specified a=
s
>        0.
>
>        Typically,  a  library or application will keep the rseq struc=
=E2=80=90
>        ture in a thread-local storage variable, or other memory  area=
s

"variable or other memory area"

>        belonging to each thread. It is recommended to perform volatil=
e
>        reads of the thread-local cache to prevent  the  compiler  fro=
m
>        doing  load  tearing.  An  alternative approach is to read eac=
h
>        field from inline assembly.

I don't think the man page needs to tell people how to implement
correct atomic loads.

>
>        Each thread is responsible for registering its rseq  structure=
=2E
>        Only  one  rseq structure address can be registered per thread=
=2E
>        Once set, the rseq address is idempotent for a given thread.

"Idempotent" is a property that applies to an action, and the "rseq
address" is not an action.  I don't know what you're trying to say.

>
>        In a typical usage scenario, the thread  registering  the  rse=
q
>        structure  will  be  performing  loads  and stores from/to tha=
t
>        structure. It is however also allowed to  read  that  structur=
e
>        from  other  threads.   The rseq field updates performed by th=
e
>        kernel provide single-copy atomicity semantics, which guarante=
e
>        that  other  threads performing single-copy atomic reads of th=
e
>        cpu number cache will always observe a consistent value.

s/single-copy/relaxed atomic/ perhaps?

>
>        Memory registered as rseq structure should never be deallocate=
d
>        before  the  thread which registered it exits: specifically, i=
t
>        should not be freed, and the library containing the  registere=
d
>        thread-local  storage  should  not be dlclose'd. Violating thi=
s
>        constraint may cause a SIGSEGV signal to be  delivered  to  th=
e
>        thread.

That's an unfortunate constraint for threads that exit without help.

>
>        Unregistration  of associated rseq structure is implicitly per=
=E2=80=90
>        formed when a thread or process exit.

exits.

[...]

Can you please document what this thing does prior to giving an
example of how to use it.

Hmm, here are the docs, sort of:

> diff --git a/kernel/rseq.c b/kernel/rseq.c
> new file mode 100644
> index 0000000..e1c847b
> --- /dev/null
> +++ b/kernel/rseq.c

> +/*
> + * Each restartable sequence assembly block defines a "struct rseq_c=
s"
> + * structure which describes the post_commit_ip address, and the
> + * abort_ip address where the kernel should move the thread instruct=
ion
> + * pointer if a rseq critical section assembly block is preempted or=
 if
> + * a signal is delivered on top of a rseq critical section assembly
> + * block. It also contains a start_ip, which is the address of the s=
tart
> + * of the rseq assembly block, which is useful to debuggers.
> + *
> + * The algorithm for a restartable sequence assembly block is as
> + * follows:
> + *
> + * rseq_start()
> + *
> + *   0. Userspace loads the current event counter value from the
> + *      event_counter field of the registered struct rseq TLS area,
> + *
> + * rseq_finish()
> + *
> + *   Steps [1]-[3] (inclusive) need to be a sequence of instructions=
 in
> + *   userspace that can handle being moved to the abort_ip between a=
ny
> + *   of those instructions.
> + *
> + *   The abort_ip address needs to be equal or above the post_commit=
_ip.
> + *   Step [4] and the failure code step [F1] need to be at addresses
> + *   equal or above the post_commit_ip.
> + *
> + *   1.  Userspace stores the address of the struct rseq cs rseq

"struct rseq cs rseq" contains a typo.

> + *       assembly block descriptor into the rseq_cs field of the
> + *       registered struct rseq TLS area.
> + *
> + *   2.  Userspace tests to see whether the current event counter va=
lues
> + *       match those loaded at [0]. Manually jumping to [F1] in case=
 of
> + *       a mismatch.

Grammar issues here.  More importantly, you said "values", but you
only described one value.

> + *
> + *       Note that if we are preempted or interrupted by a signal
> + *       after [1] and before post_commit_ip, then the kernel also
> + *       performs the comparison performed in [2], and conditionally
> + *       clears rseq_cs, then jumps us to abort_ip.

This is the first I've heard of rseq_cs being something that gets
changed as a result of using this facility.  What code sets it in the
first place?

I think you've also mentioned "preemption" and "migration".  Which do y=
ou mean?

> + *
> + *   3.  Userspace critical section final instruction before
> + *       post_commit_ip is the commit. The critical section is
> + *       self-terminating.
> + *       [post_commit_ip]
> + *
> + *   4.  Userspace clears the rseq_cs field of the struct rseq
> + *       TLS area.
> + *
> + *   5.  Return true.
> + *
> + *   On failure at [2]:
> + *

A major issue I have with percpu critical sections or rseqs or
whatever you want to call them is that, every time I talk to someone
about them, there are a different set of requirements that they are
supposed to satisfy.  So:

What problem does this solve?

What are its atomicity properties?  Under what conditions does it
work?  What assumptions does it make?

What real-world operations become faster as a result of rseq (as
opposed to just cpu number queries)?

Why is it important for the kernel to do something special on every pre=
emption?

What "events" does "event_counter" count and why?


If I'm understanding the intent of this code correctly (which is a big
if), I think you're trying to do this:

start a critical section;
compute something;
commit;
if (commit worked)
  return;
else
  try again;

where "commit;" is a single instruction.  The kernel guarantees that
if the thread is preempted (or migrated, perhaps?) between the start
and commit steps then commit will be forced to fail (or be skipped
entirely).  Because I don't understand what you're doing with this
primitive, I can't really tell why you need to detect preemption as
opposed to just migration.

=46or example: would the following primitive solve the same problem?

begin_dont_migrate_me()

figure out what store to do to take the percpu lock;
do that store;

if (end_dont_migrate_me())
  return;

// oops, the kernel migrated us.  retry.


--Andy
