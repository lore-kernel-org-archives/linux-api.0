From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 03/14] kthread: Add drain_kthread_worker()
Date: Wed, 29 Jul 2015 12:04:57 +0200
Message-ID: <20150729100457.GI2673@pathway.suse.cz>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-4-git-send-email-pmladek@suse.com>
 <20150728171822.GA5322@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728171822.GA5322-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-07-28 13:18:22, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 28, 2015 at 04:39:20PM +0200, Petr Mladek wrote:
> > +/*
> > + * Test whether @work is being queued from another work
> > + * executing on the same kthread.
> > + */
> > +static bool is_chained_work(struct kthread_worker *worker)
> > +{
> > +	struct kthread_worker *current_worker;
> > +
> > +	current_worker = current_kthread_worker();
> > +	/*
> > +	 * Return %true if I'm a kthread worker executing a work item on
> > +	 * the given @worker.
> > +	 */
> > +	return current_worker && current_worker == worker;
> > +}
> 
> I'm not sure full-on chained work detection is necessary here.
> kthread worker's usages tend to be significantly simpler and draining
> is only gonna be used for destruction.

I think that it might be useful to detect bugs when someone
depends on the worker when it is being destroyed. For example,
I tried to convert "khubd" kthread and there was not easy to
double check that this worked as expected.

I actually think about replacing

    WARN_ON_ONCE(!is_chained_work(worker)))

with

    WARN_ON(!is_chained_work(worker)))

in queue_kthread_work, so that we get the warning for all misused
workers.

> > +void drain_kthread_worker(struct kthread_worker *worker)
> > +{
> > +	int flush_cnt = 0;
> > +
> > +	spin_lock_irq(&worker->lock);
> > +	worker->nr_drainers++;
> > +
> > +	while (!list_empty(&worker->work_list)) {
> > +		/*
> > +		 * Unlock, so we could move forward. Note that queuing
> > +		 * is limited by @nr_drainers > 0.
> > +		 */
> > +		spin_unlock_irq(&worker->lock);
> > +
> > +		flush_kthread_worker(worker);
> > +
> > +		if (++flush_cnt == 10 ||
> > +		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
> > +			pr_warn("kthread worker %s: drain_kthread_worker() isn't complete after %u tries\n",
> > +				worker->task->comm, flush_cnt);
> > +
> > +		spin_lock_irq(&worker->lock);
> > +	}
> 
> I'd just do something like WARN_ONCE(flush_cnt++ > 10, "kthread worker: ...").

This would print the warning only for one broken worker. But I do not
have strong opinion about it.

Best Regards,
Petr
