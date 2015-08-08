From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Sat, 08 Aug 2015 08:53:59 +0200
Message-ID: <55C5A787.9010806@gmail.com>
References: <55B61EF3.7080302@gmail.com> <alpine.DEB.2.11.1507282054370.3825@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507282054370.3825@nanos>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

Thank you for the comments below. This helps hugely:
more than 30 of my FIXMEs have now gone away!

I have a few open questions, which you can find
by searching for the string "???". If you would have
a chance to look at those, I'd appreciate it.

On 07/28/2015 10:23 PM, Thomas Gleixner wrote:
> On Mon, 27 Jul 2015, Michael Kerrisk (man-pages) wrote:
>>        FUTEX_CLOCK_REALTIME (since Linux 2.6.28)
>>               This   option   bit   can   be   employed  only  with =
 the
>>               FUTEX_WAIT_BITSET and FUTEX_WAIT_REQUEUE_PI operations=
=2E
>>
>>               If this option is set, the kernel  treats  timeout  as=
  an
>>               absolute time based on CLOCK_REALTIME.
>>
>> .\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?
>>               If  this  option  is not set, the kernel treats timeou=
t as
>>               relative time, measured against the CLOCK_MONOTONIC cl=
ock.
>=20
> That's correct.

Thanks.

>>        The operation specified in futex_op is one of the following:
>>
>>        FUTEX_WAIT (since Linux 2.6.0)
>>               This operation tests that the  value  at  the  futex  =
word
>>               pointed  to  by  the  address  uaddr  still  contains =
 the
>>               expected value  val,  and  if  so,  then  sleeps  awai=
ting
>>               FUTEX_WAKE  on  the  futex word.  The load of the valu=
e of
>>               the futex word is an atomic  memory  access  (i.e.,  u=
sing
>>               atomic  machine  instructions  of the respective archi=
tec=E2=80=90
>>               ture).  This load, the comparison with the expected va=
lue,
>>               and starting to sleep are performed atomically and tot=
ally
>>               ordered with respect to other futex operations on the =
same
>>               futex  word.  If the thread starts to sleep, it is con=
sid=E2=80=90
>>               ered a waiter on this futex word.  If the futex value =
does
>>               not  match  val,  then the call fails immediately with=
 the
>>               error EAGAIN.
>>
>>               The purpose of the comparison with the expected  value=
  is
>>               to  prevent  lost  wake-ups: If another thread changed=
 the
>>               value of the futex word after the calling  thread  dec=
ided
>>               to block based on the prior value, and if the other th=
read
>>               executed a FUTEX_WAKE operation (or similar wake-up) a=
fter
>>               the  value  change  and  before this FUTEX_WAIT operat=
ion,
>>               then the latter will observe the value change and will=
 not
>>               start to sleep.
>>
>>               If  the timeout argument is non-NULL, its contents spe=
cify
>>               a relative timeout for the wait, measured according to=
 the
>> .\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?
>=20
> Yes.

Thanks.

>=20
>>               CLOCK_MONOTONIC  clock.  (This interval will be rounde=
d up
>>               to the system clock  granularity,  and  kernel  schedu=
ling
>>               delays  mean  that  the blocking interval may overrun =
by a
>>               small amount.)
>=20
> 		The given wait time will be rounded up to the system
> 		clock granularity and is guaranteed not to expire
> 		early.
>=20
> There are a gazillion reasons why it can expire late, but the
> guarantee is that it never expires prematurely.
>=20
>> 		  If timeout is NULL, the call blocks indef=E2=80=90
>>               initely.
>=20
> Right.

Thanks. Reworded as you suggest.=20

>>               The arguments uaddr2 and val3 are ignored.
>>
>>
>>        FUTEX_WAKE (since Linux 2.6.0)
>>               This  operation  wakes at most val of the waiters that=
 are
>>               waiting (e.g., inside FUTEX_WAIT) on the futex word at=
 the
>>               address  uaddr.  Most commonly, val is specified as ei=
ther
>>               1 (wake up a single waiter) or INT_MAX (wake up all  w=
ait=E2=80=90
>>               ers).   No  guarantee  is provided about which waiters=
 are
