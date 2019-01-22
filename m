From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 08/16] sched/cpufreq: uclamp: Add utilization clamping
 for FAIR tasks
Date: Tue, 22 Jan 2019 18:13:14 +0100
Message-ID: <20190122171314.GS27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-9-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-9-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:05AM +0000, Patrick Bellasi wrote:
> @@ -342,11 +350,24 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
>  		return;
>  	sg_cpu->iowait_boost_pending = true;
>  
> +	/*
> +	 * Boost FAIR tasks only up to the CPU clamped utilization.
> +	 *
> +	 * Since DL tasks have a much more advanced bandwidth control, it's
> +	 * safe to assume that IO boost does not apply to those tasks.

I'm not buying that argument. IO-boost isn't related to b/w management.

IO-boot is more about compensating for hidden dependencies, and those
don't get less hidden for using a different scheduling class.

Now, arguably DL should not be doing IO in the first place, but that's a
whole different discussion.

> +	 * Instead, since RT tasks are not utilization clamped, we don't want
> +	 * to apply clamping on IO boost while there is blocked RT
> +	 * utilization.
> +	 */
> +	max_boost = sg_cpu->iowait_boost_max;
> +	if (!cpu_util_rt(cpu_rq(sg_cpu->cpu)))
> +		max_boost = uclamp_util(cpu_rq(sg_cpu->cpu), max_boost);
> +
>  	/* Double the boost at each request */
>  	if (sg_cpu->iowait_boost) {
>  		sg_cpu->iowait_boost <<= 1;
> -		if (sg_cpu->iowait_boost > sg_cpu->iowait_boost_max)
> -			sg_cpu->iowait_boost = sg_cpu->iowait_boost_max;
> +		if (sg_cpu->iowait_boost > max_boost)
> +			sg_cpu->iowait_boost = max_boost;
>  		return;
>  	}

Hurmph...  so I'm not sold on this bit.
