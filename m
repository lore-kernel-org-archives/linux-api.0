From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Sat, 08 Aug 2015 08:57:35 +0200
Message-ID: <55C5A85F.3020202@gmail.com>
References: <55B61EF3.7080302@gmail.com> <20150805222140.GA74817@vmdeb7>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805222140.GA74817@vmdeb7>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Darren,

Some of my comments below will refer to the reply I just sent
to tglx (and the list) a few minutes ago.

On 08/06/2015 12:21 AM, Darren Hart wrote:
> On Mon, Jul 27, 2015 at 02:07:15PM +0200, Michael Kerrisk (man-pages)=
 wrote:
>> Hello all,
>>
>=20
> Michael, thank you for your diligence in following up and collecting
> reviews. I've attempted to respond to what I was specifically called =
out
> in or where I had something specific to add in addition to other
> replies.

Thanks!

> After this, will you send another version (numbered for reference
> maybe?) with any remaining FIXMEs that haven't yet been addressed
> according to your accounting?

Yes, I'll be sending out another draft (probably after a short delay,
while I see what further responses come back on the mails I just sent.)
In any case, the latest version of the page can be found at
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddraft_=
futex

>>    Priority-inheritance futexes
>>        Linux supports priority-inheritance (PI) futexes in order to =
han=E2=80=90
>>        dle priority-inversion problems that can be encountered with =
nor=E2=80=90
>>        mal  futex  locks.  Priority inversion is the problem that oc=
curs
>>        when a high-priority task is blocked waiting to  acquire  a  =
lock
>>        held  by a low-priority task, while tasks at an intermediate =
pri=E2=80=90
>>        ority continuously preempt the low-priority task  from  the  =
CPU.
>>        Consequently,  the  low-priority  task  makes  no progress to=
ward
>>        releasing the lock, and the high-priority task remains blocke=
d.
>>
>>        Priority inheritance is a mechanism for dealing with  the  pr=
ior=E2=80=90
>>        ity-inversion problem.  With this mechanism, when a high-prio=
rity
>>        task becomes blocked by a lock held by a low-priority  task, =
 the
>>        latter's priority is temporarily raised to that of the former=
, so
>>        that it is not preempted by any intermediate level tasks, and=
 can
>>        thus  make  progress toward releasing the lock.  To be effect=
ive,
>>        priority inheritance must be transitive, meaning that if a  h=
igh-
>>        priority task blocks on a lock held by a lower-priority task =
that
>>        is itself blocked by lock held by  another  intermediate-prio=
rity
>>        task  (and  so  on, for chains of arbitrary length), then bot=
h of
>>        those task (or more generally, all of the tasks in a lock  ch=
ain)
>>        have  their priorities raised to be the same as the high-prio=
rity
>>        task.
>>
>> .\" FIXME XXX The following is my attempt at a definition of PI fute=
xes,
>> .\"       based on mail discussions with Darren Hart. Does it seem o=
kay?
>>
>>        From a user-space perspective, what makes a futex PI-aware  i=
s  a
>>        policy  agreement  between  user  space  and the kernel about=
 the
>>        value of the futex word (described in a moment), coupled with=
 the
>>        use  of  the  PI futex operations described below (in particu=
lar,
>>        FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and FUTEX_CMP_REQUEUE_PI).
>=20
> Yes. Was this intended to be a complete opcode list?=20

No. I'll remove that list, in case its misunderstood that way.

> PI operations must
> use paired operations.
>=20
> (FUTEX_LOCK_PI | FUTEX_TRYLOCK_PI) : FUTEX_UNLOCK_PI
> FUTEX_WAIT_REQUEUE_PI : FUTEX_CMP_REQUEUE_PI

And now I've made that point explicitly in the page. See my comment=20
lower down.

> And their PRIVATE counterparts of course (which is assumed as it is a
> flag to the opcode).

Yes. But I don't think that needs to be called out explicitly here (?).

>> .\" FIXME XXX =3D=3D=3D=3D=3D Start of adapted Hart/Guniguntala text=
 =3D=3D=3D=3D=3D
