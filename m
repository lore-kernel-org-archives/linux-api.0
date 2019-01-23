From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Wed, 23 Jan 2019 11:28:21 +0100
Message-ID: <20190123102821.GW27931@hirez.programming.kicks-ass.net>
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
> -	util = (type == ENERGY_UTIL)
> -		? util_cfs
> -		: uclamp_util(rq, util_cfs);
> -	util += cpu_util_rt(rq);
> +	util = cpu_util_rt(rq);
> +	if (type == FREQUENCY_UTIL) {
> +		util += cpu_util_cfs(rq);
> +		util  = uclamp_util(rq, util);
> +	} else {
> +		util += util_cfs;
> +	}

Or the combined thing:

-       util = util_cfs;
-       util += cpu_util_rt(rq);
+       util = cpu_util_rt(rq);
+       if (type == FREQUENCY_UTIL) {
+               util += cpu_util_cfs(rq);
+               util  = uclamp_util(rq, util);
+       } else {
+               util += util_cfs;
+       }


Leaves me confused.

When type == FREQ, util_cfs should already be cpu_util_cfs(), per
sugov_get_util().

So should that not end up like:

	util = util_cfs;
	util += cpu_util_rt(rq);
+	if (type == FREQUENCY_UTIL)
+		util = uclamp_util(rq, util);

instead?
