From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 10/15] sched/fair: uclamp: Add uclamp support to
 energy_compute()
Date: Mon, 18 Mar 2019 15:19:00 +0000
Message-ID: <20190318151900.p2lm2ys4qx7yfjhs@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-11-patrick.bellasi@arm.com>
 <20190306172124.tpr32k6hawos7a3g@queper01-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306172124.tpr32k6hawos7a3g@queper01-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Perret <quentin.perret@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 06-Mar 17:21, Quentin Perret wrote:

[...]

> > Since we are at that:
> >  - rename schedutil_freq_util() into schedutil_cpu_util(),
> >    since it's not only used for frequency selection.
> >  - use "unsigned int" instead of "unsigned long" whenever the tracked
> >    utilization value is not expected to overflow 32bit.
> 
> We use unsigned long all over the place right ? All the task_util*()
> functions return unsigned long, the capacity-related functions too, and
> util_avg is an unsigned long in sched_avg. So I'm not sure if we want to
> do this TBH.

For utilization we never need more then an "unsigned int" as storage
class. Even at RQ level, 32bits allows +4mln tasks.

However we started with long and keep going on with that, this was
just an attempt to incrementally fix that whenever we do some
changes or we add some new code.
But, perhaps a single whole sale update patch would fit better this
job in case we really wanna do it at some point.

I'll drop this change in v8 and keep this patch focused on functional
bits, don't want to risk to sidetrack the discussion again.

[...]

> > @@ -283,13 +284,14 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
> >  static unsigned long sugov_get_util(struct sugov_cpu *sg_cpu)
> >  {
> >  	struct rq *rq = cpu_rq(sg_cpu->cpu);
> > -	unsigned long util = cpu_util_cfs(rq);
> > -	unsigned long max = arch_scale_cpu_capacity(NULL, sg_cpu->cpu);
> > +	unsigned int util_cfs = cpu_util_cfs(rq);
> > +	unsigned int cpu_cap = arch_scale_cpu_capacity(NULL, sg_cpu->cpu);
> 
> Do you really need this one ? What's wrong with 'max' :-) ?

Being a pretty "generic" and thus confusing name is not enough? :)

Anyway, same reasoning as above and same conclusions: I'll drop the
renaming so that we don't sidetrack the discussion on v8.

[...]

> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index de181b8a3a2a..b9acef080d99 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -2335,6 +2335,7 @@ static inline unsigned long capacity_orig_of(int cpu)
> >  #endif
> > 
> >  #ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL
> > +
> >  /**
> >   * enum schedutil_type - CPU utilization type
> 
> Since you're using this enum unconditionally in fair.c, you should to
> move it out of the #ifdef CONFIG_CPU_FREQ_GOV_SCHEDUTIL block, I think.
> 
> >   * @FREQUENCY_UTIL:	Utilization used to select frequency
> > @@ -2350,15 +2351,9 @@ enum schedutil_type {
> >  	ENERGY_UTIL,
> >  };

Good point, will do!

Cheers,
Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
