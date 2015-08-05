From: Darren Hart <dvhart@infradead.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Wed, 5 Aug 2015 15:21:40 -0700
Message-ID: <20150805222140.GA74817@vmdeb7>
References: <55B61EF3.7080302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B61EF3.7080302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Torvald Riegel <triegel@redhat.com>, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>, Anton Blanchard <anton@samba.org>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>, Andy Lutomirski <luto@amacapital.net>, bert hubert <bert.hubert@netherlabs.nl>, Rusty Russell <rusty@rustcorp.com.au>, Heinrich Schuchardt <xypron.glpk@gmx.de>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 02:07:15PM +0200, Michael Kerrisk (man-pages) w=
rote:
> Hello all,
>=20

Michael, thank you for your diligence in following up and collecting
reviews. I've attempted to respond to what I was specifically called ou=
t
in or where I had something specific to add in addition to other
replies.

After this, will you send another version (numbered for reference
maybe?) with any remaining FIXMEs that haven't yet been addressed
according to your accounting?

=2E..

>    Priority-inheritance futexes
>        Linux supports priority-inheritance (PI) futexes in order to h=
an=E2=80=90
>        dle priority-inversion problems that can be encountered with n=
or=E2=80=90
>        mal  futex  locks.  Priority inversion is the problem that occ=
urs
>        when a high-priority task is blocked waiting to  acquire  a  l=
ock
>        held  by a low-priority task, while tasks at an intermediate p=
ri=E2=80=90
>        ority continuously preempt the low-priority task  from  the  C=
PU.
>        Consequently,  the  low-priority  task  makes  no progress tow=
ard
>        releasing the lock, and the high-priority task remains blocked=
=2E
>=20
>        Priority inheritance is a mechanism for dealing with  the  pri=
or=E2=80=90
>        ity-inversion problem.  With this mechanism, when a high-prior=
ity
>        task becomes blocked by a lock held by a low-priority  task,  =
the
>        latter's priority is temporarily raised to that of the former,=
 so
>        that it is not preempted by any intermediate level tasks, and =
can
>        thus  make  progress toward releasing the lock.  To be effecti=
ve,
>        priority inheritance must be transitive, meaning that if a  hi=
gh-
>        priority task blocks on a lock held by a lower-priority task t=
hat
>        is itself blocked by lock held by  another  intermediate-prior=
ity
>        task  (and  so  on, for chains of arbitrary length), then both=
 of
>        those task (or more generally, all of the tasks in a lock  cha=
in)
>        have  their priorities raised to be the same as the high-prior=
ity
>        task.
>=20
> .\" FIXME XXX The following is my attempt at a definition of PI futex=
es,
> .\"       based on mail discussions with Darren Hart. Does it seem ok=
ay?
>=20
>        From a user-space perspective, what makes a futex PI-aware  is=
  a
>        policy  agreement  between  user  space  and the kernel about =
the
>        value of the futex word (described in a moment), coupled with =
the
>        use  of  the  PI futex operations described below (in particul=
ar,
>        FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and FUTEX_CMP_REQUEUE_PI).

Yes. Was this intended to be a complete opcode list? PI operations must
use paired operations.

(FUTEX_LOCK_PI | FUTEX_TRYLOCK_PI) : FUTEX_UNLOCK_PI
=46UTEX_WAIT_REQUEUE_PI : FUTEX_CMP_REQUEUE_PI

And their PRIVATE counterparts of course (which is assumed as it is a
flag to the opcode).

>=20
> .\" FIXME XXX =3D=3D=3D=3D=3D Start of adapted Hart/Guniguntala text =
=3D=3D=3D=3D=3D
> .\"       The following text is drawn from the Hart/Guniguntala paper
> .\"       (listed in SEE ALSO), but I have reworded some pieces
> .\"       significantly. Please check it.
>=20
>        The PI futex operations described below  differ  from  the  ot=
her
>        futex  operations  in  that  they impose policy on the use of =
the
>        value of the futex word:
>=20
>        *  If the lock is not acquired, the futex word's value  shall =
 be
>           0.
>=20
>        *  If  the  lock is acquired, the futex word's value shall be =
the
>           thread ID (TID; see gettid(2)) of the owning thread.
>=20
>        *  If the lock is owned and there are threads contending for  =
the
>           lock,  then  the  FUTEX_WAITERS  bit shall be set in the fu=
tex
>           word's value; in other words, this value is:
>=20
>               FUTEX_WAITERS | TID
>=20
>=20
>        Note that a PI futex word never just has the value FUTEX_WAITE=
RS,
>        which is a permissible state for non-PI futexes.

