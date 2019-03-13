From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Wed, 13 Mar 2019 21:13:42 +0100
Message-ID: <20190313201342.GV2482@worktop.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190208100554.32196-4-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 08, 2019 at 10:05:42AM +0000, Patrick Bellasi wrote:
> +int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
> +				void __user *buffer, size_t *lenp,
> +				loff_t *ppos)
> +{
> +	int old_min, old_max;
> +	int result = 0;

Should this not have an internal mutex to serialize concurrent usage?
See for example sched_rt_handler().

> +
> +	old_min = sysctl_sched_uclamp_util_min;
> +	old_max = sysctl_sched_uclamp_util_max;
> +
> +	result = proc_dointvec(table, write, buffer, lenp, ppos);
> +	if (result)
> +		goto undo;
> +	if (!write)
> +		goto done;
> +
> +	if (sysctl_sched_uclamp_util_min > sysctl_sched_uclamp_util_max ||
> +	    sysctl_sched_uclamp_util_max > SCHED_CAPACITY_SCALE) {
> +		result = -EINVAL;
> +		goto undo;
> +	}
> +
> +	if (old_min != sysctl_sched_uclamp_util_min) {
> +		uclamp_default[UCLAMP_MIN].value =
> +			sysctl_sched_uclamp_util_min;
> +		uclamp_default[UCLAMP_MIN].bucket_id =
> +			uclamp_bucket_id(sysctl_sched_uclamp_util_min);
> +	}
> +	if (old_max != sysctl_sched_uclamp_util_max) {
> +		uclamp_default[UCLAMP_MAX].value =
> +			sysctl_sched_uclamp_util_max;
> +		uclamp_default[UCLAMP_MAX].bucket_id =
> +			uclamp_bucket_id(sysctl_sched_uclamp_util_max);
> +	}
> +
> +	/*
> +	 * Updating all the RUNNABLE task is expensive, keep it simple and do
> +	 * just a lazy update at each next enqueue time.
> +	 */
> +	goto done;
> +
> +undo:
> +	sysctl_sched_uclamp_util_min = old_min;
> +	sysctl_sched_uclamp_util_max = old_max;
> +done:
> +
> +	return result;
> +}
