From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Thu, 8 Oct 2015 15:36:07 +0100
Message-ID: <20151008143607.GB101005@vmdeb7>
References: <55B61EF3.7080302@gmail.com>
 <alpine.DEB.2.11.1507282054370.3825@nanos>
 <55C5A787.9010806@gmail.com>
 <alpine.DEB.2.11.1508200042180.3873@nanos>
 <5614D836.7070506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5614D836.7070506-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 07, 2015 at 09:30:46AM +0100, Michael Kerrisk (man-pages) w=
rote:
> Hello Thomas,
>=20
> Thanks for the follow up!
>=20
> Some open questions below are marked with the string ###.

A couple of comments from me below, although I suspect you have this mu=
ch
covered already.

>=20
> On 08/19/2015 04:17 PM, Thomas Gleixner wrote:
> > On Sat, 8 Aug 2015, Michael Kerrisk (man-pages) wrote:
> >>>>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
> >>>>               This  operation  first  checks  whether the locati=
on uaddr
> >>>>               still contains the value  val3.   If  not,  the  o=
peration
> >>>>               fails  with  the  error  EAGAIN.  Otherwise, the o=
peration
> >>>>               wakes up a maximum of val waiters that are waiting=
 on  the
> >>>>               futex  at uaddr.  If there are more than val waite=
rs, then
> >>>>               the remaining waiters are removed from the wait  q=
ueue  of
> >>>>               the  source  futex at uaddr and added to the wait =
queue of
> >>>>               the target futex at uaddr2.  The val2  argument  s=
pecifies
> >>>>               an  upper limit on the number of waiters that are =
requeued
> >>>>               to the futex at uaddr2.
> >>>>
> >>>> .\" FIXME(Torvald) Is the following correct?  Or is just the dec=
ision
> >>>> .\" which threads to wake or requeue part of the atomic operatio=
n?
> >>>>
> >>>>               The load from uaddr is  an  atomic  memory  access=
  (i.e.,
> >>>>               using atomic machine instructions of the respectiv=
e archi=E2=80=90
> >>>>               tecture).  This load, the comparison with  val3,  =
and  the
> >>>>               requeueing  of  any  waiters  are performed atomic=
ally and
> >>>>               totally ordered with respect to other  operations =
 on  the
> >>>>               same futex word.
> >>>
> >>> It's atomic as the other atomic operations on the futex word. It'=
s
> >>> always performed with the proper lock(s) held in the kernel. That
> >>> means any concurrent operation will serialize on that lock(s). Us=
er
> >>> space has to make sure, that depending on the observed value no
> >>> concurrent operations happen, but that's something the kernel can=
not
> >>> control.
> >>
> >> ???
> >> Sorry, I'm not clear here. Is the current text correct then? Or is=
 some
> >> change needed.
> >=20
> > I think we need some change here because the meaning of atomic is
> > unclear. The basic rules of futexes are:
> >=20
> >  - All modifying operations on the futex value have to be done with
> >    atomic instructions, usually cmpxchg. That applies to both kerne=
l
> >    and user space.
> >=20
> >    That's the atomicity at the futex value level.
> >=20
> >  - In the kernel we have to create/modify/destroy state in order to
> >    provide the blocking/requeueing etc.
> >=20
> >    This state needs protection as well. So all operations related t=
o
> >    the kernel internal state are serialized on the hash bucket
> >    locks. The hash buckets are a scalability mechanism to avoid
> >    contention on a single lock protecting all kernel internal
> >    state. For simplicity reasons you can just think of a global loc=
k
> >    protecting all kernel internal state.
> >=20
> >    If the kernel creates/modifies state then it can be necessary to
> >    either reread the futex value or modify it. That happens under t=
he
> >    locks as well.
> >=20
> >    So in the case of requeue, we take the proper locks and perform =
the
> >    comparison with val3 and the requeueing with the locks held.
> >   =20
> >    So that lock protection makes these operations 'atomic'. The
> >    correct expression is 'serialized'.
>=20
> ###
> So, here, i think I need some specific pointers on the precise text
> changes that are required. Let's talk about this f2f. For convenience=
,
> here's the relevant text once again quoted:

Not speaking for tglx, but I think the point here is to distinguish bet=
ween
atomic (as in cmpxchg comparison tests performed on the futex word) and
serialized (as in the management of futex hashbuckets and task states).

>=20
>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
>               This  operation  first  checks  whether the location ua=
ddr
>               still contains the value  val3.   If  not,  the  operat=
ion
>               fails  with  the  error  EAGAIN.  Otherwise, the operat=
ion

Here you might explain the _CMP_ qualifier and note atomicity of the op=
eration:

The _CMP_ refers to the verification of the userspace state as specifie=
d by
through the arguments. This operation first atomically compares the val=
ue at
uaddr with the value val3 ...


