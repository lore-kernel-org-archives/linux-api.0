From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Wed, 07 Oct 2015 09:30:46 +0100
Message-ID: <5614D836.7070506@gmail.com>
References: <55B61EF3.7080302@gmail.com> <alpine.DEB.2.11.1507282054370.3825@nanos> <55C5A787.9010806@gmail.com> <alpine.DEB.2.11.1508200042180.3873@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1508200042180.3873@nanos>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Thomas,

Thanks for the follow up!

Some open questions below are marked with the string ###.

On 08/19/2015 04:17 PM, Thomas Gleixner wrote:
> On Sat, 8 Aug 2015, Michael Kerrisk (man-pages) wrote:
>>>>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
>>>>               This  operation  first  checks  whether the location=
 uaddr
>>>>               still contains the value  val3.   If  not,  the  ope=
ration
>>>>               fails  with  the  error  EAGAIN.  Otherwise, the ope=
ration
>>>>               wakes up a maximum of val waiters that are waiting o=
n  the
>>>>               futex  at uaddr.  If there are more than val waiters=
, then
>>>>               the remaining waiters are removed from the wait  que=
ue  of
>>>>               the  source  futex at uaddr and added to the wait qu=
eue of
>>>>               the target futex at uaddr2.  The val2  argument  spe=
cifies
>>>>               an  upper limit on the number of waiters that are re=
queued
>>>>               to the futex at uaddr2.
>>>>
>>>> .\" FIXME(Torvald) Is the following correct?  Or is just the decis=
ion
>>>> .\" which threads to wake or requeue part of the atomic operation?
>>>>
>>>>               The load from uaddr is  an  atomic  memory  access  =
(i.e.,
>>>>               using atomic machine instructions of the respective =
archi=E2=80=90
>>>>               tecture).  This load, the comparison with  val3,  an=
d  the
>>>>               requeueing  of  any  waiters  are performed atomical=
ly and
>>>>               totally ordered with respect to other  operations  o=
n  the
>>>>               same futex word.
>>>
>>> It's atomic as the other atomic operations on the futex word. It's
>>> always performed with the proper lock(s) held in the kernel. That
>>> means any concurrent operation will serialize on that lock(s). User
>>> space has to make sure, that depending on the observed value no
>>> concurrent operations happen, but that's something the kernel canno=
t
>>> control.
>>
>> ???
>> Sorry, I'm not clear here. Is the current text correct then? Or is s=
ome
>> change needed.
>=20
> I think we need some change here because the meaning of atomic is
> unclear. The basic rules of futexes are:
>=20
>  - All modifying operations on the futex value have to be done with
>    atomic instructions, usually cmpxchg. That applies to both kernel
>    and user space.
>=20
>    That's the atomicity at the futex value level.
>=20
>  - In the kernel we have to create/modify/destroy state in order to
>    provide the blocking/requeueing etc.
>=20
>    This state needs protection as well. So all operations related to
>    the kernel internal state are serialized on the hash bucket
>    locks. The hash buckets are a scalability mechanism to avoid
>    contention on a single lock protecting all kernel internal
>    state. For simplicity reasons you can just think of a global lock
>    protecting all kernel internal state.
>=20
>    If the kernel creates/modifies state then it can be necessary to
>    either reread the futex value or modify it. That happens under the
>    locks as well.
>=20
>    So in the case of requeue, we take the proper locks and perform th=
e
>    comparison with val3 and the requeueing with the locks held.
>   =20
>    So that lock protection makes these operations 'atomic'. The
>    correct expression is 'serialized'.

###
So, here, i think I need some specific pointers on the precise text
changes that are required. Let's talk about this f2f. For convenience,
here's the relevant text once again quoted:

       FUTEX_CMP_REQUEUE (since Linux 2.6.7)
              This  operation  first  checks  whether the location uadd=
r
              still contains the value  val3.   If  not,  the  operatio=
n
              fails  with  the  error  EAGAIN.  Otherwise, the operatio=
