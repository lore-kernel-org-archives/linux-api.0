From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Sat, 24 Jan 2015 12:35:01 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1501241116160.5526@nanos>
References: <537346E5.4050407@gmail.com>  <CF98E3EF.90564%dvhart@linux.intel.com>  <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>  <5373D0CA.2050204@redhat.com>  <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>  <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>  <54B7D87C.3090901@gmail.com> <1422037788.29655.0.camel@triegel.csb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422037788.29655.0.camel-I2ZjUw8blINjztcc/or7kQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Petr Baudis <pasky-AlSwsSmVLrQ@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 23 Jan 2015, Torvald Riegel wrote:
> Second, the current documentation for EINTR is that it can happen due to
> receiving a signal *or* due to a spurious wake-up.  This is difficult to

I don't think so. I went through all callchains again with a fine comb.

futex_wait()
retry:
	ret = futex_wait_setup();
	if (ret) {
		 /*
		  * Possible return codes related to uaddr:
		  * -EINVAL:    Not u32 aligned uaddr
		  * -EFAULT:    No mapping, no RW
		  * -ENOMEM:    Paging ran out of memory
		  * -EHWPOISON: Memory hardware error
		  *
		  * Others:
		  * -EWOULDBLOCK: value at uaddr has changed
		  */
		return ret;
	}

	futex_wait_queue_me();

	if (woken by futex_wake/requeue)
	   	return 0;

	if (timeout)
		return -ETIMEOUT;

	/*
	 * Spurious wakeup, i.e. no signal pending
	 */
	if (!signal_pending())
		goto retry;

	/* Handled in the low level syscall exit code */
	if (!timed_wait)
		return -ERESTARTSYS;
	else
		return -ERESTARTBLOCK;

Now in the low level syscall exit we try to deliver the signal

	if (!signal_delivered())
	      restart_syscall();

	if (sigaction->flags & SA_RESTART)
	      restart_syscall();

	ret_to_userspace -EINTR;

So we should never see -EINTR in the case of a spurious wakeup here.

But, here is the not so good news:

 I did some archaeology. The restart handling of futex_wait() got
 introduced in kernel 2.6.22, so anything older than that will have
 the spurious -EINTR issues.

futex_wait_pi() always had the restart handling and glibc folks back
then (2006) requested that it should never return -EINTR, so it
unconditionally restarts the syscall whether a signal had been
delivered or not.

So kernels >= 2.6.22 should never return -EINTR spuriously. If that
happens it's a bug and needs to be fixed.

> Third, I think it would be useful to -- somewhere -- explain which
> behavior the futex operations would have conceptually when expressed by
> C11 code.  We currently say that they wake up, sleep, etc, and which
> values they return.  But we never say how to properly synchronize with
> them on the userspace side.  The C11 memory model is probably the best
> model to use on the userspace side, so that's why I'm arguing for this.
> Basically, I think we need to (1) tell people that they should use
> memory_order_relaxed accesses to the futex variable (ie, the memory
> location associated with the whole futex construct on the kernel side --
> or do we have another name for this?), and (2) give some conceptual
> guarantees for the kernel-side synchronization so that one use this to
> derive how to use them correctly in userspace.
> 
> The man pages might not be the right place for this, and maybe we just
> need a revision of "Futexes are tricky".  If you have other suggestions
> for where to document this, or on the content, let me know.  (I'm also
> willing to spend time on this :) ).

The current futex code in the kernel has gained documentation about
the required memory ordering recently. That should be a good starting
point.

Thanks,

	tglx
