From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 01/22] timer: Allow to check when the timer callback
 has not finished yet
Date: Thu, 19 Nov 2015 13:43:49 +0100
Message-ID: <20151119124349.GP4431@pathway.suse.cz>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-2-git-send-email-pmladek@suse.com>
 <alpine.DEB.2.11.1511182331010.3761@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1511182331010.3761@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-11-18 23:32:28, Thomas Gleixner wrote:
> On Wed, 18 Nov 2015, Petr Mladek wrote:
> > timer_pending() checks whether the list of callbacks is empty.
> > Each callback is removed from the list before it is called,
> > see call_timer_fn() in __run_timers().
> > 
> > Sometimes we need to make sure that the callback has finished.
> > For example, if we want to free some resources that are accessed
> > by the callback.
> > 
> > For this purpose, this patch adds timer_active(). It checks both
> > the list of callbacks and the running_timer. It takes the base_lock
> > to see a consistent state.
> > 
> > I plan to use it to implement delayed works in kthread worker.
> > But I guess that it will have wider use. In fact, I wonder if
> > timer_pending() is misused in some situations.
> 
> Well. That's nice and good. But how will that new function solve
> anything? After you drop the lock the state is not longer valid.

If we prevent anyone from setting up the timer and timer_pending()
returns false, we are sure that the timer will stay as is.

For example, I use it in the function try_to_cancel_kthread_work().
Any manipulation with the timer is protected by worker->lock.
If the timer is not pending but still active, I have to drop
the lock and busy wait for the timer callback. See
http://thread.gmane.org/gmane.linux.kernel.mm/141493/focus=141501


Also I wonder if the following usage in
drivers/infiniband/hw/nes/nes_cm.c is safe:

static int mini_cm_dealloc_core(struct nes_cm_core *cm_core)
{
	nes_debug(NES_DBG_CM, "De-Alloc CM Core (%p)\n", cm_core);

	if (!cm_core)
		return -EINVAL;

	barrier();

	if (timer_pending(&cm_core->tcp_timer))
		del_timer(&cm_core->tcp_timer);

	destroy_workqueue(cm_core->event_wq);
	destroy_workqueue(cm_core->disconn_wq);

We destroy the workqueue but the timer callback might still
be in progress and queue new work.


There are many more locations where I see the pattern:

      if (timer_pending())
		del_timer();
      clean_up_stuff();

IMHO, we should use:

      if (timer_active())
		del_timer_sync();
      /* really safe to free stuff */
      clean_up_stuff();

or just

   del_timer_sync();
   clean_up_stuff();


I wonder if timer_pending() is used in more racy scenarios. Or maybe,
I just miss something that makes it all safe.

Thanks,
Petr
