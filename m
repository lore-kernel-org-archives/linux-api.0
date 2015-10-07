From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v2 07/18] kthread: Allow to cancel kthread work
Date: Wed, 7 Oct 2015 11:21:30 +0200
Message-ID: <20151007092130.GD3122@pathway.suse.cz>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-8-git-send-email-pmladek@suse.com>
 <20150922193513.GE17659@mtj.duckdns.org>
 <20150925112617.GA3122@pathway.suse.cz>
 <20150928170314.GF2589@mtj.duckdns.org>
 <20151002154336.GC3122@pathway.suse.cz>
 <20151002192453.GA7564@mtj.duckdns.org>
 <20151005100758.GK9603@pathway.suse.cz>
 <20151005110924.GL9603@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151005110924.GL9603-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-10-05 13:09:24, Petr Mladek wrote:
> On Mon 2015-10-05 12:07:58, Petr Mladek wrote:
> > On Fri 2015-10-02 15:24:53, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Fri, Oct 02, 2015 at 05:43:36PM +0200, Petr Mladek wrote:
> > > > IMHO, we need both locks. The worker manipulates more works and
> > > > need its own lock. We need work-specific lock because the work
> > > > might be assigned to different workers and we need to be sure
> > > > that the operations are really serialized, e.g. queuing.
> > > 
> > > I don't think we need per-work lock.  Do we have such usage in kernel
> > > at all?  If you're worried, let the first queueing record the worker
> > > and trigger warning if someone tries to queue it anywhere else.  This
> > > doesn't need to be full-on general like workqueue.  Let's make
> > > reasonable trade-offs where possible.
> > 
> > I actually thought about this simplification as well. But then I am
> > in doubts about the API. It would make sense to assign the worker
> > when the work is being initialized and avoid the duplicate information
> > when the work is being queued:
> > 
> > 	init_kthread_work(work, fn, worker);
> > 	queue_work(work);
> > 
> > Or would you prefer to keep the API similar to workqueues even when
> > it makes less sense here?
> > 
> > 
> > In each case, we need a way to switch the worker if the old one
> > is destroyed and a new one is started later. We would need
> > something like:
> > 
> > 	reset_work(work, worker)
> > or
> > 	reinit_work(work, fn, worker)
> 
> I was too fast. We could set "work->worker = NULL" when the work
> finishes and it is not pending. It means that it will be connected
> to the particular worker only when used. Then we could keep the
> workqueues-like API and do not need reset_work().

I have played with this idea and the result is not satisfactory.
I am not able to make the code easier using the single lock.

First, the worker lock is not enough to safely queue the work
without a test_and_set() atomic operation. Let me show this on
a pseudo code:

bool queue_kthread_work(worker, work)
{
	bool ret = false;

	lock(&worker->lock);

	if (test_bit(WORK_PENDING, work->flags);
		goto out;

	if (WARN(work->worker != worker,
		 "Work could not be used by two workers at the same time\n"))
		goto out;

	set_bit(WORK_PENDING, work->flags);
	work->worker = worker;
	insert_work(worker->work_list, work);
	ret = true;

out:
	unlock(&worker->lock);
	return ret;
}

Now, let's have one work: W, two workers: A, B, and try to queue
the same work to the two workers at the same time:

CPU0					CPU1

queue_kthread_work(A, W);		queue_kthread_work(B, W);
  lock(&A->lock);			lock(&B->lock);
  test_bit(WORK_PENDING, W->flags)      test_bit(WORK_PENDING, W->flags)
    # false				  # false
  WARN(W->worker != A);			WARN(W->worker != B);
    # false				  # false

  set_bit(WORK_PENDING, W->flags);	set_bit(WORK_PENDING, W->flags);
  W->worker = A;			W->worker = B;
  insert_work(A->work_list, W);		insert_work(B->work_list, W);

  unlock(&A->lock);			unlock(&B->lock);

=> It is possible and the result is unclear.

We would need to set either WORK_PENDING flag or the work->worker
using a test_and_set atomic operation and bail out if it fails.
But then we are back in the original code.


Second, we still need the busy waiting for the pending timer callback.
Yes, we could set some flag so that the call back does not queue
the work. But cancel_kthread_work_sync() still has to wait.
It could not return if there is still some pending operation
with the struct kthread_work. Otherwise, it never could
be freed a safe way.

Also note that we still need the WORK_PENDING flag. Otherwise, we
would not be able to detect the race when timer is removed but
the callback has not run yet.


Let me to repeat that using per-work and per-worker lock is not an
option either. We would need some crazy hacks to avoid ABBA deadlocks.


All in all, I would prefer to keep the original approach that is
heavily inspired by the workqueues. I think that it is actually
an advantage to reuse some working concept that reinventing wheels.


Best Regards,
Petr
