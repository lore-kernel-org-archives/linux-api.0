From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Next round: revised futex(2) man page for review
Date: Mon, 27 Jul 2015 14:07:15 +0200
Message-ID: <55B61EF3.7080302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello all,

=46rom a draft sent out in March, I got a few useful comments that
I've now incorporated into this draft. And I got some complaints
from people who did not want to read groff source. My point
was that there are a bunch of FIXMEs in the page source that I
wanted people to look at... Anyway, this time, I will take
a different tack, interspersing the FIXMEs in a rendered=20
version of the page. I'd greatly appreciate help with those FIXMEs.

The current page source can be found at in a branch at
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddraft_=
futex

=3D=3D=3D

As becomes quickly obvious upon reading it, the current futex(2)=20
man page is in a sorry state, lacking many important details, and
also the various additions that have been made to the interface
over the last years. I've been working on revising it, first
of all based on input I got in response to a request for help
last year (http://thread.gmane.org/gmane.linux.kernel/1703405),=20
especially taking Thomas Gleixner's input=20
(http://thread.gmane.org/gmane.linux.kernel/1703405/focus=3D2952)=20
into account. I also got some further offlist input from Darren
 Hart, Torvald Riegel, and Davidlohr Bueso that has been
incorporated into the revised draft. Other than that, I got
some useful info out of Ulrich Drepper's paper (cited at the
end of the page) and one or two web pages (cited in the page
source).

The page has now increased in size by a factor of about 5, but
is far from complete. In particular, as I reworked the page,=20
there were many details that I was not 100% certain of, and I
have added FIXME markers to the page source. In addition,
Torvald added some text, and a few more FIXMEs. Some of
the FIXMEs are trivial, as in: I'd like confirmation that
I have correctly captured a technical detail. Others are more=20
substantial, probably requiring the addition of further text.

I appreciate that there are probably other things that can be
improved in the page. (Torvald and Darren have some ideas.)
However, before growing the page any further, I would like to
resolve as many of the FIXMEs (and any other problems that people
see) as possible in the existing text. I need help with that.=20
(And I know that dealing with that help, if I get it, will in=20
itself will be quite a task to deal with, which is why I have=20
been delaying it for many weeks now, as my time has been=20
rather limited recently.)

So, please take a look at the page below. At this point,
I would most especially appreciate help with the FIXMEs.

Cheers,

Michael



=46UTEX(2)                Linux Programmer's Manual               FUTEX=
(2)

NAME
       futex - fast user-space locking

SYNOPSIS
       #include <linux/futex.h>
       #include <sys/time.h>

       int futex(int *uaddr, int futex_op, int val,
                 const struct timespec *timeout,   /* or: uint32_t val2=
 */
                 int *uaddr2, int val3);

       Note: There is no glibc wrapper for this system call; see NOTES.

DESCRIPTION
       The  futex()  system  call  provides a method for waiting until =
a
       certain condition becomes true.  It is typically used as a block=
=E2=80=90
       ing  construct  in  the context of shared-memory synchronization=
:
       The program implements the majority  of  the  synchronization  i=
n
       user  space,  and  uses  one of the operations of the system cal=
l
       when it is likely that it has to block for a  longer  time  unti=
l
       the  condition  becomes true.  The program uses another operatio=
n
       of the system call to wake anyone waiting for a particular condi=
=E2=80=90
       tion.

       The  condition  is  represented  by  the  futex word, which is a=
n
       address in memory supplied to the futex() system  call,  and  th=
e
       32-bit  value  at  this  memory  location.   (While  the  virtua=
l
       addresses for the same physical memory address in  separate  pro=
=E2=80=90
       cesses  may be different, the same physical address may be share=
d
       by the processes using mmap(2).)

       When executing a futex operation that requests to block a thread=
,
       the  kernel  will block only if the futex word has the value tha=
t
       the calling thread supplied as expected value.  The load from th=
e
       futex  word,  the  comparison  with  the  expected value, and th=
e
       actual blocking will happen atomically and totally  ordered  wit=
h
       respect  to  concurrently  executing futex operations on the sam=
e
       futex word.  Thus, the futex word is used to connect the synchro=
=E2=80=90
       nization in user space with the implementation of blocking by th=
e
       kernel; similar to an atomic compare-and-exchange operation  tha=
t
       potentially  changes  shared  memory,  blocking via a futex is a=
n
       atomic compare-and-block operation.

       One example use of futexes is implementing locks.  The  state  o=
f
       the  lock  (i.e., acquired or not acquired) can be represented a=
s
       an atomically accessed flag in shared memory.  In the uncontende=
d
       case,  a  thread  can access or modify the lock state with atomi=
c
       instructions,  for  example  atomically  changing  it  from   no=
t
       acquired   to   acquired  using  an  atomic  compare-and-exchang=
e
       instruction.  A thread maybe unable acquire a lock because it  i=
s
       already  acquired by another thread.  It then may pass the lock'=
s
       flag as futex word and the value representing the acquired  stat=
e
       as  the  expected value to a futex() wait operation.  The call t=
o
       futex() will block if and only if the  lock  is  still  acquired=
=2E
       When  releasing  the  lock,  a thread has to first reset the loc=
k
       state to not acquired and then execute  a  futex  operation  tha=
t
       wakes  threads  blocked on the lock flag used as futex word (thi=
s
       can be be further optimized to avoid unnecessary wake-ups).   Se=
e
       futex(7) for more detail on how to use futexes.

       Besides the basic wait and wake-up futex functionality, there ar=
e
       further futex operations aimed at  supporting  more  complex  us=
e
       cases.   Also note that no explicit initialization or destructio=
n
       are necessary to use futexes; the kernel maintains a futex (i.e.=
,
       the  kernel-internal  implementation  artifact) only while opera=
=E2=80=90
       tions such as FUTEX_WAIT, described below, are being performed o=
n
       a particular futex word.

   Arguments
       The  uaddr  argument points to the futex word.  On all platforms=
,
       futexes are four-byte integers that must be aligned  on  a  four=
-
       byte  boundary.   The operation to perform on the futex is speci=
=E2=80=90
       fied in the futex_op argument; val is a value whose  meaning  an=
d
       purpose depends on futex_op.

       The  remaining arguments (timeout, uaddr2, and val3) are require=
d
       only for certain of the futex operations described below.   Wher=
e
       one of these arguments is not required, it is ignored.

       For  several  blocking  operations,  the  timeout  argument  is =
a
       pointer to a timespec structure that specifies a timeout for  th=
e
       operation.   However,  notwithstanding the prototype shown above=
,
       for some operations, the least significant four bytes are used a=
s
       an  integer  whose  meaning  is determined by the operation.  Fo=
r
       these operations, the kernel casts the  timeout  value  first  t=
o
       unsigned  long,  then  to  uint32_t, and in the remainder of thi=
s
       page, this argument is referred to as val2  when  interpreted  i=
n
       this fashion.

       Where  it is required, the uaddr2 argument is a pointer to a sec=
=E2=80=90
       ond futex word that is employed by the operation.  The  interpre=
=E2=80=90
       tation of the final integer argument, val3, depends on the opera=
=E2=80=90
       tion.

   Futex operations
       The futex_op argument consists of two parts: a command that spec=
=E2=80=90
       ifies  the  operation to be performed, bit-wise ORed with zero o=
r
       or more options that modify the behaviour of the operation.   Th=
e
       options that may be included in futex_op are as follows:

       FUTEX_PRIVATE_FLAG (since Linux 2.6.22)
              This option bit can be employed with all futex operations=
=2E
              It tells the kernel that the futex is process-private  an=
d
              not  shared  with  another process (i.e., it is being use=
d
              for synchronization  only  between  threads  of  the  sam=
e
              process).   This allows the kernel to make some additiona=
l
              performance optimizations.

              As a convenience, <linux/futex.h> defines a  set  of  con=
=E2=80=90
              stants  with  the  suffix _PRIVATE that are equivalents o=
f
              all  of  the  operations  listed  below,  but   with   th=
e
              FUTEX_PRIVATE_FLAG  ORed  into  the constant value.  Thus=
,
              there are FUTEX_WAIT_PRIVATE, FUTEX_WAKE_PRIVATE,  and  s=
o
              on.

       FUTEX_CLOCK_REALTIME (since Linux 2.6.28)
              This   option   bit   can   be   employed  only  with  th=
e
              FUTEX_WAIT_BITSET and FUTEX_WAIT_REQUEUE_PI operations.

              If this option is set, the kernel  treats  timeout  as  a=
n
              absolute time based on CLOCK_REALTIME.

=2E\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?
              If  this  option  is not set, the kernel treats timeout a=
s
              relative time, measured against the CLOCK_MONOTONIC clock=
=2E

       The operation specified in futex_op is one of the following:

       FUTEX_WAIT (since Linux 2.6.0)
              This operation tests that the  value  at  the  futex  wor=
d
              pointed  to  by  the  address  uaddr  still  contains  th=
e
              expected value  val,  and  if  so,  then  sleeps  awaitin=
g
              FUTEX_WAKE  on  the  futex word.  The load of the value o=
f
              the futex word is an atomic  memory  access  (i.e.,  usin=
g
              atomic  machine  instructions  of the respective architec=
=E2=80=90
              ture).  This load, the comparison with the expected value=
,
              and starting to sleep are performed atomically and totall=
y
              ordered with respect to other futex operations on the sam=
e
              futex  word.  If the thread starts to sleep, it is consid=
=E2=80=90
              ered a waiter on this futex word.  If the futex value doe=
s
              not  match  val,  then the call fails immediately with th=
e
              error EAGAIN.

              The purpose of the comparison with the expected  value  i=
s
              to  prevent  lost  wake-ups: If another thread changed th=
e
              value of the futex word after the calling  thread  decide=
d
              to block based on the prior value, and if the other threa=
d
              executed a FUTEX_WAKE operation (or similar wake-up) afte=
r
              the  value  change  and  before this FUTEX_WAIT operation=
,
              then the latter will observe the value change and will no=
t
              start to sleep.

              If  the timeout argument is non-NULL, its contents specif=
y
              a relative timeout for the wait, measured according to th=
e
=2E\" FIXME XXX I added CLOCK_MONOTONIC below. Okay?
              CLOCK_MONOTONIC  clock.  (This interval will be rounded u=
p
              to the system clock  granularity,  and  kernel  schedulin=
g
              delays  mean  that  the blocking interval may overrun by =
a
              small amount.)  If timeout is NULL, the call blocks indef=
=E2=80=90
              initely.

              The arguments uaddr2 and val3 are ignored.


       FUTEX_WAKE (since Linux 2.6.0)
              This  operation  wakes at most val of the waiters that ar=
e
              waiting (e.g., inside FUTEX_WAIT) on the futex word at th=
e
              address  uaddr.  Most commonly, val is specified as eithe=
r
              1 (wake up a single waiter) or INT_MAX (wake up all  wait=
=E2=80=90
              ers).   No  guarantee  is provided about which waiters ar=
e
              awoken (e.g., a waiter with a higher  scheduling  priorit=
y
              is  not  guaranteed to be awoken in preference to a waite=
r
              with a lower priority).

              The arguments timeout, uaddr2, and val3 are ignored.


       FUTEX_FD (from Linux 2.6.0 up to and including Linux 2.6.25)
              This operation creates a file descriptor that  is  associ=
=E2=80=90
              ated  with  the futex at uaddr.  The caller must close th=
e
              returned file descriptor after use.  When another  proces=
s
              or  thread  performs  a  FUTEX_WAKE on the futex word, th=
e
              file  descriptor  indicates   as   being   readable   wit=
h
              select(2), poll(2), and epoll(7)

              The  file  descriptor  can  be used to obtain asynchronou=
s
              notifications:  if  val  is  nonzero,  then  when  anothe=
r
              process  or  thread executes a FUTEX_WAKE, the caller wil=
l
              receive the signal number that was passed in val.

              The arguments timeout, uaddr2 and val3 are ignored.

=2E\" FIXME(Torvald) We never define "upped".  Maybe just remove the
=2E\"      following sentence?
              To prevent race conditions, the caller should test if  th=
e
              futex has been upped after FUTEX_FD returns.

              Because  it was inherently racy, FUTEX_FD has been remove=
d
              from Linux 2.6.26 onward.

       FUTEX_REQUEUE (since Linux 2.6.0)
=2E\" FIXME(Torvald) Is there some indication that FUTEX_REQUEUE is bro=
ken
=2E\"     in general, or is this comment implicitly speaking about the
=2E\"     condvar (?) use case? If the latter we might want to weaken t=
he
=2E\"     advice below a little.
=2E\" [Anyone else have input on this?]
              Avoid using this operation.  It is broken for its intende=
d
              purpose.  Use FUTEX_CMP_REQUEUE instead.

              This    operation    performs    the    same    task    a=
s
              FUTEX_CMP_REQUEUE, except that no check is made using  th=
e
              value in val3.  (The argument val3 is ignored.)

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

=2E\" FIXME(Torvald) Is the following correct?  Or is just the decision
=2E\" which threads to wake or requeue part of the atomic operation?
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

              This  operation was added as a replacement for the earlie=
r
              FUTEX_REQUEUE.  The difference is that the  check  of  th=
e
              value  at uaddr can be used to ensure that requeueing hap=
=E2=80=90
              pens only under certain conditions.  Both  operations  ca=
n
              be   used   to  avoid  a  "thundering  herd"  effect  whe=
n
              FUTEX_WAKE is used and all of the waiters that  are  woke=
n
              need to acquire another futex.

=2E\" FIXME Please review the following new paragraph to see if it is
=2E\"       accurate.
              Typical  values to specify for val are 0 or or 1.  (Speci=
=E2=80=90
              fying INT_MAX is not useful, because  it  would  make  th=
e
              FUTEX_CMP_REQUEUE  operation  equivalent  to  FUTEX_WAKE.=
)
              The limit value specified via val2 is typically  either  =
1
              or  INT_MAX.  (Specifying the argument as 0 is not useful=
,
              because it  would  make  the  FUTEX_CMP_REQUEUE  operatio=
n
              equivalent to FUTEX_WAIT.)
=2E\" FIXME Here, it would be helpful to have an example of how
=2E\"       FUTEX_CMP_REQUEUE might be used, at the same time illustrat=
ing
=2E\"       why FUTEX_WAKE is unsuitable for the same use case.


       FUTEX_WAKE_OP (since Linux 2.6.14)
=2E\" FIXME I added a lengthy piece of text on FUTEX_WAKE_OP text,
=2E\"       and I'd be happy if someone checked it.
=2E\"
=2E\" FIXME(Torvald) The glibc condvar implementation is currently bein=
g
=2E\"     revised (e.g., to not use an internal lock anymore).
=2E\"     It is probably more future-proof to remove this paragraph.
=2E\" [Torvald, do you have an update here?]
=2E\"
              This  operation  was  added to support some user-space us=
e
              cases where more than one futex must  be  handled  at  th=
e
              same time.  The most notable example is the implementatio=
n
              of pthread_cond_signal(3), which  requires  operations  o=
n
              two  futexes,  the one used to implement the mutex and th=
e
              one used in the implementation of the wait  queue  associ=
=E2=80=90
              ated  with  the  condition variable.  FUTEX_WAKE_OP allow=
s
              such cases to be implemented without leading to high rate=
s
              of contention and context switching.

              The FUTEX_WAIT_OP operation is equivalent to executing th=
e
              following code atomically and totally ordered with respec=
t
              to other futex operations on any of the two supplied fute=
x
              words:

                  int oldval =3D *(int *) uaddr2;
                  *(int *) uaddr2 =3D oldval op oparg;
                  futex(uaddr, FUTEX_WAKE, val, 0, 0, 0);
                  if (oldval cmp cmparg)
                      futex(uaddr2, FUTEX_WAKE, val2, 0, 0, 0);

              In other words, FUTEX_WAIT_OP does the following:

              *  saves the original value of the futex  word  at  uaddr=
2
                 and  performs  an  operation to modify the value of th=
e
                 futex at uaddr2; this is  an  atomic  read-modify-writ=
e
                 memory  access (i.e., using atomic machine instruction=
s
                 of the respective architecture)

              *  wakes up a maximum of val waiters on the futex for  th=
e
                 futex word at uaddr; and

              *  dependent  on  the  results  of  a test of the origina=
l
                 value of the futex word at uaddr2, wakes up  a  maximu=
m
                 of  val2  waiters  on  the  futex for the futex word a=
t
                 uaddr2.

              The operation and comparison that are to be performed  ar=
e
              encoded  in  the  bits of the argument val3.  Pictorially=
,
              the encoding is:

                      +---+---+-----------+-----------+
                      |op |cmp|   oparg   |  cmparg   |
                      +---+---+-----------+-----------+
                        4   4       12          12    <=3D=3D # of bits

              Expressed in code, the encoding is:

                  #define FUTEX_OP(op, oparg, cmp, cmparg) \
                                  (((op & 0xf) << 28) | \
                                  ((cmp & 0xf) << 24) | \
                                  ((oparg & 0xfff) << 12) | \
                                  (cmparg & 0xfff))

              In the above, op and cmp are each one of the codes  liste=
d
              below.   The  oparg  and  cmparg  components  are  litera=
l
              numeric values, except as noted below.

              The op component has one of the following values:

                  FUTEX_OP_SET        0  /* uaddr2 =3D oparg; */
                  FUTEX_OP_ADD        1  /* uaddr2 +=3D oparg; */
                  FUTEX_OP_OR         2  /* uaddr2 |=3D oparg; */
                  FUTEX_OP_ANDN       3  /* uaddr2 &=3D ~oparg; */
                  FUTEX_OP_XOR        4  /* uaddr2 ^=3D oparg; */

              In addition, bit-wise ORing the following  value  into  o=
p
              causes (1 << oparg) to be used as the operand:

                  FUTEX_OP_ARG_SHIFT  8  /* Use (1 << oparg) as operand=
 */

              The cmp field is one of the following:

                  FUTEX_OP_CMP_EQ     0  /* if (oldval =3D=3D cmparg) w=
ake */
                  FUTEX_OP_CMP_NE     1  /* if (oldval !=3D cmparg) wak=
e */
                  FUTEX_OP_CMP_LT     2  /* if (oldval < cmparg) wake *=
/
                  FUTEX_OP_CMP_LE     3  /* if (oldval <=3D cmparg) wak=
e */
                  FUTEX_OP_CMP_GT     4  /* if (oldval > cmparg) wake *=
/
                  FUTEX_OP_CMP_GE     5  /* if (oldval >=3D cmparg) wak=
e */

              The return value of FUTEX_WAKE_OP is the sum of the numbe=
r
              of waiters woken on the futex uaddr  plus  the  number  o=
f
              waiters woken on the futex uaddr2.

       FUTEX_WAIT_BITSET (since Linux 2.6.25)
              This operation is like FUTEX_WAIT except that val3 is use=
d
              to provide a 32-bit bitset to the kernel.  This bitset  i=
s
              stored  in  the  kernel-internal state of the waiter.  Se=
e
              the description of FUTEX_WAKE_BITSET for further details.

              The FUTEX_WAIT_BITSET operation also interprets the  time=
=E2=80=90
              out argument differently from FUTEX_WAIT.  See the discus=
=E2=80=90
              sion of FUTEX_CLOCK_REALTIME, above.

              The uaddr2 argument is ignored.

       FUTEX_WAKE_BITSET (since Linux 2.6.25)
              This operation is the same as FUTEX_WAKE except  that  th=
e
              val3  argument  is  used to provide a 32-bit bitset to th=
e
              kernel.  This bitset  is  used  to  select  which  waiter=
s
              should  be  woken up.  The selection is done by a bit-wis=
e
              AND of the "wake" bitset (i.e., the value in val3) and th=
e
              bitset which is stored in the kernel-internal state of th=
e
              waiter   (the   "wait"   bitset   that   is   set    usin=
g
              FUTEX_WAIT_BITSET).   All  of  the  waiters  for which th=
e
              result of the AND is nonzero are woken up;  the  remainin=
g
              waiters are left sleeping.

=2E\" FIXME XXX Is this next paragraph that I added okay?
              The  effect  of FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSET i=
s
              to allow selective wake-ups among  multiple  waiters  tha=
t
              are  blocked on the same futex.  Note, however, that usin=
g
              this bitset multiplexing feature on a futex is less  effi=
=E2=80=90
              cient  than simply using multiple futexes, because employ=
=E2=80=90
              ing bitset multiplexing requires the kernel to  check  al=
l
              waiters  on  a  futex, including those that are not inter=
=E2=80=90
              ested in being woken up (i.e., they do not have the  rele=
=E2=80=90
              vant bit set in their "wait" bitset).

              The uaddr2 and timeout arguments are ignored.

              The  FUTEX_WAIT  and  FUTEX_WAKE  operations correspond t=
o
              FUTEX_WAIT_BITSET and FUTEX_WAKE_BITSET  operations  wher=
e
              the bitsets are all ones.

   Priority-inheritance futexes
       Linux supports priority-inheritance (PI) futexes in order to han=
=E2=80=90
       dle priority-inversion problems that can be encountered with nor=
=E2=80=90
       mal  futex  locks.  Priority inversion is the problem that occur=
s
       when a high-priority task is blocked waiting to  acquire  a  loc=
k
       held  by a low-priority task, while tasks at an intermediate pri=
=E2=80=90
       ority continuously preempt the low-priority task  from  the  CPU=
=2E
       Consequently,  the  low-priority  task  makes  no progress towar=
d
       releasing the lock, and the high-priority task remains blocked.

       Priority inheritance is a mechanism for dealing with  the  prior=
=E2=80=90
       ity-inversion problem.  With this mechanism, when a high-priorit=
y
       task becomes blocked by a lock held by a low-priority  task,  th=
e
       latter's priority is temporarily raised to that of the former, s=
o
       that it is not preempted by any intermediate level tasks, and ca=
n
       thus  make  progress toward releasing the lock.  To be effective=
,
       priority inheritance must be transitive, meaning that if a  high=
-
       priority task blocks on a lock held by a lower-priority task tha=
t
       is itself blocked by lock held by  another  intermediate-priorit=
y
       task  (and  so  on, for chains of arbitrary length), then both o=
f
       those task (or more generally, all of the tasks in a lock  chain=
)
       have  their priorities raised to be the same as the high-priorit=
y
       task.

=2E\" FIXME XXX The following is my attempt at a definition of PI futex=
es,
=2E\"       based on mail discussions with Darren Hart. Does it seem ok=
ay?

       From a user-space perspective, what makes a futex PI-aware  is  =
a
       policy  agreement  between  user  space  and the kernel about th=
e
       value of the futex word (described in a moment), coupled with th=
e
       use  of  the  PI futex operations described below (in particular=
,
       FUTEX_LOCK_PI, FUTEX_TRYLOCK_PI, and FUTEX_CMP_REQUEUE_PI).

=2E\" FIXME XXX =3D=3D=3D=3D=3D Start of adapted Hart/Guniguntala text =
=3D=3D=3D=3D=3D
=2E\"       The following text is drawn from the Hart/Guniguntala paper
=2E\"       (listed in SEE ALSO), but I have reworded some pieces
=2E\"       significantly. Please check it.

       The PI futex operations described below  differ  from  the  othe=
r
       futex  operations  in  that  they impose policy on the use of th=
e
       value of the futex word:

       *  If the lock is not acquired, the futex word's value  shall  b=
e
          0.

       *  If  the  lock is acquired, the futex word's value shall be th=
e
          thread ID (TID; see gettid(2)) of the owning thread.

       *  If the lock is owned and there are threads contending for  th=
e
          lock,  then  the  FUTEX_WAITERS  bit shall be set in the fute=
x
          word's value; in other words, this value is:

              FUTEX_WAITERS | TID


       Note that a PI futex word never just has the value FUTEX_WAITERS=
,
       which is a permissible state for non-PI futexes.

       With this policy in place, a user-space application can acquire =
a
       not-acquired lock or release a lock that no other threads try  t=
o
       acquire using atomic instructions executed in user space (e.g., =
a
       compare-and-swap operation such as cmpxchg on the  x86  architec=
=E2=80=90
       ture).   Acquiring  a  lock simply consists of using compare-and=
-
       swap to atomically set the futex word's value to the caller's TI=
D
       if  its  previous  value  was 0.  Releasing a lock requires usin=
g
       compare-and-swap to set the futex word's value to 0 if the previ=
=E2=80=90
       ous value was the expected TID.

       If a futex is already acquired (i.e., has a nonzero value), wait=
=E2=80=90
       ers must employ the FUTEX_LOCK_PI operation to acquire the  lock=
=2E
       If other threads are waiting for the lock, then the FUTEX_WAITER=
S
       bit is set in the futex value; in this case, the lock owner  mus=
t
       employ the FUTEX_UNLOCK_PI operation to release the lock.

       In  the  cases  where  callers  are forced into the kernel (i.e.=
,
       required to perform a futex() call), they then deal directly wit=
h
       a so-called RT-mutex, a kernel locking mechanism which implement=
s
       the required priority-inheritance semantics.  After the  RT-mute=
x
       is  acquired,  the futex value is updated accordingly, before th=
e
       calling thread returns to user space.
=2E\" FIXME =3D=3D=3D=3D=3D End of adapted Hart/Guniguntala text =3D=3D=
=3D=3D=3D



=2E\" FIXME We need some explanation in the following paragraph of *why=
*
=2E\"       it is important to note that "the kernel will update the
=2E\"       futex word's value prior
       It is important to note to returning to user space" . Can someon=
e
       explain?   that  the  kernel  will  update the futex word's valu=
e
       prior to returning to user space.  Unlike the other futex  opera=
=E2=80=90
       tions  described  above, the PI futex operations are designed fo=
r
       the implementation of very specific IPC mechanisms.
=2E\"
=2E\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren H=
art
=2E\"       made the observation that "EINVAL is returned if the non-pi=
=20
=2E\"       to pi or op pairing semantics are violated."
=2E\"       Probably there needs to be a general statement about this
=2E\"       requirement, probably located at about this point in the pa=
ge.
=2E\"       Darren (or someone else), care to take a shot at this?
=2E\"
=2E\" FIXME Somewhere on this page (I guess under the discussion of PI
=2E\"       futexes) we need a discussion of the FUTEX_OWNER_DIED bit.
=2E\"       Can someone propose a text?



       PI futexes are operated on by specifying  one  of  the  followin=
g
       values in futex_op:

       FUTEX_LOCK_PI (since Linux 2.6.18)
=2E\" FIXME I did some significant rewording of tglx's text to create
=2E\"       the text below.
=2E\"       Please check the following paragraph, in case I injected
=2E\"       errors.
              This  operation  is used after after an attempt to acquir=
e
              the lock  via  an  atomic  user-space  instruction  faile=
d
              because  the  futex word has a nonzero value=E2=80=94spec=
ifically,
              because it contained the  namespace-specific  TID  of  th=
e
              lock owner.
=2E\" FIXME In the preceding line, what does "namespace-specific" mean?
=2E\"       (I kept those words from tglx.)
=2E\"       That is, what kind of namespace are we talking about?
=2E\"       (I suppose we are talking PID namespaces here, but I want t=
o
=2E\"       be sure.)


              The  operation  checks  the value of the futex word at th=
e
              address uaddr.  If the value is 0, then the  kernel  trie=
s
              to atomically set the futex value to the caller's TID. =20
=2E\" FIXME What would be the cause(s) of failure referred to
=2E\"       in the following sentence?
              If
              that fails, or the futex word's value is nonzero, the ker=
=E2=80=90
              nel  atomically  sets the FUTEX_WAITERS bit, which signal=
s
              the futex owner that it cannot unlock the  futex  in  use=
r
              space  atomically  by setting the futex value to 0.  Afte=
r
              that, the kernel tries to find the thread which is associ=
=E2=80=90
              ated with the owner TID, creates or reuses kernel state o=
n
              behalf of the owner and attaches the waiter  to  it.  =20
=2E\" FIXME Could I get a bit more detail on the previous lines?
=2E\"       What is "creates or reuses kernel state" about?
=2E\"       (I think this needs to be clearer in the page)

=2E\" FIXME In the next line, what type of "priority" are we talking ab=
out?
=2E\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
=2E\"       Or something else?

              The
              enqueueing  of  the waiter is in descending priority orde=
r
              if more than one waiter exists. =20

=2E\" FIXME In the next sentence, what type of "priority" are we talkin=
g about?
=2E\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
=2E\"       Or something else?
=2E\" FIXME What does "bandwidth" refer to in the next sentence?

              The owner inherits either
              the priority or the bandwidth of the waiter. =20
=2E\" FIXME In the preceding sentence, what determines whether the
=2E\"       owner inherits the priority versus the bandwidth?

=2E\" FIXME Could I get some help translating the next sentence into
=2E\"       something that user-space developers (and I) can understand=
?
=2E\"       In particular, what are "nested locks" in this context?

              This inheri=E2=80=90
              tance follows the lock chain in the case of nested lockin=
g
              and performs deadlock detection.

=2E\" FIXME tglx said "The timeout argument is handled as described in
=2E\"       FUTEX_WAIT." However, it appears to me that this is not rig=
ht.
=2E\"       Is the following formulation correct?
              The  timeout  argument  provides  a  timeout  for the loc=
k
              attempt.  It is interpreted as an absolute time,  measure=
d
              against the CLOCK_REALTIME clock.  If timeout is NULL, th=
e
              operation will block indefinitely.

              The uaddr2, val, and val3 arguments are ignored.

       FUTEX_TRYLOCK_PI (since Linux 2.6.18)
=2E\" FIXME I think it would be helpful here to say a few more words ab=
out
=2E\"       the difference(s) between FUTEX_LOCK_PI and FUTEX_TRYLOCK_P=
I.
=2E\"       Can someone propose something?
              This operation tries to acquire the futex  at  uaddr.   I=
t
              deals  with  the situation where the TID value at uaddr i=
s
              0, but the FUTEX_WAITERS bit is set.   User  space  canno=
t
              handle this condition in a race-free manner
=2E\" FIXME How does the situation in the previous sentence come about?
=2E\"       Probably it would be helpful to say something about that in
=2E\"       the man page.
=2E\" FIXME And *how* does FUTEX_TRYLOCK_PI deal with this situation?


              The uaddr2, val, timeout, and val3 arguments are ignored.

       FUTEX_UNLOCK_PI (since Linux 2.6.18)
              This operation wakes the top priority waiter that is wait=
=E2=80=90
              ing in FUTEX_LOCK_PI on the futex address provided by  th=
e
              uaddr argument.

              This  is  called when the user space value at uaddr canno=
t
              be changed atomically from a TID (of the owner) to 0.

              The uaddr2, val, timeout, and val3 arguments are ignored.

       FUTEX_CMP_REQUEUE_PI (since Linux 2.6.31)
              This operation is a PI-aware variant of FUTEX_CMP_REQUEUE=
=2E
              It    requeues    waiters    that    are    blocked    vi=
a
              FUTEX_WAIT_REQUEUE_PI on uaddr from a non-PI source  fute=
x
              (uaddr) to a PI target futex (uaddr2).

              As with FUTEX_CMP_REQUEUE, this operation wakes up a maxi=
=E2=80=90
              mum of val waiters that are waiting on the futex at uaddr=
=2E
              However, for FUTEX_CMP_REQUEUE_PI, val is required to be =
1
              (since the main point is to avoid a thundering herd).  Th=
e
              remaining  waiters  are removed from the wait queue of th=
e
              source futex at uaddr and added to the wait queue  of  th=
e
              target futex at uaddr2.

              The val2 and val3 arguments serve the same purposes as fo=
r
              FUTEX_CMP_REQUEUE.
=2E\" FIXME The page at http://locklessinc.com/articles/futex_cheat_she=
et/
=2E\"       notes that "priority-inheritance Futex to priority-inherita=
nce
=2E\"       Futex requeues are currently unsupported". Do we need to sa=
y
=2E\"       something in the man page about that?



       FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)

