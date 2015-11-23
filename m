From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 09/22] kthread: Allow to cancel kthread work
Date: Mon, 23 Nov 2015 17:58:23 -0500
Message-ID: <20151123225823.GI19072@mtj.duckdns.org>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-10-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447853127-3461-10-git-send-email-pmladek-IBi9RG/b67k@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Nov 18, 2015 at 02:25:14PM +0100, Petr Mladek wrote:
> +static int
> +try_to_cancel_kthread_work(struct kthread_work *work,
> +				   spinlock_t *lock,
> +				   unsigned long *flags)
> +{
> +	int ret = 0;
> +
> +	if (work->timer) {
> +		/* Try to cancel the timer if pending. */
> +		if (del_timer(work->timer)) {
> +			ret = 1;
> +			goto out;
> +		}
> +
> +		/* Are we racing with the timer callback? */
> +		if (timer_active(work->timer)) {
> +			/* Bad luck, need to avoid a deadlock. */
> +			spin_unlock_irqrestore(lock, *flags);
> +			del_timer_sync(work->timer);
> +			ret = -EAGAIN;
> +			goto out;
> +		}

As the timer side is already kinda trylocking anyway, can't the cancel
path be made simpler?  Sth like

	lock(worker);
	work->canceling = true;
	del_timer_sync(work->timer);
	unlock(worker);

And the timer can do (ignoring the multiple worker support, do we even
need that?)

	while (!trylock(worker)) {
		if (work->canceling)
			return;
		cpu_relax();
	}
	queue;
	unlock(worker);

Thanks.

-- 
tejun
