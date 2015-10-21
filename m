From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Wed, 21 Oct 2015 18:12:48 +0200
Message-ID: <20151021161247.GA19764@lerouge>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445373372-6567-5-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 04:36:02PM -0400, Chris Metcalf wrote:
> diff --git a/kernel/isolation.c b/kernel/isolation.c
> new file mode 100644
> index 000000000000..9a73235db0bb
> --- /dev/null
> +++ b/kernel/isolation.c
> @@ -0,0 +1,78 @@
> +/*
> + *  linux/kernel/isolation.c
> + *
> + *  Implementation for task isolation.
> + *
> + *  Distributed under GPLv2.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/swap.h>
> +#include <linux/vmstat.h>
> +#include <linux/isolation.h>
> +#include <linux/syscalls.h>
> +#include "time/tick-sched.h"
> +
> +/*
> + * This routine controls whether we can enable task-isolation mode.
> + * The task must be affinitized to a single nohz_full core or we will
> + * return EINVAL.  Although the application could later re-affinitize
> + * to a housekeeping core and lose task isolation semantics, this
> + * initial test should catch 99% of bugs with task placement prior to
> + * enabling task isolation.
> + */
> +int task_isolation_set(unsigned int flags)
> +{
> +	if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||

I think you'll have to make sure the task can not be concurrently reaffined
to more CPUs. This may involve setting task_isolation_flags under the runqueue
lock and thus move that tiny part to the scheduler code. And then we must forbid
changing the affinity while the task has the isolation flag, or deactivate the flag.

In any case this needs some synchronization.

> +	    !tick_nohz_full_cpu(smp_processor_id()))
> +		return -EINVAL;
> +
> +	current->task_isolation_flags = flags;
> +	return 0;
> +}
> +
> +/*
> + * In task isolation mode we try to return to userspace only after
> + * attempting to make sure we won't be interrupted again.  To handle
> + * the periodic scheduler tick, we test to make sure that the tick is
> + * stopped, and if it isn't yet, we request a reschedule so that if
> + * another task needs to run to completion first, it can do so.
> + * Similarly, if any other subsystems require quiescing, we will need
> + * to do that before we return to userspace.
> + */
> +bool _task_isolation_ready(void)
> +{
> +	WARN_ON_ONCE(!irqs_disabled());
> +
> +	/* If we need to drain the LRU cache, we're not ready. */
> +	if (lru_add_drain_needed(smp_processor_id()))
> +		return false;
> +
> +	/* If vmstats need updating, we're not ready. */
> +	if (!vmstat_idle())
> +		return false;
> +
> +	/* If the tick is running, request rescheduling; we're not ready. */
> +	if (!tick_nohz_tick_stopped()) {

Note that this function tells whether the tick is in dynticks mode, which means
the tick currently only run on-demand. But it's not necessarily completely stopped.

I think we should rename that function and the field it refers to.

> +		set_tsk_need_resched(current);
> +		return false;
> +	}
> +
> +	return true;
> +}

Thanks.
