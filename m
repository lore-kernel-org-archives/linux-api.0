From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v9 06/12] kthread: Add kthread_drain_worker()
Date: Mon, 27 Jun 2016 16:33:50 +0200
Message-ID: <20160627143350.GA3313@pathway.suse.cz>
References: <1466075851-24013-1-git-send-email-pmladek@suse.com>
 <1466075851-24013-7-git-send-email-pmladek@suse.com>
 <20160622205445.GV30909@twins.programming.kicks-ass.net>
 <20160623213258.GO3262@mtj.duckdns.org>
 <20160624070515.GU30154@twins.programming.kicks-ass.net>
 <20160624155447.GY3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160624155447.GY3262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Fri 2016-06-24 11:54:47, Tejun Heo wrote:
> On Fri, Jun 24, 2016 at 09:05:15AM +0200, Peter Zijlstra wrote:
> > > Given how rare that is 
> > 
> > Could you then not remove/rework these few cases for workqueue as well
> > and make that 'better' too?
> 
> Usage of draining is rare for workqueue but that still means several
> legitimate users.  With draining there, it's logical to use it during
> shutdown.  I don't think it makes sense to change it on workqueue
> side.
> 
> > > and the extra
> > > complexity of identifying self-requeueing cases, let's forget about
> > > draining and on destruction clear the worker pointer to block further
> > > queueing and then flush whatever is in flight.
> > 
> > You're talking about regular workqueues here?
> 
> No, kthread worker.  It's unlikely that kthread worker is gonna need
> chained draining especially given that most of its usages are gonna be
> conversions from raw kthread usages.  We won't lose much if anything
> by just ignoring draining and making the code simpler.

OK, so you suggest to do the following:

  1. Add a flag into struct kthread_worker that will prevent
     from further queuing.

  2. kthread_create_worker()/kthread_destroy_worker() will
     not longer dynamically allocate struct kthread_worker.
     They will just start/stop the kthread.


The result will be:

  a. User will not need the strict synchronization between
     the queue and create/destroy operations.

  b. We could get rid of drain_kthread_worker() because
     flush_kthread_worker() will be enough.


IMHO, the 1st change does not make sense without the 2nd one.
Otherwise, users could do an out-of-memory access when testing
the freed kthread_worker flag.

Do I get this correctly please?

Best Regards,
Petr
