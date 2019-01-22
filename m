From: Quentin Perret <quentin.perret@arm.com>
Subject: Re: [PATCH v6 11/16] sched/fair: Add uclamp support to
 energy_compute()
Date: Tue, 22 Jan 2019 14:39:11 +0000
Message-ID: <20190122143909.pmlqyhcjshyomrbw@queper01-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-12-patrick.bellasi@arm.com>
 <20190122121321.r6mv23ao57uut3t7@queper01-lin>
 <20190122124546.njrpmykzbjpztd6u@e110439-lin>
 <20190122132944.sfxlnpc3xeft4rqd@queper01-lin>
 <20190122142606.gc5hnc5pzefblegw@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122142606.gc5hnc5pzefblegw@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 22 Jan 2019 at 14:26:06 (+0000), Patrick Bellasi wrote:
> On 22-Jan 13:29, Quentin Perret wrote:
> > On Tuesday 22 Jan 2019 at 12:45:46 (+0000), Patrick Bellasi wrote:
> > > On 22-Jan 12:13, Quentin Perret wrote:
> > > > On Tuesday 15 Jan 2019 at 10:15:08 (+0000), Patrick Bellasi wrote:
> > > > > The Energy Aware Scheduler (AES) estimates the energy impact of waking
> > > 
> > > [...]
> > > 
> > > > > +		for_each_cpu_and(cpu, pd_mask, cpu_online_mask) {
> > > > > +			cfs_util = cpu_util_next(cpu, p, dst_cpu);
> > > > > +
> > > > > +			/*
> > > > > +			 * Busy time computation: utilization clamping is not
> > > > > +			 * required since the ratio (sum_util / cpu_capacity)
> > > > > +			 * is already enough to scale the EM reported power
> > > > > +			 * consumption at the (eventually clamped) cpu_capacity.
> > > > > +			 */
> > > > 
> > > > Right.
> > > > 
> > > > > +			sum_util += schedutil_cpu_util(cpu, cfs_util, cpu_cap,
> > > > > +						       ENERGY_UTIL, NULL);
> > > > > +
> > > > > +			/*
> > > > > +			 * Performance domain frequency: utilization clamping
> > > > > +			 * must be considered since it affects the selection
> > > > > +			 * of the performance domain frequency.
> > > > > +			 */
> > > > 
> > > > So that actually affects the way we deal with RT I think. I assume the
> > > > idea is to say if you don't want to reflect the RT-go-to-max-freq thing
> > > > in EAS (which is what we do now) you should set the min cap for RT to 0.
> > > > Is that correct ?
> > > 
> > > By default configuration, RT tasks still go to max when uclamp is
> > > enabled, since they get a util_min=1024.
> > > 
> > > If we want to save power on RT tasks, we can set a smaller util_min...
> > > but not necessarily 0. A util_min=0 for RT tasks means to use just
> > > cpu_util_rt() for that class.
> > 
> > Ah, sorry, I guess my message was misleading. I'm saying this is
> > changing the way _EAS_ deals with RT tasks. Right now we don't actually
> > consider the RT-go-to-max thing at all in the EAS prediction. Your
> > patch is changing that AFAICT. It actually changes the way EAS sees RT
> > tasks even without uclamp ...
> 
> Lemme see if I get it right.
> 
> Currently, whenever we look at CPU utilization for ENERGY_UTIL, we
> always use cpu_util_rt() for RT tasks:
> 
> ---8<---
>         util = util_cfs;
>         util += cpu_util_rt(rq);
>         util += dl_util;
> ---8<---
> 
> Thus, even when RT tasks are RUNNABLE, we don't always assume the CPU
> running at the max capacity but just whatever is the aggregated
> utilization across all the classes.
> 
> With uclamp, we have:
> 
> ---8<---
>         util = cpu_util_rt(rq) + util_cfs;
>         if (type == FREQUENCY_UTIL)
>             util = uclamp_util_with(rq, util, p);
>         dl_util = cpu_util_dl(rq);
>         if (type == ENERGY_UTIL)
>             util += dl_util;
> ---8<---
> 
> So, I would say that, in terms of ENERGY_UTIL we do the same both
> w/ and w/o uclamp. Isn't it?

Yes but now you use FREQUENCY_UTIL for computing 'max_util' in the EAS
prediction.

Let's take an example. You have a perf domain with two CPUs. One CPU is
busy running a RT task, the other CPU runs a CFS task. Right now in
compute_energy() we only use ENERGY_UTIL, so 'max_util' ends up being
the max between the utilization of the two tasks. So we don't predict
we're going to max freq.

With your patch, we use FREQUENCY_UTIL to compute 'max_util', so we
_will_ predict that we're going to max freq. And we will do that even if
CONFIG_UCLAMP_TASK=n.

The default EAS calculation will be different with your patch when there
are runnable RT tasks in the system. This needs to be documented, I
think.

> > But I'm not hostile to the idea since it's possible to enable uclamp and
> > set the min cap to 0 for RT if you want. So there is a story there.
> > However, I think this needs be documented somewhere, at the very least.
> 
> The only difference I see is that the actual frequency could be
> different (lower then max) when a clamped RT task is RUNNABLE.
> 
> Are you worried that running RT on a lower freq could have side
> effects on the estimated busy time the CPU ?
> 
> I also still don't completely get why you say it could be useful to
>    "set the min cap to 0 for RT if you want"

I'm not saying it's useful, I'm saying userspace can decide to do that
if it thinks it is a good idea. The default should be min_cap = 1024 for
RT, no questions. But you _can_ change it at runtime if you want to.
That's my point. And doing that basically provides the same behaviour as
what we have right now in terms of EAS calculation (but it changes the
freq selection obviously) which is why I'm not fundamentally opposed to
your patch.

So in short, I'm fine with the behavioural change, but please at least
mention it somewhere :-)

Thanks,
Quentin
