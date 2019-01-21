From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Mon, 21 Jan 2019 15:59:29 +0100
Message-ID: <20190121145929.GI27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-5-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-5-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:01AM +0000, Patrick Bellasi wrote:
> @@ -835,6 +954,28 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
>  	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
>  					  &uc_map_old.data, uc_map_new.data));
>  
> +	/*
> +	 * Ensure each CPU tracks the correct value for this clamp bucket.
> +	 * This initialization of per-CPU variables is required only when a
> +	 * clamp value is requested for the first time from a slow-path.
> +	 */

I'm confused; why is this needed?

> +	if (unlikely(!uc_map_old.se_count)) {
> +		for_each_possible_cpu(cpu) {
> +			struct uclamp_cpu *uc_cpu =
> +				&cpu_rq(cpu)->uclamp[clamp_id];
> +
> +			/* CPU's tasks count must be 0 for free buckets */
> +			SCHED_WARN_ON(uc_cpu->bucket[bucket_id].tasks);
> +			if (unlikely(uc_cpu->bucket[bucket_id].tasks))
> +				uc_cpu->bucket[bucket_id].tasks = 0;
> +
> +			/* Minimize cache lines invalidation */
> +			if (uc_cpu->bucket[bucket_id].value == bucket_value)
> +				continue;
> +			uc_cpu->bucket[bucket_id].value = bucket_value;
> +		}
> +	}
> +
>  	uc_se->value = clamp_value;
>  	uc_se->bucket_id = bucket_id;
>  
