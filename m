From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 07/22] kthread: Detect when a kthread work is used by
 more workers
Date: Mon, 25 Jan 2016 13:57:47 -0500
Message-ID: <20160125185747.GC3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-8-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-8-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 04:44:56PM +0100, Petr Mladek wrote:
> +static void insert_kthread_work_sanity_check(struct kthread_worker *worker,
> +					       struct kthread_work *work)
> +{
> +	lockdep_assert_held(&worker->lock);
> +	WARN_ON_ONCE(!irqs_disabled());

Isn't worker->lock gonna be a irq-safe lock?  If so, why would this
need to be tested separately?

> +	WARN_ON_ONCE(!list_empty(&work->node));
> +	/* Do not use a work with more workers, see queue_kthread_work() */
> +	WARN_ON_ONCE(work->worker && work->worker != worker);
> +}

Is this sanity check function gonna be used from multiple places?

>  /* insert @work before @pos in @worker */
>  static void insert_kthread_work(struct kthread_worker *worker,
> -			       struct kthread_work *work,
> -			       struct list_head *pos)
> +				struct kthread_work *work,
> +				struct list_head *pos)
>  {
> -	lockdep_assert_held(&worker->lock);
> +	insert_kthread_work_sanity_check(worker, work);
>  
>  	list_add_tail(&work->node, pos);
>  	work->worker = worker;
> @@ -717,6 +730,15 @@ static void insert_kthread_work(struct kthread_worker *worker,
>   * Queue @work to work processor @task for async execution.  @task
>   * must have been created with kthread_worker_create().  Returns %true
>   * if @work was successfully queued, %false if it was already pending.
> + *
> + * Never queue a work into a worker when it is being processed by another
> + * one. Otherwise, some operations, e.g. cancel or flush, will not work
> + * correctly or the work might run in parallel. This is not enforced
> + * because it would make the code too complex. There are only warnings
> + * printed when such a situation is detected.

I'm not sure the above paragraph adds much.  It isn't that accurate to
begin with as what's being disallowed is larger scope than the above.
Isn't the paragraph below enough?

> + * Reinitialize the work if it needs to be used by another worker.
> + * For example, when the worker was stopped and started again.
>   */
>  bool queue_kthread_work(struct kthread_worker *worker,
>  			struct kthread_work *work)
> -- 
> 1.8.5.6
> 

-- 
tejun
