From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Tue, 28 Jul 2015 22:23:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1507282054370.3825@nanos>
References: <55B61EF3.7080302@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1516064912-1438115033=:3825"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B61EF3.7080302-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1516064912-1438115033=:3825
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 27 Jul 2015, Michael Kerrisk (man-pages) wrote:
>        FUTEX_CLOCK_REALTIME (since Linux 2.6.28)
>               This   option   bit   can   be   employed  only  with  the
>               FUTEX_WAIT_BITSET and FUTEX_WAIT_REQUEUE_PI operations.
> 
>               If this option is set, the kernel  treats  timeout  as  an
>               absolute time based on CLOCK_REALTIME.
> 
> .\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?
>               If  this  option  is not set, the kernel treats timeout as
>               relative time, measured against the CLOCK_MONOTONIC clock.

That's correct.

>        The operation specified in futex_op is one of the following:
> 
>        FUTEX_WAIT (since Linux 2.6.0)
>               This operation tests that the  value  at  the  futex  word
>               pointed  to  by  the  address  uaddr  still  contains  the
>               expected value  val,  and  if  so,  then  sleeps  awaiting
>               FUTEX_WAKE  on  the  futex word.  The load of the value of
>               the futex word is an atomic  memory  access  (i.e.,  using
>               atomic  machine  instructions  of the respective architec‐
>               ture).  This load, the comparison with the expected value,
>               and starting to sleep are performed atomically and totally
>               ordered with respect to other futex operations on the same
>               futex  word.  If the thread starts to sleep, it is consid‐
>               ered a waiter on this futex word.  If the futex value does
>               not  match  val,  then the call fails immediately with the
>               error EAGAIN.
> 
>               The purpose of the comparison with the expected  value  is
>               to  prevent  lost  wake-ups: If another thread changed the
>               value of the futex word after the calling  thread  decided
>               to block based on the prior value, and if the other thread
>               executed a FUTEX_WAKE operation (or similar wake-up) after
>               the  value  change  and  before this FUTEX_WAIT operation,
>               then the latter will observe the value change and will not
>               start to sleep.
> 
>               If  the timeout argument is non-NULL, its contents specify
>               a relative timeout for the wait, measured according to the
> .\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?

Yes.

>               CLOCK_MONOTONIC  clock.  (This interval will be rounded up
>               to the system clock  granularity,  and  kernel  scheduling
>               delays  mean  that  the blocking interval may overrun by a
>               small amount.)

		The given wait time will be rounded up to the system
		clock granularity and is guaranteed not to expire
		early.

There are a gazillion reasons why it can expire late, but the
guarantee is that it never expires prematurely.

>		  If timeout is NULL, the call blocks indef‐
>               initely.

Right.
 
>               The arguments uaddr2 and val3 are ignored.
> 
> 
>        FUTEX_WAKE (since Linux 2.6.0)
>               This  operation  wakes at most val of the waiters that are
>               waiting (e.g., inside FUTEX_WAIT) on the futex word at the
>               address  uaddr.  Most commonly, val is specified as either
>               1 (wake up a single waiter) or INT_MAX (wake up all  wait‐
>               ers).   No  guarantee  is provided about which waiters are
>               awoken (e.g., a waiter with a higher  scheduling  priority
>               is  not  guaranteed to be awoken in preference to a waiter
>               with a lower priority).

That's only correct up to Linux 2.6.21.

Since 2.6.22 we have a priority ordered wakeup. For SCHED_OTHER
threads this takes the nice level into account. Threads with the same
priority are woken in FIFO order.
 
>               The arguments timeout, uaddr2, and val3 are ignored.
 
> 
>        FUTEX_FD (from Linux 2.6.0 up to and including Linux 2.6.25)
>               This operation creates a file descriptor that  is  associ‐
>               ated  with  the futex at uaddr.  The caller must close the
>               returned file descriptor after use.  When another  process
>               or  thread  performs  a  FUTEX_WAKE on the futex word, the
>               file  descriptor  indicates   as   being   readable   with
>               select(2), poll(2), and epoll(7)
> 
>               The  file  descriptor  can  be used to obtain asynchronous
>               notifications:  if  val  is  nonzero,  then  when  another
>               process  or  thread executes a FUTEX_WAKE, the caller will
>               receive the signal number that was passed in val.
> 
>               The arguments timeout, uaddr2 and val3 are ignored.
> 
> .\" FIXME(Torvald) We never define "upped".  Maybe just remove the
> .\"      following sentence?
>               To prevent race conditions, the caller should test if  the
>               futex has been upped after FUTEX_FD returns.

Yes, just remove it.
 
>               Because  it was inherently racy, FUTEX_FD has been removed
>               from Linux 2.6.26 onward.
> 
>        FUTEX_REQUEUE (since Linux 2.6.0)
> .\" FIXME(Torvald) Is there some indication that FUTEX_REQUEUE is broken
> .\"     in general, or is this comment implicitly speaking about the
> .\"     condvar (?) use case? If the latter we might want to weaken the
> .\"     advice below a little.
> .\" [Anyone else have input on this?]

The condvar use case exposes the flaw nicely, but that's pretty much
true for everything which wants a sane requeue operation.

