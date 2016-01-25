From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 08/22] kthread: Initial support for delayed kthread
 work
Date: Mon, 25 Jan 2016 14:04:54 -0500
Message-ID: <20160125190454.GD3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-9-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-9-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Jan 25, 2016 at 04:44:57PM +0100, Petr Mladek wrote:
> +/*
> + * Returns true when there is a pending operation for this work.
> + * In particular, it checks if the work is:
> + *	- queued
> + *	- a timer is running to queue this delayed work
> + *
> + * This function must be called with locked work.
> + */
> +static inline bool kthread_work_pending(const struct kthread_work *work)
> +{
> +	return !list_empty(&work->node) ||
> +	       (work->timer && timer_active(work->timer));
> +}

Why not just put the work item on a separate list so that
lits_empty(&work->node) is always enough?  IOW, put delayed work items
on timers on worker->delayed or sth.

> +/*
> + * Queue @work right into the worker queue.
> + */
> +static void __queue_kthread_work(struct kthread_worker *worker,
> +			  struct kthread_work *work)
> +{
> +	insert_kthread_work(worker, work, &worker->work_list);
> +}

Does this really need to be an inline function?  This sort of one
liner helpers tend to be obfuscating more than anything else.

> @@ -756,6 +779,121 @@ bool queue_kthread_work(struct kthread_worker *worker,
>  }
>  EXPORT_SYMBOL_GPL(queue_kthread_work);
>  
> +static bool try_lock_kthread_work(struct kthread_work *work)
> +{
> +	struct kthread_worker *worker;
> +	int ret = false;
> +
> +try_again:
> +	worker = work->worker;
> +
> +	if (!worker)
> +		goto out;

		return false;

> +
> +	spin_lock(&worker->lock);
> +	if (worker != work->worker) {
> +		spin_unlock(&worker->lock);
> +		goto try_again;
> +	}

	return true;

> +	ret = true;
> +
> +out:
> +	return ret;
> +}

Stop building unnecessary structures.  Keep it simple.

> +static inline void unlock_kthread_work(struct kthread_work *work)
> +{
> +	spin_unlock(&work->worker->lock);
> +}

Ditto.  Just open code it.  It doesn't add anything.

> +/**
> + * delayed_kthread_work_timer_fn - callback that queues the associated delayed
> + *	kthread work when the timer expires.
> + * @__data: pointer to the data associated with the timer
> + *
> + * The format of the function is defined by struct timer_list.
> + * It should have been called from irqsafe timer with irq already off.
> + */
> +void delayed_kthread_work_timer_fn(unsigned long __data)
> +{
> +	struct delayed_kthread_work *dwork =
> +		(struct delayed_kthread_work *)__data;
> +	struct kthread_work *work = &dwork->work;
> +
> +	if (!try_lock_kthread_work(work))

Can you please explain why try_lock is necessary here?  That's the
most important and non-obvious thing going on here and there's no
explanation of that at all.

Thanks.

-- 
tejun
