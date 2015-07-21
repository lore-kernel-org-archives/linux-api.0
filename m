From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Tue, 21 Jul 2015 13:36:23 -0700
Message-ID: <20150721203622.GX3717@linux.vnet.ibm.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
 <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com>
 <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 12:26:17PM -0700, Andy Lutomirski wrote:
> On Tue, Jul 21, 2015 at 12:10 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> > Sorry for the delay in responding; some other priorities came up internally.
> >
> > On 07/13/2015 05:45 PM, Andy Lutomirski wrote:
> >>
> >> On Mon, Jul 13, 2015 at 2:01 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
> >> wrote:
> >>>
> >>> On 07/13/2015 04:40 PM, Andy Lutomirski wrote:
> >>>>
> >>>> On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
> >>>>
> >>>> wrote:
> >>>>>
> >>>>> The existing nohz_full mode makes tradeoffs to minimize userspace
> >>>>> interruptions while still attempting to avoid overheads in the
> >>>>> kernel entry/exit path, to provide 100% kernel semantics, etc.
> >>>>>
> >>>>> However, some applications require a stronger commitment from the
> >>>>> kernel to avoid interruptions, in particular userspace device
> >>>>> driver style applications, such as high-speed networking code.
> >>>>>
> >>>>> This change introduces a framework to allow applications to elect
> >>>>> to have the stronger semantics as needed, specifying
> >>>>> prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
> >>>>> Subsequent commits will add additional flags and additional
> >>>>> semantics.
> >>>>
> >>>> I thought the general consensus was that this should be the default
> >>>> behavior and that any associated bugs should be fixed.
> >>>
> >>>
> >>> I think it comes down to dividing the set of use cases in two:
> >>>
> >>> - "Regular" nohz_full, as used to improve performance and limit
> >>>    interruptions, possibly for power benefits, etc.  But, stray
> >>>    interrupts are not particularly bad, and you don't want to take
> >>>    extreme measures to avoid them.
> >>>
> >>> - What I'm calling "cpu_isolated" mode where when you return to
> >>>    userspace, you expect that by God, the kernel doesn't interrupt you
> >>>    again, and if it does, it's a flat-out bug.
> >>>
> >>> There are a few things that cpu_isolated mode currently does to
> >>> accomplish its goals that are pretty heavy-weight:
> >>>
> >>> Processes are held in kernel space until ticks are quiesced; this is
> >>> not necessarily what every nohz_full task wants.  If a task makes a
> >>> kernel call, there may well be arbitrary timer fallout, and having a
> >>> way to select whether or not you are willing to take a timer tick after
> >>> return to userspace is pretty important.
> >>
> >> Then shouldn't deferred work be done immediately in nohz_full mode
> >> regardless?  What is this delayed work that's being done?
> >
> > I'm thinking of things like needing to wait for an RCU quiesce
> > period to complete.
> 
> rcu_nocbs does this, right?

CONFIG_RCU_NOCB_CPUS offloads the RCU callbacks to a kthread, which
allows the nohz CPU to turn off its scheduling-clock tick more frequently.
Chris might have some other reason to wait for an RCU grace period, given
that waiting for an RCU grace period would not guarantee no callbacks.
Some more might have arrived in the meantime, and there can be some delay
between the end of the grace period and the invocation of the callbacks.

> > In the current version, there's also the vmstat_update() that
> > may schedule delayed work and interrupt the core again
> > shortly before realizing that there are no more counter updates
> > happening, at which point it quiesces.  Currently we handle
> > this in cpu_isolated mode simply by spinning and waiting for
> > the timer interrupts to complete.
> 
> Perhaps we should fix that?

Didn't Christoph Lameter fix this?  Or is this an additional problem?

							Thanx, Paul

> >>> Likewise, there are things that you may want to do on return to
> >>> userspace that are designed to prevent further interruptions in
> >>> cpu_isolated mode, even at a possible future performance cost if and
> >>> when you return to the kernel, such as flushing the per-cpu free page
> >>> list so that you won't be interrupted by an IPI to flush it later.
> >>
> >> Why not just kick the per-cpu free page over to whatever cpu is
> >> monitoring your RCU state, etc?  That should be very quick.
> >
> >
> > So just for the sake of precision, the thing I'm talking about
> > is the lru_add_drain() call on kernel exit.  Are you proposing
> > that we call that for every nohz_full core on kernel exit?
> > I'm not opposed to this, but I don't know if other nohz
> > developers feel like this is the right tradeoff.
> 
> I'm proposing either that we do that or that we arrange for other cpus
> to be able to steal our LRU list while we're in RCU user/idle.
> 
> >> Let's fix them instead of adding new ABIs to work around them.
> >
> >
> > Well, in principle if we accepted my proposed patch series
> > and then over time came to decide that it was reasonable
> > for nohz_full to have these complete cpu isolation
> > semantics, the one proposed ABI simply becomes a no-op.
> > So it's not as problematic an ABI as some.
> 
> What if we made it a debugfs thing instead of a prctl?  Have a mode
> where the system tries really hard to quiesce itself even at the cost
> of performance.
> 
> >
> > My issue is this: I'm totally happy with submitting a revised
> > patch series that does all the stuff for pure nohz_full that
> > I'm currently proposing for cpu_isolated.  But, is it what
> > the community wants?  Should I propose it and see?
> >
> > Frederic, do you have any insight here?  Thanks!
> >
> > --
> > Chris Metcalf, EZChip Semiconductor
> > http://www.ezchip.com
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-api" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> 
