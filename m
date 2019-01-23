From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Wed, 23 Jan 2019 11:49:44 +0100
Message-ID: <20190123104944.GX27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-10-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:06AM +0000, Patrick Bellasi wrote:
> @@ -858,16 +859,23 @@ static inline void
>  uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
>  		     unsigned int *clamp_value, unsigned int *bucket_id)
>  {
> +	struct uclamp_se *default_clamp;
> +
>  	/* Task specific clamp value */
>  	*clamp_value = p->uclamp[clamp_id].value;
>  	*bucket_id = p->uclamp[clamp_id].bucket_id;
>  
> +	/* RT tasks have different default values */
> +	default_clamp = task_has_rt_policy(p)
> +		? uclamp_default_perf
> +		: uclamp_default;
> +
>  	/* System default restriction */
> -	if (unlikely(*clamp_value < uclamp_default[UCLAMP_MIN].value ||
> -		     *clamp_value > uclamp_default[UCLAMP_MAX].value)) {
> +	if (unlikely(*clamp_value < default_clamp[UCLAMP_MIN].value ||
> +		     *clamp_value > default_clamp[UCLAMP_MAX].value)) {
>  		/* Keep it simple: unconditionally enforce system defaults */
> -		*clamp_value = uclamp_default[clamp_id].value;
> -		*bucket_id = uclamp_default[clamp_id].bucket_id;
> +		*clamp_value = default_clamp[clamp_id].value;
> +		*bucket_id = default_clamp[clamp_id].bucket_id;
>  	}
>  }

So I still don't much like the whole effective thing; but I think you
should use rt_task() instead of task_has_rt_policy().
