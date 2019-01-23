From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Wed, 23 Jan 2019 10:52:19 +0100
Message-ID: <20190123095219.GV27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
 <20190122171314.GS27931@hirez.programming.kicks-ass.net>
 <20190122181831.a4w65qcivx4hua6d@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122181831.a4w65qcivx4hua6d@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 22, 2019 at 06:18:31PM +0000, Patrick Bellasi wrote:
> On 22-Jan 18:13, Peter Zijlstra wrote:
> > On Tue, Jan 15, 2019 at 10:15:05AM +0000, Patrick Bellasi wrote:
> > > @@ -342,11 +350,24 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
> > >  		return;
> > >  	sg_cpu->iowait_boost_pending = true;
> > >  
> > > +	/*
> > > +	 * Boost FAIR tasks only up to the CPU clamped utilization.
> > > +	 *
> > > +	 * Since DL tasks have a much more advanced bandwidth control, it's
> > > +	 * safe to assume that IO boost does not apply to those tasks.
> > 
> > I'm not buying that argument. IO-boost isn't related to b/w management.
> > 
> > IO-boot is more about compensating for hidden dependencies, and those
> > don't get less hidden for using a different scheduling class.
> > 
> > Now, arguably DL should not be doing IO in the first place, but that's a
> > whole different discussion.
> 
> My understanding is that IOBoost is there to help tasks doing many
> and _frequent_ IO operations, which are relatively _not so much_
> computational intensive on the CPU.
> 
> Those tasks generate a small utilization and, without IOBoost, will be
> executed at a lower frequency and will add undesired latency on
> triggering the next IO operation.
> 
> Isn't mainly that the reason for it?

  http://lkml.kernel.org/r/20170522082154.f57cqovterd2qajv@hirez.programming.kicks-ass.net

Using a lower frequency will allow the IO device to go idle while we try
and get the next request going.

The connection between IO device and task/freq selection is hidden/lost.
We could potentially do better here, but fundamentally a completion
doesn't have an 'owner', there can be multiple waiters etc.

We loose (through our software architecture, and this we could possibly
improve, although it would be fairly invasive) the device busy state,
and it would be the device that raises the CPU frequency (to the point
where request submission is no longer the bottle neck to staying busy).

Currently all we do is mark a task as sleeping on IO and loose any
and all device relations/metrics.

So I don't think the task clamping should affect the IO boosting, as
that is meant to represent the device state, not the task utilization.

> IMHO, it makes perfectly sense to use DL for these kind of operations
> but I would expect that, since you care about latency we should come
> up with a proper description of the required bandwidth... eventually
> accounting for an additional headroom to compensate for "hidden
> dependencies"... without relaying on a quite dummy policy like
> IOBoost to get our DL tasks working.

Deadline is about determinsm, (file/disk) IO is typically the
anti-thesis of that.

> At the end, DL is now quite good in driving the freq as high has it
> needs... and by closing userspace feedback loops it can also
> compensate for all sort of fluctuations and noise... as demonstrated
> by Alessio during last OSPM:
> 
>    http://retis.sssup.it/luca/ospm-summit/2018/Downloads/OSPM_deadline_audio.pdf

Audio is a special in that it is indeed a deterministic device, also, I
don't think ALSA touches the IO-wait code, that is typically all
filesystem stuff.

> > > +	 * Instead, since RT tasks are not utilization clamped, we don't want
> > > +	 * to apply clamping on IO boost while there is blocked RT
> > > +	 * utilization.
> > > +	 */
> > > +	max_boost = sg_cpu->iowait_boost_max;
> > > +	if (!cpu_util_rt(cpu_rq(sg_cpu->cpu)))
> > > +		max_boost = uclamp_util(cpu_rq(sg_cpu->cpu), max_boost);
> > > +
> > >  	/* Double the boost at each request */
> > >  	if (sg_cpu->iowait_boost) {
> > >  		sg_cpu->iowait_boost <<= 1;
> > > -		if (sg_cpu->iowait_boost > sg_cpu->iowait_boost_max)
> > > -			sg_cpu->iowait_boost = sg_cpu->iowait_boost_max;
> > > +		if (sg_cpu->iowait_boost > max_boost)
> > > +			sg_cpu->iowait_boost = max_boost;
> > >  		return;
> > >  	}
> > 
> > Hurmph...  so I'm not sold on this bit.
> 
> If a task is not clamped we execute it at its required utilization or
> even max frequency in case of wakeup from IO.
> 
> When a task is util_max clamped instead, we are saying that we don't
> care to run it above the specified clamp value and, if possible, we
> should run it below that capacity level.
> 
> If that's the case, why this clamping hints should not be enforced on
> IO wakeups too?
> 
> At the end it's still a user-space decision, we basically allow
> userspace to defined what's the max IO boost they like to get.

Because it is the wrong knob for it.

Ideally we'd extend the IO-wait state to include the device-busy state
at the time of sleep. At the very least double state io_schedule() state
space from 1 to 2 bits, where we not only indicate: yes this is an
IO-sleep, but also can indicate device saturation. When the device is
saturated, we don't need to boost further.

(this binary state will ofcourse cause oscilations where we drop the
freq, drop device saturation, then ramp the freq, regain device
saturation etc..)

However, doing this is going to require fairly massive surgery on our
whole IO stack.

Also; how big of a problem is 'supriouos' boosting really? Joel tried to
introduce a boost_max tunable, but the grandual boosting thing was good
enough at the time.