>>               awoken (e.g., a waiter with a higher  scheduling  prio=
rity
>>               is  not  guaranteed to be awoken in preference to a wa=
iter
>>               with a lower priority).
>=20
> That's only correct up to Linux 2.6.21.
>=20
> Since 2.6.22 we have a priority ordered wakeup. For SCHED_OTHER
> threads this takes the nice level into account. Threads with the same
> priority are woken in FIFO order.

So, this got picked up in a little subthread by Peter Zijsltra. I'll
reply there.

>>               The arguments timeout, uaddr2, and val3 are ignored.
> =20
>>
>>        FUTEX_FD (from Linux 2.6.0 up to and including Linux 2.6.25)
>>               This operation creates a file descriptor that  is  ass=
oci=E2=80=90
>>               ated  with  the futex at uaddr.  The caller must close=
 the
>>               returned file descriptor after use.  When another  pro=
cess
>>               or  thread  performs  a  FUTEX_WAKE on the futex word,=
 the
>>               file  descriptor  indicates   as   being   readable   =
with
>>               select(2), poll(2), and epoll(7)
>>
>>               The  file  descriptor  can  be used to obtain asynchro=
nous
>>               notifications:  if  val  is  nonzero,  then  when  ano=
ther
>>               process  or  thread executes a FUTEX_WAKE, the caller =
will
>>               receive the signal number that was passed in val.
>>
>>               The arguments timeout, uaddr2 and val3 are ignored.
>>
>> .\" FIXME(Torvald) We never define "upped".  Maybe just remove the
>> .\"      following sentence?
>>               To prevent race conditions, the caller should test if =
 the
>>               futex has been upped after FUTEX_FD returns.
>=20
> Yes, just remove it.

Done.

>>               Because  it was inherently racy, FUTEX_FD has been rem=
oved
>>               from Linux 2.6.26 onward.
>>
>>        FUTEX_REQUEUE (since Linux 2.6.0)
>> .\" FIXME(Torvald) Is there some indication that FUTEX_REQUEUE is br=
oken
>> .\"     in general, or is this comment implicitly speaking about the
>> .\"     condvar (?) use case? If the latter we might want to weaken =
the
>> .\"     advice below a little.
>> .\" [Anyone else have input on this?]
>=20
> The condvar use case exposes the flaw nicely, but that's pretty much
> true for everything which wants a sane requeue operation.

Yep. I dealt with this in an earlier response to mail from Darren (wher=
e=20
you also replied). I've removed the warning that FUTEX_REQUEUE is broke=
n.

>>               Avoid using this operation.  It is broken for its inte=
nded
>>               purpose.  Use FUTEX_CMP_REQUEUE instead.
>>
>>               This    operation    performs    the    same    task  =
  as
>>               FUTEX_CMP_REQUEUE, except that no check is made using =
 the
>>               value in val3.  (The argument val3 is ignored.)
>>
>>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
>>               This  operation  first  checks  whether the location u=
addr
>>               still contains the value  val3.   If  not,  the  opera=
tion
>>               fails  with  the  error  EAGAIN.  Otherwise, the opera=
tion
>>               wakes up a maximum of val waiters that are waiting on =
 the
>>               futex  at uaddr.  If there are more than val waiters, =
then
>>               the remaining waiters are removed from the wait  queue=
  of
>>               the  source  futex at uaddr and added to the wait queu=
e of
>>               the target futex at uaddr2.  The val2  argument  speci=
fies
>>               an  upper limit on the number of waiters that are requ=
eued
>>               to the futex at uaddr2.
>>
>> .\" FIXME(Torvald) Is the following correct?  Or is just the decisio=
n
>> .\" which threads to wake or requeue part of the atomic operation?
>>
>>               The load from uaddr is  an  atomic  memory  access  (i=
=2Ee.,
>>               using atomic machine instructions of the respective ar=
chi=E2=80=90
>>               tecture).  This load, the comparison with  val3,  and =
 the
>>               requeueing  of  any  waiters  are performed atomically=
 and
>>               totally ordered with respect to other  operations  on =
 the
>>               same futex word.
>=20
> It's atomic as the other atomic operations on the futex word. It's
> always performed with the proper lock(s) held in the kernel. That
> means any concurrent operation will serialize on that lock(s). User
> space has to make sure, that depending on the observed value no
> concurrent operations happen, but that's something the kernel cannot
> control.

???
Sorry, I'm not clear here. Is the current text correct then? Or is some
change needed.