=2E\" FIXME I find the next sentence (from tglx) pretty hard to grok.
=2E\"       Could someone explain it a bit more?

              Wait operation to wait on a  non-PI  futex  at  uaddr  an=
d
              potentially  be  requeued  onto a PI futex at uaddr2.  Th=
e
              wait operation on uaddr is the same  as  FUTEX_WAIT.  =20

=2E\" FIXME I'm not quite clear on the meaning of the following sentenc=
e.
=2E\"       Is this trying to say that while blocked in a
=2E\"       FUTEX_WAIT_REQUEUE_PI, it could happen that another
=2E\"       task does a FUTEX_WAKE on uaddr that simply causes
=2E\"       a normal wake, with the result that the FUTEX_WAIT_REQUEUE_=
PI
=2E\"       does not complete? What happens then to the FUTEX_WAIT_REQU=
EUE_PI
=2E\"       opertion? Does it remain blocked, or does it unblock
=2E\"       In which case, what does user space see?

              The
              waiter   can  be  removed  from  the  wait  on  uaddr  vi=
a
              FUTEX_WAKE without requeueing on uaddr2.

=2E\" FIXME Please check the following. tglx said "The timeout argument
=2E\"       is handled as described in FUTEX_WAIT.", but the truth is
=2E\"       as below, AFAICS

              If timeout is not NULL, it specifies  a  timeout  for  th=