n
              wakes up a maximum of val waiters that are waiting on  th=
e
              futex  at uaddr.  If there are more than val waiters, the=
n
              the remaining waiters are removed from the wait  queue  o=
f
              the  source  futex at uaddr and added to the wait queue o=
f
              the target futex at uaddr2.  The val2  argument  specifie=
s
              an  upper limit on the number of waiters that are requeue=
d
              to the futex at uaddr2.

              The load from uaddr is  an  atomic  memory  access  (i.e.=
,
              using atomic machine instructions of the respective archi=
=E2=80=90
              tecture).  This load, the comparison with  val3,  and  th=
e
              requeueing  of  any  waiters  are performed atomically an=
d
              totally ordered with respect to other  operations  on  th=
e
              same futex word.


>>>> .\" FIXME We need some explanation in the following paragraph of *=
why*
>>>> .\"       it is important to note that "the kernel will update the
>>>> .\"       futex word's value prior
>>>>        It is important to note to returning to user space" . Can s=
omeone
>>>>        explain?   that  the  kernel  will  update the futex word's=
 value
>>>>        prior to returning to user space.  Unlike the other futex  =
opera=E2=80=90
>>>>        tions  described  above, the PI futex operations are design=
ed for
>>>>        the implementation of very specific IPC mechanisms.
>>>
>>> If there are multiple waiters on a pi futex then a wake pi operatio=
n
>>> will wake the first waiter and hand over the lock to this waiter. T=
his
>>> includes handing over the rtmutex which represents the futex in the
>>> kernel. The strict requirement is that the futex owner and the rtmu=
tex
>>> owner must be the same, except for the update period which is
>>> serialized by the futex internal locking. That means the kernel mus=
t
>>> update the user space value prior to returning to user space.
>=20
> And as noted above: It must update while holding the proper locks.

(Okay.)


>>>> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darre=
n Hart
>>>> .\"       made the observation that "EINVAL is returned if the non=
-pi=20
>>>> .\"       to pi or op pairing semantics are violated."
>>>> .\"       Probably there needs to be a general statement about thi=
s
>>>> .\"       requirement, probably located at about this point in the=
 page.
>>>> .\"       Darren (or someone else), care to take a shot at this?
>>>
>>> Well, that's hard to describe because the kernel only has a limited
>>> way of detecting such mismatches. It only can detect it when there =
are
>>> non PI waiters on a futex and a PI function is called or vice versa=
=2E
>>
>> Hmmm. Okay, I filed your comments away for reference, but
>> hopefully someone can help with some actual text.
>=20
> I let Darren come up with something sensible :)

Okay, let's see if Darren has something to say.

>>>> .\" FIXME Somewhere on this page (I guess under the discussion of =
PI
>>>> .\"       futexes) we need a discussion of the FUTEX_OWNER_DIED bi=
t.
>>>> .\"       Can someone propose a text?
>>>
>>> If a futex has a rtmutex associated in the kernel, i.e. when there =
are
>>> blocked waiters, and the owner of the futex/rtmutex dies unexpected=
ly,
>>> then the kernel cleans up the rtmutex (as it holds a reference to t=
he
>>> dying task) and hands it over to the next waiter. That requires tha=
t
>>> the user space value is updated accordingly. The kernel sets the
>>> FUTEX_OWNER_DIED in the user space value along with the TID of the =
new
>>> owner. User space is responsible for cleaning this up, though there
>>> are cases where the kernel does the cleanup.
>>> =20
>>> The FUTEX_OWNER_DIED bit can also be set on uncontended futexes, wh=
ere
>>> the kernel has no state associated. This happens via the robust fut=
ex
>>> mechanism. In that case the futex value will be set to
>>> FUTEX_OWNER_DIED. The robust futex mechanism is also available for =
non
>>> PI futexes.
>>
>> ???
>> So, I added part of that text to the page, as follows:
>>
>>        If  a futex has an associated RT-mutex in the kernel (i.e., t=
here
>>        are blocked waiters) and the owner  of  the  futex/RT-mutex  =
dies
>>        unexpectedly, then the kernel cleans up the RT-mutex and hand=
s it
>>        over to the next waiter.  This in turn requires  that  the  u=
ser-
>>        space  value  is  updated  accordingly.  To indicate that thi=
s is
>>        required, the kernel sets the FUTEX_OWNER_DIED bit in  the  f=
utex
>>        word  along  with  the thread ID of the new owner.  User spac=
e is
>>        then responsible for cleaning this up  (though  there  are  c=
ases
>>        where the kernel does the cleanup).
>>
>> Okay?
>>
>> I think the last sentence still requires a little work though. What =
does
>> user space need to do in terms of clean up?
>=20
> User space has usually state as well. So the FUTEX_OWNER_DIED bit
> tells userspace that it needs to cleanup the stale state left over by
> the dead owner.

