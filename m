From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 11/16] sched/fair: Add uclamp support to
 energy_compute()
Date: Tue, 22 Jan 2019 12:45:46 +0000
Message-ID: <20190122124546.njrpmykzbjpztd6u@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-12-patrick.bellasi@arm.com>
 <20190122121321.r6mv23ao57uut3t7@queper01-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122121321.r6mv23ao57uut3t7@queper01-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Perret <quentin.perret@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 12:13, Quentin Perret wrote:
> On Tuesday 15 Jan 2019 at 10:15:08 (+0000), Patrick Bellasi wrote:
> > The Energy Aware Scheduler (AES) estimates the energy impact of waking

[...]

> > +		for_each_cpu_and(cpu, pd_mask, cpu_online_mask) {
> > +			cfs_util = cpu_util_next(cpu, p, dst_cpu);
> > +
> > +			/*
> > +			 * Busy time computation: utilization clamping is not
> > +			 * required since the ratio (sum_util / cpu_capacity)
> > +			 * is already enough to scale the EM reported power
> > +			 * consumption at the (eventually clamped) cpu_capacity.
> > +			 */
> 
> Right.
> 
> > +			sum_util += schedutil_cpu_util(cpu, cfs_util, cpu_cap,
> > +						       ENERGY_UTIL, NULL);
> > +
> > +			/*
> > +			 * Performance domain frequency: utilization clamping
> > +			 * must be considered since it affects the selection
> > +			 * of the performance domain frequency.
> > +			 */
> 
> So that actually affects the way we deal with RT I think. I assume the
> idea is to say if you don't want to reflect the RT-go-to-max-freq thing
> in EAS (which is what we do now) you should set the min cap for RT to 0.
> Is that correct ?

By default configuration, RT tasks still go to max when uclamp is
enabled, since they get a util_min=1024.

If we want to save power on RT tasks, we can set a smaller util_min...
but not necessarily 0. A util_min=0 for RT tasks means to use just
cpu_util_rt() for that class.

> I'm fine with this conceptually but maybe the specific case of RT should
> be mentioned somewhere in the commit message or so ? I think it's
> important to say that clearly since this patch changes the default
> behaviour.

Default behavior for RT should not be affected. While a capping is
possible for those tasks... where do you see issues ?
Here we are just figuring out what's the capacity the task will run
at, if we will have clamped RT tasks will not be the max but: is that
a problem ?

> > +			cpu_util = schedutil_cpu_util(cpu, cfs_util, cpu_cap,
> > +						      FREQUENCY_UTIL,
> > +						      cpu == dst_cpu ? p : NULL);
> > +			max_util = max(max_util, cpu_util);
> >  		}
> >  
> >  		energy += em_pd_energy(pd->em_pd, max_util, sum_util);
> 
> Thanks,
> Quentin

-- 
#include <best/regards.h>

Patrick Bellasi