e
              wait  operation;  this  timeout is interpreted as outline=
d
              above  in  the  description  of  the  FUTEX_CLOCK_REALTIM=
E
              option.   If  timeout  is  NULL,  the  operation can bloc=
k
              indefinitely.

              The val3 argument is ignored.

=2E\" FIXME Re the preceding sentence... Actually 'val3' is internally =
set to
=2E\"       FUTEX_BITSET_MATCH_ANY before calling futex_wait_requeue_pi=
().
=2E\"       I'm not sure we need to say anything about this though.
=2E\"       Comments?


              The FUTEX_WAIT_REQUEUE_PI  and  FUTEX_CMP_REQUEUE_PI  wer=
e
              added  to  support a fairly specific use case: support fo=
r
              priority-inheritance-aware POSIX threads  condition  vari=
=E2=80=90
              ables.  The idea is that these operations should always b=
e
              paired, in order to ensure that user space and the  kerne=
l
              remain in sync.  Thus, in the FUTEX_WAIT_REQUEUE_PI opera=
=E2=80=90
              tion, the user-space application pre-specifies the  targe=
t
              of    the    requeue    that    takes    place    in   th=
e
              FUTEX_CMP_REQUEUE_PI operation.

RETURN VALUE
       In the event of an error (and assuming that futex()  was  invoke=
d
       via  syscall(2)), all operations return -1 and set errno to indi=
