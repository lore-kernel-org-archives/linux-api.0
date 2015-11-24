From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 17/22] ipmi: Convert kipmi kthread into kthread worker
 API
Date: Tue, 24 Nov 2015 13:12:33 +0100
Message-ID: <20151124121233.GH10750@pathway.suse.cz>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-18-git-send-email-pmladek@suse.com>
 <56536AA6.5040102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56536AA6.5040102-HInyCGIudOg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-23 13:36:06, Corey Minyard wrote:
> 
> 
> On 11/18/2015 07:25 AM, Petr Mladek wrote:
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
> > single thread for the work. It helps to make sure that it is
> > available when needed. Also it allows a better control, e.g.
> > define a scheduling priority.
> >
> > This patch converts kipmi kthread into the kthread worker API because
> > it modifies the scheduling priority. The change is quite straightforward.
> 
> I think this is correct.  That code was hard to get right, but I don't
> see where any
> logic is actually changed.

I believe that it was hard to make it working.


> This also doesn't really look any simpler (you end up with more LOC than
> you did before :) ),
> though it will make things more consistent and reduce errors and that's
> a good thing.

I have just realized that the original code actually looks racy. For
example, it does:

	__set_current_state(TASK_INTERRUPTIBLE);
	schedule();

without rechecking the state in between. There might already be a new
message and it might miss the wake_up_process(). Similar problem is
with the schedule_timeout_interruptible(100); I mean:


CPU 0					CPU 1


ipmi_thread()
  spin_lock_irqsave();
  smi_result = smi_event_handler();
  spin_unlock_irqrestore();

  [...]
  else if (smi_result == SI_SM_IDLE)
    /* true */
    if (atomic_read(need_watch)) {
      /* true */

					sender()
					  spin_lock_irqsave()
					  check_start_timer_thread()
					    wake_up_process()

					    /*
					     * NOPE because kthread
					     * is not sleeping
					     */

     schedule_timeout_interruptible(100);

     /*
      * We sleep 100 jiffies but
      * there is a pending message.
      */


This is not a problem with the kthread worker API because

	mod_delayed_kthread_work(smi_info->worker,
				 &smi_info->work, 0);

would queue the work to be done immediately and

	queue_delayed_kthread_work(smi_info->worker,
				   &smi_info->work, 100);

would do nothing in this case.


> My only comment is I would like the worker function named ipmi_worker,
> not ipmi_func.

You probably want it because the original name was ipmi_thread. But
it might cause confusion with new_smi->worker. The function gets
assigned to work->func, see struct kthread_work. Therefore I think that
_func suffix makes more sense.

> Reviewed-by: Corey Minyard <cminyard-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>


Thanks a lot for review,
Petr
