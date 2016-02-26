From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 04/20] kthread: Add drain_kthread_worker()
Date: Fri, 26 Feb 2016 16:23:09 +0100
Message-ID: <20160226152309.GH3305@pathway.suse.cz>
References: <1456153030-12400-1-git-send-email-pmladek@suse.com>
 <1456153030-12400-5-git-send-email-pmladek@suse.com>
 <20160225123551.GG6357@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160225123551.GG6357-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 2016-02-25 13:35:51, Peter Zijlstra wrote:
> On Mon, Feb 22, 2016 at 03:56:54PM +0100, Petr Mladek wrote:
> > +/**
> > + * drain_kthread_worker - drain a kthread worker
> > + * @worker: worker to be drained
> > + *
> > + * Wait until there is no work queued for the given kthread worker.
> > + * @worker is flushed repeatedly until it becomes empty.  The number
> > + * of flushing is determined by the depth of chaining and should
> > + * be relatively short.  Whine if it takes too long.
> > + *
> > + * The caller is responsible for blocking all users of this kthread
> > + * worker from queuing new works. Also it is responsible for blocking
> > + * the already queued works from an infinite re-queuing!
> > + */
> > +void drain_kthread_worker(struct kthread_worker *worker)
> > +{
> > +	int flush_cnt = 0;
> > +
> > +	spin_lock_irq(&worker->lock);
> 
> Would it not make sense to set a flag here that inhibits (or warns)
> queueing new work?
> 
> Otherwise this can, as you point out, last forever.
> 
> And I think its a logic fail if you both want to drain it and keeping
> adding new work.

We must allow self-queuing because it might be needed to finish
the processing. We would need to detect it. Tejun suggested
to avoid this and make the code simple.

I do not have a strong opinion here. On one hand, such a check might
help with debugging. On the other hand, workqueues have happily lived
without it for years.

Thanks a lot for review,
Petr
