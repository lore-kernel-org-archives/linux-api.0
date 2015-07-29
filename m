From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 13/14] kthread_worker: Add
 set_kthread_worker_user_nice()
Date: Wed, 29 Jul 2015 13:23:54 +0200
Message-ID: <20150729112354.GK2673@pathway.suse.cz>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-14-git-send-email-pmladek@suse.com>
 <20150728174058.GF5322@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728174058.GF5322-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-07-28 13:40:58, Tejun Heo wrote:
> On Tue, Jul 28, 2015 at 04:39:30PM +0200, Petr Mladek wrote:
> ...
> > +/*
> > + * set_kthread_worker_user_nice - set scheduling priority for the kthread worker
> > + * @worker: target kthread_worker
> > + * @nice: niceness value
> > + */
> > +void set_kthread_worker_user_nice(struct kthread_worker *worker, long nice)
> > +{
> > +	struct task_struct *task = worker->task;
> > +
> > +	WARN_ON(!task);
> > +	set_user_nice(task, nice);
> > +}
> > +EXPORT_SYMBOL(set_kthread_worker_user_nice);
> 
> kthread_worker is explcitly associated with a single kthread.  Why do
> we want to create explicit wrappers for kthread operations?  This is
> encapsulation for encapsulation's sake.  It doesn't buy us anything at
> all.  Just let the user access the associated kthread and operate on
> it.

My plan is to make the API cleaner and hide struct kthread_worker
definition into kthread.c. It would prevent anyone doing any hacks
with it. BTW, we do the same with struct workqueue_struct.

Another possibility would be to add helper function to get the
associated task struct but this might cause inconsistencies when
the worker is restarted.

Best Regards,
Petr
