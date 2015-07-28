From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 14/14] kthread_worker: Add
 set_kthread_worker_scheduler*()
Date: Tue, 28 Jul 2015 21:48:20 +0200
Message-ID: <20150728194820.GE19282@twins.programming.kicks-ass.net>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-15-git-send-email-pmladek@suse.com>
 <20150728174154.GG5322@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728174154.GG5322-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 01:41:54PM -0400, Tejun Heo wrote:
> On Tue, Jul 28, 2015 at 04:39:31PM +0200, Petr Mladek wrote:
> > +/**
> > + * set_kthread_worker_scheduler - change the scheduling policy and/or RT
> > + *	priority of a kthread worker.
> > + * @worker: target kthread_worker
> > + * @policy: new policy
> > + * @sched_priority: new RT priority
> > + *
> > + * Return: 0 on success. An error code otherwise.
> > + */
> > +int set_kthread_worker_scheduler(struct kthread_worker *worker,
> > +				 int policy, int sched_priority)
> > +{
> > +	return __set_kthread_worker_scheduler(worker, policy, sched_priority,
> > +					      true);
> > +}
> 
> Ditto.  I don't get why we would want these thin wrappers.

On top of which this is an obsolete interface :-)