>               Avoid using this operation.  It is broken for its intended
>               purpose.  Use FUTEX_CMP_REQUEUE instead.
> 
>               This    operation    performs    the    same    task    as
>               FUTEX_CMP_REQUEUE, except that no check is made using  the
>               value in val3.  (The argument val3 is ignored.)
> 
>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
>               This  operation  first  checks  whether the location uaddr
>               still contains the value  val3.   If  not,  the  operation
>               fails  with  the  error  EAGAIN.  Otherwise, the operation
>               wakes up a maximum of val waiters that are waiting on  the
>               futex  at uaddr.  If there are more than val waiters, then
>               the remaining waiters are removed from the wait  queue  of
>               the  source  futex at uaddr and added to the wait queue of
>               the target futex at uaddr2.  The val2  argument  specifies
>               an  upper limit on the number of waiters that are requeued
>               to the futex at uaddr2.
> 
> .\" FIXME(Torvald) Is the following correct?  Or is just the decision
> .\" which threads to wake or requeue part of the atomic operation?
> 
>               The load from uaddr is  an  atomic  memory  access  (i.e.,
>               using atomic machine instructions of the respective archi‐
>               tecture).  This load, the comparison with  val3,  and  the
>               requeueing  of  any  waiters  are performed atomically and
>               totally ordered with respect to other  operations  on  the
>               same futex word.

It's atomic as the other atomic operations on the futex word. It's
always performed with the proper lock(s) held in the kernel. That
means any concurrent operation will serialize on that lock(s). User
space has to make sure, that depending on the observed value no
concurrent operations happen, but that's something the kernel cannot
control.
 
>               This  operation was added as a replacement for the earlier
>               FUTEX_REQUEUE.  The difference is that the  check  of  the
>               value  at uaddr can be used to ensure that requeueing hap‐
>               pens only under certain conditions.  Both  operations  can
>               be   used   to  avoid  a  "thundering  herd"  effect  when
>               FUTEX_WAKE is used and all of the waiters that  are  woken
>               need to acquire another futex.
> 
> .\" FIXME Please review the following new paragraph to see if it is
> .\"       accurate.
>               Typical  values to specify for val are 0 or or 1.  (Speci‐
>               fying INT_MAX is not useful, because  it  would  make  the
>               FUTEX_CMP_REQUEUE  operation  equivalent  to  FUTEX_WAKE.)
>               The limit value specified via val2 is typically  either  1
>               or  INT_MAX.  (Specifying the argument as 0 is not useful,
>               because it  would  make  the  FUTEX_CMP_REQUEUE  operation
>               equivalent to FUTEX_WAIT.)

It's correct.

> .\" FIXME Here, it would be helpful to have an example of how
> .\"       FUTEX_CMP_REQUEUE might be used, at the same time illustrating
> .\"       why FUTEX_WAKE is unsuitable for the same use case.

Waiters:

  lock(A)
  while (!check_value(V)) {
  	unlock(A);
	block_on(B);
	lock(A);
  };
  unlock(A);

Note: B is a wait queue implemented with futexes.
 
If the waker would use FUTEX_WAKE and wake all waiters waiting on B
then those would all try to acquire lock A. That's called thundering
herd and pointless because all except one would immediately block on
lock A again.

Requeueing prevents that because it only wakes one waiter and moves
the other waiters to lock A. When that waiter unlocks A then the next
waiter can proceed ...