>> .\"       The following text is drawn from the Hart/Guniguntala pape=
r
>> .\"       (listed in SEE ALSO), but I have reworded some pieces
>> .\"       significantly. Please check it.
>>
>>        The PI futex operations described below  differ  from  the  o=
ther
>>        futex  operations  in  that  they impose policy on the use of=
 the
>>        value of the futex word:
>>
>>        *  If the lock is not acquired, the futex word's value  shall=
  be
>>           0.
>>
>>        *  If  the  lock is acquired, the futex word's value shall be=
 the
>>           thread ID (TID; see gettid(2)) of the owning thread.
>>
>>        *  If the lock is owned and there are threads contending for =
 the
>>           lock,  then  the  FUTEX_WAITERS  bit shall be set in the f=
utex
>>           word's value; in other words, this value is:
>>
>>               FUTEX_WAITERS | TID
>>
>>
>>        Note that a PI futex word never just has the value FUTEX_WAIT=
ERS,
>>        which is a permissible state for non-PI futexes.
>=20
> The second clause is inappropriate. I don't know if that was yours or
> mine, but non-PI futexes do not have a kernel defined value policy, s=
o
> =3D=3DFUTEX_WAITERS cannot be a "permissible state" as any value is
> permissible for non-PI futexes, and none have a kernel defined state.
>=20
> Perhaps include a Note under the third bullet as:
>=20
> 	  Note: It is invalid for a PI futex word to have no owner and
> 	        FUTEX_WAITERS set.

Done.

>>        With this policy in place, a user-space application can acqui=
re a
>>        not-acquired lock or release a lock that no other threads try=
  to
>=20
> "that no other threads try to acquire" seems out of place. I think
> "atomic instructions" is sufficient to express how contention is
> handled.

Yup, changed.

>>        acquire using atomic instructions executed in user space (e.g=
=2E, a
>>        compare-and-swap operation such as cmpxchg on the  x86  archi=
tec=E2=80=90
>>        ture).   Acquiring  a  lock simply consists of using compare-=
and-
>>        swap to atomically set the futex word's value to the caller's=
 TID
>>        if  its  previous  value  was 0.  Releasing a lock requires u=
sing
>>        compare-and-swap to set the futex word's value to 0 if the pr=
evi=E2=80=90
>>        ous value was the expected TID.
>>
>>        If a futex is already acquired (i.e., has a nonzero value), w=
ait=E2=80=90
>>        ers must employ the FUTEX_LOCK_PI operation to acquire the  l=
ock.
>>        If other threads are waiting for the lock, then the FUTEX_WAI=
TERS
>>        bit is set in the futex value; in this case, the lock owner  =
must
>>        employ the FUTEX_UNLOCK_PI operation to release the lock.
>>
>>        In  the  cases  where  callers  are forced into the kernel (i=
=2Ee.,
>>        required to perform a futex() call), they then deal directly =
with
>>        a so-called RT-mutex, a kernel locking mechanism which implem=
ents
>>        the required priority-inheritance semantics.  After the  RT-m=
utex
>>        is  acquired,  the futex value is updated accordingly, before=
 the
>>        calling thread returns to user space.
>=20
> This last paragraph relies on kernel implementation rather than
> behavior. If the RT-mutex is renamed or the mechanism is implemented
> differently in futexes, this section will require updating. Is that
> appropriate for a user-space man page?

In the end, I'm not sure. This is (so far) my best attempt at trying
to convey an explanation of the behavior provided by the API.

>> .\" FIXME =3D=3D=3D=3D=3D End of adapted Hart/Guniguntala text =3D=3D=
=3D=3D=3D
>>
>>
>>
>> .\" FIXME We need some explanation in the following paragraph of *wh=
y*
>> .\"       it is important to note that "the kernel will update the
>> .\"       futex word's value prior
>>        It is important to note to returning to user space" . Can som=
eone
>>        explain?   that  the  kernel  will  update the futex word's v=
alue
>>        prior to returning to user space.  Unlike the other futex  op=
era=E2=80=90
>>        tions  described  above, the PI futex operations are designed=
 for
>>        the implementation of very specific IPC mechanisms.
>=20
> If the kernel didn't perform the update prior to returning to userspa=
ce,
> we could end up in an invalid state. Such as having an owner, but the
> value being 0. Or having waiters, but not having FUTEX_WAITERS set.

