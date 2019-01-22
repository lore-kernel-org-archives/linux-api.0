From: Quentin Perret <quentin.perret@arm.com>
Subject: Re: [PATCH v6 11/16] sched/fair: Add uclamp support to
 energy_compute()
Date: Tue, 22 Jan 2019 13:29:46 +0000
Message-ID: <20190122132944.sfxlnpc3xeft4rqd@queper01-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-12-patrick.bellasi@arm.com>
 <20190122121321.r6mv23ao57uut3t7@queper01-lin>
 <20190122124546.njrpmykzbjpztd6u@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122124546.njrpmykzbjpztd6u@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 22 Jan 2019 at 12:45:46 (+0000), Patrick Bellasi wrote:
> On 22-Jan 12:13, Quentin Perret wrote:
> > On Tuesday 15 Jan 2019 at 10:15:08 (+0000), Patrick Bellasi wrote:
> > > The Energy Aware Scheduler (AES) estimates the energy impact of waking
> 
> [...]
> 
> > > +		for_each_cpu_and(cpu, pd_mask, cpu_online_mask) {
> > > +			cfs_util = cpu_util_next(cpu, p, dst_cpu);
> > > +
> > > +			/*
> > > +			 * Busy time computation: utilization clamping is not
> > > +			 * required since the ratio (sum_util / cpu_capacity)
> > > +			 * is already enough to scale the EM reported power
> > > +			 * consumption at the (eventually clamped) cpu_capacity.
> > > +			 */
> > 
> > Right.
> > 
> > > +			sum_util += schedutil_cpu_util(cpu, cfs_util, cpu_cap,
> > > +						       ENERGY_UTIL, NULL);
> > > +
> > > +			/*
> > > +			 * Performance domain frequency: utilization clamping
> > > +			 * must be considered since it affects the selection
> > > +			 * of the performance domain frequency.
> > > +			 */
> > 
> > So that actually affects the way we deal with RT I think. I assume the
> > idea is to say if you don't want to reflect the RT-go-to-max-freq thing
> > in EAS (which is what we do now) you should set the min cap for RT to 0.
> > Is that correct ?
> 
> By default configuration, RT tasks still go to max when uclamp is
> enabled, since they get a util_min=1024.
> 
> If we want to save power on RT tasks, we can set a smaller util_min...
> but not necessarily 0. A util_min=0 for RT tasks means to use just
> cpu_util_rt() for that class.

Ah, sorry, I guess my message was misleading. I'm saying this is
changing the way _EAS_ deals with RT tasks. Right now we don't actually
consider the RT-go-to-max thing at all in the EAS prediction. Your
patch is changing that AFAICT. It actually changes the way EAS sees RT
tasks even without uclamp ...

But I'm not hostile to the idea since it's possible to enable uclamp and
set the min cap to 0 for RT if you want. So there is a story there.
However, I think this needs be documented somewhere, at the very least.

Thanks,
Quentin
