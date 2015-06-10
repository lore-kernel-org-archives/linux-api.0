From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 06/18] signal/kthread: Initial implementation of
 kthread signal handling
Date: Wed, 10 Jun 2015 12:13:21 +0900
Message-ID: <20150610031321.GF11955@mtj.duckdns.org>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-7-git-send-email-pmladek@suse.cz>
 <20150609071022.GX21465@mtj.duckdns.org>
 <alpine.LNX.2.00.1506091405360.12753@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1506091405360.12753-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Jiri.

On Tue, Jun 09, 2015 at 02:15:24PM +0200, Jiri Kosina wrote:
> To me, the ultimate goal (*) is to make it possible for kthread to be able 
> to decide whether it wants "some kind of default behavior" (however that'd 
> be defined), or "ignore all", or "just handle this set of signals with 
> these handlers", and make API for this that would avoid every kthread 
> implementing its own complete signal handling.

Yes, cleaning up the current usages like above would be great but one
concern is that the above might inadvertantly encourage usage of
signals in kthreads which I don't think is a good idea.  It'd be great
if we can consolidate the current users while also making it clear
that we shouldn't be adding new ones.

> > While we do have several kthread signal users, they aren't too many and 
> > majority of them use it to allow userland to tell it to shutdown and 
> 
> Yeah. Via SIGKILL. Or SIGTERM. Or SIGINT. Or SIGQUIT. Not really 
> consistent either.

Exactly, and it's pretty confusing from userland.  Why do some
kthreads take SIGTERM but not SIGKILL while others do the other way
and yet others ignore them all?  This is too low level for a userland
visible interface which is tied too closely to the implementation
detail (usage of one kthread) and often unclear in terms of the
meaning of the action.

> > there seem to be a couple which use HUP/USR1 to cancel whatever it's 
> > processing / waiting on at the moment.  Hmmm... jffs uses STOP/CONT too.
> 
> > I don't know how this should be done but let's please try to
> > 
> > 1. Encourage uniform behaviors across the signals.
> 
> Fully agreed.
> 
> > 2. Ultimately discourage usage of signals on kthreads as this closely
> >    ties implementation detail (use of single kthread) to the userland
> >    visible interface in a way where we can't easily get back out of.
> >    For example, what if jffs needs its gc workers to be multi-threaded
> >    and per-NUMA for high-iops devices later on?
> 
> What kind of multi-threading kthreads are you referring to here? Something 
> more sophisticated than simply spawning several per-CPU (or 
> per-whatever-resource) full-fledged kthreads?

Becoming simple multi-threaded or per-cpu are good examples but these
things not too rarely develop into something which needs more
sophiscation.  e.g. jobs which process considerable amount data are
usually best served by NUMA-node-affine workers roughly matching the
number of CPUs in each node.  workqueue is half way there but still
lacking an automatic way to regulate concurrency in those cases.

For certain use cases, you really can't avoid employing a pool of
workers and once things get there, having tied userland interface to a
single kthread becomes pretty awkward.  It sure works for certain use
cases and sending signals to kthreads *might* be considered a "softer"
interface where userland is meddling with kernel implementation
details that it can be changed later on but it can still be painful
for users depending on it.

Thanks.

-- 
tejun
