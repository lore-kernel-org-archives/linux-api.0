From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v9 06/12] kthread: Add kthread_drain_worker()
Date: Fri, 24 Jun 2016 11:08:25 +0200
Message-ID: <20160624090825.GG29718@pathway.suse.cz>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-7-git-send-email-pmladek@suse.com>
 <20160622205445.GV30909@twins.programming.kicks-ass.net>
 <20160623213258.GO3262@mtj.duckdns.org>
 <20160624070515.GU30154@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160624070515.GU30154@twins.programming.kicks-ass.net>
Sender: owner-linux-mm@kvack.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri 2016-06-24 09:05:15, Peter Zijlstra wrote:
> On Thu, Jun 23, 2016 at 05:32:58PM -0400, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Jun 22, 2016 at 10:54:45PM +0200, Peter Zijlstra wrote:
> > > > + * The caller is responsible for blocking all users of this kthread
> > > > + * worker from queuing new works. Also it is responsible for blocking
> > > > + * the already queued works from an infinite re-queuing!
> > > 
> > > This, I really dislike that. And it makes the kthread_destroy_worker()
> > > from the next patch unnecessarily fragile.
> > > 
> > > Why not add a kthread_worker::blocked flag somewhere and refuse/WARN
> > > kthread_queue_work() when that is set.
> > 
> > It's the same logic from workqueue counterpart.
> 
> So ? Clearly it (the kthread workqueue) can be improved here.
> 
> > For workqueue, nothing can make it less fragile as the workqueue
> > struct itself is freed on destruction.  If its users fail to stop
> > issuing work items, it'll lead to use-after-free.
> 
> Right, but this kthread thingy does not, so why not add a failsafe?

The struct kthread_worker is freed in kthread_destroy_worker().
So kthread_worker is the same situation as workqueues.

The allocation/freeing has been added in v2. It helped
to make it clear when the structure was initialized. Note that we
still need the crate/destroy functions to start/stop the kthread.
See the discussion at
https://lkml.kernel.org/g/20150728172657.GC5322@mtj.duckdns.org

I personally do not have strong opinion about it.

On one hand, it makes the code more complex because we need strong
synchronization between queueing/canceling/destroying. There are cases
where it is not that important, for example the hugepage daemon or
hung task. It does not matter if the next round will be done or not.
Well, it is strange if someting gets queued and it is not proceed.

On the other hand, there are situations where the work must be
done, e.g. some I/O operation. They need the strong syncronization.
We could print a warning when queueing a work for a destroyed
(stoped) kthread_worker to catch potential problems. But then we will need
the strong synchronization in all cases to avoid "false" alarms.

After all, the blocked flag will not necessarily make the usage
less hairy. Or did I miss something?

Best Regards,
Petr

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