>        FUTEX_WAKE_OP (since Linux 2.6.14)
> .\" FIXME I added a lengthy piece of text on FUTEX_WAKE_OP text,
> .\"       and I'd be happy if someone checked it.
> .\"
> .\" FIXME(Torvald) The glibc condvar implementation is currently being
> .\"     revised (e.g., to not use an internal lock anymore).
> .\"     It is probably more future-proof to remove this paragraph.
> .\" [Torvald, do you have an update here?]
> .\"
>               This  operation  was  added to support some user-space use
>               cases where more than one futex must  be  handled  at  the
>               same time.  The most notable example is the implementation
>               of pthread_cond_signal(3), which  requires  operations  on
>               two  futexes,  the one used to implement the mutex and the
>               one used in the implementation of the wait  queue  associ‐
>               ated  with  the  condition variable.  FUTEX_WAKE_OP allows
>               such cases to be implemented without leading to high rates
>               of contention and context switching.
> 
>               The FUTEX_WAIT_OP operation is equivalent to executing the
>               following code atomically and totally ordered with respect
>               to other futex operations on any of the two supplied futex
>               words:
> 
>                   int oldval = *(int *) uaddr2;
>                   *(int *) uaddr2 = oldval op oparg;
>                   futex(uaddr, FUTEX_WAKE, val, 0, 0, 0);
>                   if (oldval cmp cmparg)
>                       futex(uaddr2, FUTEX_WAKE, val2, 0, 0, 0);
> 
>               In other words, FUTEX_WAIT_OP does the following:
> 
>               *  saves the original value of the futex  word  at  uaddr2
>                  and  performs  an  operation to modify the value of the
>                  futex at uaddr2; this is  an  atomic  read-modify-write
>                  memory  access (i.e., using atomic machine instructions
>                  of the respective architecture)
> 
>               *  wakes up a maximum of val waiters on the futex for  the
>                  futex word at uaddr; and
> 
>               *  dependent  on  the  results  of  a test of the original
>                  value of the futex word at uaddr2, wakes up  a  maximum
>                  of  val2  waiters  on  the  futex for the futex word at
>                  uaddr2.
> 
>               The operation and comparison that are to be performed  are
>               encoded  in  the  bits of the argument val3.  Pictorially,
>               the encoding is:
> 
>                       +---+---+-----------+-----------+
>                       |op |cmp|   oparg   |  cmparg   |
>                       +---+---+-----------+-----------+
>                         4   4       12          12    <== # of bits
> 
>               Expressed in code, the encoding is:
> 
>                   #define FUTEX_OP(op, oparg, cmp, cmparg) \
>                                   (((op & 0xf) << 28) | \
>                                   ((cmp & 0xf) << 24) | \
>                                   ((oparg & 0xfff) << 12) | \
>                                   (cmparg & 0xfff))
> 
>               In the above, op and cmp are each one of the codes  listed
>               below.   The  oparg  and  cmparg  components  are  literal
>               numeric values, except as noted below.
> 
>               The op component has one of the following values:
> 
>                   FUTEX_OP_SET        0  /* uaddr2 = oparg; */
>                   FUTEX_OP_ADD        1  /* uaddr2 += oparg; */
>                   FUTEX_OP_OR         2  /* uaddr2 |= oparg; */
>                   FUTEX_OP_ANDN       3  /* uaddr2 &= ~oparg; */
>                   FUTEX_OP_XOR        4  /* uaddr2 ^= oparg; */
> 
>               In addition, bit-wise ORing the following  value  into  op
>               causes (1 << oparg) to be used as the operand:
> 
>                   FUTEX_OP_ARG_SHIFT  8  /* Use (1 << oparg) as operand */
> 
>               The cmp field is one of the following:
> 
>                   FUTEX_OP_CMP_EQ     0  /* if (oldval == cmparg) wake */
>                   FUTEX_OP_CMP_NE     1  /* if (oldval != cmparg) wake */
>                   FUTEX_OP_CMP_LT     2  /* if (oldval < cmparg) wake */
>                   FUTEX_OP_CMP_LE     3  /* if (oldval <= cmparg) wake */
>                   FUTEX_OP_CMP_GT     4  /* if (oldval > cmparg) wake */
>                   FUTEX_OP_CMP_GE     5  /* if (oldval >= cmparg) wake */
> 
>               The return value of FUTEX_WAKE_OP is the sum of the number
>               of waiters woken on the futex uaddr  plus  the  number  of
>               waiters woken on the futex uaddr2.
> 
>        FUTEX_WAIT_BITSET (since Linux 2.6.25)
>               This operation is like FUTEX_WAIT except that val3 is used
>               to provide a 32-bit bitset to the kernel.  This bitset  is
>               stored  in  the  kernel-internal state of the waiter.  See
>               the description of FUTEX_WAKE_BITSET for further details.
> 
>               The FUTEX_WAIT_BITSET operation also interprets the  time‐
>               out argument differently from FUTEX_WAIT.  See the discus‐
>               sion of FUTEX_CLOCK_REALTIME, above.
> 
>               The uaddr2 argument is ignored.
> 
>        FUTEX_WAKE_BITSET (since Linux 2.6.25)
>               This operation is the same as FUTEX_WAKE except  that  the
>               val3  argument  is  used to provide a 32-bit bitset to the
>               kernel.  This bitset  is  used  to  select  which  waiters
>               should  be  woken up.  The selection is done by a bit-wise
>               AND of the "wake" bitset (i.e., the value in val3) and the
>               bitset which is stored in the kernel-internal state of the
>               waiter   (the   "wait"   bitset   that   is   set    using
>               FUTEX_WAIT_BITSET).   All  of  the  waiters  for which the
>               result of the AND is nonzero are woken up;  the  remaining
>               waiters are left sleeping.
> 
> .\" FIXME XXX Is this next paragraph that I added okay?
>               The  effect  of FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSET is
>               to allow selective wake-ups among  multiple  waiters  that
>               are  blocked on the same futex.  Note, however, that using
>               this bitset multiplexing feature on a futex is less  effi‐
>               cient  than simply using multiple futexes, because employ‐

		s/is less efficient/can be less efficient/

It really depends on the usecase.

