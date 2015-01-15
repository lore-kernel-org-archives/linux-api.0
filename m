From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 Jan 2015 23:23:42 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1501152313330.5526@nanos>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <54B7D87C.3090901@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B7D87C.3090901-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
> > [EINVAL] uaddr equal uaddr2. Requeue to same futex.
> 
> ??? I added this, but does this error not occur only for PI requeues?

It's equally wrong for normal futexes. And its actually the same code
checking for this for all variants.

> > [EDEADLOCK] The futex is already locked by the caller or the kernel 
> > detected a deadlock scenario in a nested lock chain
>
> Added.

It's actually EDEADLK

> 
> > [EOWNERDIED] The owner of the futex died and the kernel made the 
> > caller the new owner. The kernel sets the FUTEX_OWNER_DIED bit in the
> > futex userspace value. Caller is responsible for cleanup
> 
> There is no such thing as an EOWNERDIED error. I had a look
> through the kernel source for the FUTEX_OWNER_DIED cases and didn't 
> see an obvious error associated with them. Can you clarify? (I think 
> the point is that this condition, which is described in
> Documentation/robust-futexes.txt, is not an error as such. However, I'm
> not yet sure of how to describe it in the man page.)
> I will add this point as a FIXME in the new draft man page.

Oops. My bad. That's not the what the kernel does. The kernel merily
marks it in the futex itself with FUTEX_OWNER_DIED. User space needs
to deal with that and the posix users return EOWNERDEAD (not
EOWNERDIED], so it's not part of the futex call itself.

We had discussions about returning EOWNERDEAD in that case, but then
glibc with its sophisticated error handling prevented that ....
 
> > FUTEX_TRYLOCK_PI
> > 
> > This operation tries to acquire the futex at uaddr. It deals with the
> > situation where the TID value at uaddr is 0, but the FUTEX_HAS_WAITER
> > bit is set. User space cannot handle this race free.
> 
> Added.
> 
> > The arguments uaddr2, val, timeout and val3 are ignored.
> 
> ??? But the code reads:
> 
>         case FUTEX_TRYLOCK_PI:
>                 return futex_lock_pi(uaddr, flags, 0, timeout, 1);
>  
> which momentarily misleads one into thinking that 'timeout' is used.
> And: it's not quite ignored, since in futex_lock_pi() a non-NULL
> 'timeout' is unconditionally dereferenced (meaning you could get
> an EFAULT error for a bad 'timeout' pointer).
> I'm confused....

Indeed. That's just wrong.
 
> Maybe the above code should be
> 
>         case FUTEX_TRYLOCK_PI:
>                 return futex_lock_pi(uaddr, flags, 0, NULL, 1);
> ?

Care to send a patch?
 
> > FUTEX_WAIT_REQUEUE_PI
> > 
> > Wait operation to wait on a non pi futex at uaddr and potentially be
> > requeued on a pi futex at uaddr2. The wait operation on uaddr is the
> > same as FUTEX_WAIT. The waiter can be removed from the wait on uaddr
> > via FUTEX_WAKE without requeuing on uaddr2.
> 
> Added.
> 
> > The timeout argument is handled as described in FUTEX_WAIT.
> 
> The above seems not to be correct. I've written the discussion of
> 'timeout' up as I understand it, and added a FIXME to the draft page.
> 
> > Darren, can you fill in the missing details?
> 
> > Return values:
> > 
> > [EFAULT] Kernel was unable to access the futex value at uaddr or
> > uaddr2
> 
> Already covered.
> 
> > [EINVAL] The supplied uaddr or uaddr2 argument does not point to a
> > valid object, i.e. pointer is not 4 byte aligned
> 
> Already covered.
> 
> > [EINVAL] The supplied timeout argument is not normalized.
> 
> Already covered.
> 
> > [EINVAL] The supplied bitset is zero.
> 
> ??? I don't believe this can happen. 'val3' is internally set to
> FUTEX_BITSET_MATCH_ANY. Can you confirm?

Right. We dont support that bitset stuff in requeue_pi ATM.
 
Thanks,

	tglx
