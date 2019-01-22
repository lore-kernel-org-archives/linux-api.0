From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Tue, 22 Jan 2019 11:02:05 +0000
Message-ID: <20190122110205.lpk6o2jdfe3mttjr@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
 <3006911.57lVBuUGX3@aspire.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3006911.57lVBuUGX3@aspire.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 11:37, Rafael J. Wysocki wrote:
> On Tuesday, January 15, 2019 11:15:05 AM CET Patrick Bellasi wrote:
> > Each time a frequency update is required via schedutil, a frequency is
> > selected to (possibly) satisfy the utilization reported by each
> > scheduling class. However, when utilization clamping is in use, the
> > frequency selection should consider userspace utilization clamping
> > hints.  This will allow, for example, to:
> > 
> >  - boost tasks which are directly affecting the user experience
> >    by running them at least at a minimum "requested" frequency
> > 
> >  - cap low priority tasks not directly affecting the user experience
> >    by running them only up to a maximum "allowed" frequency
> > 
> > These constraints are meant to support a per-task based tuning of the
> > frequency selection thus supporting a fine grained definition of
> > performance boosting vs energy saving strategies in kernel space.
> > 
> > Add support to clamp the utilization and IOWait boost of RUNNABLE FAIR
> > tasks within the boundaries defined by their aggregated utilization
> > clamp constraints.
> > Based on the max(min_util, max_util) of each task, max-aggregated the
> > CPU clamp value in a way to give the boosted tasks the performance they
> > need when they happen to be co-scheduled with other capped tasks.
> > 
> > Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > ---
> > Changes in v6:
> >  Message-ID: <20181107113849.GC14309@e110439-lin>
> >  - sanity check util_max >= util_min
> >  Others:
> >  - wholesale s/group/bucket/
> >  - wholesale s/_{get,put}/_{inc,dec}/ to match refcount APIs
> > ---
> >  kernel/sched/cpufreq_schedutil.c | 27 ++++++++++++++++++++++++---
> >  kernel/sched/sched.h             | 23 +++++++++++++++++++++++
> >  2 files changed, 47 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > index 033ec7c45f13..520ee2b785e7 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -218,8 +218,15 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
> >  	 * CFS tasks and we use the same metric to track the effective
> >  	 * utilization (PELT windows are synchronized) we can directly add them
> >  	 * to obtain the CPU's actual utilization.
> > +	 *
> > +	 * CFS utilization can be boosted or capped, depending on utilization
> > +	 * clamp constraints requested by currently RUNNABLE tasks.
> > +	 * When there are no CFS RUNNABLE tasks, clamps are released and
> > +	 * frequency will be gracefully reduced with the utilization decay.
> >  	 */
> > -	util = util_cfs;
> > +	util = (type == ENERGY_UTIL)
> > +		? util_cfs
> > +		: uclamp_util(rq, util_cfs);
> >  	util += cpu_util_rt(rq);
> >  
> >  	dl_util = cpu_util_dl(rq);
> > @@ -327,6 +334,7 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
> >  			       unsigned int flags)
> >  {
> >  	bool set_iowait_boost = flags & SCHED_CPUFREQ_IOWAIT;
> > +	unsigned int max_boost;
> >  
> >  	/* Reset boost if the CPU appears to have been idle enough */
> >  	if (sg_cpu->iowait_boost &&
> > @@ -342,11 +350,24 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
> >  		return;
> >  	sg_cpu->iowait_boost_pending = true;
> >  
> > +	/*
> > +	 * Boost FAIR tasks only up to the CPU clamped utilization.
> > +	 *
> > +	 * Since DL tasks have a much more advanced bandwidth control, it's
> > +	 * safe to assume that IO boost does not apply to those tasks.
> > +	 * Instead, since RT tasks are not utilization clamped, we don't want
> > +	 * to apply clamping on IO boost while there is blocked RT
> > +	 * utilization.
> > +	 */
> > +	max_boost = sg_cpu->iowait_boost_max;
> > +	if (!cpu_util_rt(cpu_rq(sg_cpu->cpu)))
> > +		max_boost = uclamp_util(cpu_rq(sg_cpu->cpu), max_boost);
> > +
> >  	/* Double the boost at each request */
> >  	if (sg_cpu->iowait_boost) {
> >  		sg_cpu->iowait_boost <<= 1;
> > -		if (sg_cpu->iowait_boost > sg_cpu->iowait_boost_max)
> > -			sg_cpu->iowait_boost = sg_cpu->iowait_boost_max;
> > +		if (sg_cpu->iowait_boost > max_boost)
> > +			sg_cpu->iowait_boost = max_boost;
> >  		return;
> >  	}
> >  
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index b7f3ee8ba164..95d62a2a0b44 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -2267,6 +2267,29 @@ static inline unsigned int uclamp_none(int clamp_id)
> >  	return SCHED_CAPACITY_SCALE;
> >  }
> >  
> > +#ifdef CONFIG_UCLAMP_TASK
> > +static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
> > +{
> > +	unsigned int min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
> > +	unsigned int max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
> > +
> > +	/*
> > +	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
> > +	 * RUNNABLE tasks with _different_ clamps, we can end up with an
> > +	 * invertion, which we can fix at usage time.
> > +	 */
> > +	if (unlikely(min_util >= max_util))
> > +		return min_util;
> > +
> > +	return clamp(util, min_util, max_util);
> > +}
> > +#else /* CONFIG_UCLAMP_TASK */
> > +static inline unsigned int uclamp_util(struct rq *rq, unsigned int util)
> > +{
> > +	return util;
> > +}
> > +#endif /* CONFIG_UCLAMP_TASK */
> > +
> >  #ifdef arch_scale_freq_capacity
> >  # ifndef arch_scale_freq_invariant
> >  #  define arch_scale_freq_invariant()	true
> > 
> 
> IMO it would be better to combine this patch with the next one.

Main reason was to better document in the changelog what we do for the
two different classes...

> At least some things in it I was about to ask about would go away
> then. :-)

... but if it creates confusion I can certainly merge them.

Or maybe clarify better in this patch what's not clear: may I ask what
were your questions ?

> Besides, I don't really see a reason for the split here.

Was mainly to make the changes required for RT more self-contained.

For that class only, not for FAIR, we have additional code in the
following patch which add uclamp_default_perf which are system
defaults used to track/account tasks requesting the maximum frequency.

Again, I can either better clarify the above patch or just merge the
two together: what do you prefer ?

-- 
#include <best/regards.h>

Patrick Bellasi
