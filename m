From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Tue, 26 Jul 2016 03:02:19 +0000 (UTC)
Message-ID: <1806206514.82247.1469502139408.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVq3hgLbADcx_4g6gGgp7Hf-WnnWA8gg68tPZTv2wfbDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 25, 2016, at 7:02 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org =
wrote:

> On Thu, Jul 21, 2016 at 2:14 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> Man page associated:
>>
>> RSEQ(2)                Linux Programmer's Manual               RSEQ(=
2)
>>
>> NAME
>>        rseq - Restartable sequences and cpu number cache
>>
>> SYNOPSIS
>>        #include <linux/rseq.h>
>>
>>        int rseq(struct rseq * rseq, int flags);
>>
>> DESCRIPTION
>>        The  rseq()  ABI  accelerates  user-space operations on per-c=
pu
>>        data by defining a shared data structure ABI between each use=
r-
>>        space thread and the kernel.
>>
>>        The  rseq argument is a pointer to the thread-local rseq stru=
c=E2=80=90
>>        ture to be shared between kernel and user-space.  A  NULL  rs=
eq
>>        value  can  be used to check whether rseq is registered for t=
he
>>        current thread.
>>
>>        The layout of struct rseq is as follows:
>>
>>        Structure alignment
>>               This structure needs to be aligned on  multiples  of  =
64
>>               bytes.
>>
>>        Structure size
>>               This structure has a fixed size of 128 bytes.
>>
>>        Fields
>>
>>            cpu_id
>>               Cache  of  the CPU number on which the calling thread =
is
>>               running.
>>
>>            event_counter
>>               Restartable sequences event_counter field.
>=20
> That's an unhelpful description.

Good point, how about:

event_counter
   Counter guaranteed to be incremented when the current thread is
   preempted or when a signal is delivered to the current thread.

In that same line of thoughts, I would reword cpu_id as:

cpu_id
   Cache  of  the CPU number on which the current thread is
   running.

>=20
>>
>>            rseq_cs
>>               Restartable sequences rseq_cs field. Points to a  stru=
ct
>>               rseq_cs.
>=20
> Why is it a pointer?

Rewording like this should help understand:

rseq_cs
   The rseq_cs field is a pointer to a struct rseq_cs. Is is NULL when
   no rseq assembly block critical section is active for the current
   thread. Setting it to point to a critical section descriptor (struct
   rseq_cs) marks the beginning of the critical section. It is cleared
   after the end of the critical section.


>=20
>>
>>        The layout of struct rseq_cs is as follows:
>>
>>        Structure alignment
>>               This  structure  needs  to be aligned on multiples of =
64
>>               bytes.
>>
>>        Structure size
>>               This structure has a fixed size of 192 bytes.
>>
>>        Fields
>>
>>            start_ip
>>               Instruction pointer address of the first instruction  =
of
>>               the sequence of consecutive assembly instructions.
>>
>>            post_commit_ip
>>               Instruction  pointer  address after the last instructi=
on
>>               of the sequence of consecutive assembly instructions.
>>
>>            abort_ip
>>               Instruction pointer address where to move the  executi=
on
>>               flow  in  case  of  abort of the sequence of consecuti=
ve
>>               assembly instructions.
>>
>>        The flags argument is currently unused and must be specified =
as
>>        0.
>>
>>        Typically,  a  library or application will keep the rseq stru=
c=E2=80=90
>>        ture in a thread-local storage variable, or other memory  are=
as
>=20
> "variable or other memory area"

ok

>=20
>>        belonging to each thread. It is recommended to perform volati=
le
>>        reads of the thread-local cache to prevent  the  compiler  fr=
om
>>        doing  load  tearing.  An  alternative approach is to read ea=
ch
>>        field from inline assembly.
>=20
> I don't think the man page needs to tell people how to implement
> correct atomic loads.

ok, I can remove the two previous sentences.

>=20
>>
>>        Each thread is responsible for registering its rseq  structur=
e.
>>        Only  one  rseq structure address can be registered per threa=
d.
>>        Once set, the rseq address is idempotent for a given thread.
>=20
> "Idempotent" is a property that applies to an action, and the "rseq
> address" is not an action.  I don't know what you're trying to say.

I mean there is only one address registered per thread, and it stays
registered for the life-time of the thread. Perhaps I could say:

  "Once set, the rseq address never changes for a given thread."