>               ing bitset multiplexing requires the kernel to  check  all
>               waiters  on  a  futex, including those that are not inter‐
>               ested in being woken up (i.e., they do not have the  rele‐
>               vant bit set in their "wait" bitset).
> 
>               The uaddr2 and timeout arguments are ignored.
> 
>               The  FUTEX_WAIT  and  FUTEX_WAKE  operations correspond to
>               FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSET  operations  where
>               the bitsets are all ones.
> 
>    Priority-inheritance futexes
>        Linux supports priority-inheritance (PI) futexes in order to han‐
>        dle priority-inversion problems that can be encountered with nor‐
>        mal  futex  locks.  Priority inversion is the problem that occurs
>        when a high-priority task is blocked waiting to  acquire  a  lock
>        held  by a low-priority task, while tasks at an intermediate pri‐
>        ority continuously preempt the low-priority task  from  the  CPU.
>        Consequently,  the  low-priority  task  makes  no progress toward
>        releasing the lock, and the high-priority task remains blocked.
> 
>        Priority inheritance is a mechanism for dealing with  the  prior‐
>        ity-inversion problem.  With this mechanism, when a high-priority
>        task becomes blocked by a lock held by a low-priority  task,  the
>        latter's priority is temporarily raised to that of the former, so
>        that it is not preempted by any intermediate level tasks, and can
>        thus  make  progress toward releasing the lock.  To be effective,
>        priority inheritance must be transitive, meaning that if a  high-
>        priority task blocks on a lock held by a lower-priority task that
>        is itself blocked by lock held by  another  intermediate-priority
>        task  (and  so  on, for chains of arbitrary length), then both of
>        those task (or more generally, all of the tasks in a lock  chain)
>        have  their priorities raised to be the same as the high-priority
>        task.
> 
> .\" FIXME XXX The following is my attempt at a definition of PI futexes,
> .\"       based on mail discussions with Darren Hart. Does it seem okay?
> 
>        From a user-space perspective, what makes a futex PI-aware  is  a
>        policy  agreement  between  user  space  and the kernel about the
>        value of the futex word (described in a moment), coupled with the
>        use  of  the  PI futex operations described below (in particular,
>        FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and FUTEX_CMP_REQUEUE_PI).
> 
> .\" FIXME XXX ===== Start of adapted Hart/Guniguntala text =====
> .\"       The following text is drawn from the Hart/Guniguntala paper
> .\"       (listed in SEE ALSO), but I have reworded some pieces
> .\"       significantly. Please check it.
> 
>        The PI futex operations described below  differ  from  the  other
>        futex  operations  in  that  they impose policy on the use of the
>        value of the futex word:
> 
>        *  If the lock is not acquired, the futex word's value  shall  be
>           0.
> 
>        *  If  the  lock is acquired, the futex word's value shall be the
>           thread ID (TID; see gettid(2)) of the owning thread.
> 
>        *  If the lock is owned and there are threads contending for  the
>           lock,  then  the  FUTEX_WAITERS  bit shall be set in the futex
>           word's value; in other words, this value is:
> 
>               FUTEX_WAITERS | TID
> 
> 
>        Note that a PI futex word never just has the value FUTEX_WAITERS,
>        which is a permissible state for non-PI futexes.
> 
>        With this policy in place, a user-space application can acquire a
>        not-acquired lock or release a lock that no other threads try  to
>        acquire using atomic instructions executed in user space (e.g., a
>        compare-and-swap operation such as cmpxchg on the  x86  architec‐
>        ture).   Acquiring  a  lock simply consists of using compare-and-
>        swap to atomically set the futex word's value to the caller's TID
>        if  its  previous  value  was 0.  Releasing a lock requires using
>        compare-and-swap to set the futex word's value to 0 if the previ‐
>        ous value was the expected TID.
> 
>        If a futex is already acquired (i.e., has a nonzero value), wait‐
>        ers must employ the FUTEX_LOCK_PI operation to acquire the  lock.
>        If other threads are waiting for the lock, then the FUTEX_WAITERS
>        bit is set in the futex value; in this case, the lock owner  must
>        employ the FUTEX_UNLOCK_PI operation to release the lock.
> 
>        In  the  cases  where  callers  are forced into the kernel (i.e.,
>        required to perform a futex() call), they then deal directly with
>        a so-called RT-mutex, a kernel locking mechanism which implements
>        the required priority-inheritance semantics.  After the  RT-mutex
>        is  acquired,  the futex value is updated accordingly, before the
>        calling thread returns to user space.
> .\" FIXME ===== End of adapted Hart/Guniguntala text =====

That's correct.

> .\" FIXME We need some explanation in the following paragraph of *why*
> .\"       it is important to note that "the kernel will update the
> .\"       futex word's value prior
>        It is important to note to returning to user space" . Can someone
>        explain?   that  the  kernel  will  update the futex word's value
>        prior to returning to user space.  Unlike the other futex  opera‐
>        tions  described  above, the PI futex operations are designed for
>        the implementation of very specific IPC mechanisms.

If there are multiple waiters on a pi futex then a wake pi operation
will wake the first waiter and hand over the lock to this waiter. This
includes handing over the rtmutex which represents the futex in the
kernel. The strict requirement is that the futex owner and the rtmutex
owner must be the same, except for the update period which is
serialized by the futex internal locking. That means the kernel must
update the user space value prior to returning to user space.

> .\"
> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren Hart
> .\"       made the observation that "EINVAL is returned if the non-pi 
> .\"       to pi or op pairing semantics are violated."
> .\"       Probably there needs to be a general statement about this
> .\"       requirement, probably located at about this point in the page.
> .\"       Darren (or someone else), care to take a shot at this?

Well, that's hard to describe because the kernel only has a limited
way of detecting such mismatches. It only can detect it when there are
non PI waiters on a futex and a PI function is called or vice versa.

> .\" FIXME Somewhere on this page (I guess under the discussion of PI
> .\"       futexes) we need a discussion of the FUTEX_OWNER_DIED bit.
> .\"       Can someone propose a text?

If a futex has a rtmutex associated in the kernel, i.e. when there are
blocked waiters, and the owner of the futex/rtmutex dies unexpectedly,
then the kernel cleans up the rtmutex (as it holds a reference to the
dying task) and hands it over to the next waiter. That requires that
the user space value is updated accordingly. The kernel sets the
FUTEX_OWNER_DIED in the user space value along with the TID of the new
owner. User space is responsible for cleaning this up, though there
are cases where the kernel does the cleanup.
 
The FUTEX_OWNER_DIED bit can also be set on uncontended futexes, where
the kernel has no state associated. This happens via the robust futex
mechanism. In that case the futex value will be set to
FUTEX_OWNER_DIED. The robust futex mechanism is also available for non
PI futexes.
 
