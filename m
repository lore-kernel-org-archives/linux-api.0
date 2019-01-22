From: Quentin Perret <quentin.perret@arm.com>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Tue, 22 Jan 2019 12:30:10 +0000
Message-ID: <20190122123007.dkavjh73w223pa6y@queper01-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-10-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tuesday 15 Jan 2019 at 10:15:06 (+0000), Patrick Bellasi wrote:
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index 520ee2b785e7..38a05a4f78cc 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -201,9 +201,6 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
>  	unsigned long dl_util, util, irq;
>  	struct rq *rq = cpu_rq(cpu);
>  
> -	if (type == FREQUENCY_UTIL && rt_rq_is_runnable(&rq->rt))
> -		return max;
> -
>  	/*
>  	 * Early check to see if IRQ/steal time saturates the CPU, can be
>  	 * because of inaccuracies in how we track these -- see
> @@ -219,15 +216,19 @@ unsigned long schedutil_freq_util(int cpu, unsigned long util_cfs,
>  	 * utilization (PELT windows are synchronized) we can directly add them
>  	 * to obtain the CPU's actual utilization.
>  	 *
> -	 * CFS utilization can be boosted or capped, depending on utilization
> -	 * clamp constraints requested by currently RUNNABLE tasks.
> +	 * CFS and RT utilization can be boosted or capped, depending on
> +	 * utilization clamp constraints requested by currently RUNNABLE
> +	 * tasks.
>  	 * When there are no CFS RUNNABLE tasks, clamps are released and
>  	 * frequency will be gracefully reduced with the utilization decay.
>  	 */
> -	util = (type == ENERGY_UTIL)
> -		? util_cfs
> -		: uclamp_util(rq, util_cfs);
> -	util += cpu_util_rt(rq);
> +	util = cpu_util_rt(rq);
> +	if (type == FREQUENCY_UTIL) {
> +		util += cpu_util_cfs(rq);
> +		util  = uclamp_util(rq, util);

So with this we don't go to max to anymore for CONFIG_UCLAMP_TASK=n no ?

Thanks,
Quentin