>>               This  operation was added as a replacement for the ear=
lier
>>               FUTEX_REQUEUE.  The difference is that the  check  of =
 the
>>               value  at uaddr can be used to ensure that requeueing =
hap=E2=80=90
>>               pens only under certain conditions.  Both  operations =
 can
>>               be   used   to  avoid  a  "thundering  herd"  effect  =
when
>>               FUTEX_WAKE is used and all of the waiters that  are  w=
oken
>>               need to acquire another futex.
>>
>> .\" FIXME Please review the following new paragraph to see if it is
>> .\"       accurate.
>>               Typical  values to specify for val are 0 or or 1.  (Sp=
eci=E2=80=90
>>               fying INT_MAX is not useful, because  it  would  make =
 the
>>               FUTEX_CMP_REQUEUE  operation  equivalent  to  FUTEX_WA=
KE.)
>>               The limit value specified via val2 is typically  eithe=
r  1
>>               or  INT_MAX.  (Specifying the argument as 0 is not use=
ful,
>>               because it  would  make  the  FUTEX_CMP_REQUEUE  opera=
tion
>>               equivalent to FUTEX_WAIT.)
>=20
> It's correct.

Thanks.

>> .\" FIXME Here, it would be helpful to have an example of how
>> .\"       FUTEX_CMP_REQUEUE might be used, at the same time illustra=
ting
>> .\"       why FUTEX_WAKE is unsuitable for the same use case.
>=20
> Waiters:
>=20
>   lock(A)
>   while (!check_value(V)) {
>   	unlock(A);
> 	block_on(B);
> 	lock(A);
>   };
>   unlock(A);
>=20
> Note: B is a wait queue implemented with futexes.
> =20
> If the waker would use FUTEX_WAKE and wake all waiters waiting on B
> then those would all try to acquire lock A. That's called thundering
> herd and pointless because all except one would immediately block on
> lock A again.
>=20
> Requeueing prevents that because it only wakes one waiter and moves
> the other waiters to lock A. When that waiter unlocks A then the next
> waiter can proceed ...

Thanks, I used a lot of that text.

[...]

>>        FUTEX_WAKE_BITSET (since Linux 2.6.25)
>>               This operation is the same as FUTEX_WAKE except  that =
 the
>>               val3  argument  is  used to provide a 32-bit bitset to=
 the
>>               kernel.  This bitset  is  used  to  select  which  wai=
ters
>>               should  be  woken up.  The selection is done by a bit-=
wise
>>               AND of the "wake" bitset (i.e., the value in val3) and=
 the
>>               bitset which is stored in the kernel-internal state of=
 the
>>               waiter   (the   "wait"   bitset   that   is   set    u=
sing
>>               FUTEX_WAIT_BITSET).   All  of  the  waiters  for which=
 the
>>               result of the AND is nonzero are woken up;  the  remai=
ning
>>               waiters are left sleeping.
>>
>> .\" FIXME XXX Is this next paragraph that I added okay?
>>               The  effect  of FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSE=
T is
>>               to allow selective wake-ups among  multiple  waiters  =
that
>>               are  blocked on the same futex.  Note, however, that u=
sing
>>               this bitset multiplexing feature on a futex is less  e=
ffi=E2=80=90
>>               cient  than simply using multiple futexes, because emp=
loy=E2=80=90
>=20
> 		s/is less efficient/can be less efficient/
>=20
> It really depends on the usecase.

Thanks. Amended as you suggest.

>>               ing bitset multiplexing requires the kernel to  check =
 all
>>               waiters  on  a  futex, including those that are not in=
ter=E2=80=90
>>               ested in being woken up (i.e., they do not have the  r=
ele=E2=80=90
>>               vant bit set in their "wait" bitset).
>>
>>               The uaddr2 and timeout arguments are ignored.
>>
>>               The  FUTEX_WAIT  and  FUTEX_WAKE  operations correspon=
d to
>>               FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSET  operations  w=
here
>>               the bitsets are all ones.
>>
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
>>
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
>>
>>        With this policy in place, a user-space application can acqui=
re a
>>        not-acquired lock or release a lock that no other threads try=
  to
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
>> .\" FIXME =3D=3D=3D=3D=3D End of adapted Hart/Guniguntala text =3D=3D=
=3D=3D=3D
>=20
> That's correct.

