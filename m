From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Thu, 20 Aug 2015 01:17:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1508200042180.3873@nanos>
References: <55B61EF3.7080302@gmail.com> <alpine.DEB.2.11.1507282054370.3825@nanos> <55C5A787.9010806@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-185193515-1440026224=:3873"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C5A787.9010806-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-185193515-1440026224=:3873
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 8 Aug 2015, Michael Kerrisk (man-pages) wrote:
> >>        FUTEX_CMP_REQUEUE (since Linux 2.6.7)
> >>               This  operation  first  checks  whether the location uaddr
> >>               still contains the value  val3.   If  not,  the  operation
> >>               fails  with  the  error  EAGAIN.  Otherwise, the operation
> >>               wakes up a maximum of val waiters that are waiting on  the
> >>               futex  at uaddr.  If there are more than val waiters, then
> >>               the remaining waiters are removed from the wait  queue  of
> >>               the  source  futex at uaddr and added to the wait queue of
> >>               the target futex at uaddr2.  The val2  argument  specifies
> >>               an  upper limit on the number of waiters that are requeued
> >>               to the futex at uaddr2.
> >>
> >> .\" FIXME(Torvald) Is the following correct?  Or is just the decision
> >> .\" which threads to wake or requeue part of the atomic operation?
> >>
> >>               The load from uaddr is  an  atomic  memory  access  (i.e.,
> >>               using atomic machine instructions of the respective archi‐
> >>               tecture).  This load, the comparison with  val3,  and  the
> >>               requeueing  of  any  waiters  are performed atomically and
> >>               totally ordered with respect to other  operations  on  the
> >>               same futex word.
> > 
> > It's atomic as the other atomic operations on the futex word. It's
> > always performed with the proper lock(s) held in the kernel. That
> > means any concurrent operation will serialize on that lock(s). User
> > space has to make sure, that depending on the observed value no
> > concurrent operations happen, but that's something the kernel cannot
> > control.
> 
> ???
> Sorry, I'm not clear here. Is the current text correct then? Or is some
> change needed.

I think we need some change here because the meaning of atomic is
unclear. The basic rules of futexes are:

 - All modifying operations on the futex value have to be done with
   atomic instructions, usually cmpxchg. That applies to both kernel
   and user space.

   That's the atomicity at the futex value level.

 - In the kernel we have to create/modify/destroy state in order to
   provide the blocking/requeueing etc.

   This state needs protection as well. So all operations related to
   the kernel internal state are serialized on the hash bucket
   locks. The hash buckets are a scalability mechanism to avoid
   contention on a single lock protecting all kernel internal
   state. For simplicity reasons you can just think of a global lock
   protecting all kernel internal state.

   If the kernel creates/modifies state then it can be necessary to
   either reread the futex value or modify it. That happens under the
   locks as well.

   So in the case of requeue, we take the proper locks and perform the
   comparison with val3 and the requeueing with the locks held.
   
   So that lock protection makes these operations 'atomic'. The
   correct expression is 'serialized'.
 
> >> .\" FIXME We need some explanation in the following paragraph of *why*
> >> .\"       it is important to note that "the kernel will update the
> >> .\"       futex word's value prior
> >>        It is important to note to returning to user space" . Can someone
> >>        explain?   that  the  kernel  will  update the futex word's value
> >>        prior to returning to user space.  Unlike the other futex  opera‐
> >>        tions  described  above, the PI futex operations are designed for
> >>        the implementation of very specific IPC mechanisms.
> > 
> > If there are multiple waiters on a pi futex then a wake pi operation
> > will wake the first waiter and hand over the lock to this waiter. This
> > includes handing over the rtmutex which represents the futex in the
> > kernel. The strict requirement is that the futex owner and the rtmutex
> > owner must be the same, except for the update period which is
> > serialized by the futex internal locking. That means the kernel must
> > update the user space value prior to returning to user space.

And as noted above: It must update while holding the proper locks.

> >> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren Hart
> >> .\"       made the observation that "EINVAL is returned if the non-pi 
> >> .\"       to pi or op pairing semantics are violated."
> >> .\"       Probably there needs to be a general statement about this
> >> .\"       requirement, probably located at about this point in the page.
> >> .\"       Darren (or someone else), care to take a shot at this?
> > 
> > Well, that's hard to describe because the kernel only has a limited
> > way of detecting such mismatches. It only can detect it when there are
> > non PI waiters on a futex and a PI function is called or vice versa.
> 
> Hmmm. Okay, I filed your comments away for reference, but
> hopefully someone can help with some actual text.

