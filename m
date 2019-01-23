From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 10/16] sched/core: Add uclamp_util_with()
Date: Wed, 23 Jan 2019 14:33:24 +0100
Message-ID: <20190123133324.GY27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-11-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-11-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:07AM +0000, Patrick Bellasi wrote:
> +static __always_inline
> +unsigned int uclamp_util_with(struct rq *rq, unsigned int util,
> +			      struct task_struct *p)
>  {
>  	unsigned int min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
>  	unsigned int max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
>  
> +	if (p) {
> +		min_util = max(min_util, uclamp_effective_value(p, UCLAMP_MIN));
> +		max_util = max(max_util, uclamp_effective_value(p, UCLAMP_MAX));
> +	}
> +

Like I think you mentioned earlier; this doesn't look right at all.

Should that not be something like:

	lo = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
	hi = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);

	min_util = clamp(uclamp_effective(p, UCLAMP_MIN), lo, hi);
	max_util = clamp(uclamp_effective(p, UCLAMP_MAX), lo, hi);