>=20
>>
>>        In a typical usage scenario, the thread  registering  the  rs=
eq
>>        structure  will  be  performing  loads  and stores from/to th=
at
>>        structure. It is however also allowed to  read  that  structu=
re
>>        from  other  threads.   The rseq field updates performed by t=
he
>>        kernel provide single-copy atomicity semantics, which guarant=
ee
>>        that  other  threads performing single-copy atomic reads of t=
he
>>        cpu number cache will always observe a consistent value.
>=20
> s/single-copy/relaxed atomic/ perhaps?

ok

>=20
>>
>>        Memory registered as rseq structure should never be deallocat=
ed
>>        before  the  thread which registered it exits: specifically, =
it
>>        should not be freed, and the library containing the  register=
ed
>>        thread-local  storage  should  not be dlclose'd. Violating th=
is
>>        constraint may cause a SIGSEGV signal to be  delivered  to  t=
he
>>        thread.
>=20
> That's an unfortunate constraint for threads that exit without help.

I don't understand what you are pointing at here. I see this mostly as
a constraint on the life-time of the library that holds the struct rseq
TLS more than a constraint on the thread life-time.

>=20
>>
>>        Unregistration  of associated rseq structure is implicitly pe=
r=E2=80=90
>>        formed when a thread or process exit.
>=20
> exits.

ok

>=20
> [...]
>=20
> Can you please document what this thing does prior to giving an
> example of how to use it.

Good point, will do. (more comments on what can be added as documentati=
on
below)