Thanks.

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
> If there are multiple waiters on a pi futex then a wake pi operation
> will wake the first waiter and hand over the lock to this waiter. Thi=
s
> includes handing over the rtmutex which represents the futex in the
> kernel. The strict requirement is that the futex owner and the rtmute=
x
> owner must be the same, except for the update period which is
> serialized by the futex internal locking. That means the kernel must
> update the user space value prior to returning to user space.

Okay -- thanks. I've noted these details, but need to consider more abo=
ut
what changes (if any) are needed to the page.

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
> Well, that's hard to describe because the kernel only has a limited
> way of detecting such mismatches. It only can detect it when there ar=
e
> non PI waiters on a futex and a PI function is called or vice versa.

Hmmm. Okay, I filed your comments away for reference, but
hopefully someone can help with some actual text.

>> .\" FIXME Somewhere on this page (I guess under the discussion of PI
>> .\"       futexes) we need a discussion of the FUTEX_OWNER_DIED bit.
>> .\"       Can someone propose a text?
>=20
> If a futex has a rtmutex associated in the kernel, i.e. when there ar=
e
> blocked waiters, and the owner of the futex/rtmutex dies unexpectedly=
,
> then the kernel cleans up the rtmutex (as it holds a reference to the
> dying task) and hands it over to the next waiter. That requires that
> the user space value is updated accordingly. The kernel sets the
> FUTEX_OWNER_DIED in the user space value along with the TID of the ne=
w
> owner. User space is responsible for cleaning this up, though there
> are cases where the kernel does the cleanup.
> =20
> The FUTEX_OWNER_DIED bit can also be set on uncontended futexes, wher=
e
> the kernel has no state associated. This happens via the robust futex
> mechanism. In that case the futex value will be set to
> FUTEX_OWNER_DIED. The robust futex mechanism is also available for no=
n
> PI futexes.

???
So, I added part of that text to the page, as follows:

       If  a futex has an associated RT-mutex in the kernel (i.e., ther=
e
       are blocked waiters) and the owner  of  the  futex/RT-mutex  die=
s
       unexpectedly, then the kernel cleans up the RT-mutex and hands i=
t
       over to the next waiter.  This in turn requires  that  the  user=
-
       space  value  is  updated  accordingly.  To indicate that this i=
s
       required, the kernel sets the FUTEX_OWNER_DIED bit in  the  fute=
x
       word  along  with  the thread ID of the new owner.  User space i=
s
       then responsible for cleaning this up  (though  there  are  case=
s
       where the kernel does the cleanup).

Okay?

I think the last sentence still requires a little work though. What doe=
s
user space need to do in terms of clean up?


>>        PI futexes are operated on by specifying  one  of  the  follo=
wing
>>        values in futex_op:
>>
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
>> .\" FIXME In the preceding line, what does "namespace-specific" mean=
?
>> .\"       (I kept those words from tglx.)
>> .\"       That is, what kind of namespace are we talking about?
>> .\"       (I suppose we are talking PID namespaces here, but I want =
to
>> .\"       be sure.)
>=20
> Yes.

Thanks.

>>               The  operation  checks  the value of the futex word at=
 the
>>               address uaddr.  If the value is 0, then the  kernel  t=
ries
>>               to atomically set the futex value to the caller's TID.=
 =20
>> .\" FIXME What would be the cause(s) of failure referred to
>> .\"       in the following sentence?
>>               If
>>               that fails, or the futex word's value is nonzero, the =
ker=E2=80=90
>=20
> 'If that fails' does not make sense. If the user space access fails w=
e
> return -EFAULT and let user space deal with the mess.

Okay. , I removed "that fails, or"
>=20
> The operation here is similar to the FUTEX_WAIT logic. When the user
> space atomic acquire does not succeed because the futex value was non
> zero, then the waiter goes into the kernel, takes the kernel internal
> lock and retries the acquisition under the lock. If the acquisition
> does not succeed either, then it sets the FUTEX_WAITERS bit, to signa=
l
> the lock owner that it needs to go into the kernel. Here is the pseud=
o
> code:
>=20
> 		lock(kernel_lock);
> 	retry:
> 	=09
> 		/*
> 		 * Owner might have unlocked in userspace before we
> 		 * were able to set the waiter bit.
> 		 */
> 		if (atomic_acquire(futex) =3D=3D SUCCESS) {
> 		   unlock(kernel_lock());
> 		   return 0;
> 		}
>=20
> 		/*
> 		 * Owner might have unlocked after the above atomic_acquire()
> 		 * attempt.
> 		 */
> 		if (atomic_set_waiters_bit(futex) !=3D SUCCESS)
> 		   goto retry;
>=20
> 		queue_waiter();
> 		unlock(kernel_lock);
> 		block();  =20

