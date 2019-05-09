From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 11/16] sched/fair: uclamp: Add uclamp support to
 energy_compute()
Date: Thu, 9 May 2019 14:51:05 +0200
Message-ID: <20190509125105.GU2623@hirez.programming.kicks-ass.net>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-12-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402104153.25404-12-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 11:41:47AM +0100, Patrick Bellasi wrote:
> @@ -6484,11 +6494,29 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
>  		 * it will not appear in its pd list and will not be accounted
>  		 * by compute_energy().
>  		 */
> -		for_each_cpu_and(cpu, perf_domain_span(pd), cpu_online_mask) {
> -			util = cpu_util_next(cpu, p, dst_cpu);
> -			util = schedutil_energy_util(cpu, util);
> -			max_util = max(util, max_util);
> -			sum_util += util;
> +		for_each_cpu_and(cpu, pd_mask, cpu_online_mask) {
> +			util_cfs = cpu_util_next(cpu, p, dst_cpu);
> +
> +			/*
> +			 * Busy time computation: utilization clamping is not
> +			 * required since the ratio (sum_util / cpu_capacity)
> +			 * is already enough to scale the EM reported power
> +			 * consumption at the (eventually clamped) cpu_capacity.
> +			 */
> +			sum_util += schedutil_cpu_util(cpu, util_cfs, cpu_cap,
> +						       ENERGY_UTIL, NULL);
> +
> +			/*
> +			 * Performance domain frequency: utilization clamping
> +			 * must be considered since it affects the selection
> +			 * of the performance domain frequency.
> +			 * NOTE: in case RT tasks are running, by default the
> +			 * FREQUENCY_UTIL's utilization can be max OPP.
> +			 */
> +			tsk = cpu == dst_cpu ? p : NULL;
> +			cpu_util = schedutil_cpu_util(cpu, util_cfs, cpu_cap,
> +						      FREQUENCY_UTIL, tsk);
> +			max_util = max(max_util, cpu_util);
>  		}

That's a bit unfortunate; having to do both variants here, but I see
why. Nothing to be done about it I suppose.