>               wakes up a maximum of val waiters that are waiting on  =
the
>               futex  at uaddr.  If there are more than val waiters, t=
hen
>               the remaining waiters are removed from the wait  queue =
 of
>               the  source  futex at uaddr and added to the wait queue=
 of
>               the target futex at uaddr2.  The val2  argument  specif=
ies
>               an  upper limit on the number of waiters that are reque=
ued
>               to the futex at uaddr2.

And here, perhaps:
These operations are serialized on locks protecting the internal datast=
ructures
storing the kernel futex state.

I believe this paragraph is sufficient, but I'll comment on the second =
paragraph
below:

>=20
>               The load from uaddr is  an  atomic  memory  access  (i.=
e.,
>               using atomic machine instructions of the respective arc=
hi=E2=80=90
>               tecture).  This load, the comparison with  val3,

We are "atomic" up to here. ^

And what follows below is serialized by the hash bucket locks.:

>                and  the
>               requeueing  of  any  waiters  are performed atomically =
and
>               totally ordered with respect to other  operations  on  =
the
>               same futex word.

I personally think this is too much implementation detail for the man p=
age,
especially for FUTEX_CMP_REQUEUE which does not manipulate the futex wo=
rd value
from kernel space (We're not discussing PI here). The first paragraph i=
s
sufficient to fully describe the guaranteed behavior of the opcode.




>=20
>=20
> >>>> .\" FIXME We need some explanation in the following paragraph of=
 *why*
> >>>> .\"       it is important to note that "the kernel will update t=
he
> >>>> .\"       futex word's value prior
> >>>>        It is important to note to returning to user space" . Can=
 someone
> >>>>        explain?   that  the  kernel  will  update the futex word=
's value
> >>>>        prior to returning to user space.  Unlike the other futex=
  opera=E2=80=90
> >>>>        tions  described  above, the PI futex operations are desi=
gned for
> >>>>        the implementation of very specific IPC mechanisms.
> >>>
> >>> If there are multiple waiters on a pi futex then a wake pi operat=
ion
> >>> will wake the first waiter and hand over the lock to this waiter.=
 This
> >>> includes handing over the rtmutex which represents the futex in t=
he
> >>> kernel. The strict requirement is that the futex owner and the rt=
mutex
> >>> owner must be the same, except for the update period which is
> >>> serialized by the futex internal locking. That means the kernel m=
ust
> >>> update the user space value prior to returning to user space.
> >=20
> > And as noted above: It must update while holding the proper locks.
>=20
> (Okay.)
>=20
>=20
> >>>> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Dar=
ren Hart
> >>>> .\"       made the observation that "EINVAL is returned if the n=
on-pi=20
> >>>> .\"       to pi or op pairing semantics are violated."
> >>>> .\"       Probably there needs to be a general statement about t=
his
> >>>> .\"       requirement, probably located at about this point in t=
he page.
> >>>> .\"       Darren (or someone else), care to take a shot at this?
> >>>
> >>> Well, that's hard to describe because the kernel only has a limit=
ed
> >>> way of detecting such mismatches. It only can detect it when ther=
e are
> >>> non PI waiters on a futex and a PI function is called or vice ver=
sa.
> >>
> >> Hmmm. Okay, I filed your comments away for reference, but
> >> hopefully someone can help with some actual text.
> >=20
> > I let Darren come up with something sensible :)
>=20
> Okay, let's see if Darren has something to say.
>=20
> >>>> .\" FIXME Somewhere on this page (I guess under the discussion o=
f PI
> >>>> .\"       futexes) we need a discussion of the FUTEX_OWNER_DIED =
bit.
> >>>> .\"       Can someone propose a text?
> >>>
> >>> If a futex has a rtmutex associated in the kernel, i.e. when ther=
e are
> >>> blocked waiters, and the owner of the futex/rtmutex dies unexpect=
edly,
> >>> then the kernel cleans up the rtmutex (as it holds a reference to=
 the
> >>> dying task) and hands it over to the next waiter. That requires t=
hat
> >>> the user space value is updated accordingly. The kernel sets the
> >>> FUTEX_OWNER_DIED in the user space value along with the TID of th=
e new
> >>> owner. User space is responsible for cleaning this up, though the=
re
> >>> are cases where the kernel does the cleanup.
> >>> =20
> >>> The FUTEX_OWNER_DIED bit can also be set on uncontended futexes, =
where
> >>> the kernel has no state associated. This happens via the robust f=
utex
> >>> mechanism. In that case the futex value will be set to
> >>> FUTEX_OWNER_DIED. The robust futex mechanism is also available fo=
r non
> >>> PI futexes.
> >>
> >> ???
> >> So, I added part of that text to the page, as follows:
> >>
> >>        If  a futex has an associated RT-mutex in the kernel (i.e.,=
 there
> >>        are blocked waiters) and the owner  of  the  futex/RT-mutex=
  dies
