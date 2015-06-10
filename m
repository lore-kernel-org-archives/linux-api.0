From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 00/18] kthreads/signal: Safer kthread API and signal
 handling
Date: Wed, 10 Jun 2015 12:40:57 +0200
Message-ID: <20150610104057.GE3644@twins.programming.kicks-ass.net>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <20150605162216.GK19282@twins.programming.kicks-ass.net>
 <20150609061446.GV21465@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150609061446.GV21465-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 09, 2015 at 03:14:46PM +0900, Tejun Heo wrote:
> Hey, Peter.
> 
> On Fri, Jun 05, 2015 at 06:22:16PM +0200, Peter Zijlstra wrote:
> > There's a lot more problems with workqueues:
> > 
> >  - they're not regular tasks and all the task controls don't work on
> >    them. This means all things scheduler, like cpu-affinity, nice, and
> >    RT/deadline scheduling policies. Instead there is some half baked
> >    secondary interface for some of these.
> 
> Because there's a pool of them and the workers come and go
> dynamically.  There's no way around it.  The attributes just have to
> be per-pool.

Sure, but there's a few possible ways to still make that work with the
regular syscall interfaces.

 1) propagate the change to any one worker to all workers of the same
    pool

 2) have a common ancestor task for each pool, and allow changing that.
    You can combine that with either the propagation like above, or a
    rule that workers kill themselves if they observe their parent
    changed (eg. check a attribute sequence count after each work).

> >    But this also very much includes things like cgroups, which brings me
> >    to the second point.
> >
> >  - its oblivious to cgroups (as it is to RT priority for example) both
> >    leading to priority inversion. A work enqueued from a deep/limited
> >    cgroup does not inherit the task's cgroup. Instead this work is ran
> >    from the root cgroup.
> > 
> >    This breaks cgroup isolation, more significantly so when a large part
> >    of the actual work is done from workqueues (as some workloads end up
> >    being). Instead of being able to control the work, it all ends up in
> >    the root cgroup outside of control.
> 
> cgroup support will surely be added but I'm not sure we can or should
> do inheritance automatically.  

I think its a good default to inherit stuff from the task that queued
it.

> Using a different API doesn't solve the
> problem automatically either.  A lot of kthreads are shared
> system-wide after all.  We'll need an abstraction layer to deal with
> that no matter where we do it.

Yes, hardware threads are global, but so is the hardware. Those are not
a problem provided the thread map 1:1 with the actual devices and do not
service multiple devices from a single thread.

Once you start combining things you start to get all the above problems
all over again.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