I let Darren come up with something sensible :)
 
> >> .\" FIXME Somewhere on this page (I guess under the discussion of PI
> >> .\"       futexes) we need a discussion of the FUTEX_OWNER_DIED bit.
> >> .\"       Can someone propose a text?
> > 
> > If a futex has a rtmutex associated in the kernel, i.e. when there are
> > blocked waiters, and the owner of the futex/rtmutex dies unexpectedly,
> > then the kernel cleans up the rtmutex (as it holds a reference to the
> > dying task) and hands it over to the next waiter. That requires that
> > the user space value is updated accordingly. The kernel sets the
> > FUTEX_OWNER_DIED in the user space value along with the TID of the new
> > owner. User space is responsible for cleaning this up, though there
> > are cases where the kernel does the cleanup.
> >  
> > The FUTEX_OWNER_DIED bit can also be set on uncontended futexes, where
> > the kernel has no state associated. This happens via the robust futex
> > mechanism. In that case the futex value will be set to
> > FUTEX_OWNER_DIED. The robust futex mechanism is also available for non
> > PI futexes.
> 
> ???
> So, I added part of that text to the page, as follows:
> 
>        If  a futex has an associated RT-mutex in the kernel (i.e., there
>        are blocked waiters) and the owner  of  the  futex/RT-mutex  dies
>        unexpectedly, then the kernel cleans up the RT-mutex and hands it
>        over to the next waiter.  This in turn requires  that  the  user-
>        space  value  is  updated  accordingly.  To indicate that this is
>        required, the kernel sets the FUTEX_OWNER_DIED bit in  the  futex
>        word  along  with  the thread ID of the new owner.  User space is
>        then responsible for cleaning this up  (though  there  are  cases
>        where the kernel does the cleanup).
> 
> Okay?
> 
> I think the last sentence still requires a little work though. What does
> user space need to do in terms of clean up?

User space has usually state as well. So the FUTEX_OWNER_DIED bit
tells userspace that it needs to cleanup the stale state left over by
the dead owner.
 
> >> .\" FIXME In the next line, what type of "priority" are we talking about?
> >> .\"       Realtime priorities for SCHED_FIFO and SCHED_RR?
> >> .\"       Or something else?
> >>
> >>               The
> >>               enqueueing  of  the waiter is in descending priority order
> >>               if more than one waiter exists.  
> > 
> > That also covers sched deadline.
> 
> ???
> Thanks. If the realm is restricted purely to SCHED_OTHER (SCHED_NORMAL)
> processes, does the nice value come into play also?

No. SCHED_OTHER/NORMAL tasks are handled in FIFO order.
 
> So by now, I've reworked this text to be:
> 
>        FUTEX_TRYLOCK_PI (since Linux 2.6.18)
>               This operation tries to acquire the futex at uaddr.  It is
>               invoked when a user-space atomic acquire did  not  succeed
>               because the futex word was not 0.
> 
>               The trylock in kernel might succeed because the futex word
>               contains     stale     state     (FUTEX_WAITERS     and/or
>               FUTEX_OWNER_DIED).   This can happen when the owner of the
>               futex died.  User space cannot handle this condition in  a
>               race-free manner
> 
> Okay?
> 
> I must admit that I find "the trylock in kernel might succeed"hard
> to understand. Could you elaborate a little?

If the user space value has stale state, then the kernel can fix that
up and acquire the futex.
 
> ???
> So now I've reworded the opening text describing FUTEX_WAIT_REQUEUE_PI
> as follows:
> 
>        FUTEX_WAIT_REQUEUE_PI (since Linux 2.6.31)
>               Wait on  a  non-PI  futex  at  uaddr  and  potentially  be
>               requeued  (via a FUTEX_CMP_REQUEUE_PI operation in another
>               task) onto a PI futex at uaddr2.  The  wait  operation  on
>               uaddr is the same as for FUTEX_WAIT.
> 
>               The  waiter  can be removed from the wait on uaddr without
>               requeueing on uaddr2 via a FUTEX_WAIT operation in another

s/FUTEX_WAIT/FUTEX_WAKE/

>               task.   In  this case, the FUTEX_WAIT_REQUEUE_PI operation
>               returns with the error EWOULDBLOCK.
> 
> Okay?

Yes.

Thanks,

	tglx
--8323329-185193515-1440026224=:3873--