>        PI futexes are operated on by specifying  one  of  the  following
>        values in futex_op:
> 
>        FUTEX_LOCK_PI (since Linux 2.6.18)
> .\" FIXME I did some significant rewording of tglx's text to create
> .\"       the text below.
> .\"       Please check the following paragraph, in case I injected
> .\"       errors.
>               This  operation  is used after after an attempt to acquire
>               the lock  via  an  atomic  user-space  instruction  failed
>               because  the  futex word has a nonzero value—specifically,
>               because it contained the  namespace-specific  TID  of  the
>               lock owner.
> .\" FIXME In the preceding line, what does "namespace-specific" mean?
> .\"       (I kept those words from tglx.)
> .\"       That is, what kind of namespace are we talking about?
> .\"       (I suppose we are talking PID namespaces here, but I want to
> .\"       be sure.)

Yes.
 
>               The  operation  checks  the value of the futex word at the
>               address uaddr.  If the value is 0, then the  kernel  tries
>               to atomically set the futex value to the caller's TID.  
> .\" FIXME What would be the cause(s) of failure referred to
> .\"       in the following sentence?
>               If
>               that fails, or the futex word's value is nonzero, the ker‐

'If that fails' does not make sense. If the user space access fails we
return -EFAULT and let user space deal with the mess.

The operation here is similar to the FUTEX_WAIT logic. When the user
space atomic acquire does not succeed because the futex value was non
zero, then the waiter goes into the kernel, takes the kernel internal
lock and retries the acquisition under the lock. If the acquisition
does not succeed either, then it sets the FUTEX_WAITERS bit, to signal
the lock owner that it needs to go into the kernel. Here is the pseudo
code:

		lock(kernel_lock);
	retry:
		
		/*
		 * Owner might have unlocked in userspace before we
		 * were able to set the waiter bit.
		 */
		if (atomic_acquire(futex) == SUCCESS) {
		   unlock(kernel_lock());
		   return 0;
		}

		/*
		 * Owner might have unlocked after the above atomic_acquire()
		 * attempt.
		 */
		if (atomic_set_waiters_bit(futex) != SUCCESS)
		   goto retry;

		queue_waiter();
		unlock(kernel_lock);
		block();   

>               nel  atomically  sets the FUTEX_WAITERS bit, which signals
>               the futex owner that it cannot unlock the  futex  in  user
>               space  atomically  by setting the futex value to 0.  After
>               that, the kernel tries to find the thread which is associ‐
>               ated with the owner TID, creates or reuses kernel state on
>               behalf of the owner and attaches the waiter  to  it.   
> .\" FIXME Could I get a bit more detail on the previous lines?
> .\"       What is "creates or reuses kernel state" about?
> .\"       (I think this needs to be clearer in the page)

If this is the first waiter then there is no kernel state for this
futex, so it is created. That means the rtmutex is locked and the
futex owner established as the owner of the rtmutex. If there is a
waiter, then the state is reused, i.e. the new waiter is enqueued into
the rtmutex waiter list.
 
> .\" FIXME In the next line, what type of "priority" are we talking about?
> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
> .\"       Or something else?
> 
>               The
>               enqueueing  of  the waiter is in descending priority order
>               if more than one waiter exists.  

That also covers sched deadline.

> .\" FIXME In the next sentence, what type of "priority" are we talking about?
> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
> .\"       Or something else?
> .\" FIXME What does "bandwidth" refer to in the next sentence?
> 
>               The owner inherits either
>               the priority or the bandwidth of the waiter.  

If the highest priority waiter is SCHED_DEADLINE, then the owner
inherits cpu bandwidth from the waiter as there is no priority
associated to SCHED_DEADLINE tasks.

If the highest priority waiter is SCHED_FIFO/RR, then the owner
inherits the waiter priority.


> .\" FIXME In the preceding sentence, what determines whether the
> .\"       owner inherits the priority versus the bandwidth?
> 
> .\" FIXME Could I get some help translating the next sentence into
> .\"       something that user-space developers (and I) can understand?
> .\"       In particular, what are "nested locks" in this context?
> 
>               This inheri‐
>               tance follows the lock chain in the case of nested locking
>               and performs deadlock detection.

T1 blocks on lock A held by T2
T2 blocks on lock B held by T3

So we have a lock chain A, B. The inheritance mechanism follows the
lock chain and propagates the highest waiter priority up to the end of
the chain.
 
> .\" FIXME tglx said "The timeout argument is handled as described in
> .\"       FUTEX_WAIT." However, it appears to me that this is not right.
> .\"       Is the following formulation correct?
>               The  timeout  argument  provides  a  timeout  for the lock
>               attempt.  It is interpreted as an absolute time,  measured
>               against the CLOCK_REALTIME clock.  If timeout is NULL, the
>               operation will block indefinitely.

Indeed.
 
>               The uaddr2, val, and val3 arguments are ignored.
> 
>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
> .\" FIXME I think it would be helpful here to say a few more words about
> .\"       the difference(s) between FUTEX_LOCK_PI and FUTEX_TRYLOCK_PI.
> .\"       Can someone propose something?
>               This operation tries to acquire the futex  at  uaddr.   It
>               deals  with  the situation where the TID value at uaddr is
>               0, but the FUTEX_WAITERS bit is set.   User  space  cannot
>               handle this condition in a race-free manner
> .\" FIXME How does the situation in the previous sentence come about?
> .\"       Probably it would be helpful to say something about that in
> .\"       the man page.
> .\" FIXME And *how* does FUTEX_TRYLOCK_PI deal with this situation?

