From: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list
Date: Tue, 25 Nov 2008 17:23:20 -0500
Message-ID: <20081125222320.GA23612@tsunami.ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <alpine.LFD.2.00.0811252224430.3235@localhost.localdomain>
Reply-To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811252224430.3235-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2008 at 04:36:48PM -0500, Thomas Gleixner wrote:
> > --- 2.6.28-rc6.orig/kernel/timer.c    2008-11-25 11:59:07.000000000 -0500
> > +++ 2.6.28-rc6/kernel/timer.c 2008-11-25 13:49:05.000000000 -0500
> > +#if defined(CONFIG_PROC_FS) || defined(CONFIG_MAGIC_SYSRQ)
> 
> This belongs into kernel/time/timer_list.c and there is no need to
> copy that code around.

Everything to do with jiffy timer implementation is static
local to kernel/timer.c, and not available to code in
kernel/time/timer_list.c or anywhere else.  I consider that
localization to be a rather nice feature of kernel/timer.c,
and I wasn't willing to globalize it just for a debug
data dump.

Also, other features implement their 'show' functions
elsewhere, for example, show_interrupts.  So doing the
same thing here is certainly not out of line.


> > +void print_cpu_jtimers(struct seq_file *m, int cpu)
> > +{
> > +     int i;
> > +     struct tvec_base *base = per_cpu(tvec_bases, cpu);
> > +
> > +     SEQ_printf(m, "active jiffie timers:\n");
> > +     spin_lock_irq(&base->lock);
> 
> Yuck. We really do _NOT_ stop everything just to print timers. Check
> the hrtimer print code in timer_list.c

I'm not sure there is a safe way to reference the timers without
holding the lock.  But I will look into this and see what can
be done.



> >
> > @@ -139,6 +140,7 @@
> >               SEQ_printf(m, " clock %d:\n", i);
> >               print_base(m, cpu_base->clock_base + i, now);
> >       }
> > +
> 
> random whitespace change

Will fix.


> >               P_ns(idle_expires);
> > -             SEQ_printf(m, "jiffies: %Lu\n",
> > +             SEQ_printf(m, "jiffies: %llu (0x%llx)\n",
> > +                        (unsigned long long)jiffies,
> >                          (unsigned long long)jiffies);
> 
> The exact purpose of this change ?

In the 'active jiffie timer' section I print timer_jiffies
etc in hex format.  It's probably just me, but I found that
to be easier to read than the rather longer decimal format.
So this change was to get a hex version of the global jiffies
out, for easy comparison to values appearing in that section.

Certainly everything can be changed to decimal, if that is
the consensus.

> > -     pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
> > +     pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
> >       if (!pe)
> >               return -ENOMEM;
> >       return 0;
> 
> Correct, but unrelated $subject. Separate patch please.

Will do.

Thanks for the review,
Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
