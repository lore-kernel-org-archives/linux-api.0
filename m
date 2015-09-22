From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v2 07/18] kthread: Allow to cancel kthread work
Date: Tue, 22 Sep 2015 15:35:13 -0400
Message-ID: <20150922193513.GE17659@mtj.duckdns.org>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-8-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442840639-6963-8-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 21, 2015 at 03:03:48PM +0200, Petr Mladek wrote:
>  /**
> + * try_to_grab_pending_kthread_work - steal kthread work item from worklist,
> + *	and disable irq
> + * @work: work item to steal
> + * @is_dwork: @work is a delayed_work
> + * @flags: place to store irq state
> + *
> + * Try to grab PENDING bit of @work.  This function can handle @work in any
> + * stable state - idle, on timer or on worklist.
> + *
> + * Return:
> + *  1		if @work was pending and we successfully stole PENDING
> + *  0		if @work was idle and we claimed PENDING
> + *  -EAGAIN	if PENDING couldn't be grabbed at the moment, safe to busy-retry
> + *  -ENOENT	if someone else is canceling @work, this state may persist
> + *		for arbitrarily long
> + *
> + * Note:
> + * On >= 0 return, the caller owns @work's PENDING bit.  To avoid getting
> + * interrupted while holding PENDING and @work off queue, irq must be
> + * disabled on return.  This, combined with delayed_work->timer being
> + * irqsafe, ensures that we return -EAGAIN for finite short period of time.
> + *
> + * On successful return, >= 0, irq is disabled and the caller is
> + * responsible for releasing it using local_irq_restore(*@flags).
> + *
> + * This function is safe to call from any context including IRQ handler.
> + */

Ugh... I think this is way too much for kthread_worker.  Workqueue is
as complex as it is partly for historical reasons and partly because
it's used so widely and heavily.  kthread_worker is always guaranteed
to have a single worker and in most cases maybe several work items.
There's no reason to bring this level of complexity onto it.
Providing simliar semantics is fine but it should be possible to do
this in a lot simpler way if the requirements on space and concurrency
is this much lower.

e.g. always embed timer_list in a work item and use per-worker
spinlock to synchronize access to both the work item and timer and use
per-work-item mutex to synchronize multiple cancelers.  Let's please
keep it simple.

Thanks.

-- 
tejun