That should be expressed differently:

     	    This operation tries to acquire the futex at uaddr. It's
     	    invoked when the user space atomic acquire did not
     	    succeed because the user space value was not 0.

	    The trylock in kernel might succeed because the user space
	    value contains stale state (FUTEX_WAITERS and or
	    FUTEX_OWNER_DIED). This can happen when the owner of the
	    futex died.

>               The uaddr2, val, timeout, and val3 arguments are ignored.
> 
>        FUTEX_UNLOCK_PI (since Linux 2.6.18)
>               This operation wakes the top priority waiter that is wait‐
>               ing in FUTEX_LOCK_PI on the futex address provided by  the
>               uaddr argument.
> 
>               This  is  called when the user space value at uaddr cannot
>               be changed atomically from a TID (of the owner) to 0.
> 
>               The uaddr2, val, timeout, and val3 arguments are ignored.
> 
>        FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
>               This operation is a PI-aware variant of FUTEX_CMP_REQUEUE.
>               It    requeues    waiters    that    are    blocked    via
>               FUTEX_WAIT_REQUEUE_PI on uaddr from a non-PI source  futex
>               (uaddr) to a PI target futex (uaddr2).
> 
>               As with FUTEX_CMP_REQUEUE, this operation wakes up a maxi‐
>               mum of val waiters that are waiting on the futex at uaddr.
>               However, for FUTEX_CMP_REQUEUE_PI, val is required to be 1
>               (since the main point is to avoid a thundering herd).  The
>               remaining  waiters  are removed from the wait queue of the
>               source futex at uaddr and added to the wait queue  of  the
>               target futex at uaddr2.
> 
>               The val2 and val3 arguments serve the same purposes as for
>               FUTEX_CMP_REQUEUE.
> .\" FIXME The page at http://locklessinc.com/articles/futex_cheat_sheet/
> .\"       notes that "priority-inheritance Futex to priority-inheritance
> .\"       Futex requeues are currently unsupported". Do we need to say
> .\"       something in the man page about that?
> 

And they never will be supported because they make no sense at all.  

> 
>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
> 
> .\" FIXME I find the next sentence (from tglx) pretty hard to grok.
> .\"       Could someone explain it a bit more?
> 
>               Wait operation to wait on a  non-PI  futex  at  uaddr  and
>               potentially  be  requeued  onto a PI futex at uaddr2.  The
>               wait operation on uaddr is the same  as  FUTEX_WAIT.

let me copy the pseudo code from cmp_requeue 

  lock(A)
  while (!check_value(V)) {
  	unlock(A);
	block_on(B);
	lock(A);
  };
  unlock(A);

So in this case B is the non-PI futex (the wait queue) and A is a PI
futex. So wait operation on B is the same as in FUTEX_WAIT.
   
> 
> .\" FIXME I'm not quite clear on the meaning of the following sentence.
> .\"       Is this trying to say that while blocked in a
> .\"       FUTEX_WAIT_REQUEUE_PI, it could happen that another
> .\"       task does a FUTEX_WAKE on uaddr that simply causes
> .\"       a normal wake, with the result that the FUTEX_WAIT_REQUEUE_PI
> .\"       does not complete? What happens then to the FUTEX_WAIT_REQUEUE_PI
> .\"       opertion? Does it remain blocked, or does it unblock
> .\"       In which case, what does user space see?

It unblocks and returns -EWOULDBLOCK.
 
>               The
>               waiter   can  be  removed  from  the  wait  on  uaddr  via
>               FUTEX_WAKE without requeueing on uaddr2.
 
> .\" FIXME Please check the following. tglx said "The timeout argument
> .\"       is handled as described in FUTEX_WAIT.", but the truth is
> .\"       as below, AFAICS
> 
>               If timeout is not NULL, it specifies  a  timeout  for  the
>               wait  operation;  this  timeout is interpreted as outlined
>               above  in  the  description  of  the  FUTEX_CLOCK_REALTIME
>               option.   If  timeout  is  NULL,  the  operation can block
>               indefinitely.
> 
>               The val3 argument is ignored.

Correct
 
> .\" FIXME Re the preceding sentence... Actually 'val3' is internally set to
> .\"       FUTEX_BITSET_MATCH_ANY before calling futex_wait_requeue_pi().
> .\"       I'm not sure we need to say anything about this though.
> .\"       Comments?

That's a kernel internal and can be removed
 