Thanks, I filed the above point away as a comment in the source.

>>               nel  atomically  sets the FUTEX_WAITERS bit, which sig=
nals
>>               the futex owner that it cannot unlock the  futex  in  =
user
>>               space  atomically  by setting the futex value to 0.  A=
fter
>>               that, the kernel tries to find the thread which is ass=
oci=E2=80=90
>>               ated with the owner TID, creates or reuses kernel stat=
e on
>>               behalf of the owner and attaches the waiter  to  it.  =
=20
>> .\" FIXME Could I get a bit more detail on the previous lines?
>> .\"       What is "creates or reuses kernel state" about?
>> .\"       (I think this needs to be clearer in the page)
>=20
> If this is the first waiter then there is no kernel state for this
> futex, so it is created. That means the rtmutex is locked and the
> futex owner established as the owner of the rtmutex. If there is a
> waiter, then the state is reused, i.e. the new waiter is enqueued int=
o
> the rtmutex waiter list.

Thanks, I've reworked this passage somewhat, to read:

              The operation checks the value of the futex  word  at  th=
e
              address  uaddr.   If the value is 0, then the kernel trie=
s
              to atomically set the futex value to the caller's TID.  I=
f
              the  futex  word's value is nonzero, the kernel atomicall=
y
              sets the FUTEX_WAITERS bit, which signals the futex  owne=
r
              that  it  cannot unlock the futex in user space atomicall=
y
              by setting the futex value to 0.  After that, the kernel:

              1. Tries to find the thread which is associated  with  th=
e
                 owner TID.

              2. Creates  or reuses kernel state on behalf of the owner=
=2E
                 (If this is the first waiter, there is no kernel  stat=
e
                 for  this  futex, so kernel state is created by lockin=
g
                 the RT-mutex and the futex owner is made the  owner  o=
f
                 the  RT-mutex.  If there are existing waiters, then th=
e
                 existing state is reused.)

              3. Attaches the waiter to it (i.e., the waiter is enqueue=
d
                 on the RT-mutex waiter list).

>> .\" FIXME In the next line, what type of "priority" are we talking a=
bout?
>> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
>> .\"       Or something else?
>>
>>               The
>>               enqueueing  of  the waiter is in descending priority o=
rder
>>               if more than one waiter exists. =20
>=20
> That also covers sched deadline.

???
Thanks. If the realm is restricted purely to SCHED_OTHER (SCHED_NORMAL)
processes, does the nice value come into play also?


>> .\" FIXME In the next sentence, what type of "priority" are we talki=
ng about?
>> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
>> .\"       Or something else?
>> .\" FIXME What does "bandwidth" refer to in the next sentence?
>>
>>               The owner inherits either
>>               the priority or the bandwidth of the waiter. =20
>=20
> If the highest priority waiter is SCHED_DEADLINE, then the owner
> inherits cpu bandwidth from the waiter as there is no priority
> associated to SCHED_DEADLINE tasks.
>=20
> If the highest priority waiter is SCHED_FIFO/RR, then the owner
> inherits the waiter priority.

Thanks!

>> .\" FIXME In the preceding sentence, what determines whether the
>> .\"       owner inherits the priority versus the bandwidth?
>>
>> .\" FIXME Could I get some help translating the next sentence into
>> .\"       something that user-space developers (and I) can understan=
d?
>> .\"       In particular, what are "nested locks" in this context?
>>
>>               This inheri=E2=80=90
>>               tance follows the lock chain in the case of nested loc=
king
>>               and performs deadlock detection.
>=20
> T1 blocks on lock A held by T2
> T2 blocks on lock B held by T3
>=20
> So we have a lock chain A, B. The inheritance mechanism follows the
> lock chain and propagates the highest waiter priority up to the end o=
f
> the chain.

Thanks.

