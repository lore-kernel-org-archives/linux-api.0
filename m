From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 09/18] kthread: Make it easier to correctly sleep in
 iterant kthreads
Date: Wed, 10 Jun 2015 11:05:49 +0200
Message-ID: <20150610090549.GC3644@twins.programming.kicks-ass.net>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-10-git-send-email-pmladek@suse.cz>
 <20150605161021.GJ19282@twins.programming.kicks-ass.net>
 <20150608100107.GA3135@pathway.suse.cz>
 <1433763595.1495.35.camel@twins>
 <20150609152526.GB9409@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150609152526.GB9409-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 09, 2015 at 05:25:26PM +0200, Petr Mladek wrote:
> On Mon 2015-06-08 13:39:55, Peter Zijlstra wrote:
> > On Mon, 2015-06-08 at 12:01 +0200, Petr Mladek wrote:
> > 
> > > Just to be sure. Do you suggest to use TASK_IDLE everywhere in
> > > kthreads or only when the uninterruptible sleep is really needed?
> >
> > Always, only use INTERRUPTIBLE when you're actually interruptible, that
> > is you want signals or such muck to terminate your wait.
> 
> I like that TASK_IDLE clearly describes that the state of the task.
> I am just curious. Is there any particular advantage of using
> uninterruptible sleep over the interruptible one, please?

I think, given how all schedule() calls should be inside a loop testing
their sleep condition, and one has to assume spurious wakeups anyhow,
one can make an argument for removing the distinction.

That said, typically INTERRUPTIBLE means 'capable of handling signals
while waiting for $foo', and as said elsewhere in this thread, kthreads
should not really be having signals.

In that spirit, I think UNINTERRUPTIBLE is the right sleep.

> I ask because making freezable kthreads is quite tricky. You need to
> call try_to_freeze() after each schedule or call freezable_* variants
> of schedule(). I think that it is easy to make a mistake. I wonder if
> it might be more elegant to use interruptible sleep whenever possible,
> send the fake signal also to kthreads and force them moving into some
> location where the freeze is safe and handled.

I don't think that's really a concern here, you have an absolutely
perfect freeze point and freezable_schedule() is fine.
> 
> > > IMHO, we should not use TASK_IDLE in freezable kthreads because
> > > it would break freezing.
> > 
> > How so? The task is IDLE, its not doing anything.
> 
> Well, it might cause the freeze. I have just double checked this
> with ubi_thread(). It calls set_freezable().

> I did the following change:
> 
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 16214d3d57a4..d528fa5e93ba 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -1428,7 +1428,7 @@ int ubi_thread(void *u)
>                 spin_lock(&ubi->wl_lock);
>                 if (list_empty(&ubi->works) || ubi->ro_mode ||
>                     !ubi->thread_enabled || ubi_dbg_is_bgt_disabled(ubi)) {
> -                       set_current_state(TASK_INTERRUPTIBLE);
> +                       set_current_state(TASK_IDLE);
>                         spin_unlock(&ubi->wl_lock);
>                         schedule();
>                         continue;


> or use in ubi_thread()
> 
> 		freezable_schedule()

This

> or always ignore freezing when the task sets TASK_IDLE.

Can't, because they might get woken up, in which case they need to end
up in the fridge.

> > And this is the arch typical freeze point if ever there was one, you're
> > checking kthread_stop, if we can terminate the kthread, we can certainly
> > get frozen.
> 
> It makes sense. The tasks should be in some sane state when it goes
> into the idle state. I hope that people will not misuse it too much.

Do your utmost bestest to put in as many assertions as you can to avoid
abuse.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