> >>        unexpectedly, then the kernel cleans up the RT-mutex and ha=
nds it
> >>        over to the next waiter.  This in turn requires  that  the =
 user-
> >>        space  value  is  updated  accordingly.  To indicate that t=
his is
> >>        required, the kernel sets the FUTEX_OWNER_DIED bit in  the =
 futex
> >>        word  along  with  the thread ID of the new owner.  User sp=
ace is
> >>        then responsible for cleaning this up  (though  there  are =
 cases
> >>        where the kernel does the cleanup).
> >>
> >> Okay?
> >>
> >> I think the last sentence still requires a little work though. Wha=
t does
> >> user space need to do in terms of clean up?
> >=20
> > User space has usually state as well. So the FUTEX_OWNER_DIED bit
> > tells userspace that it needs to cleanup the stale state left over =
by
> > the dead owner.
>=20
> ###
> So I changed the last sentence to=20
>=20
>     User space is then responsible for cleaning up the stale state le=
ft
>     over by the dead owner.
>=20
> Okay?

We can't say much beyond it's userspace's problem now because how it's =
handled
will vary widely. It might be worth mentioning that userspace can use
=46UTEX_OWNER_DIED to detect this state and handle it appropriately.

>=20
> >>>> .\" FIXME In the next line, what type of "priority" are we talki=
ng about?
> >>>> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
> >>>> .\"       Or something else?
> >>>>
> >>>>               The
> >>>>               enqueueing  of  the waiter is in descending priori=
ty order
> >>>>               if more than one waiter exists. =20
> >>>
> >>> That also covers sched deadline.
> >>
> >> ???
> >> Thanks. If the realm is restricted purely to SCHED_OTHER (SCHED_NO=
RMAL)
> >> processes, does the nice value come into play also?
> >=20
> > No. SCHED_OTHER/NORMAL tasks are handled in FIFO order.
>=20
> Okay. Thanks.
>=20
> >> So by now, I've reworked this text to be:
> >>
> >>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
> >>               This operation tries to acquire the futex at uaddr. =
 It is
> >>               invoked when a user-space atomic acquire did  not  s=
ucceed
> >>               because the futex word was not 0.
> >>
> >>               The trylock in kernel might succeed because the fute=
x word
> >>               contains     stale     state     (FUTEX_WAITERS     =
and/or
> >>               FUTEX_OWNER_DIED).   This can happen when the owner =
of the
> >>               futex died.  User space cannot handle this condition=
 in  a
> >>               race-free manner
> >>
> >> Okay?
> >>
> >> I must admit that I find "the trylock in kernel might succeed"hard
> >> to understand. Could you elaborate a little?
> >=20
> > If the user space value has stale state, then the kernel can fix th=
at
> > up and acquire the futex.
>=20
>=20
> Okay, so I made the last sentence:
>=20
>     User space cannot handle this condition in a race-free manner,
>     but the kernel can fix this up and acquire the futex.
>=20
> Okay?
>=20
> However, I realize I should have said more clearly why I find the tex=
t
> hard to understand. As I read this text:
>=20
>     The trylock in kernel might succeed because the futex word
>     contains stale state FUTEX_WAITERS and/or FUTEX_OWNER_DIED).
>=20
> ###
>=20
> The words "The trylock in kernel might succeed" makes it feel
> like a contrast is being drawn with some other scenario, but
> it's not clear what that alternative/contrast is. Do you see
> what I mean? Let's talk about this f2f.

I presume you got this covered in Dublin:
The trylock in the kernel has more state, so it can independently verif=
y the
flags that userspace must trust implicitly.

>=20
> >> ???
> >> So now I've reworded the opening text describing FUTEX_WAIT_REQUEU=
E_PI
> >> as follows:
> >>
> >>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
> >>               Wait on  a  non-PI  futex  at  uaddr  and  potential=
ly  be
> >>               requeued  (via a FUTEX_CMP_REQUEUE_PI operation in a=
nother
> >>               task) onto a PI futex at uaddr2.  The  wait  operati=
on  on
> >>               uaddr is the same as for FUTEX_WAIT.
> >>
> >>               The  waiter  can be removed from the wait on uaddr w=
ithout
> >>               requeueing on uaddr2 via a FUTEX_WAIT operation in a=
nother
> >=20
> > s/FUTEX_WAIT/FUTEX_WAKE/
>=20
> Thanks. Fixed.
>=20
> >>               task.   In  this case, the FUTEX_WAIT_REQUEUE_PI ope=
ration
> >>               returns with the error EWOULDBLOCK.
> >>
> >> Okay?
> >=20
> > Yes.
>=20
> Thanks.
>=20
> Cheers,
>=20
> Michael
>=20
>=20
>=20
> --=20
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
>=20

--=20
Darren Hart
Intel Open Source Technology Center