By now, I have reworded this passage to read:

             If  more  than  one  waiter  exists, the enqueueing of the
              waiter is in descending priority order.  (For  informatio=
n
              on   priority   ordering,   see   the  discussion  of  th=
e
              SCHED_DEADLINE, SCHED_FIFO, and SCHED_RR scheduling  poli=
=E2=80=90
              cies in sched(7).)  The owner inherits either the waiter'=
s
              CPU bandwidth  (if  the  waiter  is  scheduled  under  th=
e
              SCHED_DEADLINE  policy)  or  the waiter's priority (if th=
e
              waiter is scheduled under the SCHED_RR or SCHED_FIFO  pol=
=E2=80=90
              icy).  This inheritance follows the lock chain in the cas=
e
              of nested locking (i.e., task 1 blocks on lock A, held  b=
y
              task 2, while task 2 blocks on lock B, held by task 3) an=
d
              performs deadlock detection.

>> .\" FIXME tglx said "The timeout argument is handled as described in
>> .\"       FUTEX_WAIT." However, it appears to me that this is not ri=
ght.
>> .\"       Is the following formulation correct?
>>               The  timeout  argument  provides  a  timeout  for the =
lock
>>               attempt.  It is interpreted as an absolute time,  meas=
ured
>>               against the CLOCK_REALTIME clock.  If timeout is NULL,=
 the
>>               operation will block indefinitely.
>=20
> Indeed.

Thanks.

>>               The uaddr2, val, and val3 arguments are ignored.
>>
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
> That should be expressed differently:
>=20
>      	    This operation tries to acquire the futex at uaddr. It's
>      	    invoked when the user space atomic acquire did not
>      	    succeed because the user space value was not 0.
>=20
> 	    The trylock in kernel might succeed because the user space
> 	    value contains stale state (FUTEX_WAITERS and or
> 	    FUTEX_OWNER_DIED). This can happen when the owner of the
> 	    futex died.

???
So by now, I've reworked this text to be:

       FUTEX_TRYLOCK_PI (since Linux 2.6.18)
              This operation tries to acquire the futex at uaddr.  It i=
s
              invoked when a user-space atomic acquire did  not  succee=
d
              because the futex word was not 0.

              The trylock in kernel might succeed because the futex wor=
d
              contains     stale     state     (FUTEX_WAITERS     and/o=
r
              FUTEX_OWNER_DIED).   This can happen when the owner of th=
e
              futex died.  User space cannot handle this condition in  =
a
              race-free manner

Okay?

I must admit that I find "the trylock in kernel might succeed"hard
to understand. Could you elaborate a little?


>>               The uaddr2, val, timeout, and val3 arguments are ignor=
ed.
>>
>>        FUTEX_UNLOCK_PI (since Linux 2.6.18)
>>               This operation wakes the top priority waiter that is w=
ait=E2=80=90
>>               ing in FUTEX_LOCK_PI on the futex address provided by =
 the
>>               uaddr argument.
>>
>>               This  is  called when the user space value at uaddr ca=
nnot
>>               be changed atomically from a TID (of the owner) to 0.
>>
>>               The uaddr2, val, timeout, and val3 arguments are ignor=
ed.
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
> And they never will be supported because they make no sense at all. =20

Okay, thanks. I've removed that FIXME.

>>
>>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
>>
>> .\" FIXME I find the next sentence (from tglx) pretty hard to grok.
>> .\"       Could someone explain it a bit more?
>>
>>               Wait operation to wait on a  non-PI  futex  at  uaddr =
 and
>>               potentially  be  requeued  onto a PI futex at uaddr2. =
 The
>>               wait operation on uaddr is the same  as  FUTEX_WAIT.
>=20
> let me copy the pseudo code from cmp_requeue=20
>=20
>   lock(A)
>   while (!check_value(V)) {
>   	unlock(A);
> 	block_on(B);
> 	lock(A);
>   };
>   unlock(A);
>=20
> So in this case B is the non-PI futex (the wait queue) and A is a PI
> futex. So wait operation on B is the same as in FUTEX_WAIT.

Thanks. I've done a little rewording here. See below.

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
>=20
> It unblocks and returns -EWOULDBLOCK.

Thanks.

>>               The
>>               waiter   can  be  removed  from  the  wait  on  uaddr =
 via
>>               FUTEX_WAKE without requeueing on uaddr2.