=E2=80=90
       cate the cause of the error.  The return value on success depend=
s
       on the operation, as described in the following list:

       FUTEX_WAIT
              Returns 0 if the caller was woken up.  Note that a wake-u=
p
              can also be caused by common futex usage patterns in unre=
=E2=80=90
              lated code that happened to have previously used the fute=
x
              word's memory location (e.g., typical  futex-based  imple=
=E2=80=90
              mentations  of  Pthreads mutexes can cause this under som=
e
              conditions).  Therefore, callers should  always  conserva=
=E2=80=90
              tively assume that a return value of 0 can mean a spuriou=
s
              wake-up, and use the futex word's value  (i.e.,  the  use=
r
              space synchronization scheme)
                  to decide whether to continue to block or not.

       FUTEX_WAKE
              Returns the number of waiters that were woken up.

       FUTEX_FD
              Returns the new file descriptor associated with the futex=
=2E

       FUTEX_REQUEUE
              Returns the number of waiters that were woken up.

       FUTEX_CMP_REQUEUE
              Returns  the total number of waiters that were woken up o=
r
              requeued to the futex for the futex word  at  uaddr2.   I=
f
              this  value  is  greater  than val, then difference is th=
e
              number of waiters requeued to the futex for the futex wor=
d
              at uaddr2.

       FUTEX_WAKE_OP
              Returns  the  total  number of waiters that were woken up=
