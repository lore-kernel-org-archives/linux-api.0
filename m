From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Tue, 22 Jan 2019 15:45:24 +0000
Message-ID: <20190122154524.64c6yawmutig35zo@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
 <20190122152132.GR27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122152132.GR27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 16:21, Peter Zijlstra wrote:
> On Tue, Jan 15, 2019 at 10:15:05AM +0000, Patrick Bellasi wrote:
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
> 
> That's pretty horrible; what's wrong with:
> 
> 	util = util_cfs;
> 	if (type == FREQUENCY_UTIL)
> 		util = uclamp_util(rq, util);
> 
> That should generate the same code, but is (IMO) far easier to read.

Yes, right... and that's also the pattern we end up with the
following patch on RT integration.

However, as suggested by Rafael, I'll squash these two patches
together and we will get rid of the above for free ;)

> >  	util += cpu_util_rt(rq);
> >  
> >  	dl_util = cpu_util_dl(rq);

-- 
#include <best/regards.h>

Patrick Bellasi
