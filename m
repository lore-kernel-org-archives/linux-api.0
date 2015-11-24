From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 07/22] kthread: Detect when a kthread work is used by
 more workers
Date: Tue, 24 Nov 2015 15:56:41 +0100
Message-ID: <20151124145641.GV17308@twins.programming.kicks-ass.net>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-8-git-send-email-pmladek@suse.com>
 <20151123222703.GH19072@mtj.duckdns.org>
 <20151124100650.GF10750@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151124100650.GF10750-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 11:06:50AM +0100, Petr Mladek wrote:
> On Mon 2015-11-23 17:27:03, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Nov 18, 2015 at 02:25:12PM +0100, Petr Mladek wrote:
> > > @@ -610,6 +625,12 @@ repeat:
> > >  	if (work) {
> > >  		__set_current_state(TASK_RUNNING);
> > >  		work->func(work);
> > > +
> > > +		spin_lock_irq(&worker->lock);
> > > +		/* Allow to queue the work into another worker */
> > > +		if (!kthread_work_pending(work))
> > > +			work->worker = NULL;
> > > +		spin_unlock_irq(&worker->lock);
> > 
> > Doesn't this mean that the work item can't be freed from its callback?
> > That pattern tends to happen regularly.
> 
> I am not sure if I understand your question. Do you mean switching
> work->func during the life time of the struct kthread_work? This
> should not be affected by the above code.

No, work->func(work) doing: kfree(work).

That is indeed something quite frequently done, and since you now have
references to work after calling func, things would go *boom* rather
quickly.
