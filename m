From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Thu, 28 Jan 2016 17:38:24 +0100
Message-ID: <20160128163822.GD25866@lerouge>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
 <20151021161247.GA19764@lerouge>
 <562FA8FD.8080502@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <562FA8FD.8080502-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 27, 2015 at 12:40:29PM -0400, Chris Metcalf wrote:
> On 10/21/2015 12:12 PM, Frederic Weisbecker wrote:
> >On Tue, Oct 20, 2015 at 04:36:02PM -0400, Chris Metcalf wrote:
> >>+/*
> >>+ * This routine controls whether we can enable task-isolation mode.
> >>+ * The task must be affinitized to a single nohz_full core or we will
> >>+ * return EINVAL.  Although the application could later re-affinitize
> >>+ * to a housekeeping core and lose task isolation semantics, this
> >>+ * initial test should catch 99% of bugs with task placement prior to
> >>+ * enabling task isolation.
> >>+ */
> >>+int task_isolation_set(unsigned int flags)
> >>+{
> >>+	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
> >I think you'll have to make sure the task can not be concurrently reaffined
> >to more CPUs. This may involve setting task_isolation_flags under the runqueue
> >lock and thus move that tiny part to the scheduler code. And then we must forbid
> >changing the affinity while the task has the isolation flag, or deactivate the flag.
> >
> >In any case this needs some synchronization.
> 
> Well, as the comment says, this is not intended as a hard guarantee.
> As written, it might race with a concurrent sched_setaffinity(), but
> then again, it also is totally OK as written for sched_setaffinity() to
> change it away after the prctl() is complete, so it's not necessary to
> do any explicit synchronization.
> 
> This harks back again to the whole "polite vs aggressive" issue with
> how we envision task isolation.
> 
> The "polite" model basically allows you to set up the conditions for
> task isolation to be useful, and then if they are useful, great! What
> you're suggesting here is a bit more of the "aggressive" model, where
> we actually fail sched_setaffinity() either for any cpumask after
> task isolation is set, or perhaps just for resetting it to housekeeping
> cores.  (Note that we could in principle use PF_NO_SETAFFINITY to
> just hard fail all attempts to call sched_setaffinity once we enable
> task isolation, so we don't have to add more mechanism on that path.)
> 
> I'm a little reluctant to ever fail sched_setaffinity() based on the
> task isolation status with the current "polite" model, since an
> unprivileged application can set up for task isolation, and then
> presumably no one can override it via sched_setaffinity() from another
> task.  (I suppose you could do some kind of permissions-based thing
> where root can always override it, or some suitable capability, etc.,
> but I feel like that gets complicated quickly, for little benefit.)
> 
> The alternative you mention is that if the task is re-affinitized, it
> loses its task-isolation status, and that also seems like an unfortunate
> API, since if you are setting it with prctl(), it's really cleanest just to
> only be able to unset it with prctl() as well.
> 
> I think given the current "polite" API, the only question is whether in
> fact *no* initial test is the best thing, or if an initial test (as
> introduced
> in the v8 version) is defensible just as a help for catching an obvious
> mistake in setting up your task isolation.  I decided the advantage
> of catching the mistake were more important than the "API purity"
> of being 100% consistent in how we handled the interactions between
> affinity and isolation, but I am certainly open to argument on that one.
> 
> Meanwhile I think it still feels like the v8 code is the best compromise.

So what is the way to deal with a migration for example? When the task wakes
up on the non-isolated CPU, it gets warned or killed?

> 
> >>+	/* If the tick is running, request rescheduling; we're not ready. */
> >>+	if (!tick_nohz_tick_stopped()) {
> >Note that this function tells whether the tick is in dynticks mode, which means
> >the tick currently only run on-demand. But it's not necessarily completely stopped.
> 
> I think in fact this is the semantics we want (and that people requested),
> e.g. if the user requests an alarm(), we may still be ticking even though
> tick_nohz_tick_stopped() is true, but that test is still the right condition
> to use to return to user space, since the user explicitly requested the
> alarm.

It seems to break the initial purpose. If your task really doesn't want to be
disturbed, it simply can't arm a timer. tick_nohz_tick_stopped() is really no
other indication than the CPU trying to do its best to delay the next tick. But
that next tick could be re-armed every two msecs for example. Worse yet, if the
tick has been stopped and finally issues a timer that rearms itself every 1 msec,
tick_nohz_tick_stopped() will still be true.

Thanks.

> 
> >I think we should rename that function and the field it refers to.
> 
> Sounds like a good idea.
> 
> -- 
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
> 
