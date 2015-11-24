From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/22] kthread: Allow to cancel kthread work
Date: Tue, 24 Nov 2015 11:21:43 +0100
Message-ID: <20151124102143.GG10750@pathway.suse.cz>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-10-git-send-email-pmladek@suse.com>
 <20151123225823.GI19072@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151123225823.GI19072@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-23 17:58:23, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 18, 2015 at 02:25:14PM +0100, Petr Mladek wrote:
> > +static int
> > +try_to_cancel_kthread_work(struct kthread_work *work,
> > +				   spinlock_t *lock,
> > +				   unsigned long *flags)
> > +{
> > +	int ret = 0;
> > +
> > +	if (work->timer) {
> > +		/* Try to cancel the timer if pending. */
> > +		if (del_timer(work->timer)) {
> > +			ret = 1;
> > +			goto out;
> > +		}
> > +
> > +		/* Are we racing with the timer callback? */
> > +		if (timer_active(work->timer)) {
> > +			/* Bad luck, need to avoid a deadlock. */
> > +			spin_unlock_irqrestore(lock, *flags);
> > +			del_timer_sync(work->timer);
> > +			ret = -EAGAIN;
> > +			goto out;
> > +		}
> 
> As the timer side is already kinda trylocking anyway, can't the cancel
> path be made simpler?  Sth like
> 
> 	lock(worker);
> 	work->canceling = true;
> 	del_timer_sync(work->timer);
> 	unlock(worker);
> 
> And the timer can do (ignoring the multiple worker support, do we even
> need that?)
> 
> 	while (!trylock(worker)) {
> 		if (work->canceling)
> 			return;
> 		cpu_relax();
> 	}
> 	queue;
> 	unlock(worker);

Why did I not find out this myself ?:-)

Thanks for hint,
Petr

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