###
So I changed the last sentence to=20

    User space is then responsible for cleaning up the stale state left
    over by the dead owner.

Okay?

>>>> .\" FIXME In the next line, what type of "priority" are we talking=
 about?
>>>> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
>>>> .\"       Or something else?
>>>>
>>>>               The
>>>>               enqueueing  of  the waiter is in descending priority=
 order
>>>>               if more than one waiter exists. =20
>>>
>>> That also covers sched deadline.
>>
>> ???
>> Thanks. If the realm is restricted purely to SCHED_OTHER (SCHED_NORM=
AL)
>> processes, does the nice value come into play also?
>=20
> No. SCHED_OTHER/NORMAL tasks are handled in FIFO order.

Okay. Thanks.

>> So by now, I've reworked this text to be:
>>
>>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
>>               This operation tries to acquire the futex at uaddr.  I=
t is
>>               invoked when a user-space atomic acquire did  not  suc=
ceed
>>               because the futex word was not 0.
>>
>>               The trylock in kernel might succeed because the futex =
word
>>               contains     stale     state     (FUTEX_WAITERS     an=
d/or
>>               FUTEX_OWNER_DIED).   This can happen when the owner of=
 the
>>               futex died.  User space cannot handle this condition i=
n  a
>>               race-free manner
>>
>> Okay?
>>
>> I must admit that I find "the trylock in kernel might succeed"hard
>> to understand. Could you elaborate a little?
>=20
> If the user space value has stale state, then the kernel can fix that
> up and acquire the futex.


Okay, so I made the last sentence:

    User space cannot handle this condition in a race-free manner,
    but the kernel can fix this up and acquire the futex.

Okay?

However, I realize I should have said more clearly why I find the text
hard to understand. As I read this text:

    The trylock in kernel might succeed because the futex word
    contains stale state FUTEX_WAITERS and/or FUTEX_OWNER_DIED).

###

The words "The trylock in kernel might succeed" makes it feel
like a contrast is being drawn with some other scenario, but
it's not clear what that alternative/contrast is. Do you see
what I mean? Let's talk about this f2f.

>> ???
>> So now I've reworded the opening text describing FUTEX_WAIT_REQUEUE_=
PI
>> as follows:
>>
>>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
>>               Wait on  a  non-PI  futex  at  uaddr  and  potentially=
  be
>>               requeued  (via a FUTEX_CMP_REQUEUE_PI operation in ano=
ther
>>               task) onto a PI futex at uaddr2.  The  wait  operation=
  on
>>               uaddr is the same as for FUTEX_WAIT.
>>
>>               The  waiter  can be removed from the wait on uaddr wit=
hout
>>               requeueing on uaddr2 via a FUTEX_WAIT operation in ano=
ther
>=20
> s/FUTEX_WAIT/FUTEX_WAKE/

Thanks. Fixed.

>>               task.   In  this case, the FUTEX_WAIT_REQUEUE_PI opera=
tion
>>               returns with the error EWOULDBLOCK.
>>
>> Okay?
>=20
> Yes.

Thanks.

Cheers,

Michael



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
