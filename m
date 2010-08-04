From: Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Date: Wed, 4 Aug 2010 18:46:38 +0300
Message-ID: <20100804154638.GB28519@shisha.kicks-ass.net>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
 <20100804153221.GA29109@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100804153221.GA29109@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: lkml@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 04, 2010 at 06:32:21 +0300, Kirill A. Shutemov wrote:
> On Wed, Aug 04, 2010 at 03:48:28PM +0300, Alexander Shishkin wrote:
> > Certain userspace applications (like "clock" desktop applets or ntpd) might
> > want to be notified when some other application changes the system time. It
> > might also be important for an application to be able to distinguish between
> > its own and somebody else's time changes.
> > 
> > This patch implements a notification interface via eventfd mechanism. Proccess
> > wishing to be notified about time changes should create an eventfd and echo
> > its file descriptor to /sys/kernel/time_notify. After that, any calls to
> > settimeofday()/stime()/adjtimex() made by other processes will be signalled
> > to this eventfd. Credits for suggesting the eventfd mechanism for this
> > purpose go te Kirill Shutemov.
> > 
> > So far, this implementation can only filter out notifications caused by
> > time change calls made by the process that wrote the eventfd descriptor to
> > sysfs, but not its children which (might) have inherited the eventfd. It
> > is so far not clear to me whether this is bad and more confusing than
> > excluding such children as well.
> 
> I think it's a bad idea to filter notifications. Let's leave it for

Why?

> userspace. Userspace always can check eventfd counter and understand who
> touch time based on its own activity.

That's another way to approach this, yes. But I can think of scenarios when
this will complicate userspace implementation. This generally means that the
"time monitor" application will have to increment some internal counter every
time it calls settimeofday() and friends. And when some library that it links
against starts calling one of those functions behind the scenes, it will
become trickier.

It is also true that you can never be too good to userspace.

> > Similar mechanism can also be used for signalling other (all?) system calls
> > made by certain (all?) processes without resorting to ptrace (which won't
> > help if you don't know what processes you'd like to look after), given
> > proper permission checks etc.
> > 
> > Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> > CC: Kirill A. Shutemov <kirill@shutemov.name>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: John Stultz <johnstul@us.ibm.com>
> > CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Jon Hunter <jon-hunter@ti.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > CC: David Howells <dhowells@redhat.com>
> > CC: Avi Kivity <avi@redhat.com>
> > CC: "H. Peter Anvin" <hpa@zytor.com>
> > CC: John Kacur <jkacur@redhat.com>
> > CC: Alexander Shishkin <virtuoso@slind.org>
> > CC: linux-kernel@vger.kernel.org
> > ---
> >  include/linux/time.h |    7 ++
> >  init/Kconfig         |    7 ++
> >  kernel/Makefile      |    1 +
> >  kernel/time.c        |   11 +++-
> >  kernel/time_notify.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 182 insertions(+), 2 deletions(-)
> >  create mode 100644 kernel/time_notify.c
> > 
> > diff --git a/include/linux/time.h b/include/linux/time.h
> > index ea3559f..9fca62b 100644
> > --- a/include/linux/time.h
> > +++ b/include/linux/time.h
> > @@ -237,6 +237,13 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
> >  	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
> >  	a->tv_nsec = ns;
> >  }
> > +
> > +#ifdef CONFIG_TIME_NOTIFY
> > +void time_notify_all(void);
> > +#else
> > +#define time_notify_all() do {} while (0)
> > +#endif
> > +
> >  #endif /* __KERNEL__ */
> >  
> >  #define NFDBITS			__NFDBITS
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 5cff9a9..f7271f8 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -976,6 +976,13 @@ config PERF_USE_VMALLOC
> >  	help
> >  	  See tools/perf/design.txt for details
> >  
> > +config TIME_NOTIFY
> > +	bool
> > +	depends on EVENTFD
> > +	help
> > +	  Enable time change notification events to userspace via
> > +	  eventfd.
> > +
> 
> Do we really need config option? I think better just use
> CONFIG_EVENTFD.

This is quite obscure. If anything, it's better to get rid of CONFIG_EVENTFD
and always unconditionally compile it in, while this functionality (time_notify)
may well be optional.

Regards,
--
Alex
