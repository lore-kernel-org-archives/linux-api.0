From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 1/6] sched/core: uclamp: Extend CPU's cgroup
 controller
Date: Fri, 30 Aug 2019 11:45:05 +0200
Message-ID: <20190830094505.GA2369@hirez.programming.kicks-ass.net>
References: <20190822132811.31294-1-patrick.bellasi@arm.com>
 <20190822132811.31294-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190822132811.31294-2-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 22, 2019 at 02:28:06PM +0100, Patrick Bellasi wrote:
> +#define _POW10(exp) ((unsigned int)1e##exp)
> +#define POW10(exp) _POW10(exp)

What is this magic? You're forcing a float literal into an integer.
Surely that deserves a comment!

> +struct uclamp_request {
> +#define UCLAMP_PERCENT_SHIFT	2
> +#define UCLAMP_PERCENT_SCALE	(100 * POW10(UCLAMP_PERCENT_SHIFT))
> +	s64 percent;
> +	u64 util;
> +	int ret;
> +};
> +
> +static inline struct uclamp_request
> +capacity_from_percent(char *buf)
> +{
> +	struct uclamp_request req = {
> +		.percent = UCLAMP_PERCENT_SCALE,
> +		.util = SCHED_CAPACITY_SCALE,
> +		.ret = 0,
> +	};
> +
> +	buf = strim(buf);
> +	if (strncmp("max", buf, 4)) {

That is either a bug, and you meant to write: strncmp(buf, "max", 3), or
it is not, and then you could've written: strcmp(buf, "max")

But as written it doesn't make sense.

> +		req.ret = cgroup_parse_float(buf, UCLAMP_PERCENT_SHIFT,
> +					     &req.percent);
> +		if (req.ret)
> +			return req;
> +		if (req.percent > UCLAMP_PERCENT_SCALE) {
> +			req.ret = -ERANGE;
> +			return req;
> +		}
> +
> +		req.util = req.percent << SCHED_CAPACITY_SHIFT;
> +		req.util = DIV_ROUND_CLOSEST_ULL(req.util, UCLAMP_PERCENT_SCALE);
> +	}
> +
> +	return req;
> +}