The second clause is inappropriate. I don't know if that was yours or
mine, but non-PI futexes do not have a kernel defined value policy, so
=3D=3DFUTEX_WAITERS cannot be a "permissible state" as any value is
permissible for non-PI futexes, and none have a kernel defined state.

Perhaps include a Note under the third bullet as:

	  Note: It is invalid for a PI futex word to have no owner and
	        FUTEX_WAITERS set.

>=20
>        With this policy in place, a user-space application can acquir=
e a
>        not-acquired lock or release a lock that no other threads try =
 to

"that no other threads try to acquire" seems out of place. I think
"atomic instructions" is sufficient to express how contention is
handled.

>        acquire using atomic instructions executed in user space (e.g.=
, a
>        compare-and-swap operation such as cmpxchg on the  x86  archit=
ec=E2=80=90
>        ture).   Acquiring  a  lock simply consists of using compare-a=
nd-
>        swap to atomically set the futex word's value to the caller's =
TID
>        if  its  previous  value  was 0.  Releasing a lock requires us=
ing
>        compare-and-swap to set the futex word's value to 0 if the pre=
vi=E2=80=90
>        ous value was the expected TID.
>=20
>        If a futex is already acquired (i.e., has a nonzero value), wa=
it=E2=80=90
>        ers must employ the FUTEX_LOCK_PI operation to acquire the  lo=
ck.
>        If other threads are waiting for the lock, then the FUTEX_WAIT=
ERS
>        bit is set in the futex value; in this case, the lock owner  m=
ust
>        employ the FUTEX_UNLOCK_PI operation to release the lock.
>=20
>        In  the  cases  where  callers  are forced into the kernel (i.=
e.,
>        required to perform a futex() call), they then deal directly w=
ith
>        a so-called RT-mutex, a kernel locking mechanism which impleme=
nts
>        the required priority-inheritance semantics.  After the  RT-mu=
tex
>        is  acquired,  the futex value is updated accordingly, before =
the
>        calling thread returns to user space.

This last paragraph relies on kernel implementation rather than
behavior. If the RT-mutex is renamed or the mechanism is implemented
differently in futexes, this section will require updating. Is that
appropriate for a user-space man page?

> .\" FIXME =3D=3D=3D=3D=3D End of adapted Hart/Guniguntala text =3D=3D=
=3D=3D=3D
>=20
>=20
>=20
> .\" FIXME We need some explanation in the following paragraph of *why=
*
> .\"       it is important to note that "the kernel will update the
> .\"       futex word's value prior
>        It is important to note to returning to user space" . Can some=
one
>        explain?   that  the  kernel  will  update the futex word's va=
lue
>        prior to returning to user space.  Unlike the other futex  ope=
ra=E2=80=90
>        tions  described  above, the PI futex operations are designed =
for
>        the implementation of very specific IPC mechanisms.

If the kernel didn't perform the update prior to returning to userspace=
,
we could end up in an invalid state. Such as having an owner, but the
value being 0. Or having waiters, but not having FUTEX_WAITERS set.

> .\"
> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren H=
art
> .\"       made the observation that "EINVAL is returned if the non-pi=
=20
> .\"       to pi or op pairing semantics are violated."
> .\"       Probably there needs to be a general statement about this
> .\"       requirement, probably located at about this point in the pa=
ge.
> .\"       Darren (or someone else), care to take a shot at this?

