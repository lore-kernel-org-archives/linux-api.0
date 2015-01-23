From: Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Fri, 23 Jan 2015 19:29:48 +0100
Message-ID: <1422037788.29655.0.camel@triegel.csb>
References: <537346E5.4050407@gmail.com>
	 <CF98E3EF.90564%dvhart@linux.intel.com>
	 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
	 <5373D0CA.2050204@redhat.com>
	 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
	 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
	 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
	 <54B7D87C.3090901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B7D87C.3090901-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-01-15 at 16:10 +0100, Michael Kerrisk (man-pages) wrote:
> [Adding a few people to CC that have expressed interest in the 
> progress of the updates of this page, or who may be able to
> provide review feedback. Eventually, you'll all get CCed on
> the new draft of the page.]
> 
> Hello Thomas,
> 
> On 05/15/2014 04:14 PM, Thomas Gleixner wrote:
> > On Thu, 15 May 2014, Michael Kerrisk (man-pages) wrote:
> >> And that universe would love to have your documentation of 
> >> FUTEX_WAKE_BITSET and FUTEX_WAIT_BITSET ;-),
> > 
> > I give you almost the full treatment, but I leave REQUEUE_PI to
> > Darren and FUTEX_WAKE_OP to Jakub. :)
> 
> Thank you for the great effort you put into compiling the
> text below, and apologies for my long delay in following up.
> 
> I've integrated almost all of your suggestions into the 
> manual page. I will shortly send out a new draft of the
> page that contains various FIXMEs for points that remain 
> unclear.

Michael, thanks for working on the draft!  I'll review the draft closely
once you've sent it (or have I missed it?).

There are a few things that I'd like to see covered.

First, we should discuss that users, until they control all code in the
respective process, need to expect futexes to be affected by spurious
futex_wake calls; see https://lkml.org/lkml/2014/11/27/472 for
background and Linus' choice (AFAIU) to just document this.
So, for example, a return code of 0 for FUTEX_WAIT can mean either being
woken up by a FUTEX_WAKE intended for this futex, or a stale one
intended for another futex used by, for example, glibc internally.
(Note that as explained in this thread, this isn't just a glibc
artifact, but a result of the general futex design mixed with
destruction requirements for mutexes and other constructs in C++11 and
POSIX.)
It might also be necessary to further consider this when documenting the
errors, because it does affect how to handle them. See this for a glibc
perspective:
https://sourceware.org/ml/libc-alpha/2014-09/msg00381.html

Second, the current documentation for EINTR is that it can happen due to
receiving a signal *or* due to a spurious wake-up.  This is difficult to
handle when implementing POSIX semaphores, because they require that
EINTR is returned from SEM_WAIT if and only if the interruption was due
to a signal.  Thus, if FUTEX_WAIT returns EINTR, the semaphore
implementation can't return EINTR from sem_wait; see this for more
comments, including some discussion why use cases relying on the POSIX
requirement around EINTR are borderline timing-dependent:
https://sourceware.org/git/?p=glibc.git;a=blob;f=nptl/sem_waitcommon.c;h=96848d7ac5b6f8f1f3099b422deacc09323c796a;hb=HEAD#l282
Others have commented that aio_suspend has a similar issue; if EINTR
wouldn't in fact be returned spuriously, the POSIX-implementation-side
would get easier.

Third, I think it would be useful to -- somewhere -- explain which
behavior the futex operations would have conceptually when expressed by
C11 code.  We currently say that they wake up, sleep, etc, and which
values they return.  But we never say how to properly synchronize with
them on the userspace side.  The C11 memory model is probably the best
model to use on the userspace side, so that's why I'm arguing for this.
Basically, I think we need to (1) tell people that they should use
memory_order_relaxed accesses to the futex variable (ie, the memory
location associated with the whole futex construct on the kernel side --
or do we have another name for this?), and (2) give some conceptual
guarantees for the kernel-side synchronization so that one use this to
derive how to use them correctly in userspace.

The man pages might not be the right place for this, and maybe we just
need a revision of "Futexes are tricky".  If you have other suggestions
for where to document this, or on the content, let me know.  (I'm also
willing to spend time on this :) ).


Torvald




--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