=2E
              This is the sum of the woken waiters on  the  two  futexe=
s
              for the futex words at uaddr and uaddr2.

       FUTEX_WAIT_BITSET
              Returns  0 if the caller was woken up.  See FUTEX_WAIT fo=
r
              how to interpret this correctly in practice.

       FUTEX_WAKE_BITSET
              Returns the number of waiters that were woken up.

       FUTEX_LOCK_PI
              Returns 0 if the futex was successfully locked.

       FUTEX_TRYLOCK_PI
              Returns 0 if the futex was successfully locked.

       FUTEX_UNLOCK_PI
              Returns 0 if the futex was successfully unlocked.

       FUTEX_CMP_REQUEUE_PI
              Returns the total number of waiters that were woken up  o=
r
              requeued  to  the  futex for the futex word at uaddr2.  I=
f
              this value is greater than val,  then  difference  is  th=
e
              number of waiters requeued to the futex for the futex wor=
d
              at uaddr2.

       FUTEX_WAIT_REQUEUE_PI
              Returns 0 if the caller was successfully requeued  to  th=
e
              futex for the futex word at uaddr2.

ERRORS
       EACCES No read access to the memory of a futex word.

       EAGAIN (FUTEX_WAIT, FUTEX_WAIT_BITSET, FUTEX_WAIT_REQUEUE_PI) Th=
