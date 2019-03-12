From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Tue, 12 Mar 2019 13:52:49 +0100
Message-ID: <21171fa0-7fd5-ebbf-dd48-d6668ed563af@arm.com>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208100554.32196-2-patrick.bellasi@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 2/8/19 11:05 AM, Patrick Bellasi wrote:

[...]

> +config UCLAMP_BUCKETS_COUNT
> +	int "Number of supported utilization clamp buckets"
> +	range 5 20
> +	default 5
> +	depends on UCLAMP_TASK
> +	help
> +	  Defines the number of clamp buckets to use. The range of each bucket
> +	  will be SCHED_CAPACITY_SCALE/UCLAMP_BUCKETS_COUNT. The higher the
> +	  number of clamp buckets the finer their granularity and the higher
> +	  the precision of clamping aggregation and tracking at run-time.
> +
> +	  For example, with the default configuration we will have 5 clamp
> +	  buckets tracking 20% utilization each. A 25% boosted tasks will be
> +	  refcounted in the [20..39]% bucket and will set the bucket clamp
> +	  effective value to 25%.
> +	  If a second 30% boosted task should be co-scheduled on the same CPU,
> +	  that task will be refcounted in the same bucket of the first task and
> +	  it will boost the bucket clamp effective value to 30%.
> +	  The clamp effective value of a bucket is reset to its nominal value
> +	  (20% in the example above) when there are anymore tasks refcounted in

this sounds weird.

[...]

> +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> +{
> +	return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> +}

Soemthing like uclamp_bucket_nominal_value() should be clearer.

> +static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id)
> +{
> +	struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
> +	unsigned int max_value = uclamp_none(clamp_id);
> +	unsigned int bucket_id;

unsigned int bucket_id = UCLAMP_BUCKETS;

> +
> +	/*
> +	 * Both min and max clamps are MAX aggregated, thus the topmost
> +	 * bucket with some tasks defines the rq's clamp value.
> +	 */
> +	bucket_id = UCLAMP_BUCKETS;

to get rid of this line?

> +	do {
> +		--bucket_id;
> +		if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)

if (!bucket[bucket_id].tasks)

[...]

> +/*
> + * When a task is enqueued on a rq, the clamp bucket currently defined by the
> + * task's uclamp::bucket_id is reference counted on that rq. This also
> + * immediately updates the rq's clamp value if required.
> + *
> + * Since tasks know their specific value requested from user-space, we track
> + * within each bucket the maximum value for tasks refcounted in that bucket.
> + * This provide a further aggregation (local clamping) which allows to track

s/This provide/This provides

> + * within each bucket the exact "requested" clamp value whenever all tasks
> + * RUNNABLE in that bucket require the same clamp.
> + */
> +static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
> +				    unsigned int clamp_id)
> +{
> +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> +	unsigned int rq_clamp, bkt_clamp, tsk_clamp;

Wouldn't it be easier to have a pointer to the task's and rq's uclamp 
structure as well to the bucket?

-       unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
+       struct uclamp_se *uc_se = &p->uclamp[clamp_id];
+       struct uclamp_rq *uc_rq = &rq->uclamp[clamp_id];
+       struct uclamp_bucket *bucket = &uc_rq->bucket[uc_se->bucket_id];

The code in uclamp_rq_inc_id() and uclamp_rq_dec_id() for example 
becomes much more readable.

[...]

>   struct sched_class {
>   	const struct sched_class *next;
>   
> +#ifdef CONFIG_UCLAMP_TASK
> +	int uclamp_enabled;
> +#endif
> +
>   	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
>   	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
> -	void (*yield_task)   (struct rq *rq);
> -	bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
>   
>   	void (*check_preempt_curr)(struct rq *rq, struct task_struct *p, int flags);
>   
> @@ -1685,7 +1734,6 @@ struct sched_class {
>   	void (*set_curr_task)(struct rq *rq);
>   	void (*task_tick)(struct rq *rq, struct task_struct *p, int queued);
>   	void (*task_fork)(struct task_struct *p);
> -	void (*task_dead)(struct task_struct *p);
>   
>   	/*
>   	 * The switched_from() call is allowed to drop rq->lock, therefore we
> @@ -1702,12 +1750,17 @@ struct sched_class {
>   
>   	void (*update_curr)(struct rq *rq);
>   
> +	void (*yield_task)   (struct rq *rq);
> +	bool (*yield_to_task)(struct rq *rq, struct task_struct *p, bool preempt);
> +
>   #define TASK_SET_GROUP		0
>   #define TASK_MOVE_GROUP		1
>   
>   #ifdef CONFIG_FAIR_GROUP_SCHED
>   	void (*task_change_group)(struct task_struct *p, int type);
>   #endif
> +
> +	void (*task_dead)(struct task_struct *p);

Why do you move yield_task, yield_to_task and task_dead here?

[...]