We can probably borrow from either the futex.c comments or the
futex-requeue-pi.txt in Documentation. Also, it is important to note
that the PI requeue operations require two distinct uadders (although
that is implied by requiring "non-pi to pi" as a futex cannot be both.

Or... perhaps something like:

	Due to the kernel imposed futex word value policy, PI futex
	operations have additional usage requirements:
=09
	FUTEX_WAIT_REQUEUE_PI must be paired with FUTEX_CMP_REQUEUE_PI
	and be performed from a non-pi futex to a distinct pi futex.
	Failing to do so will return EINVAL. Additionally,
	FUTEX_CMP_REQUEUE_PI requires that nr_wake=3D1. [We state in the
	docs that nr_requeue should be INT_MAX for broadcast and 0 for
	signal... but that may be overly specific to libc for this
	manual]
=09
	Similarly, FUTEX_UNLOCK_PI must only be called on a futex owned
	by the calling thread as defined by the value policy, otherwise
	EPERM is returned.

Were you looking for something like that - or were you looking for
justification for these requirements?

=2E..

>        FUTEX_LOCK_PI (since Linux 2.6.18)
> .\" FIXME I did some significant rewording of tglx's text to create
> .\"       the text below.
> .\"       Please check the following paragraph, in case I injected
> .\"       errors.
>               This  operation  is used after after an attempt to acqu=
ire
>               the lock  via  an  atomic  user-space  instruction  fai=
led
>               because  the  futex word has a nonzero value=E2=80=94sp=
ecifically,
>               because it contained the  namespace-specific  TID  of  =
the
>               lock owner.

Acked.

=2E..

>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
> .\" FIXME I think it would be helpful here to say a few more words ab=
out
> .\"       the difference(s) between FUTEX_LOCK_PI and FUTEX_TRYLOCK_P=
I.
> .\"       Can someone propose something?
>               This operation tries to acquire the futex  at  uaddr.  =
 It
>               deals  with  the situation where the TID value at uaddr=
 is
>               0, but the FUTEX_WAITERS bit is set.   User  space  can=
not
>               handle this condition in a race-free manner
> .\" FIXME How does the situation in the previous sentence come about?
> .\"       Probably it would be helpful to say something about that in
> .\"       the man page.
> .\" FIXME And *how* does FUTEX_TRYLOCK_PI deal with this situation?

I guess I wouldn't expect to see this detail in the manual. That state
should never exist in userspace as far as I understand it, which makes
it a kernel implementation detail and not relevant to a usage manual.

=2E..

>=20
>        FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
>               This operation is a PI-aware variant of FUTEX_CMP_REQUE=
UE.
>               It    requeues    waiters    that    are    blocked    =
via
>               FUTEX_WAIT_REQUEUE_PI on uaddr from a non-PI source  fu=
tex
>               (uaddr) to a PI target futex (uaddr2).
>=20
>               As with FUTEX_CMP_REQUEUE, this operation wakes up a ma=
xi=E2=80=90
>               mum of val waiters that are waiting on the futex at uad=
dr.
>               However, for FUTEX_CMP_REQUEUE_PI, val is required to b=
e 1
>               (since the main point is to avoid a thundering herd).  =
The
>               remaining  waiters  are removed from the wait queue of =
the
>               source futex at uaddr and added to the wait queue  of  =
the
>               target futex at uaddr2.
>=20
>               The val2 and val3 arguments serve the same purposes as =
for
>               FUTEX_CMP_REQUEUE.
> .\" FIXME The page at http://locklessinc.com/articles/futex_cheat_she=
et/
> .\"       notes that "priority-inheritance Futex to priority-inherita=
nce
> .\"       Futex requeues are currently unsupported". Do we need to sa=
y
> .\"       something in the man page about that?
>=20

I noted this above in response to your request for detail about the
*REQUEUE_PI semantics and error codes. Was that sufficient?

>=20
>=20
>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
>=20
> .\" FIXME I find the next sentence (from tglx) pretty hard to grok.
> .\"       Could someone explain it a bit more?
>=20
>               Wait operation to wait on a  non-PI  futex  at  uaddr  =
and
>               potentially  be  requeued  onto a PI futex at uaddr2.  =
The
>               wait operation on uaddr is the same  as  FUTEX_WAIT.  =20

The point tglx is making here is that you must know ahead of time and
tell the kernel that you intend to use this futex in a REQUEUE_PI
operation, and not a regular REQUEUE. This is determined by the both th=
e
op codes as well as the required arguments, which I also documented
above. Is more detail required?

>=20
> .\" FIXME I'm not quite clear on the meaning of the following sentenc=
e.
> .\"       Is this trying to say that while blocked in a
> .\"       FUTEX_WAIT_REQUEUE_PI, it could happen that another
> .\"       task does a FUTEX_WAKE on uaddr that simply causes
> .\"       a normal wake, with the result that the FUTEX_WAIT_REQUEUE_=
PI
> .\"       does not complete? What happens then to the FUTEX_WAIT_REQU=
EUE_PI
> .\"       opertion? Does it remain blocked, or does it unblock
> .\"       In which case, what does user space see?
>=20
>               The
>               waiter   can  be  removed  from  the  wait  on  uaddr  =
via
>               FUTEX_WAKE without requeueing on uaddr2.

Userspace should see the task wake and continue executing. This would
effectively be a cancelation operation - which I didn't think was
supported. Thomas?

=2E..

>=20
> .\" FIXME XXX The following is a reworded version of Darren Hart's te=
xt.
> .\"       Please check that I did not introduce any errors.
>        EINVAL (FUTEX_CMP_REQUEUE_PI) An attempt was made  to  requeue=
  a
>               waiter  to a futex other than that specified by the mat=
ch=E2=80=90
>               ing FUTEX_WAIT_REQUEUE_PI call for that waiter.

Acked.

Thanks Michael!

--=20
Darren Hart
Intel Open Source Technology Center