> 
>               The FUTEX_WAIT_REQUEUE_PI  and  FUTEX_CMP_REQUEUE_PI  were
>               added  to  support a fairly specific use case: support for
>               priority-inheritance-aware POSIX threads  condition  vari‐
>               ables.  The idea is that these operations should always be
>               paired, in order to ensure that user space and the  kernel
>               remain in sync.  Thus, in the FUTEX_WAIT_REQUEUE_PI opera‐
>               tion, the user-space application pre-specifies the  target
>               of    the    requeue    that    takes    place    in   the
>               FUTEX_CMP_REQUEUE_PI operation.
> 
> RETURN VALUE
>        In the event of an error (and assuming that futex()  was  invoked
>        via  syscall(2)), all operations return -1 and set errno to indi‐
>        cate the cause of the error.  The return value on success depends
>        on the operation, as described in the following list:
> 
>        FUTEX_WAIT
>               Returns 0 if the caller was woken up.  Note that a wake-up
>               can also be caused by common futex usage patterns in unre‐
>               lated code that happened to have previously used the futex
>               word's memory location (e.g., typical  futex-based  imple‐
>               mentations  of  Pthreads mutexes can cause this under some
>               conditions).  Therefore, callers should  always  conserva‐
>               tively assume that a return value of 0 can mean a spurious
>               wake-up, and use the futex word's value  (i.e.,  the  user
>               space synchronization scheme)
>                   to decide whether to continue to block or not.
> 
>        FUTEX_WAKE
>               Returns the number of waiters that were woken up.
> 
>        FUTEX_FD
>               Returns the new file descriptor associated with the futex.
> 
>        FUTEX_REQUEUE
>               Returns the number of waiters that were woken up.
> 
>        FUTEX_CMP_REQUEUE
>               Returns  the total number of waiters that were woken up or
>               requeued to the futex for the futex word  at  uaddr2.   If
>               this  value  is  greater  than val, then difference is the
>               number of waiters requeued to the futex for the futex word
>               at uaddr2.
> 
>        FUTEX_WAKE_OP
>               Returns  the  total  number of waiters that were woken up.
>               This is the sum of the woken waiters on  the  two  futexes
>               for the futex words at uaddr and uaddr2.
> 
>        FUTEX_WAIT_BITSET
>               Returns  0 if the caller was woken up.  See FUTEX_WAIT for
>               how to interpret this correctly in practice.
> 
>        FUTEX_WAKE_BITSET
>               Returns the number of waiters that were woken up.
> 
>        FUTEX_LOCK_PI
>               Returns 0 if the futex was successfully locked.
> 
>        FUTEX_TRYLOCK_PI
>               Returns 0 if the futex was successfully locked.
> 
>        FUTEX_UNLOCK_PI
>               Returns 0 if the futex was successfully unlocked.
> 
>        FUTEX_CMP_REQUEUE_PI
>               Returns the total number of waiters that were woken up  or
>               requeued  to  the  futex for the futex word at uaddr2.  If
>               this value is greater than val,  then  difference  is  the
>               number of waiters requeued to the futex for the futex word
>               at uaddr2.
> 
>        FUTEX_WAIT_REQUEUE_PI
>               Returns 0 if the caller was successfully requeued  to  the
>               futex for the futex word at uaddr2.
> 
> ERRORS
>        EACCES No read access to the memory of a futex word.
> 
>        EAGAIN (FUTEX_WAIT, FUTEX_WAIT_BITSET, FUTEX_WAIT_REQUEUE_PI) The
>               value pointed to by uaddr was not equal  to  the  expected
>               value val at the time of the call.
> 
>               Note:  on Linux, the symbolic names EAGAIN and EWOULDBLOCK
>               (both of which appear in different  parts  of  the  kernel
>               futex code) have the same value.
> 
>        EAGAIN (FUTEX_CMP_REQUEUE,    FUTEX_CMP_REQUEUE_PI)   The   value
>               pointed to by uaddr is not equal  to  the  expected  value
>               val3.   (This  probably  indicates  a  race;  use the safe
>               FUTEX_WAKE now.)
> .\" FIXME: Is the preceding sentence "(This probably...") correct?
> .\" [I would prefer to remove this sentence. --triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]

This part should be removed:

      "(This  probably  indicates  a  race;  use the safe FUTEX_WAKE now.)
 
> 
>        EAGAIN (FUTEX_LOCK_PI,  FUTEX_TRYLOCK_PI,   FUTEX_CMP_REQUEUE_PI)
>               The    futex    owner    thread    ID    of   uaddr   (for
>               FUTEX_CMP_REQUEUE_PI: uaddr2) is about to  exit,  but  has
>               not yet handled the internal state cleanup.  Try again.
> 
> .\" FIXME XXX Should there be an EAGAIN case for FUTEX_TRYLOCK_PI?
> .\"       It seems so, looking at the handling of the rt_mutex_trylock()
> .\"       call in futex_lock_pi()
> .\"       (Davidlohr also thinks so.)

  Yes. It's the same internal logic so it can return EAGAIN
 
> 
>        EDEADLK
>               (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI)
>               The futex word at uaddr is already locked by the caller.
> 
>        EDEADLK
> 
> .\" FIXME I reworded tglx's text somewhat; is the following okay?
> 
>               (FUTEX_CMP_REQUEUE_PI) While requeueing a waiter to the PI
>               futex  for the futex word at uaddr2, the kernel detected a
>               deadlock.

Yes		

> 
> .\" FIXME XXX I see that kernel/locking/rtmutex.c uses EDEADLK in some
> .\"       places, and EDEADLOCK in others. On almost all architectures
> .\"       these constants are synonymous. Is there a reason that both
> .\"       names are used?

No. We should probably fix that.
 
>        EFAULT A required pointer argument (i.e., uaddr, uaddr2, or time‐
>               out) did not point to a valid user-space address.
> 
>        EINTR  A  FUTEX_WAIT  or  FUTEX_WAIT_BITSET  operation was inter‐
>               rupted by a signal (see  signal(7)).   In  kernels  before
>               Linux  2.6.22,  this error could also be returned for on a
>               spurious wakeup; since Linux 2.6.22, this no  longer  hap‐
>               pens.
> 
>        EINVAL The  operation  in futex_op is one of those that employs a
>               timeout, but the supplied  timeout  argument  was  invalid
>               (tv_sec  was  less than zero, or tv_nsec was not less than
>               1,000,000,000).
> 
>        EINVAL The operation specified in futex_op employs one or both of
>               the  pointers  uaddr and uaddr2, but one of these does not
>               point to a valid object—that is, the address is not  four-
>               byte-aligned.
> 
>        EINVAL (FUTEX_WAIT_BITSET, FUTEX_WAKE_BITSET) The bitset supplied
>               in val3 is zero.
> 
>        EINVAL (FUTEX_CMP_REQUEUE_PI)  uaddr  equals  uaddr2  (i.e.,   an
>               attempt was made to requeue to the same futex).
> 
>        EINVAL (FUTEX_FD) The signal number supplied in val is invalid.
> 
>        EINVAL (FUTEX_WAKE,       FUTEX_WAKE_OP,       FUTEX_WAKE_BITSET,
>               FUTEX_REQUEUE, FUTEX_CMP_REQUEUE) The kernel  detected  an
>               inconsistency  between  the  user-space state at uaddr and
>               the kernel state—that is, it detected a waiter which waits
>               in FUTEX_LOCK_PI on uaddr.
> 
>        EINVAL (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_UNLOCK_PI)  The
>               kernel detected an inconsistency  between  the  user-space
>               state  at  uaddr  and  the  kernel  state.  This indicates
>               either state corruption or that the kernel found a  waiter
>               on    uaddr   which   is   waiting   via   FUTEX_WAIT   or
>               FUTEX_WAIT_BITSET.

> .\" FIXME Above, tglx did not mention the "state corruption" case for
> .\"       FUTEX_UNLOCK_PI, but I have added it, since I'm estimating
> .\"       that it also applied for FUTEX_UNLOCK_PI.
> .\"       So, does that case also apply for FUTEX_UNLOCK_PI?

Yes
 
> 
>        EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  inconsis‐
>               tency  between the user-space state at uaddr2 and the ker‐
>               nel state; that is, the kernel  detected  a  waiter  which
>               waits via FUTEX_WAIT on uaddr2.
> .\" FIXME In the preceding sentence, tglx did not mention FUTEX_WAIT_BITSET,
> .\"       but should that not also be included here?

Yes  	    
 
> 
>        EINVAL (FUTEX_CMP_REQUEUE_PI)  The  kernel  detected an inconsis‐
>               tency between the user-space state at uaddr and the kernel
>               state;  that  is, the kernel detected a waiter which waits
>               via FUTEX_WAIT or FUTEX_WAIT_BITESET on uaddr.
> 
>        EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  inconsis‐
>               tency between the user-space state at uaddr and the kernel
>               state; that is, the kernel detected a waiter  which  waits
>               on     uaddr     via     FUTEX_LOCK_PI     (instead     of
>               FUTEX_WAIT_REQUEUE_PI).
> 
> .\" FIXME XXX The following is a reworded version of Darren Hart's text.
> .\"       Please check that I did not introduce any errors.
>        EINVAL (FUTEX_CMP_REQUEUE_PI) An attempt was made  to  requeue  a
>               waiter  to a futex other than that specified by the match‐
>               ing FUTEX_WAIT_REQUEUE_PI call for that waiter.

Correct. That handles the case:

	 wait_requeue_pi(A, B);
	 requeue_pi(A, C);
 
>        EINVAL (FUTEX_CMP_REQUEUE_PI) The val argument is not 1.
> 
>        EINVAL Invalid argument.
> 
>        ENOMEM (FUTEX_LOCK_PI,  FUTEX_TRYLOCK_PI,   FUTEX_CMP_REQUEUE_PI)
>               The  kernel could not allocate memory to hold state infor‐
>               mation.
> 
>        ENFILE (FUTEX_FD) The system limit on the total  number  of  open
>               files has been reached.
> 
>        ENOSYS Invalid operation specified in futex_op.
> 
>        ENOSYS The FUTEX_CLOCK_REALTIME option was specified in futex_op,
>               but the accompanying operation was neither FUTEX_WAIT_BIT‐
>               SET nor FUTEX_WAIT_REQUEUE_PI.
> 
>        ENOSYS (FUTEX_LOCK_PI,     FUTEX_TRYLOCK_PI,     FUTEX_UNLOCK_PI,
>               FUTEX_CMP_REQUEUE_PI,  FUTEX_WAIT_REQUEUE_PI)  A  run-time
>               check determined that the operation is not available.  The
>               PI futex operations are not implemented on  all  architec‐
>               tures and are not supported on some CPU variants.
> 
>        EPERM  (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI)
>               The caller is not allowed to attach itself to the futex at
>               uaddr  (for  FUTEX_CMP_REQUEUE_PI:  the  futex at uaddr2).
>               (This may be caused by a state corruption in user space.)
> 
>        EPERM  (FUTEX_UNLOCK_PI) The caller does not own the lock  repre‐
>               sented by the futex word.
> 
>        ESRCH  (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI)
> 
> .\" FIXME I reworded the following sentence a bit differently from
> .\"       tglx's formulation. Is it okay?
> 
>               The thread ID in the futex word at uaddr does not exist.

Right.
 
>        ESRCH  (FUTEX_CMP_REQUEUE_PI) 
> 
> .\" FIXME I reworded the following sentence a bit differently from
> .\"       tglx's formulation. Is it okay?
> 
>               The thread ID in the futex word  at
>               uaddr2 does not exist.

Right
 
Thanks,

	tglx
--8323329-1516064912-1438115033=:3825--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