???
So now I've reworded the opening text describing FUTEX_WAIT_REQUEUE_PI
as follows:

       FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
              Wait on  a  non-PI  futex  at  uaddr  and  potentially  b=
e
              requeued  (via a FUTEX_CMP_REQUEUE_PI operation in anothe=
r
              task) onto a PI futex at uaddr2.  The  wait  operation  o=
n
              uaddr is the same as for FUTEX_WAIT.

              The  waiter  can be removed from the wait on uaddr withou=
t
              requeueing on uaddr2 via a FUTEX_WAIT operation in anothe=
r
              task.   In  this case, the FUTEX_WAIT_REQUEUE_PI operatio=
n
              returns with the error EWOULDBLOCK.

Okay?


>> .\" FIXME Please check the following. tglx said "The timeout argumen=
t
>> .\"       is handled as described in FUTEX_WAIT.", but the truth is
>> .\"       as below, AFAICS
>>
>>               If timeout is not NULL, it specifies  a  timeout  for =
 the
>>               wait  operation;  this  timeout is interpreted as outl=
ined
>>               above  in  the  description  of  the  FUTEX_CLOCK_REAL=
TIME
>>               option.   If  timeout  is  NULL,  the  operation can b=
lock
>>               indefinitely.
>>
>>               The val3 argument is ignored.
>=20
> Correct

Thanks.

>> .\" FIXME Re the preceding sentence... Actually 'val3' is internally=
 set to
>> .\"       FUTEX_BITSET_MATCH_ANY before calling futex_wait_requeue_p=
i().
>> .\"       I'm not sure we need to say anything about this though.
>> .\"       Comments?
>=20
> That's a kernel internal and can be removed

Thanks.

>>
>>               The FUTEX_WAIT_REQUEUE_PI  and  FUTEX_CMP_REQUEUE_PI  =
were
>>               added  to  support a fairly specific use case: support=
 for
>>               priority-inheritance-aware POSIX threads  condition  v=
ari=E2=80=90
>>               ables.  The idea is that these operations should alway=
s be
>>               paired, in order to ensure that user space and the  ke=
rnel
>>               remain in sync.  Thus, in the FUTEX_WAIT_REQUEUE_PI op=
era=E2=80=90
>>               tion, the user-space application pre-specifies the  ta=
rget
>>               of    the    requeue    that    takes    place    in  =
 the
>>               FUTEX_CMP_REQUEUE_PI operation.
>>
>> RETURN VALUE

[...]

>> ERRORS
>>        EACCES No read access to the memory of a futex word.
>>
>>        EAGAIN (FUTEX_WAIT, FUTEX_WAIT_BITSET, FUTEX_WAIT_REQUEUE_PI)=
 The
>>               value pointed to by uaddr was not equal  to  the  expe=
cted
>>               value val at the time of the call.
>>
>>               Note:  on Linux, the symbolic names EAGAIN and EWOULDB=
LOCK
>>               (both of which appear in different  parts  of  the  ke=
rnel
>>               futex code) have the same value.
>>
>>        EAGAIN (FUTEX_CMP_REQUEUE,    FUTEX_CMP_REQUEUE_PI)   The   v=
alue
>>               pointed to by uaddr is not equal  to  the  expected  v=
alue
>>               val3.   (This  probably  indicates  a  race;  use the =
safe
>>               FUTEX_WAKE now.)
>> .\" FIXME: Is the preceding sentence "(This probably...") correct?
>> .\" [I would prefer to remove this sentence. --triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>=20
> This part should be removed:
>=20
>       "(This  probably  indicates  a  race;  use the safe FUTEX_WAKE =
now.)

Thanks. Done.

>>
>>        EAGAIN (FUTEX_LOCK_PI,  FUTEX_TRYLOCK_PI,   FUTEX_CMP_REQUEUE=
_PI)
>>               The    futex    owner    thread    ID    of   uaddr   =
(for
>>               FUTEX_CMP_REQUEUE_PI: uaddr2) is about to  exit,  but =
 has
>>               not yet handled the internal state cleanup.  Try again=
=2E
>>
>> .\" FIXME XXX Should there be an EAGAIN case for FUTEX_TRYLOCK_PI?
>> .\"       It seems so, looking at the handling of the rt_mutex_trylo=
ck()
>> .\"       call in futex_lock_pi()
>> .\"       (Davidlohr also thinks so.)
>=20
>   Yes. It's the same internal logic so it can return EAGAIN