e
              value pointed to by uaddr was not equal  to  the  expecte=
d
              value val at the time of the call.

              Note:  on Linux, the symbolic names EAGAIN and EWOULDBLOC=
K
              (both of which appear in different  parts  of  the  kerne=
l
              futex code) have the same value.

       EAGAIN (FUTEX_CMP_REQUEUE,    FUTEX_CMP_REQUEUE_PI)   The   valu=
e
              pointed to by uaddr is not equal  to  the  expected  valu=
e
              val3.   (This  probably  indicates  a  race;  use the saf=
e
              FUTEX_WAKE now.)
=2E\" FIXME: Is the preceding sentence "(This probably...") correct?
=2E\" [I would prefer to remove this sentence. --triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]


       EAGAIN (FUTEX_LOCK_PI,  FUTEX_TRYLOCK_PI,   FUTEX_CMP_REQUEUE_PI=
)
              The    futex    owner    thread    ID    of   uaddr   (fo=
r
              FUTEX_CMP_REQUEUE_PI: uaddr2) is about to  exit,  but  ha=
s
              not yet handled the internal state cleanup.  Try again.

=2E\" FIXME XXX Should there be an EAGAIN case for FUTEX_TRYLOCK_PI?
=2E\"       It seems so, looking at the handling of the rt_mutex_tryloc=
k()
=2E\"       call in futex_lock_pi()
=2E\"       (Davidlohr also thinks so.)


       EDEADLK
              (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI=
)
              The futex word at uaddr is already locked by the caller.

       EDEADLK

=2E\" FIXME I reworded tglx's text somewhat; is the following okay?

              (FUTEX_CMP_REQUEUE_PI) While requeueing a waiter to the P=
I
              futex  for the futex word at uaddr2, the kernel detected =
a
              deadlock.

=2E\" FIXME XXX I see that kernel/locking/rtmutex.c uses EDEADLK in som=
e
=2E\"       places, and EDEADLOCK in others. On almost all architecture=
s
=2E\"       these constants are synonymous. Is there a reason that both
=2E\"       names are used?

       EFAULT A required pointer argument (i.e., uaddr, uaddr2, or time=
=E2=80=90
              out) did not point to a valid user-space address.

       EINTR  A  FUTEX_WAIT  or  FUTEX_WAIT_BITSET  operation was inter=
=E2=80=90
              rupted by a signal (see  signal(7)).   In  kernels  befor=
e
              Linux  2.6.22,  this error could also be returned for on =
a
              spurious wakeup; since Linux 2.6.22, this no  longer  hap=
=E2=80=90
              pens.

       EINVAL The  operation  in futex_op is one of those that employs =
a
              timeout, but the supplied  timeout  argument  was  invali=
d
              (tv_sec  was  less than zero, or tv_nsec was not less tha=
n
              1,000,000,000).

       EINVAL The operation specified in futex_op employs one or both o=
f
              the  pointers  uaddr and uaddr2, but one of these does no=
t
              point to a valid object=E2=80=94that is, the address is n=
ot  four-
              byte-aligned.

       EINVAL (FUTEX_WAIT_BITSET, FUTEX_WAKE_BITSET) The bitset supplie=
d
              in val3 is zero.

       EINVAL (FUTEX_CMP_REQUEUE_PI)  uaddr  equals  uaddr2  (i.e.,   a=
n
              attempt was made to requeue to the same futex).

       EINVAL (FUTEX_FD) The signal number supplied in val is invalid.

       EINVAL (FUTEX_WAKE,       FUTEX_WAKE_OP,       FUTEX_WAKE_BITSET=
,
              FUTEX_REQUEUE, FUTEX_CMP_REQUEUE) The kernel  detected  a=
n
              inconsistency  between  the  user-space state at uaddr an=
d
              the kernel state=E2=80=94that is, it detected a waiter wh=
ich waits
              in FUTEX_LOCK_PI on uaddr.

       EINVAL (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_UNLOCK_PI)  Th=
e
              kernel detected an inconsistency  between  the  user-spac=
e
              state  at  uaddr  and  the  kernel  state.  This indicate=
s
              either state corruption or that the kernel found a  waite=
r
              on    uaddr   which   is   waiting   via   FUTEX_WAIT   o=
r
              FUTEX_WAIT_BITSET.
=2E\" FIXME Above, tglx did not mention the "state corruption" case for
=2E\"       FUTEX_UNLOCK_PI, but I have added it, since I'm estimating
=2E\"       that it also applied for FUTEX_UNLOCK_PI.
=2E\"       So, does that case also apply for FUTEX_UNLOCK_PI?


       EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  inconsis=
=E2=80=90
              tency  between the user-space state at uaddr2 and the ker=
=E2=80=90
              nel state; that is, the kernel  detected  a  waiter  whic=
h
              waits via FUTEX_WAIT on uaddr2.
=2E\" FIXME In the preceding sentence, tglx did not mention FUTEX_WAIT_=
BITSET,
=2E\"       but should that not also be included here?


       EINVAL (FUTEX_CMP_REQUEUE_PI)  The  kernel  detected an inconsis=
=E2=80=90
              tency between the user-space state at uaddr and the kerne=
l
              state;  that  is, the kernel detected a waiter which wait=
s
              via FUTEX_WAIT or FUTEX_WAIT_BITESET on uaddr.

       EINVAL (FUTEX_CMP_REQUEUE_PI) The kernel  detected  an  inconsis=
=E2=80=90
              tency between the user-space state at uaddr and the kerne=
l
              state; that is, the kernel detected a waiter  which  wait=
s
              on     uaddr     via     FUTEX_LOCK_PI     (instead     o=
f
              FUTEX_WAIT_REQUEUE_PI).

=2E\" FIXME XXX The following is a reworded version of Darren Hart's te=
xt.
=2E\"       Please check that I did not introduce any errors.
       EINVAL (FUTEX_CMP_REQUEUE_PI) An attempt was made  to  requeue  =
a
              waiter  to a futex other than that specified by the match=
=E2=80=90
              ing FUTEX_WAIT_REQUEUE_PI call for that waiter.

       EINVAL (FUTEX_CMP_REQUEUE_PI) The val argument is not 1.

       EINVAL Invalid argument.

       ENOMEM (FUTEX_LOCK_PI,  FUTEX_TRYLOCK_PI,   FUTEX_CMP_REQUEUE_PI=
)
              The  kernel could not allocate memory to hold state infor=
=E2=80=90
              mation.

       ENFILE (FUTEX_FD) The system limit on the total  number  of  ope=
n
              files has been reached.

       ENOSYS Invalid operation specified in futex_op.

       ENOSYS The FUTEX_CLOCK_REALTIME option was specified in futex_op=
,
              but the accompanying operation was neither FUTEX_WAIT_BIT=
=E2=80=90
              SET nor FUTEX_WAIT_REQUEUE_PI.

       ENOSYS (FUTEX_LOCK_PI,     FUTEX_TRYLOCK_PI,     FUTEX_UNLOCK_PI=
,
              FUTEX_CMP_REQUEUE_PI,  FUTEX_WAIT_REQUEUE_PI)  A  run-tim=
e
              check determined that the operation is not available.  Th=
e
              PI futex operations are not implemented on  all  architec=
=E2=80=90
              tures and are not supported on some CPU variants.

       EPERM  (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI=
)
              The caller is not allowed to attach itself to the futex a=
t
              uaddr  (for  FUTEX_CMP_REQUEUE_PI:  the  futex at uaddr2)=
=2E
              (This may be caused by a state corruption in user space.)

       EPERM  (FUTEX_UNLOCK_PI) The caller does not own the lock  repre=
=E2=80=90
              sented by the futex word.

       ESRCH  (FUTEX_LOCK_PI,   FUTEX_TRYLOCK_PI,  FUTEX_CMP_REQUEUE_PI=
)

=2E\" FIXME I reworded the following sentence a bit differently from
=2E\"       tglx's formulation. Is it okay?

              The thread ID in the futex word at uaddr does not exist.

       ESRCH  (FUTEX_CMP_REQUEUE_PI)=20

=2E\" FIXME I reworded the following sentence a bit differently from
=2E\"       tglx's formulation. Is it okay?

              The thread ID in the futex word  at
              uaddr2 does not exist.

       ETIMEDOUT
              The  operation  in futex_op employed the timeout specifie=
d
              in timeout, and the timeout expired before  the  operatio=
n
              completed.

VERSIONS
       Futexes were first made available in a stable kernel release wit=
h
       Linux 2.6.0.

       Initial futex support was merged in Linux 2.5.7 but with  differ=
=E2=80=90
       ent  semantics  from  what  was described above.  A four-argumen=
t
       system call with the semantics described in this page was  intro=
=E2=80=90
       duced  in Linux 2.5.40.  In Linux 2.5.70, one argument was added=
=2E
       In Linux 2.6.7, a sixth argument was added=E2=80=94messy,  espec=
ially  on
       the s390 architecture.

CONFORMING TO
       This system call is Linux-specific.

NOTES
       Glibc  does  not  provide a wrapper for this system call; call i=
t
       using syscall(2).

       Various higher-level programming abstractions are implemented vi=
a
       futexes, including POSIX threads mutexes and condition variables=
,
       as well as POSIX semaphores.

EXAMPLE

=2E\" FIXME Is it worth having an example program?
=2E\" FIXME Anything obviously broken in the example program?

       The program below demonstrates use of futexes in a program  wher=
e
       parent  and  child  use a pair of futexes located inside a share=
d
       anonymous mapping to synchronize access to a shared resource: th=
e
       terminal.   The  two  processes each write nloops (a command-lin=
e
       argument that defaults to 5 if omitted) messages to the  termina=
l
       and  employ  a  synchronization  protocol  that ensures that the=
y
       alternate in writing messages.  Upon running this program we  se=
e
       output such as the following:

           $ ./futex_demo
           Parent (18534) 0
           Child  (18535) 0
           Parent (18534) 1
           Child  (18535) 1
           Parent (18534) 2
           Child  (18535) 2
           Parent (18534) 3
           Child  (18535) 3
           Parent (18534) 4
           Child  (18535) 4

   Program source

       /* futex_demo.c

          Usage: futex_demo [nloops]
                           (Default: 5)

          Demonstrate the use of futexes in a program where parent and =
child
          use a pair of futexes located inside a shared anonymous mappi=
ng to
          synchronize access to a shared resource: the terminal. The tw=
o
          processes each write 'num-loops' messages to the terminal and=
 employ
          a synchronization protocol that ensures that they alternate i=
n
          writing messages.
       */
       #define _GNU_SOURCE
       #include <stdio.h>
       #include <errno.h>
       #include <stdlib.h>
       #include <unistd.h>
       #include <sys/wait.h>
       #include <sys/mman.h>
       #include <sys/syscall.h>
       #include <linux/futex.h>
       #include <sys/time.h>

       #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                               } while (0)

       static int *futex1, *futex2, *iaddr;

       static int
       futex(int *uaddr, int futex_op, int val,
             const struct timespec *timeout, int *uaddr2, int val3)
       {
           return syscall(SYS_futex, uaddr, futex_op, val,
                          timeout, uaddr, val3);
       }

       /* Acquire the futex pointed to by 'futexp': wait for its value =
to
          become 1, and then set the value to 0. */

       static void
       fwait(int *futexp)
       {
           int s;

           /* __sync_bool_compare_and_swap(ptr, oldval, newval) is a gc=
c
              built-in function.  It atomically performs the equivalent=
 of:

                  if (*ptr =3D=3D oldval)
                      *ptr =3D newval;

              It returns true if the test yielded true and *ptr was upd=
ated.
              The alternative here would be to employ the equivalent at=
omic
              machine-language instructions.  For further information, =
see
              the GCC Manual. */

           while (1) {

               /* Is the futex available? */

               if (__sync_bool_compare_and_swap(futexp, 1, 0))
                   break;      /* Yes */

               /* Futex is not available; wait */

               s =3D futex(futexp, FUTEX_WAIT, 0, NULL, NULL, 0);
               if (s =3D=3D -1 && errno !=3D EAGAIN)
                   errExit("futex-FUTEX_WAIT");
           }
       }

       /* Release the futex pointed to by 'futexp': if the futex curren=
tly
          has the value 0, set its value to 1 and the wake any futex wa=
iters,
          so that if the peer is blocked in fpost(), it can proceed. */

       static void
       fpost(int *futexp)
       {
           int s;

           /* __sync_bool_compare_and_swap() was described in comments =
above */

           if (__sync_bool_compare_and_swap(futexp, 0, 1)) {

               s =3D futex(futexp, FUTEX_WAKE, 1, NULL, NULL, 0);
               if (s  =3D=3D -1)
                   errExit("futex-FUTEX_WAKE");
           }
       }

       int
       main(int argc, char *argv[])
       {
           pid_t childPid;
           int j, nloops;

           setbuf(stdout, NULL);

           nloops =3D (argc > 1) ? atoi(argv[1]) : 5;

           /* Create a shared anonymous mapping that will hold the fute=
xes.
              Since the futexes are being shared between processes, we
              subsequently use the "shared" futex operations (i.e., not=
 the
              ones suffixed "_PRIVATE") */

           iaddr =3D mmap(NULL, sizeof(int) * 2, PROT_READ | PROT_WRITE=
,
                       MAP_ANONYMOUS | MAP_SHARED, -1, 0);
           if (iaddr =3D=3D MAP_FAILED)
               errExit("mmap");

           futex1 =3D &iaddr[0];
           futex2 =3D &iaddr[1];

           *futex1 =3D 0;        /* State: unavailable */
           *futex2 =3D 1;        /* State: available */

           /* Create a child process that inherits the shared anonymous
              mapping */

           childPid =3D fork();
           if (childPid =3D=3D -1)
               errExit("fork");

           if (childPid =3D=3D 0) {        /* Child */
               for (j =3D 0; j < nloops; j++) {
                   fwait(futex1);
                   printf("Child  (%ld) %d\n", (long) getpid(), j);
                   fpost(futex2);
               }

               exit(EXIT_SUCCESS);
           }

           /* Parent falls through to here */

           for (j =3D 0; j < nloops; j++) {
               fwait(futex2);
               printf("Parent (%ld) %d\n", (long) getpid(), j);
               fpost(futex1);
           }

           wait(NULL);

           exit(EXIT_SUCCESS);
       }

SEE ALSO
       get_robust_list(2), restart_syscall(2), futex(7)

       The following kernel source files:

       * Documentation/pi-futex.txt

       * Documentation/futex-requeue-pi.txt

       * Documentation/locking/rt-mutex.txt

       * Documentation/locking/rt-mutex-design.txt

       * Documentation/robust-futex-ABI.txt

       Franke, H., Russell, R., and Kirwood, M., 2002.  Fuss, Futexes
       and Furwocks: Fast Userlevel Locking in Linux (from proceedings
       of the Ottawa Linux Symposium 2002),
       =E2=9F=A8http://kernel.org/doc/ols/2002/ols2002-pages-479-495.pd=
f=E2=9F=A9

       Hart, D., 2009. A futex overview and update,
       =E2=9F=A8http://lwn.net/Articles/360699/=E2=9F=A9

       Hart, D. and Guniguntala, D., 2009.  Requeue-PI: Making Glibc
       Condvars PI-Aware (from proceedings of the 2009 Real-Time Linux
       Workshop),
       =E2=9F=A8http://lwn.net/images/conf/rtlws11/papers/proc/p10.pdf=E2=
=9F=A9

       Drepper, U., 2011. Futexes Are Tricky,
       =E2=9F=A8http://www.akkadia.org/drepper/futex.pdf=E2=9F=A9

       Futex example library, futex-*.tar.bz2 at
       =E2=9F=A8ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/=E2=9F=
=A9

=2E\" FIXME Are there any other resources that should be listed
=2E\"       in the SEE ALSO section?

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
