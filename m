From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 03/16] sched/core: uclamp: Map TASK's clamp values
 into CPU's clamp buckets
Date: Mon, 21 Jan 2019 11:15:08 +0100
Message-ID: <20190121101508.GH27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-4-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-4-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:00AM +0000, Patrick Bellasi wrote:
> +/*
> + * Number of utilization clamp buckets.
> + *
> + * The first clamp bucket (bucket_id=0) is used to track non clamped tasks, i.e.
> + * util_{min,max} (0,SCHED_CAPACITY_SCALE). Thus we allocate one more bucket in
> + * addition to the compile time configured number.
> + */
> +#define UCLAMP_BUCKETS (CONFIG_UCLAMP_BUCKETS_COUNT + 1)
> +
> +/*
> + * Utilization clamp bucket
> + * @value:		clamp value tracked by a clamp bucket
> + * @bucket_id:		the bucket index used by the fast-path
> + * @mapped:		the bucket index is valid
> + *
> + * A utilization clamp bucket maps a:
> + *   clamp value (value), i.e.
> + *   util_{min,max} value requested from userspace
> + * to a:
> + *   clamp bucket index (bucket_id), i.e.
> + *   index of the per-cpu RUNNABLE tasks refcounting array
> + *
> + * The mapped bit is set whenever a task has been mapped on a clamp bucket for
> + * the first time. When this bit is set, any:
> + *   uclamp_bucket_inc() - for a new clamp value
> + * is matched by a:
> + *   uclamp_bucket_dec() - for the old clamp value
> + */
> +struct uclamp_se {
> +	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
> +	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
> +	unsigned int mapped		: 1;
> +};

Do we want something like:

	BUILD_BUG_ON(sizeof(struct uclamp_se) == sizeof(unsigned int));

And/or put a limit on CONFIG_UCLAMP_BUCKETS_COUNT that guarantees that ?