>=20
> Hmm, here are the docs, sort of:
>=20
>> diff --git a/kernel/rseq.c b/kernel/rseq.c
>> new file mode 100644
>> index 0000000..e1c847b
>> --- /dev/null
>> +++ b/kernel/rseq.c
>=20
>> +/*
>> + * Each restartable sequence assembly block defines a "struct rseq_=
cs"
>> + * structure which describes the post_commit_ip address, and the
>> + * abort_ip address where the kernel should move the thread instruc=
tion
>> + * pointer if a rseq critical section assembly block is preempted o=
r if
>> + * a signal is delivered on top of a rseq critical section assembly
>> + * block. It also contains a start_ip, which is the address of the =
start
>> + * of the rseq assembly block, which is useful to debuggers.
>> + *
>> + * The algorithm for a restartable sequence assembly block is as
>> + * follows:
>> + *
>> + * rseq_start()
>> + *
>> + *   0. Userspace loads the current event counter value from the
>> + *      event_counter field of the registered struct rseq TLS area,
>> + *
>> + * rseq_finish()
>> + *
>> + *   Steps [1]-[3] (inclusive) need to be a sequence of instruction=
s in
>> + *   userspace that can handle being moved to the abort_ip between =
any
>> + *   of those instructions.
>> + *
>> + *   The abort_ip address needs to be equal or above the post_commi=
t_ip.
>> + *   Step [4] and the failure code step [F1] need to be at addresse=
s
>> + *   equal or above the post_commit_ip.
>> + *
>> + *   1.  Userspace stores the address of the struct rseq cs rseq
>=20
> "struct rseq cs rseq" contains a typo.

should be "struct rseq_cs"

>=20
>> + *       assembly block descriptor into the rseq_cs field of the
>> + *       registered struct rseq TLS area.
>> + *
>> + *   2.  Userspace tests to see whether the current event counter v=
alues
>> + *       match those loaded at [0]. Manually jumping to [F1] in cas=
e of
>> + *       a mismatch.
>=20
> Grammar issues here.  More importantly, you said "values", but you
> only described one value.

Indeed, values -> value, and those -> the value

>=20
>> + *
>> + *       Note that if we are preempted or interrupted by a signal
>> + *       after [1] and before post_commit_ip, then the kernel also
>> + *       performs the comparison performed in [2], and conditionall=
y
>> + *       clears rseq_cs, then jumps us to abort_ip.
>=20
> This is the first I've heard of rseq_cs being something that gets
> changed as a result of using this facility.  What code sets it in the
> first place?

struct rseq_cs (the critical section descriptor) is statically declared=
,
never changes. What I should clarify above is that the rseq_cs field of
struct rseq gets cleared (not the struct rseq_cs per se).

The struct rseq_cs field is initially at NULL, and is populated by the
struct rseq_cs descriptor address when entering the critical section.
It is set back to NULL right after exiting the critical section, throug=
h
both the success and failure paths.

>=20
> I think you've also mentioned "preemption" and "migration".  Which do=
 you mean?

We really care about preemption here. Every migration implies a
preemption from a user-space perspective. If we would only care
about keeping the CPU id up-to-date, hooking into migration would be
enough. But since we want atomicity guarantees for restartable
sequences, we need to hook into preemption.

I should update the changelog of patch 1/7 to specify that we really do
hook on preemption, even for the cpu_id update part.

>=20
>> + *
>> + *   3.  Userspace critical section final instruction before
>> + *       post_commit_ip is the commit. The critical section is
>> + *       self-terminating.
>> + *       [post_commit_ip]
>> + *
>> + *   4.  Userspace clears the rseq_cs field of the struct rseq
>> + *       TLS area.
>> + *
>> + *   5.  Return true.
>> + *
>> + *   On failure at [2]:
>> + *
>=20
> A major issue I have with percpu critical sections or rseqs or
> whatever you want to call them is that, every time I talk to someone
> about them, there are a different set of requirements that they are
> supposed to satisfy.  So:
>=20
> What problem does this solve?

It allows user-space to perform update operations on per-cpu data witho=
ut
requiring heavy-weight atomic operations.

>=20
> What are its atomicity properties?  Under what conditions does it
> work?  What assumptions does it make?

Restartable sequences are atomic with respect to preemption (making it
atomic with respect to other threads running on the same CPU), as well
as signal delivery (user-space execution contexts nested over the same
thread).

It is suited for update operations on per-cpu data.

It can be used on data structures shared between threads within a proce=
ss,
and on data structures shared between threads across different processe=
s.

>=20
> What real-world operations become faster as a result of rseq (as
> opposed to just cpu number queries)?

A few examples of operations accelerated:

- incrementing per-cpu counters,
- per-cpu spin-lock,
- per-cpu linked-lists (including memory allocator free-list),
- per-cpu ring buffer,

Perhaps others will have other operations in mind ?

Note that compared to Paul Turner's patchset, I removed the percpu_cmpx=
chg
and percpu_cmpxchg_check APIs from the test program rseq.h in user-spac=
e,
because I found out that it was difficult to guarantee progress with th=
ose
APIs. The do_rseq() approach, which does 2 attempts and falls back to
locking, does provide progress guarantees even in the face of (unlikely=
)
frequent migrations.

>=20
> Why is it important for the kernel to do something special on every p=
reemption?

This is how we can ensure that the entire critical section,
consisting of both the C part and the assembly instruction
sequence, will issue the commit instruction only if executed
atomically with respect to other threads scheduled on the
same CPU.

>=20
> What "events" does "event_counter" count and why?

Technically, it increments each time a thread returns to
user-space with the NOTIFY_RESUME thread flag set. We ensure
to set this flag on preemption (out), as well as signal delivery.
So it is guaranteed to increment when either of those events take
place. It can however increment due to other kernel code setting
TIF_NOTIFY_RESUME before returning to user-space.

It is meant to allow user-space to detect preemption and signal
delivery, not to count the exact number of such events.

>=20
>=20
> If I'm understanding the intent of this code correctly (which is a bi=
g
> if), I think you're trying to do this:
>=20
> start a critical section;
> compute something;
> commit;
> if (commit worked)
>  return;
> else
>  try again;
>=20
> where "commit;" is a single instruction.  The kernel guarantees that
> if the thread is preempted (or migrated, perhaps?)

A thread needs to have been preempted in order to be migrated, so
from a user-space perspective, detecting preemption is a super-set
of detecting migration. We track preemption and signal delivery here.

> between the start
> and commit steps then commit will be forced to fail (or be skipped
> entirely).  Because I don't understand what you're doing with this
> primitive, I can't really tell why you need to detect preemption as
> opposed to just migration.
>=20
> For example: would the following primitive solve the same problem?
>=20
> begin_dont_migrate_me()
>=20
> figure out what store to do to take the percpu lock;
> do that store;
>=20
> if (end_dont_migrate_me())
>  return;
>=20
> // oops, the kernel migrated us.  retry.

=46irst, prohibiting migration from user-space has been frowned upon
by scheduler developers for a long time, and I doubt this mindset will
change.

But if we look at it from the point of view of letting user-space
retry when it detects migration (rather than preemption), it would
require that we use an atomic instruction (although without the lock
prefix) as the commit instruction to ensure atomicity with respect
to other threads running on the same CPU. Detecting preemption
instead allows us to use a simple store instruction as the commit.
Simple store instructions (e.g. mov) are faster than atomic
instructions (e.g. xadd, cmpxchg...). Moreover, detecting
migrations and using atomic instructions as commit is prone to ABA
(e.g. free-list use-case) that are prevented by the restart on
preemption or signal delivery.

Thanks for looking into it!

Mathieu


>=20
>=20
> --Andy

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
