From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 08/20] kthread: Allow to cancel kthread work
Date: Fri, 26 Feb 2016 16:38:18 +0100
Message-ID: <20160226153818.GI3305@pathway.suse.cz>
References: <1456153030-12400-9-git-send-email-pmladek@suse.com>
 <201602230025.uuCAc4Tn%fengguang.wu@intel.com>
 <20160224161805.GB3305@pathway.suse.cz>
 <20160225125932.GI6357@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160225125932.GI6357-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 2016-02-25 13:59:32, Peter Zijlstra wrote:
> On Wed, Feb 24, 2016 at 05:18:05PM +0100, Petr Mladek wrote:
> > @@ -770,7 +782,22 @@ void delayed_kthread_work_timer_fn(unsigned long __data)
> >  	if (WARN_ON_ONCE(!worker))
> >  		return;
> >  
> > -	spin_lock(&worker->lock);
> > +	/*
> > +	 * We might be unable to take the lock if someone is trying to
> > +	 * cancel this work and calls del_timer_sync() when this callback
> > +	 * has already been removed from the timer list.
> > +	 */
> > +	while (!spin_trylock(&worker->lock)) {
> > +		/*
> > +		 * Busy wait with spin_is_locked() to avoid cache bouncing.
> > +		 * Break when canceling is set to avoid a deadlock.
> > +		 */
> > +		do {
> > +			if (work->canceling)
> > +				return;
> > +			cpu_relax();
> > +		} while (spin_is_locked(&worker->lock));
> > +	}
> >  	/* Work must not be used with more workers, see queue_kthread_work(). */
> >  	WARN_ON_ONCE(work->worker != worker);
> >  
> 
> This is pretty vile; why can't you drop the lock over del_timer_sync() ?

We would need to take the lock later and check if nobody has set the timer
again in the meantime.

Now, timer_active() check is not reliable. It does not check if the
timer handler is running at the moment. I tried to implement
a safe timer_active()[1] but nobody was keen to take it.

Even if we have that timer_active() check, we would need to add
some relock/check/try_again stuff around the del_timer_sync().
So, it would just move the complexity somewhere else.

I think that the current solution is quite elegant after all.
Thanks a lot Tejun for the idea.

Reference:
[1] http://thread.gmane.org/gmane.linux.kernel.mm/144964/focus=144965


Thanks a lot for review,
Petr
