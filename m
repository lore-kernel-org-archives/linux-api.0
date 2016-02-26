From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 08/20] kthread: Allow to cancel kthread work
Date: Fri, 26 Feb 2016 18:00:56 +0100
Message-ID: <20160226170056.GA12548@pathway.suse.cz>
References: <1456153030-12400-9-git-send-email-pmladek@suse.com>
 <201602230025.uuCAc4Tn%fengguang.wu@intel.com>
 <20160224161805.GB3305@pathway.suse.cz>
 <20160225125932.GI6357@twins.programming.kicks-ass.net>
 <20160226153818.GI3305@pathway.suse.cz>
 <20160226162552.GB6356@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160226162552.GB6356-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 2016-02-26 17:25:52, Peter Zijlstra wrote:
> On Fri, Feb 26, 2016 at 04:38:18PM +0100, Petr Mladek wrote:
> > On Thu 2016-02-25 13:59:32, Peter Zijlstra wrote:
> > > On Wed, Feb 24, 2016 at 05:18:05PM +0100, Petr Mladek wrote:
> > > > @@ -770,7 +782,22 @@ void delayed_kthread_work_timer_fn(unsigned long __data)
> > > >  	if (WARN_ON_ONCE(!worker))
> > > >  		return;
> > > >  
> > > > -	spin_lock(&worker->lock);
> > > > +	/*
> > > > +	 * We might be unable to take the lock if someone is trying to
> > > > +	 * cancel this work and calls del_timer_sync() when this callback
> > > > +	 * has already been removed from the timer list.
> > > > +	 */
> > > > +	while (!spin_trylock(&worker->lock)) {
> > > > +		/*
> > > > +		 * Busy wait with spin_is_locked() to avoid cache bouncing.
> > > > +		 * Break when canceling is set to avoid a deadlock.
> > > > +		 */
> > > > +		do {
> > > > +			if (work->canceling)
> > > > +				return;
> > > > +			cpu_relax();
> > > > +		} while (spin_is_locked(&worker->lock));
> > > > +	}
> > > >  	/* Work must not be used with more workers, see queue_kthread_work(). */
> > > >  	WARN_ON_ONCE(work->worker != worker);
> > > >  
> > > 
> > > This is pretty vile; why can't you drop the lock over del_timer_sync() ?
> > 
> > We would need to take the lock later and check if nobody has set the timer
> > again in the meantime.
> 
> Well, if ->cancelling is !0, nobody should be re-queueing, re-arming
> timers etc.., right?

Which rings a bell. __cancel_kthread_work()/del_timer_sync() is used
also from mod_timer_sync() and we do not increment ->canceling there.
See the 9th patch. It is racy and I have to fix it.


> And since you do add_timer() while holding the spinlock, this should all
> work out, no?

Interesting idea. Yes, it should work. But is this really easier? The
try_again/relock/recheck code is not trivial either.

I personally slightly more prefer the current code. I am open
to use your version ff you persist on it. But I also do not want
to end up in a ping-pong re-implementation as Tejun king of suggested
the current code.


Thanks a lot,
Petr
