From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v4 09/22] kthread: Allow to cancel kthread work
Date: Fri, 19 Feb 2016 17:22:39 +0100
Message-ID: <20160219162239.GT3305@pathway.suse.cz>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-10-git-send-email-pmladek@suse.com>
 <20160125191709.GE3628@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160125191709.GE3628@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2016-01-25 14:17:09, Tejun Heo wrote:
> On Mon, Jan 25, 2016 at 04:44:58PM +0100, Petr Mladek wrote:
> > +static bool __cancel_kthread_work_sync(struct kthread_work *work)
[...]
 > > +	work->canceling++;
> > +	ret = try_to_cancel_kthread_work(work, &worker->lock, &flags);
> > +
> > +	if (worker->current_work != work)
> > +		goto out_fast;
> 
> If there are two racing cancellers, wouldn't this allow the losing one
> to return while the work item is still running?

If the work is running, worker->current_work must point to it.
All cancelers will see it and queue its own kthread_flush_work.
It is a bit sub-optimal but it is trivial. I doubt that there
will be many parallel cancelers in practice.

> > +	spin_unlock_irqrestore(&worker->lock, flags);
> > +	flush_kthread_work(work);
> > +	/*
> > +	 * Nobody is allowed to switch the worker or queue the work
> > +	 * when .canceling is set.
> > +	 */
> > +	spin_lock_irqsave(&worker->lock, flags);
> > +
> > +out_fast:
> > +	work->canceling--;
> > +	spin_unlock_irqrestore(&worker->lock, flags);
> > +out:
> > +	return ret;

Best Regards,
Petr

PS: I have updated the patchset according to your other comments.
In addition, I got rid of many try_lock games. We do not allow
to queue the same work to different workers. Therefore it should
be enough to warn if the worker changes unexpectedly. It makes
the code even more simple. I still need to do some testing.
I will send it next week, hopefully.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