Thanks.

>>        EDEADLK
>>               (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE=
_PI)
>>               The futex word at uaddr is already locked by the calle=
r.
>>
>>        EDEADLK
>>
>> .\" FIXME I reworded tglx's text somewhat; is the following okay?
>>
>>               (FUTEX_CMP_REQUEUE_PI) While requeueing a waiter to th=
e PI
>>               futex  for the futex word at uaddr2, the kernel detect=
ed a
>>               deadlock.
>=20
> Yes	=09

Thanks.

>>
>> .\" FIXME XXX I see that kernel/locking/rtmutex.c uses EDEADLK in so=
me
>> .\"       places, and EDEADLOCK in others. On almost all architectur=
es
>> .\"       these constants are synonymous. Is there a reason that bot=
h
>> .\"       names are used?
>=20
> No. We should probably fix that.

Okay.

[...]

>>        EINVAL (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_UNLOCK_PI) =
 The
>>               kernel detected an inconsistency  between  the  user-s=
pace
>>               state  at  uaddr  and  the  kernel  state.  This indic=
ates
>>               either state corruption or that the kernel found a  wa=
iter
>>               on    uaddr   which   is   waiting   via   FUTEX_WAIT =
  or
>>               FUTEX_WAIT_BITSET.
>=20
>> .\" FIXME Above, tglx did not mention the "state corruption" case fo=
r
>> .\"       FUTEX_UNLOCK_PI, but I have added it, since I'm estimating
>> .\"       that it also applied for FUTEX_UNLOCK_PI.
>> .\"       So, does that case also apply for FUTEX_UNLOCK_PI?
>=20
> Yes

Thanks.


>>
>>        EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  incon=
sis=E2=80=90
>>               tency  between the user-space state at uaddr2 and the =
ker=E2=80=90
>>               nel state; that is, the kernel  detected  a  waiter  w=
hich
>>               waits via FUTEX_WAIT on uaddr2.
>> .\" FIXME In the preceding sentence, tglx did not mention FUTEX_WAIT=
_BITSET,
>> .\"       but should that not also be included here?
>=20
> Yes  	   =20

Thanks. I added "[via FUTEX_WAIT] or FUTEX_WAIT_BITSET".

>>
>>        EINVAL (FUTEX_CMP_REQUEUE_PI)  The  kernel  detected an incon=
sis=E2=80=90
>>               tency between the user-space state at uaddr and the ke=
rnel
>>               state;  that  is, the kernel detected a waiter which w=
aits
>>               via FUTEX_WAIT or FUTEX_WAIT_BITESET on uaddr.
>>
>>        EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  incon=
sis=E2=80=90
>>               tency between the user-space state at uaddr and the ke=
rnel
>>               state; that is, the kernel detected a waiter  which  w=
aits
>>               on     uaddr     via     FUTEX_LOCK_PI     (instead   =
  of
>>               FUTEX_WAIT_REQUEUE_PI).
>>
>> .\" FIXME XXX The following is a reworded version of Darren Hart's t=
ext.
>> .\"       Please check that I did not introduce any errors.
>>        EINVAL (FUTEX_CMP_REQUEUE_PI) An attempt was made  to  requeu=
e  a
>>               waiter  to a futex other than that specified by the ma=
tch=E2=80=90
>>               ing FUTEX_WAIT_REQUEUE_PI call for that waiter.
>=20
> Correct. That handles the case:
>=20
> 	 wait_requeue_pi(A, B);
> 	 requeue_pi(A, C);

Thanks.

[...]

>>        ESRCH  (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE=
_PI)
>>
>> .\" FIXME I reworded the following sentence a bit differently from
>> .\"       tglx's formulation. Is it okay?
>>
>>               The thread ID in the futex word at uaddr does not exis=
t.
>=20
> Right.

Thanks.

>>        ESRCH  (FUTEX_CMP_REQUEUE_PI)=20
>>
>> .\" FIXME I reworded the following sentence a bit differently from
>> .\"       tglx's formulation. Is it okay?
>>
>>               The thread ID in the futex word  at
>>               uaddr2 does not exist.
>=20
> Right

Thanks.

Cheers,

Michael

PS: The latest version of the page can be found in its entirety at
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddraft_=
futex

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
