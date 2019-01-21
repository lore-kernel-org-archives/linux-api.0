From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Mon, 21 Jan 2019 16:17:17 +0100
Message-ID: <20190121151717.GK27931@hirez.programming.kicks-ass.net>
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
> +#ifdef CONFIG_UCLAMP_TASK

> +struct uclamp_bucket {
> +	unsigned long value : bits_per(SCHED_CAPACITY_SCALE);
> +	unsigned long tasks : BITS_PER_LONG - bits_per(SCHED_CAPACITY_SCALE);
> +};

> +struct uclamp_cpu {
> +	unsigned int value;

	/* 4 byte hole */

> +	struct uclamp_bucket bucket[UCLAMP_BUCKETS];
> +};

With the default of 5, this UCLAMP_BUCKETS := 6, so struct uclamp_cpu
ends up being 7 'unsigned long's, or 56 bytes on 64bit (with a 4 byte
hole).

> +#endif /* CONFIG_UCLAMP_TASK */
> +
>  /*
>   * This is the main, per-CPU runqueue data structure.
>   *
> @@ -835,6 +879,11 @@ struct rq {
>  	unsigned long		nr_load_updates;
>  	u64			nr_switches;
>  
> +#ifdef CONFIG_UCLAMP_TASK
> +	/* Utilization clamp values based on CPU's RUNNABLE tasks */
> +	struct uclamp_cpu	uclamp[UCLAMP_CNT] ____cacheline_aligned;

Which makes this 112 bytes with 8 bytes in 2 holes, which is short of 2
64 byte cachelines.

Is that the best layout?

> +#endif
> +
>  	struct cfs_rq		cfs;
>  	struct rt_rq		rt;
>  	struct dl_rq		dl;
> -- 
> 2.19.2
> 
