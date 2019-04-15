From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 02/16] sched/core: Add bucket local max tracking
Date: Mon, 15 Apr 2019 15:51:07 +0100
Message-ID: <20190415144930.pntid6evu6r67l4o@e110439-lin>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-3-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402104153.25404-3-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 02-Apr 11:41, Patrick Bellasi wrote:
> Because of bucketization, different task-specific clamp values are
> tracked in the same bucket.  For example, with 20% bucket size and
> assuming to have:
>   Task1: util_min=25%
>   Task2: util_min=35%
> both tasks will be refcounted in the [20..39]% bucket and always boosted
> only up to 20% thus implementing a simple floor aggregation normally
> used in histograms.
> 
> In systems with only few and well-defined clamp values, it would be
> useful to track the exact clamp value required by a task whenever
> possible. For example, if a system requires only 23% and 47% boost
> values then it's possible to track the exact boost required by each
> task using only 3 buckets of ~33% size each.
> 
> Introduce a mechanism to max aggregate the requested clamp values of
> RUNNABLE tasks in the same bucket. Keep it simple by resetting the
> bucket value to its base value only when a bucket becomes inactive.
> Allow a limited and controlled overboosting margin for tasks recounted
> in the same bucket.
> 
> In systems where the boost values are not known in advance, it is still
> possible to control the maximum acceptable overboosting margin by tuning
> the number of clamp groups. For example, 20 groups ensure a 5% maximum
> overboost.
> 
> Remove the rq bucket initialization code since a correct bucket value
> is now computed when a task is refcounted into a CPU's rq.
> 
> Signed-off-by: Patrick Bellasi <patrick.bellasi@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> 
> --
> Changes in v8:
>  Message-ID: <20190313193916.GQ2482@worktop.programming.kicks-ass.net>
>  - split this code out from the previous patch
> ---
>  kernel/sched/core.c | 46 ++++++++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 032211b72110..6e1beae5f348 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -778,6 +778,11 @@ unsigned int uclamp_rq_max_value(struct rq *rq, unsigned int clamp_id)
>   * When a task is enqueued on a rq, the clamp bucket currently defined by the
>   * task's uclamp::bucket_id is refcounted on that rq. This also immediately
>   * updates the rq's clamp value if required.
> + *
> + * Tasks can have a task-specific value requested from user-space, track
> + * within each bucket the maximum value for tasks refcounted in it.
> + * This "local max aggregation" allows to track the exact "requested" value
> + * for each bucket when all its RUNNABLE tasks require the same clamp.
>   */
>  static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
>  				    unsigned int clamp_id)
> @@ -789,8 +794,15 @@ static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
>  	bucket = &uc_rq->bucket[uc_se->bucket_id];
>  	bucket->tasks++;
>  
> +	/*
> +	 * Local max aggregation: rq buckets always track the max
> +	 * "requested" clamp value of its RUNNABLE tasks.
> +	 */
> +	if (uc_se->value > bucket->value)
> +		bucket->value = uc_se->value;
> +
>  	if (uc_se->value > READ_ONCE(uc_rq->value))
> -		WRITE_ONCE(uc_rq->value, bucket->value);
> +		WRITE_ONCE(uc_rq->value, uc_se->value);
>  }
>  
>  /*
> @@ -815,6 +827,12 @@ static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
>  	if (likely(bucket->tasks))
>  		bucket->tasks--;
>  
> +	/*
> +	 * Keep "local max aggregation" simple and accept to (possibly)
> +	 * overboost some RUNNABLE tasks in the same bucket.
> +	 * The rq clamp bucket value is reset to its base value whenever
> +	 * there are no more RUNNABLE tasks refcounting it.
> +	 */
>  	if (likely(bucket->tasks))
>  		return;
>  
> @@ -824,8 +842,14 @@ static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
>  	 * e.g. due to future modification, warn and fixup the expected value.
>  	 */
>  	SCHED_WARN_ON(bucket->value > rq_clamp);
> -	if (bucket->value >= rq_clamp)
> +	if (bucket->value >= rq_clamp) {
> +		/*
> +		 * Reset clamp bucket value to its nominal value whenever
> +		 * there are anymore RUNNABLE tasks refcounting it.
> +		 */
> +		bucket->value = uclamp_bucket_base_value(bucket->value);

While running tests on Android, I found that the snipped above should
be better done in uclamp_rq_inc_id() for two main reasons:
 1. because of the early return in this function, we skip the reset in
    case the task is not the last one running on a CPU, thus
    triggering the above SCHED_WARN_ON
 2. since a non active bucket is already ignored, we don't care about
    resetting its "local max value"

Will move the "max local update" in uclamp_rq_inc_id() where something
like:


    /*
     * Local max aggregation: rq buckets always track the max
     * "requested" clamp value of its RUNNABLE tasks.
     */
    if (bucket->tasks == 1 || uc_se->value > bucket->value)
    	bucket->value = uc_se->value;


Should grant to always have an updated local max every time a bucket
is active.


>  		WRITE_ONCE(uc_rq->value, uclamp_rq_max_value(rq, clamp_id));
> +	}
>  }
>  
>  static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p)
> @@ -855,25 +879,9 @@ static void __init init_uclamp(void)
>  	unsigned int clamp_id;
>  	int cpu;
>  
> -	for_each_possible_cpu(cpu) {
> -		struct uclamp_bucket *bucket;
> -		struct uclamp_rq *uc_rq;
> -		unsigned int bucket_id;
> -
> +	for_each_possible_cpu(cpu)
>  		memset(&cpu_rq(cpu)->uclamp, 0, sizeof(struct uclamp_rq));
>  
> -		for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
> -			uc_rq = &cpu_rq(cpu)->uclamp[clamp_id];
> -
> -			bucket_id = 1;
> -			while (bucket_id < UCLAMP_BUCKETS) {
> -				bucket = &uc_rq->bucket[bucket_id];
> -				bucket->value = bucket_id * UCLAMP_BUCKET_DELTA;
> -				++bucket_id;
> -			}
> -		}
> -	}
> -
>  	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
>  		struct uclamp_se *uc_se = &init_task.uclamp[clamp_id];
>  
> -- 
> 2.20.1
> 

-- 
#include <best/regards.h>

Patrick Bellasi
