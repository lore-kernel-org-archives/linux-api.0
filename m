From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v2 17/18] rcu: Convert RCU gp kthreads into kthread worker
 API
Date: Thu, 1 Oct 2015 17:43:00 +0200
Message-ID: <20151001154300.GD9603@pathway.suse.cz>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-18-git-send-email-pmladek@suse.com>
 <20150928171437.GB5182@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150928171437.GB5182-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-09-28 10:14:37, Paul E. McKenney wrote:
> On Mon, Sep 21, 2015 at 03:03:58PM +0200, Petr Mladek wrote:
> > Kthreads are currently implemented as an infinite loop. Each
> > has its own variant of checks for terminating, freezing,
> > awakening. In many cases it is unclear to say in which state
> > it is and sometimes it is done a wrong way.
> > 
> > The plan is to convert kthreads into kthread_worker or workqueues
> > API. It allows to split the functionality into separate operations.
> > It helps to make a better structure. Also it defines a clean state
> > where no locks are taken, IRQs blocked, the kthread might sleep
> > or even be safely migrated.
> > 
> > The kthread worker API is useful when we want to have a dedicated
> > single kthread for the work. It helps to make sure that it is
> > available when needed. Also it allows a better control, e.g.
> > define a scheduling priority.
> > 
> > This patch converts RCU gp threads into the kthread worker API.
> > They modify the scheduling, have their own logic to bind the process.
> > They provide functions that are critical for the system to work
> > and thus deserve a dedicated kthread.
> > 
> > This patch tries to split start of the grace period and the quiescent
> > state handling into separate works. The motivation is to avoid
> > wait_events inside the work. Instead it queues the works when
> > appropriate which is more typical for this API.
> > 
> > On one hand, it should reduce spurious wakeups where the condition
> > in the wait_event failed and the kthread went to sleep again.
> > 
> > On the other hand, there is a small race window when the other
> > work might get queued. We could detect and fix this situation
> > at the beginning of the work but it is a bit ugly.
> > 
> > The patch renames the functions kthread_wake() to kthread_worker_poke()
> > that sounds more appropriate.
> > 
> > Otherwise, the logic should stay the same. I did a lot of torturing
> > and I did not see any problem with the current patch. But of course,
> > it would deserve much more testing and reviewing before applying.
> 
> Suppose I later need to add helper kthreads to parallelize grace-period
> initialization.  How would I implement that in a freeze-friendly way?

I have been convinced that there only few kthreads that really need
freezing. See the discussion around my first attempt at
https://lkml.org/lkml/2015/6/13/190

In fact, RCU is a good example of kthreads that should not get
frozen because they are needed even later when the system
is suspended.

If I understand it correctly, they will do the job until most devices
and all non-boot CPUs are disabled. Then the task doing the suspend
will get scheduled. It will write the image and stop the machine.
RCU should not be needed by this very last step.

By other words. RCU should not be much concerned about freezing.

If you are concerned about adding more kthreads, it should be
possible to just add more workers if we agree on using the
kthreads worker API.


Best Regards,
Petr