So I've now reworked this passage to read:

       It  is  important  to  note that the kernel will update the fute=
x
       word's value prior to returning to user  space.   (This  prevent=
s
       the possibility of the futex word's value ending up in an invali=
d
       state, such as having an owner but the value being 0,  or  havin=
g
       waiters but not having the FUTEX_WAITERS bit set.)

Okay?

>> .\"
>> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren =
Hart
>> .\"       made the observation that "EINVAL is returned if the non-p=
i=20
>> .\"       to pi or op pairing semantics are violated."
>> .\"       Probably there needs to be a general statement about this
>> .\"       requirement, probably located at about this point in the p=
age.
>> .\"       Darren (or someone else), care to take a shot at this?
>=20
> We can probably borrow from either the futex.c comments or the
> futex-requeue-pi.txt in Documentation. Also, it is important to note
> that the PI requeue operations require two distinct uadders (although
> that is implied by requiring "non-pi to pi" as a futex cannot be both=
=2E
>=20
> Or... perhaps something like:
>=20
> 	Due to the kernel imposed futex word value policy, PI futex
> 	operations have additional usage requirements:
> =09
> 	FUTEX_WAIT_REQUEUE_PI must be paired with FUTEX_CMP_REQUEUE_PI
> 	and be performed from a non-pi futex to a distinct pi futex.
> 	Failing to do so will return EINVAL.=20

=46or which operation does the EINVAL occur: FUTEX_WAIT_REQUEUE_PI or=20
=46UTEX_CMP_REQUEUE_PI?

>       Additionally,
> 	FUTEX_CMP_REQUEUE_PI requires that nr_wake=3D1. [We state in the
> 	docs that nr_requeue should be INT_MAX for broadcast and 0 for
> 	signal... but that may be overly specific to libc for this
> 	manual]
> =09
> 	Similarly, FUTEX_UNLOCK_PI must only be called on a futex owned
> 	by the calling thread as defined by the value policy, otherwise
> 	EPERM is returned.
>=20
> Were you looking for something like that - or were you looking for
> justification for these requirements?

That's good. I've reworked a piece of the page to be:

       PI futexes are operated on by specifying one of the values liste=
d
       below  in  futex_op.   Note  that the PI futex operations must b=
e
       used as paired operations and  are  subject  to  some  additiona=
l
       requirements:

       *  FUTEX_LOCK_PI  and FUTEX_TRYLOCK_PI pair with FUTEX_UNLOCK_PI=
=2E
          FUTEX_UNLOCK_PI must be called only on a futex  owned  by  th=
e
          calling  thread, as defined by the value policy, otherwise th=
e
          error EPERM results.

       *  FUTEX_WAIT_REQUEUE_PI pairs with  FUTEX_CMP_REQUEUE_PI.   Thi=
s
          must  be  performed from a non-PI futex to a distinct PI fute=
x
          (or the error EINVAL results).  Additionally, val (the  numbe=
r
          of  waiters  to  be  woken)  must  be  1  (or the error EINVA=
L
          results).

But see my question just above. I'll tweak the first bullet point a
little after I hear back from you.

> ...
>=20
>>        FUTEX_LOCK_PI (since Linux 2.6.18)
>> .\" FIXME I did some significant rewording of tglx's text to create
>> .\"       the text below.
>> .\"       Please check the following paragraph, in case I injected
>> .\"       errors.
>>               This  operation  is used after after an attempt to acq=
uire
>>               the lock  via  an  atomic  user-space  instruction  fa=
iled
>>               because  the  futex word has a nonzero value=E2=80=94s=
pecifically,
>>               because it contained the  namespace-specific  TID  of =
 the
>>               lock owner.
>=20
> Acked.

Thanks.

>>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
>> .\" FIXME I think it would be helpful here to say a few more words a=
bout
>> .\"       the difference(s) between FUTEX_LOCK_PI and FUTEX_TRYLOCK_=
PI.
>> .\"       Can someone propose something?
>>               This operation tries to acquire the futex  at  uaddr. =
  It
>>               deals  with  the situation where the TID value at uadd=
r is
>>               0, but the FUTEX_WAITERS bit is set.   User  space  ca=
nnot
>>               handle this condition in a race-free manner
>> .\" FIXME How does the situation in the previous sentence come about=
?
>> .\"       Probably it would be helpful to say something about that i=
n
>> .\"       the man page.
>> .\" FIXME And *how* does FUTEX_TRYLOCK_PI deal with this situation?
>=20
> I guess I wouldn't expect to see this detail in the manual. That stat=
e
> should never exist in userspace as far as I understand it, which make=
s
> it a kernel implementation detail and not relevant to a usage manual.

See my recent reply to Thomas Gleixner.

>>
>>        FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
>>               This operation is a PI-aware variant of FUTEX_CMP_REQU=
EUE.
>>               It    requeues    waiters    that    are    blocked   =
 via
>>               FUTEX_WAIT_REQUEUE_PI on uaddr from a non-PI source  f=
utex
>>               (uaddr) to a PI target futex (uaddr2).
>>
>>               As with FUTEX_CMP_REQUEUE, this operation wakes up a m=
axi=E2=80=90
>>               mum of val waiters that are waiting on the futex at ua=
ddr.
>>               However, for FUTEX_CMP_REQUEUE_PI, val is required to =
be 1
>>               (since the main point is to avoid a thundering herd). =
 The
>>               remaining  waiters  are removed from the wait queue of=
 the
>>               source futex at uaddr and added to the wait queue  of =
 the
>>               target futex at uaddr2.
>>
>>               The val2 and val3 arguments serve the same purposes as=
 for
>>               FUTEX_CMP_REQUEUE.
>> .\" FIXME The page at http://locklessinc.com/articles/futex_cheat_sh=
eet/
>> .\"       notes that "priority-inheritance Futex to priority-inherit=
ance
>> .\"       Futex requeues are currently unsupported". Do we need to s=
ay
>> .\"       something in the man page about that?
>>
>=20
> I noted this above in response to your request for detail about the
> *REQUEUE_PI semantics and error codes. Was that sufficient?

Between input from you and tglx, I think we're okay.

>>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
>>
>> .\" FIXME I find the next sentence (from tglx) pretty hard to grok.
>> .\"       Could someone explain it a bit more?
>>
>>               Wait operation to wait on a  non-PI  futex  at  uaddr =
 and
>>               potentially  be  requeued  onto a PI futex at uaddr2. =
 The
>>               wait operation on uaddr is the same  as  FUTEX_WAIT.  =
=20
>=20
> The point tglx is making here is that you must know ahead of time and
> tell the kernel that you intend to use this futex in a REQUEUE_PI
> operation, and not a regular REQUEUE. This is determined by the both =
the
> op codes as well as the required arguments, which I also documented
> above. Is more detail required?

I think I've got it now. See my revised version of this text in my repl=
y
to tglx, and let me know if anything is amiss.

>> .\" FIXME I'm not quite clear on the meaning of the following senten=
ce.
>> .\"       Is this trying to say that while blocked in a
>> .\"       FUTEX_WAIT_REQUEUE_PI, it could happen that another
>> .\"       task does a FUTEX_WAKE on uaddr that simply causes
>> .\"       a normal wake, with the result that the FUTEX_WAIT_REQUEUE=
_PI
>> .\"       does not complete? What happens then to the FUTEX_WAIT_REQ=
UEUE_PI
>> .\"       opertion? Does it remain blocked, or does it unblock
>> .\"       In which case, what does user space see?
>>
>>               The
>>               waiter   can  be  removed  from  the  wait  on  uaddr =
 via
>>               FUTEX_WAKE without requeueing on uaddr2.
>=20
> Userspace should see the task wake and continue executing. This would
> effectively be a cancelation operation - which I didn't think was
> supported. Thomas?

Thomas responded on this point, and I revised my text. Please see
my reply to tglx and let me know if anything is amiss.

>> .\" FIXME XXX The following is a reworded version of Darren Hart's t=
ext.
>> .\"       Please check that I did not introduce any errors.
>>        EINVAL (FUTEX_CMP_REQUEUE_PI) An attempt was made  to  requeu=
e  a
>>               waiter  to a futex other than that specified by the ma=
tch=E2=80=90
>>               ing FUTEX_WAIT_REQUEUE_PI call for that waiter.
>=20
> Acked.

Thanks!

Thanks for the help, Darren!

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
